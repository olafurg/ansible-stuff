# AGENTS.md

This document provides guidelines for agentic coding assistants working in this Ansible repository. It covers build/lint/test commands, code style guidelines, and repository conventions.

## Build/Lint/Test Commands

### Linting
- **Full lint suite**: `make lint`
  - Runs both YAML and Ansible linting
- **YAML linting only**: `make lint-yaml` or `yamllint .`
  - Checks YAML formatting and syntax
- **Ansible linting only**: `make lint-ansible` or `ansible-lint playbooks/*/playbook.yml roles/*/tasks/*.yml`
  - Validates Ansible playbooks and role tasks

### Pre-commit Hooks
- **Install hooks**: `pre-commit install`
- **Run all hooks manually**: `pre-commit run --all-files`
- **Run specific hook**: `pre-commit run <hook-id> --all-files`

### Syntax Checking
- **Check all playbooks**: `make check`
  - Runs syntax validation on all main playbooks
- **Check specific playbook**: `ansible-playbook <playbook-path> --syntax-check`

### Testing Playbooks
- **macOS workstation**: `make macos` or `ansible-playbook playbooks/macos_workstation/playbook.yml -K`
- **Debian/Ubuntu workstation**: `make debian` or `ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -K`

### CI Pipeline
The GitHub Actions CI runs:
1. `yamllint .`
2. `ansible-galaxy install -r requirements.yml`
3. `ansible-lint playbooks/*/playbook.yml roles/*/tasks/*.yml`

## Code Style Guidelines

### YAML Formatting (.yamllint rules)
- **Indentation**: 2 spaces, indent sequences consistently
- **Line length**: Maximum 120 characters (warning level)
- **Comments**: Minimum 1 space from content, no indentation requirement
- **Braces/Brackets**: Maximum 1 space inside
- **Octal values**: Forbidden (implicit and explicit)
- **Ignored paths**: .git/, .github/, .molecule/, .vscode/, __pycache__/

### Ansible Code Style (ansible-lint rules)
- **Task naming**: Use descriptive, imperative names (e.g., "Install Vim", "Create symlink")
- **Module usage**: Prefer `ansible.builtin.*` modules over deprecated ones
- **Role structure**: Follow standard Ansible role layout
- **Variable naming**: Use snake_case, avoid role prefix warnings when appropriate
- **File permissions**: Warn on risky permissions
- **Command usage**: Warn when using shell instead of command (when applicable)

### Role Structure Conventions
- **Main tasks file**: `roles/{role_name}/tasks/main.yml`
- **OS-specific tasks**: Include separate files like `debian_ubuntu.yml`, `macos.yml`, `arch_linux.yml`
- **Conditional includes**: Use `when: ansible_facts['os_family'] in ['Debian', 'Ubuntu']`
- **Tags**: Include role name as tag (e.g., `tags: [vim]`)

### Task Writing Patterns
- **Privileged tasks**: Use `become: true` for system-level changes
- **Package installation**:
  - Debian/Ubuntu: `ansible.builtin.apt`
  - macOS: `community.general.homebrew` or `community.general.homebrew_cask`
  - Arch Linux: `ansible.builtin.pacman`
- **File operations**: Use `ansible.builtin.file` for symlinks, directories, etc.
- **Template variables**: Use `{{ role_path }}/files/...` for role file references
- **Environment variables**: Use `{{ ansible_facts.env.HOME }}` or `{{ ansible_env.HOME }}`

### Playbook Organization
- **Role-first approach**: Use roles for complex installations with configuration
- **Task sections**: Group related tasks with comments (e.g., "# Base roles", "# Apps that require no config")
- **Loop usage**: Use `loop` for installing multiple packages
- **Conditional installations**: Use `when` clauses for OS/architecture-specific logic

### Error Handling
- **Idempotency**: Ensure tasks are safe to run multiple times
- **State management**: Use `state: present/absent` appropriately
- **Force operations**: Use `force: true` for symlinks when needed
- **Directory creation**: Ensure parent directories exist before file operations

### Naming Conventions
- **Roles**: lowercase_with_underscores (e.g., `visual_studio_code`)
- **Variables**: snake_case
- **Task names**: Start with capital letter, imperative mood
- **File names**: snake_case.yml for task files
- **Directory names**: snake_case for role directories

### Best Practices
- **Documentation**: Include name for all tasks and plays
- **Modularity**: Split complex tasks into separate files by OS
- **Reusability**: Use variables for common paths and package names
- **Security**: Avoid hardcoded secrets, use Ansible Vault for sensitive data
- **Maintainability**: Keep tasks focused on single responsibilities

### Common Patterns
- **Symlink creation**:
  ```yaml
  - name: Create symlink for config file
    ansible.builtin.file:
      src: "{{ role_path }}/files/.config"
      dest: "{{ ansible_facts.env.HOME }}/.config"
      state: link
      force: true
  ```

- **Package installation with OS detection**:
  ```yaml
  - name: Install package on Debian/Ubuntu
    ansible.builtin.apt:
      name: "{{ item }}"
      state: present
    loop: "{{ debian_packages }}"
    when: ansible_facts['os_family'] in ['Debian', 'Ubuntu']
  ```

- **Directory creation**:
  ```yaml
  - name: Ensure directory exists
    ansible.builtin.file:
      path: "{{ ansible_facts.env.HOME }}/.config/app"
      state: directory
      mode: '0755'
  ```

### Development Workflow
1. Make changes to roles/playbooks
2. Run `make lint` to check code quality
3. Run `make check` for syntax validation
4. Test changes with appropriate playbook (e.g., `make macos`)
5. Commit changes (pre-commit hooks will run automatically)

### Dependencies
- **Ansible Galaxy**: Requirements defined in `requirements.yml`
- **Python packages**: ansible-lint, yamllint for development
- **System packages**: Varies by OS (see individual setup.sh scripts)

Remember: Always test playbook changes on target systems before committing. Use `ansible-playbook --check` for dry-run testing when possible.
