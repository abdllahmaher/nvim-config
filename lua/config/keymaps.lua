-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here-- Add this to your keymaps.lua or wherever you define keymaps
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- format using conform
vim.keymap.set("v", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format selection" })
-- toggle relative numbers
vim.keymap.set("n", "<leader>cn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })

-- Next buffer: <Space> + Right Arrow
vim.keymap.set("n", "<Space><Right>", ":bnext<CR>", {
  noremap = true,
  silent = true,
  desc = "Next buffer",
})

-- Previous buffer: <Space> + Left Arrow
vim.keymap.set("n", "<Space><Left>", ":bprevious<CR>", {
  noremap = true,
  silent = true,
  desc = "Previous buffer",
})

-- Close current buffer: <Space> + q
vim.keymap.set("n", "<Space>q", function()
  Snacks.bufdelete({ force = false })
end, { desc = "Close buffer (keep focus)" })
local ls = require("luasnip")
vim.keymap.set({"i","s"}, "<Tab>", function()
    if ls.expand_or_jumpable() then
        return ls.expand_or_jump()
    else
        return "<Tab>"
    end
end, {expr=true, silent=true})

vim.keymap.set({"i","s"}, "<S-Tab>", function()
    if ls.jumpable(-1) then
        return ls.jump(-1)
    else
        return "<S-Tab>"
    end
end, {expr=true, silent=true})

vim.keymap.set("n", "<leader>t", ":CompetiTest run<CR>", { noremap = true, silent = true })

