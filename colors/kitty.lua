-- ~/.config/nvim/colors/kitty.lua
local function setup()
  vim.o.termguicolors = true
  
  -- Clear existing highlights
  vim.cmd("hi clear")
  
  -- Set syntax groups to use terminal colors (empty table = inherit from terminal)
  local groups = {
    "Normal", "NonText", "Comment", "Constant", "String", "Character",
    "Number", "Boolean", "Float", "Function", "Identifier", "Statement",
    "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception",
    "PreProc", "Include", "Define", "Macro", "PreCondit", "Type",
    "StorageClass", "Structure", "Typedef", "Special", "SpecialChar",
    "Tag", "Delimiter", "SpecialComment", "Debug", "Underlined", "Ignore",
    "Error", "Todo", "qfLineNr", "qfFileName", "Directory", "Title"
  }
  
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, {})
  end
  
  -- Set specific colors for better visibility using your Kitty colors
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#322e41" })  -- color234
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#48454e" })      -- color245
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ebd1da", bold = true })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#4b465b" })       -- color252
  vim.api.nvim_set_hl(0, "Search", { bg = "#ffdce8", fg = "#1b1a20" }) -- color3
  
  -- Let Treesitter handle the rest with terminal colors
  vim.cmd("hi! link @variable Normal")
  vim.cmd("hi! link @function Function")
  vim.cmd("hi! link @keyword Keyword")
  vim.cmd("hi! link @string String")
  vim.cmd("hi! link @comment Comment")
  vim.cmd("hi! link @type Type")
  vim.cmd("hi! link @constant Constant")
  vim.cmd("hi! link @operator Operator")
end

setup()
