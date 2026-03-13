return {
  "Saghen/blink.cmp",
  enabled = true,
  version = "*",
  eevent = "InsertEnter",
  -- event = "VeryLazy",
  -- to prevent loading on C++ files
  cond = function()
    -- Don't load if opening a C++ file
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    if ft == "cpp" or ft == "c" then
      -- Defer loading until insert mode
      return false
    end
    return true
  end,
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
      lazy = true,
      event = "InsertCharPre",
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
          local custom_snippets_path = vim.fn.stdpath("config") .. "/lua/user/snippets"
          if pcall(vim.loop.fs_stat, custom_snippets_path) then
            local ok, loader = pcall(require, "luasnip.loaders.from_lua")
            if ok then
              loader.load({ paths = custom_snippets_path })
            end
          end
          local extends =
            { typescript = { "tsdoc" }, javascript = { "jsdoc" }, lua = { "luadoc" }, cpp = { "cppdoc" }, sh = {
              "shelldoc",
            } }
          for ft, snips in pairs(extends) do
            require("luasnip").filetype_extend(ft, snips)
          end
        end,
      },
      opts = { history = true, delete_check_events = "TextChanged" },
    },
  },
  opts = {
    snippets = { preset = "luasnip" },

    completion = {
      documentation = { auto_show = false },
      auto_insert = false, -- يمنع كتابة العنصر تلقائيًا
      trigger = {
        show_on_insert_on_trigger_character = true,
        show_on_insert = false,
        show_on_keyword = true,
        keyword = { range = "prefix" },
      },
      list = {
        max_items = 10,
        selection = {
          preselect = false, -- 
          auto_insert = false,
        },
      },
    },

    keymap = {
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Enter>"] = { "accept", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

      -- تعطيل الأسهم بشكل صريح
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
      ["<Left>"] = { "fallback" },
      ["<Right>"] = { "fallback" },
    },

    keymap_disable_default = true,    disable_keymap = true, --

    -- sources = {
    --   default = { "lsp", "snippets", "buffer", "path" },
    --   providers = {
    --     buffer = { max_items = 5 },
    --     ripgrep = {
    --       module = "blink-ripgrep",
    --       name = "Ripgrep",
    --       enabled = true,
    --       should_show_items = function()
    --         local line = vim.api.nvim_get_current_line()
    --         local col = vim.api.nvim_win_get_cursor(0)[2]
    --         local word = line:sub(1, col):match("[%w_]+$")
    --         return word and #word > 3
    --       end,
    --       opts = {
    --         prefix_min_len = 4,
    --         score_offset = 10,
    --         max_filesize = "300K",
    --         search_casing = "--smart-case",
    --         debounce = 300,
    --       },
    --     },
    --   },
    -- },
    sources = {
      default = { "lsp", "snippets", "buffer" }, -- Remove "path" initially
      providers = {
        buffer = {
          max_items = 3,
          -- Only current buffer, not all buffers
          opts = {
            get_bufnrs = function()
              return { vim.api.nvim_get_current_buf() }
            end,
          },
        },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          enabled = true,
          -- DISABLE AUTO-SHOW - only when manually triggered
          should_show_items = function()
            return false -- Never show automatically
          end,
          -- Make it async with very high debounce
          async = true,
          opts = {
            prefix_min_len = 10, -- Only trigger on very long words
            score_offset = 10,
            max_filesize = "100K",
            search_casing = "--smart-case",
            debounce = 2000, -- 2 second debounce
            -- Limit search scope aggressively
            search_paths = { vim.fn.getcwd() }, -- Only current directory
            ignore_paths = {
              "node_modules",
              ".git",
              "build",
              "dist",
              "target",
              "vendor",
              "cache",
              "logs",
              "tmp",
              "*.min.*",
            },
          },
        },
      },
    },
  },
}
