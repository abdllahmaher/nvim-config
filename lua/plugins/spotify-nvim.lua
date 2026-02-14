return {
  "stsewd/spotify.nvim",
  build = ":UpdateRemotePlugins",
  config = function()
    require("spotify").setup({
      notify_after_action = true,
      notification = {
        backend = "builtin",  -- Start with builtin to avoid dependency issues
        extra_opts = {
          icon = "",
        },
        width = 44,
      },
    })
  end,
  init = function()
    vim.keymap.set("n", "<leader>ss", ":Spotify play/pause<CR>", { silent = true })
    vim.keymap.set("n", "<leader>sj", ":Spotify next<CR>", { silent = true })
    vim.keymap.set("n", "<leader>sk", ":Spotify prev<CR>", { silent = true })
  end,
}
