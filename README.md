# macOS Development Environment Configuration

A comprehensive, modern macOS development environment featuring Lua-based configurations, terminal emulators, window management, and development tools optimized for productivity.

## 🚀 Features

### Core Development Tools
- **[Neovim](https://neovim.io/)** - Modern Lua configuration using LazyVim distribution with multi-language support
- **[tmux](https://github.com/tmux/tmux)** - Terminal multiplexer with TPM plugin manager and modular configuration
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-accelerated terminal with custom themes and Fira Code font
- **[Ghostty](https://ghostty.org/)** - Fast terminal emulator with JetBrains Mono font integration

### macOS-Specific Tools
- **[SketchyBar](https://github.com/FelixKratz/SketchyBar)** - Modern Lua-based menu bar replacement with comprehensive features
- **[Raycast](https://www.raycast.com/)** - Productivity launcher with custom extensions
- **[Borders](https://github.com/JankyBorders/borders)** - Window border management for enhanced visual feedback

### Development Environment
- **[RStudio](https://www.rstudio.com/)** - R development environment with optimized preferences
- **[Neofetch](https://github.com/dylanaraps/neofetch)** - System information display tool
- **[MPV](https://mpv.io/)** - Media player with custom configuration

### Modern Configuration Approach
- **Lua-first**: Neovim and SketchyBar use modern Lua configurations
- **Plugin Management**: tmux uses TPM, Neovim uses lazy.nvim
- **Font Integration**: Fira Code and JetBrains Mono with ligature support
- **Transparency & Blur**: Terminal emulators configured with modern visual effects

## 📋 Prerequisites

### Required Software
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Xcode Command Line Tools
xcode-select --install

# Install Git
brew install git
```

### Required Fonts
```bash
# Install fonts via Homebrew
brew tap homebrew/cask-fonts
brew install font-fira-code
brew install font-jetbrains-mono

# Alternative: Download and install manually from:
# - Fira Code: https://github.com/tonsky/FiraCode
# - JetBrains Mono: https://www.jetbrains.com/lp/mono/
```

### Core Applications
```bash
# Terminal emulators
brew install --cask kitty
brew install --cask ghostty

# Development tools
brew install neovim
brew install tmux
brew install --cask rstudio

# System tools
brew install neofetch
brew install mpv
brew install --cask raycast
```

## 🛠️ Installation

### Automated Installation (Recommended)

1. **Clone the repository:**
```bash
git clone <repository-url> ~/.config
cd ~/.config
```

2. **Install SketchyBar with all dependencies:**
```bash
chmod +x sketchybar/install_complete.sh
./sketchybar/install_complete.sh
```
This script will:
- Install Lua runtime and required dependencies
- Install SketchyBar from FelixKratz/formulae tap
- Compile and install the SbarLua module
- Build helper binaries for system monitoring
- Load and verify the configuration

3. **Install tmux plugins:**
```bash
# Start tmux and install TPM plugins
tmux new-session -d
tmux source ~/.config/tmux/tmux.conf
# Press prefix + I to install plugins (default prefix is Ctrl+B)
```

### Manual Installation

If you prefer to set up individual components manually:

1. **Create symbolic links:**
```bash
# Backup existing configurations (optional)
mv ~/.config ~/.config.backup

# Create symlinks to this repository
ln -sf /path/to/this/repo ~/.config

# Or link individual components:
ln -sf ~/.config/nvim ~/.config/nvim
ln -sf ~/.config/tmux ~/.config/tmux
ln -sf ~/.config/kitty ~/.config/kitty
ln -sf ~/.config/ghostty ~/.config/ghostty
ln -sf ~/.config/sketchybar ~/.config/sketchybar
```

2. **Install SketchyBar dependencies manually:**
```bash
brew install lua switchaudio-osx nowplaying-cli
brew tap FelixKratz/formulae
brew install sketchybar

# Compile SbarLua module
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install && cd -
rm -rf /tmp/SbarLua

# Compile helper binaries
cd ~/.config/sketchybar/helpers && make
```

## ⚙️ Configuration Details

### Neovim
- **Distribution**: LazyVim for modern Lua configuration
- **Plugin Manager**: lazy.nvim with automatic plugin management
- **Language Support**: Multi-language LSP, debugging, and testing support
- **Key Features**: Project utilities, DAP core, test framework integration

### tmux
- **Plugin Manager**: TPM (Tmux Plugin Manager)
- **Key Plugins**: 
  - Online status indicator
  - Mode indicator for visual feedback
  - Session resurrection and continuous saving
  - Powerline status bar integration
- **Configuration**: Modular setup with separate options and keybindings files

### Terminal Emulators

#### Kitty
- **Font**: Fira Code with ligatures
- **Theme**: Cherry Midnight with transparency
- **Features**: Background blur, custom opacity, GPU acceleration
- **Shell Integration**: zsh with advanced features

#### Ghostty
- **Font**: JetBrains Mono
- **Theme**: GitLab-Dark with custom palette
- **Features**: Background opacity, clipboard integration
- **Command**: Preconfigured to launch tmux

### SketchyBar
- **Language**: Modern Lua configuration
- **Features**: System monitoring, network status, CPU/memory indicators
- **Dependencies**: SbarLua module for advanced scripting
- **Helpers**: Compiled binaries for system metric collection

### RStudio
- **Theme**: a11y-dark for accessibility
- **Features**: GitHub Copilot integration, advanced diagnostics
- **Code Style**: styler formatter with comprehensive linting
- **UI**: Optimized pane layout with enhanced productivity features

## 🔧 Key Files

| File/Directory | Purpose |
|----------------|---------|
| [`nvim/lua/config/lazy.lua`](nvim/lua/config/lazy.lua) | LazyVim bootstrap and plugin configuration |
| [`tmux/tmux.conf`](tmux/tmux.conf) | Main tmux configuration with plugin loading |
| [`kitty/kitty.conf`](kitty/kitty.conf) | Kitty terminal customization and theming |
| [`ghostty/config`](ghostty/config) | Ghostty terminal preferences |
| [`sketchybar/sketchybarrc`](sketchybar/sketchybarrc) | SketchyBar Lua entry point |
| [`sketchybar/install_complete.sh`](sketchybar/install_complete.sh) | Comprehensive SketchyBar installation script |
| [`rstudio/rstudio-prefs.json`](rstudio/rstudio-prefs.json) | RStudio IDE preferences and settings |

## 🎯 Usage

### First Launch
1. **Terminal**: Launch Kitty or Ghostty from Applications
2. **tmux**: Sessions will start automatically with configured plugins
3. **Neovim**: Launch with `nvim` - plugins will auto-install on first run
4. **SketchyBar**: Should load automatically after installation
5. **RStudio**: Launch from Applications with preconfigured settings

### Key Shortcuts
- **tmux**: Prefix key is `Ctrl+B` (default)
- **Neovim**: Leader key is `Space` (LazyVim default)
- **Kitty**: `Cmd+Enter` for new window, transparency controls available
- **SketchyBar**: Interactive elements respond to clicks and hover

### Verification Commands
```bash
# Check SketchyBar status
sketchybar --query bar
ps aux | grep sketchybar

# Verify tmux plugins
tmux list-sessions
tmux show-options -g @plugin

# Test Neovim configuration
nvim --headless -c 'lua print("Lua config loaded")' -c 'qa'
```

## 🎨 Customization

### Adding Custom Themes
1. **Kitty**: Place theme files in `kitty/` and reference in `kitty.conf`
2. **Neovim**: Add colorschemes through LazyVim plugin system
3. **SketchyBar**: Modify Lua configuration files in `sketchybar/` directory

### Font Modifications
```bash
# Update Kitty font
# Edit kitty/kitty.conf:
font_family    Your-Preferred-Font

# Update Ghostty font
# Edit ghostty/config:
font-family = Your-Preferred-Font
```

### Plugin Management
- **Neovim**: Add plugins in `nvim/lua/plugins/` directory
- **tmux**: Add plugins to `tmux/tmux.conf` and run `prefix + I`
- **SketchyBar**: Extend functionality through Lua modules

### System Integration
- **Raycast**: Extensions are stored in `raycast/extensions/`
- **Neofetch**: Customize system info display in `neofetch/config.conf`
- **Borders**: Configure window border appearance (if using)

## 🔍 Troubleshooting

### SketchyBar Issues
```bash
# Restart SketchyBar
brew services restart sketchybar

# Check dependencies
which lua switchaudio-osx nowplaying-cli

# Verify SbarLua installation
ls -la ~/.local/share/sketchybar_lua/
```

### tmux Plugin Problems
```bash
# Reinstall TPM plugins
rm -rf ~/.config/tmux/plugins/
# Restart tmux and press prefix + I
```

### Font Issues
```bash
# Verify font installation
fc-list | grep -i "fira\|jetbrains"

# Refresh font cache
fc-cache -f -v
```

### Neovim Configuration
```bash
# Check for configuration errors
nvim --headless -c 'checkhealth' -c 'qa'

# Reset lazy.nvim if needed
rm -rf ~/.local/share/nvim/lazy
```

## 📄 License

This configuration is provided as-is for personal and educational use. Individual tools and applications are subject to their respective licenses.

## 🤝 Contributing

Feel free to submit issues and enhancement requests. When contributing:
1. Test configurations on a clean macOS environment
2. Ensure compatibility with the specified tool versions
3. Update documentation for any new features or changes
4. Follow the existing code style and organization

---

**Note**: This configuration is optimized for macOS and may require adjustments for other operating systems. Always backup your existing configurations before installation.