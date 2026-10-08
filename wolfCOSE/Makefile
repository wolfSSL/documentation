# The manual content and build adapter live in wolfSSL/wolfCOSE.
WOLFCOSE_SOURCE ?= wolfcose
WOLFCOSE_REF ?= main
export WOLFCOSE_REF

.DEFAULT_GOAL := all
.PHONY: all pdf html source
all: source
	python3 "$(WOLFCOSE_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFCOSE_SOURCE)" --target all

source:
	@set -eu; \
	if [ "$(WOLFCOSE_SOURCE)" = wolfcose ]; then \
		if [ -e wolfcose ]; then \
			if [ ! -e wolfcose/.git ]; then \
				echo 'wolfcose exists but is not a Git checkout' >&2; exit 1; \
			fi; \
			remote=$$(git -C wolfcose config --get remote.origin.url) || { \
				echo 'wolfcose has no origin remote' >&2; exit 1; \
			}; \
			if [ "$$remote" != https://github.com/wolfSSL/wolfCOSE.git ]; then \
				echo "wolfcose origin is $$remote; expected https://github.com/wolfSSL/wolfCOSE.git" >&2; exit 1; \
			fi; \
			if [ -n "$$(git -C wolfcose status --porcelain)" ]; then \
				echo 'wolfcose checkout has local changes; use WOLFCOSE_SOURCE for local edits' >&2; exit 1; \
			fi; \
		else \
			git init -q wolfcose; \
			git -C wolfcose remote add origin https://github.com/wolfSSL/wolfCOSE.git; \
		fi; \
		ref=$$WOLFCOSE_REF; \
		case "$$ref" in ''|-*) echo 'WOLFCOSE_REF must be a commit, tag, or branch' >&2; exit 1;; esac; \
		if printf '%s' "$$ref" | grep -Eq '^[0-9a-f]{40}$$' && \
			git -C wolfcose cat-file -e "$$ref^{commit}" 2>/dev/null; then \
			git -C wolfcose checkout --detach "$$ref"; \
		else \
			git -C wolfcose fetch --depth 1 origin "$$ref"; \
			git -C wolfcose checkout --detach FETCH_HEAD; \
		fi; \
		echo "wolfCOSE source: $$(git -C wolfcose rev-parse HEAD)"; \
	else \
		test -f "$(WOLFCOSE_SOURCE)/tools/docs_manual.py"; \
	fi

pdf html: source
	python3 "$(WOLFCOSE_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFCOSE_SOURCE)" --target $@
