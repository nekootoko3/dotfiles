# Nix と GUI 専用 Homebrew の管理

CLI・言語環境は cli-packages.json と home.nix / Home Manager、GUI は gui-casks.json と
darwin.nix / nix-darwin、プロジェクト環境は各プロジェクトの devShell で管理する。
Homebrew 本体と core/cask の配布定義も nix-homebrew / flake.lock で固定する。
Homebrew に手動で CLI を追加しない。App Store 版や Karabiner のドライバー等は
native-apps.json に記録した既存方式を維持する。

## Apple Silicon Mac での初回セットアップ

Nix を導入し、[リポジトリの README](../README.md) に従って clone する。
以下はログインユーザーのターミナルで実行する。ユーザー名やホームの編集は不要。
既存の同名ファイルがある場合は内容を比較して退避する。

```sh
cd ~/ghq/github.com/nekootoko3/dotfiles/nix
export NIX_CONFIG='extra-experimental-features = nix-command flakes'
nix build --impure .#homeConfigurations.mac.activationPackage
./result/activate
```

GUI も導入する場合は、同じディレクトリで次を実行する。管理者認証が必要。
この構成は宣言済みの Cask をインストール・更新する。

```sh
export DARWIN_USER="$(id -un)" DARWIN_HOME="$HOME"
nix build --impure .#darwinConfigurations.mac.system
sudo env DARWIN_USER="$DARWIN_USER" DARWIN_HOME="$DARWIN_HOME" NIX_CONFIG="$NIX_CONFIG" ./result/sw/bin/darwin-rebuild switch --impure --flake .#mac
```

以前の Home Manager 世代で GUI を管理している Mac は、先に Cask への移行と検証を済ませる。
過去の移行専用スクリプトと当時の構成は一組として扱う。

## 通常の反映

普段の追加には `macenv cli add ripgrep` や `macenv gui add iina` を使う。
設定ファイルを手で編集した後は `macenv apply cli` または `macenv apply gui` で反映する。
削除には `macenv cli remove ripgrep` や `macenv gui remove iina` を使う。
アプリ設定の同期は[リポジトリの README](../README.md#アプリ設定の同期)を参照。

直接反映する場合は次のコマンドを使う。

```sh
cd ~/ghq/github.com/nekootoko3/dotfiles/nix
export NIX_CONFIG='extra-experimental-features = nix-command flakes'
home-manager switch --impure --flake .#mac
# macOS / Homebrew の構成を変えた場合
sudo env DARWIN_USER="$(id -un)" DARWIN_HOME="$HOME" NIX_CONFIG="$NIX_CONFIG" /run/current-system/sw/bin/darwin-rebuild switch --impure --flake .#mac
```

Vim、tmux、Zsh、共通 Git 設定、Cursor のキーバインドは nix/dotfiles/ で編集する。
Git の名前・メール・仕事用 includeIf は書き込み可能な ~/.gitconfig に置く。
新端末では git config --global user.name と user.email を設定する。
~/.zshrc.local や認証情報は端末ごとに復元する。
初回の対話シェルでは Antigen がネットワークからプラグインを取得する。
Vim のプラグインは :PlugInstall で取得する。これらのプラグインの版は flake.lock の対象外。
Vim のスワップディレクトリは mkdir -p ~/.vim/tmp で作成できる。
Cursor の settings.json、VS Code、Karabiner は[アプリ設定の復元手順](../README.md#アプリ設定の同期)を使う。

## 更新

普段は `macenv update cli` または `macenv update gui` を使う。
CLI の初回更新では、Nixpkgs のコミット指定を nixpkgs-26.05-darwin に変更し、
正確な版は flake.lock で固定する。GUI の更新は管理者認証が必要。

mise 本体は公式リリースに固定している。更新するには `flake.nix` の
`github:jdx/mise/v…` を希望のタグに変更し、`macenv apply cli` を実行する。

手動で入力を更新する場合は次の手順を使う。

作業中の変更を保存し、現在の Git コミットと Home Manager / nix-darwin の世代を記録する。

```sh
cd ~/ghq/github.com/nekootoko3/dotfiles/nix
nix --extra-experimental-features 'nix-command flakes' flake update nix-darwin nix-homebrew homebrew-core homebrew-cask home-manager
git diff -- flake.lock
DARWIN_USER="$(id -un)" DARWIN_HOME="$HOME" nix --extra-experimental-features 'nix-command flakes' build --impure .#darwinConfigurations.mac.system
```

その後、通常の反映を行う。onActivation.upgrade=true のため GUI 更新も実行する。
Homebrew の独立した autoUpdate は無効、cleanup=none のため未宣言パッケージを自動削除しない。
Nixpkgs がコミット指定の間は別途URLを見直す。home.stateVersion と system.stateVersion は
通常の更新に合わせて変更しない。

BetterTouchTool 4.397、CleanShot X 4.7.8、Dash 8.2.0 はライセンス保全のため
homebrew-tap/Casks の簡潔な定義で版を維持する。更新時は利用可能なライセンスを確認し、
version / URL / SHA256 を更新する。Dash の同一URLの内容変更時も公式配布物を確認する。
Cask はインストール一覧を宣言管理できるが、Nix パッケージと同じロールバック・再現性ではない。

## 復元と新しいMac

GUI 更新前のアプリ原本とリンクは作業フォルダのバックアップへ保存する。
Git / flake.lock の復元だけでは Cask のアプリ本体やユーザーデータは以前に戻らない。
必要なら保存したアプリ本体を復元する。個人の認証情報・DB・書類も別途保全する。

新端末の手順は上記の初回セットアップを参照。プロジェクトのソースと lock は別途復元する。

参考：https://nix-darwin.github.io/nix-darwin/manual/
参考：https://github.com/zhaofengli/nix-homebrew
