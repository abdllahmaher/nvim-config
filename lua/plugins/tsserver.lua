return {
  "neovim/nvim-lspconfig",
  ft = { "typescript", "javascript" },
  config = function()
    require("lspconfig").tsserver.setup({})
  end,
}
