return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local venv = require("venv-selector").venv()
          return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
        end,
        cond = function()
          return vim.bo.filetype == "python" and require("venv-selector").venv() ~= nil
        end,
      })
    end,
  },
}
