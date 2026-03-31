# Set PATH to include pipx-installed tools
# GNU Make 3.81 (macOS default) can't reliably export PATH, so we prepend it in each recipe.
SHELL := /bin/zsh
LINT_PATH := $(HOME)/.local/pipx/venvs/ansible-lint/bin
ANSIBLE_PATH := $(HOME)/.local/bin:$(HOME)/.local/pipx/venvs/ansible/bin
LINT_CMD := export PATH="$(LINT_PATH):$$PATH";
ANSIBLE_CMD := export PATH="$(ANSIBLE_PATH):$$PATH";

.PHONY: help setup lint lint-yaml lint-ansible check macos debian clean

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

lint-yaml: ## Run yamllint on all YAML files
	@echo "Running yamllint..."
	@$(LINT_CMD) yamllint .

lint-ansible: ## Run ansible-lint on playbooks and roles
	@echo "Running ansible-lint..."
	@$(LINT_CMD) ansible-lint playbooks/*/playbook.yml roles/*/tasks/*.yml

check: ## Run syntax check on all playbooks
	@echo "Checking macOS playbook syntax..."
	@$(ANSIBLE_CMD) ansible-playbook playbooks/macos_workstation/playbook.yml --syntax-check
	@echo "Checking Debian/Ubuntu playbook syntax..."
	@$(ANSIBLE_CMD) ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml --syntax-check

macos: ## Run macOS playbook
	@$(ANSIBLE_CMD) ansible-playbook playbooks/macos_workstation/playbook.yml -K

debian: ## Run Debian/Ubuntu playbook
	@$(ANSIBLE_CMD) ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -K

clean: ## Clean up temporary files
	@echo "Cleaning up..."
	@find . -type f -name '*.retry' -delete
	@find . -type f -name '*.log' -delete
	@find . -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
	@echo "Done!"
