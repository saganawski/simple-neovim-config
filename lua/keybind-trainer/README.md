# 🎮 Neovim Keybind Trainer

An interactive plugin to help you master the keybindings in your Neovim setup. Inspired by vim-be-good, this trainer provides multiple modes to learn and practice your custom keybindings.

## Features

### 📚 Training Mode

- **Step-by-step learning**: Go through each keybinding category systematically
- **Interactive exercises**: Practice each keybinding with real-time feedback
- **Progress tracking**: See which keybindings you've mastered
- **Helpful hints**: Get tips for complex key combinations

### 🎮 Challenge Game

- **Speed test**: How fast can you execute the keybindings?
- **Lives system**: Make mistakes and learn from them
- **Level progression**: Difficulty increases as you improve
- **High score tracking**: Beat your personal best
- **Time pressure**: Race against the clock

### 📖 Cheatsheet

- **Complete reference**: All keybindings in one place
- **Categorized view**: Organized by function type
- **Quick lookup**: Easy to scan and find what you need
- **Includes tmux bindings**: Seamless navigation reference

### 📊 Statistics

- Track your learning progress
- See which keybindings you use most
- Identify areas that need practice
- Monitor improvement over time

## Installation

The trainer is already included in your config! Just use these commands:

```vim
:KeybindTrainer    " Open the main menu
:KeybindGame       " Jump straight to the game
:KeybindCheatsheet " View the cheatsheet
```

Or use the keybindings:

- `<leader>kt` - Start Keybind Trainer
- `<leader>kg` - Start Keybind Game
- `<leader>kc` - Show Keybind Cheatsheet

## How to Use

### Main Menu

When you start the trainer, you'll see a menu with options:

1. **Training Mode** - Learn systematically
2. **Challenge Game** - Test your speed
3. **Cheatsheet** - Quick reference
4. **Statistics** - View your progress
5. **Settings** - Configure options

### Training Mode

1. Read the exercise description
2. Press the indicated keys
3. Get instant feedback
4. Progress to the next exercise

**Controls:**

- `n` - Next exercise
- `p` - Previous exercise
- `c` - Change category
- `q` - Quit
- `h` - Help

### Challenge Game

1. Keybindings appear on screen
2. Execute them as fast as possible
3. Earn points for speed
4. Level up for harder challenges
5. Don't run out of time or lives!

**Controls:**

- `s` - Skip (costs a life)
- `q` - Quit game

## Categories Covered

### 🗂️ File Navigation

- File explorer (nvim-tree)
- Fuzzy finding (Telescope)
- Recent files
- Buffer switching

### 🔍 Code Navigation

- Go to definition
- Find references
- Show documentation
- Navigate diagnostics

### ✏️ Code Editing

- Code actions
- Rename symbols
- Format code
- Text manipulation

### 🪟 Window Management

- Split creation
- Pane navigation
- Tmux integration
- Window resizing

### 📑 Buffer & Tabs

- Buffer navigation
- Tab management
- Quick switching

## Tips for Learning

1. **Start with Training Mode** - Don't rush into the game
2. **Practice daily** - Even 5 minutes helps
3. **Focus on one category** - Master one before moving on
4. **Use in real work** - Apply what you learn immediately
5. **Review the cheatsheet** - Keep it open while coding

## Customization

To add your own keybindings to the trainer:

1. Edit `lua/keybind-trainer/init.lua`
2. Add to the `M.categories` table:

```lua
{
  name = "My Category",
  icon = "🔧",
  keybinds = {
    { keys = "<leader>xx", desc = "My action", practice = "Do something cool" },
  }
}
```

## Troubleshooting

- **Keys not detected?** Some complex keybindings might not work in the trainer buffer. The real keybinding still works in normal buffers.
- **Game too fast/slow?** Adjust the initial time limit in settings
- **Missing keybindings?** Check if they're included in the categories

## Future Improvements

- Persistent statistics across sessions
- Custom difficulty levels
- Multiplayer challenges
- More game modes
- Achievement system

Enjoy mastering your Neovim keybindings! 🚀
