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

You also need Doxybook2 installed which can be found at: <https://github.com/matusnovak/doxybook2>. Unfortunately there is no package for this.

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
