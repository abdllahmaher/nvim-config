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
--           "clangd",
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
--                 root_dir = require("lspconfig.util").root_pattern(
--                   "tsconfig.json", "package.json", ".git"
--                 ),
--                 settings = {
--                   typescript = {
--                     preferences = { includePackageJsonAutoImports = "off" },
--                     tsserver = {
--                       watchOptions = {
--                         excludeDirectories = { "node_modules", ".git" },
--                       },
--                     },
--                   },
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
--   -- LSP Configuration with keymaps
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
--       -- Also set HTML filetype for .ejs files on BufRead
--       vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--         pattern = "*.ejs",
--         callback = function()
--           vim.bo.filetype = "html"
--         end,
--       })
--
--       -- LSP Keymaps - MOVED INSIDE HERE
--       local lsp_keymaps = function(bufnr)
--         local opts = { buffer = bufnr, remap = false }
--
--         vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)  -- Make both work
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
--         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--         vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--         vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
--         vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
--       end
--
--       -- Attach keymaps when LSP attaches
--       vim.api.nvim_create_autocmd("LspAttach", {
--         group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--         callback = function(args)
--           lsp_keymaps(args.buf)
--         end,
--       })
--     end,
--   },
-- }



return {
  -- First, ensure lspconfig is installed
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,
  },
  
  -- Mason for managing LSP servers
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP config bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
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
          -- Skip clangd - handled in cpp.lua
          clangd = function() end,
          
          -- Handle vtsls specially
          vtsls = function()
            require("lspconfig").vtsls.setup({
              root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git"),
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
          end,
          
          -- Default handler
          function(server_name)
            if server_name ~= "clangd" then
              require("lspconfig")[server_name].setup({})
            end
          end,
        },
      })
    end,
  },

  -- LSP Configuration with keymaps
  {
    "neovim/nvim-lspconfig",  -- This will be merged with the first one
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Setup other LSP servers (excluding clangd)
      lspconfig.pyright.setup({
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
      })

      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })

      -- Diagnostics configuration
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
      })

      -- Filetype handling
      vim.filetype.add({ extension = { ejs = "html" } })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.ejs",
        callback = function() vim.bo.filetype = "html" end,
      })

      -- LSP Keymaps
      local lsp_keymaps = function(bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args) lsp_keymaps(args.buf) end,
      })
    end,
  },
}
