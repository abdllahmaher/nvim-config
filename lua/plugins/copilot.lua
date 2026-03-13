
-- return {
--   "zbirenbaum/copilot.lua",
--   event = "VeryLazy",  -- load Copilot as soon as  start typing
--   cmd = "Copilot",     -- only load fully when  run :Copilot command
--   build = ":Copilot auth",
--   opts = {
--     suggestion = {
--       enabled = true,           -- always enable
--       auto_trigger = true,
--       keymap = {
--         accept = "<C-l>",       -- or any key you want
--         next = "<M-]>",
--         prev = "<M-[>",
--       },
--     },
--     panel = { enabled = false },
--     filetypes = {
--       lua = true,
--       python = true,
--       cpp = true,
--       markdown = true,
--       help = true,
--       -- add more as needed
--     },
--   },
-- }
return {
  "zbirenbaum/copilot.lua",
  event = "VeryLazy",
  cmd = "Copilot",
  build = ":Copilot auth",
  
  -- ADD THIS - prevent multiple instances
  init = function()
    -- Kill any existing copilot processes when starting
    vim.defer_fn(function()
      local handle = io.popen("pgrep -f 'copilot.lua.*language-server'")
      if handle then
        local result = handle:read("*a")
        handle:close()
        
        -- Count processes
        local count = 0
        for _ in result:gmatch("[^\r\n]+") do
          count = count + 1
        end
        
        if count > 1 then
          vim.notify("Found " .. count .. " copilot processes. Killing extras...", vim.log.levels.WARN)
          os.execute("pkill -f 'copilot.lua.*language-server'")
        end
      end
    end, 1000)  -- Check after 1 second
  end,
  
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
    
    -- ADD THIS - ensure only one instance
    server = {
      -- This prevents starting a separate server process
      standalone = false,
    },
    
    filetypes = {
      lua = true,
      python = true,
      cpp = true,
      markdown = true,
      help = true,
    },
  },
}
