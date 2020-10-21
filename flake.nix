{
  description = "A very basic flake";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix.url = "github:NixOS/nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, flake-utils, home-manager, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nix-wrapper = pkgs.writeShellScriptBin "nix" ''
          ${pkgs.nixUnstable}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
        '';
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nix-wrapper ];
          NIX_PATH = "nixpkgs=${nixpkgs}";
        };

        packages = {
          home-odin = home-manager.lib.homeManagerConfiguration {
            configuration = ./config.nix;
            homeDirectory = "/home/shane";
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            system = "x86-64_linux";
            username = "shane";
          };

          home-tyr = home-manager.lib.homeManagerConfiguration {
            configuration = ./config.nix;
            homeDirectory = "/Users/shanesveller";
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
            system = "x86-64_darwin";
            username = "shanesveller";
          };
        };
      }) // {

        # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

        # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

      };
}
