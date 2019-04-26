{ pkgs }:
let
  hx = import ./derivations.nix { inherit pkgs; };
in
  hx // {
    symbiflow = import ./eda/symbiflow.nix { inherit pkgs; yosys = hx.yosys; };
    vivado = import ./eda/vivado.nix { inherit pkgs; };
  }
