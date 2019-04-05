{ runCommand, fetchFromGitHub, makeWrapper, scala-spinalhdl, name, scalaToRun }:
let
  vexriscv-src = fetchFromGitHub {
    rev = "d63c6818df8c7229ee9c2ffa83181748b930e1d9";
    owner = "SpinalHDL";
    repo = "VexRiscv";
    sha256 = "1q707icib7q7x9njm4f73g36jjs9q1cvfpv10w6a4jhswg63zyga";
  };
  vexriscv-compiled = runCommand "vexriscv-compiled" {}
    ''
    mkdir $out
    ${scala-spinalhdl}/bin/scalac-spinalhdl -d $out/VexRiscv.jar `find ${vexriscv-src}/src/main/scala -type f`
    '';
  scala-vexriscv = runCommand "scala-vexriscv" { nativeBuildInputs = [ makeWrapper ]; }
    ''
    mkdir -p $out/bin
    makeWrapper ${scala-spinalhdl}/bin/scala-spinalhdl $out/bin/scala-vexriscv --prefix CLASSPATH : ${vexriscv-compiled}/VexRiscv.jar
    '';
in
  runCommand name {}
    ''
    mkdir $out
    cd $out
    ${scala-vexriscv}/bin/scala-vexriscv ${scalaToRun}

    mkdir -p $out/nix-support
    echo file verilog $out/VexRiscv.v >> $out/nix-support/hydra-build-products
    ''
