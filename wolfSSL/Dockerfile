FROM texlive/texlive:latest AS builder

WORKDIR /deps

RUN apt-get -y update
RUN apt-get -y install pandoc mkdocs doxygen git build-essential cmake libfmt-dev nlohmann-json3-dev libspdlog-dev libcxxopts-dev fonts-noto

RUN git clone --depth=1 https://github.com/pantor/inja
RUN cd inja && cmake . -DBUILD_TESTING=OFF -DBUILD_BENCHMARK=OFF && make install

RUN git clone --depth=1 https://github.com/matusnovak/doxybook2
RUN cd doxybook2 && cmake . && make install

WORKDIR /src

COPY . wolfssl

WORKDIR /src/wolfssl
RUN git clone --depth 1 https://github.com/wolfSSL/wolfssl

FROM builder AS stage1
WORKDIR /src/wolfssl
RUN make pdf

FROM builder AS stage2
WORKDIR /src/wolfssl
RUN make html

FROM scratch AS export-stage
COPY --from=stage1 /src/wolfssl/wolfssl.pdf .
COPY --from=stage2 /src/wolfssl/html ./html
