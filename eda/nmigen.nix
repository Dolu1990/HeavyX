{ stdenv, fetchFromGitHub, python3Packages, yosys, symbiyosys, yices }:

python3Packages.buildPythonPackage {
  name = "nmigen";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "aed2062101afe14336cfca36cc22cb6f585c3795";
    sha256 = "0hyxn41xz4y84xxvvj8nccn86b7ad8n7l1m0dz2dvxnyrhq5knnw";
  };

  checkPhase = "PATH=${yosys}/bin:${symbiyosys}/bin:${yices}/bin:$PATH python -m unittest discover nmigen.test -v";

  propagatedBuildInputs = [ python3Packages.bitarray python3Packages.pyvcd ];

  meta = with stdenv.lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage    = "https://lambdaconcept.com";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
