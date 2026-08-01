#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------
# 1. dotfilesのコピー
# ------------------------------------------------------------------
echo "=== tmux / vimrc / bash_aliases を HOME にコピー ==="
cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
cp "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
cp "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"

# ------------------------------------------------------------------
# 2. Gitのグローバル設定
# ------------------------------------------------------------------
echo "=== Gitのグローバル設定を行います ==="
cp "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"
git config --global core.excludesfile ~/.gitignore
git config --global core.editor "code --wait"
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
# 3. bashrcへの追記
# ------------------------------------------------------------------
echo "=== bashrc に PS1 / zoxide / Docker 設定を追記 ==="
if ! grep -Fq "parse_git_branch() {" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

# nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# zoxide
eval "$(zoxide init bash)"

# PS1
parse_git_branch() {
    git branch --show-current 2>/dev/null
}

PS1='\[\e[38;5;39m\]\u\[\e[0m\]@\[\e[38;5;214m\]\h\[\e[0m\] \[\e[38;5;81m\]\w\[\e[0m\]\[\e[38;5;40m\]$(b=$(parse_git_branch); [ -n "$b" ] && printf " (%s)" "$b")\[\e[0m\]\n❯ '
EOF
fi

if ! grep -Fq "# Docker aliases & functions" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

#############################################
# Docker aliases & functions
#############################################

if command -v docker >/dev/null 2>&1; then

## --- クリーンアップ系 ---
alias dclean='docker system prune -f'
alias dclean-all='docker system prune -af --volumes'
alias dclean-cache='docker builder prune -f'
alias drm-stopped='docker container prune -f'
alias drm-dangling='docker image prune -f'
alias drm-volumes='docker volume prune -f'
alias drm-networks='docker network prune -f'
alias drm-all-stopped='docker rm -f $(docker ps -aq --filter "status=exited") 2>/dev/null'

## --- 状態確認系 ---
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias dimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"'
alias ddf='docker system df'
alias ddf-v='docker system df -v'

## --- 実行・停止系 ---
alias dstop-all='docker stop $(docker ps -q)'

#############################################
# fzfでコンテナ/イメージを選ぶ系（矢印キー選択、Tabで複数選択）
#############################################

# 稼働中コンテナをfzfで選んでshellに入る
dsh() {
  local cid
  cid=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
    | fzf --header 'Enter container shell' \
    | awk '{print $1}')
  [ -z "$cid" ] && return 1
  docker exec -it "$cid" sh -c "which bash >/dev/null 2>&1 && exec bash || exec sh"
}

# 稼働中コンテナをfzfで選んでログをfollow表示
dlogs() {
  local cid
  cid=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
    | fzf --header 'Tail logs' \
    | awk '{print $1}')
  [ -z "$cid" ] && return 1
  docker logs -f --tail 100 "$cid"
}

# 全コンテナ(停止中含む)からfzfで複数選択して削除
drm() {
  local cids
  cids=$(docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
    | fzf -m --header 'Remove containers (Tab: multi-select)' \
    | awk '{print $1}')
  [ -z "$cids" ] && return 1
  echo "$cids" | xargs docker rm -f
}

# 全コンテナからfzfで複数選択して停止
dstop() {
  local cids
  cids=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
    | fzf -m --header 'Stop containers (Tab: multi-select)' \
    | awk '{print $1}')
  [ -z "$cids" ] && return 1
  echo "$cids" | xargs docker stop
}

# イメージをfzfで複数選択して削除
drmi() {
  local ids
  ids=$(docker images --format '{{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}' \
    | fzf -m --header 'Remove images (Tab: multi-select)' \
    | awk '{print $2}')
  [ -z "$ids" ] && return 1
  echo "$ids" | xargs docker rmi -f
}

# ボリュームをfzfで複数選択して削除
drmv() {
  local vols
  vols=$(docker volume ls --format '{{.Name}}\t{{.Driver}}' \
    | fzf -m --header 'Remove volumes (Tab: multi-select)' \
    | awk '{print $1}')
  [ -z "$vols" ] && return 1
  echo "$vols" | xargs docker volume rm
}

# 名前の一部でパターン一致するコンテナをまとめて停止＋削除
drm-match() {
  docker ps -a --format '{{.Names}}' | grep "$1" | xargs -r docker rm -f
}

fi
EOF
fi

# ------------------------------------------------------------------
# 4. Nix本体のインストール（未インストールの場合のみ）
# ------------------------------------------------------------------
if ! command -v nix >/dev/null 2>&1; then
  echo "=== Nix をインストールします ==="
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
  # 現在のシェルでnixコマンドを使えるようにする
  # shellcheck disable=SC1091
   . $HOME/.nix-profile/etc/profile.d/nix.sh
else
  echo "=== Nix は既にインストール済みです ==="
fi

# ------------------------------------------------------------------
# 5. Nixの設定ファイル作成（experimental-features有効化）
# ------------------------------------------------------------------
echo "=== Nixの設定ファイルを作成（experimental-features有効化） ==="
mkdir -p $HOME/.config/nix
echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf

# ------------------------------------------------------------------
# 6. nixpkgsレジストリをweekly(7日クールダウン)版に固定
#    supply chain攻撃対策。詳細:
#    https://determinate.systems/blog/nixpkgs-cooldown/
# ------------------------------------------------------------------
echo "=== nixpkgsレジストリをweekly版に設定 ==="
nix registry add nixpkgs https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1

# ------------------------------------------------------------------
# 7. パッケージのインストール（nix profile add）
#    ※ nix profile install は旧称。現行CLIでは add が正式名。
# ------------------------------------------------------------------
echo "=== 各種CLIツールをインストール ==="

packages=(
  nkf
  eza
  bat
  ripgrep
  fd
  btop
  trash-cli
  git
  tmux
  lazygit
  zoxide
)

for pkg in "${packages[@]}"; do
  echo "--- nix profile add nixpkgs#${pkg} ---"
  nix profile add "nixpkgs#${pkg}"
done

echo ""
echo "=== インストール完了 ==="
echo "nix profile list で確認できます:"
echo "  nix profile list"
echo ""
echo "Nix版のbat/fdはバイナリ名がそのまま 'bat' 'fd' になる点に注意してください"
echo "(apt版のbatcat/fdfindとは違います)。alias側もそれに合わせて修正が必要です。"
