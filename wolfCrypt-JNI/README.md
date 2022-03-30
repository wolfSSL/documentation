# wolfCrypt JCE Provider and JNI Wrapper Manual

This is a pandoc generated version of the wolfCrypt JCE Provider and JNI Wrapper manual.

## Building Manual

#### Prerequisites

In Ubuntu run the following, this will be a large download/install:

```sh
sudo apt install pandoc texlive-full mkdocs
```

#### Building

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
