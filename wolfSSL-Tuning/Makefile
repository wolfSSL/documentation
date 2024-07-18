-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = section01.md \
		  section02.md \
		  section03.md \
		  section04.md

ifeq ($(DOC_LANG),JA)
    PDF  = wolfSSL-Tuning-Guide-jp.pdf
else
    PDF  = wolfSSL-Tuning-Guide.pdf
endif

DOXYFILE = Doxyfile


.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
