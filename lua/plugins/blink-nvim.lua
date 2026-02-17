-- return {
--   {
--     "Saghen/blink.cmp",
--     event = { "InsertEnter", "CmdlineEnter" },
--     opts = function(_, opts)
--       opts = opts or {}
--
--       -- Ghost text for insert mode (files, buffers, LSP)
--       opts.completion = opts.completion or {}
--       opts.completion.ghost_text = {
--         enabled = true,
--         show_with_selection = true,
--         show_without_selection = false,
--         show_with_menu = true, -- needed to display alongside menu
--         show_without_menu = true,
--       }
--
--       -- Keep menu
--       opts.completion.menu = { auto_show = true }
--
--       return opts
--     end,
--   },
-- }
--
-- return {
--   'Saghen/blink.cmp',
--   enabled = true,
--   version = '*',
--   dependencies = {
--     'mikavilpas/blink-ripgrep.nvim',
--     {
--       'L3MON4D3/LuaSnip',
--       version = 'v2.*',
--       build = 'make install_jsregexp',
--       dependencies = {
--         'rafamadriz/friendly-snippets',
--         config = function()
--           require('luasnip.loaders.from_vscode').lazy_load()
--           require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath 'config' .. '/snippets' } })
--
--           local extends = {
--             typescript = { 'tsdoc' },
--             javascript = { 'jsdoc' },
--             lua = { 'luadoc' },
--             python = { 'pydoc' },
--             rust = { 'rustdoc' },
--             cs = { 'csharpdoc' },
--             java = { 'javadoc' },
--             c = { 'cdoc' },
--             cpp = { 'cppdoc' },
--             php = { 'phpdoc' },
--             kotlin = { 'kdoc' },
--             ruby = { 'rdoc' },
--             sh = { 'shelldoc' },
--           }
--           -- friendly-snippets - enable standardized comments snippets
--           for ft, snips in pairs(extends) do
--             require('luasnip').filetype_extend(ft, snips)
--           end
--         end,
--       },
--       opts = { history = true, delete_check_events = 'TextChanged' },
--     },
--   },
--   ---@module 'blink.cmp'
--   ---@type blink.cmp.Config
--   opts = {
--     snippets = { preset = 'luasnip' },
--     sources = {
--       default = {
--         'lsp',
--         'path',
--         'buffer',
--         'snippets',
--         'ripgrep',
--       },
--       providers = {
--         ripgrep = {
--           module = 'blink-ripgrep',
--           name = 'Ripgrep',
--           ---@module "blink-ripgrep"
--           ---@type blink-ripgrep.Options
--           opts = {
--             prefix_min_len = 4,
--             score_offset = 10, -- should be lower priority
--             max_filesize = '300K',
--             search_casing = '--smart-case',
--           },
--         },
--      }
--     }
--    }
-- }

--NOTE this version is much faster and more efficient (Fuck my potato laptop)
return {
  'Saghen/blink.cmp',
  enabled = true,
  version = '*',
  event = "VeryLazy",
  opts = {
    keymap = {
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<Enter>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },
    snippets = { preset = 'luasnip' },
    completion = {
      documentation = { auto_show = false },
      trigger = {
        show_on_insert_on_trigger_character = true,
        show_on_insert = false,
        show_on_keyword = true,
        keyword = { range = 'full' },
      },
      list = {
        selection = { preselect = false },
      },
    },
    sources = {
      default = {
        'lsp',
        'path',
        'buffer',
        'snippets',
      },
      providers = {
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'Ripgrep',
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
            max_filesize = '300K',
            search_casing = '--smart-case',
            debounce = 300,
          },
        },
      }
    }
  },
  dependencies = {
    {
      'mikavilpas/blink-ripgrep.nvim',
      enabled = true,
      lazy = true,
    },
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath 'config' .. '/snippets' } })

          local extends = {
            typescript = { 'tsdoc' },
            javascript = { 'jsdoc' },
            lua = { 'luadoc' },
            python = { 'pydoc' },
            rust = { 'rustdoc' },
            cs = { 'csharpdoc' },
            java = { 'javadoc' },
            c = { 'cdoc' },
            cpp = { 'cppdoc' },
            php = { 'phpdoc' },
            kotlin = { 'kdoc' },
            ruby = { 'rdoc' },
            sh = { 'shelldoc' },
          }
          for ft, snips in pairs(extends) do
            require('luasnip').filetype_extend(ft, snips)
          end
        end,
      },
      opts = { history = true, delete_check_events = 'TextChanged' },
    },
  },
}
