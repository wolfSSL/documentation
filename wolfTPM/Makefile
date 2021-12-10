all: pdf


SOURCES = chapter01.md \
		  chapter02.md \
		  chapter03.md \
		  chapter04.md \
          chapter05.md \
          chapter06.md 

PDF = wolfTPM-Manual.pdf

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

.PHONY: pdf
pdf: api 
	@perl -i -pe "s/# /## /g" api/md/*.md                                 
	@perl -i -pe "s/(\/group_.*|Classes\/struct.*|\/.*8h)\.md//g" api/md/*.md
	@perl -i -pe "s/^-(-)+$$//" api/md/*.md 
	@perl -i -pe "s/^title:.*//" api/md/*.md 
	@perl -i -pe "s/^Updated on.*//" api/md/*.md
	@perl -i -pe "s/^summary.*//" api/md/*.md  
	@perl -i -pe "s/dox_comments\/header_files\///" api/md/*.md 
	@perl -i -pe "s/^\\\\//" api/md/*.md 
	@perl -i -pe "s/\\\\par/par/g" api/md/*.md 
	@perl -i -pe "s/(?<=md\#function\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@perl -i -pe "s/(?<=md\#typedef\-)(.*)(?=\))/\$$1=~s#-#_#gr/ge" api/md/*.md
	@rm -rf src/chapter05.md
	@echo '# API Reference' >> src/chapter05.md
	@cat api/md/group__TPM2__Proprietary.md api/md/tpm2_8h.md api/md/tpm2__wrap_8h.md	api/md/group__wolfTPM2__Wrappers.md >> src/chapter05.md
	@cd src/ && pandoc \
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
		../header.txt $(SOURCES) \
		--pdf-engine=xelatex \
		--toc \
		-o ../$(PDF)

clean:
	rm -f $(PDF)
	rm -rf wolftpm api
