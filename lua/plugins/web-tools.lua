--
-- return {
--   "ray-x/web-tools.nvim",
--   enabled = true,
--   dependencies = {
--     "ray-x/guihua.lua",
--     "nvim-lua/plenary.nvim",
--   },
--   ft = { "html", "css", "javascript", "typescript", "json", "hurl" },
--   opts = {
--     keymaps = {
--       rename = nil,
--       repeat_rename = ".",
--     },
--     -- Configure browser-sync
--     browser_sync = {
--       enabled = true,
--       -- Watch these file extensions
--       watch = { "html", "css", "js", "json", "vue", "svelte", "astro" },
--       -- Additional browser-sync options
--       options = {
--         files = { "**/*.css", "**/*.html", "**/*.js" },  -- Explicitly watch CSS files
--         watchOptions = {
--           ignored = "**/node_modules/**",  -- Ignore node_modules
--           awaitWriteFinish = true,  -- Wait for file writes to complete
--         },
--         reloadOnRestart = true,
--         notify = true,
--       },
--     },
--     hurl = {
--       show_headers = false,
--       floating = true,
--       json5 = false,
--       formatters = {
--         json = { "jq" },
--         html = { "prettier", "--parser", "html" },
--       },
--     },
--   },
-- }
return {
  "ray-x/web-tools.nvim",
  enabled = true,
  dependencies = {
    "ray-x/guihua.lua",
    "nvim-lua/plenary.nvim",
  },
  ft = { "html", "css", "javascript", "typescript", "json", "hurl" },
  opts = {
    keymaps = {
      rename = nil,
      repeat_rename = ".",
    },
    -- Configure browser-sync
    browser_sync = {
      enabled = true,
      -- Command to start browser-sync (this is the key part)
      cmd = {
        "browser-sync", "start", "--server", "--files", 
        -- This is the correct way to specify files
        "**/*.html,**/*.css,**/*.js,**/*.json", 
        "--no-open",  -- Don't open browser automatically
        "--reload-delay", "300",  -- Small delay to ensure file is written
        "--reload-debounce", "500",  -- Debounce multiple rapid changes
        "--inject-changes",  -- Enable CSS injection without reload
      },
      -- Watch these file extensions
      watch = { "html", "css", "js", "json" },
      -- Additional browser-sync options
      options = {
        files = { 
          "**/*.css", 
          "**/*.html", 
          "**/*.js", 
          "**/*.json" 
        },
        watchOptions = {
          ignored = "**/node_modules/**",
          awaitWriteFinish = true,
          usePolling = true,  -- Use polling for better file detection
          interval = 100,  -- Check every 100ms
        },
        reloadOnRestart = true,
        notify = true,
        injectChanges = true,  -- This is crucial for CSS
        ghostMode = false,  -- Disable ghost mode for testing
        logLevel = "debug",  -- See what's happening
      },
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
}
