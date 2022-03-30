all: pdf html


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \

PDF = wolfsentry.pdf
HTML = html/

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-setup
html-setup: builddir $(SOURCES)
	@cp src/*.png build/html/
	@cp src/*.css build/html/
	@mv build/html/chapter01.md build/html/index.md
	-cd ../mkdocs-material; patch -p1 < ../Custom-wolfSSL-theme.patch --ignore-whitespace -N


html: html-setup
	@mkdir html
	@mkdocs build

.PHONY: serve
serve: html-setup
	@mkdocs serve

.PHONY: builddir
builddir:
	@mkdir -p build/pdf
	@mkdir -p build/html

.PHONY: docker
docker:
	@DOCKER_BUILDKIT=1 docker build --target=export-stage -t doc_build --output=build .

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Indent all headings by one #
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
# 5. Fix titles of the header files Markdown
# 6. Two regexes to handle bad Doxygen that didn't convert and the LaTeX processor thinks is LaTeX commands
.PHONY: pdf
pdf: builddir $(SOURCES)
	@cp src/*.png build/pdf/
	@cd build/pdf && pandoc \
		-N \
        -s \
        --metadata date="`date -I`" \
		--variable mainfont="Noto Sans" \
		--variable sansfont="Noto Sans" \
		--variable monofont="Noto Sans Mono" \
		--variable papersize=letter \
		--variable geometry="margin=2.5cm" \
		--variable version=2.0 \
		--variable colorlinks=true \
		../../header.txt $(SOURCES) \
		--pdf-engine=xelatex \
		--toc \
		-o ../../$(PDF)

# 1. mkdocs needs internal links prefixed with the source MD document, pandoc
# does not work this way.
# 2. mkdocs needs nested code blocks to not be nested (it figures that out)
%.md:
	@sed -e 's/chapter[0-9][0-9].md\|(appendix[0-9][0-9].md//g' src/$@ > build/pdf/$@
	@sed -e 's/    ```/```/g' src/$@ > build/html/$@

clean:
	rm -f $(PDF)
	rm -rf build
	rm -rf $(HTML)
