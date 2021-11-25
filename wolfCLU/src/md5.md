### MD5 Command
Used to create a MD5 hash of input data. The last argument is the file to be hashed, if a file argument is not used then stdin is pulled for data to be hashed.


Example :

```
wolfssl md5 configure.ac
978425cba5277d73db2a76d72b523d48
```

```
echo "hi" | wolfssl md5
764efa883dda1e11db47671c4a3bbd9e
```