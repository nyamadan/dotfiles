# Dotfiles Repository

## install.sh

このinstall.shスクリプトは、開発環境のセットアップを自動化するスクリプトです：

**主な機能：**
- `.local/bin`ディレクトリを作成（install.sh:5）
- 設定ファイル（`.gitconfig`, `.gitignore`, `.vimrc`, `.tmux.conf`, `shell.nix`, `nix.conf`）をホームディレクトリにシンボリックリンク（install.sh:8-13）
- nix-portableをダウンロードして実行可能に設定（install.sh:16-18）
- `.bashrc`にコマンド用の関数とエイリアスを追加（install.sh:21-42）
- batが存在する場合、PAGER環境変数にbatを設定（install.sh:27-30）

### .bash_tools

`.bash_tools`ファイルには、以下のコマンド用の関数とエイリアスが定義されています：

- bat: `PAGER`環境変数に`bat -p`を設定（.bash_tools:5）
- eza: `e`エイリアスで`eza --icons`を実行（.bash_tools:9-11）
- zoxide: `zoxide init bash`を評価（.bash_tools:14-16）

作業が完了したら[AGENTS.md](./AGENTS.md)を更新するように指示します。
