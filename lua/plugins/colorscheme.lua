-- return {
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     lazy = false,
--     priority = 1000,
--     opts = {
--       transparent_background = true,
--       integrations = {
--         cmp = true,
--         telescope = true,
--         treesitter = true,
--         native_lsp = {
--           enabled = true,
--         },
--       },
--     },
--     config = function(_, opts)
--       require("catppuccin").setup(opts)
--       vim.cmd.colorscheme("catppuccin-mocha")
--     end,
--   },
-- }

-- return {
--   {
--     "Tsuzat/NeoSolarized.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("NeoSolarized").setup({
--         style = "dark",
--         transparent = true,
--         terminal_colors = true,
--         enable_italics = true,
--       })

--       vim.cmd.colorscheme("NeoSolarized")
--     end,
--   },
-- }
return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        variant = "default", -- or "auto"
        transparent = true, -- THIS is what you missed
        terminal_colors = true,

        extensions = {
          cmp = true,
          blinkcmp = true,
          telescope = true,
          mini = true,
          notify = true,
          gitsigns = true,
        },
      })

      vim.cmd.colorscheme("cyberdream")

      vim.cmd([[
  highlight! link CmpItemAbbr Normal
  highlight! link CmpItemAbbrMatch Keyword
  highlight! link CmpItemKind Type
  highlight! link CmpItemMenu Comment
]])
    end,
  },
}
