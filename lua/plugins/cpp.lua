--
-- return {
--   {
--     "p00f/clangd_extensions.nvim",
--     dependencies = {
--       "neovim/nvim-lspconfig",
--       "mason-org/mason.nvim",
--       "mason-org/mason-lspconfig.nvim",
--       { "hrsh7th/cmp-nvim-lsp", enabled = false },
--     },
--     ft = { "c", "cpp", "h", "hpp" },
--     config = function()
--       local lspconfig = require("lspconfig")
--
--       -- Safe require for cmp_nvim_lsp
--       local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--       if not ok then
--         vim.notify("cmp_nvim_lsp not found! clangd_extensions may be limited.", vim.log.levels.WARN)
--       end
--
--       -- clangd setup
--       lspconfig.clangd.setup({
--         capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or nil,
--         cmd = {
--           "clangd",
--           "--background-index",
--           "--clang-tidy",
--           "--header-insertion=iwyu",
--           "--completion-style=detailed",
--           "--function-arg-placeholders",
--           "--fallback-style=llvm",
--         },
--       })
--
--       -- clangd extensions setup
--       local ok2, clangd_ext = pcall(require, "clangd_extensions")
--       if ok2 then
--         clangd_ext.setup({
--           server = {
--             capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or nil,
--           },
--           extensions = {
--             autoSetHints = true,
--             inlay_hints = {
--               only_current_line = false,
--               show_parameter_hints = true,
--               parameter_hints_prefix = "← ",
--               other_hints_prefix = "→ ",
--               highlight = "Comment",
--             },
--           },
--         })
--       end
--     end,
--   },
-- }
return {
  {
    "p00f/clangd_extensions.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      --"Saghen/blink.cmp",  
    },
    ft = { "c", "cpp", "h", "hpp" },
    config = function()
      -- جيب capabilities من blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      
      local lspconfig = require("lspconfig")

      -- clangd setup
      lspconfig.clangd.setup({
        capabilities = capabilities,  -- استخدم capabilities من blink.cmp
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      })

      -- clangd extensions setup
      local ok, clangd_ext = pcall(require, "clangd_extensions")
      if ok then
        clangd_ext.setup({
          server = {
            capabilities = capabilities,  -- استخدم capabilities من blink.cmp
          },
          extensions = {
            autoSetHints = true,
            inlay_hints = {
              only_current_line = false,
              show_parameter_hints = true,
              parameter_hints_prefix = "← ",
              other_hints_prefix = "→ ",
              highlight = "Comment",
            },
          },
        })
      end
    end,
  },
}
