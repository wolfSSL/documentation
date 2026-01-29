### Configuration File Format

wolfCLU supports OpenSSL-style configuration files for the `req` and `ca` commands. This page describes the supported directives.

## Basic Structure

Configuration files use INI-style format with sections and key-value pairs:

```ini
[section_name]
key = value
```

## REQ Command Configuration

### Main Section

The `[req]` section contains the main configuration:

| Directive | Description |
|-----------|-------------|
| `prompt` | Set to `no` to disable interactive prompting |
| `default_bits` | Default key size in bits (e.g., 2048) |
| `default_md` | Default hash algorithm (e.g., sha256) |
| `default_keyfile` | Default key file path |
| `distinguished_name` | Section name containing DN fields |
| `attributes` | Section name containing attributes |
| `x509_extensions` | Section name containing X509 extensions |

### Distinguished Name Section

The distinguished name section (referenced by `distinguished_name`) defines certificate subject fields:

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

| Modifier | Description |
|----------|-------------|
| `<field>_default` | Default value if not provided |
| `<field>_min` | Minimum length |
| `<field>_max` | Maximum length |

### Attributes Section

The attributes section (referenced by `attributes`) defines PKCS#9 attributes:

| Directive | Description |
|-----------|-------------|
| `challengePassword` | PKCS#9 challenge password |
| `unstructuredName` | PKCS#9 unstructured name |

## X509 Extensions Section

The extensions section (referenced by `x509_extensions`) defines certificate extensions:

| Directive | Description |
|-----------|-------------|
| `basicConstraints` | CA constraint and path length |
| `subjectKeyIdentifier` | Subject key identifier |
| `authorityKeyIdentifier` | Authority key identifier |
| `keyUsage` | Key usage flags |
| `subjectAltName` | Subject alternative names |

### basicConstraints

Defines whether the certificate is a CA and the maximum path length.

Format: `[critical, ]CA:TRUE|FALSE[, pathlen:<n>]`

| Value | Description |
|-------|-------------|
| `critical` | Mark as critical extension |
| `CA:TRUE` | This is a CA certificate |
| `CA:FALSE` | This is not a CA certificate |
| `pathlen:<n>` | Maximum certification path length |

Examples:
```ini
basicConstraints = critical, CA:TRUE, pathlen:0
basicConstraints = CA:FALSE
```

### keyUsage

Defines the purpose of the key contained in the certificate.

Format: `[critical, ]<usage>[, <usage>...]`

| Value | Description |
|-------|-------------|
| `digitalSignature` | Digital signature |
| `nonRepudiation` | Non-repudiation (also `contentCommitment`) |
| `keyEncipherment` | Key encipherment |
| `dataEncipherment` | Data encipherment |
| `keyAgreement` | Key agreement |
| `keyCertSign` | Certificate signing |
| `cRLSign` | CRL signing |
| `encipherOnly` | Encipher only (with keyAgreement) |
| `decipherOnly` | Decipher only (with keyAgreement) |

Examples:
```ini
keyUsage = critical, digitalSignature, keyEncipherment
keyUsage = keyCertSign, cRLSign
```

### subjectKeyIdentifier

Identifies the public key in the certificate.

| Value | Description |
|-------|-------------|
| `hash` | Use hash of public key |

Example:
```ini
subjectKeyIdentifier = hash
```

### subjectAltName

Specifies additional identities for the certificate subject. Use `@section_name` to reference a section containing the alternative names.

Example:
```ini
subjectAltName = @alt_names
```

#### Alternative Names Section

| Directive | Description |
|-----------|-------------|
| `DNS.<n>` | DNS name (e.g., `DNS.1 = example.com`) |
| `IP.<n>` | IP address (e.g., `IP.1 = 192.168.1.1`) |
| `URI.<n>` | URI (e.g., `URI.1 = https://example.com`) |
| `email.<n>` | Email address (e.g., `email.1 = admin@example.com`) |
| `RID.<n>` | Registered ID / OID |

Example:
```ini
[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.1
email.1 = admin@example.com
```

## CA Command Configuration

### Main Section

The `[ca]` section specifies the default CA section:

```ini
[ca]
default_ca = CA_default
```

### CA Section

The CA section (e.g., `[CA_default]`) contains CA-specific settings:

| Directive | Description |
|-----------|-------------|
| `serial` | File containing serial number (hex format) |
| `new_certs_dir` | Directory for new certificates |
| `certificate` | CA certificate file |
| `private_key` | CA private key file |
| `default_days` | Default validity period in days |
| `default_md` | Default hash algorithm |
| `x509_extensions` | Section name for extensions |
| `policy` | Section name for DN policy |
| `database` | Certificate database file |
| `unique_subject` | Require unique subjects |
| `crl_dir` | Directory for CRLs |
| `crl` | CRL file |
| `RANDFILE` | Random seed file |

## Complete Examples

### Server Certificate Request

```ini
[req]
prompt = no
default_bits = 2048
default_md = sha256
distinguished_name = req_dn
x509_extensions = v3_server

[req_dn]
countryName = US
stateOrProvinceName = Washington
localityName = Seattle
organizationName = wolfSSL
commonName = example.com
emailAddress = info@example.com

[v3_server]
basicConstraints = critical, CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.1
```

Usage:
```
wolfssl req -new -config server.conf -key server.priv -out server.csr
wolfssl req -new -x509 -config server.conf -key server.priv -out server.pem -days 365
```

### CA Certificate

```ini
[req]
prompt = no
default_bits = 4096
default_md = sha256
distinguished_name = ca_dn
x509_extensions = v3_ca

[ca_dn]
countryName = US
stateOrProvinceName = Washington
localityName = Seattle
organizationName = wolfSSL
commonName = wolfSSL CA

[v3_ca]
basicConstraints = critical, CA:TRUE, pathlen:1
keyUsage = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
```

Usage:
```
wolfssl req -new -x509 -config ca.conf -key ca.priv -out ca.pem -days 3650
```

### Simple CSR (Minimal)

```ini
[req]
prompt = no
distinguished_name = req_dn

[req_dn]
commonName = myserver
```

Usage:
```
wolfssl req -new -config simple.conf -key server.priv -out server.csr
```

## Limitations

### Output Path Handling with new_certs_dir

When using the `-out` option together with `new_certs_dir` in the configuration file, there is a path handling bug in versions up to v0.1.9:

- If `-out` specifies an **absolute path** (e.g., `/tmp/output/signed.pem`), it is incorrectly concatenated with `new_certs_dir`, resulting in an invalid path.
- **Workaround:** Use a relative path for `-out` (e.g., `signed.pem`), which will be correctly placed in the `new_certs_dir` directory.

### Serial Number File

The `serial` directive specifies a file containing the serial number in hexadecimal format:

```
01
```

The serial number is incremented after each certificate is signed. Without a configuration file specifying a serial file, wolfCLU generates a random serial number for each signed certificate.
