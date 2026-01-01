#! /bin/bash
set -eux

# get script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# install dependencies
sudo apt-get update
sudo apt-get install -y socket

# create directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/nix

# copy config files
cp -fv "$DIR/.gitconfig" "$HOME/.gitconfig"
cp -fv "$DIR/.gitignore" "$HOME/.gitignore"
cp -fv "$DIR/.vimrc" "$HOME/.vimrc"
cp -fv "$DIR/.tmux.conf" "$HOME/.tmux.conf"
cp -fv "$DIR/shell.nix" "$HOME/shell.nix"
cp -fv "$DIR/nix.conf" "$HOME/.config/nix/nix.conf"
cp -fv "$DIR/.bash_tools" "$HOME/.bash_tools"

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -sfv $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# update .bashrc
if grep -q "DOTFILES_START" $HOME/.bashrc; then
    # remove old dotfiles section
    sed -i '/# DOTFILES_START/,/# DOTFILES_END/d' $HOME/.bashrc
fi

cat << EOS >> $HOME/.bashrc

# DOTFILES_START

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

if [ -d /workspaces ] || [ -n "\$DEVCONTAINER" ]; then
  alias xsel='for i in "\$@"; do case "\$i" in (-i|--input|-in) tee <&0 | socat - tcp:host.docker.internal:8121; exit 0 ;; esac; done'
fi


# DOTFILES_END

EOS
