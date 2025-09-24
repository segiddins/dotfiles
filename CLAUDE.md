# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed by **chezmoi**. It templates and applies configuration files to `~/.

## Key Commands

```bash
chezmoi apply              # Apply all dotfiles to home directory
chezmoi diff               # Preview pending changes
chezmoi edit <file>        # Edit a managed file
chezmoi add <file>         # Add a new file to chezmoi management
chezmoi data               # View template data
```

## Chezmoi File Naming Conventions

- `dot_*` → `~/.*` (e.g., `dot_gitconfig.tmpl` → `~/.gitconfig`)
- `private_dot_*` → encrypted sensitive configs
- `*.tmpl` → Go template files, processed with data from `.chezmoidata.toml`
- `run_before_*` / `run_after_*` → lifecycle scripts run during `chezmoi apply`
- `run_once_*` → runs only on first apply; `run_onchange_*` → runs when content hash changes
- `executable_*` → files that should be chmod +x
- `symlink_*` → symlink definitions
- `encrypted_*` → age-encrypted files

## Templating

Templates use Go template syntax with variables from `.chezmoidata.toml` (e.g., `{{ .email }}`, `{{ .personal }}`, `{{ .server }}`). Chezmoi built-ins like `{{ .chezmoi.homeDir }}` are also available.

## Encryption

Uses **age** encryption. Key stored at `~/.config/age/chezmoi_key.txt`, configured in `.chezmoi.toml.tmpl`.

## Key Files

- `.chezmoidata.toml` — template variables (name, email, flags)
- `.chezmoiexternal.toml` — external resources fetched during apply
- `.chezmoiignore` — files excluded from apply
- `dot_Brewfile.tmpl` — Homebrew packages (triggers `run_onchange_after_brew_bundle.sh.tmpl`)
- `dot_zshrc.tmpl` / `dot_zshenv.tmpl` — shell configuration (znap plugin manager)
- `dot_gitconfig.tmpl` — git configuration
- `private_dot_config/jj/config.toml.tmpl` — jj (Jujutsu) VCS configuration with extensive aliases
