{ pkgs }:
rec {
  yosys = pkgs.callPackage ./yosys.nix {};
  symbiyosys = pkgs.symbiyosys.override { inherit yosys; };
  nmigen = pkgs.callPackage ./nmigen.nix { inherit yosys; };
  jtagtap = pkgs.callPackage ./jtagtap.nix { inherit nmigen; };
  minerva = pkgs.callPackage ./minerva.nix { inherit nmigen; inherit jtagtap; };
  heavycomps = pkgs.callPackage ./heavycomps.nix { inherit nmigen; };
}
