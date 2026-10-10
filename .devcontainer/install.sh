#!/usr/bin/env bash
set -euo pipefail

touch "$HOME/.bashrc" "$HOME/.npmrc"
if ! grep -Fqx 'eval "$(mise activate bash)"' "$HOME/.bashrc"; then
  printf '\n%s\n' 'eval "$(mise activate bash)"' >> "$HOME/.bashrc"
fi
for setting in 'min-release-age=7' 'ignore-scripts=true'; do
  key=${setting%%=*}
  if ! grep -Eq "^[[:space:]]*${key}[[:space:]]*=" "$HOME/.npmrc"; then
    printf '\n%s\n' "$setting" >> "$HOME/.npmrc"
  elif ! grep -Fqx "$setting" "$HOME/.npmrc"; then
    printf '既存の npm 設定を保持します: %s\n' "$key" >&2
  fi
done

if [[ ! -e "$HOME/.codex" ]]; then
  mkdir -p "$HOME/.codex"
fi
if [[ ! -w "$HOME/.codex" ]]; then
  printf 'Codex 設定ディレクトリに書き込めません: %s\n' "$HOME/.codex" >&2
  exit 1
fi
# 永続化した設定は再作成時にも保持する。
if [[ ! -e "$HOME/.codex/config.toml" ]]; then
cat <<'EOF' > "$HOME/.codex/config.toml"

model = "gpt-6.1-sol"
model_reasoning_effort = "low"
plan_mode_reasoning_effort = "low"
sandbox_mode = "danger-full-access"
approval_policy = "on-request"
check_for_update_on_startup = false
cli_auth_credentials_store = "file"

[features]
fast_mode = false

EOF
fi

mise install
