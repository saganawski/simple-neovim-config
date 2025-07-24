-- ~/.config/nvim/lua/plugins/git-heatmap.lua
-- Visual git heatmap showing code age

return {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    config = function()
        require('blame').setup({
            -- Show blame info in virtual text
            virtual_text = true,
            -- Use relative dates
            date_format = "%d.%m.%Y",
            -- Merge consecutive lines with same commit
            merge_consecutive = false,
            -- Maximum blur amount for old commits
            max_summary_width = 30,
            -- Colors from new to old (green -> yellow -> red)
            colors = {
                "#00ff00", -- Bright green (newest)
                "#40ff00",
                "#80ff00",
                "#bfff00",
                "#ffff00", -- Yellow
                "#ffbf00",
                "#ff8000",
                "#ff4000",
                "#ff0000", -- Red (oldest)
            },
        })

        -- Toggle heatmap view
        vim.keymap.set("n", "<leader>gh", "<cmd>BlameToggle<CR>", { desc = "Toggle git heatmap" })
    end,
}
