return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              includePackageJsonAutoImports = "off",
            },
          },
          javascript = {
            preferences = {
              includePackageJsonAutoImports = "off",
            },
          },
          inlayHints = {
            includedFiles = false,
          },
        },
      },
    },
  },
}
