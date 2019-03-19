{ pkgs ? import <nixpkgs> {}}:
rec {
	nmigen = pkgs.callPackage ./nmigen.nix {};
	jtagtap = pkgs.callPackage ./jtagtap.nix { inherit nmigen; };
	minerva = pkgs.callPackage ./minerva.nix { inherit nmigen; inherit jtagtap; };
}
