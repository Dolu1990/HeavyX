{ stdenv, fetchFromGitHub, python3Packages, yosys, symbiyosys, yices }:

python3Packages.buildPythonPackage {
  name = "nmigen";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "d69a4e29a8e2492dc916d0c7e42d9337c8c6d4c5";
    sha256 = "04jndrml6zm9g0p61kd05kzviy0m0yf919c7g2hgdl9n2ja1aw4p";
  };

  checkPhase = "PATH=${yosys}/bin:${symbiyosys}/bin:${yices}/bin:$PATH python -m unittest discover nmigen.test";

  propagatedBuildInputs = [ python3Packages.bitarray python3Packages.pyvcd ];

  meta = with stdenv.lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage    = "https://lambdaconcept.com";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
