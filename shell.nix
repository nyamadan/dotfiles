with import <nixpkgs> {};

mkShell {
  buildInputs = [
    tmux
    vim
    eza
    lazygit
    git
    fd
    fzf
    zoxide
    ripgrep
    trash-cli
    dust
    btop
    jq
    procs
    bat
    delta
    httpie
    bandwhich
  ];
}