-include ../common/common.am
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
	@git clone --depth 1 https://github.com/wolfSSL/wolfhsm


.PHONY: wolfhsm-update
wolfhsm-update: wolfhsm
	@cd wolfhsm && git pull --ff-only

.PHONY: api
api: wolfhsm-update


# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api


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
