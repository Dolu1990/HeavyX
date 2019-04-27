{ runCommand, fetchFromGitHub, makeWrapper, scala-spinalhdl, name, scalaToRun }:
let
  vexriscv-src = fetchFromGitHub {
    rev = "fa13e46e873c3ec35e5c7c07c320259eda6ef789";
    owner = "SpinalHDL";
    repo = "VexRiscv";
    sha256 = "146m8m00zf7sqhfqg2aybv0m9if3q9asbji0ff0sf4aq652b5b4y";
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
