-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = section01.md \
		  section02.md \
		  section03.md \
		  section04.md

ifeq ($(DOC_LANG),JA)
    PDF  = wolfSSL-Porting-Guide-ja.pdf
	DOXYFILE = Doxyfile-ja
else
    PDF  = wolfSSL-Porting-Guide.pdf
	DOXYFILE = Doxyfile
endif


.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
