--

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "tsx",
        "jsx",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    opts = {
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte",
        "tsx",
        "jsx",
        "xml",
      },
    },
  },
}
