-- ~/.config/nvim/lua/keybind-trainer/game.lua
-- Game mode for keybind trainer
-- Version 2 - Fixed

local M = {}
local api = vim.api

-- Game state
M.game_state = {
  score = 0,
  level = 1,
  lives = 3,
  time_limit = 10, -- seconds per challenge
  current_challenge = nil,
  start_time = nil,
  high_score = 0,
}

-- Get random keybind challenge
function M.get_random_challenge()
  local trainer = require("keybind-trainer")
  local all_keybinds = {}
  
  -- Collect all keybinds
  for _, category in ipairs(trainer.categories) do
    for _, kb in ipairs(category.keybinds) do
      table.insert(all_keybinds, {
        keys = kb.keys,
        desc = kb.desc,
        category = category.name,
      })
    end
  end
  
  -- Return random keybind
  return all_keybinds[math.random(#all_keybinds)]
end

-- Create game buffer
function M.create_game_buffer()
  local buf = api.nvim_create_buf(false, true)
  
  api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'swapfile', false)
  api.nvim_buf_set_option(buf, 'filetype', 'keybind-game')
  
  api.nvim_set_current_buf(buf)
  
  return buf
end

-- Render game interface
function M.render_game()
  local buf = api.nvim_get_current_buf()
  api.nvim_buf_set_option(buf, 'modifiable', true)
  
  local challenge = M.game_state.current_challenge
  local time_left = M.game_state.time_limit - (os.time() - M.game_state.start_time)
  
  -- Create ASCII art game interface
  local lines = {
    "╔══════════════════════════════════════════════════════════════════╗",
    "║                    🎮 KEYBIND CHALLENGE 🎮                       ║",
    "╚══════════════════════════════════════════════════════════════════╝",
    "",
    string.format("Score: %d  |  Level: %d  |  Lives: %s  |  Time: %ds",
      M.game_state.score,
      M.game_state.level,
      string.rep("❤️ ", M.game_state.lives),
      math.max(0, time_left)
    ),
    "",
    "┌─────────────────────────────────────────────────────────────────┐",
    "│                                                                 │",
    "│                        QUICK! PRESS:                            │",
    "│                                                                 │",
    string.format("│                          %s                                     │", 
      M.center_text(challenge.keys, 65)),
    "│                                                                 │",
    string.format("│                    To: %-40s │", challenge.desc),
    "│                                                                 │",
    "└─────────────────────────────────────────────────────────────────┘",
    "",
  }
  
  -- Add progress bar
  local progress_width = 50
  local progress = math.floor((time_left / M.game_state.time_limit) * progress_width)
  local progress_bar = "[" .. string.rep("=", progress) .. string.rep(" ", progress_width - progress) .. "]"
  table.insert(lines, "Time: " .. progress_bar)
  
  -- Add instructions
  table.insert(lines, "")
  table.insert(lines, "Press 'q' to quit | Press 's' to skip (-1 life)")
  
  -- Add high score
  if M.game_state.high_score > 0 then
    table.insert(lines, "")
    table.insert(lines, string.format("High Score: %d", M.game_state.high_score))
  end
  
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Apply highlights
  M.apply_game_highlights(buf)
end

-- Center text helper
function M.center_text(text, width)
  local padding = math.floor((width - #text) / 2)
  return string.rep(" ", padding) .. text
end

-- Apply game highlights
function M.apply_game_highlights(buf)
  vim.cmd([[
    highlight KeybindGameTitle guifg=#f7768e gui=bold
    highlight KeybindGameScore guifg=#9ece6a gui=bold
    highlight KeybindGameKeys guifg=#7aa2f7 gui=bold
    highlight KeybindGameProgress guifg=#e0af68
  ]])
end

-- Setup game keymaps
function M.setup_game_keymaps(buf)
  local opts = { silent = true }
  
  -- Quit
  api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>lua require("keybind-trainer.game").quit_game()<CR>', opts)
  
  -- Skip (costs a life)
  api.nvim_buf_set_keymap(buf, 'n', 's', '<cmd>lua require("keybind-trainer.game").skip_challenge()<CR>', opts)
  
  -- Setup detection for current challenge
  M.setup_challenge_detection()
end

-- Setup challenge detection
function M.setup_challenge_detection()
  local challenge = M.game_state.current_challenge
  local buf = api.nvim_get_current_buf()
  
  -- Convert keys for mapping
  local map_keys = challenge.keys:gsub("<Space>", "<leader>")
  
  -- Try to create the mapping
  pcall(function()
    api.nvim_buf_set_keymap(buf, 'n', map_keys,
      '<cmd>lua require("keybind-trainer.game").complete_challenge()<CR>',
      { silent = true, nowait = true })
  end)
end

-- Complete challenge
function M.complete_challenge()
  -- Calculate score based on time
  local time_taken = os.time() - M.game_state.start_time
  local time_bonus = math.max(0, M.game_state.time_limit - time_taken) * 10
  local base_score = 100
  
  M.game_state.score = M.game_state.score + base_score + time_bonus
  
  -- Level up every 500 points
  if M.game_state.score > M.game_state.level * 500 then
    M.game_state.level = M.game_state.level + 1
    M.game_state.time_limit = math.max(3, M.game_state.time_limit - 1) -- Decrease time limit
    vim.notify("🎉 LEVEL UP! Time limit decreased!", vim.log.levels.INFO)
  end
  
  -- Show success message
  vim.notify(string.format("✓ Correct! +%d points!", base_score + time_bonus), vim.log.levels.INFO)
  
  -- Next challenge
  M.next_challenge()
end

-- Skip challenge
function M.skip_challenge()
  M.game_state.lives = M.game_state.lives - 1
  
  if M.game_state.lives <= 0 then
    M.game_over()
  else
    vim.notify("Skipped! -1 ❤️", vim.log.levels.WARN)
    M.next_challenge()
  end
end

-- Next challenge
function M.next_challenge()
  M.game_state.current_challenge = M.get_random_challenge()
  M.game_state.start_time = os.time()
  
  M.render_game()
  M.setup_game_keymaps(api.nvim_get_current_buf())
  
  -- Start timer
  M.start_timer()
end

-- Start timer
function M.start_timer()
  -- Cancel existing timer
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  
  -- Create new timer
  M.timer = vim.fn.timer_start(1000, function()
    local time_left = M.game_state.time_limit - (os.time() - M.game_state.start_time)
    
    if time_left <= 0 then
      -- Time's up!
      vim.fn.timer_stop(M.timer)
      M.game_state.lives = M.game_state.lives - 1
      
      if M.game_state.lives <= 0 then
        M.game_over()
      else
        vim.notify("⏰ Time's up! -1 ❤️", vim.log.levels.ERROR)
        M.next_challenge()
      end
    else
      -- Update display
      M.render_game()
    end
  end, { ['repeat'] = -1 })
end

-- Game over
function M.game_over()
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  
  -- Update high score
  if M.game_state.score > M.game_state.high_score then
    M.game_state.high_score = M.game_state.score
    vim.notify("🏆 NEW HIGH SCORE!", vim.log.levels.INFO)
  end
  
  local buf = api.nvim_get_current_buf()
  api.nvim_buf_set_option(buf, 'modifiable', true)
  
  -- Game over screen
  local lines = {
    "",
    "",
    "  ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ ",
    " ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗",
    " ██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝",
    " ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗",
    " ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║",
    "  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝",
    "",
    "",
    string.format("                        Final Score: %d", M.game_state.score),
    string.format("                        Level Reached: %d", M.game_state.level),
    string.format("                        High Score: %d", M.game_state.high_score),
    "",
    "",
    "                    Press 'r' to play again",
    "                    Press 'q' to quit",
    "                    Press 't' for training mode",
    "",
  }
  
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Game over keymaps
  local opts = { silent = true }
  api.nvim_buf_set_keymap(buf, 'n', 'r', '<cmd>lua require("keybind-trainer.game").start()<CR>', opts)
  api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bdelete!<CR>', opts)
  api.nvim_buf_set_keymap(buf, 'n', 't', '<cmd>bdelete!<CR><cmd>KeybindTrainer<CR>', opts)
end

-- Quit game
function M.quit_game()
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  
  vim.cmd('bdelete!')
end

-- Start game
function M.start()
  -- Reset game state
  M.game_state = {
    score = 0,
    level = 1,
    lives = 3,
    time_limit = 10,
    current_challenge = nil,
    start_time = nil,
    high_score = M.game_state.high_score or 0, -- Preserve high score
  }
  
  -- Create game buffer
  M.create_game_buffer()
  
  -- Start first challenge
  M.next_challenge()
  
  vim.notify("🎮 Game started! Press the keybinds as fast as you can!", vim.log.levels.INFO)
end

return M
