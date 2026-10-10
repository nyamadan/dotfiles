#! /bin/bash

set -eux

echo 'eval "$(mise activate bash)"' >> ~/.bashrc

cat << EOF >> ~/.npmrc
min-release-age=7
ignore-scripts=true
EOF

sudo mkdir -p ~/.codex
sudo chown -R "$(id -u):$(id -g)" ~/.codex
# 永続化した設定は再作成時にも保持する。
if [ ! -e ~/.codex/config.toml ]; then
cat << EOF > ~/.codex/config.toml

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

