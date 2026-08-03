return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log({ current_file = true })
        end,
        desc = "Git Log (current file)",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log (repo)",
      },
    },
  },
}
