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
		  chapter18.md \
		  chapter19.md
APPENDIX= appendix01.md \
		  appendix02.md \
		  appendix03.md \
		  appendix04.md

PDF = wolfssl.pdf
HTML = html/

wolfssl:
	@git clone --depth 1 https://github.com/wolfSSL/wolfssl

.PHONY: wolfssl-update
wolfssl-update: wolfssl
	@cd wolfssl && git pull --ff-only

.PHONY: api
api: wolfssl-update
	@mkdir -p api/md
	@cp Doxyfile wolfssl/doc
	@cd wolfssl/doc && doxygen Doxyfile
	@PATH=${DOXYBOOK_PATH}:${PATH} doxybook2 --input wolfssl/doc/xml --output api/md --config doxybook.cfg

# Need an index.md, so let's make it chapter01.
# Perl regex to fix two things:
# 1. Doxybook2 replaces underscores with dashes in anchor tags (which breaks them)
# 2. Remove leading slash on links so that mkdocs can parse them
# 3. Fix the titles of the header files markdown
.PHONY: html-setup
html-setup: api builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/html/
	@cp src/*.css build/html/
	@cp -a api/md/group* build/html/
	@cp -a api/md/*8h* build/html/
	@rm -f build/html/chapter17.md build/html/chapter18.md build/html/chapter19.md
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/html/group* build/html/*8h*
	@perl -i -pe "s/\/group_/group_/g" build/html/group* build/html/*8h*
	@perl -i -pe "s/dox_comments\/header_files\///" build/html/*8h*
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

# Set input format to gfm to fix issues with converted API docs
# Regexes:
# 1. Indent all headings by one #
# 2. Fix broken anchors from Doxybook2
# 3. Remove file references from links
# 4. Three regexes to remove metadata which outputs in the PDF text
# 5. Fix titles of the header files Markdown
# 6. Two regexes to handle bad Doxygen that didn't convert and the LaTeX processor thinks is LaTeX commands
.PHONY: pdf
pdf: api builddir $(SOURCES) $(APPENDIX)
	@cp src/*.png build/pdf/
	@cp -a api/md/group* build/pdf/
	@cp -a api/md/*8h* build/pdf/
	@perl -i -pe "s/^(#+ )/#\$$1/g" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/\/group_.*\.md//g" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/^-(-)+$$//" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/^title:.*//" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/^Updated on.*//" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/dox_comments\/header_files\///" build/pdf/*8h*
	@perl -i -pe "s/^\\\\//" build/pdf/group* build/pdf/*8h*
	@perl -i -pe "s/\\\\par/par/g" build/pdf/group* build/pdf/*8h*
	@cat build/pdf/group__CertManager.md build/pdf/group__Memory.md build/pdf/group__openSSL.md build/pdf/group__CertsKeys.md build/pdf/group__IO.md build/pdf/group__Setup.md build/pdf/group__Debug.md build/pdf/group__TLS.md >> build/pdf/chapter17.md
	@cat build/pdf/group__ASN.md build/pdf/group__Base__Encoding.md build/pdf/group__Compression.md build/pdf/group__Error.md build/pdf/group__IoTSafe.md build/pdf/group__Keys.md build/pdf/group__Logging.md build/pdf/group__Math.md build/pdf/group__Random.md build/pdf/group__Signature.md build/pdf/group__wolfCrypt.md build/pdf/group__DES.md build/pdf/group__AES.md build/pdf/group__ARC4.md build/pdf/group__BLAKE2.md build/pdf/group__Camellia.md build/pdf/group__ChaCha.md build/pdf/group__ChaCha20Poly1305.md build/pdf/group__Crypto.md build/pdf/group__Curve25519.md build/pdf/group__Curve448.md build/pdf/group__DSA.md build/pdf/group__Diffie-Hellman.md build/pdf/group__ECC.md build/pdf/group__ED25519.md build/pdf/group__ED448.md >> build/pdf/chapter18.md
	@cat build/pdf/aes_8h.md build/pdf/arc4_8h.md build/pdf/asn_8h.md build/pdf/asn__public_8h.md build/pdf/blake2_8h.md build/pdf/bn_8h.md build/pdf/camellia_8h.md build/pdf/chacha20__poly1305_8h.md build/pdf/chacha_8h.md build/pdf/coding_8h.md build/pdf/compress_8h.md build/pdf/cryptocb_8h.md build/pdf/curve25519_8h.md build/pdf/curve448_8h.md build/pdf/des3_8h.md build/pdf/dh_8h.md build/pdf/doxygen__groups_8h.md build/pdf/doxygen__pages_8h.md build/pdf/dsa_8h.md build/pdf/ecc_8h.md build/pdf/eccsi_8h.md build/pdf/ed25519_8h.md build/pdf/ed448_8h.md build/pdf/error-crypt_8h.md build/pdf/evp_8h.md build/pdf/hash_8h.md build/pdf/hc128_8h.md build/pdf/hmac_8h.md build/pdf/idea_8h.md build/pdf/iotsafe_8h.md build/pdf/logging_8h.md build/pdf/md2_8h.md build/pdf/md4_8h.md build/pdf/md5_8h.md build/pdf/memory_8h.md build/pdf/pem_8h.md build/pdf/pkcs11_8h.md build/pdf/pkcs7_8h.md build/pdf/poly1305_8h.md build/pdf/pwdbased_8h.md build/pdf/rabbit_8h.md build/pdf/random_8h.md build/pdf/ripemd_8h.md build/pdf/rsa_8h.md build/pdf/sakke_8h.md build/pdf/sha256_8h.md build/pdf/sha512_8h.md build/pdf/sha_8h.md build/pdf/signature_8h.md build/pdf/srp_8h.md build/pdf/ssl_8h.md build/pdf/tfm_8h.md build/pdf/types_8h.md build/pdf/wc__encrypt_8h.md build/pdf/wc__port_8h.md build/pdf/wolfio_8h.md >> build/pdf/chapter19.md
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
	rm -rf api
	rm -rf wolfssl
