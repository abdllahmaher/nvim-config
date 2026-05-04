-- return {
--   {
--     "p00f/clangd_extensions.nvim",
--     dependencies = {
--       "neovim/nvim-lspconfig",
--       "mason-org/mason.nvim",
--       "mason-org/mason-lspconfig.nvim",
--       --"Saghen/blink.cmp",  
--     },
--     ft = { "c", "cpp", "h", "hpp" },
--     config = function()
--       -- جيب capabilities من blink.cmp
--       local capabilities = require("blink.cmp").get_lsp_capabilities()
--
--       local lspconfig = require("lspconfig")
--
--       -- clangd setup
--       lspconfig.clangd.setup({
--         capabilities = capabilities,  -- استخدم capabilities من blink.cmp
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
--       local ok, clangd_ext = pcall(require, "clangd_extensions")
--       if ok then
--         clangd_ext.setup({
--           server = {
--             capabilities = capabilities,  -- استخدم capabilities من blink.cmp
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
      "Saghen/blink.cmp",
    },
    ft = { "c", "cpp", "h", "hpp" },
    -- Add lazy = false to ensure it loads
    lazy = false,
    config = function()
      -- Small delay to ensure lspconfig is fully loaded
      vim.defer_fn(function()
        local blink_ok, blink_cmp = pcall(require, "blink.cmp")
        local capabilities = blink_ok and blink_cmp.get_lsp_capabilities() 
          or vim.lsp.protocol.make_client_capabilities()
        
        local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
        if not lspconfig_ok then
          vim.notify("lspconfig not found!", vim.log.levels.ERROR)
          return
        end

        -- Setup clangd
        lspconfig.clangd.setup({
          capabilities = capabilities,
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

        -- Setup clangd_extensions
        local clangd_ext_ok, clangd_ext = pcall(require, "clangd_extensions")
        if clangd_ext_ok then
          clangd_ext.setup({
            server = { capabilities = capabilities },
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
      end, 50) -- 50ms delay
    end,
  },
}
