# The manual content and build adapter live in wolfSSL/wolfTrust.
WOLFTRUST_SOURCE ?= wolftrust
WOLFTRUST_REF ?= main
export WOLFTRUST_REF

.DEFAULT_GOAL := all
.PHONY: all pdf html source
all: source
	python3 "$(WOLFTRUST_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTRUST_SOURCE)" --target all

source:
	@set -eu; \
	if [ "$(WOLFTRUST_SOURCE)" = wolftrust ]; then \
		if [ -e wolftrust ]; then \
			if [ ! -e wolftrust/.git ]; then \
				echo 'wolftrust exists but is not a Git checkout' >&2; exit 1; \
			fi; \
			remote=$$(git -C wolftrust config --get remote.origin.url) || { \
				echo 'wolftrust has no origin remote' >&2; exit 1; \
			}; \
			if [ "$$remote" != https://github.com/wolfSSL/wolfTrust.git ]; then \
				echo "wolftrust origin is $$remote; expected https://github.com/wolfSSL/wolfTrust.git" >&2; exit 1; \
			fi; \
			if [ -n "$$(git -C wolftrust status --porcelain)" ]; then \
				echo 'wolftrust checkout has local changes; use WOLFTRUST_SOURCE for local edits' >&2; exit 1; \
			fi; \
		else \
			git init -q wolftrust; \
			git -C wolftrust remote add origin https://github.com/wolfSSL/wolfTrust.git; \
		fi; \
		ref=$$WOLFTRUST_REF; \
		case "$$ref" in ''|-*) echo 'WOLFTRUST_REF must be a commit, tag, or branch' >&2; exit 1;; esac; \
		if printf '%s' "$$ref" | grep -Eq '^[0-9a-f]{40}$$' && \
			git -C wolftrust cat-file -e "$$ref^{commit}" 2>/dev/null; then \
			git -C wolftrust checkout --detach "$$ref"; \
		else \
			git -C wolftrust fetch --depth 1 origin "$$ref"; \
			git -C wolftrust checkout --detach FETCH_HEAD; \
		fi; \
		echo "wolfTrust source: $$(git -C wolftrust rev-parse HEAD)"; \
	else \
		test -f "$(WOLFTRUST_SOURCE)/tools/docs_manual.py"; \
	fi

pdf html: source
	python3 "$(WOLFTRUST_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTRUST_SOURCE)" --target $@
