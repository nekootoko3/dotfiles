## dotfiles

### Apple Silicon Mac のセットアップ

Nix を導入し、このリポジトリを取得します。

```sh
mkdir -p ~/ghq/github.com/nekootoko3
git clone https://github.com/nekootoko3/dotfiles.git ~/ghq/github.com/nekootoko3/dotfiles
cd ~/ghq/github.com/nekootoko3/dotfiles/nix
```

初回の適用、更新、GUI の導入は [Nix の手順](nix/README.md) を参照してください。
Home Manager が配布する設定は `nix/dotfiles/` で編集します。
`home/` と `cursor/keybindings.json` は旧セットアップ用です。

### What you need to do manually

#### System preferences

- Dock
  - Ajdust the size
  - Prefer tabs when opening documents -> Always
- Keyboard
  - Keyboard
    - Key Repeat -> Fast
    - Delay Until Repeat -> Short
    - Touch Barh shows -> F1, F2, etc. Keys
    - Move focus to next window -> option + tab
  - Shortcuts
    - Input Sources -> Select the previous input source -> off
  - Spotlight
    - All off (because Alfred enabled)
  - Trackpad
    - Tap to click -> on
    - Click -> Light
    - Tracking speed -> Fast
  - Touch ID
    - Set your Touch ID

#### Install font

https://fonts.google.com/specimen/Fira+Mono
