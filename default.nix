{ pkgs }:
(import ./derivations.nix { inherit pkgs; }) // {
  vivado = import ./eda/vivado.nix { inherit pkgs; };
}
