return {
  "Saghen/blink.cmp",
  enabled = true,
  version = "*",
  event = "VeryLazy",
  dependencies = {
    {
      "mikavilpas/blink-ripgrep.nvim",
      enabled = true,
      lazy = true,
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      -- Force LuaSnip to load at startup
      lazy = false, -- This is key! Load immediately
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          -- Load VS Code snippets
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

          -- LOAD CUSTOM LUA SNIPPETS (Faster than JSON!)
          local custom_snippets_path = vim.fn.stdpath("config") .. "/lua/user/snippets"

          -- Check if directory exists before trying to load
          local ok, _ = pcall(vim.loop.fs_stat, custom_snippets_path)
          if ok then
            -- Use pcall to safely require the loader
            local loader_ok, loader = pcall(require, "luasnip.loaders.from_lua")
            if loader_ok then
              loader.load({ paths = custom_snippets_path })
              vim.notify("Custom Lua snippets loaded from: " .. custom_snippets_path, vim.log.levels.INFO)
            else
              vim.notify("LuaSnip from_lua loader not available. Update LuaSnip!", vim.log.levels.WARN)
            end
          end

          -- Filetype extensions for documentation snippets
          local extends = {
            typescript = { "tsdoc" },
            javascript = { "jsdoc" },
            lua = { "luadoc" },
            cpp = { "cppdoc" },
            sh = { "shelldoc" },
          }
          for ft, snips in pairs(extends) do
            require("luasnip").filetype_extend(ft, snips)
          end
        end,
      },
      opts = { history = true, delete_check_events = "TextChanged" },
    },
  },
  opts = {
    keymap = {
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<Enter>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    snippets = { preset = "luasnip" },
    completion = {
      documentation = { auto_show = false },
      trigger = {
        show_on_insert_on_trigger_character = true,
        show_on_insert = true,
        show_on_keyword = true,
        keyword = { range = "prefix" },
      },
      list = {
        max_items = 15,
        selection = { preselect = false },
      },
    },
    sources = {
      default = {
        "lsp",
        "snippets",
        "buffer",
        "path",
      },
      providers = {
        buffer = {
          -- Only search current buffer, not all buffers
          max_items = 5,
        },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          enabled = true,
          should_show_items = function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local word = line:sub(1, col):match("[%w_]+$")
            return word and #word > 3
          end,
          opts = {
            prefix_min_len = 4,
            score_offset = 10,
            max_filesize = "300K",
            search_casing = "--smart-case",
            debounce = 300,
          },
        },
      },
    },
  },
}
