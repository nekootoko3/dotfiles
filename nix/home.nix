{ pkgs, lib, ... }:
let
  username = builtins.getEnv "USER";
  directory = builtins.getEnv "HOME";
in
assert lib.assertMsg (username != "" && username != "root" && lib.hasPrefix "/" directory)
  "Run Home Manager as your login user with --impure, USER and HOME.";
{
  home.username = username;
  home.homeDirectory = directory;
  home.stateVersion = "26.05";
  home.sessionVariables.JAVA_HOME = "${pkgs.jdk21}";

  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".zlogin".source = ./dotfiles/zlogin;
  home.file.".zlogout".source = ./dotfiles/zlogout;
  home.file.".zprofile".source = ./dotfiles/zprofile;
  home.file.".zpreztorc".source = ./dotfiles/zpreztorc;
  home.file.".zshenv".source = ./dotfiles/zshenv;
  home.file."Library/Application Support/Cursor/User/keybindings.json".source = ./dotfiles/cursor-keybindings.json;
  home.file.".vimrc".source = ./dotfiles/vimrc;
  xdg.configFile."git/config".source = ./dotfiles/gitconfig;
  home.file.".tmux.conf".source = ./dotfiles/tmux.conf;
  home.file.".vim/autoload/plug.vim".source = ./dotfiles/plug.vim;

  home.packages = with pkgs; [
    (python312.withPackages (ps: [ ps.numpy ps.pip ]))
    (writeShellScriptBin "vercel" ''
      export PATH="${nodejs_22}/bin:$PATH"
      exec ${nodejs_22}/bin/npx --yes vercel@65.16.0 "$@"
    '')
    (writeShellScriptBin "macenv" ''
      exec ${python312}/bin/python3 "$HOME/ghq/github.com/nekootoko3/dotfiles/nix/macenv" "$@"
    '')
  ] ++ map (name: builtins.getAttr name pkgs)
    (builtins.fromJSON (builtins.readFile ./cli-packages.json));

  programs.home-manager.enable = true;
  home.activation.requireCaskMigration = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [[ ! -f /opt/homebrew/.gui-cask-migration-verified ]] &&
       compgen -G "$HOME/.nix-profile/Applications/*.app" >/dev/null; then
      echo "GUI Cask migration must be verified before removing the Nix GUI packages." >&2
      exit 1
    fi
  '';
}
