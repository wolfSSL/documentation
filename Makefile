DOCKER_CMD=DOCKER_BUILDKIT=1 docker build -t doc_build --build-arg MANPATH=$(MANPATH) --build-arg PDFFILE=$(PDFFILE) --target=manual --output=build -f Dockerfile .

all: wolfssl wolfssh wolfboot wolfclu wolfcrypt-jni wolfmqtt wolfsentry wolfssl-jni wolftpm

build:
	@mkdir -p build

.PHONY: wolfssl
wolfssl: MANPATH=wolfSSL
wolfssl: PDFFILE=wolfSSL-Manual.pdf
wolfssl: build
	@$(DOCKER_CMD)

.PHONY: wolfssh
wolfssh: MANPATH=wolfSSH
wolfssh: PDFFILE=wolfSSH-Manual.pdf
wolfssh: build
	@$(DOCKER_CMD)

.PHONY: wolfboot
wolfboot: MANPATH=wolfBoot
wolfboot: PDFFILE=wolfBoot-Manual.pdf
wolfboot: build
	@$(DOCKER_CMD)

.PHONY: wolfclu
wolfclu: MANPATH=wolfCLU
wolfclu: PDFFILE=wolfCLU-Manual.pdf
wolfclu: build
	@$(DOCKER_CMD)

.PHONY: wolfcrypt-jni
wolfcrypt-jni: MANPATH=wolfCrypt-JNI
wolfcrypt-jni: PDFFILE=wolfCrypt-JNI-JCE-Manual.pdf
wolfcrypt-jni: build
	@$(DOCKER_CMD)

.PHONY: wolfmqtt
wolfmqtt: MANPATH=wolfMQTT
wolfmqtt: PDFFILE=/wolfMQTT-Manual.pdf
wolfmqtt: build
	@$(DOCKER_CMD)

.PHONY: wolfsentry
wolfsentry: MANPATH=wolfSentry
wolfsentry: PDFFILE=wolfSentry-Manual.pdf
wolfsentry: build
	@$(DOCKER_CMD)

.PHONY: wolfssl-jni
wolfssl-jni: MANPATH=wolfSSL-JNI
wolfssl-jni: PDFFILE=wolfSSL-JNI-JSSE-Manual.pdf
wolfssl-jni: build
	@$(DOCKER_CMD)

.PHONY: wolftpm
wolftpm: MANPATH=wolfTPM
wolftpm: PDFFILE=wolfTPM-Manual.pdf
wolftpm: build
	@$(DOCKER_CMD)

clean:
	rm -rf build
