#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_if_absent() {
  local source=$1 destination=$2
  if [[ ! -e "$destination" ]]; then
    cp -- "$source" "$destination"
  elif ! cmp -s -- "$source" "$destination"; then
    printf '既存の設定を保持します: %s\n' "$destination" >&2
  fi
}

git_default() {
  if ! git config --global --get "$1" >/dev/null; then
    git config --global "$1" "$2"
  fi
}

echo '=== Neovim ==='
mkdir -p "$HOME/.config/nvim" "$HOME/.local/share/nvim/undo" "$HOME/.vim/undodir"
copy_if_absent "$SCRIPT_DIR/init.lua" "$HOME/.config/nvim/init.lua"
copy_if_absent "$SCRIPT_DIR/init.vim" "$HOME/.vimrc"

echo '=== tmux ==='
copy_if_absent "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
if [[ ! -e "$HOME/.tmux/plugins/tpm" ]]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo '=== Git ==='
copy_if_absent "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"
git_default core.excludesfile "$HOME/.gitignore"
git_default core.autocrlf false
git_default core.whitespace cr-at-eol
git_default core.filemode false
git_default color.ui auto
git_default color.quotepath false
git_default push.default current
git_default branch.autosetuprebase always
git_default pull.rebase true
git_default pull.ff only
git_default alias.b branch
git_default alias.ci commit
git_default alias.co checkout
git_default alias.d diff
git_default alias.di diff
git_default alias.dc 'diff --cached'
git_default alias.dt difftool
git_default alias.dtc 'difftool --cached'
git_default alias.dtd 'difftool --dir-diff'
git_default alias.dtdc 'difftool --dir-diff --cached'
git_default alias.f 'fetch --prune'
git_default alias.s 'status --short --branch'
git_default alias.st status
git_default alias.sw switch
git_default alias.r restore
git_default gui.encoding utf-8
git_default init.defaultBranch master
git_default fetch.prune true

echo '=== Nix ==='
if ! command -v nix >/dev/null 2>&1; then
  installer=$(mktemp)
  trap 'rm -f -- "$installer"' EXIT
  curl --fail --proto '=https' --tlsv1.2 --location https://nixos.org/nix/install -o "$installer"
  sh "$installer" --no-daemon
fi
if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
if ! command -v nix >/dev/null 2>&1; then
  printf 'Nix が見つかりません。新しいシェルで再実行してください。\n' >&2
  exit 1
fi

mkdir -p "$HOME/.config/nix"
nix_conf="$HOME/.config/nix/nix.conf"
touch "$nix_conf"
if ! grep -Eq '^[[:space:]]*(extra-)?experimental-features[[:space:]]*=' "$nix_conf"; then
  printf '\n%s\n' 'experimental-features = nix-command flakes' >> "$nix_conf"
elif ! grep -Eq '^[[:space:]]*(extra-)?experimental-features[[:space:]]*=.*nix-command.*flakes' "$nix_conf"; then
  printf 'Nix の experimental-features を確認してください: %s\n' "$nix_conf" >&2
fi

registry_url='https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1'
registry_list=$(nix registry list)
if grep -Eq '^user[[:space:]]+flake:nixpkgs[[:space:]]' <<< "$registry_list"; then
  if ! grep -Fq "flake:nixpkgs $registry_url" <<< "$registry_list"; then
    printf '既存の nixpkgs レジストリを保持します。\n' >&2
  fi
else
  nix registry add nixpkgs "$registry_url"
fi

packages=(eza nkf bat tmux trash-cli ripgrep fd btop git lazygit neovim tree-sitter yazi chafa)
profile_list=$(nix profile list)
for pkg in "${packages[@]}"; do
  if ! grep -Fq "nixpkgs#${pkg}" <<< "$profile_list"; then
    printf 'nix profile add nixpkgs#%s\n' "$pkg"
    nix profile add "nixpkgs#${pkg}"
  fi
done

if command -v git-lfs >/dev/null 2>&1; then
  git_default filter.lfs.clean 'git-lfs clean -- %f'
  git_default filter.lfs.smudge 'git-lfs smudge -- %f'
  git_default filter.lfs.process 'git-lfs filter-process'
  git_default filter.lfs.required true
fi
if command -v git-credential-manager >/dev/null 2>&1; then
  git_default credential.helper manager
fi

echo '=== Bash ==='
copy_if_absent "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"
copy_if_absent "$SCRIPT_DIR/.bash_prompt" "$HOME/.bash_prompt"
copy_if_absent "$SCRIPT_DIR/.bash_functions" "$HOME/.bash_functions"
touch "$HOME/.bashrc"
if ! grep -Fqx '# dotfiles setup' "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

# dotfiles setup
if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
export EDITOR=nvim
[[ -f "$HOME/.bash_prompt" ]] && . "$HOME/.bash_prompt"
[[ -f "$HOME/.bash_functions" ]] && . "$HOME/.bash_functions"
[[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"
EOF
fi

echo '=== インストール完了 ==='
