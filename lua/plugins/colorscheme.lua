
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",

        transparent_background = true,

        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          notify = true,
          mini = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")

      vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalFloat guibg=NONE ctermbg=NONE
  highlight FloatBorder guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE
  highlight EndOfBuffer guibg=NONE

  highlight Pmenu guibg=NONE ctermbg=NONE
  highlight PmenuSel guibg=NONE ctermbg=NONE
  highlight PmenuSbar guibg=NONE ctermbg=NONE
  highlight PmenuThumb guibg=NONE ctermbg=NONE

  highlight BlinkCmpMenu guibg=NONE
  highlight BlinkCmpMenuBorder guibg=NONE
  highlight BlinkCmpDoc guibg=NONE
  highlight BlinkCmpDocBorder guibg=NONE
]])
      -- force transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    end,
  },
  
}
