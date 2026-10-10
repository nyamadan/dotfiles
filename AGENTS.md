# Repository guidance

- Keep `install.sh` for the regular Nix environment and
  `.devcontainer/install.sh` for the mise based Dev Container.
- Setup scripts must be safe to run repeatedly. Avoid duplicate shell
  initialization, configuration lines, clones, and package installs.
- Preserve existing user configuration. Copy missing files only; warn when
  an existing file differs. Add Git defaults only for unset keys.
- Do not recursively change ownership of the persisted `.codex` directory.
- Keep `rm` mapped to `trash-put` in `.bash_aliases`; retain `rm-force`
  for explicit permanent deletion.
