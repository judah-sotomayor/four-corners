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

              d2.enable = true;
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
            packages =
              with pkgs;
              let
                mkScript =
                  name: text:
                  let
                    script = pkgs.writeShellScriptBin name text;
                  in
                  script;
                # Add custom scripts and build commands here.
                scripts = [
                  (mkScript "diagrams" "d2 --watch --dark-theme 200 --scale 1 -l elk docs/data-model.d2")
                  (mkScript "run" "python3 src/main.py")
                ];
              in
              config.pre-commit.settings.enabledPackages
              ++ scripts
              ++ [

                # Add dependencies here
                ty
                sqlite
                d2
                (python314.withPackages (
                  ps: with ps; [
                    fasthtml
                    peewee
                    passlib
                    bcrypt
                  ]
                ))
              ];
          };
        };
    };
}
