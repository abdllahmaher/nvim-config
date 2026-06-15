return {
  -- Disable LazyVim's default formatting
  {
    "lazyvim/lazyvim.plugins.extras.formatting.format",
    enabled = false, -- Disable the entire formatting extra
  },
  -- Override conform settings
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = false, -- Already have this
      -- Add this to prevent LazyVim from re-enabling
      notify_on_error = true,
      formatters_by_ft = {
        -- Keep it empty or only add formatters you want manually
      },
    },
    -- Add this to ensure conform doesn't get auto-configured by LazyVim
    init = function()
      vim.g.format_on_save = false
      vim.g.autoformat = false
    end,
  },
}
