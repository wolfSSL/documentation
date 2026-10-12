Q?=@
ifeq ($(V),1)
  Q=
endif

# Handy debugging trick: `DOCKER_CMD_EXTRA_ARGS="--progress=plain" make` to see all the output
WOLFCOSE_REF ?= main
WOLFTPM_REF ?= master
DOCKER_CMD=DOCKER_BUILDKIT=1 docker build $(DOCKER_CMD_EXTRA_ARGS) -t doc_build --build-arg MANPATH=$(MANPATH) --build-arg PDFFILE=$(PDFFILE) --build-arg V=$(V) --build-arg WOLFCOSE_REF=$(WOLFCOSE_REF) --build-arg WOLFTPM_REF=$(WOLFTPM_REF) --target=manual --output=build -f Dockerfile .

all: wolfssl wolfssh wolfboot wolfclu wolfcrypt-jni wolfmqtt wolfsentry wolfssl-jni wolftpm wolfhsm wolfcose wolfengine wolfprovider fips-ready tuning porting faq fips-faq bc-migration

build:
	$(Q)mkdir -p build

.PHONY: wolfssl
wolfssl: MANPATH=wolfSSL
wolfssl: PDFFILE=wolfSSL-Manual.pdf
wolfssl: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfssh
wolfssh: MANPATH=wolfSSH
wolfssh: PDFFILE=wolfSSH-Manual.pdf
wolfssh: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfboot
wolfboot: MANPATH=wolfBoot
wolfboot: PDFFILE=wolfBoot-Manual.pdf
wolfboot: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfclu
wolfclu: MANPATH=wolfCLU
wolfclu: PDFFILE=wolfCLU-Manual.pdf
wolfclu: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfcrypt-jni
wolfcrypt-jni: MANPATH=wolfCrypt-JNI
wolfcrypt-jni: PDFFILE=wolfCrypt-JNI-JCE-Manual.pdf
wolfcrypt-jni: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfmqtt
wolfmqtt: MANPATH=wolfMQTT
wolfmqtt: PDFFILE=/wolfMQTT-Manual.pdf
wolfmqtt: build
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

.PHONY: wolftpm
# Resolve a mutable ref (e.g. master) to an immutable commit so the Docker
# build-arg cache key advances with upstream; a 40-char SHA passes through.
# override so a command-line WOLFTPM_REF=<branch> is still resolved to a commit.
wolftpm: override WOLFTPM_REF := $(shell r='$(WOLFTPM_REF)'; if printf '%s' "$$r" | grep -Eq '^[0-9a-f]{40}$$'; then printf '%s' "$$r"; else s=$$(git ls-remote https://github.com/wolfSSL/wolfTPM.git "$$r" 2>/dev/null | cut -f1); [ -n "$$s" ] && printf '%s' "$$s" || printf '%s' "$$r"; fi)
wolftpm: MANPATH=wolfTPM
wolftpm: PDFFILE=wolfTPM-Manual.pdf
wolftpm: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfhsm
wolfhsm: MANPATH=wolfHSM
wolfhsm: PDFFILE=wolfHSM-Manual.pdf
wolfhsm: build
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

.PHONY: wolfprovider
wolfprovider: MANPATH=wolfProvider
wolfprovider: PDFFILE=wolfProvider-Manual.pdf
wolfprovider: build
	$(Q)$(DOCKER_CMD)

.PHONY: porting
porting: MANPATH=wolfSSL-Porting
porting: PDFFILE=wolfSSL-Porting-Guide.pdf
porting: build
	$(Q)$(DOCKER_CMD)

.PHONY: fips-ready
fips-ready: MANPATH=wolfSSL-FIPS-Ready
fips-ready: PDFFILE=wolfSSL-FIPS-Ready.pdf
fips-ready: build
	$(Q)$(DOCKER_CMD)

.PHONY: tuning
tuning: MANPATH=wolfSSL-Tuning
tuning: PDFFILE=wolfSSL-Tuning-Guide.pdf
tuning: build
	@$(DOCKER_CMD)

.PHONY: faq
faq: MANPATH=wolfSSL-FAQ
faq: PDFFILE=wolfSSL-FAQ.pdf
faq: build
	@$(DOCKER_CMD)

.PHONY: fips-faq
fips-faq: MANPATH=wolfSSL-FIPS-FAQ
fips-faq: PDFFILE=wolfSSL-FIPS-FAQ.pdf
fips-faq: build
	@$(DOCKER_CMD)

.PHONY: bc-migration
bc-migration: MANPATH=BouncyCastle-Migration
bc-migration: PDFFILE=BouncyCastle-wolfSSL-Migration-Guide.pdf
bc-migration: build
	$(Q)$(DOCKER_CMD)

clean:
	$(Q)rm -rf build
