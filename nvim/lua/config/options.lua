-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true
vim.opt.linebreak = true -- wrap at word boundaries, not mid-word

-- lima guests have no pbcopy/xclip reaching the mac clipboard, so yanks go
-- nowhere by default. Route them to the host clipboard via OSC 52 instead,
-- which the terminal (over SSH) forwards to macOS.
if (vim.uv or vim.loop).os_uname().sysname == "Linux" then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
  vim.opt.clipboard = "unnamedplus"
end
