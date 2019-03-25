{ pkgs ? import <nixpkgs> {}}:
let
  derivations = import ./derivations.nix { inherit pkgs; };
in
  builtins.mapAttrs (name: value: pkgs.lib.hydraJob value) derivations
