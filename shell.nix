with import <nixpkgs> {};

mkShell {
  buildInputs = [
    tmux
    vim
    eza
    lazygit
    git
  ];
  
  shellHook = ''
    alias eza="eza --icons"
  '';
}