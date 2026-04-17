os.execute("pkill -f 'copilot.lua.*language-server' 2>/dev/null")
return {
  "zbirenbaum/copilot.lua",
  event = "VeryLazy",
  cmd = "Copilot",
  build = ":Copilot auth",
  
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
    
    -- Memory limit for Node
    node_command = "node --max-old-space-size=512",
    
    filetypes = {
      lua = true,
      python = true,
      cpp = true,
      markdown = true,
      help = true,
    },
  },
}
