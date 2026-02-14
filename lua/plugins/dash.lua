-- return {
--   "nvimdev/dashboard-nvim",
--   lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
--   opts = function()
--     local logo = [[
--       󰣇██╗   ███╗ █████╗ ██╗  ██╗███████╗██████╗ 
--       ████╗ ████║██╔══██╗██║  ██║██╔════╝██╔══██╗
--       ██╔████╔██║███████║███████║█████╗  ██████╔╝
--       ██║╚██╔╝██║██╔══██║██╔══██║██╔══╝  ██╔══██╗
--       ██║ ╚═╝ ██║██║  ██║██║  ██║███████╗██║  ██║
--       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
--     󱀡 and how do you live and have no story to tell?
--                                            ]]
--
--     logo = string.rep("\n", 8) .. logo .. "\n\n"
--
--     local opts = {
--       theme = "doom",
--       hide = {
--         -- this is taken care of by lualine
--         -- enabling this messes up the actual laststatus setting after loading a file
--         statusline = false,
--       },
--       config = {
--         header = vim.split(logo, "\n"),
--         -- stylua: ignore
--         center = {
--           { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
--           { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
--           { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
--           { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
--           { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
--           { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
--           { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
--           { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
--           { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
--         },
--         footer = function()
--           local stats = require("lazy").stats()
--           local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--           return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
--         end,
--       },
--     }
--
--     for _, button in ipairs(opts.config.center) do
--       button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
--       button.key_format = "  %s"
--     end
--
--     -- open dashboard after closing lazy
--     if vim.o.filetype == "lazy" then
--       vim.api.nvim_create_autocmd("WinClosed", {
--         pattern = tostring(vim.api.nvim_get_current_win()),
--         once = true,
--         callback = function()
--           vim.schedule(function()
--             vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
--           end)
--         end,
--       })
--     end
--
--     return opts
--   end,
-- }
--
--
return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  opts = function()
    local logo = [[
      󰣇██╗   ███╗ █████╗ ██╗  ██╗███████╗██████╗ 
      ████╗ ████║██╔══██╗██║  ██║██╔════╝██╔══██╗
      ██╔████╔██║███████║███████║█████╗  ██████╔╝
      ██║╚██╔╝██║██╔══██║██╔══██║██╔══╝  ██╔══██╗
      ██║ ╚═╝ ██║██║  ██║██║  ██║███████╗██║  ██║
      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    󱀡 and how do you live and have no story to tell?
                                           ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    return opts
  end,
  config = function(_, opts)
    -- Setup dashboard
    require("dashboard").setup(opts)
    
    -- Check if we're opening a directory
    local args = vim.fn.argv()
    local is_dir_only = #args == 1 and vim.fn.isdirectory(args[1]) == 1
    
    if is_dir_only or #args == 0 then
      -- Wait a bit for everything to load
      vim.defer_fn(function()
        -- Get all windows
        local windows = vim.api.nvim_list_wins()
        
        -- Close all buffers in all windows
        for _, win in ipairs(windows) do
          local buf = vim.api.nvim_win_get_buf(win)
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
        
        -- Create a new buffer and set it as the current window
        vim.cmd([[new]])
        vim.cmd([[only]]) -- This will close other windows like the tree
        
        -- Now explicitly call the dashboard function
        local dashboard = require("dashboard")
        dashboard.preview_command = function() end -- Disable preview if any
        vim.cmd([[Dashboard]])
        
        -- Set the buffer to be modifiable and not a special buffer
        vim.bo.buftype = ""
        vim.bo.bufhidden = ""
        vim.bo.modifiable = true
      end, 200)
    end
  end,
}
