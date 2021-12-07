# Building wolfTPM

To build the wolfTPM library, it's required to first build and install the wolfSSL library. This can be downloaded from the [downloads page](https://wolfssl.com/download/), or through a "git clone" command, shown below:
```c
$ git clone https://github.com/wolfssl/wolfssl
```
Once the wolfSSL library has been downloaded, it needs to be built with the following options being passed to the configure script:
```c
$ ./configure --enable-certgen --enable-certreq --enable-certext
--enable-pkcs7 --enable-cryptodev
```
Then the wolfSSL library just needs to be built and installed however the user prefers.

The next step is to download and install the wolfTPM library. At the time this documentation was written, the wolfTPM library does not have a stable release yet and needs to be cloned from GitHub. The following commands show how to clone and install wolfTPM:
```c
$ git clone https://github.com/wolfssl/wolftpm
$ cd wolftpm
$ ./autogen.sh
$ ./configure
$ make
```
