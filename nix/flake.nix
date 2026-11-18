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
    nixpkgs.url = "github:NixOS/nixpkgs/b349185bb79c7cf7ad8ea8c097931730bf473c71";
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
        config.allowUnfree = true;
      };
      modules = [ ./home.nix ];
    };
  };
}
