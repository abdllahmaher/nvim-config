-- bootstrap lazy.nvim, LazyVim and your plugins
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
require("config.lazy")
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumblend = 0 -- Make completion menu opaque (0-100 for transparency)
vim.opt.wildmode = "longest:full,full" -- Or disable completely with {}

-- Optional: Ensure wildmenu doesn't show in insert mode
vim.cmd([[
  autocmd InsertEnter * set wildmenu&
  autocmd InsertLeave * set wildmenu
]])
-- Disable blink.cmp if it's loaded
-- vim.cmd([[
--   autocmd VimEnter * if exists('g:loaded_blink_cmp') | let g:blink_cmp_enabled = 0 | endif
-- ]])
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

-- Auto-start vtsls for JS/TS files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function(args)
    local clients = vim.lsp.get_active_clients({ bufnr = args.buf, name = "vtsls" })
    if #clients == 0 then
      vim.lsp.start({
        name = "vtsls",
        cmd = { "vtsls", "--stdio" },
        root_dir = vim.fn.getcwd(),
        settings = {
          typescript = { preferences = { includePackageJsonAutoImports = "off" } },
          javascript = { preferences = { includePackageJsonAutoImports = "off" } },
        },
      })
    end
  end,
})
-- init.lua
vim.opt.title = true
vim.opt.titlestring = "nvim %f"  -- sets title to "nvim filename"``
-- Limit to single instance and cleanup on exit
vim.g.copilot_server_disabled = false
vim.g.copilot_auto_cleanup = true
vim.g.copilot_max_processes = 1

-- Auto-close on Vim exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*",
  callback = function()
    vim.cmd("Copilot disable")
    vim.cmd("Copilot exit")
  end,
})
