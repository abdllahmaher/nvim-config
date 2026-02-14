return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-mini/mini.icons",
    },
    opts = function()
      -- safe hl function for lualine (converts decimal colors to hex)
      local function hl(name)
        local ok, hl_tbl = pcall(vim.api.nvim_get_hl, 0, { name = name })
        if ok and hl_tbl.fg then
          return { fg = string.format("#%06x", hl_tbl.fg) }
        end
        return {}
      end

      -- get number of listed buffers
      local function buffer_count()
        return #vim.fn.getbufinfo({ buflisted = 1 })
      end

      local filetype_map = {
        lazy = { name = "lazy.nvim", icon = "💤" },
        minifiles = { name = "minifiles", icon = "🗂️ " },
        snacks_terminal = { name = "terminal", icon = "🐚" },
        mason = { name = "mason", icon = "🔨" },
        snacks_picker_input = { name = "picker", icon = "🔍" },
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = " ",
          section_separators = " ",
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },

        sections = {
          lualine_a = {
            { "mode", icon = "", fmt = string.lower },
          },

          lualine_b = {
            { "branch", icon = "" },
          },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰝶 ",
              },
            },

            {
              function()
                local ft = vim.bo.filetype
                if filetype_map[ft] then
                  return filetype_map[ft].icon .. " "
                end
                local icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"))
                return (icon or "󰈤") .. " "
              end,
              padding = { left = 0, right = 0 },
            },

            {
              "filename",
              padding = { left = 0, right = 0 },
              fmt = function(name)
                local ft = vim.bo.filetype
                if filetype_map[ft] then
                  return filetype_map[ft].name
                end
                return name
              end,
            },

            {
              function()
                local n = buffer_count()
                return n > 1 and ("+" .. (n - 1) .. " ") or ""
              end,
              cond = function()
                return buffer_count() > 1
              end,
              color = hl("Operator"),
            },

            {
              function()
                local tabs = vim.fn.tabpagenr("$")
                if tabs > 1 then
                  return vim.fn.tabpagenr() .. " of " .. tabs
                end
              end,
              icon = "󰓩",
              color = hl("Special"),
            },
          },

          lualine_x = {
            { "diff" },
          },

          lualine_y = {
            { "progress" },
            { "location", color = hl("Boolean") },
          },

          lualine_z = {
            {
              function()
                return os.date(" %X") -- shows current time
              end,
            },
          },
        },
      }
    end,
  },
}
