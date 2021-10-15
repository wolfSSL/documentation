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
		  chapter14.md \
		  chapter15.md \
		  chapter16.md \
		  chapter17.md \
		  chapter18.md
APPENDIX= appendix01.md \
		  appendix02.md \
		  appendix03.md

PDF = wolfssl.pdf
HTML = html/

# Need an index.md, so let's make it chapter01.
html: builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/html/
	@mv build/html/chapter01.md build/html/index.md
	@mkdir html
	@mkdocs build

serve: builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/html/
	@mv build/html/chapter01.md build/html/index.md
	@mkdocs serve

builddir:
	@mkdir -p build/pdf
	@mkdir -p build/html

pdf: builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/pdf/
	@cd build/pdf && pandoc \
		-N \
		--metadata date="`date -I`" \
		--variable mainfont="Noto Sans" \
		--variable sansfont="Noto Sans" \
		--variable monofont="Noto Sans Mono" \
		--variable papersize=letter \
		--variable geometry="margin=2.5cm" \
		--variable version=2.0 \
		--variable colorlinks=true \
		../../header.txt $(SOURCES) ../../appendix_head.txt $(APPENDIX) \
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
