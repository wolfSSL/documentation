### VERIFY Command
Verifies an X509 certificate given a CA. The last argument passed into the command is the certificate file name to be verified. If the verification is successful then "OK" will be printed out to stdout. Otherwise an error value and reason will be printed out.

Arguments:

- [-CAfile] file name for CA to be used with verify
- [-untrusted] file name for intermediate certificate to be used in verification (only one -untrusted cert is currently supported)
- [-crl_check] if CRL checking should be used
- [-partial_chain] allow verification with intermediate CA

Example:

```
wolfssl verify -CAfile ./certs/ca-cert.pem ./certs/server-cert.pem

wolfssl verify -CAfile ./certs/ca-cert.pem -untrusted ./certs/intermediate.pem ./certs/server-cert.pem
```

### Typical Workflow: Verify CA-Signed Certificate

After creating a CA-signed certificate (see [CA Command](ca.md)), verify it:

```
wolfssl verify -CAfile ca.pem server-signed.pem
```

Expected output on success:

```
verifying certificate file server-signed.pem
using CA file ca.pem
OK
```
