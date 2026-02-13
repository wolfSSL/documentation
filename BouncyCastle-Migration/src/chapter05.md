# Bouncy Castle Proprietary API Migration Examples

Chapters 3 and 4 cover migration of standard JCE and JSSE API usage where the
primary change is swapping the provider name. This chapter addresses migration
of code that uses Bouncy Castle's proprietary (non-standard) APIs directly,
such as classes under `org.bouncycastle.asn1.*`, `org.bouncycastle.cert.*`,
and `org.bouncycastle.crypto.*`. These cases require more significant code
changes since there is no standard Java API equivalent.

## Bouncy Castle Equivalent Functionality Gaps

wolfSSL provides functionally equivalent implementations of a subset of
Bouncy Castle API use through the classes and related APIs mentioned below.

If the Bouncy Castle functionality equivalents you are using are missing
from wolfSSL JNI/JSSE or wolfCrypt JNI/JCE, please contact **wolfSSL support
(support@wolfssl.com)** to request the feature(s) be added.

## X.509 Certificate Extensions

The following sections cover migration of Bouncy Castle code that parses
X.509 certificate extensions using `org.bouncycastle.asn1.*` and
`org.bouncycastle.cert.*` classes. wolfSSL handles ASN.1 extension parsing
internally in native code and exposes the results through the
`WolfSSLCertificate` class and its associated types. In each case, the
multi-step ASN.1 decoding required by Bouncy Castle is replaced by direct
method calls on `WolfSSLCertificate`.

### Name Constraint Validation

A common use of the Bouncy Castle proprietary API is parsing X.509 Name
Constraints extensions and validating certificate names against permitted and
excluded subtrees. Bouncy Castle exposes this through its ASN.1 and PKI
validation classes. wolfSSL provides equivalent functionality through the
`WolfSSLCertificate` and `WolfSSLNameConstraints` classes.

#### Bouncy Castle Approach

Bouncy Castle Name Constraint validation is a multi-step process involving
parsing raw extension bytes, constructing a validator object, populating it
with subtrees, and then checking names against the validator.

**Parsing the Name Constraints extension:**

```java
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.NameConstraints;
import org.bouncycastle.cert.jcajce.JcaX509ExtensionUtils;

/* Get raw extension bytes from a X509Certificate */
byte[] extensionValue =
    certificate.getExtensionValue(Extension.nameConstraints.getId());

/* Unwrap the OCTET STRING, parse the ASN.1 structure */
NameConstraints nameConstraints = NameConstraints.getInstance(
    JcaX509ExtensionUtils.parseExtensionValue(extensionValue));
```

**Building and populating the validator:**

```java
import org.bouncycastle.asn1.x509.PKIXNameConstraintValidator;

PKIXNameConstraintValidator validator = new PKIXNameConstraintValidator();

/* Add permitted subtrees */
if (nameConstraints.getPermittedSubtrees() != null) {
    validator.intersectPermittedSubtree(
        nameConstraints.getPermittedSubtrees());
}

/* Add excluded subtrees */
if (nameConstraints.getExcludedSubtrees() != null) {
    for (int i = 0;
         i < nameConstraints.getExcludedSubtrees().length; i++) {
        validator.addExcludedSubtree(
            nameConstraints.getExcludedSubtrees()[i]);
    }
}
```

**Checking a name against the constraints:**

```java
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.x509.NameConstraintValidatorException;

try {
    validator.checkPermitted(name);
    validator.checkExcluded(name);
    /* Name is valid */
} catch (NameConstraintValidatorException e) {
    /* Name violates constraints */
}
```

#### wolfSSL Approach

wolfSSL handles ASN.1 parsing and constraint management internally in native
code. Rather than manually extracting the extension, parsing it, and building
a validator, the `WolfSSLCertificate` class parses all extensions when the
certificate is loaded, and `WolfSSLNameConstraints` provides a single method
to check a name against both permitted and excluded subtrees.

**Parsing the Name Constraints from a certificate:**

```java
import com.wolfssl.WolfSSLCertificate;
import com.wolfssl.WolfSSLNameConstraints;

WolfSSLCertificate wolfCert = null;
try {
    wolfCert = new WolfSSLCertificate(certificate.getEncoded());
    WolfSSLNameConstraints nc = wolfCert.getNameConstraints();

    /* nc is null if the certificate has no Name Constraints extension */
    if (nc != null) {
        /* use nc for validation (see below) */
    }
} finally {
    if (wolfCert != null) {
        wolfCert.free();
    }
}
```

**Checking a name against the constraints:**

```java
/* Checks both permitted and excluded subtrees in a single call.
 * Returns true if the name satisfies all constraints. */
boolean allowed = nc.checkName(name.getType(), name.getValue());
```

### Extracting Name Constraint Subtree Values

Beyond validating names, applications often need to extract and display the
permitted or excluded subtree values from a certificate's Name Constraints
extension. With Bouncy Castle this requires manually decoding each
`GeneralSubtree` entry, handling different GeneralName types (DNS names, IP
addresses, etc.) individually. IP address constraints are particularly
involved since they are encoded as raw ASN.1 octets containing both the
address and subnet mask, which must be split and converted separately.

#### Bouncy Castle Approach

**Getting the subtree list from a parsed NameConstraints:**

```java
import org.bouncycastle.asn1.x509.GeneralSubtree;

/* After parsing NameConstraints (see previous section) */
GeneralSubtree[] permitted = nameConstraints.getPermittedSubtrees();
GeneralSubtree[] excluded = nameConstraints.getExcludedSubtrees();
```

**Extracting the value from a GeneralSubtree entry:**

For most GeneralName types (DNS, email, URI, etc.), the value can be obtained
by calling `toString()` on the name. IP address constraints require additional
decoding since the value is stored as a DER-encoded octet string containing
both the IP address and subnet mask concatenated together:

```java
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.DEROctetString;
import java.net.InetAddress;

GeneralName name = subtree.getBase();

if (name.getTagNo() == GeneralName.iPAddress) {
    /* IP constraints are encoded as raw octets: [address | mask] */
    byte[] octets = DEROctetString.getInstance(
        name.getName().toASN1Primitive()).getOctets();

    /* Split octets in half: first half is IP, second half is subnet mask */
    byte[] ipBytes = Arrays.copyOf(octets, octets.length / 2);
    byte[] maskBytes = Arrays.copyOfRange(
        octets, octets.length / 2, octets.length);

    String ip = InetAddress.getByAddress(ipBytes).getHostAddress();
    String mask = InetAddress.getByAddress(maskBytes).getHostAddress();
    /* Result example: "192.168.1.0/255.255.255.0" */

} else {
    /* DNS names, email, URIs, etc. */
    String value = name.getName().toString();
}
```

#### wolfSSL Approach

wolfSSL handles the ASN.1 decoding internally, including IP address and
subnet mask formatting. `WolfSSLNameConstraints` returns subtree entries as
`WolfSSLGeneralName` objects whose `getValue()` method returns a pre-formatted
string regardless of the GeneralName type.

**Getting subtree values:**

```java
import com.wolfssl.WolfSSLCertificate;
import com.wolfssl.WolfSSLNameConstraints;
import com.wolfssl.WolfSSLGeneralName;
import java.util.List;

WolfSSLCertificate wolfCert = null;
try {
    wolfCert = new WolfSSLCertificate(certificate.getEncoded());
    WolfSSLNameConstraints nc = wolfCert.getNameConstraints();

    if (nc != null) {
        List<WolfSSLGeneralName> permitted = nc.getPermittedSubtrees();
        List<WolfSSLGeneralName> excluded = nc.getExcludedSubtrees();
    }
} finally {
    if (wolfCert != null) {
        wolfCert.free();
    }
}
```

**Extracting the value from a subtree entry:**

```java
/* getValue() returns a formatted string for all GeneralName types,
 * including IP address constraints with subnet mask. No manual
 * ASN.1 decoding needed. */
String value = generalName.getValue();
```

### Authority Information Access (AIA) Extension Parsing

The AIA extension in X.509 certificates contains URIs for OCSP responders
and CA Issuer locations (used to download intermediate certificates for chain
building). With Bouncy Castle, parsing AIA requires unwrapping the extension
bytes, casting through several ASN.1 types, iterating over `AccessDescription`
entries, and filtering by access method OID. wolfSSL parses the AIA extension
internally and provides direct access to the URI lists.

#### Bouncy Castle Approach

**Parsing the AIA extension:**

```java
import org.bouncycastle.asn1.ASN1Primitive;
import org.bouncycastle.asn1.x509.AccessDescription;
import org.bouncycastle.asn1.x509.AuthorityInformationAccess;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.x509.X509ObjectIdentifiers;
import org.bouncycastle.cert.jcajce.JcaX509ExtensionUtils;

byte[] aiaValue =
    certificate.getExtensionValue(Extension.authorityInfoAccess.getId());

ASN1Primitive extensionValue =
    JcaX509ExtensionUtils.parseExtensionValue(aiaValue);

AuthorityInformationAccess aia =
    AuthorityInformationAccess.getInstance(extensionValue);
```

**Extracting CA Issuer URIs:**

```java
for (AccessDescription ad : aia.getAccessDescriptions()) {
    if (ad.getAccessMethod().equals(
            X509ObjectIdentifiers.id_ad_caIssuers)) {
        GeneralName location = ad.getAccessLocation();
        String url = location.getName().toString();
        /* url contains a CA Issuer URI, e.g. "http://ca.example.com/ca.pem" */
    }
}
```

**Extracting OCSP responder URIs:**

```java
for (AccessDescription ad : aia.getAccessDescriptions()) {
    if (ad.getAccessMethod().equals(
            X509ObjectIdentifiers.id_ad_ocsp)) {
        GeneralName location = ad.getAccessLocation();
        String url = location.getName().toString();
        /* url contains an OCSP responder URI */
    }
}
```

#### wolfSSL Approach

`WolfSSLCertificate` parses the AIA extension when the certificate is loaded
and provides separate methods for retrieving CA Issuer URIs and OCSP responder
URIs. No manual ASN.1 parsing or OID filtering is needed.

**Extracting CA Issuer URIs:**

```java
import com.wolfssl.WolfSSLCertificate;

WolfSSLCertificate wolfCert = null;
try {
    wolfCert = new WolfSSLCertificate(certificate.getEncoded());

    String[] caIssuers = wolfCert.getCaIssuerUris();
    if (caIssuers != null) {
        for (String url : caIssuers) {
            /* url contains a CA Issuer URI */
        }
    }
} finally {
    if (wolfCert != null) {
        wolfCert.free();
    }
}
```

**Extracting OCSP responder URIs:**

```java
String[] ocspUris = wolfCert.getOcspUris();
if (ocspUris != null) {
    for (String url : ocspUris) {
        /* url contains an OCSP responder URI */
    }
}
```

**Checking for AIA overflow:**

The native wolfSSL library has an internal limit on the number of AIA URIs
it can parse from a single certificate. Applications handling certificates
with unusually large numbers of AIA entries should check for overflow:

```java
int overflow = wolfCert.getAiaOverflow();
if (overflow == 1) {
    /* AIA URI list was truncated, certificate has more URIs
     * than the internal buffer can hold */
}
```

### Subject Alternative Name (SAN) Parsing

Applications commonly need to extract Subject Alternative Name values from
client certificates for identity mapping, authorization decisions, or display.
With Bouncy Castle, SAN parsing (especially for non-String types like
`otherName`) requires manual ASN.1 decoding using `ASN1InputStream`,
`ASN1Sequence`, and `ASN1TaggedObject`. This is particularly problematic
with certificates issued by Microsoft Active Directory, which encodes User
Principal Names (UPNs) as `otherName` entries with a Microsoft-specific OID.

wolfSSL provides `WolfSSLAltName` objects that handle ASN.1 decoding
internally, with explicit support for Microsoft AD UPN entries.

#### Bouncy Castle Approach

The standard JCE method `X509Certificate.getSubjectAlternativeNames()` returns
SAN entries as a `Collection<List<?>>` where each entry is a list containing
an integer type and a value. For simple string types (DNS, email, URI) the
value is a `String`. However, for `otherName` entries (type 0), the value is
returned as a raw `byte[]` requiring manual ASN.1 decoding:

**Extracting string-based SAN types (DNS, email, URI):**

```java
import java.security.cert.X509Certificate;
import java.util.Collection;
import java.util.List;

Collection<List<?>> sans = certificate.getSubjectAlternativeNames();
if (sans != null) {
    for (List<?> san : sans) {
        int type = (Integer) san.get(0);
        if (type == 1 || type == 2 || type == 6) {
            /* rfc822Name (1), dNSName (2), URI (6) */
            String value = (String) san.get(1);
        }
    }
}
```

**Decoding otherName entries (e.g., Microsoft AD UPN):**

When the SAN value is an `otherName` (type 0), the JCE API returns the raw
DER-encoded bytes. Bouncy Castle ASN.1 classes are typically used to decode
these:

```java
import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.ASN1Encodable;
import org.bouncycastle.asn1.ASN1Sequence;
import org.bouncycastle.asn1.ASN1TaggedObject;

for (List<?> san : sans) {
    int type = (Integer) san.get(0);

    if (type == 0 && san.get(1) instanceof byte[]) {
        /* otherName: requires ASN.1 decoding */
        ASN1InputStream decoder =
            new ASN1InputStream((byte[]) san.get(1));
        ASN1Encodable encoded = decoder.readObject();

        /* Navigate the ASN.1 structure:
         * SEQUENCE { OID, [0] EXPLICIT value } */
        ASN1Encodable value =
            ((ASN1Sequence) encoded).getObjectAt(1);
        String name =
            ((ASN1TaggedObject) value).getBaseObject().toString();
        decoder.close();
    }
}
```

This approach is fragile, the ASN.1 structure must be navigated by position,
casting can fail for unexpected encodings, and different certificate issuers
(particularly Microsoft AD) may encode values in subtly different ways.

#### wolfSSL Approach

`WolfSSLCertificate.getSubjectAltNamesArray()` returns `WolfSSLAltName`
objects that provide type-safe access to all SAN types. The `WolfSSLAltName`
class handles ASN.1 decoding internally and includes explicit support for
Microsoft AD UPN detection.

**Iterating over SAN entries by type:**

```java
import com.wolfssl.WolfSSLCertificate;
import com.wolfssl.WolfSSLAltName;

WolfSSLCertificate wolfCert = null;
try {
    wolfCert = new WolfSSLCertificate(certificate.getEncoded());
    WolfSSLAltName[] sans = wolfCert.getSubjectAltNamesArray();

    if (sans != null) {
        for (WolfSSLAltName san : sans) {
            switch (san.getType()) {
                case WolfSSLAltName.TYPE_DNS_NAME:
                case WolfSSLAltName.TYPE_RFC822_NAME:
                case WolfSSLAltName.TYPE_URI:
                    String value = san.getStringValue();
                    break;
                case WolfSSLAltName.TYPE_IP_ADDRESS:
                    String ip = san.getIPAddressString();
                    break;
                case WolfSSLAltName.TYPE_OTHER_NAME:
                    String otherValue =
                        san.getOtherNameValueAsString();
                    break;
            }
        }
    }
} finally {
    if (wolfCert != null) {
        wolfCert.free();
    }
}
```

**Detecting and extracting Microsoft AD UPN entries:**

`WolfSSLAltName` provides `isMicrosoftUPN()` which checks for the Microsoft
UPN OID (`1.3.6.1.4.1.311.20.2.3`) and `getOtherNameValueAsString()` which
decodes the ASN.1 UTF8String value:

```java
for (WolfSSLAltName san : sans) {
    if (san.isMicrosoftUPN()) {
        String upn = san.getOtherNameValueAsString();
        /* upn contains the User Principal Name, e.g. "user@domain.com" */
    }
}
```

For other `otherName` types, the OID and raw value can be inspected directly:

```java
if (san.getType() == WolfSSLAltName.TYPE_OTHER_NAME) {
    String oid = san.getOtherNameOID();
    String value = san.getOtherNameValueAsString();
    byte[] rawDer = san.getOtherNameValue();
}
```

## RSA Encryption, Decryption, and Signing

Applications using the Bouncy Castle crypto API for RSA operations
(`RSAEngine`, `PKCS1Encoding`, `RSADigestSigner`, `PublicKeyFactory`,
`PrivateKeyFactory`) can migrate to standard JCE APIs backed by wolfJCE. The
Bouncy Castle API provides its own key representations
(`AsymmetricKeyParameter`) and low-level cipher/signer objects, while the JCE
equivalents use standard `java.security` and `javax.crypto` interfaces.

### Bouncy Castle Approach

**RSA encryption with PKCS#1 v1.5 padding:**

```java
import org.bouncycastle.crypto.encodings.PKCS1Encoding;
import org.bouncycastle.crypto.engines.RSAEngine;
import org.bouncycastle.crypto.params.AsymmetricKeyParameter;
import org.bouncycastle.crypto.util.PublicKeyFactory;

/* Convert raw public key bytes to BC key parameter type */
AsymmetricKeyParameter pubKeyParam = PublicKeyFactory.createKey(publicKeyBytes);

/* Initialize RSA engine with PKCS#1 padding for encryption */
PKCS1Encoding rsaEngine = new PKCS1Encoding(new RSAEngine());
rsaEngine.init(true, pubKeyParam);
byte[] ciphertext = rsaEngine.processBlock(plaintext, 0, plaintext.length);
```

**RSA decryption:**

```java
import org.bouncycastle.crypto.util.PrivateKeyFactory;

/* Convert standard PrivateKey to BC key parameter type */
AsymmetricKeyParameter privKeyParam =
    PrivateKeyFactory.createKey(privateKey.getEncoded());

PKCS1Encoding rsaEngine = new PKCS1Encoding(new RSAEngine());
rsaEngine.init(false, privKeyParam);
byte[] plaintext = rsaEngine.processBlock(ciphertext, 0, ciphertext.length);
```

**RSA signing with SHA-512:**

```java
import org.bouncycastle.crypto.signers.RSADigestSigner;
import org.bouncycastle.crypto.digests.SHA512Digest;

RSADigestSigner signer = new RSADigestSigner(new SHA512Digest());
signer.init(true, PrivateKeyFactory.createKey(privateKey.getEncoded()));
signer.update(data, 0, data.length);
byte[] signature = signer.generateSignature();
```

**RSA signature verification:**

```java
import org.bouncycastle.crypto.digests.SHA256Digest;

/* Use SHA256Digest or SHA512Digest depending on the algorithm */
RSADigestSigner verifier = new RSADigestSigner(new SHA256Digest());
verifier.init(false, PublicKeyFactory.createKey(publicKey.getEncoded()));
verifier.update(data, 0, data.length);
boolean valid = verifier.verifySignature(signature);
```

### wolfJCE Approach

All of these operations map directly to standard JCE classes. No proprietary
key conversions or engine wrappers are needed - standard
`java.security.PublicKey` and `java.security.PrivateKey` objects are used
directly.

**RSA encryption with PKCS#1 v1.5 padding:**

```java
import javax.crypto.Cipher;
import java.security.KeyFactory;
import java.security.spec.X509EncodedKeySpec;

/* Convert raw public key bytes to standard PublicKey */
KeyFactory kf = KeyFactory.getInstance("RSA", "wolfJCE");
PublicKey pubKey = kf.generatePublic(new X509EncodedKeySpec(publicKeyBytes));

Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding", "wolfJCE");
cipher.init(Cipher.ENCRYPT_MODE, pubKey);
byte[] ciphertext = cipher.doFinal(plaintext);
```

**RSA decryption:**

```java
Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding", "wolfJCE");
cipher.init(Cipher.DECRYPT_MODE, privateKey);
byte[] plaintext = cipher.doFinal(ciphertext);
```

**RSA signing with SHA-512:**

```java
import java.security.Signature;

Signature sig = Signature.getInstance("SHA512withRSA", "wolfJCE");
sig.initSign(privateKey);
sig.update(data);
byte[] signature = sig.sign();
```

**RSA signature verification:**

```java
/* Use "SHA256withRSA" or "SHA512withRSA" depending on the algorithm */
Signature sig = Signature.getInstance("SHA256withRSA", "wolfJCE");
sig.initVerify(publicKey);
sig.update(data);
boolean valid = sig.verify(signature);
```

## Hex String Encoding and Decoding

Bouncy Castle provides hex encoding utilities in
`org.bouncycastle.util.encoders.Hex` that are commonly used for logging,
debugging, and formatting cryptographic values such as key fingerprints,
hash digests, and certificate serial numbers. wolfSSL provides equivalent
methods in the `com.wolfssl.WolfCrypt` class.

### Bouncy Castle Approach

```java
import org.bouncycastle.util.encoders.Hex;

/* Byte array to hex string */
String hexStr = Hex.toHexString(data);

/* Hex string to byte array */
byte[] decoded = Hex.decode(hexStr);
```

### wolfSSL Approach

```java
import com.wolfssl.wolfcrypt.WolfCrypt;

/* Byte array to hex string */
String hexStr = WolfCrypt.toHexString(data);

/* Hex string to byte array */
byte[] decoded = WolfCrypt.hexStringToByteArray(hexStr);
```

## PEM to DER Conversion

Bouncy Castle `PEMParser` is commonly used to read PEM-encoded keys and
certificates, extract the underlying ASN.1 structure, and obtain the DER
encoding. This involves parsing the PEM object, casting to the appropriate
Bouncy Castle type (`PEMKeyPair`, `X509CertificateHolder`,
`SubjectPublicKeyInfo`, etc.), and then calling `getEncoded()`.

wolfCrypt provides direct PEM-to-DER conversion methods in the `WolfCrypt`
class that handle the PEM parsing and DER extraction in a single call.

### Private Key

**Bouncy Castle:**

```java
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.PEMKeyPair;

PEMParser parser = new PEMParser(new FileReader("key.pem"));
PEMKeyPair keyPair = (PEMKeyPair) parser.readObject();
byte[] der = keyPair.getPrivateKeyInfo().getEncoded();
```

**wolfCrypt:**

```java
import com.wolfssl.wolfcrypt.WolfCrypt;
import java.nio.file.Files;
import java.nio.file.Paths;

byte[] pem = Files.readAllBytes(Paths.get("key.pem"));
byte[] der = WolfCrypt.keyPemToDer(pem, null);
```

### Encrypted Private Key (PKCS#8)

Bouncy Castle requires building a decryptor provider and decrypting through
the PKCS#8 layer before obtaining the DER encoding. wolfCrypt accepts the
password directly.

**Bouncy Castle:**

```java
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.pkcs.PKCS8EncryptedPrivateKeyInfo;
import org.bouncycastle.openssl.jcajce.JceOpenSSLPKCS8DecryptorProviderBuilder;
import org.bouncycastle.operator.InputDecryptorProvider;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;

PEMParser parser = new PEMParser(new FileReader("key.pem"));
PKCS8EncryptedPrivateKeyInfo encInfo =
    (PKCS8EncryptedPrivateKeyInfo) parser.readObject();

JceOpenSSLPKCS8DecryptorProviderBuilder builder =
    new JceOpenSSLPKCS8DecryptorProviderBuilder();
InputDecryptorProvider decryptor =
    builder.build("password".toCharArray());

PrivateKeyInfo keyInfo = encInfo.decryptPrivateKeyInfo(decryptor);
byte[] der = keyInfo.getEncoded();
```

**wolfCrypt:**

```java
import com.wolfssl.wolfcrypt.WolfCrypt;

byte[] pem = Files.readAllBytes(Paths.get("key.pem"));
byte[] der = WolfCrypt.keyPemToDer(pem, "password");
```

### Certificate

**Bouncy Castle:**

```java
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.cert.X509CertificateHolder;

PEMParser parser = new PEMParser(new FileReader("cert.pem"));
X509CertificateHolder holder =
    (X509CertificateHolder) parser.readObject();
byte[] der = holder.getEncoded();
```

**wolfCrypt:**

```java
import com.wolfssl.wolfcrypt.WolfCrypt;

byte[] pem = Files.readAllBytes(Paths.get("cert.pem"));
byte[] der = WolfCrypt.certPemToDer(pem);
```

### Public Key

**Bouncy Castle:**

```java
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;

PEMParser parser = new PEMParser(new FileReader("pubkey.pem"));
SubjectPublicKeyInfo pubKeyInfo =
    (SubjectPublicKeyInfo) parser.readObject();
byte[] der = pubKeyInfo.getEncoded();
```

**wolfCrypt:**

```java
import com.wolfssl.wolfcrypt.WolfCrypt;

byte[] pem = Files.readAllBytes(Paths.get("pubkey.pem"));
byte[] der = WolfCrypt.pubKeyPemToDer(pem);
```

## RSA Miller-Rabin Primality Test Configuration

Bouncy Castle allows configuring the number of Miller-Rabin primality test
rounds used during RSA key generation via a security property:

```java
Security.setProperty("org.bouncycastle.rsa.max_mr_tests", "0");
```

This property has no equivalent in wolfJCE. wolfCrypt's RSA implementation
uses a fixed number of Miller-Rabin rounds that cannot be adjusted at runtime.
When using wolfCrypt FIPS, the primality testing parameters are part of the
validated module and must not be modified in order to remain compliant with
FIPS 140-3 requirements.

Any code that sets this Bouncy Castle property should simply be removed during
migration.
