# Keys and Certificates

For an introduction to X.509 certificates, as well as how they are used in SSL and TLS, please see Appendix A.


## Supported Formats and Sizes

wolfSSL (formerly CyaSSL) has support for **PEM**, and **DER** formats for certificates and keys, as well as PKCS#8 private keys (with PKCS#5 or PKCS#12 encryption).

**PEM**, or “Privacy Enhanced Mail” is the most common format that certificates are issued in by certificate authorities. PEM files are Base64 encoded ASCII files which can include multiple server certificates, intermediate certificates, and private keys, and usually have a `.pem`, `.crt`, `.cer`, or `.key` file extension. Certificates inside PEM files are wrapped in the “`-----BEGIN CERTIFICATE-----`” and “`-----END CERTIFICATE-----`” statements.

**DER**, or “Distinguished Encoding Rules”, is a binary format of a certificate. DER file extensions can include `.der` and `.cer`, and cannot be viewed with a text editor.

An X.509 certificate is encoded using ASN.1 format. The DER format is the ASN.1 encoding. The PEM format is Base64 encoded and wrapped with a human readable header and footer. TLS send certificates in DER format.


## Certificate Loading

Certificates are normally loaded using the file system (although loading from memory buffers is supported as well - see [No File System and using Certificates](#no-file-system-and-using-certificates)).

### Loading CA Certificates**

CA certificate files can be loaded using the [`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations) function:

```c
int wolfSSL_CTX_load_verify_locations(WOLFSSL_CTX *ctx,
                                      const char *CAfile,
                                      const char *CApath);
```

CA loading can also parse multiple CA certificates per file using the above function by passing in a `CAfile` in PEM format with as many certs as possible. This makes initialization easier, and is useful when a client needs to load several root CAs at startup.  This makes wolfSSL easier to port into tools that expect to be able to use a single file for CAs.

**NOTE**: If you have to load a chain of Roots and Intermediate certificates you must load them in the order of trust. Load ROOT CA first followed by Intermediate 1 followed by Intermediate 2 and so on. You may call [`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations) for each cert to be loaded or just once with a file containing the certs in order (Root at the top of the file and certs ordered by the chain of trust)

### Loading Client or Server Certificates

Loading single client or server certificates can be done with the [`wolfSSL_CTX_use_certificate_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_file) function.  If this function is used with a certificate chain, only the actual, or “bottom” certificate will be sent.

```c
int wolfSSL_CTX_use_certificate_file(WOLFSSL_CTX *ctx,
                                     const char *CAfile,
                                     int type);
```

`CAfile` is the CA certificate file, and `type` is the format of the certificate - such as `SSL_FILETYPE_PEM`.

The server and client can send certificate chains using the [`wolfSSL_CTX_use_certificate_chain_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_chain_file) function.  The certificate chain file must be in PEM format and must be sorted starting with the subject's certificate (the actual client or server cert), followed by any intermediate certificates and ending (optionally) at the root "top" CA.  The example server (`/examples/server/server.c`) uses this functionality.

**NOTE**: This is the exact reverse of the order necessary when loading a certificate chain for verification! Your file contents in this scenario would be Entity cert at the top of the file followed by the next cert up the chain and so on with Root CA at the bottom of the file.

```c
int wolfSSL_CTX_use_certificate_chain_file(WOLFSSL_CTX *ctx,
                                 const char *file);
```

### Loading Private Keys

Server private keys can be loaded using the [`wolfSSL_CTX_use_PrivateKey_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_PrivateKey_file) function.

```c
int wolfSSL_CTX_use_PrivateKey_file(WOLFSSL_CTX *ctx,
                      const char *keyFile, int type);
```

`keyFile` is the private key file, and `type` is the format of the private key (e.g. `SSL_FILETYPE_PEM`).


### Loading Trusted Peer Certificates

Loading a trusted peer certificate to use can be done with [`wolfSSL_CTX_trust_peer_cert()`](group__Setup.md#function-wolfssl_ctx_trust_peer_cert).

```c
int wolfSSL_CTX_trust_peer_cert(WOLFSSL_CTX *ctx,
                 const char *trustCert, int type);
```

`trustCert` is the certificate file to load, and `type` is the format of the private key (i.e. `SSL_FILETYPE_PEM`).

## Certificate Chain Verification

wolfSSL requires that only the top or “root” certificate in a chain to be loaded as a trusted certificate in order to verify a certificate chain. This means that if you have a certificate chain (A -\> B -\> C), where C is signed by B, and B is signed by A, wolfSSL only requires that certificate A be loaded as a trusted certificate in order to verify the entire chain (A-\>B-\>C).

For example, if a server certificate chain looks like:

![Certificate Chain](certchain.png)

The wolfSSL client should already have at least the root cert (A) loaded as a trusted root (with [`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)).  When the client receives the server cert chain, it uses the signature of A to verify B, and if B has not been previously loaded into wolfSSL as a trusted root, B gets stored in wolfSSL's internal cert chain (wolfSSL just stores what is necessary to verify a certificate: common name hash, public key and key type, etc.).  If B is valid, then it is used to verify C.

Following this model, as long as root cert "A" has been loaded as a trusted root into the wolfSSL server, the server certificate chain will still be able to be verified if the server sends (A-\>B-\>C), or (B-\>C).  If the server just sends (C), and not the intermediate certificate, the chain will not be able to be verified unless the wolfSSL client has already loaded B as a trusted root.

## Domain Name Check for Server Certificates

wolfSSL has an extension on the client that automatically checks the domain of the server certificate. In OpenSSL mode nearly a dozen function calls are needed to perform this. wolfSSL checks that the date of the certificate is in range, verifies the signature, and additionally verifies the domain if you call [`wolfSSL_check_domain_name(WOLFSSL* ssl, const char* dn)`](group__Setup.md#function-wolfssl_check_domain_name) before calling [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect). wolfSSL will match the X.509 issuer name of peer's server certificate against `dn` (the expected domain name). If the names match [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) will proceed normally, however if there is a name mismatch, [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) will return a fatal error and [`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error) will return `DOMAIN_NAME_MISMATCH`.

Checking the domain name of the certificate is an important step that verifies the server is actually who it claims to be. This extension is intended to ease the burden of performing the check.

## No File System and using Certificates

Normally a file system is used to load private keys, certificates, and CAs. Since wolfSSL is sometimes used in environments without a full file system an extension to use memory buffers instead is provided. To use the extension define the constant `NO_FILESYSTEM` and the following functions will be made available:

* [`int wolfSSL_CTX_load_verify_buffer(WOLFSSL_CTX* ctx, const unsigned char* in,long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_buffer)
* [`int wolfSSL_CTX_use_certificate_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_buffer)
* [`int wolfSSL_CTX_use_PrivateKey_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_use_PrivateKey_buffer)
* [`int wolfSSL_CTX_use_certificate_chain_buffer(WOLFSSL_CTX* ctx, const unsigned char* in,long sz);`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_chain_buffer)
* [`int wolfSSL_CTX_trust_peer_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, Long sz, int format);`](group__Setup.md#function-wolfssl_ctx_trust_peer_buffer)

Use these functions exactly like their counterparts that are named `*_file` instead of `*_buffer`.  And instead of providing a filename provide a memory buffer.  See API documentation for usage details.

### Test Certificate and Key Buffers

wolfSSL has come bundled with test certificate and key files in the past.  Now it also comes bundled with test certificate and key buffers for use in environments with no filesystem available.  These buffers are available in `certs_test.h` when defining one or more of `USE_CERT_BUFFERS_1024`, `USE_CERT_BUFFERS_2048`, or `USE_CERT_BUFFERS_256`.

## Serial Number Retrieval

The serial number of an X.509 certificate can be extracted from wolfSSL using [`wolfSSL_X509_get_serial_number()`](group__openSSL.md#function-wolfssl_x509_get_serial_number).  The serial number can be of any length.

```c
int wolfSSL_X509_get_serial_number(WOLFSSL_X509* x509,
            unsigned char* buffer, int* inOutSz)
```

`buffer` will be written to with at most `*inOutSz` bytes on input. After the call, if successful (return of 0), `*inOutSz` will hold the actual number of bytes written to `buffer`. A full example is included `wolfssl/test.h`.

## RSA Key Generation

wolfSSL supports RSA key generation of varying lengths up to 4096 bits. Key generation is off by default but can be turned on during the `./configure` process with `--enable-keygen` or by defining `WOLFSSL_KEY_GEN` in Windows or non-standard environments. Creating a key is easy, only requiring one function from `rsa.h`:

```c
int MakeRsaKey(RsaKey* key, int size, long e, RNG* rng);
```

Where `size` is the length in bits and `e` is the public exponent, using 65537 is usually a good choice for `e`. The following from `wolfcrypt/test/test.c` gives an example creating an RSA key of 1024 bits:

```c
RsaKey genKey;
RNG    rng;
int    ret;

InitRng(&rng);
InitRsaKey(&genKey, 0);

ret = MakeRsaKey(&genKey, 1024, 65537, &rng);
if (ret != 0)
    /* ret contains error */;
```

The RsaKey `genKey` can now be used like any other RsaKey. If you need to export the key, wolfSSL provides both DER and PEM formatting in asn.h. Always convert the key to DER format first, and then if you need PEM use the generic `DerToPem()` function like this:

```c
byte der[4096];
int  derSz = RsaKeyToDer(&genKey, der, sizeof(der));
if (derSz < 0)
    /* derSz contains error */;
```

The buffer `der` now holds a DER format of the key. To convert the DER buffer to PEM use the conversion function:

```c
byte pem[4096];
int  pemSz = DerToPem(der, derSz, pem, sizeof(pem),
                      PRIVATEKEY_TYPE);
if (pemSz < 0)
    /* pemSz contains error */;
```

The last argument of _DerToPem()_ takes a type parameter, usually either `PRIVATEKEY_TYPE` or `CERT_TYPE`. Now the buffer `pem` holds the PEM format of the key. Supported types are:

* `CA_TYPE`
* `TRUSTED_PEER_TYPE`
* `CERT_TYPE`
* `CRL_TYPE`
* `DH_PARAM_TYPE`
* `DSA_PARAM_TYPE`
* `CERTREQ_TYPE`
* `DSA_TYPE`
* `DSA_PRIVATEKEY_TYPE`
* `ECC_TYPE`
* `ECC_PRIVATEKEY_TYPE`
* `RSA_TYPE`
* `PRIVATEKEY_TYPE`
* `ED25519_TYPE`
* `EDDSA_PRIVATEKEY_TYPE`
* `PUBLICKEY_TYPE`
* `ECC_PUBLICKEY_TYPE`
* `PKCS8_PRIVATEKEY_TYPE`
* `PKCS8_ENC_PRIVATEKEY_TYPE`

### RSA Key Generation Notes

The RSA private key contains the public key as well.  The private key can be used as both a private and public key by wolfSSL as used in test.c. The private key and the public key (in the form of a certificate) is all that is typically needed for SSL.

A separate public key can be loaded into wolfSSL manually using the RsaPublicKeyDecode() function if need be. Additionally, the [`wc_RsaKeyToPublicDer()`](group__RSA.md#function-wc_rsakeytopublicder) function can be used to export the public RSA key.

## Certificate Generation

wolfSSL supports X.509 v3 certificate generation. Certificate generation is off by default but can be turned on during the `./configure` process with `--enable-certgen` or by defining `WOLFSSL_CERT_GEN` in Windows or non-standard environments.

Before a certificate can be generated the user needs to provide information about the subject of the certificate. This information is contained in a structure from `wolfssl/wolfcrypt/asn_public.h` named `Cert`:

```c
/* for user to fill for certificate generation */
typedef struct Cert {
    int      version;                   /* x509 version  */
    byte     serial[CTC_SERIAL_SIZE];   /* serial number */
    int      sigType;                   /*signature algo type */
    CertName issuer;                    /* issuer info */
    int      daysValid;                 /* validity days */
    int      selfSigned;                /* self signed flag */
    CertName subject;                   /* subject info */
    int      isCA;                      /*is this going to be a CA*/
    ...
} Cert;
```

Where CertName looks like:

```c
typedef struct CertName {
char country[CTC_NAME_SIZE];
	char countryEnc;
	char state[CTC_NAME_SIZE];
	char stateEnc;
	char locality[CTC_NAME_SIZE];
	char localityEnc;
	char sur[CTC_NAME_SIZE];
	char surEnc;
	char org[CTC_NAME_SIZE];
	char orgEnc;
	char unit[CTC_NAME_SIZE];
	char unitEnc;
	char commonName[CTC_NAME_SIZE];
	char commonNameEnc;
	char email[CTC_NAME_SIZE];  /* !!!! email has to be last!!!! */
} CertName;
```

Before filling in the subject information an initialization function needs to be called like this:

```c
Cert myCert;
InitCert(&myCert);
```

`InitCert()` sets defaults for some of the variables including setting the version to **3** (0x02), the serial number to **0** (randomly generated), the sigType to `CTC_SHAwRSA`, the daysValid to **500**, and selfSigned to **1** (TRUE). Supported signature types include:

* `CTC_SHAwDSA`
* `CTC_MD2wRSA`
* `CTC_MD5wRSA`
* `CTC_SHAwRSA`
* `CTC_SHAwECDSA`
* `CTC_SHA256wRSA`
* `CTC_SHA256wECDSA`
* `CTC_SHA384wRSA`
* `CTC_SHA384wECDSA`
* `CTC_SHA512wRSA`
* `CTC_SHA512wECDSA`

Now the user can initialize the subject information like this example from `wolfcrypt/test/test.c`:

```c
strncpy(myCert.subject.country, "US", CTC_NAME_SIZE);
strncpy(myCert.subject.state, "OR", CTC_NAME_SIZE);
strncpy(myCert.subject.locality, "Portland", CTC_NAME_SIZE);
strncpy(myCert.subject.org, "yaSSL", CTC_NAME_SIZE);
strncpy(myCert.subject.unit, "Development", CTC_NAME_SIZE);
strncpy(myCert.subject.commonName, "www.wolfssl.com", CTC_NAME_SIZE);
strncpy(myCert.subject.email, "info@wolfssl.com", CTC_NAME_SIZE);
```

Then, a self-signed certificate can be generated using the variables genKey and rng from the above key generation example (of course any valid RsaKey or RNG can be used):

```c
byte derCert[4096];

int certSz = MakeSelfCert(&myCert, derCert, sizeof(derCert), &key, &rng);
if (certSz < 0)
  /* certSz contains the error */;
```

The buffer `derCert` now contains a DER format of the certificate. If you need a PEM format of the certificate you can use the generic `DerToPem()` function and specify the type to be `CERT_TYPE` like this:

```c
byte* pem;

int pemSz = DerToPem(derCert, certSz, pem, sizeof(pemCert), CERT_TYPE);
if (pemCertSz < 0)
  /* pemCertSz contains error */;
```

Supported types are:

* `CA_TYPE`
* `TRUSTED_PEER_TYPE`
* `CERT_TYPE`
* `CRL_TYPE`
* `DH_PARAM_TYPE`
* `DSA_PARAM_TYPE`
* `CERTREQ_TYPE`
* `DSA_TYPE`
* `DSA_PRIVATEKEY_TYPE`
* `ECC_TYPE`
* `ECC_PRIVATEKEY_TYPE`
* `RSA_TYPE`
* `PRIVATEKEY_TYPE`
* `ED25519_TYPE`
* `EDDSA_PRIVATEKEY_TYPE`
* `PUBLICKEY_TYPE`
* `ECC_PUBLICKEY_TYPE`
* `PKCS8_PRIVATEKEY_TYPE`
* `PKCS8_ENC_PRIVATEKEY_TYPE`

Now the buffer `pemCert<` holds the PEM format of the certificate.

If you wish to create a CA signed certificate then a couple of steps are required. After filling in the subject information as before, you’ll need to set the issuer information from the CA certificate.  This can be done with `SetIssuer()` like this:

```c
ret = SetIssuer(&myCert, "ca-cert.pem");
if (ret < 0)
	/* ret contains error */;
```

Then you’ll need to perform the two-step process of creating the certificate and then signing it (`MakeSelfCert()` does these both in one step). You’ll need the private keys from both the issuer (`caKey`) and the subject (`key`). Please see the example in `test.c` for complete usage.

```c
byte derCert[4096];

int certSz = MakeCert(&myCert, derCert, sizeof(derCert), &key, NULL, &rng);
if (certSz < 0);
   /*certSz contains the error*/;

certSz = SignCert(myCert.bodySz, myCert.sigType, derCert,
            sizeof(derCert), &caKey, NULL, &rng);
if (certSz < 0);
   /*certSz contains the error*/;
```

The buffer `derCert` now contains a DER format of the CA signed certificate.  If you need a PEM format of the certificate please see the self signed example above.  Note that `MakeCert()` and `SignCert()` provide function parameters for either an RSA or ECC key to be used.  The above example uses an RSA key and passes NULL for the ECC key parameter.

## Certificate Signing Request (CSR) Generation

wolfSSL supports X.509 v3 certificate signing request (CSR) generation. CSR generation is off by default but can be turned on during the `./configure` process with `--enable-certreq --enable-certgen` or by defining `WOLFSSL_CERT_GEN` **and** `WOLFSSL_CERT_REQ` in Windows or non-standard environments.

Before a CSR can be generated the user needs to provide information about the subject of the certificate. This information is contained in a structure from `wolfssl/wolfcrypt/asn_public.h` named `Cert`:

For details on the Cert and CertName structures please reference [Certificate Generation](#certificat-generation) above.

Before filling in the subject information an initialization function needs to be called like this:

```c
Cert request;
InitCert(&request);
```

`InitCert()` sets defaults for some of the variables including setting the version to **3** (0x02), the serial number to **0** (randomly generated), the sigType to `CTC_SHAwRSA`, the daysValid to **500**, and selfSigned to **1** (TRUE). Supported signature types include:


* `CTC_SHAwDSA`
* `CTC_MD2wRSA`
* `CTC_MD5wRSA`
* `CTC_SHAwRSA`
* `CTC_SHAwECDSA`
* `CTC_SHA256wRSA`
* `CTC_SHA256wECDSA`
* `CTC_SHA384wRSA`
* `CTC_SHA384wECDSA`
* `CTC_SHA512wRSA`
* `CTC_SHA512wECDSA`

Now the user can initialize the subject information like this example from <https://github.com/wolfSSL/wolfssl-examples/blob/master/certgen/csr_example.c>:

```c
strncpy(req.subject.country, "US", CTC_NAME_SIZE);
strncpy(req.subject.state, "OR", CTC_NAME_SIZE);
strncpy(req.subject.locality, "Portland", CTC_NAME_SIZE);
strncpy(req.subject.org, "wolfSSL", CTC_NAME_SIZE);
strncpy(req.subject.unit, "Development", CTC_NAME_SIZE);
strncpy(req.subject.commonName, "www.wolfssl.com", CTC_NAME_SIZE);
strncpy(req.subject.email, "info@wolfssl.com", CTC_NAME_SIZE);
```

Then, a valid signed CSR can be generated using the variable key from the above key generation example (of course any valid ECC/RSA key or RNG can be used):

```c
byte der[4096]; /* Store request in der format once made */

ret = wc_MakeCertReq(&request, der, sizeof(der), NULL, &key);
/* check ret value for error handling, <= 0 indicates a failure */
```

Next you will want to sign your request making it valid, use the rng variable from the above key generation example. (of course any valid ECC/RSA key or RNG can be used)

```c
derSz = ret;

req.sigType = CTC_SHA256wECDSA;
ret = wc_SignCert(request.bodySz, request.sigType, der, sizeof(der), NULL, &key, &rng);
/* check ret value for error handling, <= 0 indicates a failure */
```

Lastly it is time to convert the CSR to PEM format for sending to a CA authority to use in issueing a certificate:

```c
ret = wc_DerToPem(der, derSz, pem, sizeof(pem), CERTREQ_TYPE);
/* check ret value for error handling, <= 0 indicates a failure */
printf("%s", pem); /* or write to a file */
```


### Limitations

There are fields that are mandatory in a certificate that are excluded in a CSR. There are other fields in a CSR that are also deemed “optional” that are otherwise mandatory when in a certificate. Because of this the wolfSSL certificate parsing engine, which strictly checks all certificate fields AND considers all fields mandatory, does not support consuming a CSR at this time. Therefore while CSR generation AND certificate generation from scratch are supported, wolfSSL does not support certificate generation FROM a CSR. Passing in a CSR to the wolfSSL parsing engine will return a failure at this time. Check back for updates once we support consuming a CSR for use in certificate generation!

**See also**: [Certificate Generation](#certificate-generation)


## Convert to raw ECC key

With our recently added support for raw ECC key import comes the ability to convert an ECC key from PEM to DER. Use the following with the specified arguments to accomplish this:

```c
EccKeyToDer(ecc_key*, byte* output, word32 inLen);
```

### Example

```c
#define FOURK_BUF 4096
byte  der[FOURK_BUF];
ecc_key userB;

EccKeyToDer(&userB, der, FOURK_BUF);
```
