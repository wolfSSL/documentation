# Getting Started

The wolfTPM library has TPM 2.0 wrapper tests, native tests, and a sample benchmark application that come ready-to-use after a successful installation of wolfTPM. Below are some instructions on how to run the sample applications yourself.

To interface with the hardware platform that is running these applications, please see the function `TPM2_IoCb` inside of `tpm_io.c`.

## Examples

These examples demonstrate features of a TPM 2.0 module.

The examples create RSA and ECC keys in NV for testing using handles defined in `./examples/tpm_test.h`.

The PKCS #7 and TLS examples require generating CSR's and signing them using a test script. See CSR and Certificate Signing below.

To enable parameter encryption use `-aes` for AES-CFB mode or `-xor` for XOR mode. Only some TPM commands / responses support parameter encryption. If the TPM2_ API has .flags `CMD_FLAG_ENC2` or `CMD_FLAG_DEC2` set then the command will use parameter encryption / decryption.

There are some vendor specific examples, like the TPM 2.0 extra GPIO examples for ST33 and NPCT75x.

### Native API Test

Demonstrates calling native TPM2_* API's.

```
./examples/native/native_test
TPM2 Demo using Native API's
TPM2: Caps 0x30000495, Did 0x0000, Vid 0x104a, Rid 0x4e
TPM2_Startup pass
TPM2_SelfTest pass
TPM2_GetTestResult: Size 12, Rc 0x0
TPM2_IncrementalSelfTest: Rc 0x0, Alg 0x1 (Todo 0)
TPM2_GetCapability: Property FamilyIndicator 0x322e3000
TPM2_GetCapability: Property PCR Count 24
TPM2_GetCapability: Property FIRMWARE_VERSION_1 0x004a0008
TPM2_GetCapability: Property FIRMWARE_VERSION_2 0x44a01587
TPM2_GetRandom: Got 32 bytes
TPM2_StirRandom: success
TPM2_PCR_Read: Index 0, Count 1
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 1, Count 1
TPM2_PCR_Read: Index 1, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 2, Count 1
TPM2_PCR_Read: Index 2, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 3, Count 1
TPM2_PCR_Read: Index 3, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 4, Count 1
TPM2_PCR_Read: Index 4, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 5, Count 1
TPM2_PCR_Read: Index 5, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 6, Count 1
TPM2_PCR_Read: Index 6, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 7, Count 1
TPM2_PCR_Read: Index 7, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 8, Count 1
TPM2_PCR_Read: Index 8, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 9, Count 1
TPM2_PCR_Read: Index 9, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 10, Count 1
TPM2_PCR_Read: Index 10, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 11, Count 1
TPM2_PCR_Read: Index 11, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 12, Count 1
TPM2_PCR_Read: Index 12, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 13, Count 1
TPM2_PCR_Read: Index 13, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 14, Count 1
TPM2_PCR_Read: Index 14, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 15, Count 1
TPM2_PCR_Read: Index 15, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 16, Count 1
TPM2_PCR_Read: Index 16, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 17, Count 1
TPM2_PCR_Read: Index 17, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 18, Count 1
TPM2_PCR_Read: Index 18, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 19, Count 1
TPM2_PCR_Read: Index 19, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 20, Count 1
TPM2_PCR_Read: Index 20, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 21, Count 1
TPM2_PCR_Read: Index 21, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 22, Count 1
TPM2_PCR_Read: Index 22, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 23, Count 1
TPM2_PCR_Read: Index 23, Digest Sz 32, Update Counter 20
TPM2_PCR_Extend success
TPM2_PCR_Read: Index 0, Count 1
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 21
TPM2_StartAuthSession: sessionHandle 0x3000000
TPM2_PolicyGetDigest: size 32
TPM2_PCR_Read: Index 0, Digest Sz 20, Update Counter 21
wc_Hash of PCR[0]: size 32
TPM2_PolicyPCR failed 0x1c4: TPM_RC_AUTHSIZE
TPM2_PolicyRestart: Done
TPM2_HashSequenceStart: sequenceHandle 0x80000000
Hash SHA256 test success
TPM2_CreatePrimary: Endorsement 0x80000000 (314 bytes)
TPM2_CreatePrimary: Storage 0x80000002 (282 bytes)
TPM2_LoadExternal: 0x80000004
TPM2_MakeCredential: credentialBlob 68, secret 256
TPM2_ReadPublic Handle 0x80000004: pub 314, name 34, qualifiedName 34
Create HMAC-SHA256 Key success, public 48, Private 137
TPM2_Load New HMAC Key Handle 0x80000004
TPM2_PolicyCommandCode: success
TPM2_ObjectChangeAuth: private 137
TPM2_ECC_Parameters: CurveID 3, sz 256, p 32, a 32, b 32, gX 32, gY 32, n 32, h 1
TPM2_Create: New ECDSA Key: pub 88, priv 126
TPM2_Load ECDSA Key Handle 0x80000004
TPM2_Sign: ECC S 32, R 32
TPM2_VerifySignature: Tag 32802
TPM2_Create: New ECDH Key: pub 88, priv 126
TPM2_Load ECDH Key Handle 0x80000004
TPM2_ECDH_KeyGen: zPt 68, pubPt 68
TPM2_ECDH_ZGen: zPt 68
TPM2 ECC Shared Secret Pass
TPM2_Create: New RSA Key: pub 278, priv 222
TPM2_Load RSA Key Handle 0x80000004
TPM2_RSA_Encrypt: 256
TPM2_RSA_Decrypt: 68
RSA Encrypt/Decrypt test passed
TPM2_NV_DefineSpace: 0x1bfffff
TPM2_NV_ReadPublic: Sz 14, Idx 0x1bfffff, nameAlg 11, Attr 0x2020002, authPol 0, dataSz 32, name 34
Create AES128 CFB Key success, public 50, Private 142
TPM2_Load New AES Key Handle 0x80000004
Encrypt/Decrypt test success
```

### Wrapper API Test

Demonstrates calling the wolfTPM2_* wrapper API's.

```
./examples/wrap/wrap_test
TPM2 Demo for Wrapper API's
Mfg STM  (2), Vendor , Fw 74.8 (1151341959), FIPS 140-2 1, CC-EAL4 0
RSA Encrypt/Decrypt Test Passed
RSA Encrypt/Decrypt OAEP Test Passed
RSA Key 0x80000000 Exported to wolf RsaKey
wolf RsaKey loaded into TPM: Handle 0x80000000
RSA Private Key Loaded into TPM: Handle 0x80000000
ECC Sign/Verify Passed
ECC DH Test Passed
ECC Verify Test Passed
ECC Key 0x80000000 Exported to wolf ecc_key
wolf ecc_key loaded into TPM: Handle 0x80000000
ECC Private Key Loaded into TPM: Handle 0x80000000
NV Test on index 0x1800200 with 1024 bytes passed
Hash SHA256 test success
HMAC SHA256 test success
Encrypt/Decrypt (known key) test success
Encrypt/Decrypt test success
```


### Attestation Use Cases

#### TPM signed timestamp, TPM2.0 GetTime

Demonstrates creation of Attestation Identity Keys (AIK) and the generation of TPM signed timestamp that can be later used as protected report of the current system uptime.

This example demonstrates the use of `authSession` (authorization Session) and `policySession` (Policy authorization) to enable the Endorsement Hierarchy necessary for creating AIK. The AIK is used to issue a `TPM2_GetTime` command using the TPM 2.0 native API. This provides a TPM generated and signed timestamp that can be used as a system report of its uptime.

`./examples/timestamp/signed_timestamp`

#### TPM signed PCR(system) measurement, TPM2.0 Quote

Demonstrates the generation of TPM2.0 Quote used for attestation of the system state by putting PCR value(s) in a TPM signed structure.

##### List of examples

The `./examples/pcr/` folder contains tools for working with Platform Configuration Registers (PCR). It is recommended to build wolfTPM with debug output enabled using `./configure --enable-debug` before `make` to see more logging output. There are example scripts to show using these PCR examples.

Examples:

* `./examples/pcr/reset`: Used to clear the content of a PCR (restrictions apply, see below)
* `./examples/pcr/extend`: Used to modify the content of a PCR (extend is a cryptographic operation, see below)
* `./examples/pcr/quote`: Used to generate a TPM2.0 Quote structure containing the PCR digest and TPM-generated signature

Scripts:

* `./examples/pcr/demo.sh` - script demonstrating the tools above
* `./examples/pcr/demo-quote-zip.sh` - script demonstrating how using the tools above a system file can be measured and a TPM-signed proof with that measurement generated


##### Technology introduction

###### Platform Configuration Registers (PCR)

PCRs in TPM2.0 are special registers that allow only one type of write operations to be performed on them. A TPM 2.0 extend operation is the only way to update a PCR.

At power-up, the TPM resets all PCRs to their default state (all zeros or all ones, depending on the PCR). From this state, the TPM can generate the same PCR value only if the PCR is extended with the same hash digest. In case of multiple values(multiple extend operations), the values must be supplied in the correct order, otherwise the final PCR value would differ.

For example, doing a measured boot under Linux would generate the same PCR digest, if the kernel is the same at every boot. However, loading the same (A) Linux kernel, (B) initrd image and (C) configuration file would generate the same PCR digest only when the order of extend operations is consistent (for example, A-B-C). It does not matter which extend operation is first or last as long as the order is kept the same. For example, C-B-A would result in a reproducible digest, but it would differ from the A-B-C digest.

###### Reset

Not all PCRs are equal. The user can perform `extend` operation on all PCRs, but the user can `reset` only on one of them during normal runtime. This is what makes PCRs so useful.

* PCR0-15 are reset at boot and can be cleared again(reset) only from reboot cycle.
* PCR16 is a PCR for debug purposes. This is the PCR used by all tools above by default. It is safe to test and work with PCR16.
* PCR17-22 are reserved for Dynamic Root of Trust Measurement (DRTM), an advanced topic that is to be covered separately.

###### Extend

The TPM 2.0 `TPM2_Extend` API uses a SHA1 or SHA256 cryptographic operation to combine the current value of the PCR and with newly provided hash digest.

###### Quote

The TPM 2.0 `TPM2_Quote` API is a standard operation that encapsulates the PCR digest in a TCG defined structure called `TPMS_ATTEST` together with TPM signature. The signature is produced from a TPM generated key called Attestation Identity Key (AIK) that only the TPM can use. This provides guarantee for the source of the Quote and PCR digest. Together, the Quote and PCR provide the means for system measurement and integrity.

##### Example Usage

###### Reset Example Usage

```sh
$ ./examples/pcr/reset -?
PCR index is out of range (0-23)
Expected usage:
./examples/pcr/reset [pcr]
* pcr is a PCR index between 0-23 (default 16)
Demo usage without parameters, resets PCR16.
```

###### Extend Example Usage

```sh
$ ./examples/pcr/extend -?
Incorrect arguments
Expected usage:
./examples/pcr/extend [pcr] [filename]
* pcr is a PCR index between 0-23 (default 16)
* filename points to file(data) to measure
	If wolfTPM is built with --disable-wolfcrypt the file
	must contain SHA256 digest ready for extend operation.
	Otherwise, the extend tool computes the hash using wolfcrypt.
Demo usage without parameters, extends PCR16 with known hash.
```

###### Quote Example Usage

```sh
$ ./examples/pcr/quote -?
Incorrect arguments
Expected usage:
./examples/pcr/quote [pcr] [filename]
* pcr is a PCR index between 0-23 (default 16)
* filename for saving the TPMS_ATTEST structure to a file
Demo usage without parameters, generates quote over PCR16 and
saves the output TPMS_ATTEST structure to "quote.blob" file.
```

##### Typical demo output

All PCR examples can be used without arguments. This is the output of the `./examples/pcr/demo.sh` script:

```sh
$ ./examples/pcr/reset
Demo how to reset a PCR (clear the PCR value)
wolfTPM2_Init: success
Trying to reset PCR16...
TPM2_PCR_Reset success
PCR16 digest:
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | ................
```

As expected, the PCR16 content is now set back to all zeroes. From this moment on we can generate predictable PCR digests(values) for system measurement. Similar to using PCR7 after boot, because PCR7 is reset at system boot. Using PCR16 allows us to skip system reboots and test safely.

```
$ ./examples/pcr/extend
Demo how to extend data into a PCR (TPM2.0 measurement)
wolfTPM2_Init: success
Hash to be used for measurement:
000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F
TPM2_PCR_Extend success
PCR16 digest:
    bb 22 75 c4 9f 28 ad 52 ca e6 d5 5e 34 a9 74 a5 | ."u..(.R...^4.t.
    8c 7a 3b a2 6f 97 6e 8e cb be 7a 53 69 18 dc 73 | .z;.o.n...zSi..s
```

Based on the old content of the PCR (all zeros) and the provided hash (SHA256 32-byte digest), the PCR gets its new value printed at the end of the `extend` example. This value will always be the same, if `reset` is launched before `extend`. To pass custom hash digest, the `extend` tool accepts PCR index as first argument(recommended to use 16 for PCR16) and user file as second argument.

```
$ ./examples/pcr/quote
Demo of generating signed PCR measurement (TPM2.0 Quote)
wolfTPM2_Init: success
TPM2_CreatePrimary: 0x80000000 (314 bytes)
wolfTPM2_CreateEK: Endorsement 0x80000000 (314 bytes)
TPM2_CreatePrimary: 0x80000001 (282 bytes)
wolfTPM2_CreateSRK: Storage 0x80000001 (282 bytes)
TPM2_StartAuthSession: sessionHandle 0x3000000
TPM2_Create key: pub 280, priv 212
TPM2_Load Key Handle 0x80000002
wolfTPM2_CreateAndLoadAIK: AIK 0x80000002 (280 bytes)
TPM2_Quote: success
TPM with signature attests (type 0x8018):
    TPM signed 1 count of PCRs
    PCR digest:
    c7 d4 27 2a 57 97 7f 66 1f bd 79 30 0a 1b bf ff | ..'*W..f..y0....
    2e 43 57 cc 44 14 7a 82 11 aa 76 3f 9f 1b 3a 6c | .CW.D.z...v?..:l
    TPM generated signature:
    28 dc da 76 33 35 a5 85 2a 0c 0b e8 25 d0 f8 8d | (..v35..*...%...
    1f ce c3 3b 71 64 ed 54 e6 4d 82 af f3 83 18 8e | ...;qd.T.M......
    6e 2d 9f 9e 5a 86 4f 11 fe 13 84 94 cf 05 b9 d5 | n-..Z.O.........
    eb 5a 34 39 b2 a5 7a 5f 52 c0 f4 e7 2b 70 b7 62 | .Z49..z_R...+p.b
    6a fe 79 4e 2e 46 2e 43 d7 1c ef 2c 14 21 11 14 | j.yN.F.C...,.!..
    95 01 93 a9 85 0d 02 c7 b2 f8 75 1a bd 59 da 56 | ..........u..Y.V
    cc 43 e3 d2 aa 14 49 2a 59 26 09 9e c9 4b 1a 66 | .C....I*Y&...K.f
    cb 77 65 95 79 69 89 bd 46 46 13 3d 2c a9 78 f8 | .we.yi..FF.=,.x.
    2c ab 8a 4a 6b f2 97 67 86 37 f8 f6 9d 85 cd cf | ,..Jk..g.7......
    a4 ae c6 d3 cf c1 63 92 8c 7b 88 79 90 54 0a ba | ......c..{.y.T..
    8d c6 1c 8f 6e 6d 61 bc a9 2f 35 b0 1a 46 74 9a | ....nma../5..Ft.
    e3 7d 39 33 52 1a f5 4b 07 8d 30 53 75 b5 68 40 | .}93R..K..0Su.h@
    04 e7 a1 fc b1 93 5d 1e bc ca f4 a9 fa 75 d3 f6 | ......]......u..
    3d 4a 5b 07 23 0e f0 f4 1f 97 23 76 1a ee 66 93 | =J[.#.....#v..f.
    cd fd 9e 6f 2b d3 95 c5 51 cf f6 81 5b 97 a1 d2 | ...o+...Q...[...
    06 45 c0 30 70 ad bd 36 66 9f 95 af 60 7c d5 a2 | .E.0p..6f...`|..
```

Before producing a TPM-signed structure containing the PCR measurement, the quote example starts by creating an Endorsement Key(EK) that is required for the TPM to operate. It serves essentially as the primary key for all other keys. Next, a Storage Key(SRK) is generated and under that SRK a special Attestation Identity Key(AIK) is added. Using the AIK the TPM can sign the quote structure.

##### Steps for measuring a system file (performing local attestation)

A system administrator wants to make sure the zip tool of an user is genuine (legitimate software, correct version and has not been tampered with). To do this, the SysAdmin resets PCR16 and can afterwards generate a PCR digest based on the zip binary that can be used for future references if the file has been modified.

This is the output from `./examples/pcr/demo-quote-zip.sh` script.

```sh
$ ./examples/pcr/reset 16
...
Trying to reset PCR16...
TPM2_PCR_Reset success
...
```

This is a good known initial state of the PCR. By using the `extend` tool the SysAdmin feeds the `/usr/bin/zip` binary to wolfCrypt for SHA256 hash computation, which then is used by wolfTPM to issue a `TPM2_Extend` operation in PCR16.

```sh
$ ./examples/pcr/extend 16 /usr/bin/zip
...
TPM2_PCR_Extend success
PCR16 digest:
    2b bd 54 ae 08 5b 59 ef 90 42 d5 ca 5d df b5 b5 | +.T..[Y..B..]...
    74 3a 26 76 d4 39 37 eb b0 53 f5 82 67 6f b4 aa | t:&v.97..S..go..
```

Once the extend operation is finished, the SysAdmin wants to create a TPM2.0 Quote as proof of the measurement in PCR16.

```sh
$ ./examples/pcr/quote 16 zip.quote
...
TPM2_Quote: success
TPM with signature attests (type 0x8018):
    TPM signed 1 count of PCRs
...
```

The result of the TPM2.0 Quote operation is saved in the `zip.quote` binary file. The `TPMS_ATTEST` structure of TPM 2.0 Quote contains also useful clock and time information. For more about the TPM time attestation please check the `./examples/timestamp/signed_timestamp` example.

#### Remote Attestation challenge

Demonstrates how to create Remote Attestation challenge using the TPM 2.0 and afterwards prepare a response.

##### List of examples

The `./examples/attestation/` folder contains examples related specifically to remote attestation. However, the demonstration requires the creation of TPM 2.0 keys using the `keygen` example also included in wolfTPM's source code.

Complete list of the required examples is shown below:

* `./examples/attestation/make_credential`: Used by a server to create a remote attestation challenge
* `./examples/attestation/activate_credential`: Used by a client to decrypt the challenge and respond
* `./examples/keygen/keygen`: Used to create a primary key(PK) and attestation key(AK)

Note: All of these example allow the use of the Endorsement Key and Attestation Key under the Endorsement Hierarchy. This is done by adding the `-eh` option when executing any of the three examples above. The advantage of using EK/EH is that the private key material of the EK never leaves the TPM. Anything encrypted using the public part of the EK can be encrypted only internally by the TPM owner of the EK, and EK is unique for every TPM chip. Therefore, creating challenges for Remote Attestation using the EK/EH has greater value in some scenarios. One drawback is that by using the EK the identity of the host under attestation is always known, because the EK private-public key pair identifies the TPM and in some scenarios this might rise privacy concerns. Our remote attestation examples support both AK under SRK and AK under EK. It is up to the developer to decide which one to use.

##### Technology introduction

Remote Attestation is the process of a client providing an evidence to an attestation server that verifies if the client is in a known state.

For this process to take place, the client and server must establish initial trust. This is achieved using the standard TPM 2.0 commands MakeCredential and ActivateCredential.

1. The client transfers the public parts of a TPM 2.0 Primary Attestation Key(PAK) and quote signing Attestation Key(AK).

2. MakeCredential uses the public part of the PAK to encrypt a challenge(secret). Typically, the challenge is a digest of the public part of an Attestation Key(AK).

This way the challenge can only be decrypted by the TPM that can load the private part of the PAK and AK. Because the PAK and AK are bound to the TPM using a fixedTPM key attribute, the only TPM that can load these keys is the TPM where they were originally created.

3. After the challenge is created, it is transferred from the server to the client.

4. ActivateCredential uses the TPM 2.0 loaded PAK and AK to decrypt the challenge and retrieve the secret. Once retrieved, the client can respond to the server challenge.

This way the client confirms to the server it possesses the expected TPM 2.0 System Identity and Attestation Key.

Note:

* The transport protocol to exchange the challenge and response are up to the developer to choose, because this is implementation specific. One approach could be the use of TLS1.3 client-server connection using wolfSSL.

##### Example usage

###### Creating TPM 2.0 keys for Remote Attestation

Using the `keygen` example we can create the necessary TPM 2.0 Attestation Key and TPM 2.0 Primary Storage Key that will be used as a Primary Attestation Key(PAK).

```
$ ./examples/keygen/keygen -rsa
TPM2.0 Key generation example
	Key Blob: keyblob.bin
	Algorithm: RSA
	Template: AIK
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
RSA AIK template
Creating new RSA key...
New key created and loaded (pub 280, priv 222 bytes)
Wrote 508 bytes to keyblob.bin
Wrote 288 bytes to srk.pub
Wrote AK Name digest
```

###### Make Credential Example Usage

Using the `make_credential` example an attestation server can generate remote attestation challenge. The secret is 32 bytes of randomly generated seed that could be used for a symmetric key in some remote attestation schemes.

```
$ ./examples/attestation/make_credential
Using public key from SRK to create the challenge
Demo how to create a credential challenge for remote attestation
Credential will be stored in cred.blob
wolfTPM2_Init: success
Reading 288 bytes from srk.pub
Reading the private part of the key
Public key for encryption loaded
Read AK Name digest success
TPM2_MakeCredential success
Wrote credential blob and secret to cred.blob, 648 bytes
```

The transfer of the PAK and AK public parts between the client and attestation server is not part of the `make_credential` example, because the exchange is implementation specific.

###### Activate Credential Example Usage

Using the `activate_credential` example a client can decrypt the remote attestation challenge. The secret will be exposed in plain and can be exchanged with the attestation server.

```
$ ./examples/attestation/activate_credential
Using default values
Demo how to create a credential blob for remote attestation
wolfTPM2_Init: success
Credential will be read from cred.blob
Loading SRK: Storage 0x81000200 (282 bytes)
SRK loaded
Reading 508 bytes from keyblob.bin
Reading the private part of the key
AK loaded at 0x80000001
Read credential blob and secret from cred.blob, 648 bytes
TPM2_ActivateCredential success
```

The transfer of the challenge response containing the secret in plain (or used as a symmetric key seed) is not part of the `activate_credential` example, because the exchange is also implementation specific.

### Parameter Encryption

#### Key generation with encrypted authorization

Detailed information can be found under the section ["Key generation"](#key-generation)

#### Secure vault for keys with encrypted NVRAM authorization

Detailed information can be found in this file under section ["Storing keys into the TPM's NVRAM"](#storing-keys-into-the-tpms-nvram)

#### TPM2.0 Quote with encrypted user data

Example for demonstrating how to use parameter encryption to protect the user data between the Host and the TPM.

In this example the qualifying data that can be supplied by the user for a Quote operation is protected. Qualifying data is arbitrary data incorporated into the signed Quote structure. Using parameter encryption, wolfTPM enables the Host to transfer that user data in encrypted form to the TPM and vice versa. Thus, protecting the data from man-in-the-middle attacks.

Only the first parameter of a TPM command can be encrypted and the parameter must be of type `TPM2B_DATA`. For example, the password auth of a TPM key or the qualifying data of a TPM2.0 Quote.

The encryption of command request and response can be performed together or separate. There can be a communication exchange between the TPM and a client program where only the parameter in the request command is encrypted.

This behavior depends on the `sessionAttributes`:

- `TPMA_SESSION_encrypt` for command request
- `TPMA_SESSION_decrypt` for command response

Either one can be set separately or both can be set in one authorization session. This is up to the user (developer).

`./examples/pcr/quote_paramenc`

### CSR

Generates a Certificate Signing Request for building a certificate based on a TPM key pair.

`./examples/csr/csr`

It creates two files:
`./certs/tpm-rsa-cert.csr`
`./certs/tpm-ecc-cert.csr`


### Certificate Signing

External script for generating test certificates based on TPM generated CSR's. Typically the CSR would be provided to a trusted CA for signing.

`./certs/certreq.sh`

The script creates the following X.509 files (also in .pem format):
`./certs/ca-ecc-cert.der`
`./certs/ca-rsa-cert.der`
`./certs/client-rsa-cert.der`
`./certs/client-ecc-cert.der`
`./certs/server-rsa-cert.der`
`./certs/server-ecc-cert.der`


### PKCS #7

Example signs and verifies data with PKCS #7 using a TPM based key.

* Must first run:
1. `./examples/csr/csr`
2. `./certs/certreq.sh`
3. `./examples/pkcs7/pkcs7`

The result is displayed to stdout on the console.


### TLS Examples

The TLS example uses TPM based ECDHE (ECC Ephemeral key) support. It can be disabled using `CFLAGS="-DWOLFTPM2_USE_SW_ECDHE"` or `#define WOLFTPM2_USE_SW_ECDHE`. We are also looking into using the 2-phase `TPM2_EC_Ephemeral` and `TPM2_ZGen_2Phase` methods for improved performance and scalability.

To force ECC use with wolfSSL when RSA is enabled define `TLS_USE_ECC`.

To use symmetric AES/Hashing/HMAC with the TPM define `WOLFTPM_USE_SYMMETRIC`.

Generation of the Client and Server Certificates requires running:


1. `./examples/keygen/keygen rsa_test_blob.raw -rsa -t`
2. `./examples/keygen/keygen ecc_test_blob.raw -ecc -t`
3. `./examples/csr/csr`
4. `./certs/certreq.sh`
5. Copy the CA files from wolfTPM to wolfSSL certs directory.
    a. `cp ./certs/ca-ecc-cert.pem ../wolfssl/certs/tpm-ca-ecc-cert.pem`
    b. `cp ./certs/ca-rsa-cert.pem ../wolfssl/certs/tpm-ca-rsa-cert.pem`

Note: The `wolf-ca-rsa-cert.pem` and `wolf-ca-ecc-cert.pem` files come from the wolfSSL example certificates here:

```
cp ../wolfssl/certs/ca-cert.pem ./certs/wolf-ca-rsa-cert.pem
cp ../wolfssl/certs/ca-ecc-cert.pem ./certs/wolf-ca-ecc-cert.pem
```

#### TLS Client

Examples show using a TPM key and certificate for TLS mutual authentication (client authentication).

This example client connects to localhost on on port 11111 by default. These can be overridden using `TLS_HOST` and `TLS_PORT`.

You can validate using the wolfSSL example server this like:
`./examples/server/server -b -p 11111 -g -d -i -V`

To validate client certificate use the following wolfSSL example server command:
`./examples/server/server -b -p 11111 -g -A ./certs/tpm-ca-rsa-cert.pem -i -V`
or
`./examples/server/server -b -p 11111 -g -A ./certs/tpm-ca-ecc-cert.pem -i -V`

Then run the wolfTPM TLS client example:
`./examples/tls/tls_client -rsa`
or
`./examples/tls/tls_client -ecc`


#### TLS Server

This example shows using a TPM key and certificate for a TLS server.

By default it listens on port 11111 and can be overridden at build-time using the `TLS_PORT` macro.

Run the wolfTPM TLS server example:
`./examples/tls/tls_server -rsa`
or
`./examples/tls/tls_server -ecc`

Then run the wolfSSL example client this like:
`./examples/client/client -h localhost -p 11111 -g -d`

To validate server certificate use the following wolfSSL example client comment:
`./examples/client/client -h localhost -p 11111 -g -A ./certs/tpm-ca-rsa-cert.pem`
or
`./examples/client/client -h localhost -p 11111 -g -A ./certs/tpm-ca-ecc-cert.pem`


Or using your browser: `https://localhost:11111`

With browsers you will get certificate warnings until you load the test CA's `./certs/ca-rsa-cert.pem` and `./certs/ca-ecc-cert.pem` into your OS key store.
For testing most browsers have a way to continue to the site anyways to bypass the warning.


### Clock

Updating the TPM clock

The TPM has internal hardware clock that can be useful to the user. There are two values that the TPM can provide in respect to time.

TPM time is the current uptime, since the last power on sequence. This value can not be changed or modified. There is no mechanism for that. The value is reset at every power sequence.

TPM clock is the total time the TPM has ever been powered. This value can be modified using the TPM2_ClockSet command. The TPM clock can be set only forward.

This way the user can keep track of relative and current time using the TPM clock.

Note: If the new time value makes a change bigger than the TPM clock update interval, then the TPM will first update its volatile register for time and then the non-volatile register for time. This may cause a narrow delay before the commands returns execution to the user. Depending on the TPM manufacturer, the delay can vary from us to few ms.

Note: This example can take an optional argument, the time value in milliseconds used for incrementing the TPM clock. Default value is 50000ms (50 seconds).

`./examples/timestamp/clock_set`

### Key Generation

Examples for generating a TPM key blob and storing to disk, then loading from disk and loading into temporary TPM handle.

```
$ ./examples/keygen/keygen keyblob.bin -rsa
TPM2.0 Key generation example
Loading SRK: Storage 0x81000200 (282 bytes)
Creating new RSA key...
Created new key (pub 280, priv 222 bytes)
Wrote 840 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 840 bytes from keyblob.bin
Loaded key to 0x80000001


$ ./examples/keygen/keygen keyblob.bin -ecc
TPM2.0 Key generation example
Loading SRK: Storage 0x81000200 (282 bytes)
Creating new ECC key...
Created new key (pub 88, priv 126 bytes)
Wrote 744 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 744 bytes from keyblob.bin
Loaded key to 0x80000001

./examples/keygen/keygen -sym=aescfb128
TPM2.0 Key generation example
	Key Blob: keyblob.bin
	Algorithm: SYMCIPHER
		 aescfb mode, 128 keybits
	Template: Default
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Symmetric template
Creating new SYMCIPHER key...
Created new key (pub 50, priv 142 bytes)
Wrote 198 bytes to keyblob.bin

$ ./examples/keygen/keyload
TPM2.0 Key load example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 198 bytes from keyblob.bin
Reading the private part of the key
Loaded key to 0x80000001

```

When filename is not supplied, a default filename "keyblob.bin" is used, therefore `keyload` and `keygen` can be used without additional parameters for quick TPM 2.0 key generation demonstration.

To see the complete list of supported cryptographic algorithms and options by the `keygen` example, use one of the `--help` switches.

Example for importing a private key as TPM key blob and storing to disk, then loading from disk and loading into temporary TPM handle.

```
$ ./examples/keygen/keyimport keyblob.bin -rsa
TPM2.0 Key import example
Loading SRK: Storage 0x81000200 (282 bytes)
Imported key (pub 278, priv 222 bytes)
Wrote 840 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 840 bytes from keyblob.bin
Loaded key to 0x80000001


$ ./examples/keygen/keyimport keyblob.bin -ecc
TPM2.0 Key Import example
Loading SRK: Storage 0x81000200 (282 bytes)
Imported key (pub 86, priv 126 bytes)
Wrote 744 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 744 bytes from keyblob.bin
Loaded key to 0x80000001
```

The `keyload` tool takes only one argument, the filename of the stored key. Because the information what is key scheme (RSA or ECC) is contained within the key blob.

### Storing keys into the TPM's NVRAM

These examples demonstrates how to use the TPM as a secure vault for keys. There are two programs, one to store a TPM key into the TPM's NVRAM and another to extract the key from the TPM's NVRAM. Both examples can use parameter encryption to protect from MITM attacks. The Non-volatile memory location is protected with a password authorization that is passed in encrypted form, when "-aes" is given on the command line.

Before running the examples, make sure there is a keyblob.bin generated using the keygen tool. The key can be of any type, RSA, ECC or symmetric. The example will store the private and public part. In case of a symmetric key the public part is meta data from the TPM. How to generate a key you can see above, in the description of the keygen example.

Typical output for storing and then reading an RSA key with parameter encryption enabled:

```

$ ./examples/nvram/store -aes
Parameter Encryption: Enabled (AES CFB).

TPM2_StartAuthSession: sessionHandle 0x2000000
Reading 840 bytes from keyblob.bin
Storing key at TPM NV index 0x1800202 with password protection

Public part = 616 bytes
NV write of public part succeeded

Private part = 222 bytes
Stored 2-byte size marker before the private part
NV write of private part succeeded


$ ./examples/nvram/read -aes
Parameter Encryption: Enabled (AES CFB).

TPM2_StartAuthSession: sessionHandle 0x2000000
Trying to read 616 bytes of public key part from NV
Successfully read public key part from NV

Trying to read size marker of the private key part from NV
Successfully read size marker from NV

Trying to read 222 bytes of private key part from NV
Successfully read private key part from NV

Extraction of key from NVRAM at index 0x1800202 succeeded
Loading SRK: Storage 0x81000200 (282 bytes)
Trying to load the key extracted from NVRAM
Loaded key to 0x80000001

```

The "read" example will try to load the extracted key, if both the public and private part of the key were stored in NVRAM. The "-aes" switches triggers the use of parameter encryption.

The examples can work with partial key material - private or public. This is achieved by using the "-priv" and "-pub" options.

Typical output of storing only the private key of RSA asymmetric key pair in NVRAM and without parameter encryption enabled.

```

$ ./examples/nvram/store -priv
Parameter Encryption: Not enabled (try -aes or -xor).

Reading 506 bytes from keyblob.bin
Reading the private part of the key
Storing key at TPM NV index 0x1800202 with password protection

Private part = 222 bytes
Stored 2-byte size marker before the private part
NV write of private part succeeded

$ ./examples/nvram/read -priv
Parameter Encryption: Not enabled (try -aes or -xor).

Trying to read size marker of the private key part from NV
Successfully read size marker from NV

Trying to read 222 bytes of private key part from NV
Successfully read private key part from NV

Extraction of key from NVRAM at index 0x1800202 succeeded

```

After successful key extraction using "read", the NV Index is destroyed. Therefore, to use "read" again, the "store" example must be run again as well.

### Seal / Unseal

TPM 2.0 can protect secrets using a standard Seal/Unseal procedure. Seal can be created using a TPM 2.0 key or against a set of PCR values. Note: Secret data sealed in a key is limited to a maximum size of 128 bytes.

There are two examples available: `seal/seal` and `seal/unseal`.

Demo usage is available, without parameters.

#### Sealing data into a TPM 2.0 Key

Using the `seal` example we store securely our data in a newly generated TPM 2.0 key. Only when this key is loaded into the TPM, we could read back our secret data.

Please find example output from sealing and unsealing a secret message:

```
$ ./examples/seal/seal keyblob.bin mySecretMessage
TPM2.0 Simple Seal example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Sealing the user secret into a new TPM key
Created new TPM seal key (pub 46, priv 141 bytes)
Wrote 193 bytes to keyblob.bin
Key Public Blob 46
Key Private Blob 141

$ ./examples/keygen/keyload -persistent
TPM2.0 Key load example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 193 bytes from keyblob.bin
Reading the private part of the key
Loaded key to 0x80000001
Key was made persistent at 0x81000202

$ ./examples/seal/unseal message.raw
Example how to unseal data using TPM2.0
wolfTPM2_Init: success
Unsealing succeeded
Stored unsealed data to file = message.raw

$ cat message.raw
mySecretMessage
```

After a successful unsealing, the data is stored into a new file. If no filename is provided, the `unseal` tool stores the data in `unseal.bin`.


### GPIO Control

Some TPM 2.0 modules have extra I/O functionalities and additional GPIO that the developer could use. This extra GPIO could be used to signal other subsystems about security events or system states.

Currently, the GPIO control examples support ST33 and NPCT75x TPM 2.0 modules.

There are four examples available. Configuration using `gpio/gpio_config`.

Every example has a help option `-h`. Please consult with `gpio_config -h` about the various GPIO modes.

Once configured, a GPIO can be controlled using `gpio/gpio_set` and `gpio/gpio_read`.

Demo usage is available, when no parameters are supplied. Recommended is to use carefully selected options, because GPIO interact with the physical world.

#### GPIO Config

ST33 supports 6 modes, information from `gpio/gpio_config` below:

```
$ ./examples/gpio/gpio_config -h
Expected usage:
./examples/gpio/gpio_config [num] [mode]
* num is a GPIO number between 0-3 (default 0)
* mode is a number selecting the GPIO mode between 0-6 (default 3):
	0. standard - reset to the GPIO's default mode
	1. floating - input in floating configuration.
	2. pullup   - input with pull up enabled
	3. pulldown - input with pull down enabled
	4. opendrain - output in open drain configuration
	5. pushpull  - output in push pull configuration
	6. unconfigure - delete the NV index for the selected GPIO
Example usage, without parameters, configures GPIO0 as input with a pull down.
```

Example usage for configuring a GPIO to output can be found below:

```
$ ./examples/gpio/gpio_config 0 5
GPIO num is: 0
GPIO mode is: 5
Example how to use extra GPIO on a TPM 2.0 modules
Trying to configure GPIO0...
TPM2_GPIO_Config success
NV Index for GPIO access created
```

Example usage for configuring a GPIO as input with a pull-up on ST33 can be found below:

```
$ ./examples/gpio/gpio_config 0 3
GPIO num is: 0
GPIO mode is: 3
Demo how to use extra GPIO on a TPM 2.0 modules
Trying to configure GPIO0...
TPM2_GPIO_Config success
NV Index for GPIO access created
```

#### GPIO Config (NPCT75xx)

NPCT75x supports 3 output modes (no input modes), information from `gpio/gpio_config` below:

```
$ ./examples/gpio/gpio_config -h
Expected usage:
./examples/gpio/gpio_config [num] [mode]
* num is a GPIO number between 3 and 4 (default 3)
* mode is either push-pull, open-drain or open-drain with pull-up
	1. pushpull  - output in push pull configuration
	2. opendrain - output in open drain configuration
	3. pullup - output in open drain with pull-up enabled
	4. unconfig - delete NV index for GPIO access
Example usage, without parameters, configures GPIO3 as push-pull output.
```

Please note that NPCT75x GPIO numbering starts from GPIO3, while ST33 starts from GPIO0.

```
$ ./examples/gpio/gpio_nuvoton 4 1
Example for GPIO configuration of a NPTC7xx TPM 2.0 module
GPIO number: 4
GPIO mode: 1
Successfully read the current configuration
Successfully wrote new configuration
NV Index for GPIO access created
```

#### GPIO Usage

Switching a GPIO configuration is seamless.
* For ST33 `gpio/gpio_config` takes care of deleting existing NV Index, so a new GPIO configuration can be chosen.
* For NPCT75xx `gpio/gpio_config` can reconfigure any GPIO without deleting the created NV index.

```
$ ./examples/gpio/gpio_set 0 -high
GPIO0 set to high level

$ ./examples/gpio/gpio_set 0 -low
GPIO0 set to low level
```

```
$ ./examples/gpio/gpio_read 0
GPIO0 is Low
```

## Benchmarks

The wolfTPM benchmark application requires the same setup as the example applications.

Note: Key Generation is using existing template from hierarchy seed.

Run on Infineon OPTIGA SLB9670 at 43MHz:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 16 KB took 1.140 seconds,   14.033 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
Benchmark symmetric AES-256-CFB-enc not supported!
Benchmark symmetric AES-256-CFB-dec not supported!
SHA1               138 KB took 1.009 seconds,  136.783 KB/s
SHA256             138 KB took 1.009 seconds,  136.763 KB/s
RSA     2048 key gen        5 ops took 10.981 sec, avg 2196.230 ms, 0.455 ops/sec
RSA     2048 Public       113 ops took 1.005 sec, avg 8.893 ms,   112.449 ops/sec
RSA     2048 Private        7 ops took 1.142 sec, avg 163.207 ms,   6.127 ops/sec
RSA     2048 Pub  OAEP     73 ops took 1.011 sec, avg 13.848 ms,   72.211 ops/sec
RSA     2048 Priv OAEP      6 ops took 1.004 sec, avg 167.399 ms,   5.974 ops/sec
ECC      256 key gen        5 ops took 1.157 sec, avg 231.350 ms,   4.322 ops/sec
ECDSA    256 sign          15 ops took 1.033 sec, avg 68.865 ms,   14.521 ops/sec
ECDSA    256 verify         9 ops took 1.022 sec, avg 113.539 ms,   8.808 ops/sec
ECDHE    256 agree          5 ops took 1.161 sec, avg 232.144 ms,   4.308 ops/sec
```

Run on ST ST33TP SPI at 33MHz:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 14 KB took 1.017 seconds,   13.763 KB/s
AES-128-CBC-enc     40 KB took 1.008 seconds,   39.666 KB/s
AES-128-CBC-dec     42 KB took 1.032 seconds,   40.711 KB/s
AES-256-CBC-enc     40 KB took 1.013 seconds,   39.496 KB/s
AES-256-CBC-dec     40 KB took 1.011 seconds,   39.563 KB/s
AES-128-CTR-enc     26 KB took 1.055 seconds,   24.646 KB/s
AES-128-CTR-dec     26 KB took 1.035 seconds,   25.117 KB/s
AES-256-CTR-enc     26 KB took 1.028 seconds,   25.302 KB/s
AES-256-CTR-dec     26 KB took 1.030 seconds,   25.252 KB/s
AES-128-CFB-enc     42 KB took 1.045 seconds,   40.201 KB/s
AES-128-CFB-dec     40 KB took 1.008 seconds,   39.699 KB/s
AES-256-CFB-enc     40 KB took 1.022 seconds,   39.151 KB/s
AES-256-CFB-dec     42 KB took 1.041 seconds,   40.362 KB/s
SHA1                86 KB took 1.005 seconds,   85.559 KB/s
SHA256              84 KB took 1.019 seconds,   82.467 KB/s
RSA     2048 key gen        1 ops took 7.455 sec, avg 7455.036 ms, 0.134 ops/sec
RSA     2048 Public       110 ops took 1.003 sec, avg 9.122 ms,  109.624 ops/sec
RSA     2048 Private        5 ops took 1.239 sec, avg 247.752 ms,  4.036 ops/sec
RSA     2048 Pub  OAEP     81 ops took 1.001 sec, avg 12.364 ms,  80.880 ops/sec
RSA     2048 Priv OAEP      4 ops took 1.007 sec, avg 251.780 ms,  3.972 ops/sec
ECC      256 key gen        5 ops took 1.099 sec, avg 219.770 ms,  4.550 ops/sec
ECDSA    256 sign          24 ops took 1.016 sec, avg 42.338 ms,  23.619 ops/sec
ECDSA    256 verify        14 ops took 1.036 sec, avg 74.026 ms,  13.509 ops/sec
ECDHE    256 agree          5 ops took 1.235 sec, avg 247.085 ms,  4.047 ops/sec

```

Run on Microchip ATTPM20 at 33MHz:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                  2 KB took 1.867 seconds,    1.071 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
AES-128-CFB-enc     16 KB took 1.112 seconds,   14.383 KB/s
AES-128-CFB-dec     16 KB took 1.129 seconds,   14.166 KB/s
AES-256-CFB-enc     12 KB took 1.013 seconds,   11.845 KB/s
AES-256-CFB-dec     12 KB took 1.008 seconds,   11.909 KB/s
SHA1                22 KB took 1.009 seconds,   21.797 KB/s
SHA256              22 KB took 1.034 seconds,   21.270 KB/s
RSA     2048 key gen        3 ops took 15.828 sec, avg 5275.861 ms, 0.190 ops/sec
RSA     2048 Public        22 ops took 1.034 sec, avg 47.021 ms, 21.267 ops/sec
RSA     2048 Private        9 ops took 1.059 sec, avg 117.677 ms, 8.498 ops/sec
RSA     2048 Pub  OAEP     21 ops took 1.007 sec, avg 47.959 ms, 20.851 ops/sec
RSA     2048 Priv OAEP      9 ops took 1.066 sec, avg 118.423 ms, 8.444 ops/sec
ECC      256 key gen        7 ops took 1.072 sec, avg 153.140 ms, 6.530 ops/sec
ECDSA    256 sign          18 ops took 1.056 sec, avg 58.674 ms, 17.043 ops/sec
ECDSA    256 verify        24 ops took 1.031 sec, avg 42.970 ms, 23.272 ops/sec
ECDHE    256 agree         16 ops took 1.023 sec, avg 63.934 ms, 15.641 ops/sec
```

Run on Nations Technologies Inc. TPM 2.0 module at 33MHz:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 12 KB took 1.065 seconds,   11.270 KB/s
AES-128-CBC-enc     48 KB took 1.026 seconds,   46.780 KB/s
AES-128-CBC-dec     48 KB took 1.039 seconds,   46.212 KB/s
AES-256-CBC-enc     48 KB took 1.035 seconds,   46.370 KB/s
AES-256-CBC-dec     48 KB took 1.025 seconds,   46.852 KB/s
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
AES-128-CFB-enc     50 KB took 1.029 seconds,   48.591 KB/s
AES-128-CFB-dec     50 KB took 1.035 seconds,   48.294 KB/s
AES-256-CFB-enc     48 KB took 1.000 seconds,   47.982 KB/s
AES-256-CFB-dec     48 KB took 1.003 seconds,   47.855 KB/s
SHA1                80 KB took 1.009 seconds,   79.248 KB/s
SHA256              80 KB took 1.004 seconds,   79.702 KB/s
SHA384              78 KB took 1.018 seconds,   76.639 KB/s
RSA     2048 key gen        8 ops took 17.471 sec, avg 2183.823 ms, 0.458 ops/sec
RSA     2048 Public        52 ops took 1.004 sec, avg 19.303 ms, 51.805 ops/sec
RSA     2048 Private        8 ops took 1.066 sec, avg 133.243 ms, 7.505 ops/sec
RSA     2048 Pub  OAEP     51 ops took 1.001 sec, avg 19.621 ms, 50.966 ops/sec
RSA     2048 Priv OAEP      8 ops took 1.073 sec, avg 134.182 ms, 7.453 ops/sec
ECC      256 key gen       20 ops took 1.037 sec, avg 51.871 ms, 19.279 ops/sec
ECDSA    256 sign          43 ops took 1.006 sec, avg 23.399 ms, 42.736 ops/sec
ECDSA    256 verify        28 ops took 1.030 sec, avg 36.785 ms, 27.185 ops/sec
ECDHE    256 agree         26 ops took 1.010 sec, avg 38.847 ms, 25.742 ops/sec
```

Run on Nuvoton NPCT650:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                  8 KB took 1.291 seconds,    6.197 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
Benchmark symmetric AES-256-CFB-enc not supported!
Benchmark symmetric AES-256-CFB-dec not supported!
SHA1                90 KB took 1.005 seconds,   89.530 KB/s
SHA256              90 KB took 1.010 seconds,   89.139 KB/s
RSA     2048 key gen        8 ops took 35.833 sec, avg 4479.152 ms, 0.223 ops/sec
RSA     2048 Public        77 ops took 1.007 sec, avg 13.078 ms, 76.463 ops/sec
RSA     2048 Private        2 ops took 1.082 sec, avg 540.926 ms, 1.849 ops/sec
RSA     2048 Pub  OAEP     53 ops took 1.005 sec, avg 18.961 ms, 52.739 ops/sec
RSA     2048 Priv OAEP      2 ops took 1.088 sec, avg 544.075 ms, 1.838 ops/sec
ECC      256 key gen        7 ops took 1.033 sec, avg 147.608 ms, 6.775 ops/sec
ECDSA    256 sign           6 ops took 1.141 sec, avg 190.149 ms, 5.259 ops/sec
ECDSA    256 verify         4 ops took 1.061 sec, avg 265.216 ms, 3.771 ops/sec
ECDHE    256 agree          6 ops took 1.055 sec, avg 175.915 ms, 5.685 ops/sec
```

Run on Nuvoton NPCT750 at 43MHz:

```
RNG                 16 KB took 1.114 seconds,   14.368 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
SHA1               120 KB took 1.012 seconds,  118.618 KB/s
SHA256             122 KB took 1.012 seconds,  120.551 KB/s
SHA384             120 KB took 1.003 seconds,  119.608 KB/s
RSA     2048 key gen        5 ops took 17.043 sec, avg 3408.678 ms, 0.293 ops/sec
RSA     2048 Public       134 ops took 1.004 sec, avg 7.490 ms, 133.517 ops/sec
RSA     2048 Private       15 ops took 1.054 sec, avg 70.261 ms, 14.233 ops/sec
RSA     2048 Pub  OAEP    116 ops took 1.002 sec, avg 8.636 ms, 115.797 ops/sec
RSA     2048 Priv OAEP     15 ops took 1.061 sec, avg 70.716 ms, 14.141 ops/sec
ECC      256 key gen       12 ops took 1.008 sec, avg 84.020 ms, 11.902 ops/sec
ECDSA    256 sign          18 ops took 1.015 sec, avg 56.399 ms, 17.731 ops/sec
ECDSA    256 verify        26 ops took 1.018 sec, avg 39.164 ms, 25.533 ops/sec
ECDHE    256 agree         35 ops took 1.029 sec, avg 29.402 ms, 34.011 ops/sec
```
