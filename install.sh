#! /bin/bash
set -eux

# create .local/bin
mkdir -p $HOME/.local/bin
# shellcheck disable=SC2016
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# copy config files
cp .gitconfig $HOME/.gitconfig
cp .gitignore $HOME/.gitignore
cp .vimrc $HOME/.vimrc

#install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# shellcheck disable=SC2016
echo 'eval "$(zoxide init bash)"' >> $HOME/.bashrc

# install nix-portable
curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > $HOME/.local/bin/nix-portable
chmod +x $HOME/.local/bin/nix-portable
ln -s $HOME/.local/bin/nix-portable $HOME/.local/bin/nix-shell
echo "export NP_GIT=1" >> $HOME/.bashrc

cat << EOS >> $HOME/.bashrc
eza() {
    nix-portable nix run nixpkgs#eza -- "\$@"
}

vim() {
    nix-portable nix run nixpkgs#vim -- "\$@"
}

lazygit() {
    nix-portable nix run nixpkgs#lazygit -- "\$@"
}
EOS

# append bash aliases
echo "alias e='eza --icons'" >> $HOME/.bashrc
