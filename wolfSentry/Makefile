-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \
		  chapter04.md \
		  
PDF = wolfSentry-Manual.pdf

ifeq ($(DOC_LANG),JA)
    PDF  = wolfSentry-Manual-jp.pdf
	DOXYFILE = Doxyfile-ja
else
    PDF  = wolfSentry-Manual.pdf
	DOXYFILE = Doxyfile
endif

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
