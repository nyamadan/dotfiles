#! /bin/bash
set -eux

# create directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/nix

# copy config files
cp .gitconfig $HOME/.gitconfig
cp .gitignore $HOME/.gitignore
cp .vimrc $HOME/.vimrc
cp shell.nix $HOME/shell.nix
cp nix.conf $HOME/.config/nix/nix.conf

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -s $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# .bashrc
cat << EOS >> $HOME/.bashrc

dev-shell() {
  NP_GIT=0 nix-shell $HOME/shell.nix
}

export PATH="\$HOME/.local/bin:\$PATH"
EOS
