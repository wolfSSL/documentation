### RSA Command

Performs RSA operations including signing, verification, and key management. Can handle both DER and PEM format for input and output.

**RSA Sign**

```
wolfssl rsa -sign -inkey <priv_key> -in <filename> -out <filename>
```

**RSA Verify with Private Key**

```
wolfssl rsa -verify -inkey <priv_key> -sigfile <filename> -out <filename>
```

**RSA Verify with Public Key**

```
wolfssl rsa -verify -inkey <pub_key> -sigfile <filename> -out <filename> -pubin
```

Arguments:

- [-sign] sign the input data
- [-verify] verify the signature
- [-inkey] key file for signing/verification
- [-in] input file to sign or process
- [-out] file to write result to (defaults to stdout)
- [-sigfile] signature file for verification
- [-pubin] expect a public key input
- [-inform] PEM or DER input format (defaults to PEM)
- [-outform] PEM or DER output format (defaults to PEM)
- [-passin] password for PEM encrypted files
- [-noout] do not print the key out when set
- [-modulus] print out the RSA modulus (n value)

Example:

```
wolfssl rsa -sign -inkey private.pem -in data.txt -out signature.bin

wolfssl rsa -verify -inkey public.pem -sigfile signature.bin -out verified.txt -pubin
```
