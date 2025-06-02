### MD5 Command
Used to create an MD5 hash of input data. The last argument is the file to be hashed, if a file argument is not provided then stdin is used. Note that when using stdin the input must be provided upon calling wolfssl. A correct usage and incorrect usage of stdin are shown below:

Incorrect :

```
wolfssl md5
> hi
> 
```
Correct :

```
echo "hi" | wolfssl md5
```

The reason the incorrect version is wrong is because no output will be received. This input method is used because it mimics the usage of OpenSSL's CLI, thus it encourages portability when switching from OpenSSL to WolfSSL.


Examples :

```
wolfssl md5 configure.ac

978425cba5277d73db2a76d72b523d48

```

```
echo "hi" | wolfssl md5

764efa883dda1e11db47671c4a3bbd9e
```
