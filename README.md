# Neovim Configuration for Python & JavaScript Development

A comprehensive Neovim configuration optimized for Python and JavaScript development on Ubuntu. This setup provides a modern IDE-like experience with LSP support, intelligent autocompletion, file navigation, productivity features, and seamless tmux integration.

## 🎯 What This Config Supports

**Primary Languages:**

- **Python** - Full LSP support with Pyright, Black formatting, isort, and Pylint linting
- **JavaScript/TypeScript** - Complete development environment with ts_ls, Prettier, and ESLint
- **Additional** - Lua, HTML, CSS with syntax highlighting and basic LSP

## 🚀 Features

- **LSP Integration** - Intelligent code completion, go-to-definition, error checking
- **File Navigation** - Telescope fuzzy finder and nvim-tree file explorer
- **Auto-formatting** - Format on save with language-specific formatters
- **Linting** - Real-time error detection and code quality checks
- **Git Integration** - Git signs and blame functionality
- **Modern UI** - Beautiful status line, buffer tabs, and syntax highlighting
- **Productivity** - Auto-pairs, treesitter, and smart key bindings
- **Tmux Integration** - Seamless navigation between Neovim and tmux panes
- **Interactive Keybind Trainer** - Learn all keybindings through games and exercises

## 📋 Requirements

### System Requirements

- **OS**: Ubuntu 20.04+ (tested on Ubuntu)
- **Neovim**: Version 0.10.0 or higher
- **Node.js**: 16+ (for JavaScript LSP and tools)
- **Python**: 3.8+ (for Python development)
- **Git**: For plugin management

### Required System Packages

```bash
sudo apt update
sudo apt install -y curl git nodejs npm python3-pip python3-venv ripgrep fd-find build-essential cmake
```

## 🛠️ Installation

### 1. Upgrade Neovim (if needed)

```bash
# Add official Neovim PPA for latest version
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

### 2. Install Nerd Font (for icons)

```bash
# Download and install JetBrains Mono Nerd Font
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
sudo mkdir -p /usr/local/share/fonts/JetBrainsMono
sudo cp JetBrainsMono/*.ttf /usr/local/share/fonts/JetBrainsMono/
sudo fc-cache -fv
```

### 3. Install Configuration

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true

# Clone this repository
git clone https://github.com/saganawski/simple-neovim-config.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### 4. Configure Terminal Font

Set your terminal to use "JetBrainsMono Nerd Font" for proper icon display:

- **GNOME Terminal**: Preferences → Profiles → Text → Font
- **Alacritty**: Edit `~/.config/alacritty/alacritty.yml`
- **Kitty**: Edit `~/.config/kitty/kitty.conf`

## 🖥️ Tmux Integration

This Neovim configuration works seamlessly with tmux for the ultimate terminal multiplexer experience.

### Installing Tmux Configuration

```bash
# Install tmux
sudo apt update
sudo apt install -y tmux

# Clone the tmux configuration
git clone https://github.com/saganawski/tmux.git ~/.config/tmux-temp

# Backup existing config (if any)
mv ~/.config/tmux ~/.config/tmux.backup 2>/dev/null || true

# Move the configuration files
mv ~/.config/tmux-temp/.config/tmux ~/.config/
rm -rf ~/.config/tmux-temp

# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux
tmux new -s dev

# Install plugins (inside tmux)
# Press Ctrl+a then I (capital i) to install all plugins
```

### Tmux Key Bindings

**Prefix**: `Ctrl+a` (changed from default `Ctrl+b` for easier access)

| Key | Action |
|-----|--------|
| `Ctrl+a c` | Create new window |
| `Ctrl+a \|` | Split pane vertically |
| `Ctrl+a -` | Split pane horizontally |
| `Ctrl+a x` | Close current pane |
| `Ctrl+a z` | Toggle pane zoom |
| `Ctrl+a d` | Detach from session |
| `Ctrl+a [` | Enter copy mode |

### Seamless Navigation

The best feature! Use these keys to navigate between Neovim splits AND tmux panes:

| Key | Action |
|-----|--------|
| `Ctrl+h` | Navigate left (works in both Neovim and tmux!) |
| `Ctrl+j` | Navigate down |
| `Ctrl+k` | Navigate up |
| `Ctrl+l` | Navigate right |

## 🎮 Keybind Trainer Game

Master your keybindings with the built-in interactive trainer! Inspired by vim-be-good, this game helps you build muscle memory for all the custom keybindings in this configuration.

### Starting the Trainer

```vim
:KeybindTrainer    " Open the main menu
:KeybindGame       " Jump straight to the challenge game
:KeybindCheatsheet " View all keybindings
```

Or use keybindings:
- `<Space>kt` - Start Keybind Trainer
- `<Space>kg` - Start Keybind Game
- `<Space>kc` - Show Keybind Cheatsheet

### Game Modes

1. **📚 Training Mode** - Learn keybindings step-by-step with guided exercises
2. **🎮 Challenge Game** - Test your speed and accuracy under time pressure
3. **📖 Cheatsheet** - Quick reference for all keybindings
4. **📊 Statistics** - Track your learning progress

### How to Play

**Training Mode:**
- Follow the on-screen prompts
- Press the displayed keybinding
- Get instant feedback
- Progress through categories

**Game Mode:**
- Keybindings appear on screen
- Execute them before time runs out
- Earn points for speed
- Level up for harder challenges
- Don't lose all your lives!

### Tips for Success

1. Start with Training Mode to learn systematically
2. Practice for 5-10 minutes daily
3. Focus on one category at a time
4. Use the keybindings in real coding immediately after learning
5. Challenge yourself with the game mode once comfortable

## 📁 Configuration Structure

The configuration follows a modular approach where each plugin has its own file for easy maintenance and customization:

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── options.lua     # Neovim settings
│   │   ├── keymaps.lua     # Key bindings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── lsp.lua         # LSP post-setup
│   ├── plugins/            # Individual plugin configs
│   │   ├── colorscheme.lua # Theme configuration
│   │   ├── telescope.lua   # Fuzzy finder
│   │   ├── nvim-tree.lua   # File explorer
│   │   ├── lsp.lua         # Language servers
│   │   ├── nvim-cmp.lua    # Autocompletion
│   │   ├── formatting.lua  # Code formatting
│   │   ├── linting.lua     # Code linting
│   │   ├── treesitter.lua  # Syntax highlighting
│   │   ├── ui.lua          # UI enhancements
│   │   ├── tmux.lua        # Tmux integration
│   │   └── keybind-trainer.lua # Interactive trainer
│   └── keybind-trainer/    # Trainer modules
│       ├── init.lua        # Main trainer logic
│       ├── menu.lua        # Menu system
│       └── game.lua        # Game mode
```

## 🔧 Adding New Plugins

To add a new plugin:

1. **Create a new file** in `lua/plugins/` (e.g., `lua/plugins/new-plugin.lua`)
2. **Follow the plugin structure**:

```lua
-- lua/plugins/new-plugin.lua
-- Description of what this plugin does
-- Version 1

return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- plugin configuration
    })
  end,
}
```

3. **Restart Neovim** - Lazy.nvim will automatically detect and install the new plugin

## ⌨️ Key Bindings

> **Leader Key**: `<Space>`

### 🗂️ File Navigation & Management

#### File Explorer (nvim-tree)

- `<Space>ee` - Toggle file explorer
- `<Space>ef` - Toggle file explorer and focus on current file
- Inside file tree:
  - `Enter` or `o` - Open file/folder
  - `a` - Create new file
  - `d` - Delete file
  - `r` - Rename file

#### Fuzzy Finding (Telescope)

- `<Space>ff` - Find files (most used!)
- `<Space>fs` - Search text in all files
- `<Space>fr` - Recent files
- `<Space>fb` - Open buffers (currently open files)
- Inside Telescope:
  - `Ctrl+j/k` - Navigate up/down
  - `Ctrl+q` - Send results to quickfix list

### 🔍 Code Navigation & LSP

#### Go to Definition/References

- `gd` - Go to definition
- `gR` - Show all references
- `gi` - Go to implementation
- `gt` - Go to type definition
- `K` - Show documentation hover
- `gD` - Go to declaration

#### Diagnostics (Errors/Warnings)

- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `<Space>d` - Show line diagnostics
- `<Space>D` - Show all buffer diagnostics

### ✏️ Code Editing

#### LSP Actions

- `<Space>ca` - Code actions (auto-fix, imports, etc.)
- `<Space>rn` - Rename symbol
- `<Space>rs` - Restart LSP

#### Formatting & Linting

- `<Space>mp` - Format file or selection
- `<Space>l` - Run linter

### 📑 Buffer & Tab Management

#### Buffers (Open Files)

- `Shift+h` - Previous buffer
- `Shift+l` - Next buffer

#### Windows/Splits

- `<Space>sv` - Split vertically
- `<Space>sh` - Split horizontally
- `<Space>se` - Make splits equal size
- `<Space>sx` - Close current split

#### Tabs

- `<Space>to` - Open new tab
- `<Space>tn` - Next tab
- `<Space>tp` - Previous tab
- `<Space>tx` - Close tab

### 🚀 General Productivity

#### Essential Vim Motions

- `jk` - Exit insert mode (custom binding)
- `<Space>nh` - Clear search highlights

#### Text Manipulation

In visual mode:

- `J` - Move selected text down
- `K` - Move selected text up
- `<` - Indent left (stays in visual)
- `>` - Indent right (stays in visual)

## 🎯 Most Important "Must Know" Keys

If you only remember 10 key bindings, make it these:

1. `<Space>ee` - Toggle file explorer
2. `<Space>ff` - Find files
3. `<Space>fs` - Search in files
4. `gd` - Go to definition
5. `K` - Show documentation
6. `<Space>ca` - Code actions
7. `]d` / `[d` - Next/previous error
8. `Shift+h` / `Shift+l` - Switch between open files
9. `jk` - Exit insert mode
10. `<Space>rn` - Rename variable/function

## 🧭 Typical Workflow

### Terminal Multiplexer Setup

1. **Start tmux session**: `tmux new -s dev`
2. **Split for editor + terminal**: `Ctrl+a |`
3. **Open Neovim in left pane**: `nvim`
4. **Use right pane for commands**: git, running servers, etc.
5. **Navigate seamlessly**: `Ctrl+h/j/k/l` works everywhere!

### In Neovim

1. **Open project**: `nvim .` in your project directory
2. **Browse files**: `<Space>ee` to see file tree
3. **Find specific file**: `<Space>ff` and type filename
4. **Navigate code**: `gd` to jump to definitions, `K` for docs
5. **Fix issues**: `]d` to go to errors, `<Space>ca` for quick fixes
6. **Switch files**: `Shift+h/l` between open files
7. **Practice keybindings**: `<Space>kt` to open the trainer!

## 🔧 Customization

### Modifying Key Bindings

Edit `lua/config/keymaps.lua` to change or add key bindings.

### Adding Language Support

1. Add the LSP server to `ensure_installed` in `lua/plugins/lsp.lua`
2. Configure the server in the same file
3. Add formatters/linters to respective plugin files

### Changing Theme

Modify `lua/plugins/colorscheme.lua` to use a different theme.

## 🐛 Troubleshooting

### Tmux Issues

#### Navigation Not Working Between Neovim and Tmux
1. Ensure both plugins are installed (vim-tmux-navigator in Neovim, tmux-navigator in tmux)
2. Reload tmux config: `Ctrl+a r`
3. Restart Neovim

#### Tmux Colors Look Wrong
Add to your shell config (`.bashrc` or `.zshrc`):
```bash
export TERM=screen-256color
```

### Keybind Trainer Issues

#### Trainer Commands Not Found
1. Make sure all files are in correct locations
2. Run `:Lazy sync` to ensure plugin is loaded
3. Check `:Lazy` to see if keybind-trainer is listed

#### Menu Keys Not Working
1. Ensure you're in normal mode (press `Esc`)
2. Buffer must be focused (click in it or press `i` then `Esc`)
3. Try the minimal test version in the troubleshooting section

### LSP Not Working

```bash
# Check LSP status
:LspInfo

# Reinstall servers
:MasonUninstallAll
:MasonInstall pyright ts_ls black prettier eslint_d pylint
```

### Plugin Issues

```bash
# Clean and reinstall plugins
:Lazy clean
:Lazy sync
```

### Icons Not Displaying

If you see missing icons or squares instead of symbols:

1. **Verify Nerd Font is installed**:
   ```bash
   fc-list | grep -i jetbrains
   ```

2. **Configure terminal to use Nerd Font**:
   - Change terminal font from "JetBrains Mono" to "JetBrainsMono Nerd Font"
   - Available font names: "JetBrainsMono Nerd Font", "JetBrainsMono NF", or "JetBrainsMono Nerd Font Mono"

3. **Restart terminal** after font change

### Check Health

```bash
# Run health checks
:checkhealth
:checkhealth mason
```

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this configuration!

### Repositories

- **Neovim Config**: [https://github.com/saganawski/simple-neovim-config](https://github.com/saganawski/simple-neovim-config)
- **Tmux Config**: [https://github.com/saganawski/tmux](https://github.com/saganawski/tmux)

## 📄 License

This configuration is open source and available under the MIT License.

