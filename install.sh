#! /bin/bash
set -eux

# create directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/nix

# copy config files
cp .gitconfig $HOME/.gitconfig
cp .gitignore $HOME/.gitignore
cp .vimrc $HOME/.vimrc
cp .tmux.conf $HOME/.tmux.conf
cp shell.nix $HOME/shell.nix
cp nix.conf $HOME/.config/nix/nix.conf

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -s $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# .bashrc
cat << EOS >> $HOME/.bashrc

# export language
export LANG="ja_JP.UTF-8"

# nix-portable
export NP_GIT=1
export PATH="\$HOME/.local/bin:\$PATH"

export BAT_THEME="Visual Studio Dark+"

# aliases
alias dev-shell="nix-shell \$HOME/shell.nix --run 'tmux -u new-session -A -s dev'"
alias e="eza --icons"

# zoxide
if command -v zoxide &> /dev/null; then
    eval "\$(zoxide init bash)"
fi
EOS
