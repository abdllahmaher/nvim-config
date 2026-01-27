-- ~/.config/nvim/lua/highlights.lua
-- Insert-mode ghost text
vim.api.nvim_set_hl(0, "CmpGhostText", {
  fg = "red",
  bg = "NONE",
  bold = false,
  italic = true,
})

-- Command-line ghost text
vim.api.nvim_set_hl(0, "CmpGhostTextCmd", {
  fg = "#7f848e",
  bg = "green",
  italic = true,
})
