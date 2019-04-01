{ stdenv
, git
, callPackage
, perl, groff, cmake, libxml2, python, libffi, valgrind
, ...
}:

let
  llvm-src = callPackage ./fetch-llvm-clang.nix {};
in
  stdenv.mkDerivation rec {
    name = "llvm-hx";
    src = llvm-src;

    buildInputs = [ perl groff cmake libxml2 python libffi ] ++ stdenv.lib.optional stdenv.isLinux valgrind;

    preBuild = ''
      NIX_BUILD_CORES=4
      makeFlagsArray=(-j''$NIX_BUILD_CORES)
      mkdir -p $out/
    '';

    cmakeFlags = with stdenv; [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_BUILD_LLVM_DYLIB=ON"
      "-DLLVM_LINK_LLVM_DYLIB=ON"
      "-DLLVM_TARGETS_TO_BUILD=X86"
      "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=RISCV;OR1K"
      "-DLLVM_ENABLE_ASSERTIONS=OFF"
      "-DLLVM_INSTALL_UTILS=ON"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_INCLUDE_DOCS=OFF"
      "-DLLVM_INCLUDE_EXAMPLES=OFF"
      "-DCLANG_ENABLE_ARCMT=OFF"
      "-DCLANG_ENABLE_STATIC_ANALYZER=OFF"
      "-DCLANG_INCLUDE_TESTS=OFF"
      "-DCLANG_INCLUDE_DOCS=OFF"
    ];

    enableParallelBuilding = true;
    meta = {
      description = "Collection of modular and reusable compiler and toolchain technologies";
      homepage = http://llvm.org/;
      license = stdenv.lib.licenses.bsd3;
      maintainers = with stdenv.lib.maintainers; [ sb0 ];
      platforms = stdenv.lib.platforms.all;
    };
  }
