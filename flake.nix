{
  description = "TLA+ development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        usrShell = builtins.getEnv "SHELL";

        shell =
          if usrShell != ""
          then usrShell
          else "${pkgs.bashInteractive}/bin/bash";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            tlaplus
            tlaplusToolbox
            jdk
            tlaps
            gnumake
            graphviz
          ];

          shellHook = ''
            export SHELL="${shell}"

            exec ${shell}
          '';
        };
      });
}
