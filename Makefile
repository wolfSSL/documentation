Q?=@
ifeq ($(V),1)
  Q=
endif

# Handy debugging trick: `DOCKER_CMD_EXTRA_ARGS="--progress=plain" make` to see all the output
WOLFCOSE_REF ?= main
WOLFTPM_REF ?= master
# Output directory for the HTML manual inside build/, targets for a
# translated manual override it so it does not clash with the English one
HTMLDIR = $(MANPATH)-html
DOCKER_CMD=DOCKER_BUILDKIT=1 docker build $(DOCKER_CMD_EXTRA_ARGS) -t doc_build --build-arg MANPATH=$(MANPATH) --build-arg PDFFILE=$(PDFFILE) --build-arg HTMLDIR=$(HTMLDIR) --build-arg DOC_LANG=$(DOC_LANG) --build-arg V=$(V) --build-arg WOLFCOSE_REF=$(WOLFCOSE_REF) --build-arg WOLFTPM_REF=$(WOLFTPM_REF) --target=manual --output=build -f Dockerfile .

# Japanese (DOC_LANG=JA) manuals, built from each manual's src-ja
JA_MANUALS = wolfssl-ja wolfssh-ja wolfboot-ja wolfclu-ja wolfcrypt-jni-ja wolfmqtt-ja wolfssl-jni-ja wolftpm-ja wolfhsm-ja wolfengine-ja wolfprovider-ja porting-ja fips-ready-ja tuning-ja faq-ja fips-faq-ja mbedtls-migration-ja

all: wolfssl wolfssh wolfboot wolfclu wolfcrypt-jni wolfmqtt wolfsentry wolfssl-jni wolftpm wolfhsm wolfcose wolfengine wolfprovider fips-ready tuning porting faq fips-faq bc-migration mbedtls-migration $(JA_MANUALS)

build:
	$(Q)mkdir -p build

.PHONY: wolfssl
wolfssl: MANPATH=wolfSSL
wolfssl: PDFFILE=wolfSSL-Manual.pdf
wolfssl: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssl-ja
wolfssl-ja: MANPATH=wolfSSL
wolfssl-ja: PDFFILE=wolfSSL-Manual-jp.pdf
wolfssl-ja: HTMLDIR=wolfSSL-ja-html
wolfssl-ja: DOC_LANG=JA
wolfssl-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssh
wolfssh: MANPATH=wolfSSH
wolfssh: PDFFILE=wolfSSH-Manual.pdf
wolfssh: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssh-ja
wolfssh-ja: MANPATH=wolfSSH
wolfssh-ja: PDFFILE=wolfSSH-Manual-jp.pdf
wolfssh-ja: HTMLDIR=wolfSSH-ja-html
wolfssh-ja: DOC_LANG=JA
wolfssh-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfboot
wolfboot: MANPATH=wolfBoot
wolfboot: PDFFILE=wolfBoot-Manual.pdf
wolfboot: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfboot-ja
wolfboot-ja: MANPATH=wolfBoot
wolfboot-ja: PDFFILE=wolfBoot-Manual-jp.pdf
wolfboot-ja: HTMLDIR=wolfBoot-ja-html
wolfboot-ja: DOC_LANG=JA
wolfboot-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfclu
wolfclu: MANPATH=wolfCLU
wolfclu: PDFFILE=wolfCLU-Manual.pdf
wolfclu: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfclu-ja
wolfclu-ja: MANPATH=wolfCLU
wolfclu-ja: PDFFILE=wolfCLU-Manual-jp.pdf
wolfclu-ja: HTMLDIR=wolfCLU-ja-html
wolfclu-ja: DOC_LANG=JA
wolfclu-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfcrypt-jni
wolfcrypt-jni: MANPATH=wolfCrypt-JNI
wolfcrypt-jni: PDFFILE=wolfCrypt-JNI-JCE-Manual.pdf
wolfcrypt-jni: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfcrypt-jni-ja
wolfcrypt-jni-ja: MANPATH=wolfCrypt-JNI
wolfcrypt-jni-ja: PDFFILE=wolfCrypt-JNI-JCE-Manual-jp.pdf
wolfcrypt-jni-ja: HTMLDIR=wolfCrypt-JNI-ja-html
wolfcrypt-jni-ja: DOC_LANG=JA
wolfcrypt-jni-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfmqtt
wolfmqtt: MANPATH=wolfMQTT
wolfmqtt: PDFFILE=/wolfMQTT-Manual.pdf
wolfmqtt: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfmqtt-ja
wolfmqtt-ja: MANPATH=wolfMQTT
wolfmqtt-ja: PDFFILE=wolfMQTT-Manual-jp.pdf
wolfmqtt-ja: HTMLDIR=wolfMQTT-ja-html
wolfmqtt-ja: DOC_LANG=JA
wolfmqtt-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfsentry
wolfsentry: MANPATH=wolfSentry
wolfsentry: PDFFILE=wolfSentry-Manual.pdf
wolfsentry: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssl-jni
wolfssl-jni: MANPATH=wolfSSL-JNI
wolfssl-jni: PDFFILE=wolfSSL-JNI-JSSE-Manual.pdf
wolfssl-jni: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssl-jni-ja
wolfssl-jni-ja: MANPATH=wolfSSL-JNI
wolfssl-jni-ja: PDFFILE=wolfSSL-JNI-JSSE-Manual-jp.pdf
wolfssl-jni-ja: HTMLDIR=wolfSSL-JNI-ja-html
wolfssl-jni-ja: DOC_LANG=JA
wolfssl-jni-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolftpm
# Resolve a mutable ref (e.g. master) to an immutable commit so the Docker
# build-arg cache key advances with upstream; a 40-char SHA passes through.
# override so a command-line WOLFTPM_REF=<branch> is still resolved to a commit.
wolftpm wolftpm-ja: override WOLFTPM_REF := $(shell r='$(WOLFTPM_REF)'; if printf '%s' "$$r" | grep -Eq '^[0-9a-f]{40}$$'; then printf '%s' "$$r"; else s=$$(git ls-remote https://github.com/wolfSSL/wolfTPM.git "$$r" 2>/dev/null | cut -f1); [ -n "$$s" ] && printf '%s' "$$s" || printf '%s' "$$r"; fi)
wolftpm: MANPATH=wolfTPM
wolftpm: PDFFILE=wolfTPM-Manual.pdf
wolftpm: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolftpm-ja
wolftpm-ja: MANPATH=wolfTPM
wolftpm-ja: PDFFILE=wolfTPM-Manual-jp.pdf
wolftpm-ja: HTMLDIR=wolfTPM-ja-html
wolftpm-ja: DOC_LANG=JA
wolftpm-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfhsm
wolfhsm: MANPATH=wolfHSM
wolfhsm: PDFFILE=wolfHSM-Manual.pdf
wolfhsm: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfhsm-ja
wolfhsm-ja: MANPATH=wolfHSM
wolfhsm-ja: PDFFILE=wolfHSM-Manual-jp.pdf
wolfhsm-ja: HTMLDIR=wolfHSM-ja-html
wolfhsm-ja: DOC_LANG=JA
wolfhsm-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfcose
# Resolve a mutable ref (e.g. main) to an immutable commit so the Docker
# build-arg cache key advances with upstream; a 40-char SHA passes through.
wolfcose: WOLFCOSE_REF := $(shell r='$(WOLFCOSE_REF)'; if printf '%s' "$$r" | grep -Eq '^[0-9a-f]{40}$$'; then printf '%s' "$$r"; else s=$$(git ls-remote https://github.com/wolfSSL/wolfCOSE.git "$$r" 2>/dev/null | cut -f1); [ -n "$$s" ] && printf '%s' "$$s" || printf '%s' "$$r"; fi)
wolfcose: MANPATH=wolfCOSE
wolfcose: PDFFILE=wolfCOSE-Manual.pdf
wolfcose: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfengine
wolfengine: MANPATH=wolfEngine
wolfengine: PDFFILE=wolfEngine-Manual.pdf
wolfengine: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfengine-ja
wolfengine-ja: MANPATH=wolfEngine
wolfengine-ja: PDFFILE=wolfEngine-Manual-jp.pdf
wolfengine-ja: HTMLDIR=wolfEngine-ja-html
wolfengine-ja: DOC_LANG=JA
wolfengine-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfprovider
wolfprovider: MANPATH=wolfProvider
wolfprovider: PDFFILE=wolfProvider-Manual.pdf
wolfprovider: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfprovider-ja
wolfprovider-ja: MANPATH=wolfProvider
wolfprovider-ja: PDFFILE=wolfProvider-Manual-jp.pdf
wolfprovider-ja: HTMLDIR=wolfProvider-ja-html
wolfprovider-ja: DOC_LANG=JA
wolfprovider-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: porting
porting: MANPATH=wolfSSL-Porting
porting: PDFFILE=wolfSSL-Porting-Guide.pdf
porting: build
	$(Q)$(DOCKER_CMD)

.PHONY: porting-ja
porting-ja: MANPATH=wolfSSL-Porting
porting-ja: PDFFILE=wolfSSL-Porting-Guide-jp.pdf
porting-ja: HTMLDIR=wolfSSL-Porting-ja-html
porting-ja: DOC_LANG=JA
porting-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: fips-ready
fips-ready: MANPATH=wolfSSL-FIPS-Ready
fips-ready: PDFFILE=wolfSSL-FIPS-Ready.pdf
fips-ready: build
	$(Q)$(DOCKER_CMD)

.PHONY: fips-ready-ja
fips-ready-ja: MANPATH=wolfSSL-FIPS-Ready
fips-ready-ja: PDFFILE=wolfSSL-FIPS-Ready-jp.pdf
fips-ready-ja: HTMLDIR=wolfSSL-FIPS-Ready-ja-html
fips-ready-ja: DOC_LANG=JA
fips-ready-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: tuning
tuning: MANPATH=wolfSSL-Tuning
tuning: PDFFILE=wolfSSL-Tuning-Guide.pdf
tuning: build
	@$(DOCKER_CMD)

.PHONY: tuning-ja
tuning-ja: MANPATH=wolfSSL-Tuning
tuning-ja: PDFFILE=wolfSSL-Tuning-Guide-jp.pdf
tuning-ja: HTMLDIR=wolfSSL-Tuning-ja-html
tuning-ja: DOC_LANG=JA
tuning-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: faq
faq: MANPATH=wolfSSL-FAQ
faq: PDFFILE=wolfSSL-FAQ.pdf
faq: build
	@$(DOCKER_CMD)

.PHONY: faq-ja
faq-ja: MANPATH=wolfSSL-FAQ
faq-ja: PDFFILE=wolfSSL-FAQ-jp.pdf
faq-ja: HTMLDIR=wolfSSL-FAQ-ja-html
faq-ja: DOC_LANG=JA
faq-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: fips-faq
fips-faq: MANPATH=wolfSSL-FIPS-FAQ
fips-faq: PDFFILE=wolfSSL-FIPS-FAQ.pdf
fips-faq: build
	@$(DOCKER_CMD)

.PHONY: fips-faq-ja
fips-faq-ja: MANPATH=wolfSSL-FIPS-FAQ
fips-faq-ja: PDFFILE=wolfSSL-FIPS-FAQ-jp.pdf
fips-faq-ja: HTMLDIR=wolfSSL-FIPS-FAQ-ja-html
fips-faq-ja: DOC_LANG=JA
fips-faq-ja: build
	$(Q)$(DOCKER_CMD)

.PHONY: bc-migration
bc-migration: MANPATH=BouncyCastle-Migration
bc-migration: PDFFILE=BouncyCastle-wolfSSL-Migration-Guide.pdf
bc-migration: build
	$(Q)$(DOCKER_CMD)

.PHONY: mbedtls-migration
mbedtls-migration: MANPATH=MbedTLS-Migration
mbedtls-migration: PDFFILE=MbedTLS-wolfSSL-Migration-Guide.pdf
mbedtls-migration: build
	$(Q)$(DOCKER_CMD)

.PHONY: mbedtls-migration-ja
mbedtls-migration-ja: MANPATH=MbedTLS-Migration
mbedtls-migration-ja: PDFFILE=MbedTLS-wolfSSL-Migration-Guide-jp.pdf
mbedtls-migration-ja: HTMLDIR=MbedTLS-Migration-ja-html
mbedtls-migration-ja: DOC_LANG=JA
mbedtls-migration-ja: build
	$(Q)$(DOCKER_CMD)

clean:
	$(Q)rm -rf build
