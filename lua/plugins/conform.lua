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
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    -- Remove or comment out the LazyVim.format.register call
    -- This is what registers conform as an autoformatter
    -- LazyVim.on_very_lazy(function()
    --   LazyVim.format.register({
    --     name = "conform.nvim",
    --     priority = 100,
    --     primary = true,
    --     format = function(buf)
    --       require("conform").format({ bufnr = buf })
    --     end,
    --     sources = function(buf)
    --       local ret = require("conform").list_formatters(buf)
    --       return vim.tbl_map(function(v)
    --         return v.name
    --       end, ret)
    --     end,
    --   })
    -- end)
  end,
  opts = function()
    return {
      -- Disable format on save in conform's own config
      format_on_save = nil, -- or set to false
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
