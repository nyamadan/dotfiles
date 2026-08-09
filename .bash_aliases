# copy
alias pbcopy='(nkf -sjis | clip.exe)'

# eza aliases
alias l='eza --classify --oneline'
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza --icons=auto -lah --group-directories-first --git'
alias la='eza --icons=auto -a --group-directories-first'
alias tree='eza --icons=auto --tree --level=2'

# zoxide
alias cd='z'

# cat
alias cat='bat --paging=never --style=plain'

# editor
alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# grep
alias grep='rg'

# top
alias top='btop'
alias htop='btop'

# ディスク使用量
alias duh='du -sh * | sort -h'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'

# 履歴
alias h='history'
alias hs='history | grep'

# apt
alias apt-update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean'
alias apt-install='sudo apt install'
alias apt-remove='sudo apt remove'

# 基本: rm を trash-put に置き換える
alias rm='trash-put'

# 個別コマンドも短縮しておくと便利
alias tl='trash-list'          # ゴミ箱の中身を一覧
alias tp='trash-put'           # ゴミ箱に移動(rmの代わり)
alias tr='trash-restore'       # 復元(対話式で選択)
alias te='trash-empty'         # ゴミ箱を空にする
alias te7='trash-empty 7'      # 7日以上前のものだけ空にする

# 本当に完全削除したいときのための逃げ道
alias rm-force='/bin/rm'       # or \rm でも可(alias無視)

# 安全にするコマンド
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

# --- Nix本体のアップグレード(upstream版) ---
alias nix-upgrade='sudo -i nix upgrade-nix'

# --- profileパッケージの更新 ---
alias nix-update='nix profile upgrade --all'

# --- インストール済みパッケージ一覧 ---
alias nix-list='nix profile list'

# --- 不要になったストアパスの削除(ガベージコレクション) ---
alias nix-gc='nix store gc'
alias nix-gc-old='sudo nix-collect-garbage -d --delete-older-than 30d'

# --- ストアの最適化(重複排除でディスク節約) ---
alias nix-optimize='nix store optimise'

# --- ストアの使用容量確認 ---
alias nix-du='du -sh /nix/store'

# --- 世代(generation)の確認・ロールバック ---
alias nix-gens='nix profile history'
alias nix-rollback='nix profile rollback'

# --- ストアの整合性検証 ---
alias nix-verify='nix store verify --all'

# --- 現在のNixバージョン確認 ---
alias nix-ver='nix --version'

# --- まとめメンテナンス(パッケージ更新+GC+最適化。Nix本体は含めない) ---
alias nix-maintenance='nix profile upgrade --all && nix store gc && nix store optimise'
