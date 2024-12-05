# Notes on Open Source Integration

wolfEngine conforms to the general OpenSSL engine framework and architecture. As such, it can be leveraged from any OpenSSL-consuming application that correctly loads and initializes engines and wolfEngine through OpenSSL configuration file or programmatically via ENGINE API calls.

wolfSSL has tested wolfEngine with several open source projects. This chapter contains notes and tips on wolfEngine integration. This chapter is not comprehensive of all open source project support with wolfEngine, and will be expanded upon as wolfSSL or the community reports testing and using wolfEngine with additional open source projects.

## cURL

cURL is already set up to leverage an OpenSSL config file. To leverage wolfEngine:

1. Add wolfEngine engine information to your OpenSSL config file
2. If needed, set OPENSSL_CONF environment variable to point to your OpenSSL config file:
```
$ export OPENSSL_CONF=/path/to/openssl.cnf
```
3. Set OPENSSL_ENGINES environment variable to point to location of wolfEngine shared library file:
```
$ export OPENSSL_ENGINES=/path/to/wolfengine/library/dir
```
## stunnel

stunnel has been tested with wolfEngine. Notes coming soon.

## OpenSSH

To use wolfEngine with OpenSSH you will need to add `--enable-openssh` to the `./configure` line of wolfEngine.

OpenSSH needs to be compiled with OpenSSL engine support using the `--with-ssl-engine` configure option. If needed, `--with-ssl-dir=DIR` can also be used to specify the installation location of the OpenSSL library being used:
```
$ cd openssh
$ ./configure --prefix=/install/path --with-ssl-dir=/path/to/openssl/install
--with-ssl-engine
$ make
$ sudo make install
```

OpenSSH will also need an OpenSSL config file set up to leverage wolfEngine. If needed, the OPENSSL_CONF environment variable can be set to point to your config file. The OPENSSL_ENGINES environment variable may also need to be set to the location of the wolfEngine shared library:
```
$ export OPENSSL_CONF=/path/to/openssl.cnf
$ export OPENSSL_ENGINES=/path/to/wolfengine/library/dir
```
