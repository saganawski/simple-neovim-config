-- ~/.config/nvim/init.lua
-- Main configuration file that loads all modules

-- Set mapleader early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
require("config.options")
require("config.keymaps")

-- Plugin management
require("config.lazy")

-- Load plugin configurations after lazy.nvim is set up
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.lsp")
  end,
})
