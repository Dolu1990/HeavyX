{ pkgs ? import <nixpkgs> {}
, hx ? import ../default.nix { inherit pkgs; }}:

let
  symbiflowInput = pkgs.runCommand "helloworld-symbiflow-input" {
      buildInputs = [ (pkgs.python3.withPackages(ps: [hx.nmigen hx.heavycomps])) hx.yosys ];
    }
    ''
    mkdir $out

    python ${./helloworld_ecp5.py} > $out/top.il

    cat > $out/top.lpf << EOF
    LOCATE COMP "serial_tx" SITE "A4";
    IOBUF PORT "P3" IO_TYPE=LVDS;
    LOCATE COMP "tx" SITE "B19";
    IOBUF PORT "C11" IO_TYPE=LVCMOS33;
    EOF

    echo -n "--um-45k --package CABGA381" > $out/device
    '';
in
  hx.symbiflow.buildBitstream {
    name = "helloworld-bitstream";
    src = symbiflowInput;
  }
