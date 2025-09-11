# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   📊 Plotext Plus - Makefile
#   (Modern terminal plotting library with enhanced visual features)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Author(s): Chris Mitchell
#
# Description: Modern terminal plotting library with enhanced visual features, 
#              themes, and AI integration via MCP (Model Context Protocol)
#
# Credits: Special Thanks to:
#          - Mihai Criveti for the awesome Makefile template
#          - Chris Hay for the chuk-mcp-server and utilities
#
# Usage: run `make` or `make help` to view available targets
#
# help: 📊 Plotext Plus (Modern terminal plotting library with enhanced visual features)
# ──────────────────────────────────────────────────────────────────────────
# Project variables
PROJECT_NAME      = plotext_plus
DOCS_DIR          = docs

# Project-wide clean-up targets
DIRS_TO_CLEAN := __pycache__ .pytest_cache .tox .ruff_cache .mypy_cache .pytype \
                 dist build .eggs *.egg-info .cache htmlcov temp \
                 node_modules .venv

FILES_TO_CLEAN := .coverage coverage.xml *.prof *.pstats \
                  $(PROJECT_NAME).sbom.json

# Virtual-environment variables
VENVS_DIR := $(HOME)/.venv
VENV_DIR  := $(VENVS_DIR)/$(PROJECT_NAME)

# Container resource configuration
CONTAINER_MEMORY = 2048m
CONTAINER_CPUS   = 2

# Container image variables
IMG               ?= $(PROJECT_NAME)/$(PROJECT_NAME)
IMG_MCP           = $(PROJECT_NAME)/mcp-server
IMG_DEV           = $(IMG)-dev

# =============================================================================
# 📖 DYNAMIC HELP
# =============================================================================
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# =============================================================================
# 🌱 VIRTUAL ENVIRONMENT & INSTALLATION
# =============================================================================
# help: 🌱 VIRTUAL ENVIRONMENT & INSTALLATION
# help: venv                 - Create a fresh virtual environment with uv & friends
# help: activate             - Activate the virtual environment in the current shell
# help: install              - Install project into the venv
# help: install-dev          - Install project (incl. dev deps) into the venv
# help: install-mcp          - Install project (incl. MCP deps) into venv
# help: install-all          - Install project with all optional dependencies
# help: update               - Update all installed deps inside the venv

.PHONY: venv activate install install-dev install-mcp install-all update

venv:
	@rm -Rf "$(VENV_DIR)"
	@test -d "$(VENVS_DIR)" || mkdir -p "$(VENVS_DIR)"
	@python3 -m venv "$(VENV_DIR)"
	@/bin/bash -c "source $(VENV_DIR)/bin/activate && python3 -m pip install --upgrade pip setuptools uv"
	@echo -e "✅  Virtual env created.\n💡  Enter it with:\n    . $(VENV_DIR)/bin/activate\n"

activate:
	@echo -e "💡  Enter the venv using:\n    . $(VENV_DIR)/bin/activate\n"
	@. $(VENV_DIR)/bin/activate
	@echo "export PYTHONPATH=$(PWD)/src:$(PWD)"

install:
	@echo "📦  Installing project with uv…"
	@uv sync

install-dev:
	@echo "📦  Installing project with all development dependencies…"
	@uv sync --group dev

install-mcp:
	@echo "📦  Installing project with MCP server dependencies…"
	@uv sync --extra mcp

install-all:
	@echo "📦  Installing project with all optional dependencies…"
	@uv sync --all-extras

update:
	@echo "⬆️   Updating installed dependencies…"
	@uv sync --upgrade

# =============================================================================
# 🧪 TESTING
# =============================================================================
# help: 🧪 TESTING
# help: test                 - Run tests with coverage
# help: test-fast            - Run tests without coverage
# help: test-mcp             - Run MCP-specific tests
# help: coverage             - Run tests with coverage, emit HTML/XML + badge

.PHONY: test test-fast test-mcp coverage

test:
	@echo "🧪  Running tests with coverage…"
	@PYTHONPATH=src uv run pytest \
		--cov=src/plotext_plus \
		--cov-report=html \
		--cov-report=term-missing \
		--cov-report=xml \
		-v

test-fast:
	@echo "🧪  Running tests (fast mode)…"
	@PYTHONPATH=src uv run pytest -v

test-mcp:
	@echo "🧪  Running MCP-specific tests…"
	@echo "Testing MCP imports..."
	@python -c "from plotext_plus.mcp_server import start_server; print('✅ MCP import successful')"
	@echo "Testing MCP CLI..."
	@plotext-mcp --info
	@echo "Testing MCP functionality..."
	@python -c "import asyncio; from plotext_plus.mcp_server import scatter_plot; asyncio.run(scatter_plot([1,2,3], [1,4,9], title='Test'))" > /dev/null && echo "✅ MCP scatter plot test passed"

coverage:
	@echo "📊  Running comprehensive coverage analysis…"
	@mkdir -p htmlcov
	@PYTHONPATH=src uv run pytest \
		--cov=src/plotext_plus \
		--cov-report=html:htmlcov \
		--cov-report=term-missing \
		--cov-report=xml \
		-v
	@echo "✅  Coverage report generated in htmlcov/"

# =============================================================================
# 🔍 LINTING & STATIC ANALYSIS
# =============================================================================
# help: 🔍 LINTING & STATIC ANALYSIS
# help: lint                 - Run the full linting suite
# help: lint-check           - Check linting without fixing
# help: format               - Format code with black + isort
# help: ruff                 - Run ruff linter + formatter
# help: black                - Reformat code with black
# help: isort                - Organise & sort imports with isort
# help: mypy                 - Static type-checking with mypy

LINTERS := ruff black isort mypy

.PHONY: lint lint-check format $(LINTERS)

## --------------------------------------------------------------------------- ##
##  Master target
## --------------------------------------------------------------------------- ##
lint:
	@echo "🔍  Running full lint suite…"
	@set -e; for t in $(LINTERS); do \
	    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	    echo "• $$t"; \
	    $(MAKE) $$t || true; \
	done

lint-check:
	@echo "🔍  Checking linting without fixing…"
	@uv run ruff check src/ tests/ examples/
	@uv run black --check src/ tests/ examples/
	@uv run mypy src/plotext_plus

format:
	@echo "🎨  Formatting code…"
	@uv run black src/ tests/ examples/
	@uv run isort src/ tests/ examples/

## --------------------------------------------------------------------------- ##
##  Individual targets
## --------------------------------------------------------------------------- ##
ruff:                               ## ⚡  Ruff lint + format
	@echo "⚡  ruff …" && uv run ruff check src/ tests/ examples/ --fix
	@uv run ruff format src/ tests/ examples/

black:                              ## 🎨  Reformat code with black
	@echo "🎨  black …" && uv run black src/ tests/ examples/

isort:                              ## 🔀  Sort imports
	@echo "🔀  isort …" && uv run isort src/ tests/ examples/

mypy:                               ## 🏷️  mypy type-checking
	@echo "🏷️  mypy …" && uv run mypy src/plotext_plus

bandit:                             ## 🔒  Security linting with bandit
	@echo "🔒  bandit …" && uv run bandit -r src/ -f json -o bandit-report.json || true
	@uv run bandit -r src/

# =============================================================================
# 📦 PACKAGING & BUILDING
# =============================================================================
# help: 📦 PACKAGING & BUILDING
# help: build                - Build package with uv
# help: clean                - Clean build artifacts and caches

.PHONY: build clean

build:
	@echo "🏗️   Building package with uv…"
	@uv build
	@echo "✅  Package built successfully!"
	@ls -la dist/

clean:
	@echo "🧹  Cleaning workspace…"
	@# Remove matching directories
	@for dir in $(DIRS_TO_CLEAN); do \
		find . -type d -name "$$dir" -exec rm -rf {} +; \
	done
	@# Remove listed files
	@rm -f $(FILES_TO_CLEAN)
	@# Delete Python bytecode
	@find . -name '*.py[cod]' -delete
	@echo "✅  Clean complete."

# =============================================================================
# ▶️ SERVE & DEVELOPMENT
# =============================================================================
# help: ▶️ SERVE & DEVELOPMENT
# help: run-mcp              - Run MCP server
# help: run-demos            - Run interactive demos
# help: setup                - Setup development environment

.PHONY: run-mcp run-demos setup

run-mcp:
	@echo "🔌  Starting MCP server…"
	@plotext-mcp

run-demos:
	@echo "🎨  Running interactive demos…"
	@echo "Available demos:"
	@echo "  • python examples/interactive_demo.py"
	@echo "  • python examples/theme_showcase_demo.py"
	@python examples/interactive_demo.py

setup:
	@echo "🛠️   Setting up development environment…"
	@make install-all
	@echo "✅  Development environment ready!"
	@echo "💡  Try: make run-demos"

# =============================================================================
# 🐋 DOCKER BUILD & RUN
# =============================================================================
# help: 🐋 DOCKER BUILD & RUN
# help: docker-build         - Build Docker images
# help: docker-up            - Start services with Docker Compose
# help: docker-down          - Stop Docker Compose services
# help: docker-logs          - View Docker logs
# help: docker-run-mcp       - Run MCP server in Docker
# help: docker-stop          - Stop Docker containers
# help: docker-clean         - Clean Docker containers and volumes

.PHONY: docker-build docker-up docker-down docker-logs docker-run-mcp docker-stop docker-clean

docker-build:
	@echo "🐋  Building Docker images…"
	@docker build -t $(IMG_MCP) -f Dockerfile.mcp .

docker-up:
	@echo "🚀  Starting services with Docker Compose…"
	@docker compose up -d
	@echo "✅  Services started!"
	@echo "   🔌  MCP server: http://localhost:8001"

docker-down:
	@echo "🛑  Stopping Docker Compose services…"
	@docker compose down

docker-logs:
	@echo "📜  Streaming Docker logs…"
	@docker compose logs -f

docker-run-mcp:
	@echo "🚀  Starting MCP server in Docker…"
	@docker run -d --name $(PROJECT_NAME)-mcp -p 8001:8001 $(IMG_MCP)
	@echo "✅  MCP server started!"
	@echo "   🔌  MCP server: http://localhost:8001"

docker-stop:
	@echo "🛑  Stopping Docker containers…"
	@docker stop $(PROJECT_NAME)-mcp || true
	@docker rm $(PROJECT_NAME)-mcp || true

docker-clean:
	@echo "🧹  Cleaning Docker containers and volumes…"
	@docker compose down -v || true
	@docker stop $(PROJECT_NAME)-mcp || true
	@docker rm $(PROJECT_NAME)-mcp || true
	@docker rmi $(IMG_MCP) || true
	@docker system prune -f

# =============================================================================
# 🦭 PODMAN CONTAINER BUILD & RUN
# =============================================================================
# help: 🦭 PODMAN CONTAINER BUILD & RUN
# help: podman-build         - Build production container images
# help: podman-run-mcp       - Run MCP server container (port 8001)
# help: podman-stop          - Stop & remove all containers
# help: podman-test          - Quick curl smoke-test against the container
# help: podman-logs          - Follow container logs (⌃C to quit)
# help: podman-stats         - Show container resource stats
# help: podman-shell         - Open an interactive shell inside container

.PHONY: podman-build podman-run-mcp podman-stop podman-test podman-logs \
        podman-stats podman-shell

podman-build:
	@echo "🦭  Building Podman container images…"
	@podman build -t $(IMG_MCP) -f docker/Containerfile.mcp .
	@echo "✅  Container image built: $(IMG_MCP)"

podman-run-mcp:
	@echo "🚀  Starting MCP server container…"
	@podman run -d --name $(PROJECT_NAME)-mcp \
		--memory=$(CONTAINER_MEMORY) \
		--cpus=$(CONTAINER_CPUS) \
		-p 8001:8001 \
		$(IMG_MCP)
	@echo "✅  MCP server started!"
	@echo "   🔌  MCP server: http://localhost:8001"
	@echo "   📊  Container stats: make podman-stats"
	@echo "   📜  View logs: make podman-logs"

podman-stop:
	@echo "🛑  Stopping & removing Podman containers…"
	@podman stop $(PROJECT_NAME)-mcp || true
	@podman rm $(PROJECT_NAME)-mcp || true
	@echo "✅  Containers stopped and removed"

podman-test:
	@echo "🧪  Running smoke tests against containers…"
	@echo "Testing MCP server health..."
	@curl -f http://localhost:8001/health || echo "⚠️  MCP server not responding"
	@echo "✅  Smoke tests complete"

podman-logs:
	@echo "📜  Following container logs (press ⌃C to quit)…"
	@podman logs -f $(PROJECT_NAME)-mcp

podman-stats:
	@echo "📊  Container resource statistics…"
	@podman stats --no-stream $(PROJECT_NAME)-mcp

podman-shell:
	@echo "🐚  Opening shell in MCP container…"
	@podman exec -it $(PROJECT_NAME)-mcp /bin/bash

# =============================================================================
# ☁️ IBM CLOUD CODE ENGINE DEPLOYMENT
# =============================================================================
# help: ☁️ IBM CLOUD CODE ENGINE DEPLOYMENT
# help: ce-deploy            - Deploy to IBM Cloud Code Engine
# help: ce-update            - Update existing Code Engine deployment
# help: ce-delete            - Delete Code Engine deployment
# help: ce-status            - Check Code Engine deployment status
# help: ce-logs              - View Code Engine application logs
# help: ce-push-image        - Push container image to IBM Container Registry

# IBM Cloud Code Engine variables
CE_PROJECT         ?= plotext-plus
CE_APP_NAME        ?= plotext-mcp
CE_REGISTRY        ?= us.icr.io
CE_NAMESPACE       ?= plotext-plus
CE_IMAGE_TAG       ?= $(CE_REGISTRY)/$(CE_NAMESPACE)/$(CE_APP_NAME):latest
CE_CPU             ?= 0.25
CE_MEMORY          ?= 0.5G
CE_MIN_SCALE       ?= 0
CE_MAX_SCALE       ?= 10

.PHONY: ce-deploy ce-update ce-delete ce-status ce-logs ce-push-image

ce-push-image:
	@echo "☁️  Pushing container image to IBM Container Registry…"
	@echo "Building and tagging image: $(CE_IMAGE_TAG)"
	@docker build -t $(CE_IMAGE_TAG) -f Dockerfile.mcp .
	@echo "Pushing to registry…"
	@docker push $(CE_IMAGE_TAG)
	@echo "✅  Image pushed successfully: $(CE_IMAGE_TAG)"

ce-deploy:
	@echo "☁️  Deploying to IBM Cloud Code Engine…"
	@echo "Creating/updating Code Engine application: $(CE_APP_NAME)"
	@ibmcloud ce application create \
		--name $(CE_APP_NAME) \
		--image $(CE_IMAGE_TAG) \
		--port 8001 \
		--cpu $(CE_CPU) \
		--memory $(CE_MEMORY) \
		--min-scale $(CE_MIN_SCALE) \
		--max-scale $(CE_MAX_SCALE) \
		--env MCP_PORT=8001 \
		--env MCP_HOST=0.0.0.0 \
		--env PYTHONUNBUFFERED=1 \
		--project $(CE_PROJECT) || \
	ibmcloud ce application update \
		--name $(CE_APP_NAME) \
		--image $(CE_IMAGE_TAG) \
		--port 8001 \
		--cpu $(CE_CPU) \
		--memory $(CE_MEMORY) \
		--min-scale $(CE_MIN_SCALE) \
		--max-scale $(CE_MAX_SCALE) \
		--env MCP_PORT=8001 \
		--env MCP_HOST=0.0.0.0 \
		--env PYTHONUNBUFFERED=1 \
		--project $(CE_PROJECT)
	@echo "✅  Code Engine deployment complete!"
	@make ce-status

ce-update:
	@echo "☁️  Updating Code Engine deployment…"
	@make ce-push-image
	@ibmcloud ce application update \
		--name $(CE_APP_NAME) \
		--image $(CE_IMAGE_TAG) \
		--project $(CE_PROJECT)
	@echo "✅  Code Engine application updated!"
	@make ce-status

ce-delete:
	@echo "🗑️   Deleting Code Engine deployment…"
	@ibmcloud ce application delete \
		--name $(CE_APP_NAME) \
		--project $(CE_PROJECT) \
		--force
	@echo "✅  Code Engine application deleted!"

ce-status:
	@echo "📊  Checking Code Engine deployment status…"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@ibmcloud ce application get --name $(CE_APP_NAME) --project $(CE_PROJECT) || echo "Application not found"
	@echo ""
	@echo "Application URL:"
	@ibmcloud ce application get --name $(CE_APP_NAME) --project $(CE_PROJECT) --output url 2>/dev/null || echo "URL not available"

ce-logs:
	@echo "📜  Streaming Code Engine application logs…"
	@ibmcloud ce application logs --name $(CE_APP_NAME) --project $(CE_PROJECT) --follow

# Combined deployment target
ce-full-deploy: ce-push-image ce-deploy
	@echo "✅  Full IBM Cloud Code Engine deployment complete!"
	@echo ""
	@echo "🔗  Next steps:"
	@echo "   • Check status: make ce-status"
	@echo "   • View logs: make ce-logs"
	@echo "   • Update app: make ce-update"

# =============================================================================
# 🚀 VERSION MANAGEMENT & PUBLISHING
# =============================================================================
# help: 🚀 VERSION MANAGEMENT & PUBLISHING
# help: bump-patch           - Bump patch version (1.0.0 -> 1.0.1)
# help: bump-minor           - Bump minor version (1.0.0 -> 1.1.0)
# help: bump-major           - Bump major version (1.0.0 -> 2.0.0)
# help: publish              - Build and publish to PyPI with twine
# help: publish-test         - Build and publish to TestPyPI with twine
# help: release-patch        - Bump patch version and publish to PyPI
# help: release-minor        - Bump minor version and publish to PyPI
# help: release-major        - Bump major version and publish to PyPI

.PHONY: bump-patch bump-minor bump-major publish publish-test release-patch release-minor release-major

# Version bumping utilities
bump-patch:
	@echo "📈  Bumping patch version…"
	@current_version=$$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/'); \
	echo "Current version: $$current_version"; \
	new_version=$$(python3 -c "v='$$current_version'.split('.'); v[2]=str(int(v[2])+1); print('.'.join(v))"); \
	echo "New version: $$new_version"; \
	sed -i '' "s/^version = .*/version = \"$$new_version\"/" pyproject.toml; \
	echo "✅  Version bumped to $$new_version"

bump-minor:
	@echo "📈  Bumping minor version…"
	@current_version=$$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/'); \
	echo "Current version: $$current_version"; \
	new_version=$$(python3 -c "v='$$current_version'.split('.'); v[1]=str(int(v[1])+1); v[2]='0'; print('.'.join(v))"); \
	echo "New version: $$new_version"; \
	sed -i '' "s/^version = .*/version = \"$$new_version\"/" pyproject.toml; \
	echo "✅  Version bumped to $$new_version"

bump-major:
	@echo "📈  Bumping major version…"
	@current_version=$$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/'); \
	echo "Current version: $$current_version"; \
	new_version=$$(python3 -c "v='$$current_version'.split('.'); v[0]=str(int(v[0])+1); v[1]='0'; v[2]='0'; print('.'.join(v))"); \
	echo "New version: $$new_version"; \
	sed -i '' "s/^version = .*/version = \"$$new_version\"/" pyproject.toml; \
	echo "✅  Version bumped to $$new_version"

# Publishing targets using twine
publish:
	@echo "🚀  Building and publishing to PyPI with twine…"
	@echo "📦  Building package…"
	@uv build
	@echo "🔍  Checking package with twine…"
	@uv run twine check dist/*
	@echo "📤  Uploading to PyPI…"
	@uv run twine upload dist/*
	@echo "✅  Package published to PyPI!"
	@echo "🧹  Cleaning build artifacts…"
	@rm -rf dist/ build/

publish-test:
	@echo "🧪  Building and publishing to TestPyPI with twine…"
	@echo "📦  Building package…"
	@uv build
	@echo "🔍  Checking package with twine…"
	@uv run twine check dist/*
	@echo "📤  Uploading to TestPyPI…"
	@uv run twine upload --repository testpypi dist/*
	@echo "✅  Package published to TestPyPI!"
	@echo "🧹  Cleaning build artifacts…"
	@rm -rf dist/ build/

# Combined release targets
release-patch:
	@echo "🚀  Releasing new patch version…"
	@make bump-patch
	@make publish
	@echo "✅  Patch release complete!"

release-minor:
	@echo "🚀  Releasing new minor version…"
	@make bump-minor
	@make publish
	@echo "✅  Minor release complete!"

release-major:
	@echo "🚀  Releasing new major version…"
	@make bump-major
	@make publish
	@echo "✅  Major release complete!"

# =============================================================================
# 🎯 QUICK DEVELOPMENT TARGETS
# =============================================================================
# help: 🎯 QUICK DEVELOPMENT TARGETS
# help: dev                  - Quick development setup (install + format + test)
# help: check                - Quick check (lint-check + test-fast)
# help: all                  - Run everything (format + lint + test + build)

.PHONY: dev check all

dev:
	@echo "🎯  Quick development setup…"
	@make install-all
	@make format
	@make test-fast
	@echo "✅  Development setup complete!"

check:
	@echo "🔍  Quick check…"
	@make lint-check
	@make test-fast
	@echo "✅  Check complete!"

all:
	@echo "🎯  Running full pipeline…"
	@make format
	@make lint
	@make test
	@make build
	@echo "✅  Full pipeline complete!"

# =============================================================================
# 🔧 UTILITIES
# =============================================================================
# help: 🔧 UTILITIES
# help: version              - Show current version
# help: info                 - Show project information
# help: deps                 - Show dependency tree

.PHONY: version info deps

version:
	@echo "📊  Plotext Plus Version Information"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@grep '^version = ' pyproject.toml | sed 's/version = /Version: /'
	@python -c "import plotext_plus; print(f'Installed: {plotext_plus.__version__ if hasattr(plotext_plus, \"__version__\") else \"dev\"}')"

info:
	@echo "📊  Plotext Plus Project Information"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Project: $(PROJECT_NAME)"
	@echo "Description: Modern terminal plotting library with enhanced visual features"
	@echo "Structure:"
	@echo "  📁 src/plotext_plus/ - Main source code"
	@echo "  📁 tests/           - Test suites"
	@echo "  📁 examples/        - Interactive demos"
	@echo "  📁 docs/            - Documentation"
	@echo "  📁 data/            - Sample data files"
	@echo ""
	@echo "Key Features:"
	@echo "  🎨 Enhanced themes and banner mode"
	@echo "  📊 Multiple chart types (scatter, line, bar, heatmap)"
	@echo "  🔌 MCP (Model Context Protocol) integration"
	@echo "  🎯 Clean public API structure"
	@echo ""
	@echo "Quick Start:"
	@echo "  make dev      # Setup development environment"
	@echo "  make run-demos# Run interactive examples"
	@echo "  make run-mcp  # Start MCP server"

deps:
	@echo "📦  Dependency Information"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@uv tree