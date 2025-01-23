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
        pname = "hello-bun";

        hello-bun = pkgs.stdenv.mkDerivation rec {
          inherit pname;
          version = "1.0.0";
          src = ./.;
          dontFixup = true;
          buildInputs = [ pkgs.bun ];
          buildPhase = ''
            bun build --compile hello-bun.ts --outfile ${pname}
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp ${pname} $out/bin/
          '';
        };

      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
        };

        packages.default = hello-bun;

        # Define the default app to run the binary
        apps.default = {
          type = "app";
          program = "${hello-bun}/bin/hello-bun";
        };
      }
    );
}
