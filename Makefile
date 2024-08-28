Q?=@
ifeq ($(V),1)
  Q=
endif

# Handy debugging trick: `DOCKER_CMD_EXTRA_ARGS="--progress=plain" make` to see all the output
DOCKER_CMD=DOCKER_BUILDKIT=1 docker build $(DOCKER_CMD_EXTRA_ARGS) -t doc_build --build-arg MANPATH=$(MANPATH) --build-arg PDFFILE=$(PDFFILE) --build-arg V=$(V) --target=manual --output=build -f Dockerfile .

all: wolfssl wolfssh wolfboot wolfclu wolfcrypt-jni wolfmqtt wolfsentry wolfssl-jni wolftpm wolfhsm wolfengine wolfprovider fips-ready tuning porting faq

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
wolftpm: MANPATH=wolfTPM
wolftpm: PDFFILE=wolfTPM-Manual.pdf
wolftpm: build
	$(Q)$(DOCKER_CMD)

.PHONY: wolfhsm
wolfhsm: MANPATH=wolfHSM
wolfhsm: PDFFILE=wolfHSM-Manual.pdf
wolfhsm: build
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

clean:
	$(Q)rm -rf build
