return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
      'DiffviewRefresh',
    },
    keys = {
      { '<leader>go', '<cmd>DiffviewOpen<CR>', desc = 'Open Diffview' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = 'Close Diffview' },
      { '<leader>gt', '<cmd>DiffviewToggleFiles<CR>', desc = 'Toggle File Panel' },
      { '<leader>gf', '<cmd>DiffviewFocusFiles<CR>', desc = 'Focus File Panel' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<CR>', desc = 'File History' },
      { '<leader>gr', '<cmd>DiffviewRefresh<CR>', desc = 'Refresh Diffview' },
    },
    config = function()
      require('diffview').setup {
        diff_binaries = false,
        enhanced_diff_hl = false,

        use_icons = false,
        show_help_hints = true,
        file_panel = { listing_style = 'tree' },
        view = { default = { layout = 'diff2_vertical' } },
      }
    end,
  },
}
