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
  ];
}