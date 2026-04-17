return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.1",
  build = "make",
  opts = {
    show_line_number = true,
    show_workspace = true,
    snapshot_config = {
      theme = "candy",
      window = {
        mac_window_bar = true,
        margin = { x = 82, y = 82 },
      },
      watermark = {
        content = "CodeSnap.nvim",
        font_family = "Pacifico",
        color = "#ffffff",
      },
    },
  },
  keys = {
    {
      "<leader>cs",
      function()
        -- Store current selection before running command
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        
        -- Run CodeSnap
        vim.cmd('CodeSnap')
        
        -- Restore selection (optional)
        vim.fn.setpos("'<", start_pos)
        vim.fn.setpos("'>", end_pos)
      end,
      mode = "v",
      desc = "CodeSnap Copy",
    },
  },
}
