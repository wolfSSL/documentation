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
          chapter09.md

ifeq ($(DOC_LANG),JA)
    PDF  = wolfCrypt-JNI-JCE-Manual-jp.pdf
else
    PDF  = wolfCrypt-JNI-JCE-Manual.pdf
endif

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
