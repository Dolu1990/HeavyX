{ pkgs, yosys }:
{
  buildBitstream = { name, src }:
    pkgs.stdenv.mkDerivation {
      inherit name src;
      phases = [ "buildPhase" ];
      buildPhase =
        ''
        mkdir $out
        ${yosys}/bin/yosys -p "read_ilang $src/top.il; synth_ecp5 -top top -json $out/top.json"
        ${pkgs.nextpnr}/bin/nextpnr-ecp5 --json $out/top.json --textcfg $out/top.config `cat $src/device` --lpf $src/top.lpf
        ${pkgs.trellis}/bin/ecppack --svf-rowsize 100000 --svf $out/top.svf $out/top.config $out/top.bit
        '';
	  };
}
