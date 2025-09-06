# Dotfiles Repository

## install.sh

このinstall.shスクリプトは、開発環境のセットアップを自動化するスクリプトです：

**主な機能：**
- `.local/bin`ディレクトリを作成（install.sh:5）
- 設定ファイル（`.gitconfig`, `.gitignore`, `.vimrc`）をホームディレクトリにコピー（install.sh:8-10）
- zoxideをインストール（install.sh:13）
- nix-portableをダウンロードして実行可能に設定（install.sh:16-18）
- `.bashrc`にコマンド用の関数とエイリアスを追加（install.sh:21-42）
- batが存在する場合、PAGER環境変数にbatを設定（install.sh:27-30）

スクリプトは`set -eux`で厳格なエラーハンドリングを設定しています。

作業が完了したら[AGENTS.md](./AGENTS.md)を更新するように指示します。
