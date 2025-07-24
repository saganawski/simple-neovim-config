-- ~/.config/nvim/lua/plugins/git-blame.lua
-- Git blame with heatmap visualization

return {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('gitblame').setup({
            enabled = false,    -- Disable by default, toggle with :GitBlameToggle
            message_template = '<author> • <date> • <summary>',
            date_format = '%r', -- Relative date
            message_when_not_committed = 'Not Committed Yet',
            highlight_group = "Comment",
            set_extmark_options = {
                priority = 7,
            },
            display_virtual_text = 1,
            ignored_filetypes = { 'nvim-tree', 'telescope', 'lazy' },
            delay = 1000,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Toggle git blame" })
        vim.keymap.set("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<CR>", { desc = "Open commit URL" })
        vim.keymap.set("n", "<leader>gc", "<cmd>GitBlameCopySHA<CR>", { desc = "Copy commit SHA" })
    end,
}
