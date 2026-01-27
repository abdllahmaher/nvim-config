return {
  {
    "stevearc/conform.nvim",
    enabled = false,
    opts = {

      formatters_by_ft = {
        javascript = {
          function(bufnr)
            -- only format if file is valid
            local ok = vim.fn.system("node -c " .. vim.api.nvim_buf_get_name(bufnr))
            if ok == "" then
              return { "prettier" }
            end
            return {}
          end,
        },
      },
    },
  },
}


