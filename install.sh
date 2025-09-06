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
cp .bash_tools $HOME/.bash_tools

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -s $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# .bashrc
cat << EOS >> $HOME/.bashrc

# locale settings
export LANG=C
export LC_ALL=C.UTF-8

# nix-portable
export PATH="\$HOME/.local/bin:\$PATH"
alias dev-shell="nix-shell \$HOME/shell.nix --run 'tmux -u new-session -A -s dev'"

# bash tools
if [ -f \$HOME/.bash_tools ]; then
    . \$HOME/.bash_tools
fi

EOS
