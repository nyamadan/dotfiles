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
    trash
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