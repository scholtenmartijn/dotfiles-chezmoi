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
- `"linux"` — Ubuntu/Pop!_OS/WSL, CachyOS
- `"darwin"` — macOS

Linux distro: `{{ .chezmoi.osRelease.id }}` → `"ubuntu"`, `"pop"`, `"cachyos"` (or `"arch"`)

Arch-family detection (CachyOS has `ID=cachyos ID_LIKE=arch`; plain Arch has no `ID_LIKE`, hence `index`):
```
{{ if or (eq .chezmoi.osRelease.id "arch") (eq (index .chezmoi.osRelease "idLike" | default "") "arch") }}
```
Install scripts branch three ways inside the `linux` block: ubuntu/pop (apt), arch (`pacman -S --needed --noconfirm`), then darwin (brew). The base script runs `pacman -Syu` first; later scripts rely on that fresh database and must not call `pacman -Sy` themselves (partial upgrade).

Git identity (`.name`, `.email`, `.signingkey`) comes from `[data]` in `.chezmoi.toml.tmpl`: it is read from an existing global git config at `chezmoi init` time and only prompted (`promptStringOnce`) when missing. `dot_gitconfig.tmpl` enables GPG signing only when `.signingkey` is set.

## Architecture

```
.
├── run_once_before_install-base.sh.tmpl   # Base packages (apt/pacman/brew)
├── run_once_install-ohmyzsh.sh.tmpl       # Oh-My-Zsh + Powerlevel10k
├── run_once_install-devtools.sh.tmpl      # kubectl, docker, az, aws, claude-code
├── run_once_install-neovim.sh.tmpl        # Neovim + build from source
├── run_once_install-opencode.sh.tmpl      # opencode AI agent (--no-modify-path)
├── run_once_install-worktrunk.sh.tmpl     # worktrunk `wt` (brew/pacman/cargo; no shell install)
├── dot_zshrc.tmpl                         # Zsh config (templated; sources ~/.zshrc.d/*.zsh)
├── dot_zshrc.d/                           # Modular zsh fragments (one file per tool)
│   ├── opencode.zsh                       # opencode PATH + alias
│   └── worktrunk.zsh                      # wt shell init + wta/wtj/wtprune cross-repo helpers
├── dot_p10k.zsh                           # Powerlevel10k prompt config
├── dot_gitconfig.tmpl                     # Git config (templated for credential helper)
└── dot_config/
    ├── alacritty/alacritty.toml           # Terminal: Tokyo Night theme, MesloLGS NF
    ├── worktrunk/config.toml              # wt worktree path (not .tmpl: {{ }} is wt syntax)
    ├── hypr/                              # Hyprland (Linux only, native Lua config; CachyOS + Noctalia)
    │   ├── hyprland.lua                   # Entry point, requires config/*.lua in order
    │   └── config/binds.lua               # Keybindings: mirrors dot_aerospace.toml with SUPER instead of Alt
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
