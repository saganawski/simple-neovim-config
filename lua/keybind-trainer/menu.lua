-- ~/.config/nvim/lua/keybind-trainer/menu.lua
-- Menu system for keybind trainer
-- Version 1

local M = {}
local api = vim.api

-- Menu options
M.menu_options = {
    { key = "1", label = "📚 Training Mode", desc = "Learn keybindings step by step", action = "trainer" },
    { key = "2", label = "🎮 Challenge Game", desc = "Test your speed and memory", action = "game" },
    { key = "3", label = "📖 Cheatsheet", desc = "View all keybindings", action = "cheatsheet" },
    { key = "4", label = "📊 Statistics", desc = "View your progress", action = "stats" },
    { key = "5", label = "⚙️  Settings", desc = "Configure trainer options", action = "settings" },
    { key = "q", label = "🚪 Quit", desc = "Exit the trainer", action = "quit" },
}

-- Create menu buffer
function M.create_menu_buffer()
    local buf = api.nvim_create_buf(false, true)

    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'filetype', 'keybind-menu')

    api.nvim_set_current_buf(buf)

    return buf
end

-- Render menu
function M.render_menu()
    local buf = api.nvim_get_current_buf()
    api.nvim_buf_set_option(buf, 'modifiable', true)

    local lines = {
        "",
        "     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
        "           🎯 KEYBIND TRAINER - MAIN MENU 🎯",
        "",
        "  ┌─────────────────────────────────────────────────────┐",
    }

    -- Add menu options
    for _, option in ipairs(M.menu_options) do
        table.insert(lines, string.format("  │  [%s] %-15s - %-25s │",
            option.key, option.label, option.desc))
    end

    table.insert(lines, "  └─────────────────────────────────────────────────────┘")
    table.insert(lines, "")
    table.insert(lines, "     Press a number or letter to select an option")
    table.insert(lines, "")

    -- Add stats preview
    local stats = M.load_stats()
    if stats.total_exercises > 0 then
        table.insert(lines, "  📊 Quick Stats:")
        table.insert(lines, string.format("  • Total exercises completed: %d", stats.total_exercises))
        table.insert(lines, string.format("  • Best game score: %d", stats.high_score or 0))
        table.insert(lines, string.format("  • Training sessions: %d", stats.sessions or 0))
    end

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Apply highlights
    M.apply_menu_highlights(buf)
end

-- Apply menu highlights
function M.apply_menu_highlights(buf)
    vim.cmd([[
    highlight KeybindMenuTitle guifg=#7aa2f7 gui=bold
    highlight KeybindMenuOption guifg=#9ece6a
    highlight KeybindMenuKey guifg=#f7768e gui=bold
    highlight KeybindMenuBorder guifg=#565f89
  ]])
end

-- Setup menu keymaps
function M.setup_menu_keymaps(buf)
    local opts = { silent = true }

    for _, option in ipairs(M.menu_options) do
        api.nvim_buf_set_keymap(buf, 'n', option.key,
            string.format('<cmd>lua require("keybind-trainer.menu").select_option("%s")<CR>', option.action),
            opts)
    end
end

-- Select menu option
function M.select_option(action)
    if action == "trainer" then
        vim.cmd('bdelete!')
        require("keybind-trainer").start_training()
    elseif action == "game" then
        vim.cmd('bdelete!')
        require("keybind-trainer.game").start()
    elseif action == "cheatsheet" then
        vim.cmd('bdelete!')
        require("keybind-trainer").show_cheatsheet()
    elseif action == "stats" then
        M.show_statistics()
    elseif action == "settings" then
        M.show_settings()
    elseif action == "quit" then
        vim.cmd('bdelete!')
    end
end

-- Load stats
function M.load_stats()
    -- In a real implementation, this would load from a file
    return {
        total_exercises = 0,
        high_score = 0,
        sessions = 0,
        favorite_keys = {},
        problem_keys = {},
    }
end

-- Show statistics
function M.show_statistics()
    local buf = M.create_menu_buffer()
    api.nvim_buf_set_option(buf, 'modifiable', true)

    local stats = M.load_stats()

    local lines = {
        "╔══════════════════════════════════════════════════════════════════╗",
        "║                         📊 STATISTICS 📊                         ║",
        "╚══════════════════════════════════════════════════════════════════╝",
        "",
        "Training Progress:",
        string.format("  • Total exercises completed: %d", stats.total_exercises),
        string.format("  • Training sessions: %d", stats.sessions or 0),
        string.format("  • Average accuracy: %.1f%%", stats.accuracy or 100),
        "",
        "Game Stats:",
        string.format("  • High score: %d", stats.high_score or 0),
        string.format("  • Games played: %d", stats.games_played or 0),
        "",
        "Most Used Keybindings:",
        "  1. <Space>ff - Find files",
        "  2. gd - Go to definition",
        "  3. <Space>ca - Code actions",
        "",
        "Need More Practice:",
        "  1. <C-w>v - Split vertically",
        "  2. <Space>rn - Rename symbol",
        "  3. ]d - Next diagnostic",
        "",
        "Press 'b' to go back to menu | Press 'q' to quit",
    }

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Keymaps
    local opts = { silent = true }
    api.nvim_buf_set_keymap(buf, 'n', 'b', '<cmd>lua require("keybind-trainer.menu").show()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bdelete!<CR>', opts)
end

-- Show settings
function M.show_settings()
    local buf = M.create_menu_buffer()
    api.nvim_buf_set_option(buf, 'modifiable', true)

    local lines = {
        "╔══════════════════════════════════════════════════════════════════╗",
        "║                          ⚙️  SETTINGS ⚙️                          ║",
        "╚══════════════════════════════════════════════════════════════════╝",
        "",
        "Trainer Options:",
        "  [ ] Show hints immediately",
        "  [x] Play sound effects",
        "  [x] Auto-advance exercises",
        "  [ ] Practice mode (no scoring)",
        "",
        "Game Options:",
        "  Initial time limit: 10 seconds",
        "  Lives: 3",
        "  Difficulty: Normal",
        "",
        "Display Options:",
        "  [x] Show animations",
        "  [x] Use colors",
        "  [ ] Minimal UI",
        "",
        "Keybinding Categories:",
        "  [x] File Navigation",
        "  [x] Code Navigation",
        "  [x] Code Editing",
        "  [x] Window Management",
        "  [x] Buffer Management",
        "",
        "Press 'b' to go back to menu | Press 'q' to quit",
        "",
        "(Settings are not persistent in this demo version)",
    }

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Keymaps
    local opts = { buffer = buf, silent = true }
    api.nvim_buf_set_keymap(buf, 'n', 'b', '<cmd>lua require("keybind-trainer.menu").show()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bdelete!<CR>', opts)
end

-- Show menu
function M.show()
    local buf = M.create_menu_buffer()
    M.render_menu()
    M.setup_menu_keymaps(buf)
end

return M
