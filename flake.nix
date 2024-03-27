{
  description = "Nix package for building mini websites from org-mode notes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlays.default = final: prev: {
        org-builder = with final; pkgs.runCommand "org-builder" {
          src = ./src;
          nativeBuildInputs = [pkgs.makeWrapper];
          buildInputs = [pkgs.bash];
          binPath = with pkgs;
            lib.strings.makeBinPath [
              coreutils
              bash
              emacs
              rsync
            ];
        } ''
          install -Dm755 $src/lib/org-compile.el $out/lib/org-compile.el
          install -Dm755 $src/bin/org-builder.sh $out/bin/org-builder
          wrapProgram $out/bin/org-builder --prefix "$out/bin:$binPath"
          patchShebangs $out/lib/org-compile.el $out/bin
        '';
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        app = flake-utils.lib.mkApp {
          drv = pkgs.org-builder;
        };
      in
      {
        packages = {
          org-builder = pkgs.org-builder;
          default = pkgs.org-builder;
        };

        apps = {
          org-builder = app;
          default = app;
        };
      }));
}
