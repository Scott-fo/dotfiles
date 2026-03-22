return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
    },
    keys = {
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
