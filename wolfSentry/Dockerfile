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

WORKDIR /src/wolfsentry
# Cache getting wolfSSL source for Doxygen docs
#RUN git clone --depth 1 https://github.com/wolfSSL/wolfssl
# Copy the source files into Docker, this and any subsequent steps won't be cached
COPY . .

# Parallel build PDF
FROM builder AS stage1
WORKDIR /src/wolfsentry
RUN make pdf

# Parallel build HTML
FROM builder AS stage2
WORKDIR /src/wolfsentry
RUN make html

FROM scratch AS export-stage
COPY --from=stage1 /src/wolfsentry/wolfsentry.pdf .
COPY --from=stage2 /src/wolfsentry/html ./html
