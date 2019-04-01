{ stdenv, fetchFromGitHub, python3Packages, nmigen, jtagtap }:

python3Packages.buildPythonPackage {
  name = "minerva";

  src = fetchFromGitHub {
    owner = "lambdaconcept";
    repo = "minerva";
    rev = "2b94dd6be54a0d4542ef320405dfa8a15e8fac93";
    sha256 = "0w073nqvjh1vplmw463sz90ykfpz1mkmfmmglnqwhvp90p9ryhnr";
  };

  propagatedBuildInputs = [ nmigen jtagtap ];

  meta = with stdenv.lib; {
    description = "A 32-bit RISC-V soft processor";
    homepage    = "https://m-labs.hk/migen";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
