return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "ghost", -- modern preset with nice icons
      transparent_bg = false, -- keeps a solid background
      transparent_cursorline = true,
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine",
        mixing_color = "Normal",
      },
      disabled_ft = {},

      options = {
        enable_on_insert = true, -- show diagnostics in insert mode
        enable_on_select = true, -- show diagnostics when selecting items (completion)
        show_source = { enabled = true }, -- show LSP source like "pyright"
        show_code = true, -- show diagnostic codes like "F401"
        use_icons_from_diagnostic = false, -- use icons from vim.diagnostic.config
        set_arrow_to_diag_color = true, -- color the arrow matching severity
        throttle = 20,
        virt_texts = { priority = 2048 },
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },
        show_related = { enabled = true, max_count = 3 },
        softwrap = 30,
        overflow = { mode = "wrap", padding = 0 },
      },
    },
  },
}
