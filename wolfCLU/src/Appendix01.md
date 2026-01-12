# Appendix A: Configuration File Format

## A.1 Overview

Various wolfCLU commands (such as `x509`, `req`, etc.) can reference a
**configuration file**, similar in concept to OpenSSL’s `openssl.cnf`,
to perform the following tasks:

- Definition of Distinguished Names (DNs)
- Specification of X.509 extensions
- Control of certificate generation behavior

---

## Notes on CA Functionality (Scope and Intended Use)

The CA-related functionality in wolfCLU is intended for:

- **Diagnostic and verification use cases for certificate generation and validation**
- **Providing a limited set of certificate operations required in embedded systems**

In particular, wolfCLU is designed to provide
**implementation- and verification-oriented functionality**
for environments with **resource constraints** or for architectures
where **certificate management is delegated to external systems**.

As such, wolfCLU is **not intended to be used as a full-featured
Certificate Authority (CA) management tool**, nor for managing the
entire certificate lifecycle.

> **Note**  
> Although the configuration file syntax is designed to resemble OpenSSL’s
> format, it does **not** implement all features of `openssl.cnf`.

---

## A.2 Basic Syntax

Configuration files follow the rules described below.

### A.2.1 Sections

```
[ section_name ]
```

- Section names are case-insensitive.
- Sections may be defined in any order.

---

### A.2.2 Keys and Values

```
key = value
```

- Whitespace around keys and values is ignored.
- Values are treated as strings; no numeric interpretation is performed.

---

### A.2.3 Comments

```
; comment
```

- Both `#` and `;` are treated as comment markers.
- End-of-line comments are supported.

---

## A.3 Configuration File Processing Model

wolfCLU’s configuration processing has the following characteristics:

- **Single-file loading**
  - `include` and `include_dir` are not supported
- **Single-level section references**
  - References such as `section = other_section` are supported
  - Recursive or multi-level references are not supported
- **Undefined keys are ignored**
  - Unknown or unused directives do not cause errors

---

## A.4 Major Supported Sections

### A.4.1 `[ req ]`

Defines the basic behavior for Certificate Signing Request (CSR)
generation and self-signed certificate creation.

Example:

```
[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
```

| Key | Description |
|----|------------|
| `default_bits` | Key size (when using RSA) |
| `distinguished_name` | DN definition section |
| `x509_extensions` | Extension section to apply |
| `prompt` | Whether DN input is interactive |

---

### A.4.2 `[ req_distinguished_name ]`

Defines individual attributes of the Distinguished Name (DN).

```
[ req_distinguished_name ]
C = US
ST = MT
L = Bozeman
O = wolfSSL Inc
OU = Engineering
CN = example.com
```

- Each key is interpreted as an X.509 DN attribute.
- Attributes not defined in the section are omitted.

---

### A.4.3 X.509 Extension Sections  
(e.g. `[ v3_req ]`, `[ v3_ca ]`)

These sections define certificate extensions.

**Subject Alternative Name (SAN)**

```
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = example.com
DNS.2 = www.example.com
```

**Basic Constraints**

```
basicConstraints = CA:FALSE
```

**Key Usage**

```
keyUsage = digitalSignature, keyEncipherment
```

**Extended Key Usage**

```
extendedKeyUsage = serverAuth, clientAuth
```

---

## A.5 Supported Extension Directives

wolfCLU supports the following commonly used X.509 extensions:

- `basicConstraints`
- `keyUsage`
- `extendedKeyUsage`
- `subjectAltName`
- `subjectKeyIdentifier`
- `authorityKeyIdentifier`

If unsupported extensions are specified, the configuration file is still
parsed successfully, and the unsupported directives are ignored.

---

## A.6 Mapping Between Commands and Sections

| Command | Primary Sections Used |
|--------|----------------------|
| `req` | `req`, `req_distinguished_name`, extension sections |
| `x509` | Extension sections |
| `s_server` / `s_client` | Certificate loading only |

---

## A.7 Major Differences from OpenSSL

- No support for `include` / `include_dir`
- No support for `policy` sections
- No variable expansion (e.g. `${var}`)
- No engine-related configuration

These features are **intentionally not implemented**.
wolfCLU aims to provide **the minimum configuration processing required
for CLI-based diagnostics and verification**.

---

## A.8 Minimal Configuration Example

```
[ req ]
prompt = no
distinguished_name = dn
x509_extensions = v3

[ dn ]
CN = test.example.com

[ v3 ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
```

---

## A.9 `[ ca ]` Section

### A.9.1 Basic Structure

```
[ ca ]
default_ca = CA_default
```

The `[ ca ]` section acts as an **entry point that selects the actual CA
definition section** to be used.

---

### A.9.2 CA Definition Section (Example: `[ CA_default ]`)

```
[ CA_default ]
dir = ./demoCA
certs = $dir/certs
crl_dir = $dir/crl
database = $dir/index.txt
serial = $dir/serial
certificate = $dir/cacert.pem
private_key = $dir/private/cakey.pem
default_md = sha256
policy = policy_any
x509_extensions = v3_ca
```

> **Note**  
> Not all keys are required.  
> Any entries not referenced by wolfCLU are ignored.

---

### A.9.3 Primary Supported Keys

| Key | Description |
|----|------------|
| `certificate` | CA certificate file |
| `private_key` | CA private key file |
| `default_md` | Hash algorithm used for signing |
| `x509_extensions` | Extension section applied to issued certificates |

The following keys may be written in OpenSSL-compatible form, but are
either ignored or only partially used by wolfCLU:

- `database`
- `serial`
- `crl_dir`
- `policy`

---

### A.9.4 Policy Sections (`[ policy_xxx ]`)

In OpenSSL, policy sections are used to define DN constraints.
In wolfCLU, however, policy contents are **not evaluated or enforced**.

```
[ policy_any ]
countryName = optional
stateOrProvinceName = optional
organizationName = optional
commonName = supplied
```

This syntax is **accepted solely for configuration compatibility**;
no actual constraint checking is performed.

---

### A.9.5 Limitations of the `[ ca ]` Section in wolfCLU

wolfCLU’s CA processing differs from OpenSSL in the following ways:

- No certificate issuance database management
- No automatic serial number file updates
- No CRL generation or management
- No support for re-issuance or revocation workflows

As a result, the `[ ca ]` section is used strictly as a
**configuration mechanism for generating CA-signed certificates
in a simplified CA model**.

---

## A.10 Primary Commands Using `[ ca ]`

| Command | Use of the `[ ca ]` Section |
|--------|----------------------------|
| `x509` | Generation of CA-signed certificates |
| `req` | Signing CSRs with a CA |
