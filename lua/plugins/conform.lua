return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    -- Completely disable format on save
    format_on_save = false,
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      -- lua = { "stylua" },
      fish = { "fish_indent" },
      sh = { "shfmt" },
      -- Don't add cpp here - let manual formatting handle it
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  },
}
