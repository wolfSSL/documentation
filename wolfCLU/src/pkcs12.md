### PKCS12 Command
Currently only PKCS12 parsing is supported and PKCS12 generation is not yet supported. By default the --enable-wolfclu option used when building wolfSSL has PKCS12 support enabled but it does not enable RC2. If parsing PKCS12 bundles that have been encrypted using RC2 then --enable-rc2 should also be used when compiling wolfSSL.

- [-in] file input for pkcs12 bundle
- [-out] file to output results to (default stdout)
- [-nodes] no DES encryption
- [-nocerts] no certificate output
- [-nokeys] no key output
- [-passin] source to get password from
- [-passout] source to output password to

Example:

```
wolfssl pkcs12 -nodes -passin pass:"wolfSSL test" -in ./certs/test-servercert.p12
```
