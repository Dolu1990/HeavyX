# Install Vivado in /opt and add to /etc/nixos/configuration.nix:
#  nix.sandboxPaths = ["/opt"];

{ pkgs }:
let
  vivadoEnv = pkgs.buildFHSUserEnv {
    name = "vivado-env";
    targetPkgs = pkgs: (
      with pkgs; [
        ncurses5
        zlib
        libuuid
        xorg.libSM
        xorg.libICE
        xorg.libXrender
        xorg.libX11
        xorg.libXext
        xorg.libXtst
        xorg.libXi
      ]
    );
  };
in
  {
    buildBitstream = { name, src, vivadoPath ? "/opt/Xilinx/Vivado/2018.3" }:
      pkgs.stdenv.mkDerivation {
        inherit name src;
        phases = [ "buildPhase" ];
        buildPhase =
          ''
          cp --no-preserve=mode,ownership -R $src/* .
          ${vivadoEnv}/bin/vivado-env -c "source ${vivadoPath}/settings64.sh && vivado -mode batch -source top.tcl"
          mkdir $out
          cp *.dcp *.rpt *.bit $out
          '';
      };
  }
