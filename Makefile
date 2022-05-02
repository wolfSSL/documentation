DOCKER_CMD=DOCKER_BUILDKIT=1 docker build -t doc_build --output=build -f Dockerfile .

all: wolfssl wolfssh wolfboot wolfclu wolfcrypt-jni wolfmqtt wolfsentry wolfssl-jni wolftpm

build:
	@mkdir -p build

.PHONY: wolfssl
wolfssl: build
	@$(DOCKER_CMD) --target=wolfssl

.PHONY: wolfssh
wolfssh: build
	@$(DOCKER_CMD) --target=wolfssh

.PHONY: wolfboot
wolfboot: build
	@$(DOCKER_CMD) --target=wolfboot

.PHONY: wolfclu
wolfclu: build
	@$(DOCKER_CMD) --target=wolfclu

.PHONY: wolfcrypt-jni
wolfcrypt-jni: build
	@$(DOCKER_CMD) --target=wolfcrypt-jni

.PHONY: wolfmqtt
wolfmqtt: build
	@$(DOCKER_CMD) --target=wolfmqtt

.PHONY: wolfsentry
wolfsentry: build
	@$(DOCKER_CMD) --target=wolfsentry

.PHONY: wolfssl-jni
wolfssl: build
	@$(DOCKER_CMD) --target=wolfssl-jni

.PHONY: wolftpm
wolftpm: build
	@$(DOCKER_CMD) --target=wolftpm

clean:
	rm -rf build
