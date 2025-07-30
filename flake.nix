{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    system = "aarch64-darwin";
  in{
    packages.${system} = {
      test = pkgs.stdenv.mkDerivation {
        pname = "test";
        version = "1.0";

        src = ./.;  # No source code, just a simple derivation

        buildPhase = ''
          echo "Building the package..."
        '';

        installPhase = ''
          mkdir -p $out/share/plymouth/themes/test
          cp -r $src/* $out/share/plymouth/themes/test
          find $out/share/plymouth/themes/test -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \; # Adjust paths to point to the nix derivation
        '';
      };
      default = self.packages.${system}.test;
    };
  };
}
