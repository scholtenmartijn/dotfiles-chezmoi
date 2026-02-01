local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of word
opt.iskeyword:append("-")

-- Disable swapfile
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Scrolloff
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Update time
opt.updatetime = 50

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Mouse
opt.mouse = "a"

-- Command line height
opt.cmdheight = 1

-- Show matching brackets
opt.showmatch = true

-- Timeout for key sequences
opt.timeoutlen = 300
