-- lua/config/formatting.lua
return {
  -- Disable autoformat on save
  format_on_save = {
    enabled = false, -- disable format on save
    allow_filetypes = {}, -- empty table means no autoformat
    ignore_filetypes = {}, -- empty table means no autoformat
  },
  disabled = {
    -- Disable all formatters
    "lsp_fallback",
  },
}
