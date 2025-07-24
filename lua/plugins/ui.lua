-- ~/.config/nvim/lua/plugins/ui.lua
-- UI enhancement plugins

return {
    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local lualine = require("lualine")
            local lazy_status = require("lazy.status")

            lualine.setup({
                options = {
                    theme = "tokyonight",
                },
                sections = {
                    lualine_x = {
                        {
                            lazy_status.updates,
                            cond = lazy_status.has_updates,
                            color = { fg = "#ff9e64" },
                        },
                        { "encoding" },
                        { "fileformat" },
                        { "filetype" },
                    },
                },
            })
        end,
    },

    -- Buffer line
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        version = "*",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    always_show_bufferline = false,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    color_icons = true,
                },
                highlights = {
                    separator = {
                        fg = "#073642",
                        bg = "#002b36",
                    },
                    separator_selected = {
                        fg = "#073642",
                    },
                    background = {
                        fg = "#657b83",
                        bg = "#002b36",
                    },
                    buffer_selected = {
                        fg = "#fdf6e3",
                        bold = true,
                    },
                    fill = {
                        bg = "#073642",
                    },
                },
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "┊" },
                scope = { enabled = false },
            })
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                -- Add line number highlighting
                numhl = true,      -- Highlight line numbers
                linehl = false,    -- Set to true if you want the whole line highlighted
                word_diff = false, -- Set to true for word-level diff highlights
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`

                watch_gitdir = {
                    interval = 1000,
                    follow_files = true
                },

                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end


                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Jump to next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Jump to previous hunk" })

                    -- Actions
                    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
                    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
                    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Blame line" })
                    map("n", "<leader>hd", gs.diffthis, { desc = "Diff against index" })
                    map("n", "<leader>hD", function()
                        gs.diffthis("~")
                    end, { desc = "Diff against last commit" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
                end,
            })
        end,
    },
}
