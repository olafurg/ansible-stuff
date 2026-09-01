# pipx shims every app it installs into ~/.local/bin on all platforms, so that
# is the only directory worth prepending. Anything installed by a system
# package manager instead (ansible on Arch, say) is picked up from $PATH.
# GNU Make 3.81 (macOS default) can't reliably export PATH, so we prepend it in each recipe.
SHELL := /bin/sh
TOOL_PATH := $(HOME)/.local/bin
RUN := export PATH="$(TOOL_PATH):$$PATH";

.PHONY: help setup lint lint-yaml lint-ansible check \
	macos arch arch-wsl debian debian-wsl debian-server clean

# The Arch WSL image ships without a generated locale, so Ansible falls back to
# ASCII and mangles non-ASCII output unless one is forced. Matches setup.sh.
ARCH_LOCALE := LANG=C.UTF-8 LC_ALL=C.UTF-8

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Bootstrap this machine (installs Ansible, dependencies, runs playbook)
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Detected macOS"; \
		./playbooks/macos_workstation/setup.sh; \
	elif grep -qi "arch" /etc/os-release 2>/dev/null; then \
		if grep -qi "microsoft" /proc/version 2>/dev/null; then \
			echo "Detected Arch Linux (WSL)"; \
			./playbooks/arch_linux_wsl/setup.sh; \
		else \
			echo "Detected Arch Linux"; \
			./playbooks/arch_linux_workstation/setup.sh; \
		fi; \
	elif grep -qiE "debian|ubuntu" /etc/os-release 2>/dev/null; then \
		if grep -qi "microsoft" /proc/version 2>/dev/null; then \
			echo "Detected Debian/Ubuntu (WSL)"; \
			./playbooks/debian_ubuntu_wsl/setup.sh; \
		else \
			echo "Detected Debian/Ubuntu"; \
			./playbooks/debian_ubuntu_workstation/setup.sh; \
		fi; \
	else \
		echo "ERROR: Unsupported OS. Run the appropriate setup.sh manually."; \
		exit 1; \
	fi

lint: lint-yaml lint-ansible ## Run all linters

# Fail with something actionable instead of "command not found".
require-%:
	@$(RUN) command -v $* >/dev/null 2>&1 || { \
		echo "ERROR: $* not found."; \
		echo "Install it with 'make setup' (the pipx role), or: pipx install $*"; \
		exit 1; \
	}

lint-yaml: require-yamllint ## Run yamllint on all YAML files
	@echo "Running yamllint..."
	@$(RUN) yamllint .

lint-ansible: require-ansible-lint ## Run ansible-lint on playbooks and roles
	@echo "Running ansible-lint..."
	@$(RUN) ansible-lint playbooks/*/playbook.yml roles/*/tasks/*.yml

check: require-ansible-playbook ## Run syntax check on all playbooks
	@echo "Checking playbook syntax..."
	@$(RUN) for p in playbooks/*/playbook.yml; do \
		printf '  %-28s ' "$$(basename $$(dirname $$p))"; \
		if ansible-playbook "$$p" --syntax-check >/dev/null 2>&1; then \
			echo "OK"; \
		else \
			echo "FAIL"; \
			failed=1; \
		fi; \
	done; \
	[ -z "$$failed" ] || { echo "Syntax check failed. Re-run the failing playbook with --syntax-check for detail."; exit 1; }

# Local machine playbooks. -K prompts once for the sudo password. These run the
# playbook only; use `make setup` to install the prerequisites first on a new box.
macos: require-ansible-playbook ## Run the macOS workstation playbook
	@$(RUN) ansible-playbook playbooks/macos_workstation/playbook.yml -K

arch: require-ansible-playbook ## Run the Arch workstation playbook
	@$(RUN) $(ARCH_LOCALE) ansible-playbook playbooks/arch_linux_workstation/playbook.yml -K

arch-wsl: require-ansible-playbook ## Run the Arch WSL playbook
	@$(RUN) $(ARCH_LOCALE) ansible-playbook playbooks/arch_linux_wsl/playbook.yml -K

debian: require-ansible-playbook ## Run the Debian/Ubuntu workstation playbook
	@$(RUN) ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -K

debian-wsl: require-ansible-playbook ## Run the Debian/Ubuntu WSL playbook
	@$(RUN) ansible-playbook playbooks/debian_ubuntu_wsl/playbook.yml -K

# Remote, unlike every target above: connects to the `servers` group as root
# over SSH, so there is no become step for -K to answer. Defaults to every
# server in the inventory — scope to one with LIMIT=<host>.
debian-server: require-ansible-playbook ## Run the Debian server playbook (LIMIT=host to scope)
	@$(RUN) ansible-playbook playbooks/debian_server/playbook.yml $(if $(LIMIT),--limit $(LIMIT))

clean: ## Clean up temporary files
	@echo "Cleaning up..."
	@find . -type f -name '*.retry' -delete
	@find . -type f -name '*.log' -delete
	@find . -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
	@echo "Done!"
