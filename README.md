# Dotfiles (Chezmoi)

> **Warning**
> This is a personal development environment configuration. Use at your own risk. These dotfiles will install software and modify system configurations. Review the scripts before running on your machine.

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Install (From Scratch)

Bootstrap a new machine with a single command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mrcontainer/dotfiles-chezmoi
```

After installation, set zsh as default and restart your session:
```bash
chsh -s $(which zsh)
```

## Testing / Reset Chezmoi

To reset chezmoi and start fresh (useful for testing):

```bash
# Remove chezmoi state and source directory
rm -rf ~/.local/share/chezmoi ~/.config/chezmoi

# Remove applied dotfiles (optional - be careful!)
rm -rf ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.config/nvim ~/.config/alacritty

# Re-initialize from local repo (from your dotfiles-chezmoi directory)
chezmoi init --apply .

# Or re-initialize from remote
chezmoi init --apply mrcontainer/dotfiles-chezmoi
```

To see what chezmoi would change without applying:
```bash
chezmoi diff
```

To run a dry-run of the apply:
```bash
chezmoi apply --dry-run --verbose
```

## Prerequisites

Before bootstrapping, ensure you have the following set up:

### 1. Git Configuration
```bash
# Install git
sudo apt install git  # Ubuntu/Pop!_OS
brew install git      # macOS

# Configure identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. GPG Key (for signed commits)

GPG is installed automatically via the base packages script (`gnupg` + `pinentry-mac` on macOS).

```bash
# Generate key (use RSA 4096, your GitHub email)
gpg --full-generate-key

# Get key ID (long hex after "sec rsa4096/")
gpg --list-secret-keys --keyid-format=long

# Export public key — add this to GitHub → Settings → SSH and GPG keys
gpg --armor --export <key-id>

# Configure git signing
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
```

**macOS only** — configure pinentry-mac so GPG can prompt for your passphrase:
```bash
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

### 3. MesloLGS NF Font
Required for Powerlevel10k and Alacritty. Download from [powerlevel10k-media](https://github.com/romkatv/powerlevel10k-media) or install via `brew install --cask font-meslo-lg-nerd-font` on macOS.

### 4. Install Chezmoi
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin  # Ubuntu/Pop!_OS
brew install chezmoi                                      # macOS
```

## Quick Start

Bootstrap a new machine with a single command:

```bash
chezmoi init --apply <repo-url>
```

This will:
1. Clone this repository
2. Install base system packages
3. Install and configure Oh-My-Zsh with Powerlevel10k
4. Install development tools (kubectl, docker, azure-cli, aws-cli, claude-code)
5. Install and configure Neovim with LSP, treesitter, and plugins
6. Configure Alacritty terminal (Tokyo Night theme)
7. Install AeroSpace tiling window manager (macOS)
8. Install Karabiner-Elements key remapping (macOS)
9. Apply all dotfiles

## Post-Install Steps

After the initial setup, run the following to set zsh as your default shell:

```bash
chsh -s $(which zsh)
```

Then **log out and log back in** (or reboot) for the change to take effect.

## What's Included

### Terminal
- **Alacritty** - GPU-accelerated terminal with Tokyo Night theme
- **Oh-My-Zsh** with Powerlevel10k theme
- Plugins: git, kubectl, kubectx, docker, terraform, aws, azure, zsh-autosuggestions, zsh-syntax-highlighting
- Useful aliases for kubectl, terraform, docker, git, and more

### Development Tools
- **Neovim** - Primary editor with full IDE features
- **kubectl** - Kubernetes CLI
- **kubectx/kubens** - Kubernetes context/namespace switcher
- **Docker** - Container runtime
- **Azure CLI** - Azure cloud management
- **AWS CLI** - AWS cloud management
- **Claude Code** - AI coding assistant

### macOS Desktop (darwin only)
- **AeroSpace** - Tiling window manager (i3-like)
- **Karabiner-Elements** - Key remapping (Linux-style Ctrl shortcuts)

### Neovim Features
- **Plugin Manager**: lazy.nvim
- **Theme**: Catppuccin Mocha
- **File Explorer**: nvim-tree
- **Fuzzy Finder**: Telescope
- **Git Integration**: gitsigns, fugitive
- **LSP Support**: Go, Python, YAML, Lua, Terraform, Docker, Bash
- **Auto-completion**: nvim-cmp with snippets
- **Formatting**: conform.nvim with format-on-save
- **Linting**: nvim-lint
- **AI Assistant**: avante.nvim (Claude integration)
- **Debugging**: nvim-dap with Go support
- **Treesitter**: Syntax highlighting and code navigation

### Key Aliases
```bash
v       -> nvim
k       -> kubectl
kgp     -> kubectl get pods
kctx    -> kubectx
kns     -> kubens
tf      -> terraform
dc      -> docker compose
```

## Neovim Keybindings

### General
| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `jk` | Exit insert mode |

### File Navigation
| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>f` | Format |

### Git
| Key | Action |
|-----|--------|
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### Debugging
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>du` | Toggle DAP UI |

## Customization

### Karabiner-Elements (macOS Key Remapping)

Provides Linux-style keyboard shortcuts on macOS:

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Copy (everywhere) |
| `Ctrl+V` | Paste (everywhere) |
| `Ctrl+X` | Cut (everywhere) |
| `Ctrl+Space` | Spotlight / search |
| `Cmd+C` | SIGINT in terminals (stop process) |

#### Required macOS Setting

Disable the default Ctrl+Space input source shortcut, otherwise macOS intercepts it before Karabiner:

```
System Settings → Keyboard → Keyboard Shortcuts → Input Sources
→ Uncheck "Select the previous input source" (^Space)
```

#### Post-Install

Grant accessibility permissions when prompted:
```
System Settings → Privacy & Security → Accessibility → Enable Karabiner components
```

### Avante.nvim (AI Assistant)
Set your Anthropic API key:
```bash
export ANTHROPIC_API_KEY="your-api-key"
```

### AeroSpace (macOS Tiling Window Manager)

i3-inspired tiling window manager. Starts at login automatically.

| Key | Action |
|-----|--------|
| `Alt+H/J/K/L` | Focus window (vim-style) |
| `Alt+Shift+H/J/K/L` | Move window |
| `Alt+1-0` | Switch workspace 1–10 |
| `Alt+Shift+1-0` | Move window to workspace |
| `Alt+F` | Fullscreen |
| `Alt+/` | Toggle tiles layout |
| `Alt+,` | Toggle accordion layout |
| `Alt+-` / `Alt+=` | Resize smaller / larger |
| `Alt+Tab` | Switch to previous workspace |
| `Alt+Shift+Tab` | Move workspace to next monitor |
| `Alt+Shift+;` | Enter service mode |

**Service mode** (`Alt+Shift+;`):
| Key | Action |
|-----|--------|
| `Esc` | Reload config & exit |
| `R` | Flatten workspace tree |
| `F` | Toggle floating/tiling |
| `Backspace` | Close all windows but current |

Workspaces 1–5 are pinned to the main monitor, 6–10 to secondary.

### Powerlevel10k
Run `p10k configure` to customize the prompt.

### Git Config
Edit `~/.gitconfig` to set your email and GPG signing key.

## Directory Structure

```
.
├── .chezmoi.toml.tmpl           # Chezmoi configuration
├── .chezmoiignore               # Files to ignore
├── run_once_before_install-base.sh.tmpl
├── run_once_install-ohmyzsh.sh.tmpl
├── run_once_install-devtools.sh.tmpl
├── run_once_install-neovim.sh.tmpl
├── run_once_install-karabiner.sh.tmpl
├── run_once_install-aerospace.sh.tmpl
├── run_once_install-opencode.sh.tmpl
├── dot_zshrc.tmpl               # Zsh configuration (sources ~/.zshrc.d/*.zsh)
├── dot_zshrc.d/                 # Modular zsh fragments (one file per tool)
│   └── opencode.zsh
├── dot_p10k.zsh                 # Powerlevel10k config
├── dot_gitconfig.tmpl           # Git configuration
├── dot_aerospace.toml           # AeroSpace tiling WM config
└── dot_config/
    ├── alacritty/
    │   └── alacritty.toml           # Terminal config (Tokyo Night)
    ├── karabiner/
    │   └── karabiner.json           # Key remapping (Linux-style shortcuts)
    └── nvim/
        ├── init.lua
        └── lua/
            ├── config/
            │   ├── options.lua
            │   └── keymaps.lua
            └── plugins/
                ├── init.lua
                ├── lsp.lua
                ├── formatting.lua
                ├── avante.lua
                └── go.lua
```

## Supported Platforms

- Ubuntu / Pop!_OS
- WSL (Ubuntu-based)
- macOS (Apple Silicon / Intel)

## Updating

Pull the latest changes and apply:
```bash
chezmoi update
```

Or manually:
```bash
chezmoi git pull
chezmoi apply
```
