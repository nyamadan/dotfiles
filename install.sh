#! /bin/bash
set -eux

# get script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# create directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/nix

# install dependencies
sudo apt-get update
sudo apt-get install -y socat

# install clip.sh as xsel and xclip if in devcontainer

# # if you want to use clip.sh, copy below senction to .bashrc
# if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
#     # Start up the socat forwarder to clip.exe
#     ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
#     if [[ $ALREADY_RUNNING != "0" ]]; then
#         echo "Starting clipboard relay..."
#         (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'bash -c "(nkf -sjis | clip.exe)"' &) > /dev/null 2>&1
#     else
#         echo "Clipboard relay already running"
#     fi
# fi

if [ -d /workspaces ] || [ -n "$DEVCONTAINER" ]; then
  ln -sfv $DIR/clip.sh $HOME/.local/bin/xsel
  ln -sfv $DIR/clip.sh $HOME/.local/bin/xclip
fi


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
alias dev-shell="NP_GIT=\$(which git) nix-shell $HOME/shell.nix --run 'tmux -u new-session -A -s dev'"


# clipboard settings for devcontainer
if [ -d /workspaces ] || [ -n "\$DEVCONTAINER" ]; then
  alias pbcopy="(xsel --input)"
fi

# bash tools
if [ -f \$HOME/.bash_tools ]; then
    . \$HOME/.bash_tools
fi


# DOTFILES_END

EOS
