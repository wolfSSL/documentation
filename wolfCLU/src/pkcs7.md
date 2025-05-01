### PKCS7 Command

Processes PKCS#7 data, allowing operations such as extracting certificates from PKCS#7 files. PKCS#7 is a standard for cryptographically signed and/or encrypted data.

- [-in] input file containing PKCS#7 data (required)
- [-out] output file to write results to (default stdout)
- [-inform] input format (PEM or DER, default PEM)
- [-outform] output format (PEM or DER, default PEM)
- [-print_certs] extract and output certificates from the PKCS#7 file

Example for extracting certificates from a PKCS#7 file:

```
wolfssl pkcs7 -in pkcs7.pem -print_certs
```

Example for converting PKCS#7 data from PEM to DER format:

```
wolfssl pkcs7 -in pkcs7.pem -outform DER -out pkcs7.der
```
