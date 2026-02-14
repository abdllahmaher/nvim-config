-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Fix double completion menu issue
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumblend = 0 -- Make completion menu opaque (0-100 for transparency)
vim.opt.wildmode = "longest:full,full" -- Or disable completely with {}

-- Optional: Ensure wildmenu doesn't show in insert mode
vim.cmd([[
  autocmd InsertEnter * set wildmenu&
  autocmd InsertLeave * set wildmenu
]])
-- Disable blink.cmp if it's loaded
vim.cmd([[
  autocmd VimEnter * if exists('g:loaded_blink_cmp') | let g:blink_cmp_enabled = 0 | endif
]])
vim.notify("Welcome back, Commander")

-- Disable all automatic formatting
vim.g.autoformat_enabled = false
vim.g.format_on_save = false
-- Place this in your options or after LSP setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Disable format-on-type
    vim.lsp.handlers["textDocument/onTypeFormatting"] = function() end
  end,
})
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/user/snippets" })

