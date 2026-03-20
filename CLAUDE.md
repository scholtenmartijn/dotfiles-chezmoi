# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Key Principle

**Never execute commands automatically.** Always present commands for the user to run manually. This includes git operations, shell commands, and chezmoi operations. Show the command, explain what it does, then wait for the user.

## What This Repo Is

Chezmoi-managed dotfiles for a Platform/DevOps engineer. Changes here are applied to the live system via chezmoi. The repo is bootstrapped on new machines with:

```bash
chezmoi init --apply mrcontainer/dotfiles-chezmoi
```

## Chezmoi Workflow

Apply changes after editing files in this repo:
```bash
chezmoi apply
```

Preview what would change without applying:
```bash
chezmoi diff
chezmoi apply --dry-run --verbose
```

Pull and apply latest from remote:
```bash
chezmoi update
```

Reset chezmoi state for testing (destructive — confirm with user before suggesting):
```bash
rm -rf ~/.local/share/chezmoi ~/.config/chezmoi
chezmoi init --apply .
```

## File Naming Conventions (Chezmoi)

| Prefix/Suffix | Meaning |
|---|---|
| `dot_` | Becomes `.` (e.g., `dot_zshrc` → `~/.zshrc`) |
| `.tmpl` | Go template — processed by chezmoi before applying |
| `run_once_` | Script run exactly once per machine |
| `run_once_before_` | Run once, before other files are applied |

## Template Variables

Chezmoi templates use `{{ .chezmoi.os }}` for platform detection:
- `"linux"` — Ubuntu/Pop!_OS/WSL
- `"darwin"` — macOS

Linux distro: `{{ .chezmoi.osRelease.id }}` → `"ubuntu"` or `"pop"`

## Architecture

```
.
├── run_once_before_install-base.sh.tmpl   # Base packages (apt/brew)
├── run_once_install-ohmyzsh.sh.tmpl       # Oh-My-Zsh + Powerlevel10k
├── run_once_install-devtools.sh.tmpl      # kubectl, docker, az, aws, claude-code
├── run_once_install-neovim.sh.tmpl        # Neovim + build from source
├── dot_zshrc.tmpl                         # Zsh config (templated, platform-aware)
├── dot_p10k.zsh                           # Powerlevel10k prompt config
├── dot_gitconfig.tmpl                     # Git config (templated for credential helper)
└── dot_config/
    ├── alacritty/alacritty.toml           # Terminal: Tokyo Night theme, MesloLGS NF
    └── nvim/
        ├── init.lua                        # Bootstraps lazy.nvim, sets leader key
        └── lua/
            ├── config/options.lua          # Neovim options
            ├── config/keymaps.lua          # Key mappings (leader = Space)
            └── plugins/
                ├── init.lua                # Plugin list (lazy.nvim)
                ├── lsp.lua                 # LSP: Go, Python, YAML, Lua, Terraform, Bash
                ├── formatting.lua          # conform.nvim (format-on-save)
                ├── avante.lua              # AI assistant (Anthropic Claude)
                └── go.lua                  # Go-specific plugins
```

## run_once Script Pattern

All install scripts follow this idempotent pattern:

```bash
#!/bin/bash
set -e

if command -v <tool> &> /dev/null; then
    echo "✓ <tool> already installed"
    exit 0
fi

# Installation logic
```

Scripts must be idempotent — they run once per machine based on content hash.

## Conventional Commits

Use conventional commit format: `feat:`, `fix:`, `chore:`, etc.

## User Context

- Platform/DevOps engineer; primary languages: Go, Python, YAML
- Targets: Ubuntu (Pop!_OS + WSL) and macOS M2
- Manages OpenShift/Kubernetes, Azure, Terraform
- Wants to understand changes before executing them
