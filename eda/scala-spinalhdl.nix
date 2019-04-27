{ runCommand, fetchurl, makeWrapper, scala_2_11 }:

let
  jars = [
    (fetchurl {
      url = http://central.maven.org/maven2/commons-io/commons-io/2.4/commons-io-2.4.jar;
      sha256 = "108mw2v8ncig29kjvzh8wi76plr01f4x5l3b1929xk5a7vf42snc";
    })
    (fetchurl {
      url = http://central.maven.org/maven2/org/yaml/snakeyaml/1.8/snakeyaml-1.8.jar;
      sha256 = "1z0ybg8azqanrhqjbr57n6sflm7scfxik99j070f9zk7g6ykcl9g";
    })
    (fetchurl {
      url = https://oss.sonatype.org/content/groups/public/com/github/scopt/scopt_2.11/3.4.0/scopt_2.11-3.4.0.jar;
      sha256 = "0y9av2rpnaj3z9zg4chfpxgjx3xqqx9bzcv0jr3n9h4v5fqbc52r";
    })
    (fetchurl {
      url = https://oss.sonatype.org/content/groups/public/com/github/spinalhdl/spinalhdl-core_2.11/1.3.3/spinalhdl-core_2.11-1.3.3.jar;
      sha256 = "1zrs5wahgvc12zsycrhwsqw4gghjj0yf3wcywra0c9yjydahsgwq";
    })
    (fetchurl {
      url = https://oss.sonatype.org/content/groups/public/com/github/spinalhdl/spinalhdl-lib_2.11/1.3.3/spinalhdl-lib_2.11-1.3.3.jar;
      sha256 = "1s9hyyrf2iph4dhfb0nsi2s5hdxhqwpyzjnsvhm5bnsysqa1f3lc";
    })
    (fetchurl {
      url = https://oss.sonatype.org/content/groups/public/com/github/spinalhdl/spinalhdl-sim_2.11/1.3.3/spinalhdl-sim_2.11-1.3.3.jar;
      sha256 = "0wqwy5g241c7sjxb5p5wff77wdql5v987j23451is9v6qv76i3v6";
    })
  ];
  fmtJars = builtins.concatStringsSep ":" (builtins.map (x: "${x}") jars);
in
  runCommand "scala-spinalhdl" { nativeBuildInputs = [ makeWrapper ]; }
    ''
    mkdir -p $out/bin
    makeWrapper ${scala_2_11}/bin/scala $out/bin/scala-spinalhdl --prefix CLASSPATH : ${fmtJars}
    makeWrapper ${scala_2_11}/bin/scalac $out/bin/scalac-spinalhdl --prefix CLASSPATH : ${fmtJars}
    ''
