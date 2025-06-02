### CRL Command
Used to verify a CRL file given a CA, or to convert a CRL from one format [DER | PEM] to the other. The command will print out the CRL to stdout if -out is not specified and -noout is not used. Prints out "OK" on successful verification.

- [-CAfile] <ca file name>
- [-inform] pem or der in format
- [-in] the file to read from
- [-outform] pem or der out format
- [-out] output file to write to
- [-noout] do not print output if set

Example:

```
wolfssl crl -CAfile ./certs/ca-cert.pem -in ./certs/crl.der -inform DER -noout
```
