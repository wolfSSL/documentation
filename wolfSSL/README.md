# wolfSSL Manual

This is a converted version of the wolfSSL manual which:

* Has a possible code review process
* Can automatically generate PDF and HTML output
* Has cross links between parts of the documentation
* Has links to the required API parts

## Building Manual

### Prerequisites

In Ubuntu run the following, this will be a large (3GB) download/install:

```sh
sudo apt install pandoc texlive-full mkdocs doxygen
```

You also need Doxybook2 installed which can be found at: <https://github.com/matusnovak/doxybook2>. Unfortunately there is no package for this. If this is installed in a non-stardard path you can use the environment variable `DOXYBOOK_PATH` to set it.

#### Doxybook2 in Windows

To build in Windows use the following steps:

```shell
git clone https://github.com/microsoft/vcpkg
./vcpkg/bootstrap-vcpkg.sh
./vcpkg/vcpkg install


git clone https://github.com/matusnovak/doxybook2
cd doxybook2
mkdir build
cmake -B ./build -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake

cmake --build ./build --config MinSizeRel

cp ./build/src/DoxybookCli/doxybook2 ../documentation/wolfSSL
```

### Building

To build the PDF:

```sh
make pdf
```

To build the HTML:

```sh
make html
```

To build both:

```sh
make
```

To run an HTML server (HTML is built to a temporary area for this):

```sh
make serve
```
