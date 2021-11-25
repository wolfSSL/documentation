## Building wolfCLU
To build wolfCLU first build wolfSSL with the --enable-wolfclu flag. An example of this would be:

```
cd wolfssl
./configure --enable-wolfclu
make
sudo make install
```
    

Note that if parsing PKCS12 files with RC2 or if using CRL the flags --enable-rc2 and --enable-crl would also need to be used when building wolfSSL.


Then build wolfCLU linking agianst the wolfSSL library created.

```
cd wolfclu
./configure
make
sudo make install

or

cd wolfclu
./configure --with-wolfssl=/path/to/wolfssl/install
make
sudo make install
``` 
