-- bootstrap lazy.nvim, LazyVim and your plugins
-- Memory saving configurations - Put this at the VERY TOP of your init.lua

-- Define memory functions FIRST before they're used
local function get_memory_usage()
  local mem = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid())
  local mem_mb = math.floor(tonumber(mem) / 1024)
  local color = mem_mb > 3000 and "%#Error#" or (mem_mb > 2000 and "%#WarningMsg#" or "%#Normal#")
  return color .. " " .. mem_mb .. "MB %*"
end
_G.get_memory_usage = get_memory_usage -- Make globally accessible for statusline

local function check_memory_usage()
  local mem = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid())
  local mem_mb = math.floor(tonumber(mem) / 1024)

  if mem_mb > 4000 then
    vim.notify(
      "⚠️ CRITICAL: " .. mem_mb .. "MB, force killing Copilot and restarting LSP...",
      "error",
      { title = "Memory Monitor" }
    )
    -- Force kill Copilot specifically
    os.execute("pkill -9 -f 'copilot-language-server' 2>/dev/null")
    os.execute("pkill -9 -f 'npm exec.*copilot' 2>/dev/null")
    vim.cmd("LspRestart")
  elseif mem_mb > 3000 then
    vim.notify("⚠️ High memory usage: " .. mem_mb .. "MB", "warn", { title = "Memory Monitor" })
  elseif mem_mb > 2000 then
    vim.notify("📈 Memory usage: " .. mem_mb .. "MB", "info", { title = "Memory Monitor" })
  end
end

-- Setup memory monitor timer (after Vim is fully loaded)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Use vim.uv instead of deprecated vim.loop
    local memory_timer = vim.uv.new_timer()
    memory_timer:start(
      60000,
      60000,
      vim.schedule_wrap(function()
        pcall(check_memory_usage) -- Wrap in pcall to handle errors gracefully
      end)
    )

    -- Clean up on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        memory_timer:stop()
        memory_timer:close()
      end,
    })
  end,
})

-- Limit LSP diagnostic memory usage
vim.diagnostic.config({
  virtual_text = false, -- Disable virtual text (major memory saver)
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = true,
  },
})

-- LSP memory limits
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Optional: Add memory to statusline without breaking plugins
-- Comment this out if it causes issues with your existing statusline
vim.opt.statusline:append("%{v:lua.get_memory_usage()}")

-- Keymaps for memory monitoring
vim.keymap.set("n", "<leader>mm", function()
  local mem = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid())
  local mem_mb = math.floor(tonumber(mem) / 1024)
  local mem_gb = mem_mb / 1024
  vim.notify(string.format("NVim Memory: %.1f GB (%.0f MB)", mem_gb, mem_mb), "info", { title = "Memory Info" })
end, { desc = "Show memory usage" })

vim.keymap.set("n", "<leader>mr", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

vim.keymap.set("n", "<leader>mk", function()
  os.execute("pkill -9 -f 'copilot-language-server' 2>/dev/null")
  vim.notify("Killed all Copilot processes", "info", { title = "Memory Monitor" })
end, { desc = "Kill Copilot processes" })

-- Your existing init.lua continues below
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
require("config.lazy")

-- Editor settings
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumblend = 0 -- Make completion menu opaque (0-100 for transparency)
vim.opt.wildmode = "longest:full,full" -- Or disable completely with {}
vim.o.termguicolors = true
vim.opt.title = true
vim.opt.titlestring = "nvim %f" -- sets title to "nvim filename"

-- Optional: Ensure wildmenu doesn't show in insert mode
vim.cmd([[
  autocmd InsertEnter * set wildmenu&
  autocmd InsertLeave * set wildmenu
]])

-- Disable blink.cmp if it's loaded
-- vim.cmd([[
--   autocmd VimEnter * if exists('g:loaded_blink_cmp') | let g:blink_cmp_enabled = 0 | endif
-- ]])

vim.notify("Welcome back, Commander")

-- Disable all automatic formatting
vim.g.autoformat_enabled = false
vim.g.format_on_save = false

-- Place this in your options or after LSP setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Disable format-on-type
    vim.lsp.handlers["textDocument/onTypeFormatting"] = function() end
  end,
})

-- Auto-start vtsls for JS/TS files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function(args)
    local clients = vim.lsp.get_active_clients({ bufnr = args.buf, name = "vtsls" })
    if #clients == 0 then
      vim.lsp.start({
        name = "vtsls",
        cmd = { "vtsls", "--stdio" },
        root_dir = vim.fn.getcwd(),
        settings = {
          typescript = { preferences = { includePackageJsonAutoImports = "off" } },
          javascript = { preferences = { includePackageJsonAutoImports = "off" } },
        },
      })
    end
  end,
})

-- Copilot specific settings and cleanup
vim.g.copilot_server_disabled = false
vim.g.copilot_auto_cleanup = true
vim.g.copilot_max_processes = 1

-- Kill child processes on exit (VimLeavePre runs before VimLeave)
vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*",
  callback = function()
    local pid = vim.fn.getpid()
    vim.fn.system("ps -o pid= --ppid " .. pid .. " | xargs -r kill -9 2>/dev/null")
  end,
})

-- Comprehensive Copilot cleanup on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    -- Get all LSP clients and kill Copilot specifically
    local clients = vim.lsp.get_clients()
    for _, client in ipairs(clients) do
      if client.name == "copilot" then
        -- Force kill the process
        if client.rpc and client.rpc.pid then
          vim.fn.jobstop(client.rpc.pid)
          os.execute("kill -9 " .. client.rpc.pid .. " 2>/dev/null")
        end
      end
    end
    -- Fallback: kill all copilot language servers and npm wrappers
    os.execute("pkill -9 -f 'copilot-language-server' 2>/dev/null")
    os.execute("pkill -9 -f 'npm exec.*copilot' 2>/dev/null")
  end,
})

-- Optional: Add a command to manually cleanup Copilot
vim.api.nvim_create_user_command("CopilotCleanup", function()
  os.execute("pkill -9 -f 'copilot-language-server' 2>/dev/null")
  os.execute("pkill -9 -f 'npm exec.*copilot' 2>/dev/null")
  vim.notify("Cleaned up all Copilot processes", "info", { title = "Copilot" })
end, {})

-- Your existing configuration continues below
--
--
--
-- ... (any other configuration you had)
im.g.lazyvim_format_on_save = false
vim.g.autoformat = false -- LazyVim uses this
