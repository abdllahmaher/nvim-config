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

      -- REQUIRED for nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      })

      -- JavaScript / TypeScript (browser)
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        root_dir = function()
          return vim.fn.getcwd()
        end,
        flags = {
          debounce_text_changes = 150,
        },
      })

      -- CSS / SCSS / LESS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- C / C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

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
    end,
  },
}
