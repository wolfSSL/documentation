-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html 

SOURCES = section01.md \
		  section02.md

ifeq ($(DOC_LANG),JA)
    PDF  = wolfSSL-FIPS-FAQ-jp.pdf
else
    PDF  = wolfSSL-FIPS-FAQ.pdf
endif

DOXYFILE = Doxyfile


.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
