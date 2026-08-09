#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------
# 1. neovimセットアップ
# ------------------------------------------------------------------
echo "=== [1/8] neovimのセットアップ ==="
mkdir -p "$HOME/.config/nvim" "$HOME/.local/share/nvim/undo"
cp "$SCRIPT_DIR/init.lua" "$HOME/.config/nvim/init.lua"
cp "$SCRIPT_DIR/init.vim" "$HOME/.vimrc"
mkdir -p ~/.vim/undodir

# ------------------------------------------------------------------
# 2. tmuxのセットアップ
# ------------------------------------------------------------------
echo "=== [2/8] tmuxのセットアップ ==="
cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ------------------------------------------------------------------
# 3. Gitのグローバル設定
# ------------------------------------------------------------------
echo "=== [3/8] Gitのグローバル設定を行います ==="
cp "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"
git config --global core.excludesfile ~/.gitignore
# git config --global core.editor "code --wait"
git config --global core.autocrlf false
git config --global core.whitespace cr-at-eol
git config --global core.filemode false
git config --global color.ui auto
git config --global color.quotepath false
git config --global push.default current
git config --global branch.autosetuprebase always
git config --global pull.rebase true
git config --global pull.ff only
git config --global alias.b branch
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.d diff
git config --global alias.di diff
git config --global alias.dc "diff --cached"
git config --global alias.dt difftool
git config --global alias.dtc "difftool --cached"
git config --global alias.dtd "difftool --dir-diff"
git config --global alias.dtdc "difftool --dir-diff --cached"
git config --global alias.f "fetch --prune"
git config --global alias.s "status --short --branch"
git config --global alias.st status
git config --global alias.sw switch
git config --global alias.r restore
git config --global gui.encoding utf-8
git config --global filter.lfs.clean "git-lfs clean -- %f"
git config --global filter.lfs.smudge "git-lfs smudge -- %f"
git config --global filter.lfs.process "git-lfs filter-process"
git config --global filter.lfs.required true
git config --global credential.helper manager
git config --global init.defaultBranch master
git config --global fetch.prune true

# ------------------------------------------------------------------
# 4. Nix本体のインストール（未インストールの場合のみ）
# ------------------------------------------------------------------
if ! command -v nix >/dev/null 2>&1; then
  echo "=== [4/8] Nix をインストールします ==="
  echo "  [1/2] Nix のインストールスクリプトを取得しています..."
  curl --proto '=https' --tlsv1.2 --progress-bar -L https://nixos.org/nix/install -o /tmp/nix-install.sh
  echo "  [2/2] Nix をセットアップしています..."
  sh /tmp/nix-install.sh --no-daemon
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  echo "=== [4/8] Nix は既にインストール済みです ==="
fi

# ------------------------------------------------------------------
# 5. Nixの設定ファイル作成（experimental-features有効化）
# ------------------------------------------------------------------
echo "=== [5/8] Nixの設定ファイルを作成（experimental-features有効化） ==="
mkdir -p $HOME/.config/nix
echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf

# ------------------------------------------------------------------
# 6. nixpkgsレジストリをweekly(7日クールダウン)版に固定
#    supply chain攻撃対策。詳細:
#    https://determinate.systems/blog/nixpkgs-cooldown/
# ------------------------------------------------------------------
echo "=== [6/8] nixpkgsレジストリをweekly版に設定 ==="
nix registry add nixpkgs https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1

# ------------------------------------------------------------------
# 7. パッケージのインストール（nix profile add）
#    ※ nix profile install は旧称。現行CLIでは add が正式名。
# ------------------------------------------------------------------
echo "=== [7/8] 各種CLIツールをインストール ==="

packages=(
  eza                     # lsの代替コマンド
  nkf                     # 文字コード変換
  bat                     # catの代替コマンド
  tmux                    # ターミナルマルチプレクサ
  trash-cli               # ゴミ箱管理
  ripgrep                 # grepの代替コマンド
  fd                      # findの代替コマンド
  btop                    # リソース監視
  git                     # バージョン管理システム
  lazygit                 # gitのTUI
  neovim                  # エディタ
  tree-sitter             # シンタックスハイライト
  yazi                    # ファイル操作用のターミナルベースUI
  chafa                   # 画像プレビュー表示
)

total_packages=${#packages[@]}
for i in "${!packages[@]}"; do
  pkg="${packages[$i]}"
  progress=$((i + 1))
  echo "  [${progress}/${total_packages}] nix profile add nixpkgs#${pkg}"
  nix profile add "nixpkgs#${pkg}"
done

# ------------------------------------------------------------------
# 8. bash_aliasesのコピーとbashrcへの追記
# ------------------------------------------------------------------
echo "=== [8/8] bashスクリプト を HOME にコピー ==="
cp "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"
cp "$SCRIPT_DIR/.bash_prompt" "$HOME/.bash_prompt"
cp "$SCRIPT_DIR/.bash_functions" "$HOME/.bash_functions"

echo "=== [8/8] bashrc を更新 ==="
if ! grep -Fq "parse_git_branch() {" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

# nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# editor
export EDITOR='nvim'

# PS1
if [[ -f "$HOME/.bash_prompt" ]]; then
    . "$HOME/.bash_prompt"
fi

# functions
if [[ -f "$HOME/.bash_functions" ]]; then
    . "$HOME/.bash_functions"
fi
EOF
fi


echo ""
echo "=== インストール完了 ==="
echo "nix profile list で確認できます:"
echo "  nix profile list"
echo ""
