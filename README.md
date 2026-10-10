# dotfiles

## 通常環境

Bash から `./install.sh` を実行します。Nix を導入し、CLI ツールと
Neovim、tmux、Git、Bash の設定を配置します。Nix の導入とパッケージ取得には
ネットワーク接続が必要です。

既存の設定ファイルは上書きしません。リポジトリと内容が異なる場合は警告を
表示するので、必要な変更を手動で取り込んでください。Git のグローバル設定は
未設定の項目だけ追加します。再実行しても TPM や Bash の設定を重複追加しません。

`rm` は `trash-put` を呼び出します。完全に削除する場合は `rm-force`
を使います。

## Dev Container

Dev Container の作成後に `.devcontainer/install.sh` が実行されます。
mise で `mise.toml` のツールを導入し、Bash、npm、Codex の設定を補います。
既存設定と異なる値は保持して警告します。Codex の設定は永続化ボリュームに
保存されます。
