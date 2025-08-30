with import <nixpkgs> {};

mkShell {
  buildInputs = [
    tmux
    vim
    eza
    lazygit
    git
    zoxide
  ];
  
  shellHook = ''
    alias e="eza --icons"
  '';
}