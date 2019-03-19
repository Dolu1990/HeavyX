{ stdenv, python3Packages, nmigen }:

python3Packages.buildPythonPackage {
  name = "heavycomps";

  src = ./heavycomps;

  propagatedBuildInputs = [ nmigen ];

  meta = with stdenv.lib; {
    description = "Components for the HeavyX SoC toolkit";
    homepage    = "https://m-labs.hk/migen";
    license     = licenses.bsd2;
    maintainers = [ maintainers.sb0 ];
  };
}
