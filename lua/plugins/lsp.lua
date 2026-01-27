-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         -- JavaScript / TypeScript
--         tsserver = {},
--
--         -- Python
--         pyright = {},
--
--         -- C / C++
--         clangd = {},
--
--         -- HTML
--         html = {},
--
--         -- CSS
--         cssls = {},
--       },
--     },
--   },
-- }
--
--
-- config/lsp.lua
local lspconfig = require("lspconfig")

-- REQUIRED for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python
lspconfig.pyright.setup({
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
})

-- JavaScript / TypeScript (browser)
lspconfig.vtsls.setup({
  capabilities = capabilities,
  root_dir = function()
    return vim.fn.getcwd()
  end,
  flags = {
    debounce_text_changes = 150,
  },
})

-- CSS / SCSS / LESS (colors come from here)
lspconfig.cssls.setup({
  capabilities = capabilities,
})

-- diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})
