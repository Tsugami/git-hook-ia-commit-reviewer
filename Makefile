.PHONY: install uninstall check-dependencies

# Directory where Git stores global hooks
GIT_HOOKS_DIR := $(shell git config --global core.hooksPath 2>/dev/null || echo "$(HOME)/.git-hooks")

check-dependencies:
	@echo "Checking dependencies..."
	@if ! command -v jq >/dev/null 2>&1; then \
		echo "Installing jq..."; \
		if command -v apt-get >/dev/null 2>&1; then \
			sudo apt-get update && sudo apt-get install -y jq; \
		elif command -v yum >/dev/null 2>&1; then \
			sudo yum install -y jq; \
		elif command -v brew >/dev/null 2>&1; then \
			brew install jq; \
		else \
			echo "Could not install jq. Please install it manually."; \
			exit 1; \
		fi \
	fi
	@echo "All dependencies are installed."

install: check-dependencies
	@echo "Installing commit hook globally..."
	@mkdir -p $(GIT_HOOKS_DIR)
	@cp hooks/commit-msg $(GIT_HOOKS_DIR)/
	@chmod +x $(GIT_HOOKS_DIR)/commit-msg
	@git config --global core.hooksPath $(GIT_HOOKS_DIR)
	@echo "Commit hook successfully installed at: $(GIT_HOOKS_DIR)"

uninstall:
	@echo "Removing global commit hook..."
	@rm -f $(GIT_HOOKS_DIR)/commit-msg
	@git config --global --unset core.hooksPath
	@echo "Commit hook successfully removed." 