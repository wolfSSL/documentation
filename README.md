# Documentation

## wolfSSL Directory

This is the new build system for the various wolfSSL products' manuals, please see the READMEs each directory for more information.

## Site styling

To generate wolfSSL themed html docs, you'll need the mkdocs-material submodule. To get the repo, you can either:

1. Clone the documentation repo recursively.

`git clone --recursive <repo url>`

2. Update the submodules, if documentation repo is already cloned.

`git submodule update --recursive`

Then just run `make html` for the desired manual.
