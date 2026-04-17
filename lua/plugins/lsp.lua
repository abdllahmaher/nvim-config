-- -- return {
-- --   -- Mason for managing LSP servers
-- --   {
-- --     "mason-org/mason.nvim",
-- --     build = ":MasonUpdate",
-- --     config = function()
-- --       require("mason").setup()
-- --     end,
-- --   },
-- --
-- --   -- Mason LSP config bridge
-- --   {
-- --     "mason-org/mason-lspconfig.nvim",
-- --     dependencies = {
-- --       "mason-org/mason.nvim",
-- --       { "neovim/nvim-lspconfig", enabled = true },
-- --     },
-- --     config = function()
-- --       require("mason-lspconfig").setup({
-- --         ensure_installed = {
-- --           "pyright",
-- --           "vtsls",
-- --           "cssls",
-- --           "clangd",      -- Keep this so it gets installed
-- --           "html",
-- --         },
-- --         automatic_installation = false,
-- --         handlers = {
-- --           -- This function runs for each server in ensure_installed
-- --           function(server_name)
-- --             -- Skip clangd - let cpp.lua handle it
-- --             if server_name == "clangd" then
-- --               return
-- --             end
-- --             -- For all other servers, use default setup
-- --             require("lspconfig")[server_name].setup({})
-- --           end,
-- --         },
-- --       })
-- --     end,
-- --   },
-- --
-- --   -- LSP Configuration
-- --   {
-- --     "neovim/nvim-lspconfig",
-- --     dependencies = {
-- --       "mason-org/mason.nvim",
-- --       "mason-org/mason-lspconfig.nvim",
-- --       { "hrsh7th/cmp-nvim-lsp", enabled = false },
-- --     },
-- --     config = function()
-- --       local lspconfig = require("lspconfig")
-- --
-- --       -- REQUIRED for nvim-cmp
-- --       local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- --
-- --       -- Python
-- --       lspconfig.pyright.setup({
-- --         capabilities = capabilities,
-- --         flags = {
-- --           debounce_text_changes = 150,
-- --         },
-- --       })
-- --
-- --       -- JavaScript / TypeScript (browser)
-- --       lspconfig.vtsls.setup({
-- --         capabilities = capabilities,
-- --         root_dir = function()
-- --           return vim.fn.getcwd()
-- --         end,
-- --         flags = {
-- --           debounce_text_changes = 150,
-- --         },
-- --       })
-- --
-- --       -- CSS / SCSS / LESS
-- --       lspconfig.cssls.setup({
-- --         capabilities = capabilities,
-- --       })
-- --
-- --       -- C / C++
-- --       -- lspconfig.clangd.setup({
-- --       --   capabilities = capabilities,
-- --       -- })
-- --
-- --       -- HTML
-- --       lspconfig.html.setup({
-- --         capabilities = capabilities,
-- --       })
-- --
-- --       -- Diagnostics configuration
-- --       vim.diagnostic.config({
-- --         virtual_text = false,
-- --         signs = true,
-- --         update_in_insert = true,
-- --       })
-- --     end,
-- --   },
-- -- }
-- return {
--   -- Mason for managing LSP servers
--   {
--     "mason-org/mason.nvim",
--     build = ":MasonUpdate",
--     config = function()
--       require("mason").setup()
--     end,
--   },
--
--   -- Mason LSP config bridge
--   {
--     "mason-org/mason-lspconfig.nvim",
--     dependencies = {
--       "mason-org/mason.nvim",
--       { "neovim/nvim-lspconfig", enabled = true },
--     },
--     config = function()
--       require("mason-lspconfig").setup({
--         ensure_installed = {
--           "pyright",
--           "vtsls",
--           "cssls",
--           "clangd",      -- Keep this so it gets installed
--           "html",
--         },
--         automatic_installation = true,
--         handlers = {
--           function(server_name)
--             if server_name == "clangd" then
--               return
--             end
--             if server_name == "vtsls" then
--               require("lspconfig").vtsls.setup({
--                 settings = {
--                   typescript = { preferences = { includePackageJsonAutoImports = "off" } },
--                   javascript = { preferences = { includePackageJsonAutoImports = "off" } },
--                 },
--               })
--               return
--             end
--             require("lspconfig")[server_name].setup({})
--           end,
--         },
--       })
--     end,
--   },
--
--   -- LSP Configuration
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "mason-org/mason.nvim",
--       "mason-org/mason-lspconfig.nvim",
--       { "hrsh7th/cmp-nvim-lsp", enabled = false },
--     },
--     config = function()
--       local lspconfig = require("lspconfig")
--
--       local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities())
--
--       -- Python
--       lspconfig.pyright.setup({
--         capabilities = capabilities,
--         flags = {
--           debounce_text_changes = 150,
--         },
--       })
--
--       -- CSS / SCSS / LESS
--       lspconfig.cssls.setup({
--         capabilities = capabilities,
--       })
--
--       -- C / C++
--       -- lspconfig.clangd.setup({
--       --   capabilities = capabilities,
--       -- })
--
--       -- HTML
--       lspconfig.html.setup({
--         capabilities = capabilities,
--       })
--
--       -- Diagnostics configuration
--       vim.diagnostic.config({
--         virtual_text = false,
--         signs = true,
--         update_in_insert = true,
--       })
--
--       -- Make .ejs files treated as HTML
--       vim.filetype.add({
--         extension = {
--           ejs = "html",
--         },
--       })
--
--       -- Optional: Also set HTML filetype for .ejs files on BufRead
--       vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--         pattern = "*.ejs",
--         callback = function()
--           vim.bo.filetype = "html"
--         end,
--       })
--     end,
--   },
-- }
return {
  -- Mason for managing LSP servers
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP config bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      { "neovim/nvim-lspconfig", enabled = true },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "vtsls",
          "cssls",
          "clangd",
          "html",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            if server_name == "clangd" then
              return
            end
            if server_name == "vtsls" then
              require("lspconfig").vtsls.setup({
                root_dir = require("lspconfig.util").root_pattern(
                  "tsconfig.json", "package.json", ".git"
                ),
                settings = {
                  typescript = {
                    preferences = { includePackageJsonAutoImports = "off" },
                    tsserver = {
                      watchOptions = {
                        excludeDirectories = { "node_modules", ".git" },
                      },
                    },
                  },
                  javascript = { preferences = { includePackageJsonAutoImports = "off" } },
                },
              })
              return
            end
            require("lspconfig")[server_name].setup({})
          end,
        },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      { "hrsh7th/cmp-nvim-lsp", enabled = false },
    },
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities())

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      })

      -- CSS / SCSS / LESS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- C / C++
      -- lspconfig.clangd.setup({
      --   capabilities = capabilities,
      -- })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- Diagnostics configuration
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
      })

      -- Make .ejs files treated as HTML
      vim.filetype.add({
        extension = {
          ejs = "html",
        },
      })

      -- Also set HTML filetype for .ejs files on BufRead
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.ejs",
        callback = function()
          vim.bo.filetype = "html"
        end,
      })
    end,
  },
}
