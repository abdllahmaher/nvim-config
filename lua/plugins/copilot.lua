return {
  "github/copilot.vim",
  enabled = true,
  event = "InsertEnter",
  config = function()
    -- Disable default Tab mapping
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    
    -- Map Ctrl+L to accept
    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
      noremap = true,
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
    
    -- BETTER cleanup on exit - actually kill the process
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        -- Disable copilot first
        vim.cmd("Copilot disable")
        -- Find and kill the copilot language server process
        local job_id = vim.fn.jobstart("pkill -f 'copilot-language-server.*" .. vim.env.USER .. "'", { detach = true })
      end,
    })
    
    -- Also cleanup on VimLeave (if VimLeavePre isn't enough)
    vim.api.nvim_create_autocmd("VimLeave", {
      callback = function()
        vim.cmd("silent! Copilot disable")
        os.execute("pkill -f 'copilot-language-server' 2>/dev/null")
      end,
    })
  end,
}
