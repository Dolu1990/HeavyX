{ pkgs }:
rec {
  yosys = pkgs.callPackage ./eda/yosys.nix {};
  symbiyosys = pkgs.symbiyosys.override { inherit yosys; };
  nmigen = pkgs.callPackage ./eda/nmigen.nix { inherit yosys; };
  scala-spinalhdl = pkgs.callPackage ./eda/scala-spinalhdl.nix {};

  jtagtap = pkgs.callPackage ./cores/jtagtap.nix { inherit nmigen; };
  minerva = pkgs.callPackage ./cores/minerva.nix { inherit nmigen; inherit jtagtap; };
  vexriscv-small = pkgs.callPackage ./cores/vexriscv.nix {
    inherit scala-spinalhdl;
    name = "vexriscv-small";
    scalaToRun = "vexriscv.demo.GenSmallAndProductive";
  };

  heavycomps = pkgs.callPackage ./heavycomps.nix { inherit nmigen; };

  binutils-riscv = pkgs.callPackage ./compilers/binutils.nix { platform = "riscv32"; };
  binutils-or1k = pkgs.callPackage ./compilers/binutils.nix { platform = "or1k"; };
  llvm-hx = pkgs.callPackage ./compilers/llvm-hx.nix {};
}
