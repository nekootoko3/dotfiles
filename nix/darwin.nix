{ inputs, pkgs, lib, ... }:
let
  username = builtins.getEnv "DARWIN_USER";
  directory = builtins.getEnv "DARWIN_HOME";
in
assert lib.assertMsg (username != "" && username != "root" && lib.hasPrefix "/" directory)
  "Pass the login user's DARWIN_USER and DARWIN_HOME and use --impure.";
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = username;
  users.users.${username}.home = directory;
  # Retain the existing official Nix daemon and personal shell setup.
  nix.enable = false;
  programs.zsh.enable = false;
  programs.bash.enable = false;

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = username;
    mutableTaps = false;
    trust.taps = [ "local/pinned" ];
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "local/homebrew-pinned" = pkgs.runCommand "pinned-gui-casks" { } ''
        cp -R ${./homebrew-tap} "$out"
      '';
    };
  };
  homebrew = {
    enable = true;
    taps = [ "homebrew/core" "homebrew/cask" "local/pinned" ];
    brews = [ ];
    casks = [
      "local/pinned/bettertouchtool"
      "local/pinned/cleanshot"
      "local/pinned/dash"
      "cursor" "ghostty" "google-chrome" "microsoft-teams"
      "notion" "obsidian" "raycast" "slack" "visual-studio-code"
      "pgadmin4" "zoom"
    ];
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "none";
    };
  };
}
