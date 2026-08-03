return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      styles = {
        comments = { italic = false },
      },
      on_highlights = function(hl, c)
        hl.Comment = {
          fg = c.dark5,
          italic = false,
        }
      end,
    },
  },
}
