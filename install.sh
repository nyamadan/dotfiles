#! /bin/bash
set -eux

# create directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/nix

# link config files
ln -sf "$(pwd)/.gitconfig" "$HOME/.gitconfig"
ln -sf "$(pwd)/.gitignore" "$HOME/.gitignore"
ln -sf "$(pwd)/.vimrc" "$HOME/.vimrc"
ln -sf "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$(pwd)/shell.nix" "$HOME/shell.nix"
ln -sf "$(pwd)/nix.conf" "$HOME/.config/nix/nix.conf"
ln -sf "$(pwd)/.bash_tools" "$HOME/.bash_tools"

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -sf $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# .bashrc
cat << EOS >> $HOME/.bashrc

# locale settings
export LANG=C
export LC_ALL=C.UTF-8

# nix-portable
export PATH="\$HOME/.local/bin:\$PATH"
alias dev-shell="NI_PIT=0 nix-shell \$HOME/shell.nix --run 'tmux -u new-session -A -s dev'"

# bash tools
if [ -f \$HOME/.bash_tools ]; then
    . \$HOME/.bash_tools
fi

EOS
