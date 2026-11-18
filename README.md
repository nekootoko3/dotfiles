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

### パッケージの追加と削除

Home Manager を初回適用すると、どのディレクトリからでも `macenv` を使えます。

```sh
macenv cli add ripgrep
macenv gui add iina
macenv cli remove ripgrep
macenv gui remove iina
```

それぞれ `nix/cli-packages.json` と `nix/gui-casks.json` を更新し、ビルド後に反映します。
GUI の反映には管理者認証が必要で、ほかの宣言済み Cask も更新される場合があります。
GUI の削除はアプリを終了してから実行します。設定データを消す `--zap` は使いません。
リストを手で編集した場合や他の Mac で変更を取り込んだ場合は、`macenv apply cli` または
`macenv apply gui` で反映します。

### アプリ設定の同期

設定を変更した Mac で `save` を実行し、Git の差分を確認して共有する変更をコミットします。
別の Mac ではそのコミットを取り込んでから、対象アプリを終了し `restore` を実行します。

```sh
macenv settings save vscode
macenv settings restore vscode
macenv settings save karabiner
macenv settings restore karabiner
macenv settings restore cursor
```

- **VS Code** は標準プロファイルの設定・キーバインド・スニペット・カスタム CSS・拡張一覧が対象です。
  復元時は不足している拡張を導入します。既存のファイルや拡張は一覧から外れても自動削除しません。
- **Cursor** の `settings.json` は `restore` でリポジトリにリンクし、キーバインドは Home Manager で反映します。
  リンクがファイルに置き換わった場合は `macenv settings save cursor` で取り込めます。
- **Karabiner** は `karabiner.json` が対象です。ドライバーや macOS の権限は各 Mac で設定します。

VS Code と Karabiner は、変更のあるファイルを上書きする前に
`~/Library/Application Support/macenv/` にバックアップし、その場所を表示します。
Cursor のリンク設定時のバックアップはアプリの設定フォルダに作成します。
Git に共有する前に設定の差分を確認し、端末固有のパスやトークンがあれば取り除いてください。
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
