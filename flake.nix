{
  description = "ectool with support for the Framework Laptop 13 AMD Ryzen 7040 Series";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };

    ectoolSrc = pkgs.fetchgit {
      url = "https://gitlab.howett.net/DHowett/ectool.git";
      rev = "3ebe7b8b713b2ebfe2ce92d48fd8d044276b2879";
      sha256 = "sha256-soif8LrN4ceeUcesw5bB1BpuZw9lfwwQgQQefht5D4A=";
    };

    ectool = pkgs.stdenv.mkDerivation {
      name = "ectool";
      src = ectoolSrc;

      buildInputs = with pkgs; [
        clang
        cmake
        git
        libftdi1
        libusb1
        ninja
        pkg-config
      ];

      buildPhase = ''
        mkdir -p $TMPDIR/build
        cd $TMPDIR/build
        CC=clang CXX=clang++ cmake -GNinja $src
        cmake --build .
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp $TMPDIR/build/src/ectool $out/bin/
      '';
    };

  in {
    packages.${system}.ectool = ectool;
    defaultPackage.${system} = ectool;
  };
}
