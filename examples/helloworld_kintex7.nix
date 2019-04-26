{ pkgs ? import <nixpkgs> {}
, hx ? import ../default.nix { inherit pkgs; }}:

let
  vivadoInput = pkgs.runCommand "helloworld-vivado-input" {
      buildInputs = [ (pkgs.python3.withPackages(ps: [hx.nmigen hx.heavycomps])) hx.yosys ];
    }
    ''
    mkdir $out

    python ${./helloworld_kintex7.py} > $out/top.v

    cat > $out/top.xdc << EOF
    set_property LOC K24 [get_ports serial_tx]
    set_property IOSTANDARD LVCMOS25 [get_ports serial_tx]
    
    set_property LOC K28 [get_ports clk156_p]
    set_property IOSTANDARD LVDS_25 [get_ports clk156_p]
    set_property DIFF_TERM TRUE [get_ports clk156_p]

    set_property LOC K29 [get_ports clk156_n]
    set_property IOSTANDARD LVDS_25 [get_ports clk156_n]
    set_property DIFF_TERM TRUE [get_ports clk156_n]

    create_clock -name clk156 -period 6.4 [get_nets clk156_p]
    EOF

    cat > $out/top.tcl << EOF
    create_project -force -name top -part xc7k325t-ffg900-2
    set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
    add_files {top.v}
    set_property library work [get_files {top.v}]
    read_xdc top.xdc
    synth_design -top top -part xc7k325t-ffg900-2
    opt_design
    place_design
    route_design
    set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
    set_property BITSTREAM.GENERAL.COMPRESS True [current_design]
    write_bitstream -force top.bit
    quit
    EOF
    '';
in
  hx.vivado.buildBitstream {
    name = "helloworld-bitstream";
    src = vivadoInput;
  }
