{ stdenv, fetchFromGitHub, python3Packages, nmigen, jtagtap }:

python3Packages.buildPythonPackage {
  name = "minerva";

  src = fetchFromGitHub {
    owner = "lambdaconcept";
    repo = "minerva";
    rev = "6e6800f0e39d166653c3e2a7b774977209cc078a";
    sha256 = "1107w83ipdhvxgrchlifvpqj0gk730ikpjh83h2ydqqbvpaj462m";
  };

  propagatedBuildInputs = [ nmigen jtagtap ];

  meta = with stdenv.lib; {
    description = "A 32-bit RISC-V soft processor";
    homepage    = "https://m-labs.hk/migen";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
