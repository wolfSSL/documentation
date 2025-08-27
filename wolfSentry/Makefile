-include ../common/common.am
.DEFAULT_GOAL := all
all: pre-build pdf html

SOURCES = README.md \
		  freertos-lwip-app.md \
		  json_configuration.md \
		  ChangeLog.md

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

.PHONY: pre-build
pre-build:
ifeq ($(DOC_LANG),JA)
	cp src/ChangeLog.md src-ja/
endif
