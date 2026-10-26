# Doxybook2 is built in its own stage so BuildKit runs it in parallel with
# the builder setup below
FROM pandoc/latex:latest-ubuntu AS doxybook2

WORKDIR /deps

RUN apt-get -y update
# build-essential and cmake to build the dependencies
# libfmt-dev nlohmann-json3-dev libspdlog-dev and libcxxopts-dev are needed by Doxybook2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends git ca-certificates build-essential cmake libfmt-dev nlohmann-json3-dev libspdlog-dev libcxxopts-dev

# Inja is a dep for Doxybook2
RUN git clone --depth=1 https://github.com/pantor/inja
RUN cd inja && cmake . -DBUILD_TESTING=OFF -DBUILD_BENCHMARK=OFF && make install

RUN git clone https://github.com/dgarske/doxybook2
# Checkout to working version of doxybook2
RUN cd doxybook2 && git checkout master
RUN cd doxybook2 && cmake . && make install

# pandoc/latex provides pandoc and a minimal TeX Live
FROM pandoc/latex:latest-ubuntu AS builder

RUN apt-get -y update
# mkdocs is used for the HTML manuals
# Doxygen to convert the Doxygen docs
# The Noto fonts are needed by our PDF generator
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends mkdocs doxygen git make patch ca-certificates fonts-noto-core fonts-noto-mono fonts-noto-cjk
# The LaTeX packages our PDF headers use beyond the minimal TeX Live
RUN tlmgr update --self && tlmgr install titlesec tocloft fvextra listings fancyhdr
COPY --from=doxybook2 /usr/local/bin/doxybook2 /usr/local/bin/doxybook2
RUN doxybook2 --version

# Copy the source files into Docker, this and any subsequent steps won't be cached
WORKDIR /src/wolfssl
COPY . .

# Build wolfSSL PDF
FROM builder AS wolfssl-stage1
ARG MANPATH
ARG PDFFILE
ARG V
ARG WOLFCOSE_REF=main
ARG WOLFTPM_REF=master
WORKDIR /src/wolfssl/${MANPATH}
RUN make pdf V=${V} WOLFCOSE_REF=${WOLFCOSE_REF} WOLFTPM_REF=${WOLFTPM_REF}

# Build wolfSSL HTML
FROM wolfssl-stage1 AS wolfssl-stage2
ARG MANPATH
ARG PDFFILE
ARG V
WORKDIR /src/wolfssl/${MANPATH}
RUN if [ "${MANPATH}" = wolfCOSE ]; then \
        WOLFCOSE_REF="$(git -C wolfcose rev-parse HEAD)" make html V=${V}; \
    elif [ "${MANPATH}" = wolfTPM ]; then \
        WOLFTPM_REF="$(git -C wolftpm rev-parse HEAD)" make html V=${V}; \
    else \
        make html V=${V}; \
    fi

# Build both wolfSSL HTML and PDF
FROM scratch AS manual
ARG MANPATH
ARG PDFFILE
COPY --from=wolfssl-stage1 /src/wolfssl/${MANPATH}/${PDFFILE} ${PDFFILE}
COPY --from=wolfssl-stage2 /src/wolfssl/${MANPATH}/html ${MANPATH}-html
