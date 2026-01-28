### REQ Command
Used for creating a certificate request or a self-signed certificate. Can handle some basic parsing of a .conf file for certificate setup. If no configuration file is used then stdin is prompted for certificate information.

See [Configuration File Format](#configuration-file-format) for details on the config file directives.

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

### Configuration File Format

The `-config` option accepts an OpenSSL-style configuration file. wolfCLU supports a subset of OpenSSL's config directives.

#### Main Section Directives

In the `[req]` section:

| Directive | Description |
|-----------|-------------|
| `prompt` | Set to "no" to disable interactive prompting |
| `default_bits` | Default key size in bits |
| `default_keyfile` | Default key file path |
| `distinguished_name` | Section name containing DN fields |
| `attributes` | Section name containing attributes |
| `x509_extensions` | Section name containing X509 extensions |

#### Distinguished Name Section

| Directive | Description |
|-----------|-------------|
| `countryName` | Country code (2 letters, e.g., US) |
| `stateOrProvinceName` | State or province name |
| `localityName` | City or locality name |
| `organizationName` | Organization name |
| `organizationalUnitName` | Organizational unit name |
| `commonName` or `CN` | Common name (e.g., domain name) |
| `emailAddress` | Email address |
| `name` | Name |
| `surname` | Surname |
| `givenName` | Given name |
| `initials` | Initials |
| `dnQualifier` | DN qualifier |

Each field can have optional modifiers:
- `<field>_default` - Default value
- `<field>_min` - Minimum length
- `<field>_max` - Maximum length

#### Attributes Section

| Directive | Description |
|-----------|-------------|
| `challengePassword` | PKCS#9 challenge password |
| `unstructuredName` | PKCS#9 unstructured name |

#### X509 Extensions Section

| Directive | Description |
|-----------|-------------|
| `basicConstraints` | CA constraint and path length |
| `subjectKeyIdentifier` | Subject key identifier |
| `authorityKeyIdentifier` | Authority key identifier |
| `keyUsage` | Key usage flags |
| `subjectAltName` | Subject alternative names (use @section_name) |

**basicConstraints values:**
- `critical` - Mark as critical extension
- `CA:TRUE` or `CA:FALSE` - Is this a CA certificate
- `pathlen:<n>` - Maximum path length for CA

**keyUsage values:**
- `digitalSignature`
- `nonRepudiation` / `contentCommitment`
- `keyEncipherment`
- `dataEncipherment`
- `keyAgreement`
- `keyCertSign`
- `cRLSign`
- `encipherOnly`
- `decipherOnly`

**subjectKeyIdentifier values:**
- `hash` - Use hash of public key

#### Subject Alt Name Section

When `subjectAltName = @alt_names`, define a section `[alt_names]`:

| Directive | Description |
|-----------|-------------|
| `DNS.<n>` | DNS name (e.g., DNS.1 = example.com) |
| `IP.<n>` | IP address (e.g., IP.1 = 192.168.1.1) |
| `URI.<n>` | URI |
| `email.<n>` | Email address |
| `RID.<n>` | Registered ID (OID) |

#### Example Configuration File

```ini
[req]
prompt = no
default_bits = 2048
distinguished_name = req_dn
x509_extensions = v3_ext

[req_dn]
countryName = US
stateOrProvinceName = Washington
localityName = Seattle
organizationName = wolfSSL
commonName = example.com
emailAddress = info@example.com

[v3_ext]
basicConstraints = critical, CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.1
```

Usage with config file:

```
wolfssl req -new -config server.conf -key server.priv -out server.csr

wolfssl req -new -x509 -config ca.conf -key ca.priv -out ca.pem -days 3650
```
