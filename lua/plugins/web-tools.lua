return {
  {
    "ray-x/web-tools.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- optional but recommended (floating windows)
      "nvim-lua/plenary.nvim",
    },
    ft = { "html", "css", "javascript", "typescript", "json", "hurl" },
    opts = {
      keymaps = {
        rename = nil, -- use LSP rename
        repeat_rename = ".", -- repeat rename
      },
      hurl = {
        show_headers = false,
        floating = true,
        json5 = false,
        formatters = {
          json = { "jq" },
          html = { "prettier", "--parser", "html" },
        },
      },
    },
  },
}
