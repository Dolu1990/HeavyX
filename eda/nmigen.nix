{ stdenv, fetchFromGitHub, python3Packages, yosys, symbiyosys, yices }:

python3Packages.buildPythonPackage {
  name = "nmigen";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "6a77122c2ed422ac7e7e96d9d4ba58c6b37fa8bc";
    sha256 = "1gd249pj9c0kskwfdl1idhv6gx74lr9s3ycn66vy0hyhns5df0zq";
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
