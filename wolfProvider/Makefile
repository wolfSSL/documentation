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
		  chapter08.md \
		  chapter09.md \
		  chapter10.md

ifeq ($(DOC_LANG),JA)
	PDF = wolfProvider-Manual-jp.pdf
else
	PDF = wolfProvider-Manual.pdf
	# chapter11 (Post-Quantum) is English-only until it is translated.
	SOURCES += chapter11.md
endif

.PHONY: html-prep
html-prep:
	$(Q)cp png/*.png build/html/

.PHONY: pdf-prep
pdf-prep:
	$(Q)cp png/*.png build/pdf/
