return {
  {
    "nvim-tree/nvim-tree.lua", -- Just a dummy dependency to ensure it loads early
    config = function()
      -- Set EJS files to be treated as HTML
      vim.filetype.add({
        extension = {
          ejs = "html",
        },
      })

      -- Autocmd for EJS files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.ejs",
        callback = function()
          vim.bo.filetype = "html"
          -- Force treesitter to use html parser if you have it
          pcall(vim.treesitter.start, 0, "html")
        end,
      })
    end,
  },
}
