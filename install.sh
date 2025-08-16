#! /bin/bash
set -eux

# create .local/bin
mkdir -p $HOME/.local/bin

# copy config files
cp .gitconfig $HOME/.gitconfig
cp .gitignore $HOME/.gitignore
cp .vimrc $HOME/.vimrc

#install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -s $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell

# .bashrc
cat << EOS >> $HOME/.bashrc
export PATH="\$HOME/.local/bin:\$PATH"

eza() {
    NP_GIT=1 nix-portable nix run --offline nixpkgs#eza -- "\$@"
}

vim() {
    NP_GIT=1 nix-portable nix run --offline nixpkgs#vim -- "\$@"
}

lazygit() {
    NP_GIT=1 nix-portable nix run --offline nixpkgs#lazygit -- "\$@"
}

tmux() {
    NP_GIT=1 nix-portable nix run --offline nixpkgs#tmux -- "\$@"
}

build-all-nix-commands() {
    NP_GIT=1 nix-portable nix build --print-build-logs --debug nixpkgs#lazygit nixpkgs#vim nixpkgs#eza
}

eval "\$(zoxide init bash)"
alias e='eza --icons'
EOS
