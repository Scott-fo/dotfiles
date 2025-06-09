return {
 --[["yetone/avante.nvim"],
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "openai",
    providers = {
      openai = {
        api_key_name = {"op", "item", "get", "OPEN_AI_KEY", "--reveal", "--fields", "label=password"},
        endpoint = "https://api.openai.com/v1",
        model = "o4-mini", 
        timeout = 30000, 
        extra_request_body = {
          temperature = 0,
          max_completion_tokens = 8192,
          reasoning_effort = "high",
        },
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },]]
}
