# 📊 Plotext+ - Modern Terminal Plotting

[![PyPi](https://badge.fury.io/py/plotext_plus.svg)](https://badge.fury.io/py/plotext_plus)
[![Downloads](https://pepy.tech/badge/plotext_plus/month)](https://pepy.tech/project/plotext_plus)
[![GitHubIssues](https://img.shields.io/badge/issue_tracking-github-blue.svg)](https://github.com/ccmitchellusa/plotext_plus/issues)
[![GitTutorial](https://img.shields.io/badge/PR-Welcome-%23FF8300.svg?)](https://github.com/ccmitchellusa/plotext_plus/pulls)

![logo](https://raw.githubusercontent.com/ccmitchellusa/plotext_plus/refs/heads/main/data/logo.png)

**Plotext+ plots directly in your terminal** with stunning visuals, modern APIs, and professional styling.  Plotext+ is a redesigned version of the original [plotext](https://github.com/piccolomo/plotext) library by Savino Piccolomo. New features include an updated API with object oriented features, an MCP server to make the project easily usable with AI & LLM scenarios, new themes and integration with chuk-term to make sure it works in the awesome [mcp-cli](https://github.com/chrishayuk/mcp-cli) by Chris Hay.

## ✨ Key Features

🎯 **Multiple Plot Types**: [scatter](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md#scatter-plot), [line](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md#line-plot), [bar](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/bar.md), [histogram](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/bar.md#histogram-plot), [candlestick](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/datetime.md#candlestick-plot), [heatmap](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/special.md), [confusion matrix](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/special.md#confusion-matrix), [pie](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md#pie-plot), [doughnut](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md#doughnut-charts) and more

🎨 **Rich Visuals**: [Banner mode](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/chart_classes.md), [themes](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/themes.md), [colored text](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/utilities.md#colored-text), automatic terminal width detection

📊 **Advanced Features**: [Subplots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/subplots.md), [datetime plots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/datetime.md), [image/GIF display](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/image.md), [video streaming](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/video.md) (including YouTube)

🔧 **Modern APIs**: Clean public API, object-oriented charts, quick functions, 100% backward compatible

🤖 **AI Integration**: [MCP server](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/mcp-server.md) for direct AI client access (Claude, etc.)

⚡ **Zero Dependencies**: No required dependencies (optional packages for multimedia and AI integration)

![subplots](https://raw.githubusercontent.com/ccmitchellusa/plotext_plus/refs/heads/main/data/subplots.png)

## 🚀 Quick Start

### Installation

```bash
# Modern Python package management
uv add plotext_plus

# Traditional installation
pip install plotext_plus

# With optional dependencies
pip install plotext_plus[image,video]      # Multimedia support
pip install plotext_plus[mcp]              # AI integration (MCP server)
pip install plotext_plus[image,video,mcp]  # All features
```

### Basic Usage

```python
import plotext_plus as plt

# Simple scatter plot
plt.scatter([1, 2, 3, 4], [1, 4, 9, 16])
plt.title("My First Plot")
plt.show()
```

### Enhanced Visual Styling ✨

```python
import plotext_plus as plt

# Enable beautiful banner mode
plt.banner_mode(True, "📊 Data Analysis Dashboard")

# Apply professional themes
plt.theme('professional')

# Create styled plot
plt.plot([1, 2, 3, 4], [1, 4, 2, 3], label="Data Series")
plt.title("Enhanced Line Plot")
plt.xlabel("Time")
plt.ylabel("Values")
plt.show()
```

### Modern Chart Classes 🎯

```python
import plotext_plus as plt

# Object-oriented chart creation with method chaining
chart = (plt.ScatterChart([1, 2, 3, 4], [1, 4, 9, 16])
         .title("Scientific Analysis")
         .xlabel("X Variable")
         .ylabel("Y Variable")
         .color('blue')
         .show())

# Quick one-liner plots
plt.quick_scatter(x_data, y_data, title="Quick Analysis")
```

### Public API 🔧

```python
import plotext_plus as plt

# Access organized functionality
plt.plotting.bar(categories, values)      # Main plotting functions
plt.themes.apply_theme('dark_mode')       # Theme management  
plt.utilities.log_success("Plot ready!")  # Helper utilities
```

### AI Integration 🤖

```bash
# Install with MCP (Model Context Protocol) support  
pip install plotext_plus[mcp]

# Start the MCP server for AI clients like Claude
plotext-mcp
```

**Use with Claude Desktop**: Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "plotext-plus": {
      "command": "plotext-mcp",
      "args": [],
      "env": {}
    }
  }
}
```

Now AI clients can create plots directly:

```text
"Create a scatter plot showing x=[1,2,3,4,5] vs y=[1,4,9,16,25] with title 'Quadratic Function'"
```

## 🏗️ Architecture & API

### Public API Structure

```python
# 🎯 Main Modules (Public API - no underscores)
plotext_plus.plotting    # Core plotting functions
plotext_plus.charts      # Object-oriented chart classes  
plotext_plus.themes      # Theme and styling system
plotext_plus.utilities   # Helper functions and tools

# 📁 Internal Modules (Private - with underscores)
plotext_plus._core       # Internal implementation
plotext_plus._api        # Internal API details
plotext_plus._themes     # Theme internals
# ... other internal modules
```

### Project Structure

```bash
plotext_plus/
├── src/plotext_plus/              # Modern src-layout
│   ├── plotting.py           # 🎯 Main plotting functions (PUBLIC)
│   ├── charts.py             # 🎯 Chart classes (PUBLIC)
│   ├── themes.py             # 🎯 Theme system (PUBLIC)
│   ├── utilities.py          # 🎯 Utilities (PUBLIC)
│   └── _*.py                 # 🔒 Internal modules (PRIVATE)
├── examples/                 # Interactive demos
│   ├── interactive_demo.py   # Full interactive showcase
│   └── theme_showcase_demo.py # Theme comparison tool
├── tests/                    # Test suites
├── docs/                     # Comprehensive documentation
└── pyproject.toml            # Modern packaging
```

## 🎨 Enhanced Features

### 🎭 Visual Enhancements

- **Professional Banners**: Automatic width detection and border styling
- **Advanced Theming**: Multiple built-in themes with chuk-term integration
- **Smart Layouts**: Charts automatically resize to fit terminal dimensions
- **Rich Colors**: 24-bit color support with automatic fallbacks

### 🚀 Developer Experience  

- **Clean API**: Public modules clearly separated from internals
- **Method Chaining**: Fluent interface for complex plot creation
- **Quick Functions**: One-liner plots for rapid prototyping
- **Type Safety**: Better IDE support and autocomplete
- **Zero Breaking Changes**: 100% backward compatibility guaranteed

## 🧪 Try It Now

```bash
# Install and run interactive demo
pip install plotext_plus
python -c "
import plotext_plus as plt
plt.banner_mode(True, '🎨 Plotext Plus Demo')
plt.scatter([1,2,3,4], [1,4,2,3], color='blue')
plt.title('Welcome to Plotext Plus!')
plt.show()
"

# Run comprehensive demos
git clone https://github.com/ccmitchellusa/plotext_plus.git
cd plotext_plus
python examples/interactive_demo.py      # Full interactive showcase  
python examples/theme_showcase_demo.py   # Theme comparison
```

## 📚 Complete Documentation

### 🎯 **Core Plotting**

- **[📊 Basic Plots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md)** - Scatter, line, and fundamental plotting
- **[📈 Bar Charts](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/bar.md)** - Bar plots, histograms, and variations  
- **[📅 DateTime Plots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/datetime.md)** - Time series and candlestick charts
- **[🔬 Special Plots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/special.md)** - Heatmaps, confusion matrices, error bars
- **[🎨 Decorator Plots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/decorator.md)** - Text, lines, and shape overlays

### 🖼️ **Multimedia & Advanced**

- **[🖼️ Image Plotting](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/image.md)** - Display images and GIFs in terminal
- **[🎬 Video Streaming](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/video.md)** - Play videos and YouTube content
- **[📐 Subplots](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/subplots.md)** - Multiple plots and complex layouts

### ⚙️ **Configuration & Styling**

- **[🎨 Themes](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/themes.md)** - Built-in themes and customization
- **[⚙️ Settings](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/settings.md)** - Plot configuration and options
- **[📏 Aspect](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/aspect.md)** - Size, scaling, and layout control
- **[🔧 Chart Classes](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/chart_classes.md)** - Object-oriented API reference

### 🛠️ **Tools & Integration**  

- **[🔧 Utilities](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/utilities.md)** - Helper functions and command-line tools
- **[🤖 MCP Server](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/mcp-server.md)** - AI integration via Model Context Protocol
- **[🌐 Environments](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/environments.md)** - IDE and platform compatibility
- **[🏗️ API Structure](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/api.md)** - Clean public API organization
- **[📝 Notes](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/notes.md)** - Installation, tips, and troubleshooting

### 🚀 **Getting Started Guides**

1. **[👋 Introduction](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/basic.md#introduction)** - First steps with Plotext
2. **[📦 Installation](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/notes.md#install)** - Setup and dependencies  
3. **[🎯 Quick Examples](#-quick-start)** - Jump right in with code samples
4. **[🎨 Theming Guide](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/themes.md)** - Make your plots beautiful
5. **[🔧 Modern API Guide](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/api.md)** - Use the clean public interface

## 💡 Migration & Compatibility

**For Existing Users**: All your current code works unchanged! The new features are purely additive.

**For New Users**: Take advantage of the modern APIs and enhanced styling while learning the fundamentals.

```python
# ✅ Your existing code still works
import plotext_plus as plt
plt.plot([1,2,3], [1,4,2])
plt.show()

# 🆕 Enhanced with new features  
plt.banner_mode(True, "📊 My Analysis")
plt.theme('professional')
plt.plot([1,2,3], [1,4,2])
plt.show()
```

## 🛠️ Development & Build System

Plotext+ includes a comprehensive build system with modern tooling. See **[Build Documentation](https://github.com/ccmitchellusa/plotext_plus/blob/master/docs/build.md)** for complete setup, testing, publishing, and deployment instructions.
