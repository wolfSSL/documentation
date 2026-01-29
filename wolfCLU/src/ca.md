### CA Command
Used for signing Certificates. Can handle some basic config file parsing.

See [Configuration File](config.md) for details on config file directives.

Arguments:    

- [-in] input CSR file
- [-out] file to write to
- [-keyfile] file to read private key from
- [-cert] file to read CA from
- [-extensions] section in config file to parse extensions from
- [-md] type of hash to use i.e sha, sha256, ...
- [-inform] PEM/DER type of CSR input
- [-config] file to parse for configuration
- [-days] number of days should be valid for
- [-selfsign] sign with key associated with input cert

Example:

```
wolfssl ca -config ca.conf -in test.csr -out test.pem -md sha256 -selfsign -keyfile ./key
```

### Typical Workflow: Sign CSR with CA

**Step 1: Create CA key and certificate** (see [GENKEY Command](genkey.md) and [REQ Command](req.md))

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
wolfssl req -new -x509 -key ca.priv -out ca.pem -days 3650 -subj "/C=US/ST=Washington/L=Seattle/O=wolfSSL/CN=wolfSSL CA"
```

**Step 2: Create server key and CSR**

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
wolfssl req -new -key server.priv -out server.csr -subj "/C=US/ST=Washington/L=Seattle/O=wolfSSL/CN=example.com"
```

**Step 3: Sign server CSR with CA**

```
wolfssl ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

**Step 4: Verify the signed certificate** (see [VERIFY Command](verify.md))

```
wolfssl verify -CAfile ca.pem server-signed.pem
```

### Using Configuration File with CA

The `-config` option allows specifying certificate extensions to be added when signing.

Example CA config file (`ca.conf`):

```ini
[ca]
x509_extensions = v3_ca

[v3_ca]
basicConstraints = critical, CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
```

Sign CSR with extensions from config:

```
wolfssl ca -config ca.conf -extensions v3_ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

