### VERIFY Command — X.509 Certificate Verification

The `wolfssl verify` command is used to **verify X.509 certificates**
against a trusted Certificate Authority (CA).

This command performs certificate chain validation similar to OpenSSL’s
`openssl verify` command, with a simplified feature set focused on common
verification scenarios.

It supports verification using a CA certificate, optional intermediate
certificates, and optional Certificate Revocation List (CRL) checking.

---

#### Functional Overview

The `verify` command validates an X.509 certificate by performing the
following checks:

- Verification of the certificate signature against a trusted CA
- Validation of the certificate chain (root and intermediate certificates)
- Optional CRL-based revocation checking

If the verification is successful, the command prints `OK` to standard output.
If verification fails, an error code and a descriptive reason are printed.

---

#### Command Syntax

```sh
wolfssl verify -CAfile <ca file> \
  [-untrusted <intermediate file>] \
  [-crl_check] \
  [-partial_chain] \
  <certificate to verify>
```

#### Input

- **CA Certificate**
  - A trusted root CA certificate specified using the `-CAfile` option
- **Intermediate Certificate (optional)**
  - An intermediate certificate provided via the `-untrusted` option
- **Target Certificate**
  - The certificate to be verified, specified as the final argument on the command line

---

#### Common Options

| Option | Description |
|------|-------------|
| `-CAfile <file>` | Trusted CA certificate file used for verification |
| `-untrusted <file>` | Intermediate certificate file used to build the certificate chain |
| `-crl_check` | Enable certificate revocation checking using Certificate Revocation Lists (CRLs) |
| `-partial_chain` | Allow verification to succeed with a partial certificate chain |

> **Note:**  
> Current support allows loading **only one** intermediate certificate via the `-untrusted` option.

---

#### Verification Behavior

- The certificate specified as the final argument is verified against the
  trusted CA provided by `-CAfile`.
- If `-untrusted` is specified, the given certificate is used as an
  intermediate certificate during chain construction.
- When `-crl_check` is enabled, the verification process checks whether the
  certificate has been revoked using available CRLs.
- When `-partial_chain` is specified, verification may succeed even if a full
  certificate chain up to a self-signed root certificate is not available.

---

#### Notes

- The `-CAfile` option is mandatory.
- Only a single intermediate certificate is currently supported via
  the `-untrusted` option.
- CRL checking requires wolfSSL to be built with CRL support enabled.
- This command performs verification only; it does not automatically fetch
  missing certificates or CRLs.

---

#### Examples

Verify a certificate using a CA certificate:

```sh
wolfssl verify -CAfile ca-cert.pem server-cert.pem
```

Verify a certificate with an intermediate certificate:

```sh
wolfssl verify -CAfile ca-cert.pem \
  -untrusted intermediate-cert.pem \
  server-cert.pem
``` 

Verify a certificate with CRL checking enabled:

```sh
wolfssl verify -CAfile ca-cert.pem -crl_check server-cert.pem
```
