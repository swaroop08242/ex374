# Ansible Dev Environment

A fully containerised Ansible + Python development environment with CI/CD.

## Prerequisites

- WSL2 (Ubuntu recommended)
- Docker Desktop (with WSL integration enabled)
- VS Code + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Getting Started

### 1. Open in Dev Container

```bash
# Clone / open the project in WSL
code .
```

VS Code will detect `.devcontainer/` and prompt **"Reopen in Container"** — click it.
Or: `Ctrl+Shift+P` → **Dev Containers: Reopen in Container**

### 2. Install dependencies (first time, auto-runs via postCreateCommand)

```bash
make install-deps
```

---

## Common Commands

| Command | Description |
|---|---|
| `make lint` | Run ansible-lint + ruff |
| `make fmt` | Auto-format all Python files |
| `make syntax-check` | Ansible playbook syntax check |
| `make test` | Run pytest unit tests |
| `make molecule-test` | Run Molecule tests for all roles |
| `make run` | Run the main site playbook |
| `make dry-run` | Dry-run (check mode, no changes) |
| `make clean` | Remove caches and temp files |

### Override variables

```bash
make run EXTRA_VARS="env=prod"
make run PLAYBOOK=ansible/playbooks/other.yml
```

---

## CI/CD Pipeline

GitHub Actions runs automatically on push/PR:

1. **Lint** — ansible-lint, ruff, black, syntax-check
2. **Tests** — pytest
3. **Molecule** — role tests (if roles with molecule/ exist)
4. **Deploy** — runs on merge to `main` only

---

## Project Structure

```
.
├── .devcontainer/          # VS Code dev container config
├── .github/workflows/      # GitHub Actions CI/CD
├── ansible/
│   ├── ansible.cfg         # Ansible configuration
│   ├── inventory/          # Host inventory
│   ├── playbooks/          # Playbooks (entry points)
│   └── roles/              # Reusable roles
├── tests/                  # Python/pytest tests
├── .ansible-lint           # Lint rules
├── .pre-commit-config.yaml # Git hooks
├── Makefile                # Dev shortcuts
├── pyproject.toml          # Python tool config
├── requirements.txt        # Python dependencies
└── requirements.yml        # Ansible collections
```

---

## Adding a New Role

```bash
cd ansible/roles
ansible-galaxy role init my_role
# Add molecule tests:
cd my_role && molecule init scenario
```
