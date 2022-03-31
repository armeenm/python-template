{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    utils.url = github:numtide/flake-utils;
  };

  outputs = inputs@{ self, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs.nix = inputs.nixpkgs.legacyPackages.${system};
        stdenv = pkgs.nix.stdenvNoCC;
        mkShell = pkgs.nix.mkShell.override { inherit stdenv; };

        python3 = pkgs.nix.python3;
      in {
        devShell = mkShell {
          packages = [
            python3
          ] ++ (with pkgs.nix; [
          ]);

          shellHook = ''
            export PIP_PREFIX="$PWD/_build/pip_packages"
            export PYTHONPATH="$PIP_PREFIX/${python3.sitePackages}:$PYTHONPATH"
            export PATH="$PIP_PREFIX/bin:$PATH"
            unset SOURCE_DATE_EPOCH
          '';
        };
      }
  );
}
