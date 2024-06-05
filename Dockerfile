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

RUN git clone https://github.com/matusnovak/doxybook2
# Checkout to working version of doxybook2
RUN cd doxybook2 && git checkout 187dc2991dabe65f808263
RUN cd doxybook2 && cmake . && make install
# Copy the source files into Docker, this and any subsequent steps won't be cached
WORKDIR /src/wolfssl
COPY . .

# Build wolfSSL PDF
FROM builder AS wolfssl-stage1
ARG MANPATH
ARG PDFFILE
ARG V
WORKDIR /src/wolfssl/${MANPATH}
RUN make pdf V=${V}

# Build wolfSSL HTML
FROM wolfssl-stage1 AS wolfssl-stage2
ARG MANPATH
ARG PDFFILE
ARG V
WORKDIR /src/wolfssl/${MANPATH}
RUN make html V=${V}

# Build both wolfSSL HTML and PDF
FROM scratch AS manual
ARG MANPATH
ARG PDFFILE
COPY --from=wolfssl-stage1 /src/wolfssl/${MANPATH}/${PDFFILE} ${PDFFILE}
COPY --from=wolfssl-stage2 /src/wolfssl/${MANPATH}/html ${MANPATH}-html
