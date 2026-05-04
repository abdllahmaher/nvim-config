return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Add keymap to toggle inlay hints
      vim.keymap.set("n", "<leader>th", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
        vim.notify("Inlay hints " .. (not enabled and "enabled" or "disabled"))
      end, { desc = "Toggle inlay hints" })
    end,
  },
}
