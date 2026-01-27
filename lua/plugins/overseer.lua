return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup({
      strategy = "toggleterm", -- or "job", not "terminal" which seems missing
      task_list = {
        min_width = 50,
        min_height = 5,
      },
    })
  end,
}
