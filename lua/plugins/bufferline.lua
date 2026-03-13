return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",

  -- load immediately (not VeryLazy)
  lazy = false,

  config = function()
    vim.opt.showtabline = 2
    vim.opt.termguicolors = true -- Required for proper colors

    require("bufferline").setup({
      options = {
        mode = "buffers",
        -- Show LSP diagnostics
        diagnostics = "nvim_lsp", -- Use "coc" if you're using coc.nvim

        -- Customize how diagnostics appear - only icons change color
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " "
            or level:match("warning") and " "
            or level:match("info") and " "
            or level:match("hint") and " "
            or ""

          -- Return just the icon with count, no text color changes
          return " " .. icon .. count
        end,

        -- Update diagnostics in insert mode (for coc)
        diagnostics_update_in_insert = false,

        -- Use Neovim's native diagnostic handler
        diagnostics_update_on_event = true,

        -- Buffer appearance
        always_show_bufferline = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,

        -- Separator style
        separator_style = "thin",

        -- Buffer name formatting
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,

        -- Icons
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",

        -- Color icons by filetype
        color_icons = true,

        -- Sorting
        sort_by = "insert_after_current",

        -- Key mappings
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    })

    -- Optional: If you're still seeing colored buffer names,
    -- you can explicitly set the buffer name highlight to use your theme's defaults
    vim.cmd([[
      highlight! link BufferLineBuffer Normal
      highlight! link BufferLineBufferSelected Normal
      highlight! link BufferLineBufferVisible Normal
    ]])

    -- Keybindings for buffer navigation
    vim.keymap.set("n", "<leader>h", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })
    vim.keymap.set("n", "<leader>l", ":BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })

    -- Alternative with arrow keys
    vim.keymap.set("n", "<leader><left>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true })
    vim.keymap.set("n", "<leader><right>", ":BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })

    -- Buffer management keybindings
    vim.keymap.set("n", "<leader>bc", ":BufferLinePickClose<CR>", { desc = "Pick buffer to close", silent = true })
    vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick buffer", silent = true })
    vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete current buffer", silent = true })
    vim.keymap.set("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { desc = "Close other buffers", silent = true })
    vim.keymap.set(
      "n",
      "<leader>br",
      ":BufferLineCloseRight<CR>",
      { desc = "Close buffers to the right", silent = true }
    )
    vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { desc = "Close buffers to the left", silent = true })

    -- Sorting keybindings
    vim.keymap.set("n", "<leader>bsd", ":BufferLineSortByDirectory<CR>", { desc = "Sort by directory", silent = true })
    vim.keymap.set("n", "<leader>bse", ":BufferLineSortByExtension<CR>", { desc = "Sort by extension", silent = true })
  end,
}
