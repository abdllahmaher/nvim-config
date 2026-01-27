return {
  {
    "Saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, opts)
      opts = opts or {}

      -- Ghost text for insert mode (files, buffers, LSP)
      opts.completion = opts.completion or {}
      opts.completion.ghost_text = {
        enabled = true,
        show_with_selection = true,
        show_without_selection = false,
        show_with_menu = true, -- needed to display alongside menu
        show_without_menu = true,
      }

      -- Keep menu
      opts.completion.menu = { auto_show = true }

      return opts
    end,
  },
}
