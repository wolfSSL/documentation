# TODO

## Content

* Modify the "Build Options" in Chapter 2 to cover non-autotools builds
* ~~Convert remaining chapters~~
* ~~Switch API crosslinks to internal once we have the API chapters~~
* ~~Replace worded "chapter" and "section" references with internal crosslinks~~
* Make a pass at updating the content
* Unifi coding standards across the examples in the documentation
* ~~Update wolfSSL URLs to the redirected locations~~
* ~~Update all links to HTTPS where possible~~
* ~~Some of the draft RFCs must be real now, check up~~
* ~~Appendix handling incorrect~~

## PDF Output

* ~~Add copyright footer~~
* ~~Add logo to first page~~
* ~~Shrink margins~~
* ~~Make sure output is Letter format~~

## HTML Output

* ~~Mark appendices as such~~
* ~~Fix table broken footers~~
* ~~code block nested in bullets breaks~~
* ~~Fix chapter numbers~~

## Building

* ~~HTML output~~
* Skin HTML output
* ~~Convert Doxygen for API chapters~~
  * ~~Add this content to the PDF build too~~

## CI

* Add MD lint checking
  - <https://github.com/tmknom/markdownlint>
* Add URL validation (nightly?)
  - There is a mkdocs community plugin for this

```sh
sudo docker run -v ${PWD}:/tmp:ro --rm -i ghcr.io/tcort/markdown-link-check:stable /tmp/chapter02.md
```

## Other

* Licensing (which CC if open?)
