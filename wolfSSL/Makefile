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

api:
	@mkdir -p api/md
	@git clone https://github.com/wolfSSL/wolfssl api/wolfssl
	@cp Doxyfile api/wolfssl/doc
	@cd api/wolfssl/doc && doxygen Doxyfile
	@doxybook2 --input api/wolfssl/doc/xml --output api/md --config doxybook.cfg

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
html: api builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/html/
	@cp src/*.css build/html/
	@cp -a api/md/group* build/html/
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group*
	@perl -i -pe "s/\/group_/group_/g" build/html/group*
	@mv build/html/chapter01.md build/html/index.md
	@mkdir html
	@mkdocs build

serve: api builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/html/
	@cp src/*.css build/html/
	@cp -a api/md/group* build/html/
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group*
	@perl -i -pe "s/\/group_/group_/g" build/html/group*
	@mv build/html/chapter01.md build/html/index.md
	@mkdocs serve

builddir:
	@mkdir -p build/pdf
	@mkdir -p build/html

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Indent all headings by one #
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
pdf: api builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/pdf/
	@cp -a api/md/group* build/pdf/
	@perl -i -pe "s/^(#+ )/#\$$1/g" build/pdf/group*
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/group*
	@perl -i -pe "s/\/group_.*\.md//g" build/pdf/group*
	@perl -i -pe "s/^-(-)+$$//" build/pdf/group*
	@perl -i -pe "s/^title:.*//" build/pdf/group*
	@perl -i -pe "s/^Updated on.*//" build/pdf/group*
	@cat build/pdf/group__CertManager.md build/pdf/group__Memory.md build/pdf/group__openSSL.md build/pdf/group__CertsKeys.md build/pdf/group__IO.md build/pdf/group__Setup.md build/pdf/group__Debug.md build/pdf/group__TLS.md >> build/pdf/chapter17.md
	@cat build/pdf/group__ASN.md build/pdf/group__Base__Encoding.md build/pdf/group__Compression.md build/pdf/group__Error.md build/pdf/group__IoTSafe.md build/pdf/group__Keys.md build/pdf/group__Logging.md build/pdf/group__Math.md build/pdf/group__Random.md build/pdf/group__Signature.md build/pdf/group__wolfCrypt.md build/pdf/group__DES.md build/pdf/group__AES.md build/pdf/group__ARC4.md build/pdf/group__BLAKE2.md build/pdf/group__Camellia.md build/pdf/group__ChaCha.md build/pdf/group__ChaCha20Poly1305.md build/pdf/group__Crypto.md build/pdf/group__Curve25519.md build/pdf/group__Curve448.md build/pdf/group__DSA.md build/pdf/group__Diffie-Hellman.md build/pdf/group__ECC.md build/pdf/group__ED25519.md build/pdf/group__ED448.md >> build/pdf/chapter18.md
	@cd build/pdf && pandoc \
		-N \
        -s \
		-f gfm \
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
