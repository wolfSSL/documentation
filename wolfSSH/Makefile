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

PDF = wolfSSH-Manual.pdf
HTML = html/

.PHONY: html-setup
html-setup: builddir 
	@cp src/* build/html/
	@mv build/html/chapter01.md build/html/index.md

html: html-setup
	@mkdir -p html
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

.PHONY: pdf
pdf: builddir 
	@cp src/* build/pdf/
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

clean:
	rm -f $(PDF)
	rm -rf build $(HTML)
