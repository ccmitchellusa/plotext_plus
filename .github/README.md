# GitHub Actions CI/CD for Plotext Plus

This directory contains comprehensive GitHub Actions workflows for continuous integration, security scanning, dependency management, and automated releases.

## Workflows

### 🔄 CI (ci.yml)
**Triggers:** Push to main/develop, Pull requests to main

**Jobs:**
- **Lint** - Code quality with Ruff linter and formatter
- **Type Check** - Static type checking with mypy
- **Test** - Unit tests across Python 3.11, 3.12, 3.13 with coverage
- **Test MCP** - MCP-specific functionality testing
- **Security** - Security scanning with Bandit
- **Examples** - Test example code functionality
- **Build** - Package building and distribution validation
- **Container** - Docker container build testing

**Key Features:**
- Multi-Python version testing
- Coverage reporting to Codecov
- MCP functionality verification
- Container build validation
- Comprehensive error handling

### 🚀 Release (release.yml)
**Triggers:** GitHub releases, Manual workflow dispatch

**Jobs:**
- **Test** - Full test suite before release
- **Build** - Package building with artifact upload
- **Publish TestPyPI** - Test publishing workflow
- **Publish PyPI** - Production release publishing
- **Build Container** - Container image building and publishing to GHCR

**Key Features:**
- Trusted publishing with OIDC
- Dual-environment support (TestPyPI/PyPI)
- Container image tagging and publishing
- Artifact management

### 🔒 Security (security.yml)
**Triggers:** Daily schedule (2 AM UTC), Push/PR to main, Manual dispatch

**Jobs:**
- **Dependency Scan** - Vulnerability scanning with Safety
- **Code Security** - Source code security with Bandit
- **Secrets Scan** - Secret detection with TruffleHog
- **Container Security** - Container vulnerability scanning with Trivy
- **CodeQL** - GitHub's semantic code analysis

**Key Features:**
- Automated security reporting
- SARIF report upload to GitHub Security tab
- Multiple scanning engines
- Comprehensive coverage (code, dependencies, containers, secrets)

### 📦 Dependencies (dependencies.yml)
**Triggers:** Weekly schedule (Monday 9 AM UTC), Manual dispatch

**Jobs:**
- **Update Dependencies** - Automated dependency updates with PR creation
- **Check Outdated** - Dependency status reporting

**Key Features:**
- Automated dependency management
- Testing with updated dependencies
- Automatic PR creation for updates
- Dependency health reporting

## Configuration Files

### Testing
- **pytest.ini** - Pytest configuration with markers and options
- **mypy.ini** - Type checking configuration with strict settings
- **ruff.toml** - Linting and formatting configuration

### Development Dependencies
Added to `pyproject.toml` dev group:
- pytest, pytest-cov, pytest-asyncio
- ruff, black, isort, mypy
- bandit, safety, twine

## Setup Requirements

### Repository Secrets
For full functionality, configure these repository secrets:

1. **PyPI Publishing** (if not using trusted publishing):
   - `PYPI_API_TOKEN` - PyPI API token
   - `TEST_PYPI_API_TOKEN` - TestPyPI API token

2. **Security Scanning** (optional):
   - `CODECOV_TOKEN` - Codecov upload token

### Repository Settings

1. **Branch Protection:**
   - Require status checks to pass before merging
   - Require branches to be up to date before merging
   - Require linear history

2. **Security:**
   - Enable dependency graph
   - Enable Dependabot alerts
   - Enable security advisories

3. **Environments:**
   - Create `pypi` environment with deployment protection rules
   - Create `testpypi` environment for testing

## Usage

### Running Locally
```bash
# Install development dependencies
uv sync --group dev

# Run linting
uv run ruff check src/ tests/ examples/
uv run ruff format --check src/ tests/ examples/

# Run type checking
uv run mypy src/plotext_plus

# Run tests
uv run pytest --cov=src/plotext_plus

# Run security checks
uv run bandit -r src/
uv run safety check

# Build package
uv build
uv run twine check dist/*
```

### Workflow Status
All workflows provide comprehensive status reporting through:
- GitHub Actions status badges
- Artifact uploads for reports
- Integration with GitHub Security tab
- Coverage reporting integration

### Maintenance
- Workflows are designed to be self-maintaining
- Dependency updates are automated
- Security scans run automatically
- All configurations follow best practices

This CI/CD setup ensures high code quality, security, and reliability for the Plotext Plus project while maintaining developer productivity.