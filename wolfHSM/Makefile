-include ../common/common.am

# Override SRC to point to cloned wolfHSM repo's docs directory.
# Use new location (wolfhsm/docs/src) if it exists, otherwise fallback to local
# src/ for backwards compatibility during transition period.
ifeq ($(DOC_LANG),JA)
    SRC_NEW = wolfhsm/docs/src-ja
    SRC_OLD = src-ja
else
    SRC_NEW = wolfhsm/docs/src
    SRC_OLD = src
endif
SRC = $(shell if [ -d "$(SRC_NEW)" ]; then echo "$(SRC_NEW)"; else echo "$(SRC_OLD)"; fi)

.DEFAULT_GOAL := all

all: pdf html


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \
		  chapter04.md \
		  chapter05.md \
		  chapter06.md \
		  chapter07.md \
		  chapter08.md
APPENDIX= appendix01.md

ifeq ($(DOC_LANG),JA)
	DOXY = Doxyfile-ja
	PDF  = wolfHSM-Manual-jp.pdf
else
	DOXY = Doxyfile
	PDF  = wolfHSM-Manual.pdf
endif


wolfhsm:
	$(Q)git clone --depth 1 https://github.com/wolfSSL/wolfHSM wolfhsm


.PHONY: wolfhsm-update
wolfhsm-update: wolfhsm
	$(Q)if [ -L wolfhsm ]; then \
		echo "Skipping git pull for symlink (local testing)"; \
	else \
		cd wolfhsm && git pull --ff-only; \
	fi

.PHONY: api
api: wolfhsm-update
	$(Q)mkdir -p api/md
	$(Q)cd wolfhsm && doxygen ../Doxyfile
	$(Q)cd ..
	$(Q)doxybook2 --input docs/xml --output api/md --config doxybook.cfg

# NOTE: html-setup and pdf-setup are overridden from common/common.am to inject
# the wolfhsm-update dependency. If common.am changes these targets, the changes
# will need to be manually synchronized here. This duplication is intentional to
# ensure the wolfHSM repo is cloned before attempting to copy docs from it.

# Override html-setup to ensure wolfhsm repo is cloned first
.PHONY: html-setup
html-setup: wolfhsm-update
	$(Q)git submodule update --init
	-cd ../mkdocs-material; patch -p1 < $(PATCH) --ignore-whitespace -N
	$(Q)cp -a $(SRC)/* build/html/
	$(Q)cp ../common/*.png build/html/
	$(Q)cp ../common/*.css build/html/
	$(Q)perl -i -pe 's/    ```/```/g' build/html/*.md
	$(Q)perl -i -pe "s/\#--/\#-/g" build/html/*.md
	$(Q)mv build/html/$(word 1,$(SOURCES)) build/html/index.md

# Override pdf-setup to ensure wolfhsm repo is cloned first
.PHONY: pdf-setup
pdf-setup: wolfhsm-update builddir
	$(Q)cp -a $(SRC)/* build/pdf/
	$(Q)cp ../common/*.png build/pdf/
	$(Q)perl -i -pe "s/chapter[0-9][0-9].md|appendix[0-9][0-9].md//g" build/pdf/*.md
	$(Q)perl -i -pe "s/\#--/\#/g" build/pdf/*.md

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api
	$(Q)cp -a api/md/*8h* build/html/

	$(Q)perl -i -pe "s/\/group_/group_/g" build/html/group* build/html/*8h*
	$(Q)perl -i -pe "s/dox_comments\/header_files\///" build/html/*8h*

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Indent all headings by one #
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
# 5. Fix titles of the header files Markdown
# 6. Two regexes to handle bad Doxygen that didn't convert and the LaTeX processor thinks is LaTeX commands
.PHONY: pdf-prep
pdf-prep: api
	$(Q)cp -a api/md/*8h* build/pdf/

	$(Q)perl -i -pe "s/# /## /g" build/pdf/*.md
	$(Q)perl -i -pe "s/(\/group_.*|Classes\/struct.*|\/.*8h)\.md//g" build/pdf/*.md
	$(Q)perl -i -pe "s/^-(-)+$$//" build/pdf/*.md
	$(Q)perl -i -pe "s/^title:.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/^Updated on.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/^summary.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/dox_comments\/header_files\///" build/pdf/*.md
	$(Q)perl -i -pe "s/^\\\\//" build/pdf/*.md
	$(Q)perl -i -pe "s/\\\\par/par/g" build/pdf/*.md
	$(Q)perl -i -pe "s/\[(.*?)\]\(Classes\/.*?.md\)/\[\1\]\(#typedef-\1\)/g" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md
	$(Q)cat build/pdf/wh__client_8h.md build/pdf/wh__client__crypto_8h.md build/pdf/wh__server_8h.md >> build/pdf/appendix01.md
