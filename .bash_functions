# yazi

function y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"

    yazi "$@" --cwd-file="$tmp"

    IFS= read -r -d '' cwd < "$tmp"
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        builtin cd -- "$cwd"
    fi

    rm -f -- "$tmp"
}

