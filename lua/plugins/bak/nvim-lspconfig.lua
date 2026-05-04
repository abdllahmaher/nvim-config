return{
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ['*'] = {
        keys = {
          -- Add a keymap
          { "H", "<cmd>echo 'hello'<cr>", desc = "Say Hello" },
          -- Change an existing keymap
          { "K", "<cmd>echo 'custom hover'<cr>", desc = "Custom Hover" },
          -- Disable a keymap
          { "gd", false },
        },
      },
    },
  },
}
