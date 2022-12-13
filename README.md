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

You also need Doxybook2 installed which can be found at: <https://github.com/matusnovak/doxybook2>. Unfortunately there is no package for this. Installation instructions can be found at: <https://github.com/matusnovak/doxybook2#Install>. You'll likely have to checkout to this commit `1e5f8f0879aa1e908ccce250`.

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

## Localization

By default, the built output documentation is in English. If you assign a language code to the DOC_LANG variable and call 'make' with it, the output will be localized in that specified language. As of now (end of 2022), the only supported language code is 'JA', which means 'Japanese'. Not all wolfSSL products documentation supports localization. 'make' with DOC_LANG variable for unsupported products is ignored and output in English.

```sh
make DOC_LANG=JA
```

### Pre-requisites

For localization to work, the build environment must have the correct fonts installed for the specified language.

#### Japanese font
'Noto Sans CJK JP' font is used for Japanese localization. You can get the font files from the following Github repository:
https://github.com/googlefonts/noto-cjk/tree/main/Sans/OTF/Japanese

You can download the seven `NotoSansCJKjp-xxx.otf` files from there and put them into `/usr/local/share/fonts`. You may need 'sudo' for the operation. After coping font files, you need to update font cache by calling:

```sh
sudo fc-cache -fv
```
Then you can confirm the font cache includes the installed font files by 'fc-list'.

```sh
fc-list | grep NotoSansCJKjp
```
You will get the list of installed font files.

