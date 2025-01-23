{
  description = "Bun and flakes example package";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import (nixpkgs) { inherit system; });

        helloBun = pkgs.stdenv.mkDerivation {
          pname = "hello-bun";
          version = "1.0.0";
          src = ./.;
          dontFixup = true;
          buildInputs = [ pkgs.bun ];
          buildPhase = ''
            bun build --compile hello.ts --outfile hello-bun
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello-bun $out/bin/
          '';
        };

      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
        };

        # Define the default app to run the binary
        apps.default = {
          type = "app";
          program = "${helloBun}/bin/hello-bun";
        };
      }
    );
}
