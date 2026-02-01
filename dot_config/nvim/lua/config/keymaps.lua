local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General keymaps
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Tab management
keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Move lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Better paste (don't yank replaced text)
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Copy to system clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete without yanking
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Quick save
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- Escape in insert mode
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
