
return {
  "zbirenbaum/copilot.lua",
  event = "VeryLazy",  -- load Copilot as soon as  start typing
  cmd = "Copilot",     -- only load fully when  run :Copilot command
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,           -- always enable
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",       -- or any key you want
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      lua = true,
      python = true,
      cpp = true,
      markdown = true,
      help = true,
      -- add more as needed
    },
  },
}
