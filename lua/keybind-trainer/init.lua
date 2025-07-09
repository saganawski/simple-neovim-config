-- ~/.config/nvim/lua/keybind-trainer/init.lua
-- Main module for keybind trainer
-- Version 1

local M = {}
local api = vim.api
local fn = vim.fn

-- Keybinding categories and their exercises
M.categories = {
    {
        name = "File Navigation",
        icon = "🗂️",
        keybinds = {
            { keys = "<Space>ee", desc = "Toggle file explorer",                 practice = "Open the file explorer" },
            { keys = "<Space>ef", desc = "Toggle file explorer on current file", practice = "Find current file in explorer" },
            { keys = "<Space>ff", desc = "Find files",                           practice = "Search for a file by name" },
            { keys = "<Space>fs", desc = "Search text in files",                 practice = "Search for text across all files" },
            { keys = "<Space>fr", desc = "Recent files",                         practice = "Open a recently used file" },
            { keys = "<Space>fb", desc = "Browse open buffers",                  practice = "Switch to an open buffer" },
        }
    },
    {
        name = "Code Navigation (LSP)",
        icon = "🔍",
        keybinds = {
            { keys = "gd", desc = "Go to definition",     practice = "Jump to where this is defined" },
            { keys = "gR", desc = "Show all references",  practice = "Find all uses of this symbol" },
            { keys = "gi", desc = "Go to implementation", practice = "Jump to the implementation" },
            { keys = "K",  desc = "Show documentation",   practice = "View docs for symbol under cursor" },
            { keys = "]d", desc = "Next diagnostic",      practice = "Jump to next error/warning" },
            { keys = "[d", desc = "Previous diagnostic",  practice = "Jump to previous error/warning" },
        }
    },
    {
        name = "Code Editing",
        icon = "✏️",
        keybinds = {
            { keys = "<Space>ca", desc = "Code actions",            practice = "Show available code fixes" },
            { keys = "<Space>rn", desc = "Rename symbol",           practice = "Rename variable/function" },
            { keys = "<Space>mp", desc = "Format file",             practice = "Format the current file" },
            { keys = "jk",        desc = "Exit insert mode",        practice = "Quick escape from insert mode" },
            { keys = "J",         desc = "Move line down (visual)", practice = "Select lines and move them down" },
            { keys = "K",         desc = "Move line up (visual)",   practice = "Select lines and move them up" },
        }
    },
    {
        name = "Window Management",
        icon = "🪟",
        keybinds = {
            { keys = "<Space>sv", desc = "Split vertically",   practice = "Create a vertical split" },
            { keys = "<Space>sh", desc = "Split horizontally", practice = "Create a horizontal split" },
            { keys = "<Space>sx", desc = "Close split",        practice = "Close the current split" },
            { keys = "<C-h>",     desc = "Navigate left",      practice = "Move to left pane (works with tmux!)" },
            { keys = "<C-j>",     desc = "Navigate down",      practice = "Move to lower pane (works with tmux!)" },
            { keys = "<C-k>",     desc = "Navigate up",        practice = "Move to upper pane (works with tmux!)" },
            { keys = "<C-l>",     desc = "Navigate right",     practice = "Move to right pane (works with tmux!)" },
        }
    },
    {
        name = "Buffer & Tab Management",
        icon = "📑",
        keybinds = {
            { keys = "<S-h>",     desc = "Previous buffer", practice = "Switch to previous buffer" },
            { keys = "<S-l>",     desc = "Next buffer",     practice = "Switch to next buffer" },
            { keys = "<Space>to", desc = "New tab",         practice = "Open a new tab" },
            { keys = "<Space>tx", desc = "Close tab",       practice = "Close current tab" },
            { keys = "<Space>tn", desc = "Next tab",        practice = "Go to next tab" },
            { keys = "<Space>tp", desc = "Previous tab",    practice = "Go to previous tab" },
        }
    },
}

-- State management
M.state = {
    current_category = 1,
    current_exercise = 1,
    score = 0,
    completed = {},
    start_time = nil,
    practice_mode = false,
}

-- Create the trainer buffer
function M.create_trainer_buffer()
    -- Create a new buffer
    local buf = api.nvim_create_buf(false, true)

    -- Set buffer options
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'filetype', 'keybind-trainer')

    -- Make it the current buffer
    api.nvim_set_current_buf(buf)

    return buf
end

-- Render the trainer interface
function M.render_interface()
    local buf = api.nvim_get_current_buf()
    local category = M.categories[M.state.current_category]
    local exercise = category.keybinds[M.state.current_exercise]

    -- Clear buffer
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, {})

    -- Create the interface
    local lines = {
        "╔══════════════════════════════════════════════════════════════════╗",
        "║               🎮 Neovim Keybind Trainer v1.0 🎮                  ║",
        "╚══════════════════════════════════════════════════════════════════╝",
        "",
        string.format("Category: %s %s", category.icon, category.name),
        string.format("Progress: %d/%d | Score: %d", M.state.current_exercise, #category.keybinds, M.state.score),
        "",
        "┌─────────────────────────────────────────────────────────────────┐",
        "│ Current Exercise:                                               │",
        "├─────────────────────────────────────────────────────────────────┤",
        string.format("│ Task: %-57s │", exercise.practice),
        string.format("│ Keys: %-57s │", exercise.keys),
        string.format("│ Description: %-50s │", exercise.desc),
        "└─────────────────────────────────────────────────────────────────┘",
        "",
        "Instructions:",
        "• Press the shown key combination to complete the exercise",
        "• Press 'n' to skip to next exercise",
        "• Press 'p' to go to previous exercise",
        "• Press 'c' to change category",
        "• Press 'q' to quit",
        "• Press 'h' for help",
        "",
        "Hint: " .. M.get_hint(exercise.keys),
    }

    -- Add completed exercises
    if next(M.state.completed) then
        table.insert(lines, "")
        table.insert(lines, "Completed in this session:")
        for key, _ in pairs(M.state.completed) do
            table.insert(lines, "  ✓ " .. key)
        end
    end

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Set highlights
    M.set_highlights(buf)
end

-- Get hint for a keybinding
function M.get_hint(keys)
    local hints = {
        ["<Space>"] = "Space is your leader key!",
        ["<S-h>"] = "Shift+h (capital H)",
        ["<S-l>"] = "Shift+l (capital L)",
        ["<C-h>"] = "Ctrl+h",
        ["gd"] = "Press 'g' then 'd' in normal mode",
        ["jk"] = "Press 'j' then 'k' quickly in insert mode",
    }

    for pattern, hint in pairs(hints) do
        if keys:find(pattern) then
            return hint
        end
    end

    return "Press the keys in sequence"
end

-- Set highlights
function M.set_highlights(buf)
    -- Define highlight groups
    vim.cmd([[
    highlight KeybindTrainerTitle guifg=#7aa2f7 gui=bold
    highlight KeybindTrainerCategory guifg=#9ece6a gui=bold
    highlight KeybindTrainerKeys guifg=#f7768e gui=bold
    highlight KeybindTrainerCompleted guifg=#9ece6a
    highlight KeybindTrainerBorder guifg=#565f89
  ]])

    -- Apply highlights (simplified for now)
    -- In a real implementation, we'd use nvim_buf_add_highlight
end

-- Setup keymaps for the trainer buffer
function M.setup_keymaps(buf)
    local opts = { silent = true }

    -- Navigation
    api.nvim_buf_set_keymap(buf, 'n', 'n', '<cmd>lua require("keybind-trainer").next_exercise()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'p', '<cmd>lua require("keybind-trainer").prev_exercise()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'c', '<cmd>lua require("keybind-trainer").change_category()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>lua require("keybind-trainer").quit()<CR>', opts)
    api.nvim_buf_set_keymap(buf, 'n', 'h', '<cmd>lua require("keybind-trainer").show_help()<CR>', opts)

    -- Setup detection for current exercise
    local category = M.categories[M.state.current_category]
    local exercise = category.keybinds[M.state.current_exercise]

    -- Create autocmd to detect when the keybind is pressed
    M.setup_exercise_detection(exercise.keys)
end

-- Setup detection for exercise completion
function M.setup_exercise_detection(keys)
    -- This is simplified - in a real implementation, we'd need more sophisticated detection
    local buf = api.nvim_get_current_buf()

    -- Remove special characters for the mapping
    local map_keys = keys:gsub("<Space>", "<leader>")

    -- Try to detect the keypress
    vim.schedule(function()
        -- Create a temporary keymap that captures the exercise keys
        pcall(function()
            api.nvim_buf_set_keymap(buf, 'n', map_keys,
                '<cmd>lua require("keybind-trainer").complete_exercise()<CR>',
                { silent = true, nowait = true })
        end)
    end)
end

-- Complete current exercise
function M.complete_exercise()
    local category = M.categories[M.state.current_category]
    local exercise = category.keybinds[M.state.current_exercise]

    -- Mark as completed
    M.state.completed[exercise.keys] = true
    M.state.score = M.state.score + 10

    -- Show completion message
    vim.notify("✓ Completed: " .. exercise.desc, vim.log.levels.INFO)

    -- Auto advance after a short delay
    vim.defer_fn(function()
        M.next_exercise()
    end, 1500)
end

-- Navigation functions
function M.next_exercise()
    local category = M.categories[M.state.current_category]
    if M.state.current_exercise < #category.keybinds then
        M.state.current_exercise = M.state.current_exercise + 1
    else
        -- Move to next category
        if M.state.current_category < #M.categories then
            M.state.current_category = M.state.current_category + 1
            M.state.current_exercise = 1
        else
            vim.notify("🎉 Congratulations! You've completed all exercises!", vim.log.levels.INFO)
        end
    end
    M.render_interface()
    M.setup_keymaps(api.nvim_get_current_buf())
end

function M.prev_exercise()
    if M.state.current_exercise > 1 then
        M.state.current_exercise = M.state.current_exercise - 1
    else
        -- Move to previous category
        if M.state.current_category > 1 then
            M.state.current_category = M.state.current_category - 1
            local category = M.categories[M.state.current_category]
            M.state.current_exercise = #category.keybinds
        end
    end
    M.render_interface()
    M.setup_keymaps(api.nvim_get_current_buf())
end

function M.change_category()
    -- Create a simple menu
    local category_names = {}
    for i, cat in ipairs(M.categories) do
        table.insert(category_names, string.format("%d. %s %s", i, cat.icon, cat.name))
    end

    vim.ui.select(category_names, {
        prompt = "Select a category:",
    }, function(choice, idx)
        if idx then
            M.state.current_category = idx
            M.state.current_exercise = 1
            M.render_interface()
            M.setup_keymaps(api.nvim_get_current_buf())
        end
    end)
end

-- Show cheatsheet
function M.show_cheatsheet()
    local buf = M.create_trainer_buffer()
    api.nvim_buf_set_option(buf, 'modifiable', true)

    local lines = {
        "╔══════════════════════════════════════════════════════════════════╗",
        "║                    📚 Keybind Cheatsheet 📚                      ║",
        "╚══════════════════════════════════════════════════════════════════╝",
        "",
    }

    -- Add all categories and keybinds
    for _, category in ipairs(M.categories) do
        table.insert(lines, string.format("%s %s", category.icon, category.name))
        table.insert(lines, string.rep("─", 50))

        for _, kb in ipairs(category.keybinds) do
            table.insert(lines, string.format("  %-20s %s", kb.keys, kb.desc))
        end

        table.insert(lines, "")
    end

    -- Add tmux keybinds
    table.insert(lines, "🖥️  Tmux Integration")
    table.insert(lines, string.rep("─", 50))
    table.insert(lines, "  Ctrl+a              Tmux prefix key")
    table.insert(lines, "  Ctrl+h/j/k/l        Navigate panes (works in Neovim too!)")
    table.insert(lines, "  Ctrl+a |            Split vertically")
    table.insert(lines, "  Ctrl+a -            Split horizontally")
    table.insert(lines, "  Ctrl+a c            Create new window")
    table.insert(lines, "  Ctrl+a n/p          Next/previous window")
    table.insert(lines, "")
    table.insert(lines, "Press 'q' to close this cheatsheet")

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Simple quit mapping
    api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bdelete!<CR>', { silent = true })
end

-- Show help
function M.show_help()
    local help_text = {
        "Keybind Trainer Help:",
        "",
        "This trainer helps you learn the keybindings in your Neovim setup.",
        "",
        "How to use:",
        "1. Read the exercise task",
        "2. Press the shown key combination",
        "3. Move to the next exercise",
        "",
        "The trainer covers:",
        "• File navigation (Telescope, nvim-tree)",
        "• Code navigation (LSP jumps)",
        "• Code editing (formatting, actions)",
        "• Window management (splits, tmux integration)",
        "• Buffer and tab management",
        "",
        "Tips:",
        "• Take your time to memorize each keybind",
        "• Practice daily for best results",
        "• Use the cheatsheet (<leader>kc) as reference",
    }

    vim.notify(table.concat(help_text, "\n"), vim.log.levels.INFO)
end

-- Quit the trainer
function M.quit()
    local buf = api.nvim_get_current_buf()

    -- Show summary
    local duration = os.time() - (M.state.start_time or os.time())
    local minutes = math.floor(duration / 60)
    local seconds = duration % 60

    local summary = string.format(
        "Training Summary:\n" ..
        "• Score: %d\n" ..
        "• Completed: %d exercises\n" ..
        "• Time: %dm %ds\n" ..
        "\nGreat job! Keep practicing!",
        M.state.score,
        vim.tbl_count(M.state.completed),
        minutes,
        seconds
    )

    vim.notify(summary, vim.log.levels.INFO)

    -- Close buffer
    vim.cmd('bdelete!')
end

-- Start the trainer
function M.start()
    -- Show the main menu instead of going directly to training
    require("keybind-trainer.menu").show()
end

-- Start training mode (called from menu)
function M.start_training()
    -- Reset state
    M.state = {
        current_category = 1,
        current_exercise = 1,
        score = 0,
        completed = {},
        start_time = os.time(),
        practice_mode = false,
    }

    -- Create and setup buffer
    local buf = M.create_trainer_buffer()
    M.render_interface()
    M.setup_keymaps(buf)

    -- Welcome message
    vim.notify("Welcome to Training Mode! Let's learn some keybindings! 🚀", vim.log.levels.INFO)
end

return M
