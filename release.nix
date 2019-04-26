{ pkgs ? import <nixpkgs> {}}:
let
  derivations = import ./derivations.nix { inherit pkgs; };
  jobs = derivations // {
    helloworld_ecp5 = import ./examples/helloworld_ecp5.nix { inherit pkgs; };
    helloworld_kintex7 = import ./examples/helloworld_kintex7.nix { inherit pkgs; };
  };
in
  builtins.mapAttrs (name: value: pkgs.lib.hydraJob value) jobs
