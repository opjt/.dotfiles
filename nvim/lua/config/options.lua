-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true
vim.opt.linebreak = true -- wrap at word boundaries, not mid-word

-- lima guests have no pbcopy/xclip reaching the mac clipboard, so yanks go
-- nowhere by default. Route them to the host clipboard via OSC 52 instead,
-- which the terminal (over SSH) forwards to macOS.
if (vim.uv or vim.loop).os_uname().sysname == "Linux" then
  -- Mirror yanks to the mac clipboard via OSC 52, without touching how
  -- registers or "p" work, so normal yy/p stays exactly as it always was.
  local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == "y" then
        osc52_copy(vim.v.event.regcontents)
      end
    end,
  })
end
