{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.32.0";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0ji2l9xv53y27xy72qagggvq47gayr5lcv2jwvmfirx029vlqnac";
  };
  # nixcloud team code
  riscv32imac-crates = stdenv.mkDerivation {
    name = "riscv32imac-crates";
    inherit src;
    phases = [ "unpackPhase" "buildPhase" ];
    buildPhase = ''
      destdir=$out
      rustc="${rustc_internal}/bin/rustc --out-dir ''${destdir} -L ''${destdir} --target riscv32imac-unknown-none-elf -g -C target-feature=+mul,+div,+ffl1,+cmov,+addc -C opt-level=s --crate-type rlib"
      
      mkdir -p ''${destdir}
      ''${rustc} --crate-name core src/libcore/lib.rs
      ''${rustc} --crate-name compiler_builtins src/libcompiler_builtins/src/lib.rs --cfg 'feature="compiler-builtins"' --cfg 'feature="mem"'
      ''${rustc} --crate-name std_unicode src/libstd_unicode/lib.rs
      ''${rustc} --crate-name alloc src/liballoc/lib.rs
      ''${rustc} --crate-name libc src/liblibc_mini/lib.rs
      ''${rustc} --crate-name unwind src/libunwind/lib.rs
      ''${rustc} -Cpanic=abort --crate-name panic_abort src/libpanic_abort/lib.rs
      ''${rustc} -Cpanic=unwind --crate-name panic_unwind src/libpanic_unwind/lib.rs --cfg llvm_libunwind
    '';
  };
  # nixcloud team code
  # originally rustc but now renamed to rustc_internal
  rustc_internal = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    patches = [
      ./patches/net-tcp-disable-tests.patch

      # Re-evaluate if this we need to disable this one
      #./patches/stdsimd-disable-doctest.patch
    ];

    # 1. Upstream is not running tests on aarch64:
    # see https://github.com/rust-lang/rust/issues/49807#issuecomment-380860567
    # So we do the same.
    # 2. Tests run out of memory for i686
    #doCheck = !stdenv.isAarch64 && !stdenv.isi686;

    # Disabled for now; see https://github.com/NixOS/nixpkgs/pull/42348#issuecomment-402115598.
    doCheck = false;
  };
in
 stdenv.mkDerivation {
    name = "rustc";
    src = ./.;
    installPhase = ''
      mkdir $out
      mkdir -p $out/lib/rustlib/riscv32imac-unknown-none-elf/lib/
      cp -r ${riscv32imac-crates}/* $out/lib/rustlib/riscv32imac-unknown-none-elf/lib/
      cp -r ${rustc_internal}/* $out
    '';
    meta = with stdenv.lib; {
      homepage = https://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ sb0 ];
      license = [ licenses.mit licenses.asl20 ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  }
