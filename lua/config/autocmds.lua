--
-- Auto-save configuration
local auto_save_group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true })

-- Debounce timer
local save_timer = nil

local function auto_save()
  -- Don't save if not modifiable
  if not vim.bo.modifiable then
    return
  end

  -- Don't save unnamed buffers
  if vim.fn.expand("%") == "" then
    return
  end

  -- Don't save specific filetypes
  local ft = vim.bo.filetype
  local exclude_ft = {
    "alpha",
    "dashboard",
    "neo-tree",
    "TelescopePrompt",
    "toggleterm",
    "lazy",
    "mason",
    "Outline",
    "qf",
    "help",
    "",
  }

  for _, excl in ipairs(exclude_ft) do
    if ft == excl then
      return
    end
  end

  -- Save the file
  vim.cmd("silent! update")
  -- print("Auto-saved at " .. vim.fn.strftime("%H:%M:%S"))
end

-- Debounced auto-save function
local function debounced_auto_save()
  if save_timer then
    save_timer:stop()
  end
  save_timer = vim.defer_fn(auto_save, 100) -- 1 second delay
end

-- Save on text changes (including insert mode)
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = auto_save_group,
  pattern = "*",
  callback = debounced_auto_save,
})

-- Save immediately on focus lost or buffer leave
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = auto_save_group,
  pattern = "*",
  callback = auto_save,
})

-- Also save when leaving insert mode (immediately)
vim.api.nvim_create_autocmd("InsertLeave", {
  group = auto_save_group,
  pattern = "*",
  callback = auto_save,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", {
      fg = "#000000",
      bg = "none",
      italic = true,
    })
  end,
})
-- Auto-save configuration with "manual formatting only"
local auto_save_group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true })

local save_timer = nil

local function auto_save()
  if not vim.bo.modifiable then return end
  if vim.fn.expand("%") == "" then return end

  -- mark this write as auto-save
  vim.b._is_auto_save = true
  vim.cmd("silent! update")
  vim.b._is_auto_save = nil
end

local function debounced_auto_save()
  if save_timer then save_timer:stop() end
  save_timer = vim.defer_fn(auto_save, 100) -- 100ms debounce
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = auto_save_group,
  pattern = "*",
  callback = debounced_auto_save,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = auto_save_group,
  pattern = "*",
  callback = auto_save,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = auto_save_group,
  pattern = "*",
  callback = auto_save,
})

vim.api.nvim_create_autocmd('LspNotify', {
  callback = function(args)
    if args.data.method == 'textDocument/didOpen' then
      vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
    end
  end,
})
