# Chezmoi Setup Agent Instructions

## Core Principles

### Command Execution Rules
- **NEVER execute git commands automatically** - always present git commands for user to run manually
- **NEVER execute bash commands automatically** - always show commands and wait for user confirmation
- **ALWAYS show the command first** and explain what it does before user executes it
- Present commands in copy-paste ready format with explanations

### User Context
- Platform/DevOps Engineer with Software Engineering background
- Works with: Golang, Python, YAML
- Manages: OpenShift/Kubernetes clusters, Azure infrastructure, Terraform
- Multi-platform environment: Ubuntu (Pop!_OS + WSL), macOS M2
- Uses conventional commits and structured DevOps workflows

## Project Goal

Set up a chezmoi-managed dotfiles repository that:
1. Works seamlessly across Ubuntu-based systems (Pop!_OS, WSL) and macOS
2. Includes automated tool installation via run_once scripts
3. Provides production-ready development environment
4. Can be deployed to new machines with single command: `chezmoi init --apply <repo-url>`

## Required Tools & Configuration

### Prerequisites/Bootstrap
The following must be set up manually before running `chezmoi init --apply`:

**1. Git Configuration:**
```bash
# Install git (if not present)
sudo apt install git  # Ubuntu/Pop!_OS
brew install git      # macOS

# Configure git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**2. GPG Key Setup:**
```bash
# Install GPG (if not present)
sudo apt install gnupg  # Ubuntu/Pop!_OS
brew install gnupg      # macOS

# Generate a new GPG key
gpg --full-generate-key

# List keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export public key (for adding to GitHub/GitLab)
gpg --armor --export <key-id>

# Configure git to use GPG signing
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
```

**3. Chezmoi Installation:**

*Ubuntu/Pop!_OS:*
```bash
# Official install script (recommended)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# Or via snap
sudo snap install chezmoi --classic

# Or via apt (may not be latest version)
sudo apt install chezmoi
```

*macOS:*
```bash
# Via Homebrew
brew install chezmoi
```

Ensure `~/.local/bin` is in your PATH before proceeding. After all prerequisites are configured, bootstrap the full environment with:
```bash
chezmoi init --apply <repo-url>
```

### Initial Installation (Ubuntu-based systems)
The `run_once` script should install:
- **oh-my-zsh** - shell framework
- **powerlevel10k** - zsh theme
- **neovim** - primary editor (aliased as `v`)
- **kubectl** - Kubernetes CLI (aliased as `k`)
- **kubens/kubectx** - Kubernetes context/namespace switcher
- **docker** - container runtime
- **claude-code** - AI coding assistant
- **azure-cli** - Azure cloud management CLI
- **aws-cli** - AWS cloud management CLI

### Neovim Configuration Requirements
Must be **production-ready** for immediate development work with:

**Language Support:**
- Golang (LSP, debugging, testing, formatting)
- Python (LSP, linting, formatting, virtual env support)
- YAML (LSP with Kubernetes schema validation)

**Core Features:**
- Modern plugin manager (lazy.nvim preferred)
- LSP configuration with auto-completion
- Syntax highlighting (treesitter)
- File explorer (neo-tree or nvim-tree)
- Fuzzy finder (telescope.nvim)
- Git integration (gitsigns, fugitive)
- Status line (lualine)
- Auto-formatting on save
- Code navigation (go to definition, references, etc.)
- Diagnostic display (errors, warnings)
- Terraform/HCL support (bonus)
- Markdown preview (bonus)

**AI Integration:**
- avante.nvim - AI-powered coding assistant (Cursor-like experience in Neovim)
  - Chat interface for code questions and generation
  - Inline code suggestions and completions
  - Code explanation and refactoring assistance
  - Configure with preferred AI provider (Anthropic Claude recommended)

### Oh-My-Zsh Configuration Requirements

**Theme:**
- powerlevel10k with sensible defaults for DevOps work
- Show: git status, kubectl context, current directory, exit codes

**Essential Plugins:**
- git - git aliases and completions
- kubectl - kubectl aliases and completions
- kubectx - context switching completions
- docker - docker completions
- terraform - terraform completions (if available)
- aws - AWS CLI completions and aliases
- azure - Azure CLI completions
- command-not-found - suggests package for unknown commands
- zsh-autosuggestions - fish-like autosuggestions
- zsh-syntax-highlighting - command syntax highlighting

**Required Aliases:**
```bash
alias v='nvim'
alias k='kubectl'
```

**Additional Useful Aliases** (suggest to user):
```bash
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kl='kubectl logs'
alias kdesc='kubectl describe'
alias kctx='kubectx'
alias kns='kubens'
alias tf='terraform'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias dc='docker compose'
alias dps='docker ps'
```

## Chezmoi Structure Requirements

### Directory Layout
```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                    # Chezmoi config with OS detection
├── .chezmoiignore                        # Platform-specific ignores
├── run_once_before_install-base.sh.tmpl  # Base system packages
├── run_once_install-ohmyzsh.sh.tmpl      # Oh-my-zsh + powerlevel10k
├── run_once_install-devtools.sh.tmpl     # kubectl, docker, claude-code
├── run_once_install-neovim.sh.tmpl       # Neovim installation
├── dot_zshrc.tmpl                        # Zsh configuration
├── dot_p10k.zsh.tmpl                     # Powerlevel10k config
├── dot_gitconfig.tmpl                    # Git configuration
├── dot_config/
│   ├── nvim/
│   │   ├── init.lua                      # Main neovim config
│   │   ├── lua/
│   │   │   ├── plugins/                  # Plugin configurations
│   │   │   ├── lsp/                      # LSP configurations
│   │   │   └── config/                   # General settings
│   └── k9s/                              # K9s configuration (if used)
└── README.md                             # Setup instructions
```

### Platform Detection
Use chezmoi templates to detect OS:
```
{{ if eq .chezmoi.os "linux" }}
  {{ if eq .chezmoi.osRelease.id "ubuntu" "pop" }}
    # Ubuntu/Pop!_OS specific
  {{ end }}
{{ else if eq .chezmoi.os "darwin" }}
  # macOS specific
{{ end }}
```

## Script Requirements

### run_once Scripts Best Practices
- Check if tool already exists before installing
- Use idempotent operations
- Include error handling
- Show clear progress messages
- Install from official sources when possible
- Pin versions where stability matters (kubernetes tools)

### Installation Script Template Pattern
```bash
#!/bin/bash
set -e

echo "Installing <tool-name>..."

if command -v <tool> &> /dev/null; then
    echo "✓ <tool> already installed"
    exit 0
fi

# Installation logic here

echo "✓ <tool> installed successfully"
```

## Agent Workflow

### When Creating Files
1. **Explain** what the file does and why it's structured this way
2. **Show** the complete file content
3. **Suggest** the command to create it: `chezmoi add <file>`
4. **Wait** for user to execute

### When Suggesting Changes
1. **Describe** what needs to change and why
2. **Show** the diff or new content
3. **Provide** the exact command to apply changes
4. **Wait** for user confirmation

### When Installing Tools
1. **Never run installation commands** - show them instead
2. **Explain** what each command does
3. **Group** related installations logically
4. **Provide** verification commands to check installation

### Iterative Development Process
1. Start with basic structure and essential files
2. Test on user's Pop!_OS desktop first
3. Refine based on user feedback
4. Add platform-specific variations as needed
5. Only commit to git when user explicitly requests it

## Response Format

### For File Creation
```
I'll create <filename> which handles <purpose>.

<explanation of structure and choices>

File content:
---
<file content>
---

To add this to chezmoi:
```bash
chezmoi add <filepath>
```

Would you like me to proceed with the next file?
```

### For Commands
```
To <accomplish task>, run:

```bash
<command>
```

This will <explanation of what command does>.

After running this, you can verify with:
```bash
<verification command>
```
```

### For Git Operations
```
When you're ready to commit these changes:

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "feat: <description>"
git push origin main
```
```

## Quality Checklist

Before suggesting any configuration is complete, verify:

- [ ] Run_once scripts are idempotent
- [ ] Platform detection works for Ubuntu/Pop!_OS/WSL/macOS
- [ ] All required tools are included
- [ ] Neovim is production-ready (LSP + formatting + navigation work)
- [ ] Oh-my-zsh has all required plugins
- [ ] Aliases `v` and `k` are configured
- [ ] No hardcoded paths that differ between systems
- [ ] README.md documents the setup process
- [ ] No automatic command execution in suggestions

## Troubleshooting Guidelines

When user encounters issues:
1. Ask for specific error messages
2. Suggest diagnostic commands (not auto-run them)
3. Explain likely causes
4. Provide solution commands for user to run
5. Offer to adjust configuration if needed

## Security Considerations

- Never include sensitive data in dotfiles
- Use chezmoi's `private_` prefix for SSH configs
- Template out machine-specific values (email, username)
- Suggest using `chezmoi secret` for credentials if needed
- Exclude `.env` files by default in `.chezmoiignore`

## Success Criteria

Setup is complete when user can:
1. Run `chezmoi init --apply <repo>` on fresh Ubuntu/macOS machine
2. Have fully functional development environment in < 10 minutes
3. Open nvim and immediately start coding Go/Python/YAML
4. Use kubectl with proper completions and context switching
5. Have consistent shell experience across all machines

## Notes
- User prefers seeing all commands before execution
- User values understanding over automation
- User will handle git operations manually
- User wants production-ready configs, not minimal examples