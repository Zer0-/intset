{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bits-extras, bytestring, deepseq
      , stdenv, cabal-install, test-framework-quickcheck2, criterion, QuickCheck
      , test-framework, containers
      }:
      mkDerivation {
        pname = "intset";
        version = "0.1.1.0";
        sha256 = "044nw8z2ga46mal9pr64vsc714n4dibx0k2lwgnrkk49729c7lk0";
        libraryHaskellDepends = [
          base
          bits-extras
          bytestring
          deepseq
          cabal-install
        ];
        testHaskellDepends = [
          base QuickCheck test-framework test-framework-quickcheck2
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

  if pkgs.lib.inNixShell then drv.env else drv
