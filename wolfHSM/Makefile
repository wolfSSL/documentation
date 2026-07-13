-include ../common/common.am

ifeq ($(DOC_LANG),JA)
    SRC = wolfhsm/docs/src-ja
else
    SRC = wolfhsm/docs/src
endif

.DEFAULT_GOAL := all

all: pdf html


ifeq ($(DOC_LANG),JA)
    SOURCES = chapter01.md \
        chapter02.md \
        chapter03.md \
        chapter04.md \
        chapter05.md \
        chapter06.md \
        chapter07.md \
        chapter08.md
    APPENDIX = appendix01.md
    HOMEPAGE = chapter01.md
    LINK_STRIP = chapter[0-9][0-9].md|appendix[0-9][0-9].md
else
    SOURCES = 1-Overview.md \
        2-FAQs.md \
        3-Quickstart.md \
        4-Architecture.md \
        5-Features.md \
        6-Utilities.md \
        7-Examples.md \
        8-Integration.md \
        9-Configuration.md
    APPENDIX = 10-API-docs-client.md \
        11-API-docs-server.md
    HOMEPAGE = 0-Index.md
    LINK_STRIP = [0-9]+-[A-Za-z0-9-]+\.md
endif

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
	$(Q)if [ -L wolfhsm ]; then \
		echo "Skipping git pull for symlink (local testing)"; \
	else \
		cd wolfhsm && git pull --ff-only; \
	fi

.PHONY: api
api: wolfhsm-update
	$(Q)mkdir -p api/md
	$(Q)cd wolfhsm && doxygen ../Doxyfile
	$(Q)cd ..
	$(Q)doxybook2 --input docs/xml --output api/md --config doxybook.cfg

# NOTE: html-setup and pdf-setup are overridden from common/common.am to inject
# the wolfhsm-update dependency. If common.am changes these targets, the changes
# will need to be manually synchronized here. This duplication is intentional to
# ensure the wolfHSM repo is cloned before attempting to copy docs from it.

# Override html-setup to ensure wolfhsm repo is cloned first
.PHONY: html-setup
html-setup: wolfhsm-update
	$(Q)git submodule update --init
	-cd ../mkdocs-material; patch -p1 < $(PATCH) --ignore-whitespace -N
	$(Q)cp -a $(SRC)/* build/html/
	$(Q)cp ../common/*.png build/html/
	$(Q)cp ../common/*.css build/html/
	$(Q)perl -i -pe 's/    ```/```/g' build/html/*.md
	$(Q)perl -i -pe "s/\#--/\#-/g" build/html/*.md
	$(Q)mv build/html/$(HOMEPAGE) build/html/index.md

# Override pdf-setup to ensure wolfhsm repo is cloned first
.PHONY: pdf-setup
pdf-setup: wolfhsm-update builddir
	$(Q)cp -a $(SRC)/* build/pdf/
	$(Q)cp ../common/*.png build/pdf/
	$(Q)perl -i -pe "s/$(LINK_STRIP)//g" build/pdf/*.md
	$(Q)perl -i -pe "s/\#--/\#/g" build/pdf/*.md

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api
	$(Q)cp -a api/md/*8h* build/html/
	$(Q)cp -a api/md/Classes build/html/
	$(Q)perl -i -pe 's#\]\(/Classes/#](#g' build/html/Classes/*.md
	$(Q)perl -i -pe "s/Classes\///g" build/html/Classes/*.md
	$(Q)perl -i -pe 's#\]\(/#](../#g' build/html/Classes/*.md
	$(Q)perl -i -pe 's#\]\(/#](#g' build/html/*8h*
	$(Q)perl -i -pe "s/(\]\([^)#]*#[a-z]+-)([^)]+?)(\))/\$$1.(\$$2=~tr#-#_#r).\$$3/ge" build/html/*8h* build/html/Classes/*.md

	$(Q)perl -i -pe "s/\/group_/group_/g" build/html/group* build/html/*8h*
	$(Q)perl -i -pe "s/dox_comments\/header_files\///" build/html/*8h*
	$(Q)perl -i -pe "s/\[([^\]]+)\]\(Classes\/[^)]+\.md\)/\1/g" build/html/*8h*

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Demote the auto-generated API h-file headings by one # (only wh__*_8h.md)
#    so they nest as subsections under their parent appendix chapter. Don't
#    demote chapter source files — pandoc -N needs their H1 → \section for
#    proper "1.", "2.", ... numbering (and "A.", "B.", ... after \appendix);
#    if everything is demoted to ##, every chapter renders as "0.N" and the
#    appendix as ".N".
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
# 5. Fix titles of the header files Markdown
# 6. Two regexes to handle bad Doxygen that didn't convert and the LaTeX processor thinks is LaTeX commands
.PHONY: pdf-prep
pdf-prep: api
	$(Q)cp -a api/md/*8h* build/pdf/

	$(Q)perl -i -pe "s/# /## /g" build/pdf/wh__*_8h.md
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
	$(Q)perl -i -pe "s/\[([^\]]+)\]\((?:\.\.\/)*wolfhsm\/wh_[a-z_]+\.h\)/\1/g" build/pdf/*.md
	$(Q)perl -i -pe "s/\[([^\]]+)\]\(wh__[a-z_0-9]+\.md\)/\1/g" build/pdf/*.md
	$(Q)if [ "$(DOC_LANG)" = "JA" ]; then \
		cat build/pdf/wh__client_8h.md build/pdf/wh__client__crypto_8h.md build/pdf/wh__client__she_8h.md build/pdf/wh__server_8h.md build/pdf/wh__server__keystore_8h.md build/pdf/wh__server__img__mgr_8h.md build/pdf/wh__server__cert_8h.md build/pdf/wh__server__cert__cache_8h.md >> build/pdf/appendix01.md; \
	else \
		cat build/pdf/wh__client_8h.md build/pdf/wh__client__crypto_8h.md build/pdf/wh__client__she_8h.md >> build/pdf/10-API-docs-client.md; \
		cat build/pdf/wh__server_8h.md build/pdf/wh__server__keystore_8h.md build/pdf/wh__server__img__mgr_8h.md build/pdf/wh__server__cert_8h.md build/pdf/wh__server__cert__cache_8h.md >> build/pdf/11-API-docs-server.md; \
	fi
