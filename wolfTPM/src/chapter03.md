# Getting Started

The wolfTPM library has TPM 2.0 wrapper tests, native tests, and a sample benchmark application that come ready-to-use after a successful installation of wolfTPM. Below are some instructions on how to run the sample applications yourself.

To interface with the hardware platform that is running these applications, please see the function `TPM2_IoCb` inside of `tpm_demo.c`.

## Examples

The two example applications are focused on testing the wrapper APIs and native interfaces for the Raspberry Pi 3, or the STM32 with the CubeMX HAL.

By default, when running the examples wolfTPM will use the native `spi_dev` interface on the Raspberry Pi, and defaults to `/dev/spidev0.1`. If these examples are being tested with the Infineon patches on the Infineon OPTIGASLB9670, then they will override the kernel interface
with their `spi_tis_dev`, causing an error.

If desired, the wolfTPM library can be built with debugging enabled for a more detailed example application output. To do this, simply run the `configure` script like this:
```c
$ ./configure --enable-debug
```
If everything has been set up correctly, the example applications should have the following output:
```c
$ ./examples/wrap/wrap_test
TPM2 Demo for Wrapper APIs
RSA Encrypt Test Passed
ECC Sign/Verify Test Passed
ECC DH Generation Passed
NV Test on index 0x1800200 with 1024 bytes passed
```
```c
$ ./examples/native/native_test
TPM2 Demo using Native API's
TPM2: Caps 0x30000697, Did 0x001b, Vid 0x15d1, Rid 0x10
TPM2_Startup pass
TPM2_SelfTest pass
TPM2_GetTestResult: Size 10, Rc 0x
TPM2_IncrementalSelfTest: Rc 0x0, Alg 0x1 (Todo 0)
TPM2_GetCapability: Property FamilyIndicator 0x322e3000
TPM2_GetCapability: Property PCR Count 24
TPM2_GetRandom: Got 32 bytes
TPM2_StirRandom: success
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 1, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 2, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 3, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 4, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 5, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 6, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 7, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 8, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 9, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 10, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 11, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 12, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 13, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 14, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 15, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 16, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 17, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 18, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 19, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 20, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 21, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 22, Digest Sz 32, Update Counter 21
TPM2_PCR_Read: Index 23, Digest Sz 32, Update Counter 21
TPM2_PCR_Extend success
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 22
TPM2_StartAuthSession: sessionHandle 0x3000000
TPM2_PolicyGetDigest: size 32
TPM2_PCR_Read: Index 0, Digest Sz 20, Update Counter 22
wc_Hash of PCR[0]: size 32
TPM2_PolicyPCR failed 0x1c4: TPM_RC_AUTHSIZE
TPM2_PolicyPCR: Updated
TPM2_PolicyRestart: Done
TPM2_HashSequenceStart: sequenceHandle 0x80000000
Hash SHA256 test success
TPM2_CreatePrimary: Endorsement 0x80000000 (314 bytes)
TPM2_CreatePrimary: Storage 0x80000001 (282 bytes)
TPM2_LoadExternal: 0x80000002
TPM2_MakeCredential: credentialBlob 68, secret 256
TPM2_ReadPublic Handle 0x80000002: pub 314, name 34, qualifiedName 34
Create HMAC-SHA256 Key success, public 48, Private 141
TPM2_Load New HMAC Key Handle 0x80000002
TPM2_PolicyCommandCode: success
TPM2_ObjectChangeAuth failed 0x9a2: TPM_RC_BAD_AUTH
TPM2_ObjectChangeAuth: private 2
TPM2_ECC_Parameters: CurveID 3, sz 256, p 32, a 32, b 32, gX 32, gY 32, n 32, h 1
TPM2_Create: New ECDSA Key: pub 88, priv 126
TPM2_Load ECDSA Key Handle 0x80000002
TPM2_Sign: ECC S 32, R 32
TPM2_VerifySignature: Tag 32802
TPM2_Create: New ECDH Key: pub 88, priv 126
TPM2_Load ECDH Key Handle 0x80000002
TPM2_ECDH_KeyGen: zPt 68, pubPt 68
TPM2_Create: New RSA Key: pub 278, priv 222
TPM2_Load RSA Key Handle 0x80000002
TPM2_RSA_Encrypt: 256
TPM2_RSA_Decrypt: 32
RSA Encrypt/Decrypt test passed
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_ReadPublic failed 0x18b: TPM_RC_HANDLE
TPM2_NV_DefineSpace failed 0x184: TPM_RC_VALUE
```

## Benchmarks

The wolfTPM benchmark application requires the same setup as the example applications. Below is a sample output from running the benchmark application on an Infineon OPTIGA SLB9670:
```c
$ ./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RSA    2048 Public        65 ops took 1.005 sec, avg 15.466 ms, 64.657 ops/sec
RSA     2048 Private        3 ops took 1.343 sec, avg 447.759 ms, 2.233 ops/sec
RSA     2048 Pub  OAEP     12 ops took 1.040 sec, avg 86.657 ms, 11.540 ops/sec
RSA     2048 Priv OAEP      2 ops took 1.032 sec, avg 515.885 ms, 1.938 ops/sec
ECDSA    256 sign          14 ops took 1.037 sec, avg 74.101 ms, 13.495 ops/sec
ECDSA    256 verify         8 ops took 1.027 sec, avg 128.417 ms, 7.787 ops/sec
ECDHE    256 agree          8 ops took 1.040 sec, avg 130.003 ms, 7.692 ops/sec
```
