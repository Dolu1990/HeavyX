{ stdenv
, fetchurl, runCommand
, perl, groff, cmake, libxml2, python, libffi, valgrind
, ...
}:

let
  llvm-src = fetchurl {
    url = "https://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz";
    sha256 = "16s196wqzdw4pmri15hadzqgdi926zln3an2viwyq0kini6zr3d3";
  };
  clang-src = fetchurl {
    url = "https://releases.llvm.org/7.0.1/cfe-7.0.1.src.tar.xz";
    sha256 = "067lwggnbg0w1dfrps790r5l6k8n5zwhlsw7zb6zvmfpwpfn4nx4";
  };
  combined-src = runCommand "llvm-clang-src" {}
    ''
    mkdir -p $out
    mkdir -p $out/tools/clang
    tar xf ${llvm-src} -C $out --strip-components=1
    tar xf ${clang-src} -C $out/tools/clang --strip-components=1
    '';
in
  stdenv.mkDerivation rec {
    name = "llvm-hx";
    src = combined-src;

    buildInputs = [ perl groff cmake libxml2 python libffi ] ++ stdenv.lib.optional stdenv.isLinux valgrind;

    preBuild = ''
      NIX_BUILD_CORES=4
      makeFlagsArray=(-j''$NIX_BUILD_CORES)
      mkdir -p $out/
    '';

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_BUILD_LLVM_DYLIB=ON"
      "-DLLVM_LINK_LLVM_DYLIB=ON"
      "-DLLVM_TARGETS_TO_BUILD=X86"
      "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=RISCV"
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
