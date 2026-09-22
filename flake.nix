{
  description = "Small Business Software";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          treefmt = {
            programs = {
              nixfmt = {
                enable = true;
                strict = true;
              };

              ruff-check.enable = true;
              ruff-format.enable = true;
              mdformat.enable = true;
            };
          };

          pre-commit.settings = {
            package = pkgs.prek;
            hooks = {
              treefmt.enable = true;
              treefmt.package = config.treefmt.build.wrapper;
            };
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
            packages = config.pre-commit.settings.enabledPackages ++ [

              # Add dependencies here
              pkgs.ty
              (pkgs.python314.withPackages (
                ps: with ps; [
                  fasthtml
                  sqlalchemy
                ]
              ))
            ];
          };
        };
    };
}
