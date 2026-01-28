### BENCH Command
Used for benchmarking algorithms. To benchmark all algorithms run `wolfssl bench -a`.

Available algorithms (depends on configure settings):

- aes-cbc
- aes-ctr
- 3des
- camellia
- md5
- sha
- sha256
- sha384
- sha512
- blake2b

Arguments:

- [algorithm] algorithm to benchmark
- [-time] time in seconds to run (1-10)
- [-a] or [-all] test all available algorithms
- [-in] input file to read from
- [-out] output file to write to

Example:

```
wolfssl bench aes-cbc -time 10

wolfssl bench -a -time 5
```
