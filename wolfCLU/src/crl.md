### CRL Command — Certificate Revocation List Processing and Inspection

The `wolfssl crl` command is used to **read, inspect, convert, and display
Certificate Revocation Lists (CRLs)**.

This command provides functionality similar to OpenSSL’s `openssl crl`
command and is intended for examining CRL contents and converting CRLs
between encoding formats.

Typical use cases include:

- Displaying CRL contents in human-readable form
- Converting CRLs between PEM and DER formats
- Verifying CRL issuer information against a CA certificate
- Inspecting CRL metadata such as update times and revoked certificates

---

#### Functional Overview

The `crl` command operates on an existing Certificate Revocation List and
supports the following operations:

- Reading CRLs in PEM or DER format
- Converting CRLs between PEM and DER encodings
- Printing CRL contents in a human-readable text format
- Suppressing encoded output when inspection only is desired

The command does not generate CRLs; it is intended solely for CRL inspection
and format handling.

---

#### Input and Output

- **Input**
  - Certificate Revocation List (CRL) in PEM or DER format
- **Output**
  - CRL in PEM or DER format, or human-readable CRL information

---

#### Common Options

| Option | Description |
|------|-------------|
| `-CAfile <file>` | CA certificate used to verify the CRL issuer |
| `-in <file>` | Input CRL file |
| `-inform pem \| der` | Input CRL format |
| `-out <file>` | Output file for the CRL |
| `-outform pem \| der` | Output CRL format |
| `-noout` | Do not output the encoded CRL |
| `-text` | Output CRL contents in human-readable form |

---

#### Notes

- The `-in` option must specify a valid CRL file.
- The `-CAfile` option may be used to associate the CRL with a trusted CA.
- When `-text` is specified, CRL details such as issuer, update times,
  and revoked certificate entries are printed.
- The `-noout` option suppresses output of the encoded CRL, but does not
  suppress text output when `-text` is used.
- This command does not fetch CRLs automatically; it operates only on
  locally provided files.

---

#### Examples

Display CRL contents in human-readable form:

```sh
wolfssl crl -in crl.pem -text
```

Convert a CRL from PEM to DER format:

```sh
wolfssl crl -in crl.pem -inform pem -outform der -out crl.der
```

Inspect a CRL without outputting the encoded data:

```sh
wolfssl crl -in crl.pem -text -noout
```
