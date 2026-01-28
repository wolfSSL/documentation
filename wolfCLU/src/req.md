### REQ Command
Used for creating a certificate request or a self-signed certificate. Can handle some basic parsing of a .conf file for certificate setup. If no configuration file is used then stdin is prompted for certificate information.

See [Configuration File](config.md) for details on the config file directives.

Arguments:

- [-in] input file to read from
- [-out] file to write to (default stdout)
- [-key] public key to put into certificate request
- [-inform] der or pem format for '-in' (defaults to pem)
- [-outform] der or pem format for '-out' (defaults to pem)
- [-config] file to parse for certificate configuration
- [-days] number of days should be valid for
- [-x509] generate self signed certificate
- [-extensions] overwrite the section to get extensions from
- [-nodes] no DES encryption on private key output
- [-newkey] generate the private key to use with req
- [-inkey] private key to use with req
- [-keyout] file to output key to
- [-subj] use a specified subject name, e.g., O=wolfSSL/C=US/ST=WA/L=Seattle/CN=wolfSSL/OU=org-unit
- [-verify] check the signature on the req
- [-text] output human readable text of req
- [-noout] do not print out the generated results

Example:

```
wolfssl ecparam -genkey -out ecc.key -name secp384r1

wolfssl req -new -x509 -days 3650 -config selfsigned.conf -key ecc.key -out ecc.cert -outform der -sha256

wolfssl req -newkey rsa:2048 -keyout mykey.pem -out myreq.csr -subj "O=wolfSSL/C=US/CN=test"
```

### Typical Workflow: RSA Key to Certificate

**Step 1: Generate RSA key pair** (see [GENKEY Command](genkey.md))

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
```

**Step 2: Create CSR from private key**

```
wolfssl req -new -key server.priv -out server.csr -subj "/C=US/ST=Washington/L=Seattle/O=wolfSSL/CN=example.com"
```

**Step 3a: Create self-signed certificate**

```
wolfssl req -x509 -key server.priv -in server.csr -out server.pem -days 365
```

**Step 3b: Or create CA-signed certificate** (see [CA Command](ca.md))

First, create a CA certificate:

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
wolfssl req -new -x509 -key ca.priv -out ca.pem -days 3650 -subj "/C=US/ST=Washington/L=Seattle/O=wolfSSL/CN=wolfSSL CA"
```

Then sign the server CSR with the CA:

```
wolfssl ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

**Step 4: Verify the certificate** (see [VERIFY Command](verify.md))

```
wolfssl verify -CAfile ca.pem server-signed.pem
```

