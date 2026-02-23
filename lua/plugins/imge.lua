return {
  "3rd/image.nvim",
  build = false,
  opts = {
    backend = "kitty",
    processor = "magick_cli",

    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = false,
        filetypes = { "markdown", "vimwiki" },
      },
      asciidoc = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = false,
        filetypes = { "asciidoc", "adoc" },
      },
      neorg = {
        enabled = true,
        filetypes = { "norg" },
      },
      rst = { enabled = true },
      typst = {
        enabled = true,
        filetypes = { "typst" },
      },
    },

    max_height_window_percentage = 50,
    scale_factor = 1.0,

    hijack_file_patterns = {
      "*.png",
      "*.jpg",
      "*.jpeg",
      "*.gif",
      "*.webp",
      "*.avif",
    },
  },
}
