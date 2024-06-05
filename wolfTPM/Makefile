-include ../common/common.am
.DEFAULT_GOAL := all

all: pdf html


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \
		  chapter04.md \
          chapter05.md \
          chapter06.md

ifeq ($(DOC_LANG),JA)
    DOXY = Doxyfile-ja
    PDF  = wolfTPM-Manual-jp.pdf
else
    DOXY = Doxyfile
    PDF  = wolfTPM-Manual.pdf
endif


wolftpm:
	@git clone --depth 1 https://github.com/wolfSSL/wolftpm


.PHONY: wolftpm-update
wolftpm-update: wolftpm
	@cd wolftpm && git pull --ff-only

.PHONY: api
api: wolftpm-update
	@mkdir -p api/md
	@cp Doxyfile wolftpm/docs
	@cd wolftpm && doxygen docs/Doxyfile
	@cd ..
	@PATH=${DOXYBOOK_PATH}:${PATH} doxybook2 --input wolftpm/docs/xml --output api/md --config doxybook.cfg

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api
  ifeq ($(DOC_LANG),JA)
	@cp -a header-ja/group* build/html/
	@cp -a header-ja/*8h* build/html/
  else
	@cp -a api/md/group* build/html/
	@cp -a api/md/*8h* build/html/
  endif

	@rm -rf build/html/chapter05.md
	@perl -i -pe "s/\[(.*?)\]\(Classes\/.*?.md\)/\[\1\]\(#typedef-\1\)/g" build/html/group* build/html/*8h*
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group* build/html/*8h*
	@perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group* build/html/*8h*
	@perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group* build/html/*8h*
	@perl -i -pe "s/\/group_/group_/g" build/html/group* build/html/*8h*
	@perl -i -pe "s/\/tpm2_/tpm2_/g" build/html/group* build/html/*8h*
	@perl -i -pe "s/dox_comments\/header_files\///" build/html/*8h*

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Indent all headings by one #
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
# 5. Fix titles of the header files Markdown
# 6. Two regexes to handle bad Doxygen that didn't convert and the LaTeX processor thinks is LaTeX commands
.PHONY: pdf-prep
pdf-prep: api
	@perl -i -pe "s/# /## /g" api/md/*.md
	@perl -i -pe "s/(\/group_.*|Classes\/struct.*|\/.*8h)\.md//g" api/md/*.md
	@perl -i -pe "s/^-(-)+$$//" api/md/*.md
	@perl -i -pe "s/^title:.*//" api/md/*.md
	@perl -i -pe "s/^Updated on.*//" api/md/*.md
	@perl -i -pe "s/^summary.*//" api/md/*.md
	@perl -i -pe "s/dox_comments\/header_files\///" api/md/*.md
	@perl -i -pe "s/^\\\\//" api/md/*.md
	@perl -i -pe "s/\\\\par/par/g" api/md/*.md
	@perl -i -pe "s/\[(.*?)\]\(Classes\/.*?.md\)/\[\1\]\(#typedef-\1\)/g" api/md/*.md
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@rm -rf build/pdf/chapter05.md
	@echo '# API Reference' >> build/pdf/chapter05.md
  ifeq ($(DOC_LANG),JA)
	@cat header-ja/group__TPM2__Proprietary.md header-ja/tpm2_8h.md header-ja/tpm2__wrap_8h.md header-ja/group__wolfTPM2__Wrappers.md >> build/pdf/chapter05.md
  else
	@cat api/md/group__TPM2__Proprietary.md api/md/tpm2_8h.md api/md/tpm2__wrap_8h.md api/md/tpm__io_8h.md api/md/group__wolfTPM2__Wrappers.md >> build/pdf/chapter05.md
  endif