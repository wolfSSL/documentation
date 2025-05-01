-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = Intro.md \
		  build.md \
		  command_list.md \
		  bench.md \
		  ca.md \
          crl.md \
		  dsaparam.md \
          dgst.md \
		  dhparam.md \
          ecparam.md \
          enc.md \
		  genkey.md \
		  hash.md \
		  md5.md \
		  pkcs12.md \
		  pkcs7.md \
		  pkcs8.md \
		  pkey.md \
		  rand.md \
		  req.md \
		  rsa.md \
		  sha.md \
		  s_client.md \
		  verify.md \
		  x509.md \
		  base64.md

ifeq ($(DOC_LANG),JA)
    PDF  = wolfCLU-Manual-jp.pdf
else
    PDF  = wolfCLU-Manual.pdf
endif

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
