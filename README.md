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
tmux の `prefix → Ctrl-k` は上のペインに移動します。履歴の消去は `prefix → Ctrl-Delete` の後に確認します。

### アプリ設定の復元

以下はリポジトリのルートで実行します。Cursor の settings.json は編集可能なリンクにします。
既存のファイルやリンクは同じフォルダの .dotfiles-backup.* に退避します。

```sh
cd ~/ghq/github.com/nekootoko3/dotfiles
./install.sh
```

VS Code と Karabiner は書き込み可能なコピーを使います。次のコマンドは対象アプリを終了して実行します。
既存ファイルを置き換える際は個別に確認します。

```sh
code_user="$HOME/Library/Application Support/Code/User"
mkdir -p "$code_user/snippets" "$HOME/.config/karabiner"
cp -i vscode/settings.json vscode/keybindings.json "$code_user/"
cp -i vscode/snippets/*.json "$code_user/snippets/"
cp -i vscode/vscodestyles.css "$HOME/.vscodestyles.css"
cp -i karabiner/karabiner.json "$HOME/.config/karabiner/"
```

VS Code 拡張の復元用一覧は `vscode/extensions.txt` にあります。必要なものを選んで
`code --install-extension 拡張ID` で導入できます。アプリ側の編集を Git に戻すときは、
たとえば `git diff --no-index -- vscode/settings.json "$code_user/settings.json"` で差分を確認し、
共有したい変更だけを反映します。
VSCodeVim の入力ソース自動切り替えを使う場合は、VS Code から実行できる場所に
`im-select` を導入し、`vim.autoSwitchInputMethod.enable` を有効にしてください。

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
