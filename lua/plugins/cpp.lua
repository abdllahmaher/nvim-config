-- -- ~/.config/nvim/lua/plugins/cpp.lua
--
-- return {
--   {
--     "p00f/clangd_extensions.nvim",
--     dependencies = {
--       "neovim/nvim-lspconfig",
--       "mason-org/mason.nvim",
--       "mason-org/mason-lspconfig.nvim",
--       "hrsh7th/cmp-nvim-lsp", -- ADD THIS
--     },
--     ft = { "c", "cpp", "h", "hpp" },
--     config = function()
--       -- Safely require cmp_nvim_lsp
--       local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--       if not ok_cmp then
--         vim.notify("cmp-nvim-lsp not installed! Run :Lazy install hrsh7th/cmp-nvim-lsp", vim.log.levels.ERROR)
--         return
--       end
--
--       -- Setup clangd with nvim-lspconfig + Mason
--       local lspconfig = require("lspconfig")
--       lspconfig.clangd.setup({
--         capabilities = cmp_nvim_lsp.default_capabilities(),
--         cmd = {
--           "clangd",
--           "--background-index",
--           "--clang-tidy",
--           "--header-insertion=iwyu",
--           "--completion-style=detailed",
--           "--function-arg-placeholders",
--           "--fallback-style=llvm",
--         },
--       })
--
--       -- Setup clangd extensions
--       local ok_ext, clangd_ext = pcall(require, "clangd_extensions")
--       if ok_ext then
--         clangd_ext.setup({
--           server = {
--             capabilities = cmp_nvim_lsp.default_capabilities(),
--           },
--           extensions = {
--             autoSetHints = true,
--             inlay_hints = {
--               only_current_line = false,
--               show_parameter_hints = true,
--               parameter_hints_prefix = "← ",
--               other_hints_prefix = "→ ",
--               highlight = "Comment",
--             },
--           },
--         })
--       else
--         vim.notify("clangd_extensions.nvim not loaded!", vim.log.levels.WARN)
--       end
--
--       -- C++ keybindings
--       vim.keymap.set("n", "<leader>cf", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch source/header" })
--       vim.keymap.set("n", "<leader>ch", "<cmd>ClangdToggleInlayHints<cr>", { desc = "Toggle inlay hints" })
--
--       -- C++ file settings
--       vim.api.nvim_create_autocmd("FileType", {
--         pattern = { "cpp", "c", "h", "hpp" },
--         callback = function()
--           vim.bo.tabstop = 4
--           vim.bo.shiftwidth = 4
--           vim.bo.softtabstop = 4
--           vim.bo.expandtab = false
--
--           -- Auto insert common C++ template
--           if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
--             vim.fn.setline(1, "#include <iostream>")
--             vim.fn.setline(2, "")
--             vim.fn.setline(3, "using namespace std;")
--             vim.fn.setline(4, "")
--             vim.fn.setline(5, "int main() {")
--             vim.fn.setline(6, "    ")
--             vim.fn.setline(7, "    return 0;")
--             vim.fn.setline(8, "}")
--             vim.api.nvim_input("6G$")
--           end
--         end,
--       })
--     end,
--   },
-- }
--
--
--
--
--
--
--

return {
  {
    "p00f/clangd_extensions.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- <- make sure this is added
    },
    ft = { "c", "cpp", "h", "hpp" },
    config = function()
      local lspconfig = require("lspconfig")

      -- Safe require for cmp_nvim_lsp
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok then
        vim.notify("cmp_nvim_lsp not found! clangd_extensions may be limited.", vim.log.levels.WARN)
      end

      -- clangd setup
      lspconfig.clangd.setup({
        capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or nil,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      })

      -- clangd extensions setup
      local ok2, clangd_ext = pcall(require, "clangd_extensions")
      if ok2 then
        clangd_ext.setup({
          server = {
            capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or nil,
          },
          extensions = {
            autoSetHints = true,
            inlay_hints = {
              only_current_line = false,
              show_parameter_hints = true,
              parameter_hints_prefix = "← ",
              other_hints_prefix = "→ ",
              highlight = "Comment",
            },
          },
        })
      end
    end,
  },
}
