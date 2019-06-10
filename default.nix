{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, deepseq
      , stdenv, cabal-install, test-framework-quickcheck2, criterion, QuickCheck
      , test-framework, containers
      }:
      mkDerivation {
        pname = "intset";
        version = "0.1.1.0";
        src = ./.;
        libraryHaskellDepends = [
          base
          bytestring
          deepseq
        ];
        testHaskellDepends = [
          base QuickCheck test-framework test-framework-quickcheck2 cabal-install
        ];
        benchmarkHaskellDepends = [
          base bytestring containers criterion deepseq
        ];
        homepage = "https://github.com/pxqr/intset";
        description = "Pure, mergeable, succinct Int sets";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in
  drv
  #if pkgs.lib.inNixShell then drv.env else drv
