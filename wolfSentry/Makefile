-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


ifeq ($(DOC_LANG),JA)
SOURCES = chapter01.md \
		  chapter02.md \
		  chapter04.md
else
SOURCES = README.md freertos-lwip-app.md json_configuration.md ChangeLog.md
endif

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
