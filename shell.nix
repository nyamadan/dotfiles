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
  
  shellHook = ''
    alias e="eza --icons"

    eval "$(zoxide init bash)"
  '';
}