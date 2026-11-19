{
  description = "Personal macOS environment";

  inputs = {
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:Homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:Homebrew/homebrew-cask"; flake = false; };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    mise = {
      url = "github:jdx/mise/v2026.11.10";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }: {
    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [ nix-homebrew.darwinModules.nix-homebrew ./darwin.nix ];
    };
    homeConfigurations.mac = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        overlays = [ inputs.mise.overlay ];
        config.allowUnfree = true;
      };
      modules = [ ./home.nix ];
    };
  };
}
