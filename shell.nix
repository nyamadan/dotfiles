with import <nixpkgs> {};

mkShell {
  buildInputs = [
    man
    tmux
    vim
    eza
    lazygit
    git
    fd
    fzf
    nkf
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
    zoxide
  ];
}