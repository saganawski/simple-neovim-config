-- ~/.config/nvim/lua/plugins/keybind-trainer.lua
-- Interactive keybinding trainer for your Neovim setup
-- Version 2 - Fixed

return {
    "keybind-trainer",
    dir = vim.fn.stdpath("config") .. "/lua/keybind-trainer",
    lazy = false, -- Load immediately
    cmd = { "KeybindTrainer", "KeybindCheatsheet", "KeybindGame" },
    keys = {
        { "<leader>kt", "<cmd>KeybindTrainer<CR>",    desc = "Start Keybind Trainer" },
        { "<leader>kc", "<cmd>KeybindCheatsheet<CR>", desc = "Show Keybind Cheatsheet" },
        { "<leader>kg", "<cmd>KeybindGame<CR>",       desc = "Start Keybind Game" },
    },
    config = function()
        -- Create commands
        vim.api.nvim_create_user_command("KeybindTrainer", function()
            require("keybind-trainer").start()
        end, {})

        vim.api.nvim_create_user_command("KeybindCheatsheet", function()
            require("keybind-trainer").show_cheatsheet()
        end, {})

        vim.api.nvim_create_user_command("KeybindGame", function()
            require("keybind-trainer.game").start()
        end, {})

        -- Ensure keymaps are set
        vim.keymap.set("n", "<leader>kt", "<cmd>KeybindTrainer<CR>", { desc = "Start Keybind Trainer" })
        vim.keymap.set("n", "<leader>kg", "<cmd>KeybindGame<CR>", { desc = "Start Keybind Game" })
        vim.keymap.set("n", "<leader>kc", "<cmd>KeybindCheatsheet<CR>", { desc = "Show Keybind Cheatsheet" })
    end,
}
