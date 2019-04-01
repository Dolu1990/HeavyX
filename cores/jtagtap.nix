{ stdenv, fetchFromGitHub, python3Packages, nmigen }:

python3Packages.buildPythonPackage {
  name = "jtagtap";

  src = fetchFromGitHub {
    owner = "lambdaconcept";
    repo = "jtagtap";
    rev = "cac2d0156d2b6495a94f11171a1cf143b33c8e5e";
    sha256 = "05l4asx61zrg6c13irwm4a4k6gyk4r3isfrfidsqnh4g6739bdmg";
  };

  propagatedBuildInputs = [ nmigen ];

  meta = with stdenv.lib; {
    description = "A 32-bit RISC-V soft processor";
    homepage    = "https://m-labs.hk/migen";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
