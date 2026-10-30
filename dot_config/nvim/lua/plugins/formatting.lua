return {
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go = { "gofumpt", "goimports" },
          python = { "black", "isort" },
          lua = { "stylua" },
          yaml = { "yamlfmt" },
          json = { "jq" },
          terraform = { "terraform_fmt" },
          hcl = { "terraform_fmt" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          markdown = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
        python = { "pylint", "mypy" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
        terraform = { "tflint" },
      }

      -- Drop "line too long" diagnostics. yamllint defaults to 80 columns and
      -- pylint to 100, which fires on nearly every k8s manifest and Helm values
      -- file. Prepended so nvim-lint's own default args are preserved.
      table.insert(lint.linters.yamllint.args, 1, "{extends: default, rules: {line-length: disable}}")
      table.insert(lint.linters.yamllint.args, 1, "-d")
      table.insert(lint.linters.pylint.args, 1, "--disable=line-too-long")

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Mason tool installer (formatters and linters)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Go
          "gofumpt",
          "goimports",
          "golangci-lint",
          -- Python
          "black",
          "isort",
          "pylint",
          "mypy",
          -- Lua
          "stylua",
          -- YAML
          "yamlfmt",
          "yamllint",
          -- JSON
          "jq",
          -- Shell
          "shfmt",
          -- Docker
          "hadolint",
          -- Terraform
          "tflint",
          -- Markdown
          "prettier",
        },
      })
    end,
  },
}
