-- return {
--   {
--     "hrsh7th/nvim-cmp",
--     -- event = "InsertEnter",
--     enabled = true,
--     lazy = false;
--     opts = function(_, opts)
--       -- REQUIRED: define sources
--       opts.sources = opts.sources
--         or {
--           { name = "nvim_lsp" },
--           { name = "luasnip" },
--           { name = "buffer" },
--           { name = "path" },
--         }
--
--       -- ensure formatting table exists (prevents crashes)
--       opts.formatting = opts.formatting or {}
--       opts.window = {
--         completion = {
--           border = "none",
--           winhighlight = "", -- empty disables all menu highlights
--         },
--         documentation = require("cmp").config.window.bordered(),
--       }
--
--       return opts
--     end,
--   },
--
--   {
--     "hrsh7th/cmp-nvim-lsp",
--     dependencies = { "hrsh7th/nvim-cmp" },
--   },
--
--   {
--     "L3MON4D3/LuaSnip",
--     event = "InsertEnter",
--   },
--
--   {
--     "saadparwaiz1/cmp_luasnip",
--     dependencies = {
--       "hrsh7th/nvim-cmp",
--       "L3MON4D3/LuaSnip",
--     },
--   },
--
-- }
return {
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    lazy = false,
    opts = function(_, opts)
      -- enable ghost text
      --
      
      --
      --
      opts.experimental = opts.experimental or {}
      opts.experimental.ghost_text = true

      -- optional: ensure window and formatting tables exist
      opts.window = opts.window or {}
      opts.window.completion = opts.window.completion or { border = "none" }
      opts.window.documentation = opts.window.documentation or require("cmp").config.window.bordered()

      opts.formatting = opts.formatting or {}
      return opts
    end,
  },

  { "hrsh7th/cmp-nvim-lsp", dependencies = { "hrsh7th/nvim-cmp" } },
  { "L3MON4D3/LuaSnip", event = "InsertEnter" },
  { "saadparwaiz1/cmp_luasnip", dependencies = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" } },
}
--
