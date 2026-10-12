# The manual content and build adapter live in wolfSSL/wolfTPM.
WOLFTPM_SOURCE ?= wolftpm
WOLFTPM_REF ?= master
export WOLFTPM_REF

# The shared documentation build sets DOC_LANG=JA for the Japanese manual.
ifeq ($(DOC_LANG),JA)
LANG_ARG = --lang ja
else
LANG_ARG = --lang en
endif

.DEFAULT_GOAL := all
.PHONY: all pdf html source
all: source
	python3 "$(WOLFTPM_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTPM_SOURCE)" $(LANG_ARG) --target all

source:
	@set -eu; \
	if [ "$(WOLFTPM_SOURCE)" = wolftpm ]; then \
		if [ -e wolftpm ]; then \
			if [ ! -e wolftpm/.git ]; then \
				echo 'wolftpm exists but is not a Git checkout' >&2; exit 1; \
			fi; \
			remote=$$(git -C wolftpm config --get remote.origin.url) || { \
				echo 'wolftpm has no origin remote' >&2; exit 1; \
			}; \
			if [ "$$remote" != https://github.com/wolfSSL/wolfTPM.git ]; then \
				echo "wolftpm origin is $$remote; expected https://github.com/wolfSSL/wolfTPM.git" >&2; exit 1; \
			fi; \
			if [ -n "$$(git -C wolftpm status --porcelain)" ]; then \
				echo 'wolftpm checkout has local changes; use WOLFTPM_SOURCE for local edits' >&2; exit 1; \
			fi; \
		else \
			git init -q wolftpm; \
			git -C wolftpm remote add origin https://github.com/wolfSSL/wolfTPM.git; \
		fi; \
		ref=$$WOLFTPM_REF; \
		case "$$ref" in ''|-*) echo 'WOLFTPM_REF must be a commit, tag, or branch' >&2; exit 1;; esac; \
		if printf '%s' "$$ref" | grep -Eq '^[0-9a-f]{40}$$' && \
			git -C wolftpm cat-file -e "$$ref^{commit}" 2>/dev/null; then \
			git -C wolftpm checkout --detach "$$ref"; \
		else \
			git -C wolftpm fetch --depth 1 origin "$$ref"; \
			git -C wolftpm checkout --detach FETCH_HEAD; \
		fi; \
		echo "wolfTPM source: $$(git -C wolftpm rev-parse HEAD)"; \
	else \
		test -f "$(WOLFTPM_SOURCE)/tools/docs_manual.py"; \
	fi

pdf html: source
	python3 "$(WOLFTPM_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTPM_SOURCE)" $(LANG_ARG) --target $@

