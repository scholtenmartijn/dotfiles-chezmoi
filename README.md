# Dotfiles (Chezmoi)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

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
```bash
# Install GPG
sudo apt install gnupg  # Ubuntu/Pop!_OS
brew install gnupg      # macOS

# Generate key
gpg --full-generate-key

# Get key ID
gpg --list-secret-keys --keyid-format=long

# Export public key (add to GitHub/GitLab)
gpg --armor --export <key-id>

# Configure git signing
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
```

### 3. Install Chezmoi
```bash
# Ubuntu/Pop!_OS (recommended)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# macOS
brew install chezmoi
```

Ensure `~/.local/bin` is in your PATH.

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
6. Apply all dotfiles

## What's Included

### Shell
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

### Avante.nvim (AI Assistant)
Set your Anthropic API key:
```bash
export ANTHROPIC_API_KEY="your-api-key"
```

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
├── dot_zshrc.tmpl               # Zsh configuration
├── dot_p10k.zsh                 # Powerlevel10k config
├── dot_gitconfig.tmpl           # Git configuration
└── dot_config/
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
