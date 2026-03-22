return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      {
        "<M-g>",
        function()
          require("snacks").lazygit()
        end,
        mode = { "n", "i" },
        desc = "Lazygit",
      },
      {
        "<leader>e",
        function()
          require("snacks").explorer()
        end,
        desc = "Explorer",
      },
    },
  },
}
