{ stdenv, rustc }:
stdenv.mkDerivation {
  name = "rust-riscv32i-crates";
  src = rustc.src;
  phases = [ "unpackPhase" "buildPhase" ];
  buildPhase = ''
    destdir=$out/lib/rustlib/riscv32imac-unknown-none-elf/lib/
    rustc="${rustc}/bin/rustc --out-dir ''${destdir} -L ''${destdir} --target riscv32i-unknown-none-elf -g -C opt-level=s --crate-type rlib"

    mkdir -p ''${destdir}
    export RUSTC_BOOTSTRAP=1
    ''${rustc} --crate-name core src/libcore/lib.rs
    ''${rustc} --crate-name compiler_builtins src/libcompiler_builtins/src/lib.rs --cfg 'feature="compiler-builtins"' --cfg 'feature="mem"'
    ''${rustc} --crate-name alloc src/liballoc/lib.rs
  '';
  #  ''${rustc} --crate-name libc ${./libc_mini.rs}
  #  ''${rustc} --crate-name unwind src/libunwind/lib.rs
  #  ''${rustc} --crate-name std src/libstd/lib.rs
  #  ''${rustc} -Cpanic=abort --crate-name panic_abort src/libpanic_abort/lib.rs
  #  ''${rustc} -Cpanic=unwind --crate-name panic_unwind src/libpanic_unwind/lib.rs --cfg llvm_libunwind
}
