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
APPENDIX= appendix01.md

ifeq ($(DOC_LANG),JA)
	DOXY = Doxyfile-ja
	PDF  = wolfHSM-Manual-jp.pdf
else
	DOXY = Doxyfile
	PDF  = wolfHSM-Manual.pdf
endif


wolfhsm:
	$(Q)git clone --depth 1 https://github.com/wolfSSL/wolfHSM wolfhsm


.PHONY: wolfhsm-update
wolfhsm-update: wolfhsm
	$(Q)cd wolfhsm && git pull --ff-only

.PHONY: api
api: wolfhsm-update
	$(Q)mkdir -p api/md
	$(Q)cd wolfhsm && doxygen ../Doxyfile
	$(Q)cd ..
	$(Q)doxybook2 --input docs/xml --output api/md --config doxybook.cfg

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api
	$(Q)cp src/*.png build/html/
	$(Q)cp -a api/md/*8h* build/html/

	$(Q)perl -i -pe "s/\/group_/group_/g" build/html/group* build/html/*8h*
	$(Q)perl -i -pe "s/\/tpm2_/tpm2_/g" build/html/group* build/html/*8h*
	$(Q)perl -i -pe "s/dox_comments\/header_files\///" build/html/*8h*

	$(Q)cp src/appendix01.md build/html/appendix01.md

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
	$(Q)cp src/*.png build/pdf/
	$(Q)cp -a api/md/*8h* build/pdf/

	$(Q)perl -i -pe "s/# /## /g" build/pdf/*.md
	$(Q)perl -i -pe "s/(\/group_.*|Classes\/struct.*|\/.*8h)\.md//g" build/pdf/*.md
	$(Q)perl -i -pe "s/^-(-)+$$//" build/pdf/*.md
	$(Q)perl -i -pe "s/^title:.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/^Updated on.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/^summary.*//" build/pdf/*.md
	$(Q)perl -i -pe "s/dox_comments\/header_files\///" build/pdf/*.md
	$(Q)perl -i -pe "s/^\\\\//" build/pdf/*.md
	$(Q)perl -i -pe "s/\\\\par/par/g" build/pdf/*.md
	$(Q)perl -i -pe "s/\[(.*?)\]\(Classes\/.*?.md\)/\[\1\]\(#typedef-\1\)/g" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md
	$(Q)perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/*.md

	$(Q)cp src/appendix01.md build/pdf/appendix01.md
