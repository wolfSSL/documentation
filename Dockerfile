FROM texlive/texlive:latest AS builder

WORKDIR /deps

RUN apt-get -y update
# Pandoc and mkdocs are the tools we use
# Doxygen to convert the Doxygen docs
# build-essential and cmake to build the dependencies
# libfmt-dev nlohmann-json3-dev libspdlog-dev and libcxxopts-dev are needed by Doxybook2
# fonts-noto is needed by our PDF generator
RUN apt-get -y install pandoc mkdocs doxygen git build-essential cmake libfmt-dev nlohmann-json3-dev libspdlog-dev libcxxopts-dev fonts-noto

# Inja is a dep for Doxybook2
RUN git clone --depth=1 https://github.com/pantor/inja
RUN cd inja && cmake . -DBUILD_TESTING=OFF -DBUILD_BENCHMARK=OFF && make install

RUN git clone --depth=1 https://github.com/matusnovak/doxybook2
RUN cd doxybook2 && cmake . && make install
# Copy the source files into Docker, this and any subsequent steps won't be cached
WORKDIR /src/wolfssl
COPY . .

# Get the wolfSSL Doxygen
FROM builder as wolfssl-stage1
WORKDIR /src/wolfssl/wolfSSL
# Cache getting wolfSSL source for Doxygen docs
RUN git clone --depth 1 https://github.com/wolfSSL/wolfssl

# Build wolfSSL PDF
FROM wolfssl-stage1 AS wolfssl-stage2
WORKDIR /src/wolfssl/wolfSSL
RUN make pdf

# Build wolfSSL HTML
FROM wolfssl-stage1 AS wolfssl-stage3
WORKDIR /src/wolfssl/wolfSSL
RUN make html

# Build both wolfSSL HTML and PDF
FROM scratch AS wolfssl
COPY --from=wolfssl-stage2 /src/wolfssl/wolfSSL/wolfssl.pdf wolfssl.pdf
COPY --from=wolfssl-stage3 /src/wolfssl/wolfSSL/html wolfssl-html

# Build wolfSSH PDF
FROM builder AS wolfssh-stage1
WORKDIR /src/wolfssl/wolfSSH
RUN make pdf

# Build wolfSSH HTML
FROM builder AS wolfssh-stage2
WORKDIR /src/wolfssl/wolfSSH
RUN make html

# Build wolfSSH HTML and PDF
FROM scratch AS wolfssh
COPY --from=wolfssh-stage1 /src/wolfssl/wolfSSH/wolfSSH-Manual.pdf wolfssh.pdf
COPY --from=wolfssh-stage2 /src/wolfssl/wolfSSH/html wolfssh-html

# Build wolfBoot PDF
FROM builder AS wolfboot-stage1
WORKDIR /src/wolfssl/wolfBoot
RUN make pdf

# Build wolfBoot HTML
FROM builder AS wolfboot-stage2
WORKDIR /src/wolfssl/wolfBoot
RUN make html

# Build wolfBoot HTML and PDF
FROM scratch AS wolfboot
COPY --from=wolfboot-stage1 /src/wolfssl/wolfBoot/wolfBoot-Manual.pdf wolfboot.pdf
COPY --from=wolfboot-stage2 /src/wolfssl/wolfBoot/html wolfboot-html

# Build wolfCLU PDF
FROM builder AS wolfclu-stage1
WORKDIR /src/wolfssl/wolfCLU
RUN ./create-pdf.sh

FROM scratch AS wolfclu
COPY --from=wolfclu-stage1 /src/wolfssl/wolfCLU/wolfCLU_Manual.pdf wolfclu.pdf

# Build wolfCrypt JNI PDF
FROM builder AS wolfcrypt-jni-stage1
WORKDIR /src/wolfssl/wolfCrypt-JNI
RUN make pdf

# Build wolfCrypt JNI HTML
FROM builder AS wolfcrypt-jni-stage2
WORKDIR /src/wolfssl/wolfCrypt-JNI
RUN make html

# Build wolfCrypt JNI HTML and PDF
FROM scratch AS wolfcrypt-jni
COPY --from=wolfcrypt-jni-stage1 /src/wolfssl/wolfCrypt-JNI/wolfCrypt-JNI-JCE-Manual.pdf wolfcryp-jni.pdf
COPY --from=wolfcrypt-jni-stage2 /src/wolfssl/wolfCrypt-JNI/html wolfcrypt-jni-html

# Build wolfMQTT PDF
FROM builder AS wolfmqtt-stage1
WORKDIR /src/wolfssl/wolfMQTT
RUN make pdf

# Build wolfMQTT HTML
FROM builder AS wolfmqtt-stage2
WORKDIR /src/wolfssl/wolfMQTT
RUN make html

# Build wolfMQTT HTML and PDF
FROM scratch AS wolfmqtt
COPY --from=wolfmqtt-stage1 /src/wolfssl/wolfMQTT/wolfMQTT-Manual.pdf wolfmqtt.pdf
COPY --from=wolfmqtt-stage2 /src/wolfssl/wolfMQTT/html wolfmqtt-html

# Build wolfSentry PDF
FROM builder AS wolfsentry-stage1
WORKDIR /src/wolfssl/wolfSentry
RUN make pdf

# Build wolfSentry HTML
FROM builder AS wolfsentry-stage2
WORKDIR /src/wolfssl/wolfSentry
RUN make html

# Build wolfSentry HTML and PDF
FROM scratch AS wolfsentry
COPY --from=wolfsentry-stage1 /src/wolfssl/wolfSentry/wolfsentry.pdf wolfsentry.pdf
COPY --from=wolfsentry-stage2 /src/wolfssl/wolfSentry/html wolfsentry-html

# Build wolfSSL-JNI PDF
FROM builder AS wolfssl-jni-stage1
WORKDIR /src/wolfssl/wolfSSL-JNI
RUN make pdf

# Build wolfSSL-JNI HTML
FROM builder AS wolfssl-jni-stage2
WORKDIR /src/wolfssl/wolfSSL-JNI
RUN make html

# Build wolfSentry HTML and PDF
FROM scratch AS wolfssl-jni
COPY --from=wolfssl-jni-stage1 /src/wolfssl/wolfSSL-JNI/wolfSSL-JNI-JSSE-Manual.pdf wolfssl-jni.pdf
COPY --from=wolfssl-jni-stage2 /src/wolfssl/wolfSSL-JNI/html wolfssl-jni-html

# Build wolfTPM PDF
FROM builder AS wolftpm-stage1
WORKDIR /src/wolfssl/wolfTPM
RUN make pdf

# Build wolfTPM HTML
FROM builder AS wolftpm-stage2
WORKDIR /src/wolfssl/wolfTPM
RUN make html

# Build wolfTPM HTML and PDF
FROM scratch AS wolftpm
COPY --from=wolftpm-stage1 /src/wolfssl/wolfTPM/wolfTPM-Manual.pdf wolftpm.pdf
COPY --from=wolftpm-stage2 /src/wolfssl/wolfTPM/html wolftpm-html
