{ pkgs }:
rec {
  yosys = pkgs.callPackage ./eda/yosys.nix {};
  symbiyosys = pkgs.symbiyosys.override { inherit yosys; };
  nmigen = pkgs.callPackage ./eda/nmigen.nix { inherit yosys; };

  jtagtap = pkgs.callPackage ./cores/jtagtap.nix { inherit nmigen; };
  minerva = pkgs.callPackage ./cores/minerva.nix { inherit nmigen; inherit jtagtap; };

  heavycomps = pkgs.callPackage ./heavycomps.nix { inherit nmigen; };

  binutils-riscv = pkgs.callPackage ./compilers/binutils.nix { platform = "riscv32"; };
  binutils-or1k = pkgs.callPackage ./compilers/binutils.nix { platform = "or1k"; };
  llvm-hx = pkgs.callPackage ./compilers/llvm-hx.nix {};
}
