return {
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      cli = {
        win = {
          layout = "right",
          split = { width = 60 },
        },
        tools = {
          claude = { cmd = { "claude" } },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Toggle AI (Sidekick)",
        mode = { "n", "t" },
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send file to AI",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        desc = "Send selection to AI",
        mode = { "v" },
      },
    },
  },
}
