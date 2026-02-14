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
return {
  'Saghen/blink.cmp',
  enabled = true,
  version = '*',
  dependencies = {
    'mikavilpas/blink-ripgrep.nvim',
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
          -- friendly-snippets - enable standardized comments snippets
          for ft, snips in pairs(extends) do
            require('luasnip').filetype_extend(ft, snips)
          end
        end,
      },
      opts = { history = true, delete_check_events = 'TextChanged' },
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = 'luasnip' },
    sources = {
      default = {
        'lsp',
        'path',
        'buffer',
        'snippets',
        'ripgrep',
      },
      providers = {
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'Ripgrep',
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            prefix_min_len = 4,
            score_offset = 10, -- should be lower priority
            max_filesize = '300K',
            search_casing = '--smart-case',
          },
        },
     }
    }
   }
}
