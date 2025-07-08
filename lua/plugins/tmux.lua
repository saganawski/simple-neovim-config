-- ~/.config/nvim/lua/plugins/tmux.lua
-- Tmux integration for seamless navigation
-- Version 1

return {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Navigate to left pane" },
        { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Navigate to lower pane" },
        { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Navigate to upper pane" },
        { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Navigate to right pane" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous pane" },
    },
    config = function()
        -- Optional: Configure vim-tmux-navigator
        vim.g.tmux_navigator_no_mappings = 0
        vim.g.tmux_navigator_save_on_switch = 2
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_preserve_zoom = 1
    end,
}
