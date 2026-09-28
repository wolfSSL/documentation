# The manual content and build adapter live in wolfSSL/wolfTrust.
WOLFTRUST_SOURCE ?= wolftrust

.DEFAULT_GOAL := all
.PHONY: all pdf html source
all: source
	python3 "$(WOLFTRUST_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTRUST_SOURCE)" --target all

source:
	@if [ "$(WOLFTRUST_SOURCE)" = wolftrust ]; then \
		if [ -d wolftrust/.git ]; then \
			git -C wolftrust pull --ff-only; \
		else \
			git clone --depth 1 --branch main https://github.com/wolfSSL/wolfTrust.git wolftrust; \
		fi; \
	else \
		test -f "$(WOLFTRUST_SOURCE)/tools/docs_manual.py"; \
	fi

pdf html: source
	python3 "$(WOLFTRUST_SOURCE)/tools/docs_manual.py" build \
		--documentation-root .. --source-root "$(WOLFTRUST_SOURCE)" --target $@
