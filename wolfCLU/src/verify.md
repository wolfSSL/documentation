### VERIFY Command
Verifies an X509 certificate given a CA. The last argument passed into the command is the certificate file name to be verified. If the verification is successful then "OK" will be printed out to stdout. Otherwise an error value and reason will be printed out.

- [-CAfile] file name for CA to be used with verify
- [-crl_check] if CRL checking should be used

Example:

```
wolfssl verify -CAfile ./certs/ca-cert.pem ./certs/server-cert.pem
```