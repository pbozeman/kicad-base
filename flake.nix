{
  description = "kicad-base dev env (formatters and pre-commit hooks)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Lint/format toolchain for the pre-commit hooks (language: system).
        lintTools = with pkgs; [
          gitleaks
          nixfmt
          prettier
          pre-commit
          shellcheck
          shfmt
          yamlfmt
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.just
          ]
          ++ lintTools;
        };
      }
    );
}
