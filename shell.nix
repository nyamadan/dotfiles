with import <nixpkgs> {};

mkShell {
  buildInputs = [
    tmux
    vim
    eza
    lazygit
    git
    fd
    rg
    fzf
    zoxide
  ];
  
  shellHook = ''
    alias e="eza --icons"

    eval "$(zoxide init bash)"
  '';
}