# Claude Code Instructions for Plotext Plus

## Project Overview

Plotext Plus is a modern terminal plotting library with a clean public API structure and enhanced visual features including banner mode, theming, and multimedia support.

## Development Environment

### Package Management
- **Primary**: Use `uv` for modern Python package management
- **Commands**: 
  - `uv add <package>` for dependencies
  - `uv add --optional <group> <package>` for optional dependencies
  - `uv run python <script>` for executing code

### Project Structure
```bash
plotext_plus/
├── src/plotext_plus/              # Main source (modern src-layout)
│   ├── plotting.py           # 🎯 PUBLIC: Core plotting functions
│   ├── charts.py             # 🎯 PUBLIC: Chart classes
│   ├── themes.py             # 🎯 PUBLIC: Theme system  
│   ├── utilities.py          # 🎯 PUBLIC: Helper utilities
│   ├── __init__.py           # Main entry point
│   └── _*.py                 # 🔒 PRIVATE: Internal modules
├── examples/                 # Interactive demos & examples
├── tests/                    # Test suites
├── docs/                     # Comprehensive documentation
└── pyproject.toml            # UV-based configuration
```

## API Structure Rules

### 🎯 Public API (Use These)
- `plotext_plus.plotting.*` - Main plotting functions
- `plotext_plus.charts.*` - Object-oriented chart classes
- `plotext_plus.themes.*` - Theme management
- `plotext_plus.utilities.*` - Helper functions
- Traditional API: `plt.plot()`, `plt.scatter()`, etc. (always available)

### 🔒 Private API (Internal Only)
- `plotext_plus._*` - All modules with underscores are internal
- **Never import these directly** in examples or user-facing code
- **Always use public API equivalents**

## Code Standards

### Import Patterns
```python
# ✅ CORRECT - Public API usage
import plotext_plus as plt
from plotext_plus import utilities as ut, themes

# ❌ WRONG - Private module usage  
import plotext_plus._utility as ut
from plotext_plus._themes import get_theme_info
```

### Testing Commands
```bash
# Run examples to verify functionality
python examples/interactive_demo.py
python examples/theme_showcase_demo.py
python test_clean_api.py

# Test imports work correctly
python -c "import plotext_plus as plt; print('✓ Import successful')"
```

### Banner Mode & Theming
- **Always test banner width calculations** - use `plt.terminal_width()` or `ut.terminal_width()`
- **Video sizing**: Height = `max(int(width * 0.4), 16)` with width accounting for banners
- **Theme application**: Call `plt.clear_figure()` BEFORE `plt.theme()` to avoid reset issues

## Documentation Guidelines

### File Organization
- **16 documentation files** in `/docs/` covering all functionality
- **README.md** - Primary entry point with comprehensive overview
- **CLEAN_API.md** - Public API structure explanation
- **API_TRANSFORMATION_SUMMARY.md** - Development history and rationale

### Documentation Updates
When modifying functionality:
1. Update relevant documentation in `/docs/`
2. Update README.md if adding major features
3. Update examples to demonstrate new features
4. Ensure all links in README.md work correctly

## Development Workflow

### Making Changes
1. **Understand the public/private boundary** - only modify public API thoughtfully
2. **Test backward compatibility** - existing code must continue working
3. **Update examples** to use public API patterns
4. **Run demo scripts** to verify functionality
5. **Update documentation** as needed

### Adding Features
1. **Add to appropriate public module** (`plotting.py`, `charts.py`, `themes.py`, `utilities.py`)
2. **Update `__init__.py`** to expose new functionality
3. **Create examples** demonstrating usage
4. **Document in appropriate `/docs/` file**
5. **Update README.md** if it's a major feature

### Common Issues & Fixes

#### Theme System
- **Problem**: Themes showing same colors
- **Solution**: Ensure `plt.clear_figure()` called before `plt.theme()`

#### Banner Mode
- **Problem**: Incorrect width calculations
- **Solution**: Call `plt.banner_mode(True, ...)` before using `ut.terminal_width()`

#### Video Display
- **Problem**: Video height too small
- **Solution**: Set plot size before video: `plt.plotsize(width, height)` where height is proportional to width

#### Import Errors
- **Problem**: Cannot import from private modules
- **Solution**: Use public API equivalents from `plotting`, `charts`, `themes`, or `utilities`

## Testing Checklist

Before committing changes:
- [ ] `python test_clean_api.py` passes
- [ ] Examples run without errors
- [ ] Banner mode displays correctly
- [ ] Themes apply properly
- [ ] Video displays with correct sizing
- [ ] Public API imports work
- [ ] No private module imports in examples
- [ ] Documentation links are valid
- [ ] Backward compatibility maintained

## Key Functions by Module

### plotext_plus.plotting
Core plotting: `scatter`, `plot`, `bar`, `matrix_plot`, `candlestick`, `title`, `xlabel`, `ylabel`, `xlim`, `ylim`, `theme`, `show`, `banner_mode`

### plotext_plus.charts  
Chart classes: `ScatterChart`, `LineChart`, `BarChart`, `HeatmapChart`, quick functions: `quick_scatter`, `quick_line`, `quick_bar`

### plotext_plus.themes
Theme management: `get_theme_info`, `apply_theme`, `apply_chuk_theme_to_chart`, `create_chuk_term_themes`

### plotext_plus.utilities
Helpers: `terminal_width`, `colorize`, `log_info`, `log_success`, `log_warning`, `log_error`, `delete_file`, `download`

## Dependencies

### Core (No Dependencies)
- Plotext Plus core functionality requires no external dependencies

### Optional Dependencies
- **Image/Video**: `pillow`, `opencv-python`, `ffpyplayer`, `pafy`, `youtube-dl`
- **Enhanced Terminal**: `chuk-term` (automatically included)

### Installation Commands
```bash
# Basic installation
uv add plotext_plus

# With multimedia support
uv add plotext_plus[image,video]

# Development installation
git clone <repo> && cd plotext_plus && uv install
```

This project maintains high standards for API cleanliness, backward compatibility, and user experience. Always consider the impact on existing users when making changes.