# Notes on Open Source Integration

wolfProvider conforms to the general OpenSSL provider framework and architecture. As such, it can be leveraged from any OpenSSL-consuming application that correctly loads and initializes providers and wolfProvider through OpenSSL configuration file or programmatically via PROVIDER API calls.

wolfSSL has tested wolfProvider with several open source projects. This chapter contains notes and tips on wolfProvider integration. This chapter is not comprehensive of all open source project support with wolfProvider, and will be expanded upon as wolfSSL or the community reports testing and using wolfProvider with additional open source projects.

## cURL

cURL is already set up to leverage an OpenSSL config file. To leverage wolfProvider:

1. Add wolfProvider provider information to your OpenSSL config file
2. If needed, set OPENSSL_CONF environment variable to point to your OpenSSL config file:
```
$ export OPENSSL_CONF=/path/to/openssl.cnf
```
3. Set OPENSSL_PROVIDERS environment variable to point to location of wolfProvider shared library file:
```
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
## stunnel

stunnel has been tested with wolfProvider. Notes coming soon.

## OpenSSH

OpenSSH needs to be compiled with OpenSSL provider support using the `--with-ssl-provider` configure option. If needed, `--with-ssl-dir=DIR` can also be used to specify the installation location of the OpenSSL library being used:
```
$ cd openssh
$ ./configure --prefix=/install/path --with-ssl-dir=/path/to/openssl/install
--with-ssl-provider
$ make
$ sudo make install
```

OpenSSH will also need an OpenSSL config file set up to leverage wolfProvider. If needed, the OPENSSL_CONF environment variable can be set to point to your config file. The OPENSSL_PROVIDERS environment variable may also need to be set to the location of the wolfProvider shared library:
```
$ export OPENSSL_CONF=/path/to/openssl.cnf
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
