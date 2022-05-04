# Documentation

This is the new build system for the various wolfSSL products' manuals, please see the READMEs each directory for more information. The advantages of this over previous wolfSSL manuals are:

* Has a possible code review process
* Can automatically generate PDF and HTML output
* Has cross links between parts of the documentation
* Has links to the required API parts

## Building Documentation

To build the documentation you will need Docker running on your system. In this documentation root directory run `make` to build the documentation for every project which will output in a `build` subdirectory of this root directory (**note**: on some systems you may need to use `sudo` before `make`). You can also build individual project manuals by doing:

* `make wolfssl`
* `make wolfssh`
* `make wolfboot`
* `make wolfclu`
* `make wolfcrypt-jni`
* `make wolfmqtt`
* `make wolfsentry`
* `make wolfssl-jni`
* `make wolftpm`

## Contributing

There is a [CONTRIBUTING.md](CONTRIBUTING.md) document which outlines how to add manuals to the tree.

## Building without Docker

### Pre-requisites

If you are not building using the Docker build system above you can build using Ubuntu, this will require around 3GB of packages to be installed:

```sh
sudo apt install pandoc texlive-full mkdocs doxygen
```

You also need Doxybook2 installed which can be found at: <https://github.com/matusnovak/doxybook2>. Unfortunately there is no package for this. Installation instructions can be found at: <https://github.com/matusnovak/doxybook2#Install>

If Doxybook2 is installed in a non-stardard path you can use the environment variable `DOXYBOOK_PATH` to set it.

### Building

When in each manual directory to build the PDF:

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

To run a local HTML server (HTML is built to a temporary area for this):

```sh
make serve
```
