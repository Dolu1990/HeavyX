{ stdenv, fetchFromGitHub, python3Packages, yosys, symbiyosys, yices }:

python3Packages.buildPythonPackage {
  name = "nmigen";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "287a0531b325c752a94d12ce6169a1de66c9569a";
    sha256 = "17s9771f1swb9aajmddmpcslwzla5y17gzjzlzwk5kmgywxydq3v";
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
