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
          chapter10.md \
          chapter11.md \
          chapter12.md \
          chapter13.md \
          chapter14.md 

ifeq ($(DOC_LANG),JA)
    PDF  = wolfSSH-Manual-jp.pdf
else
    PDF  = wolfSSH-Manual.pdf
endif

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
