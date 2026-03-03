.PHONY: help lint fmt syntax-check test molecule-test run clean

PLAYBOOK     ?= ansible/playbooks/site.yml
INVENTORY    ?= ansible/inventory/
EXTRA_VARS   ?= env=dev

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

lint: ## Run ansible-lint + ruff
	ansible-lint ansible/
	ruff check .

fmt: ## Auto-format Python code
	black .
	ruff check --fix .

syntax-check: ## Ansible syntax check
	ansible-playbook $(PLAYBOOK) --syntax-check -i $(INVENTORY)

test: ## Run pytest unit tests
	pytest tests/ -v --tb=short

molecule-test: ## Run molecule tests for all roles
	@for role in ansible/roles/*/; do \
	  if [ -d "$${role}molecule" ]; then \
	    echo "▶ Testing role: $$role"; \
	    cd "$$role" && molecule test && cd -; \
	  fi; \
	done

run: ## Run the main site playbook (make run EXTRA_VARS="env=prod")
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --extra-vars "$(EXTRA_VARS)"

dry-run: ## Dry-run the playbook (check mode)
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --check --diff --extra-vars "$(EXTRA_VARS)"

install-deps: ## Install all Python and Ansible dependencies
	pip install -r requirements.txt
	ansible-galaxy collection install -r requirements.yml
	pre-commit install

clean: ## Remove temp files and caches
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.retry" -delete
