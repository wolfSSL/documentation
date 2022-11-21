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

ifeq ($(DOC_LANG),JA)
PDF  = wolfBoot-Manual-jp.pdf
SRC  = src-ja
MKDOC= mkdocs-ja.yml
else
PDF  = wolfBoot-Manual.pdf
SRC  = src
MKDOC= mkdocs.yml
endif

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
