# Set PATH to include pipx-installed tools
# GNU Make 3.81 (macOS default) can't reliably export PATH, so we prepend it in each recipe.
SHELL := /bin/zsh
EXTRA_PATH := $(HOME)/.local/bin:$(HOME)/.local/pipx/venvs/ansible/bin:$(HOME)/.local/pipx/venvs/ansible-lint/bin
CMD := export PATH="$(EXTRA_PATH):$$PATH";

.PHONY: help lint lint-yaml lint-ansible check macos debian clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint: lint-yaml lint-ansible ## Run all linters

lint-yaml: ## Run yamllint on all YAML files
	@echo "Running yamllint..."
	@$(CMD) yamllint .

lint-ansible: ## Run ansible-lint on playbooks and roles
	@echo "Running ansible-lint..."
	@$(CMD) ansible-lint playbooks/*/playbook.yml roles/*/tasks/*.yml

check: ## Run syntax check on all playbooks
	@echo "Checking macOS playbook syntax..."
	@$(CMD) ansible-playbook playbooks/macos_workstation/playbook.yml --syntax-check
	@echo "Checking Debian/Ubuntu playbook syntax..."
	@$(CMD) ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml --syntax-check

macos: ## Run macOS playbook
	@$(CMD) ansible-playbook playbooks/macos_workstation/playbook.yml -K

debian: ## Run Debian/Ubuntu playbook
	@$(CMD) ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -K

clean: ## Clean up temporary files
	@echo "Cleaning up..."
	@find . -type f -name '*.retry' -delete
	@find . -type f -name '*.log' -delete
	@find . -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
	@echo "Done!"
