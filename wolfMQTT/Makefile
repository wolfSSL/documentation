-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \
		  chapter04.md \
          chapter05.md 


ifeq ($(DOC_LANG),JA)
    DOXY = Doxyfile-ja
    PDF  = wolfMQTT-Manual-jp.pdf
else
    DOXY = Doxyfile
    PDF  = wolfMQTT-Manual.pdf
endif

wolfmqtt:
	@git clone --depth 1 https://github.com/wolfSSL/wolfmqtt


.PHONY: wolfmqtt-update
wolfmqtt-update: wolfmqtt
	@cd wolfmqtt && git pull --ff-only

.PHONY: api
api: wolfmqtt-update
	@mkdir -p api/md
	@doxygen $(DOXY)
	@PATH=${DOXYBOOK_PATH}:${PATH} doxybook2 --input wolfmqtt/wolfmqtt/xml --output api/md --config doxybook.cfg

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-prep
html-prep: api
	@cp -a api/md/*8h* build/html/
	@rm -rf build/html/chapter05.md	
	@perl -i -pe "s/Classes\///g" build/html/*8h* 
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge"   build/html/*8h*
	@perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge"   build/html/*8h*
	@perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge"   build/html/*8h*	
	@perl -i -pe "s/\\\\discussion//g" build/html/*8h*	
	@perl -i -pe "s/\/mqtt_/mqtt_/g" build/html/*8h*    
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
	@perl -i -pe "s/\\\\discussion//g" api/md/*.md	
	@perl -i -pe "s/\[(.*?)\]\(Classes\/.*?.md\)/\[\1\]\(#typedef-\1\)/g" api/md/*.md
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@perl -i -pe "s/(?<=md\#enum\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md 	
	@rm -rf build/pdf/chapter05.md
	@echo '# API Reference' >> build/pdf/chapter05.md
	@cat api/md/mqtt__client_8h.md api/md/mqtt__socket_8h.md api/md/mqtt__socket_8h.md	api/md/mqtt__types_8h.md >> build/pdf/chapter05.md
