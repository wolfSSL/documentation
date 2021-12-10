# API Reference






## TPM2 Proprietary

This module describes TPM2 commands specific only to wolfTPM.  [More...](#detailed-description)

### Functions

|                | Name           |
| -------------- | -------------- |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Initializes a TPM with HAL IO callback and user supplied context. When using wolfTPM with &ndash;enable-devtpm or &ndash;enable-swtpm configuration, the ioCb and userCtx are not used.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx, int timeoutTries)<br>Initializes a TPM with timeoutTries, HAL IO callback and user supplied context.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_Init_minimal]() * ctx)<br>Initializes a TPM and sets the wolfTPM2 context that will be used. This function is typically used for rich operating systems, like Windows.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_Cleanup]() * ctx)<br>Deinitializes a TPM and wolfcrypt (if it was initialized)  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_ChipStartup]() * ctx, int timeoutTries)<br>Makes sure the TPM2 startup has completed and extracts the TPM device information.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Sets the user's context and IO callbacks needed for TPM communication.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_SetSessionAuth]() * session)<br>Sets the structure holding the TPM Authorizations.  |
| WOLFTPM_API int | **[TPM2_GetSessionAuthCount]() * ctx)<br>Determine the number of currently set TPM Authorizations.  |
| WOLFTPM_API void | **[TPM2_SetActiveCtx]() * ctx)<br>Sets a new TPM2 context for use.  |
| WOLFTPM_API [TPM2_CTX](#function-tpm2-getactivectx)**(void )<br>Provides a pointer to the TPM2 context in use.  |
| WOLFTPM_API int | **[TPM2_GetHashDigestSize](#typedef-tpmi-alg-hash) hashAlg)<br>Determine the size in bytes of a TPM 2.0 hash digest.  |
| WOLFTPM_API int | **[TPM2_GetHashType](#typedef-tpmi-alg-hash) hashAlg)<br>Translate a TPM2 hash type to its coresponding wolfcrypt hash type.  |
| WOLFTPM_API int | **[TPM2_GetNonce](#function-tpm2-getnonce)**(byte * nonceBuf, int nonceSz)<br>Generate a fresh nonce of random numbers.  |
| WOLFTPM_API void | **[TPM2_SetupPCRSel](#typedef-tpm-alg-id) alg, int pcrIndex)<br>Helper function to prepare a correct PCR selection For example, when preparing to create a TPM2_Quote.  |
| const WOLFTPM_API char * | **[TPM2_GetRCString](#function-tpm2-getrcstring)**(int rc)<br>Get a human readable string for any TPM 2.0 return code.  |
| const WOLFTPM_API char * | **[TPM2_GetAlgName](#typedef-tpm-alg-id) alg)<br>Get a human readable string for any TPM 2.0 algorithm.  |
| WOLFTPM_API int | **[TPM2_GetCurveSize](#typedef-tpm-ecc-curve) curveID)<br>Determine the size in bytes of any TPM ECC Curve.  |
| WOLFTPM_API int | **[TPM2_GetTpmCurve](#function-tpm2-gettpmcurve)**(int curveID)<br>Translate a wolfcrypt curve type to its coresponding TPM curve type.  |
| WOLFTPM_API int | **[TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)**(int curve_id)<br>Translate a TPM curve type to its coresponding wolfcrypt curve type.  |
| WOLFTPM_API int | **[TPM2_ParseAttest]() structure.  |
| WOLFTPM_API int | **[TPM2_HashNvPublic]() * nvPublic, byte * buffer, UINT16 * size)<br>Computes fresh NV Index name based on a nvPublic structure.  |
| WOLFTPM_API int | **[TPM2_AppendPublic]() structure based on a user provided buffer.  |
| WOLFTPM_API int | **[TPM2_ParsePublic]() structure and stores in a user provided buffer.  |
| WOLFTPM_LOCAL int | **[TPM2_GetName]() * name)<br>Provides the Name of a TPM object.  |
| WOLFTPM_API UINT16 | **[TPM2_GetVendorID](#function-tpm2-getvendorid)**(void )<br>Provides the vendorID of the active TPM2 context.  |
| WOLFTPM_API void | **[TPM2_PrintBin](#function-tpm2-printbin)**(const byte * buffer, word32 length)<br>Helper function to print a binary buffer in a formated way.  |
| WOLFTPM_API void | **[TPM2_PrintAuth]() type in a human readable way.  |
| WOLFTPM_API void | **[TPM2_PrintPublicArea]() type in a human readable way.  |

### Detailed Description

This module describes TPM2 commands specific only to wolfTPM. 

Typically, these commands include helpers for handling TPM 2.0 data structures.

There are also functions to help debugging and testing during development. 


### Functions Documentation

#### function TPM2_Init

```
WOLFTPM_API TPM_RC TPM2_Init(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Initializes a TPM with HAL IO callback and user supplied context. When using wolfTPM with &ndash;enable-devtpm or &ndash;enable-swtpm configuration, the ioCb and userCtx are not used. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct


**See**: 

  * [TPM2_Startup](#function-tpm2-startup)
  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init_ex](#function-tpm2-init-ex)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: [TPM2_Init_minimal()](#function-tpm2-init-ex) with both ioCb and userCtx set to NULL. In other modes, the ioCb shall be set in order to use TIS. Example ioCB for baremetal and RTOS applications are provided in examples/tpm_io.c

_Example_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Init(&tpm2Ctx, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Init failed
}
```


#### function TPM2_Init_ex

```
WOLFTPM_API TPM_RC TPM2_Init_ex(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx,
    int timeoutTries
)
```

Initializes a TPM with timeoutTries, HAL IO callback and user supplied context. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct 
  * **timeoutTries** specifies the number of attempts to confirm that TPM2 startup has completed


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init](#function-tpm2-init)
  * wolfTPM2_Init_ex 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: It is recommended to use TPM2_Init instead of using TPM2_Init_ex directly.

#### function TPM2_Init_minimal

```
WOLFTPM_API TPM_RC TPM2_Init_minimal(
    TPM2_CTX * ctx
)
```

Initializes a TPM and sets the wolfTPM2 context that will be used. This function is typically used for rich operating systems, like Windows. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: It is recommended to use TPM2_Init instead of using TPM2_Init_minimal directly.

#### function TPM2_Cleanup

```
WOLFTPM_API TPM_RC TPM2_Cleanup(
    TPM2_CTX * ctx
)
```

Deinitializes a TPM and wolfcrypt (if it was initialized) 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 device structure is a NULL pointer


_Example_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Cleanup(&tpm2Ctx->dev);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Cleanup failed
}
```


#### function TPM2_ChipStartup

```
WOLFTPM_API TPM_RC TPM2_ChipStartup(
    TPM2_CTX * ctx,
    int timeoutTries
)
```

Makes sure the TPM2 startup has completed and extracts the TPM device information. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **timeoutTries** specifies the number of attempts to check if TPM2 startup has completed


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * TPM2_TIS_StartupWait 
  * TPM2_TIS_RequestLocality 
  * TPM2_TIS_GetInfo 
  * [TPM2_Init_ex](#function-tpm2-init-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG: check the provided arguments 
  * TPM_RC_TIMEOUT: timeout occurred


**Note**: This function is used in TPM2_Init_ex

#### function TPM2_SetHalIoCb

```
WOLFTPM_API TPM_RC TPM2_SetHalIoCb(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Sets the user's context and IO callbacks needed for TPM communication. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 device structure is a NULL pointer


**Note**: SetHalIoCb will fail if built with devtpm or swtpm as the callback is not used for TPM. For other configuration builds, ioCb must be set to a non-NULL function pointer and userCtx is optional.

Typically, TPM2_Init or wolfTPM2_Init are used to set the HAL IO. 


#### function TPM2_SetSessionAuth

```
WOLFTPM_API TPM_RC TPM2_SetSessionAuth(
    TPM2_AUTH_SESSION * session
)
```

Sets the structure holding the TPM Authorizations. 

**Parameters**: 

  * **session** pointer to an array of type [TPM2_AUTH_SESSION]()


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 context structure is a NULL pointer


Rarely used, because TPM2_Init functions and wolfTPM2_Init perform this initialization as well TPM 2.0 Commands can have up to three authorization slots, therefore it is recommended to supply an array of size MAX_SESSION_NUM to TPM2_SetSessionAuth(see example below).

_Example_

```cpp
int rc;
TPM2_AUTH_SESSION session[MAX_SESSION_NUM];

XMEMSET(session, 0, sizeof(session));
session[0].sessionHandle = TPM_RS_PW;

rc = TPM2_SetSessionAuth(session);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_SetSessionAuth failed
}
```


#### function TPM2_GetSessionAuthCount

```
WOLFTPM_API int TPM2_GetSessionAuthCount(
    TPM2_CTX * ctx
)
```

Determine the number of currently set TPM Authorizations. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**Return**: 

  * the number of active TPM Authorizations (between one and three) 
  * BAD_FUNC_ARG: check the arguments provided for a NULL pointer


_Example_

```cpp
int authCount;
TPM2_CTX tpm2Ctx;

authCount = TPM2_GetSessionAuthCount(tpm2ctx);
if (authCount == BAD_FUNC_ARG) {
    // TPM2_GetSessionAuthCount failed
}
```


#### function TPM2_SetActiveCtx

```
WOLFTPM_API void TPM2_SetActiveCtx(
    TPM2_CTX * ctx
)
```

Sets a new TPM2 context for use. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


_Example_

```cpp
TPM2_CTX tpm2Ctx;

TPM2_SetActiveCtx(tpm2ctx);
```


#### function TPM2_GetActiveCtx

```
WOLFTPM_API TPM2_CTX * TPM2_GetActiveCtx(
    void 
)
```

Provides a pointer to the TPM2 context in use. 

**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**Return**: ctx pointer to a [TPM2_CTX]() struct

_Example_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```


#### function TPM2_GetHashDigestSize

```
WOLFTPM_API int TPM2_GetHashDigestSize(
    TPMI_ALG_HASH hashAlg
)
```

Determine the size in bytes of a TPM 2.0 hash digest. 

**Parameters**: 

  * **hashAlg** a valid TPM 2.0 hash type


**Return**: 

  * the size of a TPM 2.0 hash digest as number of bytes 
  * 0 if hash type is invalid


_Example_

```cpp
int digestSize = 0;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

digestSize = TPM2_GetHashDigestSize(hashAlg);
if (digestSize > 0) {
    //digestSize contains a valid value
}
```


#### function TPM2_GetHashType

```
WOLFTPM_API int TPM2_GetHashType(
    TPMI_ALG_HASH hashAlg
)
```

Translate a TPM2 hash type to its coresponding wolfcrypt hash type. 

**Parameters**: 

  * **hashAlg** a valid TPM 2.0 hash type


**Return**: 

  * a value specifying a hash type to use with wolfcrypt 
  * 0 if hash type is invalid


_Example_

```cpp
int wc_hashType;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

wc_hashType = TPM2_GetHashDigestSize(hashAlg);
if (wc_hashType > 0) {
    //wc_hashType contains a valid wolfcrypt hash type
}
```


#### function TPM2_GetNonce

```
WOLFTPM_API int TPM2_GetNonce(
    byte * nonceBuf,
    int nonceSz
)
```

Generate a fresh nonce of random numbers. 

**Parameters**: 

  * **nonceBuf** pointer to a BYTE buffer 
  * **nonceSz** size of the nonce in bytes


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (TPM IO issue or wolfcrypt configuration) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Can use the TPM random number generator if WOLFTPM2_USE_HW_RNG is defined

_Example_

```cpp
int rc, nonceSize = 32;
BYTE freshNonce[32];

rc = TPM2_GetNonce(&freshNonce, nonceSize);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetNonce failed
}
```


#### function TPM2_SetupPCRSel

```
WOLFTPM_API void TPM2_SetupPCRSel(
    TPML_PCR_SELECTION * pcr,
    TPM_ALG_ID alg,
    int pcrIndex
)
```

Helper function to prepare a correct PCR selection For example, when preparing to create a TPM2_Quote. 

**Parameters**: 

  * **pcr** pointer to a structure of type [TPML_PCR_SELECTION]()
  * **alg** value of type TPM_ALG_ID specifying the type of hash algorithm used 
  * **pcrIndex** value between 0 and 23 specifying the PCR register for use


**See**: 

  * [TPM2_PCR_Read](#function-tpm2-pcr-read)
  * [TPM2_PCR_Extend](#function-tpm2-pcr-extend)
  * [TPM2_PCR_Reset](#function-tpm2-pcr-reset)
  * [TPM2_Quote](#function-tpm2-quote)


_Example_

```cpp
int pcrIndex = 16; // This is a PCR register for DEBUG & testing purposes
PCR_Read_In pcrRead;

TPM2_SetupPCRSel(&pcrRead.pcrSelectionIn, TPM_ALG_SHA256, pcrIndex);
```


#### function TPM2_GetRCString

```
const WOLFTPM_API char * TPM2_GetRCString(
    int rc
)
```

Get a human readable string for any TPM 2.0 return code. 

**Parameters**: 

  * **rc** integer value representing a TPM return code


**Return**: pointer to a string constant

_Example_

```cpp
int rc;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    printf("wolfTPM2_Init failed 0x%x: %s\n", rc, TPM2_GetRCString(rc));
    return rc;
}
```


#### function TPM2_GetAlgName

```
const WOLFTPM_API char * TPM2_GetAlgName(
    TPM_ALG_ID alg
)
```

Get a human readable string for any TPM 2.0 algorithm. 

**Parameters**: 

  * **alg** value of type TPM_ALG_ID specifying a valid TPM 2.0 algorithm


**Return**: pointer to a string constant

_Example_

```cpp
int paramEncAlg = TPM_ALG_CFB;

printf("\tUse Parameter Encryption: %s\n", TPM2_GetAlgName(paramEncAlg));
```


#### function TPM2_GetCurveSize

```
WOLFTPM_API int TPM2_GetCurveSize(
    TPM_ECC_CURVE curveID
)
```

Determine the size in bytes of any TPM ECC Curve. 

**Parameters**: 

  * **curveID** value of type TPM_ECC_CURVE


**Return**: 

  * 0 in case of invalid curve type 
  * integer value representing the number of bytes


_Example_

```cpp
int bytes;
TPM_ECC_CURVE curve = TPM_ECC_NIST_P256;

bytes = TPM2_GetCurveSize(curve);
if (bytes == 0) {
    //TPM2_GetCurveSize failed
}
```


#### function TPM2_GetTpmCurve

```
WOLFTPM_API int TPM2_GetTpmCurve(
    int curveID
)
```

Translate a wolfcrypt curve type to its coresponding TPM curve type. 

**Parameters**: 

  * **curveID** pointer to a BYTE buffer


**See**: [TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)

**Return**: 

  * integer value representing a wolfcrypt curve type 
  * ECC_CURVE_OID_E in case of invalid curve type


_Example_

```cpp
int tpmCurve;
int wc_curve = ECC_SECP256R1;

tpmCurve = TPM2_GetTpmCurve(curve);
\in this case tpmCurve will be TPM_ECC_NIST_P256
if (tpmCurve = ECC_CURVE_OID_E) {
    //TPM2_GetTpmCurve failed
}
```


#### function TPM2_GetWolfCurve

```
WOLFTPM_API int TPM2_GetWolfCurve(
    int curve_id
)
```

Translate a TPM curve type to its coresponding wolfcrypt curve type. 

**Parameters**: 

  * **curve_id** pointer to a BYTE buffer


**See**: [TPM2_GetTpmCurve](#function-tpm2-gettpmcurve)

**Return**: 

  * integer value representing a TPM curve type 
  * -1 or ECC_CURVE_OID_E in case of invalid curve type


_Example_

```cpp
int tpmCurve = TPM_ECC_NIST_P256;
int wc_curve;

wc_curve = TPM2_GetWolfCurve(tpmCurve);
\in this case tpmCurve will be ECC_SECP256R1
if (wc_curve = ECC_CURVE_OID_E || wc_curve == -1) {
    //TPM2_GetWolfCurve failed
}
```


#### function TPM2_ParseAttest

```
WOLFTPM_API int TPM2_ParseAttest(
    const TPM2B_ATTEST * in,
    TPMS_ATTEST * out
)
```

Parses [TPM2B_ATTEST]() structure. 

**Parameters**: 

  * **in** pointer to a structure of a [TPM2B_ATTEST]() type 
  * **out** pointer to a structure of a [TPMS_ATTEST]() type


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This is public API of the helper function TPM2_Packet_ParseAttest

_Example_

```cpp
TPM2B_ATTEST in; //for example, as part of a TPM2_Quote
TPMS_ATTEST out

rc = TPM2_GetNonce(&in, &out);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParseAttest failed
}
```


#### function TPM2_HashNvPublic

```
WOLFTPM_API int TPM2_HashNvPublic(
    TPMS_NV_PUBLIC * nvPublic,
    byte * buffer,
    UINT16 * size
)
```

Computes fresh NV Index name based on a nvPublic structure. 

**Parameters**: 

  * **nvPublic** 
  * **buffer** pointer to a structure of a [TPMS_ATTEST]() type 
  * **size** pointer to a variable of UINT16 type to store the size of the nvIndex


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * negative integer value in case of an error 
  * BAD_FUNC_ARG: check the provided arguments 
  * NOT_COMPILED_IN: check if wolfcrypt is enabled


_Example_

```cpp
TPMS_NV_PUBLIC nvPublic;
BYTE buffer[TPM_MAX_DIGEST_SIZE];
UINT16 size;

rc = TPM2_HashNvPublic(&nvPublic, &buffer, &size);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_HashNvPublic failed
}
```


#### function TPM2_AppendPublic

```
WOLFTPM_API int TPM2_AppendPublic(
    byte * buf,
    word32 size,
    int * sizeUsed,
    TPM2B_PUBLIC * pub
)
```

Populates [TPM2B_PUBLIC]() structure based on a user provided buffer. 

**Parameters**: 

  * **buf** pointer to a user buffer 
  * **size** integer value of word32 type, specifying the size of the user buffer 
  * **sizeUsed** pointer to an integer variable, stores the used size of pub->buffer 
  * **pub** pointer to an empty structure of [TPM2B_PUBLIC]() type


**See**: [TPM2_ParsePublic](#function-tpm2-parsepublic)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: insufficient buffer size 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Public API of the helper function TPM2_Packet_AppendPublic

_Example_

```cpp
TPM2B_PUBLIC pub; //empty
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_AppendPublic(&buffer, size, &sizeUsed, &pub);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_AppendPublic failed
}
```


#### function TPM2_ParsePublic

```
WOLFTPM_API int TPM2_ParsePublic(
    TPM2B_PUBLIC * pub,
    byte * buf,
    word32 size,
    int * sizeUsed
)
```

Parses [TPM2B_PUBLIC]() structure and stores in a user provided buffer. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **buf** pointer to an empty user buffer 
  * **size** integer value of word32 type, specifying the available size of the user buffer 
  * **sizeUsed** pointer to an integer variable, stores the used size of the user buffer


**See**: [TPM2_AppendPublic](#function-tpm2-appendpublic)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: insufficient buffer size 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Public API of the helper function TPM2_Packet_ParsePublic

_Example_

```cpp
TPM2B_PUBLIC pub; //populated
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_ParsePublic(&pub, buffer, size, &sizeUsed);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParsePublic failed
}
```


#### function TPM2_GetName

```
WOLFTPM_LOCAL int TPM2_GetName(
    TPM2_CTX * ctx,
    UINT32 handleValue,
    int handleCnt,
    int idx,
    TPM2B_NAME * name
)
```

Provides the Name of a TPM object. 

**Parameters**: 

  * **ctx** pointer to a TPM2 context 
  * **handleValue** value of UINT32 type, specifying a valid TPM handle 
  * **handleCnt** total number of handles used in the current TPM command/session 
  * **idx** index value, between one and three, specifying a valid TPM Authorization session 
  * **name** pointer to an empty structure of [TPM2B_NAME]() type


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The object is reference by its TPM handle and session index

_Example_

```cpp
int rc;
UINT32 handleValue = TRANSIENT_FIRST;
handleCount = 1;
sessionIdx = 0;
TPM2B_NAME name;

rc = TPM2_GetName(ctx, handleValue, handleCount, sessionIdx, &name);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetName failed
}
```


#### function TPM2_GetVendorID

```
WOLFTPM_API UINT16 TPM2_GetVendorID(
    void 
)
```

Provides the vendorID of the active TPM2 context. 

**See**: 

  * TPM2_GetCapabilities 
  * TPM2_GetTpmDevId 
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * integer value of UINT16 type, specifying the vendor ID 
  * 0 if TPM2 context is invalid or NULL


**Note**: Depends on correctly read TPM device info during TPM Init

_Example_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```


#### function TPM2_PrintBin

```
WOLFTPM_API void TPM2_PrintBin(
    const byte * buffer,
    word32 length
)
```

Helper function to print a binary buffer in a formated way. 

**Parameters**: 

  * **buffer** pointer to a buffer of BYTE type 
  * **length** integer value of word32 type, containing the size of the buffer


**See**: 

  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
BYTE buffer[] = {0x01,0x02,0x03,0x04};
length = sizeof(buffer);

TPM2_PrintBin(&buffer, length);
```


#### function TPM2_PrintAuth

```
WOLFTPM_API void TPM2_PrintAuth(
    const TPMS_AUTH_COMMAND * authCmd
)
```

Helper function to print a structure of [TPMS_AUTH_COMMAND]() type in a human readable way. 

**Parameters**: 

  * **authCmd** pointer to a populated structure of [TPMS_AUTH_COMMAND]() type


**See**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
TPMS_AUTH_COMMAND authCmd; //for example, part of a TPM Authorization session

TPM2_PrintAuthCmd(&authCmd);
```


#### function TPM2_PrintPublicArea

```
WOLFTPM_API void TPM2_PrintPublicArea(
    const TPM2B_PUBLIC * pub
)
```

Helper function to print a structure of [TPM2B_PUBLIC]() type in a human readable way. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type


**See**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_Create](#function-tpm2-create)
  * [TPM2_ReadPublic](#function-tpm2-readpublic)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
TPM2B_PUBLIC pub; //for example, part of the output of a successful TPM2_Create

TPM2_PrintPublicArea(&pub);
```













## wolftpm/tpm2.h



### Classes

|                | Name           |
| -------------- | -------------- |
| struct | **[TPMS_ALGORITHM_DESCRIPTION]()**  |
| union | **[TPMU_HA](Classes/unionTPMU__HA.md)**  |
| struct | **[TPMT_HA]()**  |
| struct | **[TPM2B_DIGEST]()**  |
| struct | **[TPM2B_DATA]()**  |
| struct | **[TPM2B_EVENT]()**  |
| struct | **[TPM2B_MAX_BUFFER]()**  |
| struct | **[TPM2B_MAX_NV_BUFFER]()**  |
| struct | **[TPM2B_IV]()**  |
| union | **[TPMU_NAME](Classes/unionTPMU__NAME.md)**  |
| struct | **[TPM2B_NAME]()**  |
| struct | **[TPMS_PCR_SELECT]()**  |
| struct | **[TPMS_PCR_SELECTION]()**  |
| struct | **[TPMT_TK_CREATION]()**  |
| struct | **[TPMT_TK_VERIFIED]()**  |
| struct | **[TPMT_TK_AUTH]()**  |
| struct | **[TPMT_TK_HASHCHECK]()**  |
| struct | **[TPMS_ALG_PROPERTY]()**  |
| struct | **[TPMS_TAGGED_PROPERTY]()**  |
| struct | **[TPMS_TAGGED_PCR_SELECT]()**  |
| struct | **[TPMS_TAGGED_POLICY]()**  |
| struct | **[TPML_CC]()**  |
| struct | **[TPML_CCA]()**  |
| struct | **[TPML_ALG]()**  |
| struct | **[TPML_HANDLE]()**  |
| struct | **[TPML_DIGEST]()**  |
| struct | **[TPML_DIGEST_VALUES]()**  |
| struct | **[TPML_PCR_SELECTION]()**  |
| struct | **[TPML_ALG_PROPERTY]()**  |
| struct | **[TPML_TAGGED_TPM_PROPERTY]()**  |
| struct | **[TPML_TAGGED_PCR_PROPERTY]()**  |
| struct | **[TPML_ECC_CURVE]()**  |
| struct | **[TPML_TAGGED_POLICY]()**  |
| union | **[TPMU_CAPABILITIES](Classes/unionTPMU__CAPABILITIES.md)**  |
| struct | **[TPMS_CAPABILITY_DATA]()**  |
| struct | **[TPMS_CLOCK_INFO]()**  |
| struct | **[TPMS_TIME_INFO]()**  |
| struct | **[TPMS_TIME_ATTEST_INFO]()**  |
| struct | **[TPMS_CERTIFY_INFO]()**  |
| struct | **[TPMS_QUOTE_INFO]()**  |
| struct | **[TPMS_COMMAND_AUDIT_INFO]()**  |
| struct | **[TPMS_SESSION_AUDIT_INFO]()**  |
| struct | **[TPMS_CREATION_INFO]()**  |
| struct | **[TPMS_NV_CERTIFY_INFO]()**  |
| union | **[TPMU_ATTEST](Classes/unionTPMU__ATTEST.md)**  |
| struct | **[TPMS_ATTEST]()**  |
| struct | **[TPM2B_ATTEST]()**  |
| union | **[TPMU_SYM_KEY_BITS](Classes/unionTPMU__SYM__KEY__BITS.md)**  |
| union | **[TPMU_SYM_MODE](Classes/unionTPMU__SYM__MODE.md)**  |
| struct | **[TPMT_SYM_DEF]()**  |
| struct | **[TPM2B_SYM_KEY]()**  |
| struct | **[TPMS_SYMCIPHER_PARMS]()**  |
| struct | **[TPM2B_LABEL]()**  |
| struct | **[TPMS_DERIVE]()**  |
| struct | **[TPM2B_DERIVE]()**  |
| union | **[TPMU_SENSITIVE_CREATE](Classes/unionTPMU__SENSITIVE__CREATE.md)**  |
| struct | **[TPM2B_SENSITIVE_DATA]()**  |
| struct | **[TPMS_SENSITIVE_CREATE]()**  |
| struct | **[TPM2B_SENSITIVE_CREATE]()**  |
| struct | **[TPMS_SCHEME_HASH]()**  |
| struct | **[TPMS_SCHEME_ECDAA]()**  |
| union | **[TPMU_SCHEME_KEYEDHASH](Classes/unionTPMU__SCHEME__KEYEDHASH.md)**  |
| struct | **[TPMT_KEYEDHASH_SCHEME]()**  |
| union | **[TPMU_SIG_SCHEME](Classes/unionTPMU__SIG__SCHEME.md)**  |
| struct | **[TPMT_SIG_SCHEME]()**  |
| union | **[TPMU_KDF_SCHEME](Classes/unionTPMU__KDF__SCHEME.md)**  |
| struct | **[TPMT_KDF_SCHEME]()**  |
| union | **[TPMU_ASYM_SCHEME](Classes/unionTPMU__ASYM__SCHEME.md)**  |
| struct | **[TPMT_ASYM_SCHEME]()**  |
| struct | **[TPMT_RSA_SCHEME]()**  |
| struct | **[TPMT_RSA_DECRYPT]()**  |
| struct | **[TPM2B_PUBLIC_KEY_RSA]()**  |
| struct | **[TPM2B_PRIVATE_KEY_RSA]()**  |
| struct | **[TPM2B_ECC_PARAMETER]()**  |
| struct | **[TPMS_ECC_POINT]()**  |
| struct | **[TPM2B_ECC_POINT]()**  |
| struct | **[TPMS_ALGORITHM_DETAIL_ECC]()**  |
| struct | **[TPMS_SIGNATURE_RSA]()**  |
| struct | **[TPMS_SIGNATURE_ECC]()**  |
| union | **[TPMU_SIGNATURE](Classes/unionTPMU__SIGNATURE.md)**  |
| struct | **[TPMT_SIGNATURE]()**  |
| union | **[TPMU_ENCRYPTED_SECRET](Classes/unionTPMU__ENCRYPTED__SECRET.md)**  |
| struct | **[TPM2B_ENCRYPTED_SECRET]()**  |
| union | **[TPMU_PUBLIC_ID](Classes/unionTPMU__PUBLIC__ID.md)**  |
| struct | **[TPMS_KEYEDHASH_PARMS]()**  |
| struct | **[TPMS_ASYM_PARMS]()**  |
| struct | **[TPMS_RSA_PARMS]()**  |
| struct | **[TPMS_ECC_PARMS]()**  |
| union | **[TPMU_PUBLIC_PARMS](Classes/unionTPMU__PUBLIC__PARMS.md)**  |
| struct | **[TPMT_PUBLIC_PARMS]()**  |
| struct | **[TPMT_PUBLIC]()**  |
| struct | **[TPM2B_PUBLIC]()**  |
| struct | **[TPM2B_TEMPLATE]()**  |
| struct | **[TPM2B_PRIVATE_VENDOR_SPECIFIC]()**  |
| union | **[TPMU_SENSITIVE_COMPOSITE](Classes/unionTPMU__SENSITIVE__COMPOSITE.md)**  |
| struct | **[TPMT_SENSITIVE]()**  |
| struct | **[TPM2B_SENSITIVE]()**  |
| struct | **[TPMT_PRIVATE]()**  |
| struct | **[TPM2B_PRIVATE]()**  |
| struct | **[TPMS_ID_OBJECT]()**  |
| struct | **[TPM2B_ID_OBJECT]()**  |
| struct | **[TPMS_NV_PIN_COUNTER_PARAMETERS]()**  |
| struct | **[TPMS_NV_PUBLIC]()**  |
| struct | **[TPM2B_NV_PUBLIC]()**  |
| struct | **[TPM2B_CONTEXT_SENSITIVE]()**  |
| struct | **[TPMS_CONTEXT_DATA]()**  |
| struct | **[TPM2B_CONTEXT_DATA]()**  |
| struct | **[TPMS_CONTEXT]()**  |
| struct | **[TPMS_CREATION_DATA]()**  |
| struct | **[TPM2B_CREATION_DATA]()**  |
| struct | **[TPMS_AUTH_COMMAND]()**  |
| struct | **[TPMS_AUTH_RESPONSE]()**  |
| struct | **[TPM2_AUTH_SESSION]()**  |
| struct | **[wolfTPM_tcpContext]()**  |
| struct | **[wolfTPM_winContext]()**  |
| struct | **[TPM2_CTX]()**  |
| struct | **[Startup_In]()**  |
| struct | **[Shutdown_In]()**  |
| struct | **[GetCapability_In]()**  |
| struct | **[GetCapability_Out]()**  |
| struct | **[SelfTest_In]()**  |
| struct | **[IncrementalSelfTest_In]()**  |
| struct | **[IncrementalSelfTest_Out]()**  |
| struct | **[GetTestResult_Out]()**  |
| struct | **[GetRandom_In]()**  |
| struct | **[GetRandom_Out]()**  |
| struct | **[StirRandom_In]()**  |
| struct | **[PCR_Read_In]()**  |
| struct | **[PCR_Read_Out]()**  |
| struct | **[PCR_Extend_In]()**  |
| struct | **[Create_In]()**  |
| struct | **[Create_Out]()**  |
| struct | **[CreateLoaded_In]()**  |
| struct | **[CreateLoaded_Out]()**  |
| struct | **[CreatePrimary_In]()**  |
| struct | **[CreatePrimary_Out]()**  |
| struct | **[Load_In]()**  |
| struct | **[Load_Out]()**  |
| struct | **[FlushContext_In]()**  |
| struct | **[Unseal_In]()**  |
| struct | **[Unseal_Out]()**  |
| struct | **[StartAuthSession_In]()**  |
| struct | **[StartAuthSession_Out]()**  |
| struct | **[PolicyRestart_In]()**  |
| struct | **[LoadExternal_In]()**  |
| struct | **[LoadExternal_Out]()**  |
| struct | **[ReadPublic_In]()**  |
| struct | **[ReadPublic_Out]()**  |
| struct | **[ActivateCredential_In]()**  |
| struct | **[ActivateCredential_Out]()**  |
| struct | **[MakeCredential_In]()**  |
| struct | **[MakeCredential_Out]()**  |
| struct | **[ObjectChangeAuth_In]()**  |
| struct | **[ObjectChangeAuth_Out]()**  |
| struct | **[Duplicate_In]()**  |
| struct | **[Duplicate_Out]()**  |
| struct | **[Rewrap_In]()**  |
| struct | **[Rewrap_Out]()**  |
| struct | **[Import_In]()**  |
| struct | **[Import_Out]()**  |
| struct | **[RSA_Encrypt_In]()**  |
| struct | **[RSA_Encrypt_Out]()**  |
| struct | **[RSA_Decrypt_In]()**  |
| struct | **[RSA_Decrypt_Out]()**  |
| struct | **[ECDH_KeyGen_In]()**  |
| struct | **[ECDH_KeyGen_Out]()**  |
| struct | **[ECDH_ZGen_In]()**  |
| struct | **[ECDH_ZGen_Out]()**  |
| struct | **[ECC_Parameters_In]()**  |
| struct | **[ECC_Parameters_Out]()**  |
| struct | **[ZGen_2Phase_In]()**  |
| struct | **[ZGen_2Phase_Out]()**  |
| struct | **[EncryptDecrypt_In]()**  |
| struct | **[EncryptDecrypt_Out]()**  |
| struct | **[EncryptDecrypt2_In]()**  |
| struct | **[EncryptDecrypt2_Out]()**  |
| struct | **[Hash_In]()**  |
| struct | **[Hash_Out]()**  |
| struct | **[HMAC_In]()**  |
| struct | **[HMAC_Out]()**  |
| struct | **[HMAC_Start_In]()**  |
| struct | **[HMAC_Start_Out]()**  |
| struct | **[HashSequenceStart_In]()**  |
| struct | **[HashSequenceStart_Out]()**  |
| struct | **[SequenceUpdate_In]()**  |
| struct | **[SequenceComplete_In]()**  |
| struct | **[SequenceComplete_Out]()**  |
| struct | **[EventSequenceComplete_In]()**  |
| struct | **[EventSequenceComplete_Out]()**  |
| struct | **[Certify_In]()**  |
| struct | **[Certify_Out]()**  |
| struct | **[CertifyCreation_In]()**  |
| struct | **[CertifyCreation_Out]()**  |
| struct | **[Quote_In]()**  |
| struct | **[Quote_Out]()**  |
| struct | **[GetSessionAuditDigest_In]()**  |
| struct | **[GetSessionAuditDigest_Out]()**  |
| struct | **[GetCommandAuditDigest_In]()**  |
| struct | **[GetCommandAuditDigest_Out]()**  |
| struct | **[GetTime_In]()**  |
| struct | **[GetTime_Out]()**  |
| struct | **[Commit_In]()**  |
| struct | **[Commit_Out]()**  |
| struct | **[EC_Ephemeral_In]()**  |
| struct | **[EC_Ephemeral_Out]()**  |
| struct | **[VerifySignature_In]()**  |
| struct | **[VerifySignature_Out]()**  |
| struct | **[Sign_In]()**  |
| struct | **[Sign_Out]()**  |
| struct | **[SetCommandCodeAuditStatus_In]()**  |
| struct | **[PCR_Event_In]()**  |
| struct | **[PCR_Event_Out]()**  |
| struct | **[PCR_Allocate_In]()**  |
| struct | **[PCR_Allocate_Out]()**  |
| struct | **[PCR_SetAuthPolicy_In]()**  |
| struct | **[PCR_SetAuthValue_In]()**  |
| struct | **[PCR_Reset_In]()**  |
| struct | **[PolicySigned_In]()**  |
| struct | **[PolicySigned_Out]()**  |
| struct | **[PolicySecret_In]()**  |
| struct | **[PolicySecret_Out]()**  |
| struct | **[PolicyTicket_In]()**  |
| struct | **[PolicyOR_In]()**  |
| struct | **[PolicyPCR_In]()**  |
| struct | **[PolicyLocality_In]()**  |
| struct | **[PolicyNV_In]()**  |
| struct | **[PolicyCounterTimer_In]()**  |
| struct | **[PolicyCommandCode_In]()**  |
| struct | **[PolicyPhysicalPresence_In]()**  |
| struct | **[PolicyCpHash_In]()**  |
| struct | **[PolicyNameHash_In]()**  |
| struct | **[PolicyDuplicationSelect_In]()**  |
| struct | **[PolicyAuthorize_In]()**  |
| struct | **[PolicyAuthValue_In]()**  |
| struct | **[PolicyPassword_In]()**  |
| struct | **[PolicyGetDigest_In]()**  |
| struct | **[PolicyGetDigest_Out]()**  |
| struct | **[PolicyNvWritten_In]()**  |
| struct | **[PolicyTemplate_In]()**  |
| struct | **[PolicyAuthorizeNV_In]()**  |
| struct | **[HierarchyControl_In]()**  |
| struct | **[SetPrimaryPolicy_In]()**  |
| struct | **[ChangeSeed_In]()**  |
| struct | **[Clear_In]()**  |
| struct | **[ClearControl_In]()**  |
| struct | **[HierarchyChangeAuth_In]()**  |
| struct | **[DictionaryAttackLockReset_In]()**  |
| struct | **[DictionaryAttackParameters_In]()**  |
| struct | **[PP_Commands_In]()**  |
| struct | **[SetAlgorithmSet_In]()**  |
| struct | **[FieldUpgradeStart_In]()**  |
| struct | **[FieldUpgradeData_In]()**  |
| struct | **[FieldUpgradeData_Out]()**  |
| struct | **[FirmwareRead_In]()**  |
| struct | **[FirmwareRead_Out]()**  |
| struct | **[ContextSave_In]()**  |
| struct | **[ContextSave_Out]()**  |
| struct | **[ContextLoad_In]()**  |
| struct | **[ContextLoad_Out]()**  |
| struct | **[EvictControl_In]()**  |
| struct | **[ReadClock_Out]()**  |
| struct | **[ClockSet_In]()**  |
| struct | **[ClockRateAdjust_In]()**  |
| struct | **[TestParms_In]()**  |
| struct | **[NV_DefineSpace_In]()**  |
| struct | **[NV_UndefineSpace_In]()**  |
| struct | **[NV_UndefineSpaceSpecial_In]()**  |
| struct | **[NV_ReadPublic_In]()**  |
| struct | **[NV_ReadPublic_Out]()**  |
| struct | **[NV_Write_In]()**  |
| struct | **[NV_Increment_In]()**  |
| struct | **[NV_Extend_In]()**  |
| struct | **[NV_SetBits_In]()**  |
| struct | **[NV_WriteLock_In]()**  |
| struct | **[NV_GlobalWriteLock_In]()**  |
| struct | **[NV_Read_In]()**  |
| struct | **[NV_Read_Out]()**  |
| struct | **[NV_ReadLock_In]()**  |
| struct | **[NV_ChangeAuth_In]()**  |
| struct | **[NV_Certify_In]()**  |
| struct | **[NV_Certify_Out]()**  |
| struct | **[SetCommandSet_In]()**  |
| struct | **[TPM_MODE_SET]()**  |
| struct | **[SetMode_In]()**  |
| struct | **[TPMS_GPIO_CONFIG]()**  |
| struct | **[TPML_GPIO_CONFIG]()**  |
| struct | **[GpioConfig_In]()**  |
| struct | **[CFG_STRUCT]()**  |
| struct | **[NTC2_PreConfig_In]()**  |
| struct | **[NTC2_GetConfig_Out]()**  |

### Types

|                | Name           |
| -------------- | -------------- |
| enum| **[@0](#enum-@0)** { TPM_SPEC_FAMILY = 0x322E3000, TPM_SPEC_LEVEL = 0, TPM_SPEC_VERSION = 138, TPM_SPEC_YEAR = 2016, TPM_SPEC_DAY_OF_YEAR = 273, TPM_GENERATED_VALUE = 0xff544347} |
| enum| **[TPM_ALG_ID_T](#enum-tpm-alg-id-t)** { TPM_ALG_ERROR = 0x0000, TPM_ALG_RSA = 0x0001, TPM_ALG_SHA = 0x0004, TPM_ALG_SHA1 = TPM_ALG_SHA, TPM_ALG_HMAC = 0x0005, TPM_ALG_AES = 0x0006, TPM_ALG_MGF1 = 0x0007, TPM_ALG_KEYEDHASH = 0x0008, TPM_ALG_XOR = 0x000A, TPM_ALG_SHA256 = 0x000B, TPM_ALG_SHA384 = 0x000C, TPM_ALG_SHA512 = 0x000D, TPM_ALG_NULL = 0x0010, TPM_ALG_SM3_256 = 0x0012, TPM_ALG_SM4 = 0x0013, TPM_ALG_RSASSA = 0x0014, TPM_ALG_RSAES = 0x0015, TPM_ALG_RSAPSS = 0x0016, TPM_ALG_OAEP = 0x0017, TPM_ALG_ECDSA = 0x0018, TPM_ALG_ECDH = 0x0019, TPM_ALG_ECDAA = 0x001A, TPM_ALG_SM2 = 0x001B, TPM_ALG_ECSCHNORR = 0x001C, TPM_ALG_ECMQV = 0x001D, TPM_ALG_KDF1_SP800_56A = 0x0020, TPM_ALG_KDF2 = 0x0021, TPM_ALG_KDF1_SP800_108 = 0x0022, TPM_ALG_ECC = 0x0023, TPM_ALG_SYMCIPHER = 0x0025, TPM_ALG_CAMELLIA = 0x0026, TPM_ALG_CTR = 0x0040, TPM_ALG_OFB = 0x0041, TPM_ALG_CBC = 0x0042, TPM_ALG_CFB = 0x0043, TPM_ALG_ECB = 0x0044} |
| enum| **[TPM_ECC_CURVE_T](#enum-tpm-ecc-curve-t)** { TPM_ECC_NONE = 0x0000, TPM_ECC_NIST_P192 = 0x0001, TPM_ECC_NIST_P224 = 0x0002, TPM_ECC_NIST_P256 = 0x0003, TPM_ECC_NIST_P384 = 0x0004, TPM_ECC_NIST_P521 = 0x0005, TPM_ECC_BN_P256 = 0x0010, TPM_ECC_BN_P638 = 0x0011, TPM_ECC_SM2_P256 = 0x0020} |
| enum| **[TPM_CC_T](#enum-tpm-cc-t)** { TPM_CC_FIRST = 0x0000011F, TPM_CC_NV_UndefineSpaceSpecial = TPM_CC_FIRST, TPM_CC_EvictControl = 0x00000120, TPM_CC_HierarchyControl = 0x00000121, TPM_CC_NV_UndefineSpace = 0x00000122, TPM_CC_ChangeEPS = 0x00000124, TPM_CC_ChangePPS = 0x00000125, TPM_CC_Clear = 0x00000126, TPM_CC_ClearControl = 0x00000127, TPM_CC_ClockSet = 0x00000128, TPM_CC_HierarchyChangeAuth = 0x00000129, TPM_CC_NV_DefineSpace = 0x0000012A, TPM_CC_PCR_Allocate = 0x0000012B, TPM_CC_PCR_SetAuthPolicy = 0x0000012C, TPM_CC_PP_Commands = 0x0000012D, TPM_CC_SetPrimaryPolicy = 0x0000012E, TPM_CC_FieldUpgradeStart = 0x0000012F, TPM_CC_ClockRateAdjust = 0x00000130, TPM_CC_CreatePrimary = 0x00000131, TPM_CC_NV_GlobalWriteLock = 0x00000132, TPM_CC_GetCommandAuditDigest = 0x00000133, TPM_CC_NV_Increment = 0x00000134, TPM_CC_NV_SetBits = 0x00000135, TPM_CC_NV_Extend = 0x00000136, TPM_CC_NV_Write = 0x00000137, TPM_CC_NV_WriteLock = 0x00000138, TPM_CC_DictionaryAttackLockReset = 0x00000139, TPM_CC_DictionaryAttackParameters = 0x0000013A, TPM_CC_NV_ChangeAuth = 0x0000013B, TPM_CC_PCR_Event = 0x0000013C, TPM_CC_PCR_Reset = 0x0000013D, TPM_CC_SequenceComplete = 0x0000013E, TPM_CC_SetAlgorithmSet = 0x0000013F, TPM_CC_SetCommandCodeAuditStatus = 0x00000140, TPM_CC_FieldUpgradeData = 0x00000141, TPM_CC_IncrementalSelfTest = 0x00000142, TPM_CC_SelfTest = 0x00000143, TPM_CC_Startup = 0x00000144, TPM_CC_Shutdown = 0x00000145, TPM_CC_StirRandom = 0x00000146, TPM_CC_ActivateCredential = 0x00000147, TPM_CC_Certify = 0x00000148, TPM_CC_PolicyNV = 0x00000149, TPM_CC_CertifyCreation = 0x0000014A, TPM_CC_Duplicate = 0x0000014B, TPM_CC_GetTime = 0x0000014C, TPM_CC_GetSessionAuditDigest = 0x0000014D, TPM_CC_NV_Read = 0x0000014E, TPM_CC_NV_ReadLock = 0x0000014F, TPM_CC_ObjectChangeAuth = 0x00000150, TPM_CC_PolicySecret = 0x00000151, TPM_CC_Rewrap = 0x00000152, TPM_CC_Create = 0x00000153, TPM_CC_ECDH_ZGen = 0x00000154, TPM_CC_HMAC = 0x00000155, TPM_CC_Import = 0x00000156, TPM_CC_Load = 0x00000157, TPM_CC_Quote = 0x00000158, TPM_CC_RSA_Decrypt = 0x00000159, TPM_CC_HMAC_Start = 0x0000015B, TPM_CC_SequenceUpdate = 0x0000015C, TPM_CC_Sign = 0x0000015D, TPM_CC_Unseal = 0x0000015E, TPM_CC_PolicySigned = 0x00000160, TPM_CC_ContextLoad = 0x00000161, TPM_CC_ContextSave = 0x00000162, TPM_CC_ECDH_KeyGen = 0x00000163, TPM_CC_EncryptDecrypt = 0x00000164, TPM_CC_FlushContext = 0x00000165, TPM_CC_LoadExternal = 0x00000167, TPM_CC_MakeCredential = 0x00000168, TPM_CC_NV_ReadPublic = 0x00000169, TPM_CC_PolicyAuthorize = 0x0000016A, TPM_CC_PolicyAuthValue = 0x0000016B, TPM_CC_PolicyCommandCode = 0x0000016C, TPM_CC_PolicyCounterTimer = 0x0000016D, TPM_CC_PolicyCpHash = 0x0000016E, TPM_CC_PolicyLocality = 0x0000016F, TPM_CC_PolicyNameHash = 0x00000170, TPM_CC_PolicyOR = 0x00000171, TPM_CC_PolicyTicket = 0x00000172, TPM_CC_ReadPublic = 0x00000173, TPM_CC_RSA_Encrypt = 0x00000174, TPM_CC_StartAuthSession = 0x00000176, TPM_CC_VerifySignature = 0x00000177, TPM_CC_ECC_Parameters = 0x00000178, TPM_CC_FirmwareRead = 0x00000179, TPM_CC_GetCapability = 0x0000017A, TPM_CC_GetRandom = 0x0000017B, TPM_CC_GetTestResult = 0x0000017C, TPM_CC_Hash = 0x0000017D, TPM_CC_PCR_Read = 0x0000017E, TPM_CC_PolicyPCR = 0x0000017F, TPM_CC_PolicyRestart = 0x00000180, TPM_CC_ReadClock = 0x00000181, TPM_CC_PCR_Extend = 0x00000182, TPM_CC_PCR_SetAuthValue = 0x00000183, TPM_CC_NV_Certify = 0x00000184, TPM_CC_EventSequenceComplete = 0x00000185, TPM_CC_HashSequenceStart = 0x00000186, TPM_CC_PolicyPhysicalPresence = 0x00000187, TPM_CC_PolicyDuplicationSelect = 0x00000188, TPM_CC_PolicyGetDigest = 0x00000189, TPM_CC_TestParms = 0x0000018A, TPM_CC_Commit = 0x0000018B, TPM_CC_PolicyPassword = 0x0000018C, TPM_CC_ZGen_2Phase = 0x0000018D, TPM_CC_EC_Ephemeral = 0x0000018E, TPM_CC_PolicyNvWritten = 0x0000018F, TPM_CC_PolicyTemplate = 0x00000190, TPM_CC_CreateLoaded = 0x00000191, TPM_CC_PolicyAuthorizeNV = 0x00000192, TPM_CC_EncryptDecrypt2 = 0x00000193, TPM_CC_LAST = TPM_CC_EncryptDecrypt2, CC_VEND = 0x20000000, TPM_CC_Vendor_TCG_Test = CC_VEND + 0x0000, TPM_CC_SetMode = CC_VEND + 0x0307, TPM_CC_SetCommandSet = CC_VEND + 0x0309, TPM_CC_RestoreEK = CC_VEND + 0x030A, TPM_CC_SetCommandSetLock = CC_VEND + 0x030B, TPM_CC_GPIO_Config = CC_VEND + 0x030F, TPM_CC_NTC2_PreConfig = CC_VEND + 0x0211, TPM_CC_NTC2_GetConfig = CC_VEND + 0x0213} |
| enum| **[TPM_RC_T](#enum-tpm-rc-t)** { TPM_RC_SUCCESS = 0x000, TPM_RC_BAD_TAG = 0x01E, RC_VER1 = 0x100, TPM_RC_INITIALIZE = RC_VER1 + 0x000, TPM_RC_FAILURE = RC_VER1 + 0x001, TPM_RC_SEQUENCE = RC_VER1 + 0x003, TPM_RC_PRIVATE = RC_VER1 + 0x00B, TPM_RC_HMAC = RC_VER1 + 0x019, TPM_RC_DISABLED = RC_VER1 + 0x020, TPM_RC_EXCLUSIVE = RC_VER1 + 0x021, TPM_RC_AUTH_TYPE = RC_VER1 + 0x024, TPM_RC_AUTH_MISSING = RC_VER1 + 0x025, TPM_RC_POLICY = RC_VER1 + 0x026, TPM_RC_PCR = RC_VER1 + 0x027, TPM_RC_PCR_CHANGED = RC_VER1 + 0x028, TPM_RC_UPGRADE = RC_VER1 + 0x02D, TPM_RC_TOO_MANY_CONTEXTS = RC_VER1 + 0x02E, TPM_RC_AUTH_UNAVAILABLE = RC_VER1 + 0x02F, TPM_RC_REBOOT = RC_VER1 + 0x030, TPM_RC_UNBALANCED = RC_VER1 + 0x031, TPM_RC_COMMAND_SIZE = RC_VER1 + 0x042, TPM_RC_COMMAND_CODE = RC_VER1 + 0x043, TPM_RC_AUTHSIZE = RC_VER1 + 0x044, TPM_RC_AUTH_CONTEXT = RC_VER1 + 0x045, TPM_RC_NV_RANGE = RC_VER1 + 0x046, TPM_RC_NV_SIZE = RC_VER1 + 0x047, TPM_RC_NV_LOCKED = RC_VER1 + 0x048, TPM_RC_NV_AUTHORIZATION = RC_VER1 + 0x049, TPM_RC_NV_UNINITIALIZED = RC_VER1 + 0x04A, TPM_RC_NV_SPACE = RC_VER1 + 0x04B, TPM_RC_NV_DEFINED = RC_VER1 + 0x04C, TPM_RC_BAD_CONTEXT = RC_VER1 + 0x050, TPM_RC_CPHASH = RC_VER1 + 0x051, TPM_RC_PARENT = RC_VER1 + 0x052, TPM_RC_NEEDS_TEST = RC_VER1 + 0x053, TPM_RC_NO_RESULT = RC_VER1 + 0x054, TPM_RC_SENSITIVE = RC_VER1 + 0x055, RC_MAX_FM0 = RC_VER1 + 0x07F, RC_FMT1 = 0x080, TPM_RC_ASYMMETRIC = RC_FMT1 + 0x001, TPM_RC_ATTRIBUTES = RC_FMT1 + 0x002, TPM_RC_HASH = RC_FMT1 + 0x003, TPM_RC_VALUE = RC_FMT1 + 0x004, TPM_RC_HIERARCHY = RC_FMT1 + 0x005, TPM_RC_KEY_SIZE = RC_FMT1 + 0x007, TPM_RC_MGF = RC_FMT1 + 0x008, TPM_RC_MODE = RC_FMT1 + 0x009, TPM_RC_TYPE = RC_FMT1 + 0x00A, TPM_RC_HANDLE = RC_FMT1 + 0x00B, TPM_RC_KDF = RC_FMT1 + 0x00C, TPM_RC_RANGE = RC_FMT1 + 0x00D, TPM_RC_AUTH_FAIL = RC_FMT1 + 0x00E, TPM_RC_NONCE = RC_FMT1 + 0x00F, TPM_RC_PP = RC_FMT1 + 0x010, TPM_RC_SCHEME = RC_FMT1 + 0x012, TPM_RC_SIZE = RC_FMT1 + 0x015, TPM_RC_SYMMETRIC = RC_FMT1 + 0x016, TPM_RC_TAG = RC_FMT1 + 0x017, TPM_RC_SELECTOR = RC_FMT1 + 0x018, TPM_RC_INSUFFICIENT = RC_FMT1 + 0x01A, TPM_RC_SIGNATURE = RC_FMT1 + 0x01B, TPM_RC_KEY = RC_FMT1 + 0x01C, TPM_RC_POLICY_FAIL = RC_FMT1 + 0x01D, TPM_RC_INTEGRITY = RC_FMT1 + 0x01F, TPM_RC_TICKET = RC_FMT1 + 0x020, TPM_RC_RESERVED_BITS = RC_FMT1 + 0x021, TPM_RC_BAD_AUTH = RC_FMT1 + 0x022, TPM_RC_EXPIRED = RC_FMT1 + 0x023, TPM_RC_POLICY_CC = RC_FMT1 + 0x024, TPM_RC_BINDING = RC_FMT1 + 0x025, TPM_RC_CURVE = RC_FMT1 + 0x026, TPM_RC_ECC_POINT = RC_FMT1 + 0x027, RC_MAX_FMT1 = RC_FMT1 + 0x03F, RC_WARN = 0x900, TPM_RC_CONTEXT_GAP = RC_WARN + 0x001, TPM_RC_OBJECT_MEMORY = RC_WARN + 0x002, TPM_RC_SESSION_MEMORY = RC_WARN + 0x003, TPM_RC_MEMORY = RC_WARN + 0x004, TPM_RC_SESSION_HANDLES = RC_WARN + 0x005, TPM_RC_OBJECT_HANDLES = RC_WARN + 0x006, TPM_RC_LOCALITY = RC_WARN + 0x007, TPM_RC_YIELDED = RC_WARN + 0x008, TPM_RC_CANCELED = RC_WARN + 0x009, TPM_RC_TESTING = RC_WARN + 0x00A, TPM_RC_REFERENCE_H0 = RC_WARN + 0x010, TPM_RC_REFERENCE_H1 = RC_WARN + 0x011, TPM_RC_REFERENCE_H2 = RC_WARN + 0x012, TPM_RC_REFERENCE_H3 = RC_WARN + 0x013, TPM_RC_REFERENCE_H4 = RC_WARN + 0x014, TPM_RC_REFERENCE_H5 = RC_WARN + 0x015, TPM_RC_REFERENCE_H6 = RC_WARN + 0x016, TPM_RC_REFERENCE_S0 = RC_WARN + 0x018, TPM_RC_REFERENCE_S1 = RC_WARN + 0x019, TPM_RC_REFERENCE_S2 = RC_WARN + 0x01A, TPM_RC_REFERENCE_S3 = RC_WARN + 0x01B, TPM_RC_REFERENCE_S4 = RC_WARN + 0x01C, TPM_RC_REFERENCE_S5 = RC_WARN + 0x01D, TPM_RC_REFERENCE_S6 = RC_WARN + 0x01E, TPM_RC_NV_RATE = RC_WARN + 0x020, TPM_RC_LOCKOUT = RC_WARN + 0x021, TPM_RC_RETRY = RC_WARN + 0x022, TPM_RC_NV_UNAVAILABLE = RC_WARN + 0x023, RC_MAX_WARN = RC_WARN + 0x03F, TPM_RC_NOT_USED = RC_WARN + 0x07F, TPM_RC_H = 0x000, TPM_RC_P = 0x040, TPM_RC_S = 0x800, TPM_RC_1 = 0x100, TPM_RC_2 = 0x200, TPM_RC_3 = 0x300, TPM_RC_4 = 0x400, TPM_RC_5 = 0x500, TPM_RC_6 = 0x600, TPM_RC_7 = 0x700, TPM_RC_8 = 0x800, TPM_RC_9 = 0x900, TPM_RC_A = 0xA00, TPM_RC_B = 0xB00, TPM_RC_C = 0xC00, TPM_RC_D = 0xD00, TPM_RC_E = 0xE00, TPM_RC_F = 0xF00, TPM_RC_N_MASK = 0xF00, TPM_RC_TIMEOUT = -100} |
| enum| **[TPM_CLOCK_ADJUST_T](#enum-tpm-clock-adjust-t)** { TPM_CLOCK_COARSE_SLOWER = -3, TPM_CLOCK_MEDIUM_SLOWER = -2, TPM_CLOCK_FINE_SLOWER = -1, TPM_CLOCK_NO_CHANGE = 0, TPM_CLOCK_FINE_FASTER = 1, TPM_CLOCK_MEDIUM_FASTER = 2, TPM_CLOCK_COARSE_FASTER = 3} |
| enum| **[TPM_EO_T](#enum-tpm-eo-t)** { TPM_EO_EQ = 0x0000, TPM_EO_NEQ = 0x0001, TPM_EO_SIGNED_GT = 0x0002, TPM_EO_UNSIGNED_GT = 0x0003, TPM_EO_SIGNED_LT = 0x0004, TPM_EO_UNSIGNED_LT = 0x0005, TPM_EO_SIGNED_GE = 0x0006, TPM_EO_UNSIGNED_GE = 0x0007, TPM_EO_SIGNED_LE = 0x0008, TPM_EO_UNSIGNED_LE = 0x0009, TPM_EO_BITSET = 0x000A, TPM_EO_BITCLEAR = 0x000B} |
| enum| **[TPM_ST_T](#enum-tpm-st-t)** { TPM_ST_RSP_COMMAND = 0x00C4, TPM_ST_NULL = 0X8000, TPM_ST_NO_SESSIONS = 0x8001, TPM_ST_SESSIONS = 0x8002, TPM_ST_ATTEST_NV = 0x8014, TPM_ST_ATTEST_COMMAND_AUDIT = 0x8015, TPM_ST_ATTEST_SESSION_AUDIT = 0x8016, TPM_ST_ATTEST_CERTIFY = 0x8017, TPM_ST_ATTEST_QUOTE = 0x8018, TPM_ST_ATTEST_TIME = 0x8019, TPM_ST_ATTEST_CREATION = 0x801A, TPM_ST_CREATION = 0x8021, TPM_ST_VERIFIED = 0x8022, TPM_ST_AUTH_SECRET = 0x8023, TPM_ST_HASHCHECK = 0x8024, TPM_ST_AUTH_SIGNED = 0x8025, TPM_ST_FU_MANIFEST = 0x8029} |
| enum| **[TPM_SE_T](#enum-tpm-se-t)** { TPM_SE_HMAC = 0x00, TPM_SE_POLICY = 0x01, TPM_SE_TRIAL = 0x03} |
| enum| **[TPM_SU_T](#enum-tpm-su-t)** { TPM_SU_CLEAR = 0x0000, TPM_SU_STATE = 0x0001} |
| enum| **[TPM_CAP_T](#enum-tpm-cap-t)** { TPM_CAP_FIRST = 0x00000000, TPM_CAP_ALGS = TPM_CAP_FIRST, TPM_CAP_HANDLES = 0x00000001, TPM_CAP_COMMANDS = 0x00000002, TPM_CAP_PP_COMMANDS = 0x00000003, TPM_CAP_AUDIT_COMMANDS = 0x00000004, TPM_CAP_PCRS = 0x00000005, TPM_CAP_TPM_PROPERTIES = 0x00000006, TPM_CAP_PCR_PROPERTIES = 0x00000007, TPM_CAP_ECC_CURVES = 0x00000008, TPM_CAP_LAST = TPM_CAP_ECC_CURVES, TPM_CAP_VENDOR_PROPERTY = 0x00000100} |
| enum| **[TPM_PT_T](#enum-tpm-pt-t)** { TPM_PT_NONE = 0x00000000, PT_GROUP = 0x00000100, PT_FIXED = PT_GROUP * 1, TPM_PT_FAMILY_INDICATOR = PT_FIXED + 0, TPM_PT_LEVEL = PT_FIXED + 1, TPM_PT_REVISION = PT_FIXED + 2, TPM_PT_DAY_OF_YEAR = PT_FIXED + 3, TPM_PT_YEAR = PT_FIXED + 4, TPM_PT_MANUFACTURER = PT_FIXED + 5, TPM_PT_VENDOR_STRING_1 = PT_FIXED + 6, TPM_PT_VENDOR_STRING_2 = PT_FIXED + 7, TPM_PT_VENDOR_STRING_3 = PT_FIXED + 8, TPM_PT_VENDOR_STRING_4 = PT_FIXED + 9, TPM_PT_VENDOR_TPM_TYPE = PT_FIXED + 10, TPM_PT_FIRMWARE_VERSION_1 = PT_FIXED + 11, TPM_PT_FIRMWARE_VERSION_2 = PT_FIXED + 12, TPM_PT_INPUT_BUFFER = PT_FIXED + 13, TPM_PT_HR_TRANSIENT_MIN = PT_FIXED + 14, TPM_PT_HR_PERSISTENT_MIN = PT_FIXED + 15, TPM_PT_HR_LOADED_MIN = PT_FIXED + 16, TPM_PT_ACTIVE_SESSIONS_MAX = PT_FIXED + 17, TPM_PT_PCR_COUNT = PT_FIXED + 18, TPM_PT_PCR_SELECT_MIN = PT_FIXED + 19, TPM_PT_CONTEXT_GAP_MAX = PT_FIXED + 20, TPM_PT_NV_COUNTERS_MAX = PT_FIXED + 22, TPM_PT_NV_INDEX_MAX = PT_FIXED + 23, TPM_PT_MEMORY = PT_FIXED + 24, TPM_PT_CLOCK_UPDATE = PT_FIXED + 25, TPM_PT_CONTEXT_HASH = PT_FIXED + 26, TPM_PT_CONTEXT_SYM = PT_FIXED + 27, TPM_PT_CONTEXT_SYM_SIZE = PT_FIXED + 28, TPM_PT_ORDERLY_COUNT = PT_FIXED + 29, TPM_PT_MAX_COMMAND_SIZE = PT_FIXED + 30, TPM_PT_MAX_RESPONSE_SIZE = PT_FIXED + 31, TPM_PT_MAX_DIGEST = PT_FIXED + 32, TPM_PT_MAX_OBJECT_CONTEXT = PT_FIXED + 33, TPM_PT_MAX_SESSION_CONTEXT = PT_FIXED + 34, TPM_PT_PS_FAMILY_INDICATOR = PT_FIXED + 35, TPM_PT_PS_LEVEL = PT_FIXED + 36, TPM_PT_PS_REVISION = PT_FIXED + 37, TPM_PT_PS_DAY_OF_YEAR = PT_FIXED + 38, TPM_PT_PS_YEAR = PT_FIXED + 39, TPM_PT_SPLIT_MAX = PT_FIXED + 40, TPM_PT_TOTAL_COMMANDS = PT_FIXED + 41, TPM_PT_LIBRARY_COMMANDS = PT_FIXED + 42, TPM_PT_VENDOR_COMMANDS = PT_FIXED + 43, TPM_PT_NV_BUFFER_MAX = PT_FIXED + 44, TPM_PT_MODES = PT_FIXED + 45, TPM_PT_MAX_CAP_BUFFER = PT_FIXED + 46, PT_VAR = PT_GROUP * 2, TPM_PT_PERMANENT = PT_VAR + 0, TPM_PT_STARTUP_CLEAR = PT_VAR + 1, TPM_PT_HR_NV_INDEX = PT_VAR + 2, TPM_PT_HR_LOADED = PT_VAR + 3, TPM_PT_HR_LOADED_AVAIL = PT_VAR + 4, TPM_PT_HR_ACTIVE = PT_VAR + 5, TPM_PT_HR_ACTIVE_AVAIL = PT_VAR + 6, TPM_PT_HR_TRANSIENT_AVAIL = PT_VAR + 7, TPM_PT_HR_PERSISTENT = PT_VAR + 8, TPM_PT_HR_PERSISTENT_AVAIL = PT_VAR + 9, TPM_PT_NV_COUNTERS = PT_VAR + 10, TPM_PT_NV_COUNTERS_AVAIL = PT_VAR + 11, TPM_PT_ALGORITHM_SET = PT_VAR + 12, TPM_PT_LOADED_CURVES = PT_VAR + 13, TPM_PT_LOCKOUT_COUNTER = PT_VAR + 14, TPM_PT_MAX_AUTH_FAIL = PT_VAR + 15, TPM_PT_LOCKOUT_INTERVAL = PT_VAR + 16, TPM_PT_LOCKOUT_RECOVERY = PT_VAR + 17, TPM_PT_NV_WRITE_RECOVERY = PT_VAR + 18, TPM_PT_AUDIT_COUNTER_0 = PT_VAR + 19, TPM_PT_AUDIT_COUNTER_1 = PT_VAR + 20} |
| enum| **[TPM_PT_PCR_T](#enum-tpm-pt-pcr-t)** { TPM_PT_PCR_FIRST = 0x00000000, TPM_PT_PCR_SAVE = TPM_PT_PCR_FIRST, TPM_PT_PCR_EXTEND_L0 = 0x00000001, TPM_PT_PCR_RESET_L0 = 0x00000002, TPM_PT_PCR_EXTEND_L1 = 0x00000003, TPM_PT_PCR_RESET_L1 = 0x00000004, TPM_PT_PCR_EXTEND_L2 = 0x00000005, TPM_PT_PCR_RESET_L2 = 0x00000006, TPM_PT_PCR_EXTEND_L3 = 0x00000007, TPM_PT_PCR_RESET_L3 = 0x00000008, TPM_PT_PCR_EXTEND_L4 = 0x00000009, TPM_PT_PCR_RESET_L4 = 0x0000000A, TPM_PT_PCR_NO_INCREMENT = 0x00000011, TPM_PT_PCR_DRTM_RESET = 0x00000012, TPM_PT_PCR_POLICY = 0x00000013, TPM_PT_PCR_AUTH = 0x00000014, TPM_PT_PCR_LAST = TPM_PT_PCR_AUTH} |
| enum| **[TPM_PS_T](#enum-tpm-ps-t)** { TPM_PS_MAIN = 0x00000000, TPM_PS_PC = 0x00000001, TPM_PS_PDA = 0x00000002, TPM_PS_CELL_PHONE = 0x00000003, TPM_PS_SERVER = 0x00000004, TPM_PS_PERIPHERAL = 0x00000005, TPM_PS_TSS = 0x00000006, TPM_PS_STORAGE = 0x00000007, TPM_PS_AUTHENTICATION = 0x00000008, TPM_PS_EMBEDDED = 0x00000009, TPM_PS_HARDCOPY = 0x0000000A, TPM_PS_INFRASTRUCTURE = 0x0000000B, TPM_PS_VIRTUALIZATION = 0x0000000C, TPM_PS_TNC = 0x0000000D, TPM_PS_MULTI_TENANT = 0x0000000E, TPM_PS_TC = 0x0000000F} |
| enum| **[TPM_HT_T](#enum-tpm-ht-t)** { TPM_HT_PCR = 0x00, TPM_HT_NV_INDEX = 0x01, TPM_HT_HMAC_SESSION = 0x02, TPM_HT_LOADED_SESSION = 0x02, TPM_HT_POLICY_SESSION = 0x03, TPM_HT_ACTIVE_SESSION = 0x03, TPM_HT_PERMANENT = 0x40, TPM_HT_TRANSIENT = 0x80, TPM_HT_PERSISTENT = 0x81} |
| enum| **[TPM_RH_T](#enum-tpm-rh-t)** { TPM_RH_FIRST = 0x40000000, TPM_RH_SRK = TPM_RH_FIRST, TPM_RH_OWNER = 0x40000001, TPM_RH_REVOKE = 0x40000002, TPM_RH_TRANSPORT = 0x40000003, TPM_RH_OPERATOR = 0x40000004, TPM_RH_ADMIN = 0x40000005, TPM_RH_EK = 0x40000006, TPM_RH_NULL = 0x40000007, TPM_RH_UNASSIGNED = 0x40000008, TPM_RS_PW = 0x40000009, TPM_RH_LOCKOUT = 0x4000000A, TPM_RH_ENDORSEMENT = 0x4000000B, TPM_RH_PLATFORM = 0x4000000C, TPM_RH_PLATFORM_NV = 0x4000000D, TPM_RH_AUTH_00 = 0x40000010, TPM_RH_AUTH_FF = 0x4000010F, TPM_RH_LAST = TPM_RH_AUTH_FF} |
| enum| **[TPM_HC_T](#enum-tpm-hc-t)** { HR_HANDLE_MASK = 0x00FFFFFF, HR_RANGE_MASK = 0xFF000000, HR_SHIFT = 24, HR_PCR = ((UINT32)TPM_HT_PCR << HR_SHIFT), HR_HMAC_SESSION = ((UINT32)TPM_HT_HMAC_SESSION << HR_SHIFT), HR_POLICY_SESSION = ((UINT32)TPM_HT_POLICY_SESSION << HR_SHIFT), HR_TRANSIENT = ((UINT32)TPM_HT_TRANSIENT << HR_SHIFT), HR_PERSISTENT = ((UINT32)TPM_HT_PERSISTENT << HR_SHIFT), HR_NV_INDEX = ((UINT32)TPM_HT_NV_INDEX << HR_SHIFT), HR_PERMANENT = ((UINT32)TPM_HT_PERMANENT << HR_SHIFT), PCR_FIRST = (HR_PCR + 0), PCR_LAST = (PCR_FIRST + IMPLEMENTATION_PCR-1), HMAC_SESSION_FIRST = (HR_HMAC_SESSION + 0), HMAC_SESSION_LAST = (HMAC_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1), LOADED_SESSION_FIRST = HMAC_SESSION_FIRST, LOADED_SESSION_LAST = HMAC_SESSION_LAST, POLICY_SESSION_FIRST = (HR_POLICY_SESSION + 0), POLICY_SESSION_LAST = (POLICY_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1), TRANSIENT_FIRST = (HR_TRANSIENT + 0), ACTIVE_SESSION_FIRST = POLICY_SESSION_FIRST, ACTIVE_SESSION_LAST = POLICY_SESSION_LAST, TRANSIENT_LAST = (TRANSIENT_FIRST+MAX_LOADED_OBJECTS-1), PERSISTENT_FIRST = (HR_PERSISTENT + 0), PERSISTENT_LAST = (PERSISTENT_FIRST + 0x00FFFFFF), PLATFORM_PERSISTENT = (PERSISTENT_FIRST + 0x00800000), NV_INDEX_FIRST = (HR_NV_INDEX + 0), NV_INDEX_LAST = (NV_INDEX_FIRST + 0x00FFFFFF), PERMANENT_FIRST = TPM_RH_FIRST, PERMANENT_LAST = TPM_RH_LAST} |
| enum| **[TPMA_ALGORITHM_mask](#enum-tpma-algorithm-mask)** { TPMA_ALGORITHM_asymmetric = 0x00000001, TPMA_ALGORITHM_symmetric = 0x00000002, TPMA_ALGORITHM_hash = 0x00000004, TPMA_ALGORITHM_object = 0x00000008, TPMA_ALGORITHM_signing = 0x00000010, TPMA_ALGORITHM_encrypting = 0x00000020, TPMA_ALGORITHM_method = 0x00000040} |
| enum| **[TPMA_OBJECT_mask](#enum-tpma-object-mask)** { TPMA_OBJECT_fixedTPM = 0x00000002, TPMA_OBJECT_stClear = 0x00000004, TPMA_OBJECT_fixedParent = 0x00000010, TPMA_OBJECT_sensitiveDataOrigin = 0x00000020, TPMA_OBJECT_userWithAuth = 0x00000040, TPMA_OBJECT_adminWithPolicy = 0x00000080, TPMA_OBJECT_derivedDataOrigin = 0x00000200, TPMA_OBJECT_noDA = 0x00000400, TPMA_OBJECT_encryptedDuplication = 0x00000800, TPMA_OBJECT_restricted = 0x00010000, TPMA_OBJECT_decrypt = 0x00020000, TPMA_OBJECT_sign = 0x00040000} |
| enum| **[TPMA_SESSION_mask](#enum-tpma-session-mask)** { TPMA_SESSION_continueSession = 0x01, TPMA_SESSION_auditExclusive = 0x02, TPMA_SESSION_auditReset = 0x04, TPMA_SESSION_decrypt = 0x20, TPMA_SESSION_encrypt = 0x40, TPMA_SESSION_audit = 0x80} |
| enum| **[TPMA_LOCALITY_mask](#enum-tpma-locality-mask)** { TPM_LOC_ZERO = 0x01, TPM_LOC_ONE = 0x02, TPM_LOC_TWO = 0x04, TPM_LOC_THREE = 0x08, TPM_LOC_FOUR = 0x10} |
| enum| **[TPMA_PERMANENT_mask](#enum-tpma-permanent-mask)** { TPMA_PERMANENT_ownerAuthSet = 0x00000001, TPMA_PERMANENT_endorsementAuthSet = 0x00000002, TPMA_PERMANENT_lockoutAuthSet = 0x00000004, TPMA_PERMANENT_disableClear = 0x00000100, TPMA_PERMANENT_inLockout = 0x00000200, TPMA_PERMANENT_tpmGeneratedEPS = 0x00000400} |
| enum| **[TPMA_STARTUP_CLEAR_mask](#enum-tpma-startup-clear-mask)** { TPMA_STARTUP_CLEAR_phEnable = 0x00000001, TPMA_STARTUP_CLEAR_shEnable = 0x00000002, TPMA_STARTUP_CLEAR_ehEnable = 0x00000004, TPMA_STARTUP_CLEAR_phEnableNV = 0x00000008, TPMA_STARTUP_CLEAR_orderly = 0x80000000} |
| enum| **[TPMA_MEMORY_mask](#enum-tpma-memory-mask)** { TPMA_MEMORY_sharedRAM = 0x00000001, TPMA_MEMORY_sharedNV = 0x00000002, TPMA_MEMORY_objectCopiedToRam = 0x00000004} |
| enum| **[TPMA_CC_mask](#enum-tpma-cc-mask)** { TPMA_CC_commandIndex = 0x0000FFFF, TPMA_CC_nv = 0x00400000, TPMA_CC_extensive = 0x00800000, TPMA_CC_flushed = 0x01000000, TPMA_CC_cHandles = 0x0E000000, TPMA_CC_rHandle = 0x10000000, TPMA_CC_V = 0x20000000} |
| enum| **[TPM_NV_INDEX_mask](#enum-tpm-nv-index-mask)** { TPM_NV_INDEX_index = 0x00FFFFFF, TPM_NV_INDEX_RH_NV = 0xFF000000} |
| enum| **[TPM_NT](#enum-tpm-nt)** { TPM_NT_ORDINARY = 0x0, TPM_NT_COUNTER = 0x1, TPM_NT_BITS = 0x2, TPM_NT_EXTEND = 0x4, TPM_NT_PIN_FAIL = 0x8, TPM_NT_PIN_PASS = 0x9} |
| enum| **[TPMA_NV_mask](#enum-tpma-nv-mask)** { TPMA_NV_PPWRITE = 0x00000001, TPMA_NV_OWNERWRITE = 0x00000002, TPMA_NV_AUTHWRITE = 0x00000004, TPMA_NV_POLICYWRITE = 0x00000008, TPMA_NV_TPM_NT = 0x000000F0, TPMA_NV_POLICY_DELETE = 0x00000400, TPMA_NV_WRITELOCKED = 0x00000800, TPMA_NV_WRITEALL = 0x00001000, TPMA_NV_WRITEDEFINE = 0x00002000, TPMA_NV_WRITE_STCLEAR = 0x00004000, TPMA_NV_GLOBALLOCK = 0x00008000, TPMA_NV_PPREAD = 0x00010000, TPMA_NV_OWNERREAD = 0x00020000, TPMA_NV_AUTHREAD = 0x00040000, TPMA_NV_POLICYREAD = 0x00080000, TPMA_NV_NO_DA = 0x02000000, TPMA_NV_ORDERLY = 0x04000000, TPMA_NV_CLEAR_STCLEAR = 0x08000000, TPMA_NV_READLOCKED = 0x10000000, TPMA_NV_WRITTEN = 0x20000000, TPMA_NV_PLATFORMCREATE = 0x40000000, TPMA_NV_READ_STCLEAR = 0x80000000} |
| enum| **[@1](#enum-@1)** { TPMLib_2 = 0x01, TPMFips = 0x02, TPMLowPowerOff = 0x00, TPMLowPowerByRegister = 0x04, TPMLowPowerByGpio = 0x08, TPMLowPowerAuto = 0x0C} |
| enum| **[TPMI_GPIO_NAME_T](#enum-tpmi-gpio-name-t)** { TPM_GPIO_PP = 0x00000000, TPM_GPIO_LP = 0x00000001, TPM_GPIO_C = 0x00000002, TPM_GPIO_D = 0x00000003} |
| enum| **[TPMI_GPIO_MODE_T](#enum-tpmi-gpio-mode-t)** { TPM_GPIO_MODE_STANDARD = 0x00000000, TPM_GPIO_MODE_FLOATING = 0x00000001, TPM_GPIO_MODE_PULLUP = 0x00000002, TPM_GPIO_MODE_PULLDOWN = 0x00000003, TPM_GPIO_MODE_OPENDRAIN = 0x00000004, TPM_GPIO_MODE_PUSHPULL = 0x00000005, TPM_GPIO_MODE_UNCONFIG = 0x00000006, TPM_GPIO_MODE_DEFAULT = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_MAX = TPM_GPIO_MODE_UNCONFIG, TPM_GPIO_MODE_INPUT_MIN = TPM_GPIO_MODE_FLOATING, TPM_GPIO_MODE_INPUT_MAX = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_PUSHPULL = 0x00000005, TPM_GPIO_MODE_OPENDRAIN = 0x00000004, TPM_GPIO_MODE_PULLUP = 0x00000002, TPM_GPIO_MODE_UNCONFIG = 0x00000006, TPM_GPIO_MODE_DEFAULT = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_MAX = TPM_GPIO_MODE_UNCONFIG, TPM_GPIO_MODE_INPUT_MIN = TPM_GPIO_MODE_FLOATING, TPM_GPIO_MODE_INPUT_MAX = TPM_GPIO_MODE_PULLDOWN} |
| enum| **[TPMI_GPIO_MODE_T](#enum-tpmi-gpio-mode-t)** { TPM_GPIO_MODE_STANDARD = 0x00000000, TPM_GPIO_MODE_FLOATING = 0x00000001, TPM_GPIO_MODE_PULLUP = 0x00000002, TPM_GPIO_MODE_PULLDOWN = 0x00000003, TPM_GPIO_MODE_OPENDRAIN = 0x00000004, TPM_GPIO_MODE_PUSHPULL = 0x00000005, TPM_GPIO_MODE_UNCONFIG = 0x00000006, TPM_GPIO_MODE_DEFAULT = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_MAX = TPM_GPIO_MODE_UNCONFIG, TPM_GPIO_MODE_INPUT_MIN = TPM_GPIO_MODE_FLOATING, TPM_GPIO_MODE_INPUT_MAX = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_PUSHPULL = 0x00000005, TPM_GPIO_MODE_OPENDRAIN = 0x00000004, TPM_GPIO_MODE_PULLUP = 0x00000002, TPM_GPIO_MODE_UNCONFIG = 0x00000006, TPM_GPIO_MODE_DEFAULT = TPM_GPIO_MODE_PULLDOWN, TPM_GPIO_MODE_MAX = TPM_GPIO_MODE_UNCONFIG, TPM_GPIO_MODE_INPUT_MIN = TPM_GPIO_MODE_FLOATING, TPM_GPIO_MODE_INPUT_MAX = TPM_GPIO_MODE_PULLDOWN} |
| enum| **[TPM_Vendor_t](#enum-tpm-vendor-t)** { TPM_VENDOR_UNKNOWN = 0, TPM_VENDOR_INFINEON = 0x15d1, TPM_VENDOR_STM = 0x104a, TPM_VENDOR_MCHP = 0x1114, TPM_VENDOR_NUVOTON = 0x1050, TPM_VENDOR_NATIONTECH = 0x1B4E} |
| typedef UINT32 | **[TPM_MODIFIER_INDICATOR](#typedef-tpm-modifier-indicator)**  |
| typedef UINT32 | **[TPM_AUTHORIZATION_SIZE](#typedef-tpm-authorization-size)**  |
| typedef UINT32 | **[TPM_PARAMETER_SIZE](#typedef-tpm-parameter-size)**  |
| typedef UINT16 | **[TPM_KEY_SIZE](#typedef-tpm-key-size)**  |
| typedef UINT16 | **[TPM_KEY_BITS](#typedef-tpm-key-bits)**  |
| typedef UINT32 | **[TPM_GENERATED](#typedef-tpm-generated)**  |
| typedef UINT16 | **[TPM_ALG_ID](#typedef-tpm-alg-id)**  |
| typedef UINT16 | **[TPM_ECC_CURVE](#typedef-tpm-ecc-curve)**  |
| typedef UINT32 | **[TPM_CC](#typedef-tpm-cc)**  |
| typedef INT32 | **[TPM_RC](#typedef-tpm-rc)**  |
| typedef UINT8 | **[TPM_CLOCK_ADJUST](#typedef-tpm-clock-adjust)**  |
| typedef UINT16 | **[TPM_EO](#typedef-tpm-eo)**  |
| typedef UINT16 | **[TPM_ST](#typedef-tpm-st)**  |
| typedef UINT8 | **[TPM_SE](#typedef-tpm-se)**  |
| typedef UINT16 | **[TPM_SU](#typedef-tpm-su)**  |
| typedef UINT32 | **[TPM_CAP](#typedef-tpm-cap)**  |
| typedef UINT32 | **[TPM_PT](#typedef-tpm-pt)**  |
| typedef UINT32 | **[TPM_PT_PCR](#typedef-tpm-pt-pcr)**  |
| typedef UINT32 | **[TPM_PS](#typedef-tpm-ps)**  |
| typedef UINT32 | **[TPM_HANDLE](#typedef-tpm-handle)**  |
| typedef UINT8 | **[TPM_HT](#typedef-tpm-ht)**  |
| typedef UINT32 | **[TPM_RH](#typedef-tpm-rh)**  |
| typedef UINT32 | **[TPM_HC](#typedef-tpm-hc)**  |
| typedef UINT32 | **[TPMA_ALGORITHM](#typedef-tpma-algorithm)**  |
| typedef UINT32 | **[TPMA_OBJECT](#typedef-tpma-object)**  |
| typedef BYTE | **[TPMA_SESSION](#typedef-tpma-session)**  |
| typedef BYTE | **[TPMA_LOCALITY](#typedef-tpma-locality)**  |
| typedef UINT32 | **[TPMA_PERMANENT](#typedef-tpma-permanent)**  |
| typedef UINT32 | **[TPMA_STARTUP_CLEAR](#typedef-tpma-startup-clear)**  |
| typedef UINT32 | **[TPMA_MEMORY](#typedef-tpma-memory)**  |
| typedef UINT32 | **[TPMA_CC](#typedef-tpma-cc)**  |
| typedef BYTE | **[TPMI_YES_NO](#typedef-tpmi-yes-no)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-object)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-parent)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-persistent)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-entity)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-pcr)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-sh-auth-session)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-sh-hmac)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-sh-policy)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-dh-context)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-hierarchy)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-enables)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-hierarchy-auth)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-platform)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-owner)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-endorsement)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-provision)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-clear)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-nv-auth)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-lockout)**  |
| typedef [TPM_HANDLE](#typedef-tpmi-rh-nv-index)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-hash)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-asym)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-sym)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-sym-object)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-sym-mode)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-kdf)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-sig-scheme)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-ecc-key-exchange)**  |
| typedef [TPM_ST](#typedef-tpmi-st-command-tag)**  |
| typedef struct [TPMS_ALGORITHM_DESCRIPTION](#typedef-tpms-algorithm-description)**  |
| typedef union [TPMU_HA](Classes#typedef-tpmu-ha)**  |
| typedef struct [TPMT_HA](#typedef-tpmt-ha)**  |
| typedef struct [TPM2B_DIGEST](#typedef-tpm2b-digest)**  |
| typedef struct [TPM2B_DATA](#typedef-tpm2b-data)**  |
| typedef [TPM2B_DIGEST](#typedef-tpm2b-nonce)**  |
| typedef [TPM2B_DIGEST](#typedef-tpm2b-auth)**  |
| typedef [TPM2B_DIGEST](#typedef-tpm2b-operand)**  |
| typedef struct [TPM2B_EVENT](#typedef-tpm2b-event)**  |
| typedef struct [TPM2B_MAX_BUFFER](#typedef-tpm2b-max-buffer)**  |
| typedef struct [TPM2B_MAX_NV_BUFFER](#typedef-tpm2b-max-nv-buffer)**  |
| typedef [TPM2B_DIGEST](#typedef-tpm2b-timeout)**  |
| typedef struct [TPM2B_IV](#typedef-tpm2b-iv)**  |
| typedef union [TPMU_NAME](Classes#typedef-tpmu-name)**  |
| typedef struct [TPM2B_NAME](#typedef-tpm2b-name)**  |
| typedef struct [TPMS_PCR_SELECT](#typedef-tpms-pcr-select)**  |
| typedef struct [TPMS_PCR_SELECTION](#typedef-tpms-pcr-selection)**  |
| typedef struct [TPMT_TK_CREATION](#typedef-tpmt-tk-creation)**  |
| typedef struct [TPMT_TK_VERIFIED](#typedef-tpmt-tk-verified)**  |
| typedef struct [TPMT_TK_AUTH](#typedef-tpmt-tk-auth)**  |
| typedef struct [TPMT_TK_HASHCHECK](#typedef-tpmt-tk-hashcheck)**  |
| typedef struct [TPMS_ALG_PROPERTY](#typedef-tpms-alg-property)**  |
| typedef struct [TPMS_TAGGED_PROPERTY](#typedef-tpms-tagged-property)**  |
| typedef struct [TPMS_TAGGED_PCR_SELECT](#typedef-tpms-tagged-pcr-select)**  |
| typedef struct [TPMS_TAGGED_POLICY](#typedef-tpms-tagged-policy)**  |
| typedef struct [TPML_CC](#typedef-tpml-cc)**  |
| typedef struct [TPML_CCA](#typedef-tpml-cca)**  |
| typedef struct [TPML_ALG](#typedef-tpml-alg)**  |
| typedef struct [TPML_HANDLE](#typedef-tpml-handle)**  |
| typedef struct [TPML_DIGEST](#typedef-tpml-digest)**  |
| typedef struct [TPML_DIGEST_VALUES](#typedef-tpml-digest-values)**  |
| typedef struct [TPML_PCR_SELECTION](#typedef-tpml-pcr-selection)**  |
| typedef struct [TPML_ALG_PROPERTY](#typedef-tpml-alg-property)**  |
| typedef struct [TPML_TAGGED_TPM_PROPERTY](#typedef-tpml-tagged-tpm-property)**  |
| typedef struct [TPML_TAGGED_PCR_PROPERTY](#typedef-tpml-tagged-pcr-property)**  |
| typedef struct [TPML_ECC_CURVE](#typedef-tpml-ecc-curve)**  |
| typedef struct [TPML_TAGGED_POLICY](#typedef-tpml-tagged-policy)**  |
| typedef union [TPMU_CAPABILITIES](Classes#typedef-tpmu-capabilities)**  |
| typedef struct [TPMS_CAPABILITY_DATA](#typedef-tpms-capability-data)**  |
| typedef struct [TPMS_CLOCK_INFO](#typedef-tpms-clock-info)**  |
| typedef struct [TPMS_TIME_INFO](#typedef-tpms-time-info)**  |
| typedef struct [TPMS_TIME_ATTEST_INFO](#typedef-tpms-time-attest-info)**  |
| typedef struct [TPMS_CERTIFY_INFO](#typedef-tpms-certify-info)**  |
| typedef struct [TPMS_QUOTE_INFO](#typedef-tpms-quote-info)**  |
| typedef struct [TPMS_COMMAND_AUDIT_INFO](#typedef-tpms-command-audit-info)**  |
| typedef struct [TPMS_SESSION_AUDIT_INFO](#typedef-tpms-session-audit-info)**  |
| typedef struct [TPMS_CREATION_INFO](#typedef-tpms-creation-info)**  |
| typedef struct [TPMS_NV_CERTIFY_INFO](#typedef-tpms-nv-certify-info)**  |
| typedef [TPM_ST](#typedef-tpmi-st-attest)**  |
| typedef union [TPMU_ATTEST](Classes#typedef-tpmu-attest)**  |
| typedef struct [TPMS_ATTEST](#typedef-tpms-attest)**  |
| typedef struct [TPM2B_ATTEST](#typedef-tpm2b-attest)**  |
| typedef [TPM_KEY_BITS](#typedef-tpmi-aes-key-bits)**  |
| typedef union [TPMU_SYM_KEY_BITS](Classes#typedef-tpmu-sym-key-bits)**  |
| typedef union [TPMU_SYM_MODE](Classes#typedef-tpmu-sym-mode)**  |
| typedef struct [TPMT_SYM_DEF](#typedef-tpmt-sym-def)**  |
| typedef [TPMT_SYM_DEF](#typedef-tpmt-sym-def-object)**  |
| typedef struct [TPM2B_SYM_KEY](#typedef-tpm2b-sym-key)**  |
| typedef struct [TPMS_SYMCIPHER_PARMS](#typedef-tpms-symcipher-parms)**  |
| typedef struct [TPM2B_LABEL](#typedef-tpm2b-label)**  |
| typedef struct [TPMS_DERIVE](#typedef-tpms-derive)**  |
| typedef struct [TPM2B_DERIVE](#typedef-tpm2b-derive)**  |
| typedef union [TPMU_SENSITIVE_CREATE](Classes#typedef-tpmu-sensitive-create)**  |
| typedef struct [TPM2B_SENSITIVE_DATA](#typedef-tpm2b-sensitive-data)**  |
| typedef struct [TPMS_SENSITIVE_CREATE](#typedef-tpms-sensitive-create)**  |
| typedef struct [TPM2B_SENSITIVE_CREATE](#typedef-tpm2b-sensitive-create)**  |
| typedef struct [TPMS_SCHEME_HASH](#typedef-tpms-scheme-hash)**  |
| typedef struct [TPMS_SCHEME_ECDAA](#typedef-tpms-scheme-ecdaa)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-keyedhash-scheme)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-scheme-hmac)**  |
| typedef union [TPMU_SCHEME_KEYEDHASH](Classes#typedef-tpmu-scheme-keyedhash)**  |
| typedef struct [TPMT_KEYEDHASH_SCHEME](#typedef-tpmt-keyedhash-scheme)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-sig-scheme-rsassa)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-sig-scheme-rsapss)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-sig-scheme-ecdsa)**  |
| typedef [TPMS_SCHEME_ECDAA](#typedef-tpms-sig-scheme-ecdaa)**  |
| typedef union [TPMU_SIG_SCHEME](Classes#typedef-tpmu-sig-scheme)**  |
| typedef struct [TPMT_SIG_SCHEME](#typedef-tpmt-sig-scheme)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-enc-scheme-oaep)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-key-scheme-ecdh)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-key-scheme-ecmqv)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-scheme-mgf1)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-scheme-kdf1-sp800-56a)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-scheme-kdf2)**  |
| typedef [TPMS_SCHEME_HASH](#typedef-tpms-scheme-kdf1-sp800-108)**  |
| typedef union [TPMU_KDF_SCHEME](Classes#typedef-tpmu-kdf-scheme)**  |
| typedef struct [TPMT_KDF_SCHEME](#typedef-tpmt-kdf-scheme)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-asym-scheme)**  |
| typedef union [TPMU_ASYM_SCHEME](Classes#typedef-tpmu-asym-scheme)**  |
| typedef struct [TPMT_ASYM_SCHEME](#typedef-tpmt-asym-scheme)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-rsa-scheme)**  |
| typedef struct [TPMT_RSA_SCHEME](#typedef-tpmt-rsa-scheme)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-rsa-decrypt)**  |
| typedef struct [TPMT_RSA_DECRYPT](#typedef-tpmt-rsa-decrypt)**  |
| typedef struct [TPM2B_PUBLIC_KEY_RSA](#typedef-tpm2b-public-key-rsa)**  |
| typedef [TPM_KEY_BITS](#typedef-tpmi-rsa-key-bits)**  |
| typedef struct [TPM2B_PRIVATE_KEY_RSA](#typedef-tpm2b-private-key-rsa)**  |
| typedef struct [TPM2B_ECC_PARAMETER](#typedef-tpm2b-ecc-parameter)**  |
| typedef struct [TPMS_ECC_POINT](#typedef-tpms-ecc-point)**  |
| typedef struct [TPM2B_ECC_POINT](#typedef-tpm2b-ecc-point)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-ecc-scheme)**  |
| typedef [TPM_ECC_CURVE](#typedef-tpmi-ecc-curve)**  |
| typedef [TPMT_SIG_SCHEME](#typedef-tpmt-ecc-scheme)**  |
| typedef struct [TPMS_ALGORITHM_DETAIL_ECC](#typedef-tpms-algorithm-detail-ecc)**  |
| typedef struct [TPMS_SIGNATURE_RSA](#typedef-tpms-signature-rsa)**  |
| typedef [TPMS_SIGNATURE_RSA](#typedef-tpms-signature-rsassa)**  |
| typedef [TPMS_SIGNATURE_RSA](#typedef-tpms-signature-rsapss)**  |
| typedef struct [TPMS_SIGNATURE_ECC](#typedef-tpms-signature-ecc)**  |
| typedef [TPMS_SIGNATURE_ECC](#typedef-tpms-signature-ecdsa)**  |
| typedef [TPMS_SIGNATURE_ECC](#typedef-tpms-signature-ecdaa)**  |
| typedef union [TPMU_SIGNATURE](Classes#typedef-tpmu-signature)**  |
| typedef struct [TPMT_SIGNATURE](#typedef-tpmt-signature)**  |
| typedef union [TPMU_ENCRYPTED_SECRET](Classes#typedef-tpmu-encrypted-secret)**  |
| typedef struct [TPM2B_ENCRYPTED_SECRET](#typedef-tpm2b-encrypted-secret)**  |
| typedef [TPM_ALG_ID](#typedef-tpmi-alg-public)**  |
| typedef union [TPMU_PUBLIC_ID](Classes#typedef-tpmu-public-id)**  |
| typedef struct [TPMS_KEYEDHASH_PARMS](#typedef-tpms-keyedhash-parms)**  |
| typedef struct [TPMS_ASYM_PARMS](#typedef-tpms-asym-parms)**  |
| typedef struct [TPMS_RSA_PARMS](#typedef-tpms-rsa-parms)**  |
| typedef struct [TPMS_ECC_PARMS](#typedef-tpms-ecc-parms)**  |
| typedef union [TPMU_PUBLIC_PARMS](Classes#typedef-tpmu-public-parms)**  |
| typedef struct [TPMT_PUBLIC_PARMS](#typedef-tpmt-public-parms)**  |
| typedef struct [TPMT_PUBLIC](#typedef-tpmt-public)**  |
| typedef struct [TPM2B_PUBLIC](#typedef-tpm2b-public)**  |
| typedef struct [TPM2B_TEMPLATE](#typedef-tpm2b-template)**  |
| typedef struct [TPM2B_PRIVATE_VENDOR_SPECIFIC](#typedef-tpm2b-private-vendor-specific)**  |
| typedef union [TPMU_SENSITIVE_COMPOSITE](Classes#typedef-tpmu-sensitive-composite)**  |
| typedef struct [TPMT_SENSITIVE](#typedef-tpmt-sensitive)**  |
| typedef struct [TPM2B_SENSITIVE](#typedef-tpm2b-sensitive)**  |
| typedef struct [TPMT_PRIVATE](#typedef-tpmt-private)**  |
| typedef struct [TPM2B_PRIVATE](#typedef-tpm2b-private)**  |
| typedef struct [TPMS_ID_OBJECT](#typedef-tpms-id-object)**  |
| typedef struct [TPM2B_ID_OBJECT](#typedef-tpm2b-id-object)**  |
| typedef UINT32 | **[TPM_NV_INDEX](#typedef-tpm-nv-index)**  |
| typedef enum [TPM_NT](#typedef-tpm-nt)**  |
| typedef struct [TPMS_NV_PIN_COUNTER_PARAMETERS](#typedef-tpms-nv-pin-counter-parameters)**  |
| typedef UINT32 | **[TPMA_NV](#typedef-tpma-nv)**  |
| typedef struct [TPMS_NV_PUBLIC](#typedef-tpms-nv-public)**  |
| typedef struct [TPM2B_NV_PUBLIC](#typedef-tpm2b-nv-public)**  |
| typedef struct [TPM2B_CONTEXT_SENSITIVE](#typedef-tpm2b-context-sensitive)**  |
| typedef struct [TPMS_CONTEXT_DATA](#typedef-tpms-context-data)**  |
| typedef struct [TPM2B_CONTEXT_DATA](#typedef-tpm2b-context-data)**  |
| typedef struct [TPMS_CONTEXT](#typedef-tpms-context)**  |
| typedef struct [TPMS_CREATION_DATA](#typedef-tpms-creation-data)**  |
| typedef struct [TPM2B_CREATION_DATA](#typedef-tpm2b-creation-data)**  |
| typedef struct [TPMS_AUTH_COMMAND](#typedef-tpms-auth-command)**  |
| typedef struct [TPMS_AUTH_RESPONSE](#typedef-tpms-auth-response)**  |
| typedef struct [TPM2_AUTH_SESSION](#typedef-tpm2-auth-session)**  |
| typedef int(*)(struct TPM2_CTX *, INT32 isRead, UINT32 addr, BYTE *xferBuf, UINT16 xferSz, void *userCtx) | **[TPM2HalIoCb](#typedef-tpm2haliocb)**  |
| typedef struct [TPM2_CTX](#typedef-tpm2-ctx)**  |
| typedef [ChangeSeed_In](#typedef-changepps-in)**  |
| typedef [ChangeSeed_In](#typedef-changeeps-in)**  |
| typedef struct [TPM_MODE_SET](#typedef-tpm-mode-set)**  |
| typedef UINT32 | **[TPMI_GPIO_NAME](#typedef-tpmi-gpio-name)**  |
| typedef UINT32 | **[TPMI_GPIO_MODE](#typedef-tpmi-gpio-mode)**  |
| typedef struct [TPMS_GPIO_CONFIG](#typedef-tpms-gpio-config)**  |
| typedef struct [TPML_GPIO_CONFIG](#typedef-tpml-gpio-config)**  |

### Functions

|                | Name           |
| -------------- | -------------- |
| WOLFTPM_API [TPM_RC](#function-tpm2-startup)**([Startup_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-shutdown)**([Shutdown_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-getcapability)**([GetCapability_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-selftest)**([SelfTest_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-incrementalselftest)**([IncrementalSelfTest_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-gettestresult)**([GetTestResult_Out]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-getrandom)**([GetRandom_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-stirrandom)**([StirRandom_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-read)**([PCR_Read_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-extend)**([PCR_Extend_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-create)**([Create_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-createloaded)**([CreateLoaded_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-createprimary)**([CreatePrimary_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-load)**([Load_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-flushcontext)**([FlushContext_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-unseal)**([Unseal_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-startauthsession)**([StartAuthSession_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyrestart)**([PolicyRestart_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-loadexternal)**([LoadExternal_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-readpublic)**([ReadPublic_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-activatecredential)**([ActivateCredential_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-makecredential)**([MakeCredential_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-objectchangeauth)**([ObjectChangeAuth_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-duplicate)**([Duplicate_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-rewrap)**([Rewrap_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-import)**([Import_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-rsa-encrypt)**([RSA_Encrypt_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-rsa-decrypt)**([RSA_Decrypt_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-ecdh-keygen)**([ECDH_KeyGen_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-ecdh-zgen)**([ECDH_ZGen_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-ecc-parameters)**([ECC_Parameters_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-zgen-2phase)**([ZGen_2Phase_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-encryptdecrypt)**([EncryptDecrypt_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-encryptdecrypt2)**([EncryptDecrypt2_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hash)**([Hash_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hmac)**([HMAC_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hmac-start)**([HMAC_Start_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hashsequencestart)**([HashSequenceStart_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-sequenceupdate)**([SequenceUpdate_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-sequencecomplete)**([SequenceComplete_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-eventsequencecomplete)**([EventSequenceComplete_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-certify)**([Certify_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-certifycreation)**([CertifyCreation_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-quote)**([Quote_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-getsessionauditdigest)**([GetSessionAuditDigest_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-getcommandauditdigest)**([GetCommandAuditDigest_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-gettime)**([GetTime_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-commit)**([Commit_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-ec-ephemeral)**([EC_Ephemeral_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-verifysignature)**([VerifySignature_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-sign)**([Sign_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-setcommandcodeauditstatus)**([SetCommandCodeAuditStatus_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-event)**([PCR_Event_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-allocate)**([PCR_Allocate_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-setauthpolicy)**([PCR_SetAuthPolicy_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-setauthvalue)**([PCR_SetAuthValue_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pcr-reset)**([PCR_Reset_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policysigned)**([PolicySigned_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policysecret)**([PolicySecret_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyticket)**([PolicyTicket_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyor)**([PolicyOR_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policypcr)**([PolicyPCR_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policylocality)**([PolicyLocality_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policynv)**([PolicyNV_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policycountertimer)**([PolicyCounterTimer_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policycommandcode)**([PolicyCommandCode_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyphysicalpresence)**([PolicyPhysicalPresence_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policycphash)**([PolicyCpHash_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policynamehash)**([PolicyNameHash_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyduplicationselect)**([PolicyDuplicationSelect_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyauthorize)**([PolicyAuthorize_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyauthvalue)**([PolicyAuthValue_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policypassword)**([PolicyPassword_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policygetdigest)**([PolicyGetDigest_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policynvwritten)**([PolicyNvWritten_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policytemplate)**([PolicyTemplate_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-policyauthorizenv)**([PolicyAuthorizeNV_In]() * in) |
| WOLFTPM_API void | **[_TPM_Hash_Start](#function--tpm-hash-start)**(void ) |
| WOLFTPM_API void | **[_TPM_Hash_Data](#function--tpm-hash-data)**(UINT32 dataSize, BYTE * data) |
| WOLFTPM_API void | **[_TPM_Hash_End](#function--tpm-hash-end)**(void ) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hierarchycontrol)**([HierarchyControl_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-setprimarypolicy)**([SetPrimaryPolicy_In]() * in) |
| WOLFTPM_API [TPM_RC](#typedef-changepps-in) * in) |
| WOLFTPM_API [TPM_RC](#typedef-changeeps-in) * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-clear)**([Clear_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-clearcontrol)**([ClearControl_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-hierarchychangeauth)**([HierarchyChangeAuth_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-dictionaryattacklockreset)**([DictionaryAttackLockReset_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-dictionaryattackparameters)**([DictionaryAttackParameters_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-pp-commands)**([PP_Commands_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-setalgorithmset)**([SetAlgorithmSet_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-fieldupgradestart)**([FieldUpgradeStart_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-fieldupgradedata)**([FieldUpgradeData_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-firmwareread)**([FirmwareRead_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-contextsave)**([ContextSave_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-contextload)**([ContextLoad_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-evictcontrol)**([EvictControl_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-readclock)**([ReadClock_Out]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-clockset)**([ClockSet_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-clockrateadjust)**([ClockRateAdjust_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-testparms)**([TestParms_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-definespace)**([NV_DefineSpace_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-undefinespace)**([NV_UndefineSpace_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-undefinespacespecial)**([NV_UndefineSpaceSpecial_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-readpublic)**([NV_ReadPublic_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-write)**([NV_Write_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-increment)**([NV_Increment_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-extend)**([NV_Extend_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-setbits)**([NV_SetBits_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-writelock)**([NV_WriteLock_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-globalwritelock)**([NV_GlobalWriteLock_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-read)**([NV_Read_In]() * out) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-readlock)**([NV_ReadLock_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-changeauth)**([NV_ChangeAuth_In]() * in) |
| WOLFTPM_API [TPM_RC](#function-tpm2-nv-certify)**([NV_Certify_In]() * out) |
| WOLFTPM_API int | **[TPM2_SetCommandSet](#function-tpm2-setcommandset)**([SetCommandSet_In]() * in) |
| WOLFTPM_API int | **[TPM2_SetMode](#function-tpm2-setmode)**([SetMode_In]() * in) |
| WOLFTPM_API int | **[TPM2_GPIO_Config](#function-tpm2-gpio-config)**([GpioConfig_In]() * in) |
| WOLFTPM_API int | **[TPM2_NTC2_PreConfig](#function-tpm2-ntc2-preconfig)**([NTC2_PreConfig_In]() * in) |
| WOLFTPM_API int | **[TPM2_NTC2_GetConfig](#function-tpm2-ntc2-getconfig)**([NTC2_GetConfig_Out]() * out) |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Initializes a TPM with HAL IO callback and user supplied context. When using wolfTPM with &ndash;enable-devtpm or &ndash;enable-swtpm configuration, the ioCb and userCtx are not used.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx, int timeoutTries)<br>Initializes a TPM with timeoutTries, HAL IO callback and user supplied context.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_Init_minimal]() * ctx)<br>Initializes a TPM and sets the wolfTPM2 context that will be used. This function is typically used for rich operating systems, like Windows.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_Cleanup]() * ctx)<br>Deinitializes a TPM and wolfcrypt (if it was initialized)  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_ChipStartup]() * ctx, int timeoutTries)<br>Makes sure the TPM2 startup has completed and extracts the TPM device information.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Sets the user's context and IO callbacks needed for TPM communication.  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) | **[TPM2_SetSessionAuth]() * session)<br>Sets the structure holding the TPM Authorizations.  |
| WOLFTPM_API int | **[TPM2_GetSessionAuthCount]() * ctx)<br>Determine the number of currently set TPM Authorizations.  |
| WOLFTPM_API void | **[TPM2_SetActiveCtx]() * ctx)<br>Sets a new TPM2 context for use.  |
| WOLFTPM_API [TPM2_CTX](#function-tpm2-getactivectx)**(void )<br>Provides a pointer to the TPM2 context in use.  |
| WOLFTPM_API int | **[TPM2_GetHashDigestSize](#typedef-tpmi-alg-hash) hashAlg)<br>Determine the size in bytes of a TPM 2.0 hash digest.  |
| WOLFTPM_API int | **[TPM2_GetHashType](#typedef-tpmi-alg-hash) hashAlg)<br>Translate a TPM2 hash type to its coresponding wolfcrypt hash type.  |
| WOLFTPM_API int | **[TPM2_GetNonce](#function-tpm2-getnonce)**(byte * nonceBuf, int nonceSz)<br>Generate a fresh nonce of random numbers.  |
| WOLFTPM_API void | **[TPM2_SetupPCRSel](#typedef-tpm-alg-id) alg, int pcrIndex)<br>Helper function to prepare a correct PCR selection For example, when preparing to create a TPM2_Quote.  |
| const WOLFTPM_API char * | **[TPM2_GetRCString](#function-tpm2-getrcstring)**(int rc)<br>Get a human readable string for any TPM 2.0 return code.  |
| const WOLFTPM_API char * | **[TPM2_GetAlgName](#typedef-tpm-alg-id) alg)<br>Get a human readable string for any TPM 2.0 algorithm.  |
| WOLFTPM_API int | **[TPM2_GetCurveSize](#typedef-tpm-ecc-curve) curveID)<br>Determine the size in bytes of any TPM ECC Curve.  |
| WOLFTPM_API int | **[TPM2_GetTpmCurve](#function-tpm2-gettpmcurve)**(int curveID)<br>Translate a wolfcrypt curve type to its coresponding TPM curve type.  |
| WOLFTPM_API int | **[TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)**(int curve_id)<br>Translate a TPM curve type to its coresponding wolfcrypt curve type.  |
| WOLFTPM_API int | **[TPM2_ParseAttest]() structure.  |
| WOLFTPM_API int | **[TPM2_HashNvPublic]() * nvPublic, byte * buffer, UINT16 * size)<br>Computes fresh NV Index name based on a nvPublic structure.  |
| WOLFTPM_API int | **[TPM2_AppendPublic]() structure based on a user provided buffer.  |
| WOLFTPM_API int | **[TPM2_ParsePublic]() structure and stores in a user provided buffer.  |
| WOLFTPM_LOCAL int | **[TPM2_GetName]() * name)<br>Provides the Name of a TPM object.  |
| WOLFTPM_API int | **[TPM2_GetWolfRng](#function-tpm2-getwolfrng)**(WC_RNG ** rng) |
| WOLFTPM_API UINT16 | **[TPM2_GetVendorID](#function-tpm2-getvendorid)**(void )<br>Provides the vendorID of the active TPM2 context.  |
| WOLFTPM_API void | **[TPM2_PrintBin](#function-tpm2-printbin)**(const byte * buffer, word32 length)<br>Helper function to print a binary buffer in a formated way.  |
| WOLFTPM_API void | **[TPM2_PrintAuth]() type in a human readable way.  |
| WOLFTPM_API void | **[TPM2_PrintPublicArea]() type in a human readable way.  |

### Attributes

|                | Name           |
| -------------- | -------------- |
| | **[C](#variable-c)**  |
| const BYTE[] | **[TPM_20_EK_AUTH_POLICY](#variable-tpm-20-ek-auth-policy)**  |

### Types Documentation

#### enum @0

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_SPEC_FAMILY | 0x322E3000|   |
| TPM_SPEC_LEVEL | 0|   |
| TPM_SPEC_VERSION | 138|   |
| TPM_SPEC_YEAR | 2016|   |
| TPM_SPEC_DAY_OF_YEAR | 273|   |
| TPM_GENERATED_VALUE | 0xff544347|   |




#### enum TPM_ALG_ID_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_ALG_ERROR | 0x0000|   |
| TPM_ALG_RSA | 0x0001|   |
| TPM_ALG_SHA | 0x0004|   |
| TPM_ALG_SHA1 | TPM_ALG_SHA|   |
| TPM_ALG_HMAC | 0x0005|   |
| TPM_ALG_AES | 0x0006|   |
| TPM_ALG_MGF1 | 0x0007|   |
| TPM_ALG_KEYEDHASH | 0x0008|   |
| TPM_ALG_XOR | 0x000A|   |
| TPM_ALG_SHA256 | 0x000B|   |
| TPM_ALG_SHA384 | 0x000C|   |
| TPM_ALG_SHA512 | 0x000D|   |
| TPM_ALG_NULL | 0x0010|   |
| TPM_ALG_SM3_256 | 0x0012|   |
| TPM_ALG_SM4 | 0x0013|   |
| TPM_ALG_RSASSA | 0x0014|   |
| TPM_ALG_RSAES | 0x0015|   |
| TPM_ALG_RSAPSS | 0x0016|   |
| TPM_ALG_OAEP | 0x0017|   |
| TPM_ALG_ECDSA | 0x0018|   |
| TPM_ALG_ECDH | 0x0019|   |
| TPM_ALG_ECDAA | 0x001A|   |
| TPM_ALG_SM2 | 0x001B|   |
| TPM_ALG_ECSCHNORR | 0x001C|   |
| TPM_ALG_ECMQV | 0x001D|   |
| TPM_ALG_KDF1_SP800_56A | 0x0020|   |
| TPM_ALG_KDF2 | 0x0021|   |
| TPM_ALG_KDF1_SP800_108 | 0x0022|   |
| TPM_ALG_ECC | 0x0023|   |
| TPM_ALG_SYMCIPHER | 0x0025|   |
| TPM_ALG_CAMELLIA | 0x0026|   |
| TPM_ALG_CTR | 0x0040|   |
| TPM_ALG_OFB | 0x0041|   |
| TPM_ALG_CBC | 0x0042|   |
| TPM_ALG_CFB | 0x0043|   |
| TPM_ALG_ECB | 0x0044|   |




#### enum TPM_ECC_CURVE_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_ECC_NONE | 0x0000|   |
| TPM_ECC_NIST_P192 | 0x0001|   |
| TPM_ECC_NIST_P224 | 0x0002|   |
| TPM_ECC_NIST_P256 | 0x0003|   |
| TPM_ECC_NIST_P384 | 0x0004|   |
| TPM_ECC_NIST_P521 | 0x0005|   |
| TPM_ECC_BN_P256 | 0x0010|   |
| TPM_ECC_BN_P638 | 0x0011|   |
| TPM_ECC_SM2_P256 | 0x0020|   |




#### enum TPM_CC_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_CC_FIRST | 0x0000011F|   |
| TPM_CC_NV_UndefineSpaceSpecial | TPM_CC_FIRST|   |
| TPM_CC_EvictControl | 0x00000120|   |
| TPM_CC_HierarchyControl | 0x00000121|   |
| TPM_CC_NV_UndefineSpace | 0x00000122|   |
| TPM_CC_ChangeEPS | 0x00000124|   |
| TPM_CC_ChangePPS | 0x00000125|   |
| TPM_CC_Clear | 0x00000126|   |
| TPM_CC_ClearControl | 0x00000127|   |
| TPM_CC_ClockSet | 0x00000128|   |
| TPM_CC_HierarchyChangeAuth | 0x00000129|   |
| TPM_CC_NV_DefineSpace | 0x0000012A|   |
| TPM_CC_PCR_Allocate | 0x0000012B|   |
| TPM_CC_PCR_SetAuthPolicy | 0x0000012C|   |
| TPM_CC_PP_Commands | 0x0000012D|   |
| TPM_CC_SetPrimaryPolicy | 0x0000012E|   |
| TPM_CC_FieldUpgradeStart | 0x0000012F|   |
| TPM_CC_ClockRateAdjust | 0x00000130|   |
| TPM_CC_CreatePrimary | 0x00000131|   |
| TPM_CC_NV_GlobalWriteLock | 0x00000132|   |
| TPM_CC_GetCommandAuditDigest | 0x00000133|   |
| TPM_CC_NV_Increment | 0x00000134|   |
| TPM_CC_NV_SetBits | 0x00000135|   |
| TPM_CC_NV_Extend | 0x00000136|   |
| TPM_CC_NV_Write | 0x00000137|   |
| TPM_CC_NV_WriteLock | 0x00000138|   |
| TPM_CC_DictionaryAttackLockReset | 0x00000139|   |
| TPM_CC_DictionaryAttackParameters | 0x0000013A|   |
| TPM_CC_NV_ChangeAuth | 0x0000013B|   |
| TPM_CC_PCR_Event | 0x0000013C|   |
| TPM_CC_PCR_Reset | 0x0000013D|   |
| TPM_CC_SequenceComplete | 0x0000013E|   |
| TPM_CC_SetAlgorithmSet | 0x0000013F|   |
| TPM_CC_SetCommandCodeAuditStatus | 0x00000140|   |
| TPM_CC_FieldUpgradeData | 0x00000141|   |
| TPM_CC_IncrementalSelfTest | 0x00000142|   |
| TPM_CC_SelfTest | 0x00000143|   |
| TPM_CC_Startup | 0x00000144|   |
| TPM_CC_Shutdown | 0x00000145|   |
| TPM_CC_StirRandom | 0x00000146|   |
| TPM_CC_ActivateCredential | 0x00000147|   |
| TPM_CC_Certify | 0x00000148|   |
| TPM_CC_PolicyNV | 0x00000149|   |
| TPM_CC_CertifyCreation | 0x0000014A|   |
| TPM_CC_Duplicate | 0x0000014B|   |
| TPM_CC_GetTime | 0x0000014C|   |
| TPM_CC_GetSessionAuditDigest | 0x0000014D|   |
| TPM_CC_NV_Read | 0x0000014E|   |
| TPM_CC_NV_ReadLock | 0x0000014F|   |
| TPM_CC_ObjectChangeAuth | 0x00000150|   |
| TPM_CC_PolicySecret | 0x00000151|   |
| TPM_CC_Rewrap | 0x00000152|   |
| TPM_CC_Create | 0x00000153|   |
| TPM_CC_ECDH_ZGen | 0x00000154|   |
| TPM_CC_HMAC | 0x00000155|   |
| TPM_CC_Import | 0x00000156|   |
| TPM_CC_Load | 0x00000157|   |
| TPM_CC_Quote | 0x00000158|   |
| TPM_CC_RSA_Decrypt | 0x00000159|   |
| TPM_CC_HMAC_Start | 0x0000015B|   |
| TPM_CC_SequenceUpdate | 0x0000015C|   |
| TPM_CC_Sign | 0x0000015D|   |
| TPM_CC_Unseal | 0x0000015E|   |
| TPM_CC_PolicySigned | 0x00000160|   |
| TPM_CC_ContextLoad | 0x00000161|   |
| TPM_CC_ContextSave | 0x00000162|   |
| TPM_CC_ECDH_KeyGen | 0x00000163|   |
| TPM_CC_EncryptDecrypt | 0x00000164|   |
| TPM_CC_FlushContext | 0x00000165|   |
| TPM_CC_LoadExternal | 0x00000167|   |
| TPM_CC_MakeCredential | 0x00000168|   |
| TPM_CC_NV_ReadPublic | 0x00000169|   |
| TPM_CC_PolicyAuthorize | 0x0000016A|   |
| TPM_CC_PolicyAuthValue | 0x0000016B|   |
| TPM_CC_PolicyCommandCode | 0x0000016C|   |
| TPM_CC_PolicyCounterTimer | 0x0000016D|   |
| TPM_CC_PolicyCpHash | 0x0000016E|   |
| TPM_CC_PolicyLocality | 0x0000016F|   |
| TPM_CC_PolicyNameHash | 0x00000170|   |
| TPM_CC_PolicyOR | 0x00000171|   |
| TPM_CC_PolicyTicket | 0x00000172|   |
| TPM_CC_ReadPublic | 0x00000173|   |
| TPM_CC_RSA_Encrypt | 0x00000174|   |
| TPM_CC_StartAuthSession | 0x00000176|   |
| TPM_CC_VerifySignature | 0x00000177|   |
| TPM_CC_ECC_Parameters | 0x00000178|   |
| TPM_CC_FirmwareRead | 0x00000179|   |
| TPM_CC_GetCapability | 0x0000017A|   |
| TPM_CC_GetRandom | 0x0000017B|   |
| TPM_CC_GetTestResult | 0x0000017C|   |
| TPM_CC_Hash | 0x0000017D|   |
| TPM_CC_PCR_Read | 0x0000017E|   |
| TPM_CC_PolicyPCR | 0x0000017F|   |
| TPM_CC_PolicyRestart | 0x00000180|   |
| TPM_CC_ReadClock | 0x00000181|   |
| TPM_CC_PCR_Extend | 0x00000182|   |
| TPM_CC_PCR_SetAuthValue | 0x00000183|   |
| TPM_CC_NV_Certify | 0x00000184|   |
| TPM_CC_EventSequenceComplete | 0x00000185|   |
| TPM_CC_HashSequenceStart | 0x00000186|   |
| TPM_CC_PolicyPhysicalPresence | 0x00000187|   |
| TPM_CC_PolicyDuplicationSelect | 0x00000188|   |
| TPM_CC_PolicyGetDigest | 0x00000189|   |
| TPM_CC_TestParms | 0x0000018A|   |
| TPM_CC_Commit | 0x0000018B|   |
| TPM_CC_PolicyPassword | 0x0000018C|   |
| TPM_CC_ZGen_2Phase | 0x0000018D|   |
| TPM_CC_EC_Ephemeral | 0x0000018E|   |
| TPM_CC_PolicyNvWritten | 0x0000018F|   |
| TPM_CC_PolicyTemplate | 0x00000190|   |
| TPM_CC_CreateLoaded | 0x00000191|   |
| TPM_CC_PolicyAuthorizeNV | 0x00000192|   |
| TPM_CC_EncryptDecrypt2 | 0x00000193|   |
| TPM_CC_LAST | TPM_CC_EncryptDecrypt2|   |
| CC_VEND | 0x20000000|   |
| TPM_CC_Vendor_TCG_Test | CC_VEND + 0x0000|   |
| TPM_CC_SetMode | CC_VEND + 0x0307|   |
| TPM_CC_SetCommandSet | CC_VEND + 0x0309|   |
| TPM_CC_RestoreEK | CC_VEND + 0x030A|   |
| TPM_CC_SetCommandSetLock | CC_VEND + 0x030B|   |
| TPM_CC_GPIO_Config | CC_VEND + 0x030F|   |
| TPM_CC_NTC2_PreConfig | CC_VEND + 0x0211|   |
| TPM_CC_NTC2_GetConfig | CC_VEND + 0x0213|   |




#### enum TPM_RC_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_RC_SUCCESS | 0x000|   |
| TPM_RC_BAD_TAG | 0x01E|   |
| RC_VER1 | 0x100|   |
| TPM_RC_INITIALIZE | RC_VER1 + 0x000|   |
| TPM_RC_FAILURE | RC_VER1 + 0x001|   |
| TPM_RC_SEQUENCE | RC_VER1 + 0x003|   |
| TPM_RC_PRIVATE | RC_VER1 + 0x00B|   |
| TPM_RC_HMAC | RC_VER1 + 0x019|   |
| TPM_RC_DISABLED | RC_VER1 + 0x020|   |
| TPM_RC_EXCLUSIVE | RC_VER1 + 0x021|   |
| TPM_RC_AUTH_TYPE | RC_VER1 + 0x024|   |
| TPM_RC_AUTH_MISSING | RC_VER1 + 0x025|   |
| TPM_RC_POLICY | RC_VER1 + 0x026|   |
| TPM_RC_PCR | RC_VER1 + 0x027|   |
| TPM_RC_PCR_CHANGED | RC_VER1 + 0x028|   |
| TPM_RC_UPGRADE | RC_VER1 + 0x02D|   |
| TPM_RC_TOO_MANY_CONTEXTS | RC_VER1 + 0x02E|   |
| TPM_RC_AUTH_UNAVAILABLE | RC_VER1 + 0x02F|   |
| TPM_RC_REBOOT | RC_VER1 + 0x030|   |
| TPM_RC_UNBALANCED | RC_VER1 + 0x031|   |
| TPM_RC_COMMAND_SIZE | RC_VER1 + 0x042|   |
| TPM_RC_COMMAND_CODE | RC_VER1 + 0x043|   |
| TPM_RC_AUTHSIZE | RC_VER1 + 0x044|   |
| TPM_RC_AUTH_CONTEXT | RC_VER1 + 0x045|   |
| TPM_RC_NV_RANGE | RC_VER1 + 0x046|   |
| TPM_RC_NV_SIZE | RC_VER1 + 0x047|   |
| TPM_RC_NV_LOCKED | RC_VER1 + 0x048|   |
| TPM_RC_NV_AUTHORIZATION | RC_VER1 + 0x049|   |
| TPM_RC_NV_UNINITIALIZED | RC_VER1 + 0x04A|   |
| TPM_RC_NV_SPACE | RC_VER1 + 0x04B|   |
| TPM_RC_NV_DEFINED | RC_VER1 + 0x04C|   |
| TPM_RC_BAD_CONTEXT | RC_VER1 + 0x050|   |
| TPM_RC_CPHASH | RC_VER1 + 0x051|   |
| TPM_RC_PARENT | RC_VER1 + 0x052|   |
| TPM_RC_NEEDS_TEST | RC_VER1 + 0x053|   |
| TPM_RC_NO_RESULT | RC_VER1 + 0x054|   |
| TPM_RC_SENSITIVE | RC_VER1 + 0x055|   |
| RC_MAX_FM0 | RC_VER1 + 0x07F|   |
| RC_FMT1 | 0x080|   |
| TPM_RC_ASYMMETRIC | RC_FMT1 + 0x001|   |
| TPM_RC_ATTRIBUTES | RC_FMT1 + 0x002|   |
| TPM_RC_HASH | RC_FMT1 + 0x003|   |
| TPM_RC_VALUE | RC_FMT1 + 0x004|   |
| TPM_RC_HIERARCHY | RC_FMT1 + 0x005|   |
| TPM_RC_KEY_SIZE | RC_FMT1 + 0x007|   |
| TPM_RC_MGF | RC_FMT1 + 0x008|   |
| TPM_RC_MODE | RC_FMT1 + 0x009|   |
| TPM_RC_TYPE | RC_FMT1 + 0x00A|   |
| TPM_RC_HANDLE | RC_FMT1 + 0x00B|   |
| TPM_RC_KDF | RC_FMT1 + 0x00C|   |
| TPM_RC_RANGE | RC_FMT1 + 0x00D|   |
| TPM_RC_AUTH_FAIL | RC_FMT1 + 0x00E|   |
| TPM_RC_NONCE | RC_FMT1 + 0x00F|   |
| TPM_RC_PP | RC_FMT1 + 0x010|   |
| TPM_RC_SCHEME | RC_FMT1 + 0x012|   |
| TPM_RC_SIZE | RC_FMT1 + 0x015|   |
| TPM_RC_SYMMETRIC | RC_FMT1 + 0x016|   |
| TPM_RC_TAG | RC_FMT1 + 0x017|   |
| TPM_RC_SELECTOR | RC_FMT1 + 0x018|   |
| TPM_RC_INSUFFICIENT | RC_FMT1 + 0x01A|   |
| TPM_RC_SIGNATURE | RC_FMT1 + 0x01B|   |
| TPM_RC_KEY | RC_FMT1 + 0x01C|   |
| TPM_RC_POLICY_FAIL | RC_FMT1 + 0x01D|   |
| TPM_RC_INTEGRITY | RC_FMT1 + 0x01F|   |
| TPM_RC_TICKET | RC_FMT1 + 0x020|   |
| TPM_RC_RESERVED_BITS | RC_FMT1 + 0x021|   |
| TPM_RC_BAD_AUTH | RC_FMT1 + 0x022|   |
| TPM_RC_EXPIRED | RC_FMT1 + 0x023|   |
| TPM_RC_POLICY_CC | RC_FMT1 + 0x024|   |
| TPM_RC_BINDING | RC_FMT1 + 0x025|   |
| TPM_RC_CURVE | RC_FMT1 + 0x026|   |
| TPM_RC_ECC_POINT | RC_FMT1 + 0x027|   |
| RC_MAX_FMT1 | RC_FMT1 + 0x03F|   |
| RC_WARN | 0x900|   |
| TPM_RC_CONTEXT_GAP | RC_WARN + 0x001|   |
| TPM_RC_OBJECT_MEMORY | RC_WARN + 0x002|   |
| TPM_RC_SESSION_MEMORY | RC_WARN + 0x003|   |
| TPM_RC_MEMORY | RC_WARN + 0x004|   |
| TPM_RC_SESSION_HANDLES | RC_WARN + 0x005|   |
| TPM_RC_OBJECT_HANDLES | RC_WARN + 0x006|   |
| TPM_RC_LOCALITY | RC_WARN + 0x007|   |
| TPM_RC_YIELDED | RC_WARN + 0x008|   |
| TPM_RC_CANCELED | RC_WARN + 0x009|   |
| TPM_RC_TESTING | RC_WARN + 0x00A|   |
| TPM_RC_REFERENCE_H0 | RC_WARN + 0x010|   |
| TPM_RC_REFERENCE_H1 | RC_WARN + 0x011|   |
| TPM_RC_REFERENCE_H2 | RC_WARN + 0x012|   |
| TPM_RC_REFERENCE_H3 | RC_WARN + 0x013|   |
| TPM_RC_REFERENCE_H4 | RC_WARN + 0x014|   |
| TPM_RC_REFERENCE_H5 | RC_WARN + 0x015|   |
| TPM_RC_REFERENCE_H6 | RC_WARN + 0x016|   |
| TPM_RC_REFERENCE_S0 | RC_WARN + 0x018|   |
| TPM_RC_REFERENCE_S1 | RC_WARN + 0x019|   |
| TPM_RC_REFERENCE_S2 | RC_WARN + 0x01A|   |
| TPM_RC_REFERENCE_S3 | RC_WARN + 0x01B|   |
| TPM_RC_REFERENCE_S4 | RC_WARN + 0x01C|   |
| TPM_RC_REFERENCE_S5 | RC_WARN + 0x01D|   |
| TPM_RC_REFERENCE_S6 | RC_WARN + 0x01E|   |
| TPM_RC_NV_RATE | RC_WARN + 0x020|   |
| TPM_RC_LOCKOUT | RC_WARN + 0x021|   |
| TPM_RC_RETRY | RC_WARN + 0x022|   |
| TPM_RC_NV_UNAVAILABLE | RC_WARN + 0x023|   |
| RC_MAX_WARN | RC_WARN + 0x03F|   |
| TPM_RC_NOT_USED | RC_WARN + 0x07F|   |
| TPM_RC_H | 0x000|   |
| TPM_RC_P | 0x040|   |
| TPM_RC_S | 0x800|   |
| TPM_RC_1 | 0x100|   |
| TPM_RC_2 | 0x200|   |
| TPM_RC_3 | 0x300|   |
| TPM_RC_4 | 0x400|   |
| TPM_RC_5 | 0x500|   |
| TPM_RC_6 | 0x600|   |
| TPM_RC_7 | 0x700|   |
| TPM_RC_8 | 0x800|   |
| TPM_RC_9 | 0x900|   |
| TPM_RC_A | 0xA00|   |
| TPM_RC_B | 0xB00|   |
| TPM_RC_C | 0xC00|   |
| TPM_RC_D | 0xD00|   |
| TPM_RC_E | 0xE00|   |
| TPM_RC_F | 0xF00|   |
| TPM_RC_N_MASK | 0xF00|   |
| TPM_RC_TIMEOUT | -100|   |




#### enum TPM_CLOCK_ADJUST_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_CLOCK_COARSE_SLOWER | -3|   |
| TPM_CLOCK_MEDIUM_SLOWER | -2|   |
| TPM_CLOCK_FINE_SLOWER | -1|   |
| TPM_CLOCK_NO_CHANGE | 0|   |
| TPM_CLOCK_FINE_FASTER | 1|   |
| TPM_CLOCK_MEDIUM_FASTER | 2|   |
| TPM_CLOCK_COARSE_FASTER | 3|   |




#### enum TPM_EO_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_EO_EQ | 0x0000|   |
| TPM_EO_NEQ | 0x0001|   |
| TPM_EO_SIGNED_GT | 0x0002|   |
| TPM_EO_UNSIGNED_GT | 0x0003|   |
| TPM_EO_SIGNED_LT | 0x0004|   |
| TPM_EO_UNSIGNED_LT | 0x0005|   |
| TPM_EO_SIGNED_GE | 0x0006|   |
| TPM_EO_UNSIGNED_GE | 0x0007|   |
| TPM_EO_SIGNED_LE | 0x0008|   |
| TPM_EO_UNSIGNED_LE | 0x0009|   |
| TPM_EO_BITSET | 0x000A|   |
| TPM_EO_BITCLEAR | 0x000B|   |




#### enum TPM_ST_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_ST_RSP_COMMAND | 0x00C4|   |
| TPM_ST_NULL | 0X8000|   |
| TPM_ST_NO_SESSIONS | 0x8001|   |
| TPM_ST_SESSIONS | 0x8002|   |
| TPM_ST_ATTEST_NV | 0x8014|   |
| TPM_ST_ATTEST_COMMAND_AUDIT | 0x8015|   |
| TPM_ST_ATTEST_SESSION_AUDIT | 0x8016|   |
| TPM_ST_ATTEST_CERTIFY | 0x8017|   |
| TPM_ST_ATTEST_QUOTE | 0x8018|   |
| TPM_ST_ATTEST_TIME | 0x8019|   |
| TPM_ST_ATTEST_CREATION | 0x801A|   |
| TPM_ST_CREATION | 0x8021|   |
| TPM_ST_VERIFIED | 0x8022|   |
| TPM_ST_AUTH_SECRET | 0x8023|   |
| TPM_ST_HASHCHECK | 0x8024|   |
| TPM_ST_AUTH_SIGNED | 0x8025|   |
| TPM_ST_FU_MANIFEST | 0x8029|   |




#### enum TPM_SE_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_SE_HMAC | 0x00|   |
| TPM_SE_POLICY | 0x01|   |
| TPM_SE_TRIAL | 0x03|   |




#### enum TPM_SU_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_SU_CLEAR | 0x0000|   |
| TPM_SU_STATE | 0x0001|   |




#### enum TPM_CAP_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_CAP_FIRST | 0x00000000|   |
| TPM_CAP_ALGS | TPM_CAP_FIRST|   |
| TPM_CAP_HANDLES | 0x00000001|   |
| TPM_CAP_COMMANDS | 0x00000002|   |
| TPM_CAP_PP_COMMANDS | 0x00000003|   |
| TPM_CAP_AUDIT_COMMANDS | 0x00000004|   |
| TPM_CAP_PCRS | 0x00000005|   |
| TPM_CAP_TPM_PROPERTIES | 0x00000006|   |
| TPM_CAP_PCR_PROPERTIES | 0x00000007|   |
| TPM_CAP_ECC_CURVES | 0x00000008|   |
| TPM_CAP_LAST | TPM_CAP_ECC_CURVES|   |
| TPM_CAP_VENDOR_PROPERTY | 0x00000100|   |




#### enum TPM_PT_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_PT_NONE | 0x00000000|   |
| PT_GROUP | 0x00000100|   |
| PT_FIXED | PT_GROUP * 1|   |
| TPM_PT_FAMILY_INDICATOR | PT_FIXED + 0|   |
| TPM_PT_LEVEL | PT_FIXED + 1|   |
| TPM_PT_REVISION | PT_FIXED + 2|   |
| TPM_PT_DAY_OF_YEAR | PT_FIXED + 3|   |
| TPM_PT_YEAR | PT_FIXED + 4|   |
| TPM_PT_MANUFACTURER | PT_FIXED + 5|   |
| TPM_PT_VENDOR_STRING_1 | PT_FIXED + 6|   |
| TPM_PT_VENDOR_STRING_2 | PT_FIXED + 7|   |
| TPM_PT_VENDOR_STRING_3 | PT_FIXED + 8|   |
| TPM_PT_VENDOR_STRING_4 | PT_FIXED + 9|   |
| TPM_PT_VENDOR_TPM_TYPE | PT_FIXED + 10|   |
| TPM_PT_FIRMWARE_VERSION_1 | PT_FIXED + 11|   |
| TPM_PT_FIRMWARE_VERSION_2 | PT_FIXED + 12|   |
| TPM_PT_INPUT_BUFFER | PT_FIXED + 13|   |
| TPM_PT_HR_TRANSIENT_MIN | PT_FIXED + 14|   |
| TPM_PT_HR_PERSISTENT_MIN | PT_FIXED + 15|   |
| TPM_PT_HR_LOADED_MIN | PT_FIXED + 16|   |
| TPM_PT_ACTIVE_SESSIONS_MAX | PT_FIXED + 17|   |
| TPM_PT_PCR_COUNT | PT_FIXED + 18|   |
| TPM_PT_PCR_SELECT_MIN | PT_FIXED + 19|   |
| TPM_PT_CONTEXT_GAP_MAX | PT_FIXED + 20|   |
| TPM_PT_NV_COUNTERS_MAX | PT_FIXED + 22|   |
| TPM_PT_NV_INDEX_MAX | PT_FIXED + 23|   |
| TPM_PT_MEMORY | PT_FIXED + 24|   |
| TPM_PT_CLOCK_UPDATE | PT_FIXED + 25|   |
| TPM_PT_CONTEXT_HASH | PT_FIXED + 26|   |
| TPM_PT_CONTEXT_SYM | PT_FIXED + 27|   |
| TPM_PT_CONTEXT_SYM_SIZE | PT_FIXED + 28|   |
| TPM_PT_ORDERLY_COUNT | PT_FIXED + 29|   |
| TPM_PT_MAX_COMMAND_SIZE | PT_FIXED + 30|   |
| TPM_PT_MAX_RESPONSE_SIZE | PT_FIXED + 31|   |
| TPM_PT_MAX_DIGEST | PT_FIXED + 32|   |
| TPM_PT_MAX_OBJECT_CONTEXT | PT_FIXED + 33|   |
| TPM_PT_MAX_SESSION_CONTEXT | PT_FIXED + 34|   |
| TPM_PT_PS_FAMILY_INDICATOR | PT_FIXED + 35|   |
| TPM_PT_PS_LEVEL | PT_FIXED + 36|   |
| TPM_PT_PS_REVISION | PT_FIXED + 37|   |
| TPM_PT_PS_DAY_OF_YEAR | PT_FIXED + 38|   |
| TPM_PT_PS_YEAR | PT_FIXED + 39|   |
| TPM_PT_SPLIT_MAX | PT_FIXED + 40|   |
| TPM_PT_TOTAL_COMMANDS | PT_FIXED + 41|   |
| TPM_PT_LIBRARY_COMMANDS | PT_FIXED + 42|   |
| TPM_PT_VENDOR_COMMANDS | PT_FIXED + 43|   |
| TPM_PT_NV_BUFFER_MAX | PT_FIXED + 44|   |
| TPM_PT_MODES | PT_FIXED + 45|   |
| TPM_PT_MAX_CAP_BUFFER | PT_FIXED + 46|   |
| PT_VAR | PT_GROUP * 2|   |
| TPM_PT_PERMANENT | PT_VAR + 0|   |
| TPM_PT_STARTUP_CLEAR | PT_VAR + 1|   |
| TPM_PT_HR_NV_INDEX | PT_VAR + 2|   |
| TPM_PT_HR_LOADED | PT_VAR + 3|   |
| TPM_PT_HR_LOADED_AVAIL | PT_VAR + 4|   |
| TPM_PT_HR_ACTIVE | PT_VAR + 5|   |
| TPM_PT_HR_ACTIVE_AVAIL | PT_VAR + 6|   |
| TPM_PT_HR_TRANSIENT_AVAIL | PT_VAR + 7|   |
| TPM_PT_HR_PERSISTENT | PT_VAR + 8|   |
| TPM_PT_HR_PERSISTENT_AVAIL | PT_VAR + 9|   |
| TPM_PT_NV_COUNTERS | PT_VAR + 10|   |
| TPM_PT_NV_COUNTERS_AVAIL | PT_VAR + 11|   |
| TPM_PT_ALGORITHM_SET | PT_VAR + 12|   |
| TPM_PT_LOADED_CURVES | PT_VAR + 13|   |
| TPM_PT_LOCKOUT_COUNTER | PT_VAR + 14|   |
| TPM_PT_MAX_AUTH_FAIL | PT_VAR + 15|   |
| TPM_PT_LOCKOUT_INTERVAL | PT_VAR + 16|   |
| TPM_PT_LOCKOUT_RECOVERY | PT_VAR + 17|   |
| TPM_PT_NV_WRITE_RECOVERY | PT_VAR + 18|   |
| TPM_PT_AUDIT_COUNTER_0 | PT_VAR + 19|   |
| TPM_PT_AUDIT_COUNTER_1 | PT_VAR + 20|   |




#### enum TPM_PT_PCR_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_PT_PCR_FIRST | 0x00000000|   |
| TPM_PT_PCR_SAVE | TPM_PT_PCR_FIRST|   |
| TPM_PT_PCR_EXTEND_L0 | 0x00000001|   |
| TPM_PT_PCR_RESET_L0 | 0x00000002|   |
| TPM_PT_PCR_EXTEND_L1 | 0x00000003|   |
| TPM_PT_PCR_RESET_L1 | 0x00000004|   |
| TPM_PT_PCR_EXTEND_L2 | 0x00000005|   |
| TPM_PT_PCR_RESET_L2 | 0x00000006|   |
| TPM_PT_PCR_EXTEND_L3 | 0x00000007|   |
| TPM_PT_PCR_RESET_L3 | 0x00000008|   |
| TPM_PT_PCR_EXTEND_L4 | 0x00000009|   |
| TPM_PT_PCR_RESET_L4 | 0x0000000A|   |
| TPM_PT_PCR_NO_INCREMENT | 0x00000011|   |
| TPM_PT_PCR_DRTM_RESET | 0x00000012|   |
| TPM_PT_PCR_POLICY | 0x00000013|   |
| TPM_PT_PCR_AUTH | 0x00000014|   |
| TPM_PT_PCR_LAST | TPM_PT_PCR_AUTH|   |




#### enum TPM_PS_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_PS_MAIN | 0x00000000|   |
| TPM_PS_PC | 0x00000001|   |
| TPM_PS_PDA | 0x00000002|   |
| TPM_PS_CELL_PHONE | 0x00000003|   |
| TPM_PS_SERVER | 0x00000004|   |
| TPM_PS_PERIPHERAL | 0x00000005|   |
| TPM_PS_TSS | 0x00000006|   |
| TPM_PS_STORAGE | 0x00000007|   |
| TPM_PS_AUTHENTICATION | 0x00000008|   |
| TPM_PS_EMBEDDED | 0x00000009|   |
| TPM_PS_HARDCOPY | 0x0000000A|   |
| TPM_PS_INFRASTRUCTURE | 0x0000000B|   |
| TPM_PS_VIRTUALIZATION | 0x0000000C|   |
| TPM_PS_TNC | 0x0000000D|   |
| TPM_PS_MULTI_TENANT | 0x0000000E|   |
| TPM_PS_TC | 0x0000000F|   |




#### enum TPM_HT_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_HT_PCR | 0x00|   |
| TPM_HT_NV_INDEX | 0x01|   |
| TPM_HT_HMAC_SESSION | 0x02|   |
| TPM_HT_LOADED_SESSION | 0x02|   |
| TPM_HT_POLICY_SESSION | 0x03|   |
| TPM_HT_ACTIVE_SESSION | 0x03|   |
| TPM_HT_PERMANENT | 0x40|   |
| TPM_HT_TRANSIENT | 0x80|   |
| TPM_HT_PERSISTENT | 0x81|   |




#### enum TPM_RH_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_RH_FIRST | 0x40000000|   |
| TPM_RH_SRK | TPM_RH_FIRST|   |
| TPM_RH_OWNER | 0x40000001|   |
| TPM_RH_REVOKE | 0x40000002|   |
| TPM_RH_TRANSPORT | 0x40000003|   |
| TPM_RH_OPERATOR | 0x40000004|   |
| TPM_RH_ADMIN | 0x40000005|   |
| TPM_RH_EK | 0x40000006|   |
| TPM_RH_NULL | 0x40000007|   |
| TPM_RH_UNASSIGNED | 0x40000008|   |
| TPM_RS_PW | 0x40000009|   |
| TPM_RH_LOCKOUT | 0x4000000A|   |
| TPM_RH_ENDORSEMENT | 0x4000000B|   |
| TPM_RH_PLATFORM | 0x4000000C|   |
| TPM_RH_PLATFORM_NV | 0x4000000D|   |
| TPM_RH_AUTH_00 | 0x40000010|   |
| TPM_RH_AUTH_FF | 0x4000010F|   |
| TPM_RH_LAST | TPM_RH_AUTH_FF|   |




#### enum TPM_HC_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| HR_HANDLE_MASK | 0x00FFFFFF|   |
| HR_RANGE_MASK | 0xFF000000|   |
| HR_SHIFT | 24|   |
| HR_PCR | ((UINT32)TPM_HT_PCR << HR_SHIFT)|   |
| HR_HMAC_SESSION | ((UINT32)TPM_HT_HMAC_SESSION << HR_SHIFT)|   |
| HR_POLICY_SESSION | ((UINT32)TPM_HT_POLICY_SESSION << HR_SHIFT)|   |
| HR_TRANSIENT | ((UINT32)TPM_HT_TRANSIENT << HR_SHIFT)|   |
| HR_PERSISTENT | ((UINT32)TPM_HT_PERSISTENT << HR_SHIFT)|   |
| HR_NV_INDEX | ((UINT32)TPM_HT_NV_INDEX << HR_SHIFT)|   |
| HR_PERMANENT | ((UINT32)TPM_HT_PERMANENT << HR_SHIFT)|   |
| PCR_FIRST | (HR_PCR + 0)|   |
| PCR_LAST | (PCR_FIRST + IMPLEMENTATION_PCR-1)|   |
| HMAC_SESSION_FIRST | (HR_HMAC_SESSION + 0)|   |
| HMAC_SESSION_LAST | (HMAC_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1)|   |
| LOADED_SESSION_FIRST | HMAC_SESSION_FIRST|   |
| LOADED_SESSION_LAST | HMAC_SESSION_LAST|   |
| POLICY_SESSION_FIRST | (HR_POLICY_SESSION + 0)|   |
| POLICY_SESSION_LAST | (POLICY_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1)|   |
| TRANSIENT_FIRST | (HR_TRANSIENT + 0)|   |
| ACTIVE_SESSION_FIRST | POLICY_SESSION_FIRST|   |
| ACTIVE_SESSION_LAST | POLICY_SESSION_LAST|   |
| TRANSIENT_LAST | (TRANSIENT_FIRST+MAX_LOADED_OBJECTS-1)|   |
| PERSISTENT_FIRST | (HR_PERSISTENT + 0)|   |
| PERSISTENT_LAST | (PERSISTENT_FIRST + 0x00FFFFFF)|   |
| PLATFORM_PERSISTENT | (PERSISTENT_FIRST + 0x00800000)|   |
| NV_INDEX_FIRST | (HR_NV_INDEX + 0)|   |
| NV_INDEX_LAST | (NV_INDEX_FIRST + 0x00FFFFFF)|   |
| PERMANENT_FIRST | TPM_RH_FIRST|   |
| PERMANENT_LAST | TPM_RH_LAST|   |




#### enum TPMA_ALGORITHM_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_ALGORITHM_asymmetric | 0x00000001|   |
| TPMA_ALGORITHM_symmetric | 0x00000002|   |
| TPMA_ALGORITHM_hash | 0x00000004|   |
| TPMA_ALGORITHM_object | 0x00000008|   |
| TPMA_ALGORITHM_signing | 0x00000010|   |
| TPMA_ALGORITHM_encrypting | 0x00000020|   |
| TPMA_ALGORITHM_method | 0x00000040|   |




#### enum TPMA_OBJECT_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_OBJECT_fixedTPM | 0x00000002|   |
| TPMA_OBJECT_stClear | 0x00000004|   |
| TPMA_OBJECT_fixedParent | 0x00000010|   |
| TPMA_OBJECT_sensitiveDataOrigin | 0x00000020|   |
| TPMA_OBJECT_userWithAuth | 0x00000040|   |
| TPMA_OBJECT_adminWithPolicy | 0x00000080|   |
| TPMA_OBJECT_derivedDataOrigin | 0x00000200|   |
| TPMA_OBJECT_noDA | 0x00000400|   |
| TPMA_OBJECT_encryptedDuplication | 0x00000800|   |
| TPMA_OBJECT_restricted | 0x00010000|   |
| TPMA_OBJECT_decrypt | 0x00020000|   |
| TPMA_OBJECT_sign | 0x00040000|   |




#### enum TPMA_SESSION_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_SESSION_continueSession | 0x01|   |
| TPMA_SESSION_auditExclusive | 0x02|   |
| TPMA_SESSION_auditReset | 0x04|   |
| TPMA_SESSION_decrypt | 0x20|   |
| TPMA_SESSION_encrypt | 0x40|   |
| TPMA_SESSION_audit | 0x80|   |




#### enum TPMA_LOCALITY_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_LOC_ZERO | 0x01|   |
| TPM_LOC_ONE | 0x02|   |
| TPM_LOC_TWO | 0x04|   |
| TPM_LOC_THREE | 0x08|   |
| TPM_LOC_FOUR | 0x10|   |




#### enum TPMA_PERMANENT_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_PERMANENT_ownerAuthSet | 0x00000001|   |
| TPMA_PERMANENT_endorsementAuthSet | 0x00000002|   |
| TPMA_PERMANENT_lockoutAuthSet | 0x00000004|   |
| TPMA_PERMANENT_disableClear | 0x00000100|   |
| TPMA_PERMANENT_inLockout | 0x00000200|   |
| TPMA_PERMANENT_tpmGeneratedEPS | 0x00000400|   |




#### enum TPMA_STARTUP_CLEAR_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_STARTUP_CLEAR_phEnable | 0x00000001|   |
| TPMA_STARTUP_CLEAR_shEnable | 0x00000002|   |
| TPMA_STARTUP_CLEAR_ehEnable | 0x00000004|   |
| TPMA_STARTUP_CLEAR_phEnableNV | 0x00000008|   |
| TPMA_STARTUP_CLEAR_orderly | 0x80000000|   |




#### enum TPMA_MEMORY_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_MEMORY_sharedRAM | 0x00000001|   |
| TPMA_MEMORY_sharedNV | 0x00000002|   |
| TPMA_MEMORY_objectCopiedToRam | 0x00000004|   |




#### enum TPMA_CC_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_CC_commandIndex | 0x0000FFFF|   |
| TPMA_CC_nv | 0x00400000|   |
| TPMA_CC_extensive | 0x00800000|   |
| TPMA_CC_flushed | 0x01000000|   |
| TPMA_CC_cHandles | 0x0E000000|   |
| TPMA_CC_rHandle | 0x10000000|   |
| TPMA_CC_V | 0x20000000|   |




#### enum TPM_NV_INDEX_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_NV_INDEX_index | 0x00FFFFFF|   |
| TPM_NV_INDEX_RH_NV | 0xFF000000|   |




#### enum TPM_NT

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_NT_ORDINARY | 0x0|   |
| TPM_NT_COUNTER | 0x1|   |
| TPM_NT_BITS | 0x2|   |
| TPM_NT_EXTEND | 0x4|   |
| TPM_NT_PIN_FAIL | 0x8|   |
| TPM_NT_PIN_PASS | 0x9|   |




#### enum TPMA_NV_mask

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMA_NV_PPWRITE | 0x00000001|   |
| TPMA_NV_OWNERWRITE | 0x00000002|   |
| TPMA_NV_AUTHWRITE | 0x00000004|   |
| TPMA_NV_POLICYWRITE | 0x00000008|   |
| TPMA_NV_TPM_NT | 0x000000F0|   |
| TPMA_NV_POLICY_DELETE | 0x00000400|   |
| TPMA_NV_WRITELOCKED | 0x00000800|   |
| TPMA_NV_WRITEALL | 0x00001000|   |
| TPMA_NV_WRITEDEFINE | 0x00002000|   |
| TPMA_NV_WRITE_STCLEAR | 0x00004000|   |
| TPMA_NV_GLOBALLOCK | 0x00008000|   |
| TPMA_NV_PPREAD | 0x00010000|   |
| TPMA_NV_OWNERREAD | 0x00020000|   |
| TPMA_NV_AUTHREAD | 0x00040000|   |
| TPMA_NV_POLICYREAD | 0x00080000|   |
| TPMA_NV_NO_DA | 0x02000000|   |
| TPMA_NV_ORDERLY | 0x04000000|   |
| TPMA_NV_CLEAR_STCLEAR | 0x08000000|   |
| TPMA_NV_READLOCKED | 0x10000000|   |
| TPMA_NV_WRITTEN | 0x20000000|   |
| TPMA_NV_PLATFORMCREATE | 0x40000000|   |
| TPMA_NV_READ_STCLEAR | 0x80000000|   |




#### enum @1

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPMLib_2 | 0x01|   |
| TPMFips | 0x02|   |
| TPMLowPowerOff | 0x00|   |
| TPMLowPowerByRegister | 0x04|   |
| TPMLowPowerByGpio | 0x08|   |
| TPMLowPowerAuto | 0x0C|   |




#### enum TPMI_GPIO_NAME_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_GPIO_PP | 0x00000000|   |
| TPM_GPIO_LP | 0x00000001|   |
| TPM_GPIO_C | 0x00000002|   |
| TPM_GPIO_D | 0x00000003|   |




#### enum TPMI_GPIO_MODE_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_GPIO_MODE_STANDARD | 0x00000000|   |
| TPM_GPIO_MODE_FLOATING | 0x00000001|   |
| TPM_GPIO_MODE_PULLUP | 0x00000002|   |
| TPM_GPIO_MODE_PULLDOWN | 0x00000003|   |
| TPM_GPIO_MODE_OPENDRAIN | 0x00000004|   |
| TPM_GPIO_MODE_PUSHPULL | 0x00000005|   |
| TPM_GPIO_MODE_UNCONFIG | 0x00000006|   |
| TPM_GPIO_MODE_DEFAULT | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_MAX | TPM_GPIO_MODE_UNCONFIG|   |
| TPM_GPIO_MODE_INPUT_MIN | TPM_GPIO_MODE_FLOATING|   |
| TPM_GPIO_MODE_INPUT_MAX | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_PUSHPULL | 0x00000005|   |
| TPM_GPIO_MODE_OPENDRAIN | 0x00000004|   |
| TPM_GPIO_MODE_PULLUP | 0x00000002|   |
| TPM_GPIO_MODE_UNCONFIG | 0x00000006|   |
| TPM_GPIO_MODE_DEFAULT | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_MAX | TPM_GPIO_MODE_UNCONFIG|   |
| TPM_GPIO_MODE_INPUT_MIN | TPM_GPIO_MODE_FLOATING|   |
| TPM_GPIO_MODE_INPUT_MAX | TPM_GPIO_MODE_PULLDOWN|   |




#### enum TPMI_GPIO_MODE_T

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_GPIO_MODE_STANDARD | 0x00000000|   |
| TPM_GPIO_MODE_FLOATING | 0x00000001|   |
| TPM_GPIO_MODE_PULLUP | 0x00000002|   |
| TPM_GPIO_MODE_PULLDOWN | 0x00000003|   |
| TPM_GPIO_MODE_OPENDRAIN | 0x00000004|   |
| TPM_GPIO_MODE_PUSHPULL | 0x00000005|   |
| TPM_GPIO_MODE_UNCONFIG | 0x00000006|   |
| TPM_GPIO_MODE_DEFAULT | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_MAX | TPM_GPIO_MODE_UNCONFIG|   |
| TPM_GPIO_MODE_INPUT_MIN | TPM_GPIO_MODE_FLOATING|   |
| TPM_GPIO_MODE_INPUT_MAX | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_PUSHPULL | 0x00000005|   |
| TPM_GPIO_MODE_OPENDRAIN | 0x00000004|   |
| TPM_GPIO_MODE_PULLUP | 0x00000002|   |
| TPM_GPIO_MODE_UNCONFIG | 0x00000006|   |
| TPM_GPIO_MODE_DEFAULT | TPM_GPIO_MODE_PULLDOWN|   |
| TPM_GPIO_MODE_MAX | TPM_GPIO_MODE_UNCONFIG|   |
| TPM_GPIO_MODE_INPUT_MIN | TPM_GPIO_MODE_FLOATING|   |
| TPM_GPIO_MODE_INPUT_MAX | TPM_GPIO_MODE_PULLDOWN|   |




#### enum TPM_Vendor_t

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_VENDOR_UNKNOWN | 0|   |
| TPM_VENDOR_INFINEON | 0x15d1|   |
| TPM_VENDOR_STM | 0x104a|   |
| TPM_VENDOR_MCHP | 0x1114|   |
| TPM_VENDOR_NUVOTON | 0x1050|   |
| TPM_VENDOR_NATIONTECH | 0x1B4E|   |




#### typedef TPM_MODIFIER_INDICATOR

```cpp
typedef UINT32 TPM_MODIFIER_INDICATOR;
```


#### typedef TPM_AUTHORIZATION_SIZE

```cpp
typedef UINT32 TPM_AUTHORIZATION_SIZE;
```


#### typedef TPM_PARAMETER_SIZE

```cpp
typedef UINT32 TPM_PARAMETER_SIZE;
```


#### typedef TPM_KEY_SIZE

```cpp
typedef UINT16 TPM_KEY_SIZE;
```


#### typedef TPM_KEY_BITS

```cpp
typedef UINT16 TPM_KEY_BITS;
```


#### typedef TPM_GENERATED

```cpp
typedef UINT32 TPM_GENERATED;
```


#### typedef TPM_ALG_ID

```cpp
typedef UINT16 TPM_ALG_ID;
```


#### typedef TPM_ECC_CURVE

```cpp
typedef UINT16 TPM_ECC_CURVE;
```


#### typedef TPM_CC

```cpp
typedef UINT32 TPM_CC;
```


#### typedef TPM_RC

```cpp
typedef INT32 TPM_RC;
```


#### typedef TPM_CLOCK_ADJUST

```cpp
typedef UINT8 TPM_CLOCK_ADJUST;
```


#### typedef TPM_EO

```cpp
typedef UINT16 TPM_EO;
```


#### typedef TPM_ST

```cpp
typedef UINT16 TPM_ST;
```


#### typedef TPM_SE

```cpp
typedef UINT8 TPM_SE;
```


#### typedef TPM_SU

```cpp
typedef UINT16 TPM_SU;
```


#### typedef TPM_CAP

```cpp
typedef UINT32 TPM_CAP;
```


#### typedef TPM_PT

```cpp
typedef UINT32 TPM_PT;
```


#### typedef TPM_PT_PCR

```cpp
typedef UINT32 TPM_PT_PCR;
```


#### typedef TPM_PS

```cpp
typedef UINT32 TPM_PS;
```


#### typedef TPM_HANDLE

```cpp
typedef UINT32 TPM_HANDLE;
```


#### typedef TPM_HT

```cpp
typedef UINT8 TPM_HT;
```


#### typedef TPM_RH

```cpp
typedef UINT32 TPM_RH;
```


#### typedef TPM_HC

```cpp
typedef UINT32 TPM_HC;
```


#### typedef TPMA_ALGORITHM

```cpp
typedef UINT32 TPMA_ALGORITHM;
```


#### typedef TPMA_OBJECT

```cpp
typedef UINT32 TPMA_OBJECT;
```


#### typedef TPMA_SESSION

```cpp
typedef BYTE TPMA_SESSION;
```


#### typedef TPMA_LOCALITY

```cpp
typedef BYTE TPMA_LOCALITY;
```


#### typedef TPMA_PERMANENT

```cpp
typedef UINT32 TPMA_PERMANENT;
```


#### typedef TPMA_STARTUP_CLEAR

```cpp
typedef UINT32 TPMA_STARTUP_CLEAR;
```


#### typedef TPMA_MEMORY

```cpp
typedef UINT32 TPMA_MEMORY;
```


#### typedef TPMA_CC

```cpp
typedef UINT32 TPMA_CC;
```


#### typedef TPMI_YES_NO

```cpp
typedef BYTE TPMI_YES_NO;
```


#### typedef TPMI_DH_OBJECT

```cpp
typedef TPM_HANDLE TPMI_DH_OBJECT;
```


#### typedef TPMI_DH_PARENT

```cpp
typedef TPM_HANDLE TPMI_DH_PARENT;
```


#### typedef TPMI_DH_PERSISTENT

```cpp
typedef TPM_HANDLE TPMI_DH_PERSISTENT;
```


#### typedef TPMI_DH_ENTITY

```cpp
typedef TPM_HANDLE TPMI_DH_ENTITY;
```


#### typedef TPMI_DH_PCR

```cpp
typedef TPM_HANDLE TPMI_DH_PCR;
```


#### typedef TPMI_SH_AUTH_SESSION

```cpp
typedef TPM_HANDLE TPMI_SH_AUTH_SESSION;
```


#### typedef TPMI_SH_HMAC

```cpp
typedef TPM_HANDLE TPMI_SH_HMAC;
```


#### typedef TPMI_SH_POLICY

```cpp
typedef TPM_HANDLE TPMI_SH_POLICY;
```


#### typedef TPMI_DH_CONTEXT

```cpp
typedef TPM_HANDLE TPMI_DH_CONTEXT;
```


#### typedef TPMI_RH_HIERARCHY

```cpp
typedef TPM_HANDLE TPMI_RH_HIERARCHY;
```


#### typedef TPMI_RH_ENABLES

```cpp
typedef TPM_HANDLE TPMI_RH_ENABLES;
```


#### typedef TPMI_RH_HIERARCHY_AUTH

```cpp
typedef TPM_HANDLE TPMI_RH_HIERARCHY_AUTH;
```


#### typedef TPMI_RH_PLATFORM

```cpp
typedef TPM_HANDLE TPMI_RH_PLATFORM;
```


#### typedef TPMI_RH_OWNER

```cpp
typedef TPM_HANDLE TPMI_RH_OWNER;
```


#### typedef TPMI_RH_ENDORSEMENT

```cpp
typedef TPM_HANDLE TPMI_RH_ENDORSEMENT;
```


#### typedef TPMI_RH_PROVISION

```cpp
typedef TPM_HANDLE TPMI_RH_PROVISION;
```


#### typedef TPMI_RH_CLEAR

```cpp
typedef TPM_HANDLE TPMI_RH_CLEAR;
```


#### typedef TPMI_RH_NV_AUTH

```cpp
typedef TPM_HANDLE TPMI_RH_NV_AUTH;
```


#### typedef TPMI_RH_LOCKOUT

```cpp
typedef TPM_HANDLE TPMI_RH_LOCKOUT;
```


#### typedef TPMI_RH_NV_INDEX

```cpp
typedef TPM_HANDLE TPMI_RH_NV_INDEX;
```


#### typedef TPMI_ALG_HASH

```cpp
typedef TPM_ALG_ID TPMI_ALG_HASH;
```


#### typedef TPMI_ALG_ASYM

```cpp
typedef TPM_ALG_ID TPMI_ALG_ASYM;
```


#### typedef TPMI_ALG_SYM

```cpp
typedef TPM_ALG_ID TPMI_ALG_SYM;
```


#### typedef TPMI_ALG_SYM_OBJECT

```cpp
typedef TPM_ALG_ID TPMI_ALG_SYM_OBJECT;
```


#### typedef TPMI_ALG_SYM_MODE

```cpp
typedef TPM_ALG_ID TPMI_ALG_SYM_MODE;
```


#### typedef TPMI_ALG_KDF

```cpp
typedef TPM_ALG_ID TPMI_ALG_KDF;
```


#### typedef TPMI_ALG_SIG_SCHEME

```cpp
typedef TPM_ALG_ID TPMI_ALG_SIG_SCHEME;
```


#### typedef TPMI_ECC_KEY_EXCHANGE

```cpp
typedef TPM_ALG_ID TPMI_ECC_KEY_EXCHANGE;
```


#### typedef TPMI_ST_COMMAND_TAG

```cpp
typedef TPM_ST TPMI_ST_COMMAND_TAG;
```


#### typedef TPMS_ALGORITHM_DESCRIPTION

```cpp
typedef struct TPMS_ALGORITHM_DESCRIPTION TPMS_ALGORITHM_DESCRIPTION;
```


#### typedef TPMU_HA

```cpp
typedef union TPMU_HA TPMU_HA;
```


#### typedef TPMT_HA

```cpp
typedef struct TPMT_HA TPMT_HA;
```


#### typedef TPM2B_DIGEST

```cpp
typedef struct TPM2B_DIGEST TPM2B_DIGEST;
```


#### typedef TPM2B_DATA

```cpp
typedef struct TPM2B_DATA TPM2B_DATA;
```


#### typedef TPM2B_NONCE

```cpp
typedef TPM2B_DIGEST TPM2B_NONCE;
```


#### typedef TPM2B_AUTH

```cpp
typedef TPM2B_DIGEST TPM2B_AUTH;
```


#### typedef TPM2B_OPERAND

```cpp
typedef TPM2B_DIGEST TPM2B_OPERAND;
```


#### typedef TPM2B_EVENT

```cpp
typedef struct TPM2B_EVENT TPM2B_EVENT;
```


#### typedef TPM2B_MAX_BUFFER

```cpp
typedef struct TPM2B_MAX_BUFFER TPM2B_MAX_BUFFER;
```


#### typedef TPM2B_MAX_NV_BUFFER

```cpp
typedef struct TPM2B_MAX_NV_BUFFER TPM2B_MAX_NV_BUFFER;
```


#### typedef TPM2B_TIMEOUT

```cpp
typedef TPM2B_DIGEST TPM2B_TIMEOUT;
```


#### typedef TPM2B_IV

```cpp
typedef struct TPM2B_IV TPM2B_IV;
```


#### typedef TPMU_NAME

```cpp
typedef union TPMU_NAME TPMU_NAME;
```


#### typedef TPM2B_NAME

```cpp
typedef struct TPM2B_NAME TPM2B_NAME;
```


#### typedef TPMS_PCR_SELECT

```cpp
typedef struct TPMS_PCR_SELECT TPMS_PCR_SELECT;
```


#### typedef TPMS_PCR_SELECTION

```cpp
typedef struct TPMS_PCR_SELECTION TPMS_PCR_SELECTION;
```


#### typedef TPMT_TK_CREATION

```cpp
typedef struct TPMT_TK_CREATION TPMT_TK_CREATION;
```


#### typedef TPMT_TK_VERIFIED

```cpp
typedef struct TPMT_TK_VERIFIED TPMT_TK_VERIFIED;
```


#### typedef TPMT_TK_AUTH

```cpp
typedef struct TPMT_TK_AUTH TPMT_TK_AUTH;
```


#### typedef TPMT_TK_HASHCHECK

```cpp
typedef struct TPMT_TK_HASHCHECK TPMT_TK_HASHCHECK;
```


#### typedef TPMS_ALG_PROPERTY

```cpp
typedef struct TPMS_ALG_PROPERTY TPMS_ALG_PROPERTY;
```


#### typedef TPMS_TAGGED_PROPERTY

```cpp
typedef struct TPMS_TAGGED_PROPERTY TPMS_TAGGED_PROPERTY;
```


#### typedef TPMS_TAGGED_PCR_SELECT

```cpp
typedef struct TPMS_TAGGED_PCR_SELECT TPMS_TAGGED_PCR_SELECT;
```


#### typedef TPMS_TAGGED_POLICY

```cpp
typedef struct TPMS_TAGGED_POLICY TPMS_TAGGED_POLICY;
```


#### typedef TPML_CC

```cpp
typedef struct TPML_CC TPML_CC;
```


#### typedef TPML_CCA

```cpp
typedef struct TPML_CCA TPML_CCA;
```


#### typedef TPML_ALG

```cpp
typedef struct TPML_ALG TPML_ALG;
```


#### typedef TPML_HANDLE

```cpp
typedef struct TPML_HANDLE TPML_HANDLE;
```


#### typedef TPML_DIGEST

```cpp
typedef struct TPML_DIGEST TPML_DIGEST;
```


#### typedef TPML_DIGEST_VALUES

```cpp
typedef struct TPML_DIGEST_VALUES TPML_DIGEST_VALUES;
```


#### typedef TPML_PCR_SELECTION

```cpp
typedef struct TPML_PCR_SELECTION TPML_PCR_SELECTION;
```


#### typedef TPML_ALG_PROPERTY

```cpp
typedef struct TPML_ALG_PROPERTY TPML_ALG_PROPERTY;
```


#### typedef TPML_TAGGED_TPM_PROPERTY

```cpp
typedef struct TPML_TAGGED_TPM_PROPERTY TPML_TAGGED_TPM_PROPERTY;
```


#### typedef TPML_TAGGED_PCR_PROPERTY

```cpp
typedef struct TPML_TAGGED_PCR_PROPERTY TPML_TAGGED_PCR_PROPERTY;
```


#### typedef TPML_ECC_CURVE

```cpp
typedef struct TPML_ECC_CURVE TPML_ECC_CURVE;
```


#### typedef TPML_TAGGED_POLICY

```cpp
typedef struct TPML_TAGGED_POLICY TPML_TAGGED_POLICY;
```


#### typedef TPMU_CAPABILITIES

```cpp
typedef union TPMU_CAPABILITIES TPMU_CAPABILITIES;
```


#### typedef TPMS_CAPABILITY_DATA

```cpp
typedef struct TPMS_CAPABILITY_DATA TPMS_CAPABILITY_DATA;
```


#### typedef TPMS_CLOCK_INFO

```cpp
typedef struct TPMS_CLOCK_INFO TPMS_CLOCK_INFO;
```


#### typedef TPMS_TIME_INFO

```cpp
typedef struct TPMS_TIME_INFO TPMS_TIME_INFO;
```


#### typedef TPMS_TIME_ATTEST_INFO

```cpp
typedef struct TPMS_TIME_ATTEST_INFO TPMS_TIME_ATTEST_INFO;
```


#### typedef TPMS_CERTIFY_INFO

```cpp
typedef struct TPMS_CERTIFY_INFO TPMS_CERTIFY_INFO;
```


#### typedef TPMS_QUOTE_INFO

```cpp
typedef struct TPMS_QUOTE_INFO TPMS_QUOTE_INFO;
```


#### typedef TPMS_COMMAND_AUDIT_INFO

```cpp
typedef struct TPMS_COMMAND_AUDIT_INFO TPMS_COMMAND_AUDIT_INFO;
```


#### typedef TPMS_SESSION_AUDIT_INFO

```cpp
typedef struct TPMS_SESSION_AUDIT_INFO TPMS_SESSION_AUDIT_INFO;
```


#### typedef TPMS_CREATION_INFO

```cpp
typedef struct TPMS_CREATION_INFO TPMS_CREATION_INFO;
```


#### typedef TPMS_NV_CERTIFY_INFO

```cpp
typedef struct TPMS_NV_CERTIFY_INFO TPMS_NV_CERTIFY_INFO;
```


#### typedef TPMI_ST_ATTEST

```cpp
typedef TPM_ST TPMI_ST_ATTEST;
```


#### typedef TPMU_ATTEST

```cpp
typedef union TPMU_ATTEST TPMU_ATTEST;
```


#### typedef TPMS_ATTEST

```cpp
typedef struct TPMS_ATTEST TPMS_ATTEST;
```


#### typedef TPM2B_ATTEST

```cpp
typedef struct TPM2B_ATTEST TPM2B_ATTEST;
```


#### typedef TPMI_AES_KEY_BITS

```cpp
typedef TPM_KEY_BITS TPMI_AES_KEY_BITS;
```


#### typedef TPMU_SYM_KEY_BITS

```cpp
typedef union TPMU_SYM_KEY_BITS TPMU_SYM_KEY_BITS;
```


#### typedef TPMU_SYM_MODE

```cpp
typedef union TPMU_SYM_MODE TPMU_SYM_MODE;
```


#### typedef TPMT_SYM_DEF

```cpp
typedef struct TPMT_SYM_DEF TPMT_SYM_DEF;
```


#### typedef TPMT_SYM_DEF_OBJECT

```cpp
typedef TPMT_SYM_DEF TPMT_SYM_DEF_OBJECT;
```


#### typedef TPM2B_SYM_KEY

```cpp
typedef struct TPM2B_SYM_KEY TPM2B_SYM_KEY;
```


#### typedef TPMS_SYMCIPHER_PARMS

```cpp
typedef struct TPMS_SYMCIPHER_PARMS TPMS_SYMCIPHER_PARMS;
```


#### typedef TPM2B_LABEL

```cpp
typedef struct TPM2B_LABEL TPM2B_LABEL;
```


#### typedef TPMS_DERIVE

```cpp
typedef struct TPMS_DERIVE TPMS_DERIVE;
```


#### typedef TPM2B_DERIVE

```cpp
typedef struct TPM2B_DERIVE TPM2B_DERIVE;
```


#### typedef TPMU_SENSITIVE_CREATE

```cpp
typedef union TPMU_SENSITIVE_CREATE TPMU_SENSITIVE_CREATE;
```


#### typedef TPM2B_SENSITIVE_DATA

```cpp
typedef struct TPM2B_SENSITIVE_DATA TPM2B_SENSITIVE_DATA;
```


#### typedef TPMS_SENSITIVE_CREATE

```cpp
typedef struct TPMS_SENSITIVE_CREATE TPMS_SENSITIVE_CREATE;
```


#### typedef TPM2B_SENSITIVE_CREATE

```cpp
typedef struct TPM2B_SENSITIVE_CREATE TPM2B_SENSITIVE_CREATE;
```


#### typedef TPMS_SCHEME_HASH

```cpp
typedef struct TPMS_SCHEME_HASH TPMS_SCHEME_HASH;
```


#### typedef TPMS_SCHEME_ECDAA

```cpp
typedef struct TPMS_SCHEME_ECDAA TPMS_SCHEME_ECDAA;
```


#### typedef TPMI_ALG_KEYEDHASH_SCHEME

```cpp
typedef TPM_ALG_ID TPMI_ALG_KEYEDHASH_SCHEME;
```


#### typedef TPMS_SCHEME_HMAC

```cpp
typedef TPMS_SCHEME_HASH TPMS_SCHEME_HMAC;
```


#### typedef TPMU_SCHEME_KEYEDHASH

```cpp
typedef union TPMU_SCHEME_KEYEDHASH TPMU_SCHEME_KEYEDHASH;
```


#### typedef TPMT_KEYEDHASH_SCHEME

```cpp
typedef struct TPMT_KEYEDHASH_SCHEME TPMT_KEYEDHASH_SCHEME;
```


#### typedef TPMS_SIG_SCHEME_RSASSA

```cpp
typedef TPMS_SCHEME_HASH TPMS_SIG_SCHEME_RSASSA;
```


#### typedef TPMS_SIG_SCHEME_RSAPSS

```cpp
typedef TPMS_SCHEME_HASH TPMS_SIG_SCHEME_RSAPSS;
```


#### typedef TPMS_SIG_SCHEME_ECDSA

```cpp
typedef TPMS_SCHEME_HASH TPMS_SIG_SCHEME_ECDSA;
```


#### typedef TPMS_SIG_SCHEME_ECDAA

```cpp
typedef TPMS_SCHEME_ECDAA TPMS_SIG_SCHEME_ECDAA;
```


#### typedef TPMU_SIG_SCHEME

```cpp
typedef union TPMU_SIG_SCHEME TPMU_SIG_SCHEME;
```


#### typedef TPMT_SIG_SCHEME

```cpp
typedef struct TPMT_SIG_SCHEME TPMT_SIG_SCHEME;
```


#### typedef TPMS_ENC_SCHEME_OAEP

```cpp
typedef TPMS_SCHEME_HASH TPMS_ENC_SCHEME_OAEP;
```


#### typedef TPMS_KEY_SCHEME_ECDH

```cpp
typedef TPMS_SCHEME_HASH TPMS_KEY_SCHEME_ECDH;
```


#### typedef TPMS_KEY_SCHEME_ECMQV

```cpp
typedef TPMS_SCHEME_HASH TPMS_KEY_SCHEME_ECMQV;
```


#### typedef TPMS_SCHEME_MGF1

```cpp
typedef TPMS_SCHEME_HASH TPMS_SCHEME_MGF1;
```


#### typedef TPMS_SCHEME_KDF1_SP800_56A

```cpp
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF1_SP800_56A;
```


#### typedef TPMS_SCHEME_KDF2

```cpp
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF2;
```


#### typedef TPMS_SCHEME_KDF1_SP800_108

```cpp
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF1_SP800_108;
```


#### typedef TPMU_KDF_SCHEME

```cpp
typedef union TPMU_KDF_SCHEME TPMU_KDF_SCHEME;
```


#### typedef TPMT_KDF_SCHEME

```cpp
typedef struct TPMT_KDF_SCHEME TPMT_KDF_SCHEME;
```


#### typedef TPMI_ALG_ASYM_SCHEME

```cpp
typedef TPM_ALG_ID TPMI_ALG_ASYM_SCHEME;
```


#### typedef TPMU_ASYM_SCHEME

```cpp
typedef union TPMU_ASYM_SCHEME TPMU_ASYM_SCHEME;
```


#### typedef TPMT_ASYM_SCHEME

```cpp
typedef struct TPMT_ASYM_SCHEME TPMT_ASYM_SCHEME;
```


#### typedef TPMI_ALG_RSA_SCHEME

```cpp
typedef TPM_ALG_ID TPMI_ALG_RSA_SCHEME;
```


#### typedef TPMT_RSA_SCHEME

```cpp
typedef struct TPMT_RSA_SCHEME TPMT_RSA_SCHEME;
```


#### typedef TPMI_ALG_RSA_DECRYPT

```cpp
typedef TPM_ALG_ID TPMI_ALG_RSA_DECRYPT;
```


#### typedef TPMT_RSA_DECRYPT

```cpp
typedef struct TPMT_RSA_DECRYPT TPMT_RSA_DECRYPT;
```


#### typedef TPM2B_PUBLIC_KEY_RSA

```cpp
typedef struct TPM2B_PUBLIC_KEY_RSA TPM2B_PUBLIC_KEY_RSA;
```


#### typedef TPMI_RSA_KEY_BITS

```cpp
typedef TPM_KEY_BITS TPMI_RSA_KEY_BITS;
```


#### typedef TPM2B_PRIVATE_KEY_RSA

```cpp
typedef struct TPM2B_PRIVATE_KEY_RSA TPM2B_PRIVATE_KEY_RSA;
```


#### typedef TPM2B_ECC_PARAMETER

```cpp
typedef struct TPM2B_ECC_PARAMETER TPM2B_ECC_PARAMETER;
```


#### typedef TPMS_ECC_POINT

```cpp
typedef struct TPMS_ECC_POINT TPMS_ECC_POINT;
```


#### typedef TPM2B_ECC_POINT

```cpp
typedef struct TPM2B_ECC_POINT TPM2B_ECC_POINT;
```


#### typedef TPMI_ALG_ECC_SCHEME

```cpp
typedef TPM_ALG_ID TPMI_ALG_ECC_SCHEME;
```


#### typedef TPMI_ECC_CURVE

```cpp
typedef TPM_ECC_CURVE TPMI_ECC_CURVE;
```


#### typedef TPMT_ECC_SCHEME

```cpp
typedef TPMT_SIG_SCHEME TPMT_ECC_SCHEME;
```


#### typedef TPMS_ALGORITHM_DETAIL_ECC

```cpp
typedef struct TPMS_ALGORITHM_DETAIL_ECC TPMS_ALGORITHM_DETAIL_ECC;
```


#### typedef TPMS_SIGNATURE_RSA

```cpp
typedef struct TPMS_SIGNATURE_RSA TPMS_SIGNATURE_RSA;
```


#### typedef TPMS_SIGNATURE_RSASSA

```cpp
typedef TPMS_SIGNATURE_RSA TPMS_SIGNATURE_RSASSA;
```


#### typedef TPMS_SIGNATURE_RSAPSS

```cpp
typedef TPMS_SIGNATURE_RSA TPMS_SIGNATURE_RSAPSS;
```


#### typedef TPMS_SIGNATURE_ECC

```cpp
typedef struct TPMS_SIGNATURE_ECC TPMS_SIGNATURE_ECC;
```


#### typedef TPMS_SIGNATURE_ECDSA

```cpp
typedef TPMS_SIGNATURE_ECC TPMS_SIGNATURE_ECDSA;
```


#### typedef TPMS_SIGNATURE_ECDAA

```cpp
typedef TPMS_SIGNATURE_ECC TPMS_SIGNATURE_ECDAA;
```


#### typedef TPMU_SIGNATURE

```cpp
typedef union TPMU_SIGNATURE TPMU_SIGNATURE;
```


#### typedef TPMT_SIGNATURE

```cpp
typedef struct TPMT_SIGNATURE TPMT_SIGNATURE;
```


#### typedef TPMU_ENCRYPTED_SECRET

```cpp
typedef union TPMU_ENCRYPTED_SECRET TPMU_ENCRYPTED_SECRET;
```


#### typedef TPM2B_ENCRYPTED_SECRET

```cpp
typedef struct TPM2B_ENCRYPTED_SECRET TPM2B_ENCRYPTED_SECRET;
```


#### typedef TPMI_ALG_PUBLIC

```cpp
typedef TPM_ALG_ID TPMI_ALG_PUBLIC;
```


#### typedef TPMU_PUBLIC_ID

```cpp
typedef union TPMU_PUBLIC_ID TPMU_PUBLIC_ID;
```


#### typedef TPMS_KEYEDHASH_PARMS

```cpp
typedef struct TPMS_KEYEDHASH_PARMS TPMS_KEYEDHASH_PARMS;
```


#### typedef TPMS_ASYM_PARMS

```cpp
typedef struct TPMS_ASYM_PARMS TPMS_ASYM_PARMS;
```


#### typedef TPMS_RSA_PARMS

```cpp
typedef struct TPMS_RSA_PARMS TPMS_RSA_PARMS;
```


#### typedef TPMS_ECC_PARMS

```cpp
typedef struct TPMS_ECC_PARMS TPMS_ECC_PARMS;
```


#### typedef TPMU_PUBLIC_PARMS

```cpp
typedef union TPMU_PUBLIC_PARMS TPMU_PUBLIC_PARMS;
```


#### typedef TPMT_PUBLIC_PARMS

```cpp
typedef struct TPMT_PUBLIC_PARMS TPMT_PUBLIC_PARMS;
```


#### typedef TPMT_PUBLIC

```cpp
typedef struct TPMT_PUBLIC TPMT_PUBLIC;
```


#### typedef TPM2B_PUBLIC

```cpp
typedef struct TPM2B_PUBLIC TPM2B_PUBLIC;
```


#### typedef TPM2B_TEMPLATE

```cpp
typedef struct TPM2B_TEMPLATE TPM2B_TEMPLATE;
```


#### typedef TPM2B_PRIVATE_VENDOR_SPECIFIC

```cpp
typedef struct TPM2B_PRIVATE_VENDOR_SPECIFIC TPM2B_PRIVATE_VENDOR_SPECIFIC;
```


#### typedef TPMU_SENSITIVE_COMPOSITE

```cpp
typedef union TPMU_SENSITIVE_COMPOSITE TPMU_SENSITIVE_COMPOSITE;
```


#### typedef TPMT_SENSITIVE

```cpp
typedef struct TPMT_SENSITIVE TPMT_SENSITIVE;
```


#### typedef TPM2B_SENSITIVE

```cpp
typedef struct TPM2B_SENSITIVE TPM2B_SENSITIVE;
```


#### typedef TPMT_PRIVATE

```cpp
typedef struct TPMT_PRIVATE TPMT_PRIVATE;
```


#### typedef TPM2B_PRIVATE

```cpp
typedef struct TPM2B_PRIVATE TPM2B_PRIVATE;
```


#### typedef TPMS_ID_OBJECT

```cpp
typedef struct TPMS_ID_OBJECT TPMS_ID_OBJECT;
```


#### typedef TPM2B_ID_OBJECT

```cpp
typedef struct TPM2B_ID_OBJECT TPM2B_ID_OBJECT;
```


#### typedef TPM_NV_INDEX

```cpp
typedef UINT32 TPM_NV_INDEX;
```


#### typedef TPM_NT

```cpp
typedef enum TPM_NT TPM_NT;
```


#### typedef TPMS_NV_PIN_COUNTER_PARAMETERS

```cpp
typedef struct TPMS_NV_PIN_COUNTER_PARAMETERS TPMS_NV_PIN_COUNTER_PARAMETERS;
```


#### typedef TPMA_NV

```cpp
typedef UINT32 TPMA_NV;
```


#### typedef TPMS_NV_PUBLIC

```cpp
typedef struct TPMS_NV_PUBLIC TPMS_NV_PUBLIC;
```


#### typedef TPM2B_NV_PUBLIC

```cpp
typedef struct TPM2B_NV_PUBLIC TPM2B_NV_PUBLIC;
```


#### typedef TPM2B_CONTEXT_SENSITIVE

```cpp
typedef struct TPM2B_CONTEXT_SENSITIVE TPM2B_CONTEXT_SENSITIVE;
```


#### typedef TPMS_CONTEXT_DATA

```cpp
typedef struct TPMS_CONTEXT_DATA TPMS_CONTEXT_DATA;
```


#### typedef TPM2B_CONTEXT_DATA

```cpp
typedef struct TPM2B_CONTEXT_DATA TPM2B_CONTEXT_DATA;
```


#### typedef TPMS_CONTEXT

```cpp
typedef struct TPMS_CONTEXT TPMS_CONTEXT;
```


#### typedef TPMS_CREATION_DATA

```cpp
typedef struct TPMS_CREATION_DATA TPMS_CREATION_DATA;
```


#### typedef TPM2B_CREATION_DATA

```cpp
typedef struct TPM2B_CREATION_DATA TPM2B_CREATION_DATA;
```


#### typedef TPMS_AUTH_COMMAND

```cpp
typedef struct TPMS_AUTH_COMMAND TPMS_AUTH_COMMAND;
```


#### typedef TPMS_AUTH_RESPONSE

```cpp
typedef struct TPMS_AUTH_RESPONSE TPMS_AUTH_RESPONSE;
```


#### typedef TPM2_AUTH_SESSION

```cpp
typedef struct TPM2_AUTH_SESSION TPM2_AUTH_SESSION;
```


#### typedef TPM2HalIoCb

```cpp
typedef int(* TPM2HalIoCb)(struct TPM2_CTX *, const BYTE *txBuf, BYTE *rxBuf, UINT16 xferSz, void *userCtx);
```


#### typedef TPM2_CTX

```cpp
typedef struct TPM2_CTX TPM2_CTX;
```


#### typedef ChangePPS_In

```cpp
typedef ChangeSeed_In ChangePPS_In;
```


#### typedef ChangeEPS_In

```cpp
typedef ChangeSeed_In ChangeEPS_In;
```


#### typedef TPM_MODE_SET

```cpp
typedef struct TPM_MODE_SET TPM_MODE_SET;
```


#### typedef TPMI_GPIO_NAME

```cpp
typedef UINT32 TPMI_GPIO_NAME;
```


#### typedef TPMI_GPIO_MODE

```cpp
typedef UINT32 TPMI_GPIO_MODE;
```


#### typedef TPMS_GPIO_CONFIG

```cpp
typedef struct TPMS_GPIO_CONFIG TPMS_GPIO_CONFIG;
```


#### typedef TPML_GPIO_CONFIG

```cpp
typedef struct TPML_GPIO_CONFIG TPML_GPIO_CONFIG;
```



### Functions Documentation

#### function TPM2_Startup

```cpp
WOLFTPM_API TPM_RC TPM2_Startup(
    Startup_In * in
)
```


#### function TPM2_Shutdown

```cpp
WOLFTPM_API TPM_RC TPM2_Shutdown(
    Shutdown_In * in
)
```


#### function TPM2_GetCapability

```cpp
WOLFTPM_API TPM_RC TPM2_GetCapability(
    GetCapability_In * in,
    GetCapability_Out * out
)
```


#### function TPM2_SelfTest

```cpp
WOLFTPM_API TPM_RC TPM2_SelfTest(
    SelfTest_In * in
)
```


#### function TPM2_IncrementalSelfTest

```cpp
WOLFTPM_API TPM_RC TPM2_IncrementalSelfTest(
    IncrementalSelfTest_In * in,
    IncrementalSelfTest_Out * out
)
```


#### function TPM2_GetTestResult

```cpp
WOLFTPM_API TPM_RC TPM2_GetTestResult(
    GetTestResult_Out * out
)
```


#### function TPM2_GetRandom

```cpp
WOLFTPM_API TPM_RC TPM2_GetRandom(
    GetRandom_In * in,
    GetRandom_Out * out
)
```


#### function TPM2_StirRandom

```cpp
WOLFTPM_API TPM_RC TPM2_StirRandom(
    StirRandom_In * in
)
```


#### function TPM2_PCR_Read

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_Read(
    PCR_Read_In * in,
    PCR_Read_Out * out
)
```


#### function TPM2_PCR_Extend

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_Extend(
    PCR_Extend_In * in
)
```


#### function TPM2_Create

```cpp
WOLFTPM_API TPM_RC TPM2_Create(
    Create_In * in,
    Create_Out * out
)
```


#### function TPM2_CreateLoaded

```cpp
WOLFTPM_API TPM_RC TPM2_CreateLoaded(
    CreateLoaded_In * in,
    CreateLoaded_Out * out
)
```


#### function TPM2_CreatePrimary

```cpp
WOLFTPM_API TPM_RC TPM2_CreatePrimary(
    CreatePrimary_In * in,
    CreatePrimary_Out * out
)
```


#### function TPM2_Load

```cpp
WOLFTPM_API TPM_RC TPM2_Load(
    Load_In * in,
    Load_Out * out
)
```


#### function TPM2_FlushContext

```cpp
WOLFTPM_API TPM_RC TPM2_FlushContext(
    FlushContext_In * in
)
```


#### function TPM2_Unseal

```cpp
WOLFTPM_API TPM_RC TPM2_Unseal(
    Unseal_In * in,
    Unseal_Out * out
)
```


#### function TPM2_StartAuthSession

```cpp
WOLFTPM_API TPM_RC TPM2_StartAuthSession(
    StartAuthSession_In * in,
    StartAuthSession_Out * out
)
```


#### function TPM2_PolicyRestart

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyRestart(
    PolicyRestart_In * in
)
```


#### function TPM2_LoadExternal

```cpp
WOLFTPM_API TPM_RC TPM2_LoadExternal(
    LoadExternal_In * in,
    LoadExternal_Out * out
)
```


#### function TPM2_ReadPublic

```cpp
WOLFTPM_API TPM_RC TPM2_ReadPublic(
    ReadPublic_In * in,
    ReadPublic_Out * out
)
```


#### function TPM2_ActivateCredential

```cpp
WOLFTPM_API TPM_RC TPM2_ActivateCredential(
    ActivateCredential_In * in,
    ActivateCredential_Out * out
)
```


#### function TPM2_MakeCredential

```cpp
WOLFTPM_API TPM_RC TPM2_MakeCredential(
    MakeCredential_In * in,
    MakeCredential_Out * out
)
```


#### function TPM2_ObjectChangeAuth

```cpp
WOLFTPM_API TPM_RC TPM2_ObjectChangeAuth(
    ObjectChangeAuth_In * in,
    ObjectChangeAuth_Out * out
)
```


#### function TPM2_Duplicate

```cpp
WOLFTPM_API TPM_RC TPM2_Duplicate(
    Duplicate_In * in,
    Duplicate_Out * out
)
```


#### function TPM2_Rewrap

```cpp
WOLFTPM_API TPM_RC TPM2_Rewrap(
    Rewrap_In * in,
    Rewrap_Out * out
)
```


#### function TPM2_Import

```cpp
WOLFTPM_API TPM_RC TPM2_Import(
    Import_In * in,
    Import_Out * out
)
```


#### function TPM2_RSA_Encrypt

```cpp
WOLFTPM_API TPM_RC TPM2_RSA_Encrypt(
    RSA_Encrypt_In * in,
    RSA_Encrypt_Out * out
)
```


#### function TPM2_RSA_Decrypt

```cpp
WOLFTPM_API TPM_RC TPM2_RSA_Decrypt(
    RSA_Decrypt_In * in,
    RSA_Decrypt_Out * out
)
```


#### function TPM2_ECDH_KeyGen

```cpp
WOLFTPM_API TPM_RC TPM2_ECDH_KeyGen(
    ECDH_KeyGen_In * in,
    ECDH_KeyGen_Out * out
)
```


#### function TPM2_ECDH_ZGen

```cpp
WOLFTPM_API TPM_RC TPM2_ECDH_ZGen(
    ECDH_ZGen_In * in,
    ECDH_ZGen_Out * out
)
```


#### function TPM2_ECC_Parameters

```cpp
WOLFTPM_API TPM_RC TPM2_ECC_Parameters(
    ECC_Parameters_In * in,
    ECC_Parameters_Out * out
)
```


#### function TPM2_ZGen_2Phase

```cpp
WOLFTPM_API TPM_RC TPM2_ZGen_2Phase(
    ZGen_2Phase_In * in,
    ZGen_2Phase_Out * out
)
```


#### function TPM2_EncryptDecrypt

```cpp
WOLFTPM_API TPM_RC TPM2_EncryptDecrypt(
    EncryptDecrypt_In * in,
    EncryptDecrypt_Out * out
)
```


#### function TPM2_EncryptDecrypt2

```cpp
WOLFTPM_API TPM_RC TPM2_EncryptDecrypt2(
    EncryptDecrypt2_In * in,
    EncryptDecrypt2_Out * out
)
```


#### function TPM2_Hash

```cpp
WOLFTPM_API TPM_RC TPM2_Hash(
    Hash_In * in,
    Hash_Out * out
)
```


#### function TPM2_HMAC

```cpp
WOLFTPM_API TPM_RC TPM2_HMAC(
    HMAC_In * in,
    HMAC_Out * out
)
```


#### function TPM2_HMAC_Start

```cpp
WOLFTPM_API TPM_RC TPM2_HMAC_Start(
    HMAC_Start_In * in,
    HMAC_Start_Out * out
)
```


#### function TPM2_HashSequenceStart

```cpp
WOLFTPM_API TPM_RC TPM2_HashSequenceStart(
    HashSequenceStart_In * in,
    HashSequenceStart_Out * out
)
```


#### function TPM2_SequenceUpdate

```cpp
WOLFTPM_API TPM_RC TPM2_SequenceUpdate(
    SequenceUpdate_In * in
)
```


#### function TPM2_SequenceComplete

```cpp
WOLFTPM_API TPM_RC TPM2_SequenceComplete(
    SequenceComplete_In * in,
    SequenceComplete_Out * out
)
```


#### function TPM2_EventSequenceComplete

```cpp
WOLFTPM_API TPM_RC TPM2_EventSequenceComplete(
    EventSequenceComplete_In * in,
    EventSequenceComplete_Out * out
)
```


#### function TPM2_Certify

```cpp
WOLFTPM_API TPM_RC TPM2_Certify(
    Certify_In * in,
    Certify_Out * out
)
```


#### function TPM2_CertifyCreation

```cpp
WOLFTPM_API TPM_RC TPM2_CertifyCreation(
    CertifyCreation_In * in,
    CertifyCreation_Out * out
)
```


#### function TPM2_Quote

```cpp
WOLFTPM_API TPM_RC TPM2_Quote(
    Quote_In * in,
    Quote_Out * out
)
```


#### function TPM2_GetSessionAuditDigest

```cpp
WOLFTPM_API TPM_RC TPM2_GetSessionAuditDigest(
    GetSessionAuditDigest_In * in,
    GetSessionAuditDigest_Out * out
)
```


#### function TPM2_GetCommandAuditDigest

```cpp
WOLFTPM_API TPM_RC TPM2_GetCommandAuditDigest(
    GetCommandAuditDigest_In * in,
    GetCommandAuditDigest_Out * out
)
```


#### function TPM2_GetTime

```cpp
WOLFTPM_API TPM_RC TPM2_GetTime(
    GetTime_In * in,
    GetTime_Out * out
)
```


#### function TPM2_Commit

```cpp
WOLFTPM_API TPM_RC TPM2_Commit(
    Commit_In * in,
    Commit_Out * out
)
```


#### function TPM2_EC_Ephemeral

```cpp
WOLFTPM_API TPM_RC TPM2_EC_Ephemeral(
    EC_Ephemeral_In * in,
    EC_Ephemeral_Out * out
)
```


#### function TPM2_VerifySignature

```cpp
WOLFTPM_API TPM_RC TPM2_VerifySignature(
    VerifySignature_In * in,
    VerifySignature_Out * out
)
```


#### function TPM2_Sign

```cpp
WOLFTPM_API TPM_RC TPM2_Sign(
    Sign_In * in,
    Sign_Out * out
)
```


#### function TPM2_SetCommandCodeAuditStatus

```cpp
WOLFTPM_API TPM_RC TPM2_SetCommandCodeAuditStatus(
    SetCommandCodeAuditStatus_In * in
)
```


#### function TPM2_PCR_Event

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_Event(
    PCR_Event_In * in,
    PCR_Event_Out * out
)
```


#### function TPM2_PCR_Allocate

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_Allocate(
    PCR_Allocate_In * in,
    PCR_Allocate_Out * out
)
```


#### function TPM2_PCR_SetAuthPolicy

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_SetAuthPolicy(
    PCR_SetAuthPolicy_In * in
)
```


#### function TPM2_PCR_SetAuthValue

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_SetAuthValue(
    PCR_SetAuthValue_In * in
)
```


#### function TPM2_PCR_Reset

```cpp
WOLFTPM_API TPM_RC TPM2_PCR_Reset(
    PCR_Reset_In * in
)
```


#### function TPM2_PolicySigned

```cpp
WOLFTPM_API TPM_RC TPM2_PolicySigned(
    PolicySigned_In * in,
    PolicySigned_Out * out
)
```


#### function TPM2_PolicySecret

```cpp
WOLFTPM_API TPM_RC TPM2_PolicySecret(
    PolicySecret_In * in,
    PolicySecret_Out * out
)
```


#### function TPM2_PolicyTicket

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyTicket(
    PolicyTicket_In * in
)
```


#### function TPM2_PolicyOR

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyOR(
    PolicyOR_In * in
)
```


#### function TPM2_PolicyPCR

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyPCR(
    PolicyPCR_In * in
)
```


#### function TPM2_PolicyLocality

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyLocality(
    PolicyLocality_In * in
)
```


#### function TPM2_PolicyNV

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyNV(
    PolicyNV_In * in
)
```


#### function TPM2_PolicyCounterTimer

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyCounterTimer(
    PolicyCounterTimer_In * in
)
```


#### function TPM2_PolicyCommandCode

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyCommandCode(
    PolicyCommandCode_In * in
)
```


#### function TPM2_PolicyPhysicalPresence

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyPhysicalPresence(
    PolicyPhysicalPresence_In * in
)
```


#### function TPM2_PolicyCpHash

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyCpHash(
    PolicyCpHash_In * in
)
```


#### function TPM2_PolicyNameHash

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyNameHash(
    PolicyNameHash_In * in
)
```


#### function TPM2_PolicyDuplicationSelect

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyDuplicationSelect(
    PolicyDuplicationSelect_In * in
)
```


#### function TPM2_PolicyAuthorize

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyAuthorize(
    PolicyAuthorize_In * in
)
```


#### function TPM2_PolicyAuthValue

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyAuthValue(
    PolicyAuthValue_In * in
)
```


#### function TPM2_PolicyPassword

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyPassword(
    PolicyPassword_In * in
)
```


#### function TPM2_PolicyGetDigest

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyGetDigest(
    PolicyGetDigest_In * in,
    PolicyGetDigest_Out * out
)
```


#### function TPM2_PolicyNvWritten

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyNvWritten(
    PolicyNvWritten_In * in
)
```


#### function TPM2_PolicyTemplate

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyTemplate(
    PolicyTemplate_In * in
)
```


#### function TPM2_PolicyAuthorizeNV

```cpp
WOLFTPM_API TPM_RC TPM2_PolicyAuthorizeNV(
    PolicyAuthorizeNV_In * in
)
```


#### function _TPM_Hash_Start

```cpp
WOLFTPM_API void _TPM_Hash_Start(
    void 
)
```


#### function _TPM_Hash_Data

```cpp
WOLFTPM_API void _TPM_Hash_Data(
    UINT32 dataSize,
    BYTE * data
)
```


#### function _TPM_Hash_End

```cpp
WOLFTPM_API void _TPM_Hash_End(
    void 
)
```


#### function TPM2_HierarchyControl

```cpp
WOLFTPM_API TPM_RC TPM2_HierarchyControl(
    HierarchyControl_In * in
)
```


#### function TPM2_SetPrimaryPolicy

```cpp
WOLFTPM_API TPM_RC TPM2_SetPrimaryPolicy(
    SetPrimaryPolicy_In * in
)
```


#### function TPM2_ChangePPS

```cpp
WOLFTPM_API TPM_RC TPM2_ChangePPS(
    ChangePPS_In * in
)
```


#### function TPM2_ChangeEPS

```cpp
WOLFTPM_API TPM_RC TPM2_ChangeEPS(
    ChangeEPS_In * in
)
```


#### function TPM2_Clear

```cpp
WOLFTPM_API TPM_RC TPM2_Clear(
    Clear_In * in
)
```


#### function TPM2_ClearControl

```cpp
WOLFTPM_API TPM_RC TPM2_ClearControl(
    ClearControl_In * in
)
```


#### function TPM2_HierarchyChangeAuth

```cpp
WOLFTPM_API TPM_RC TPM2_HierarchyChangeAuth(
    HierarchyChangeAuth_In * in
)
```


#### function TPM2_DictionaryAttackLockReset

```cpp
WOLFTPM_API TPM_RC TPM2_DictionaryAttackLockReset(
    DictionaryAttackLockReset_In * in
)
```


#### function TPM2_DictionaryAttackParameters

```cpp
WOLFTPM_API TPM_RC TPM2_DictionaryAttackParameters(
    DictionaryAttackParameters_In * in
)
```


#### function TPM2_PP_Commands

```cpp
WOLFTPM_API TPM_RC TPM2_PP_Commands(
    PP_Commands_In * in
)
```


#### function TPM2_SetAlgorithmSet

```cpp
WOLFTPM_API TPM_RC TPM2_SetAlgorithmSet(
    SetAlgorithmSet_In * in
)
```


#### function TPM2_FieldUpgradeStart

```cpp
WOLFTPM_API TPM_RC TPM2_FieldUpgradeStart(
    FieldUpgradeStart_In * in
)
```


#### function TPM2_FieldUpgradeData

```cpp
WOLFTPM_API TPM_RC TPM2_FieldUpgradeData(
    FieldUpgradeData_In * in,
    FieldUpgradeData_Out * out
)
```


#### function TPM2_FirmwareRead

```cpp
WOLFTPM_API TPM_RC TPM2_FirmwareRead(
    FirmwareRead_In * in,
    FirmwareRead_Out * out
)
```


#### function TPM2_ContextSave

```cpp
WOLFTPM_API TPM_RC TPM2_ContextSave(
    ContextSave_In * in,
    ContextSave_Out * out
)
```


#### function TPM2_ContextLoad

```cpp
WOLFTPM_API TPM_RC TPM2_ContextLoad(
    ContextLoad_In * in,
    ContextLoad_Out * out
)
```


#### function TPM2_EvictControl

```cpp
WOLFTPM_API TPM_RC TPM2_EvictControl(
    EvictControl_In * in
)
```


#### function TPM2_ReadClock

```cpp
WOLFTPM_API TPM_RC TPM2_ReadClock(
    ReadClock_Out * out
)
```


#### function TPM2_ClockSet

```cpp
WOLFTPM_API TPM_RC TPM2_ClockSet(
    ClockSet_In * in
)
```


#### function TPM2_ClockRateAdjust

```cpp
WOLFTPM_API TPM_RC TPM2_ClockRateAdjust(
    ClockRateAdjust_In * in
)
```


#### function TPM2_TestParms

```cpp
WOLFTPM_API TPM_RC TPM2_TestParms(
    TestParms_In * in
)
```


#### function TPM2_NV_DefineSpace

```cpp
WOLFTPM_API TPM_RC TPM2_NV_DefineSpace(
    NV_DefineSpace_In * in
)
```


#### function TPM2_NV_UndefineSpace

```cpp
WOLFTPM_API TPM_RC TPM2_NV_UndefineSpace(
    NV_UndefineSpace_In * in
)
```


#### function TPM2_NV_UndefineSpaceSpecial

```cpp
WOLFTPM_API TPM_RC TPM2_NV_UndefineSpaceSpecial(
    NV_UndefineSpaceSpecial_In * in
)
```


#### function TPM2_NV_ReadPublic

```cpp
WOLFTPM_API TPM_RC TPM2_NV_ReadPublic(
    NV_ReadPublic_In * in,
    NV_ReadPublic_Out * out
)
```


#### function TPM2_NV_Write

```cpp
WOLFTPM_API TPM_RC TPM2_NV_Write(
    NV_Write_In * in
)
```


#### function TPM2_NV_Increment

```cpp
WOLFTPM_API TPM_RC TPM2_NV_Increment(
    NV_Increment_In * in
)
```


#### function TPM2_NV_Extend

```cpp
WOLFTPM_API TPM_RC TPM2_NV_Extend(
    NV_Extend_In * in
)
```


#### function TPM2_NV_SetBits

```cpp
WOLFTPM_API TPM_RC TPM2_NV_SetBits(
    NV_SetBits_In * in
)
```


#### function TPM2_NV_WriteLock

```cpp
WOLFTPM_API TPM_RC TPM2_NV_WriteLock(
    NV_WriteLock_In * in
)
```


#### function TPM2_NV_GlobalWriteLock

```cpp
WOLFTPM_API TPM_RC TPM2_NV_GlobalWriteLock(
    NV_GlobalWriteLock_In * in
)
```


#### function TPM2_NV_Read

```cpp
WOLFTPM_API TPM_RC TPM2_NV_Read(
    NV_Read_In * in,
    NV_Read_Out * out
)
```


#### function TPM2_NV_ReadLock

```cpp
WOLFTPM_API TPM_RC TPM2_NV_ReadLock(
    NV_ReadLock_In * in
)
```


#### function TPM2_NV_ChangeAuth

```cpp
WOLFTPM_API TPM_RC TPM2_NV_ChangeAuth(
    NV_ChangeAuth_In * in
)
```


#### function TPM2_NV_Certify

```cpp
WOLFTPM_API TPM_RC TPM2_NV_Certify(
    NV_Certify_In * in,
    NV_Certify_Out * out
)
```


#### function TPM2_SetCommandSet

```cpp
WOLFTPM_API int TPM2_SetCommandSet(
    SetCommandSet_In * in
)
```


#### function TPM2_SetMode

```cpp
WOLFTPM_API int TPM2_SetMode(
    SetMode_In * in
)
```


#### function TPM2_GPIO_Config

```cpp
WOLFTPM_API int TPM2_GPIO_Config(
    GpioConfig_In * in
)
```


#### function TPM2_NTC2_PreConfig

```cpp
WOLFTPM_API int TPM2_NTC2_PreConfig(
    NTC2_PreConfig_In * in
)
```


#### function TPM2_NTC2_GetConfig

```cpp
WOLFTPM_API int TPM2_NTC2_GetConfig(
    NTC2_GetConfig_Out * out
)
```


#### function TPM2_Init

```cpp
WOLFTPM_API TPM_RC TPM2_Init(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Initializes a TPM with HAL IO callback and user supplied context. When using wolfTPM with &ndash;enable-devtpm or &ndash;enable-swtpm configuration, the ioCb and userCtx are not used. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct


**See**: 

  * [TPM2_Startup](#function-tpm2-startup)
  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init_ex](#function-tpm2-init-ex)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: [TPM2_Init_minimal()](#function-tpm2-init-ex) with both ioCb and userCtx set to NULL. In other modes, the ioCb shall be set in order to use TIS. Example ioCB for baremetal and RTOS applications are provided in examples/tpm_io.c

_Example_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Init(&tpm2Ctx, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Init failed
}
```


#### function TPM2_Init_ex

```cpp
WOLFTPM_API TPM_RC TPM2_Init_ex(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx,
    int timeoutTries
)
```

Initializes a TPM with timeoutTries, HAL IO callback and user supplied context. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct 
  * **timeoutTries** specifies the number of attempts to confirm that TPM2 startup has completed


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init](#function-tpm2-init)
  * wolfTPM2_Init_ex 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: It is recommended to use TPM2_Init instead of using TPM2_Init_ex directly.

#### function TPM2_Init_minimal

```cpp
WOLFTPM_API TPM_RC TPM2_Init_minimal(
    TPM2_CTX * ctx
)
```

Initializes a TPM and sets the wolfTPM2 context that will be used. This function is typically used for rich operating systems, like Windows. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG check arguments provided


**Note**: It is recommended to use TPM2_Init instead of using TPM2_Init_minimal directly.

#### function TPM2_Cleanup

```cpp
WOLFTPM_API TPM_RC TPM2_Cleanup(
    TPM2_CTX * ctx
)
```

Deinitializes a TPM and wolfcrypt (if it was initialized) 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 device structure is a NULL pointer


_Example_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Cleanup(&tpm2Ctx->dev);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Cleanup failed
}
```


#### function TPM2_ChipStartup

```cpp
WOLFTPM_API TPM_RC TPM2_ChipStartup(
    TPM2_CTX * ctx,
    int timeoutTries
)
```

Makes sure the TPM2 startup has completed and extracts the TPM device information. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **timeoutTries** specifies the number of attempts to check if TPM2 startup has completed


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * TPM2_TIS_StartupWait 
  * TPM2_TIS_RequestLocality 
  * TPM2_TIS_GetInfo 
  * [TPM2_Init_ex](#function-tpm2-init-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG: check the provided arguments 
  * TPM_RC_TIMEOUT: timeout occurred


**Note**: This function is used in TPM2_Init_ex

#### function TPM2_SetHalIoCb

```cpp
WOLFTPM_API TPM_RC TPM2_SetHalIoCb(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Sets the user's context and IO callbacks needed for TPM communication. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct 
  * **ioCb** pointer to TPM2HalIoCb (HAL IO) callback function 
  * **userCtx** pointer to the user's context that will be stored as a member of the ctx struct


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 device structure is a NULL pointer


**Note**: SetHalIoCb will fail if built with devtpm or swtpm as the callback is not used for TPM. For other configuration builds, ioCb must be set to a non-NULL function pointer and userCtx is optional.

Typically, TPM2_Init or wolfTPM2_Init are used to set the HAL IO. 


#### function TPM2_SetSessionAuth

```cpp
WOLFTPM_API TPM_RC TPM2_SetSessionAuth(
    TPM2_AUTH_SESSION * session
)
```

Sets the structure holding the TPM Authorizations. 

**Parameters**: 

  * **session** pointer to an array of type [TPM2_AUTH_SESSION]()


**See**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: the TPM2 context structure is a NULL pointer


Rarely used, because TPM2_Init functions and wolfTPM2_Init perform this initialization as well TPM 2.0 Commands can have up to three authorization slots, therefore it is recommended to supply an array of size MAX_SESSION_NUM to TPM2_SetSessionAuth(see example below).

_Example_

```cpp
int rc;
TPM2_AUTH_SESSION session[MAX_SESSION_NUM];

XMEMSET(session, 0, sizeof(session));
session[0].sessionHandle = TPM_RS_PW;

rc = TPM2_SetSessionAuth(session);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_SetSessionAuth failed
}
```


#### function TPM2_GetSessionAuthCount

```cpp
WOLFTPM_API int TPM2_GetSessionAuthCount(
    TPM2_CTX * ctx
)
```

Determine the number of currently set TPM Authorizations. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**Return**: 

  * the number of active TPM Authorizations (between one and three) 
  * BAD_FUNC_ARG: check the arguments provided for a NULL pointer


_Example_

```cpp
int authCount;
TPM2_CTX tpm2Ctx;

authCount = TPM2_GetSessionAuthCount(tpm2ctx);
if (authCount == BAD_FUNC_ARG) {
    // TPM2_GetSessionAuthCount failed
}
```


#### function TPM2_SetActiveCtx

```cpp
WOLFTPM_API void TPM2_SetActiveCtx(
    TPM2_CTX * ctx
)
```

Sets a new TPM2 context for use. 

**Parameters**: 

  * **ctx** pointer to a [TPM2_CTX]() struct


**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


_Example_

```cpp
TPM2_CTX tpm2Ctx;

TPM2_SetActiveCtx(tpm2ctx);
```


#### function TPM2_GetActiveCtx

```cpp
WOLFTPM_API TPM2_CTX * TPM2_GetActiveCtx(
    void 
)
```

Provides a pointer to the TPM2 context in use. 

**See**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**Return**: ctx pointer to a [TPM2_CTX]() struct

_Example_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```


#### function TPM2_GetHashDigestSize

```cpp
WOLFTPM_API int TPM2_GetHashDigestSize(
    TPMI_ALG_HASH hashAlg
)
```

Determine the size in bytes of a TPM 2.0 hash digest. 

**Parameters**: 

  * **hashAlg** a valid TPM 2.0 hash type


**Return**: 

  * the size of a TPM 2.0 hash digest as number of bytes 
  * 0 if hash type is invalid


_Example_

```cpp
int digestSize = 0;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

digestSize = TPM2_GetHashDigestSize(hashAlg);
if (digestSize > 0) {
    //digestSize contains a valid value
}
```


#### function TPM2_GetHashType

```cpp
WOLFTPM_API int TPM2_GetHashType(
    TPMI_ALG_HASH hashAlg
)
```

Translate a TPM2 hash type to its coresponding wolfcrypt hash type. 

**Parameters**: 

  * **hashAlg** a valid TPM 2.0 hash type


**Return**: 

  * a value specifying a hash type to use with wolfcrypt 
  * 0 if hash type is invalid


_Example_

```cpp
int wc_hashType;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

wc_hashType = TPM2_GetHashDigestSize(hashAlg);
if (wc_hashType > 0) {
    //wc_hashType contains a valid wolfcrypt hash type
}
```


#### function TPM2_GetNonce

```cpp
WOLFTPM_API int TPM2_GetNonce(
    byte * nonceBuf,
    int nonceSz
)
```

Generate a fresh nonce of random numbers. 

**Parameters**: 

  * **nonceBuf** pointer to a BYTE buffer 
  * **nonceSz** size of the nonce in bytes


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (TPM IO issue or wolfcrypt configuration) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Can use the TPM random number generator if WOLFTPM2_USE_HW_RNG is defined

_Example_

```cpp
int rc, nonceSize = 32;
BYTE freshNonce[32];

rc = TPM2_GetNonce(&freshNonce, nonceSize);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetNonce failed
}
```


#### function TPM2_SetupPCRSel

```cpp
WOLFTPM_API void TPM2_SetupPCRSel(
    TPML_PCR_SELECTION * pcr,
    TPM_ALG_ID alg,
    int pcrIndex
)
```

Helper function to prepare a correct PCR selection For example, when preparing to create a TPM2_Quote. 

**Parameters**: 

  * **pcr** pointer to a structure of type [TPML_PCR_SELECTION]()
  * **alg** value of type TPM_ALG_ID specifying the type of hash algorithm used 
  * **pcrIndex** value between 0 and 23 specifying the PCR register for use


**See**: 

  * [TPM2_PCR_Read](#function-tpm2-pcr-read)
  * [TPM2_PCR_Extend](#function-tpm2-pcr-extend)
  * [TPM2_PCR_Reset](#function-tpm2-pcr-reset)
  * [TPM2_Quote](#function-tpm2-quote)


_Example_

```cpp
int pcrIndex = 16; // This is a PCR register for DEBUG & testing purposes
PCR_Read_In pcrRead;

TPM2_SetupPCRSel(&pcrRead.pcrSelectionIn, TPM_ALG_SHA256, pcrIndex);
```


#### function TPM2_GetRCString

```cpp
const WOLFTPM_API char * TPM2_GetRCString(
    int rc
)
```

Get a human readable string for any TPM 2.0 return code. 

**Parameters**: 

  * **rc** integer value representing a TPM return code


**Return**: pointer to a string constant

_Example_

```cpp
int rc;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    printf("wolfTPM2_Init failed 0x%x: %s\n", rc, TPM2_GetRCString(rc));
    return rc;
}
```


#### function TPM2_GetAlgName

```cpp
const WOLFTPM_API char * TPM2_GetAlgName(
    TPM_ALG_ID alg
)
```

Get a human readable string for any TPM 2.0 algorithm. 

**Parameters**: 

  * **alg** value of type TPM_ALG_ID specifying a valid TPM 2.0 algorithm


**Return**: pointer to a string constant

_Example_

```cpp
int paramEncAlg = TPM_ALG_CFB;

printf("\tUse Parameter Encryption: %s\n", TPM2_GetAlgName(paramEncAlg));
```


#### function TPM2_GetCurveSize

```cpp
WOLFTPM_API int TPM2_GetCurveSize(
    TPM_ECC_CURVE curveID
)
```

Determine the size in bytes of any TPM ECC Curve. 

**Parameters**: 

  * **curveID** value of type TPM_ECC_CURVE


**Return**: 

  * 0 in case of invalid curve type 
  * integer value representing the number of bytes


_Example_

```cpp
int bytes;
TPM_ECC_CURVE curve = TPM_ECC_NIST_P256;

bytes = TPM2_GetCurveSize(curve);
if (bytes == 0) {
    //TPM2_GetCurveSize failed
}
```


#### function TPM2_GetTpmCurve

```cpp
WOLFTPM_API int TPM2_GetTpmCurve(
    int curveID
)
```

Translate a wolfcrypt curve type to its coresponding TPM curve type. 

**Parameters**: 

  * **curveID** pointer to a BYTE buffer


**See**: [TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)

**Return**: 

  * integer value representing a wolfcrypt curve type 
  * ECC_CURVE_OID_E in case of invalid curve type


_Example_

```cpp
int tpmCurve;
int wc_curve = ECC_SECP256R1;

tpmCurve = TPM2_GetTpmCurve(curve);
\in this case tpmCurve will be TPM_ECC_NIST_P256
if (tpmCurve = ECC_CURVE_OID_E) {
    //TPM2_GetTpmCurve failed
}
```


#### function TPM2_GetWolfCurve

```cpp
WOLFTPM_API int TPM2_GetWolfCurve(
    int curve_id
)
```

Translate a TPM curve type to its coresponding wolfcrypt curve type. 

**Parameters**: 

  * **curve_id** pointer to a BYTE buffer


**See**: [TPM2_GetTpmCurve](#function-tpm2-gettpmcurve)

**Return**: 

  * integer value representing a TPM curve type 
  * -1 or ECC_CURVE_OID_E in case of invalid curve type


_Example_

```cpp
int tpmCurve = TPM_ECC_NIST_P256;
int wc_curve;

wc_curve = TPM2_GetWolfCurve(tpmCurve);
\in this case tpmCurve will be ECC_SECP256R1
if (wc_curve = ECC_CURVE_OID_E || wc_curve == -1) {
    //TPM2_GetWolfCurve failed
}
```


#### function TPM2_ParseAttest

```cpp
WOLFTPM_API int TPM2_ParseAttest(
    const TPM2B_ATTEST * in,
    TPMS_ATTEST * out
)
```

Parses [TPM2B_ATTEST]() structure. 

**Parameters**: 

  * **in** pointer to a structure of a [TPM2B_ATTEST]() type 
  * **out** pointer to a structure of a [TPMS_ATTEST]() type


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This is public API of the helper function TPM2_Packet_ParseAttest

_Example_

```cpp
TPM2B_ATTEST in; //for example, as part of a TPM2_Quote
TPMS_ATTEST out

rc = TPM2_GetNonce(&in, &out);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParseAttest failed
}
```


#### function TPM2_HashNvPublic

```cpp
WOLFTPM_API int TPM2_HashNvPublic(
    TPMS_NV_PUBLIC * nvPublic,
    byte * buffer,
    UINT16 * size
)
```

Computes fresh NV Index name based on a nvPublic structure. 

**Parameters**: 

  * **nvPublic** 
  * **buffer** pointer to a structure of a [TPMS_ATTEST]() type 
  * **size** pointer to a variable of UINT16 type to store the size of the nvIndex


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * negative integer value in case of an error 
  * BAD_FUNC_ARG: check the provided arguments 
  * NOT_COMPILED_IN: check if wolfcrypt is enabled


_Example_

```cpp
TPMS_NV_PUBLIC nvPublic;
BYTE buffer[TPM_MAX_DIGEST_SIZE];
UINT16 size;

rc = TPM2_HashNvPublic(&nvPublic, &buffer, &size);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_HashNvPublic failed
}
```


#### function TPM2_AppendPublic

```cpp
WOLFTPM_API int TPM2_AppendPublic(
    byte * buf,
    word32 size,
    int * sizeUsed,
    TPM2B_PUBLIC * pub
)
```

Populates [TPM2B_PUBLIC]() structure based on a user provided buffer. 

**Parameters**: 

  * **buf** pointer to a user buffer 
  * **size** integer value of word32 type, specifying the size of the user buffer 
  * **sizeUsed** pointer to an integer variable, stores the used size of pub->buffer 
  * **pub** pointer to an empty structure of [TPM2B_PUBLIC]() type


**See**: [TPM2_ParsePublic](#function-tpm2-parsepublic)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: insufficient buffer size 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Public API of the helper function TPM2_Packet_AppendPublic

_Example_

```cpp
TPM2B_PUBLIC pub; //empty
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_AppendPublic(&buffer, size, &sizeUsed, &pub);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_AppendPublic failed
}
```


#### function TPM2_ParsePublic

```cpp
WOLFTPM_API int TPM2_ParsePublic(
    TPM2B_PUBLIC * pub,
    byte * buf,
    word32 size,
    int * sizeUsed
)
```

Parses [TPM2B_PUBLIC]() structure and stores in a user provided buffer. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **buf** pointer to an empty user buffer 
  * **size** integer value of word32 type, specifying the available size of the user buffer 
  * **sizeUsed** pointer to an integer variable, stores the used size of the user buffer


**See**: [TPM2_AppendPublic](#function-tpm2-appendpublic)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: insufficient buffer size 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Public API of the helper function TPM2_Packet_ParsePublic

_Example_

```cpp
TPM2B_PUBLIC pub; //populated
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_ParsePublic(&pub, buffer, size, &sizeUsed);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParsePublic failed
}
```


#### function TPM2_GetName

```cpp
WOLFTPM_LOCAL int TPM2_GetName(
    TPM2_CTX * ctx,
    UINT32 handleValue,
    int handleCnt,
    int idx,
    TPM2B_NAME * name
)
```

Provides the Name of a TPM object. 

**Parameters**: 

  * **ctx** pointer to a TPM2 context 
  * **handleValue** value of UINT32 type, specifying a valid TPM handle 
  * **handleCnt** total number of handles used in the current TPM command/session 
  * **idx** index value, between one and three, specifying a valid TPM Authorization session 
  * **name** pointer to an empty structure of [TPM2B_NAME]() type


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The object is reference by its TPM handle and session index

_Example_

```cpp
int rc;
UINT32 handleValue = TRANSIENT_FIRST;
handleCount = 1;
sessionIdx = 0;
TPM2B_NAME name;

rc = TPM2_GetName(ctx, handleValue, handleCount, sessionIdx, &name);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetName failed
}
```


#### function TPM2_GetWolfRng

```cpp
WOLFTPM_API int TPM2_GetWolfRng(
    WC_RNG ** rng
)
```


#### function TPM2_GetVendorID

```cpp
WOLFTPM_API UINT16 TPM2_GetVendorID(
    void 
)
```

Provides the vendorID of the active TPM2 context. 

**See**: 

  * TPM2_GetCapabilities 
  * TPM2_GetTpmDevId 
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * integer value of UINT16 type, specifying the vendor ID 
  * 0 if TPM2 context is invalid or NULL


**Note**: Depends on correctly read TPM device info during TPM Init

_Example_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```


#### function TPM2_PrintBin

```cpp
WOLFTPM_API void TPM2_PrintBin(
    const byte * buffer,
    word32 length
)
```

Helper function to print a binary buffer in a formated way. 

**Parameters**: 

  * **buffer** pointer to a buffer of BYTE type 
  * **length** integer value of word32 type, containing the size of the buffer


**See**: 

  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
BYTE buffer[] = {0x01,0x02,0x03,0x04};
length = sizeof(buffer);

TPM2_PrintBin(&buffer, length);
```


#### function TPM2_PrintAuth

```cpp
WOLFTPM_API void TPM2_PrintAuth(
    const TPMS_AUTH_COMMAND * authCmd
)
```

Helper function to print a structure of [TPMS_AUTH_COMMAND]() type in a human readable way. 

**Parameters**: 

  * **authCmd** pointer to a populated structure of [TPMS_AUTH_COMMAND]() type


**See**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
TPMS_AUTH_COMMAND authCmd; //for example, part of a TPM Authorization session

TPM2_PrintAuthCmd(&authCmd);
```


#### function TPM2_PrintPublicArea

```cpp
WOLFTPM_API void TPM2_PrintPublicArea(
    const TPM2B_PUBLIC * pub
)
```

Helper function to print a structure of [TPM2B_PUBLIC]() type in a human readable way. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type


**See**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_Create](#function-tpm2-create)
  * [TPM2_ReadPublic](#function-tpm2-readpublic)


**Note**: Requires DEBUG_WOLFTPM to be defined

_Example_

```cpp
TPM2B_PUBLIC pub; //for example, part of the output of a successful TPM2_Create

TPM2_PrintPublicArea(&pub);
```



### Attributes Documentation

#### variable C

```cpp
C {
#endif










typedef UINT32 TPM_ALGORITHM_ID;
```


#### variable TPM_20_EK_AUTH_POLICY

```cpp
static const BYTE[] TPM_20_EK_AUTH_POLICY = {
    0x83, 0x71, 0x97, 0x67, 0x44, 0x84, 0xb3, 0xf8, 0x1a, 0x90, 0xcc,
    0x8d, 0x46, 0xa5, 0xd7, 0x24, 0xfd, 0x52, 0xd7, 0x6e, 0x06, 0x52,
    0x0b, 0x64, 0xf2, 0xa1, 0xda, 0x1b, 0x33, 0x14, 0x69, 0xaa,
};
```



### Source code

```cpp
/* tpm2.h
 *
 * Copyright (C) 2006-2021 wolfSSL Inc.
 *
 * This file is part of wolfTPM.
 *
 * wolfTPM is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfTPM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */

#ifndef __TPM2_H__
#define __TPM2_H__

#include <wolftpm/tpm2_types.h>

#ifdef __cplusplus
    extern "C" {
#endif


/* ---------------------------------------------------------------------------*/
/* TYPES */
/* ---------------------------------------------------------------------------*/

typedef UINT32 TPM_ALGORITHM_ID;
typedef UINT32 TPM_MODIFIER_INDICATOR;
typedef UINT32 TPM_AUTHORIZATION_SIZE;
typedef UINT32 TPM_PARAMETER_SIZE;
typedef UINT16 TPM_KEY_SIZE;
typedef UINT16 TPM_KEY_BITS;
typedef UINT32 TPM_GENERATED;

/* ---------------------------------------------------------------------------*/
/* ENUMERATIONS */
/* ---------------------------------------------------------------------------*/

enum {
    TPM_SPEC_FAMILY = 0x322E3000,
    TPM_SPEC_LEVEL = 0,
    TPM_SPEC_VERSION = 138,
    TPM_SPEC_YEAR = 2016,
    TPM_SPEC_DAY_OF_YEAR = 273,

    TPM_GENERATED_VALUE = 0xff544347,
};


typedef enum {
    TPM_ALG_ERROR           = 0x0000,
    TPM_ALG_RSA             = 0x0001,
    TPM_ALG_SHA             = 0x0004,
    TPM_ALG_SHA1            = TPM_ALG_SHA,
    TPM_ALG_HMAC            = 0x0005,
    TPM_ALG_AES             = 0x0006,
    TPM_ALG_MGF1            = 0x0007,
    TPM_ALG_KEYEDHASH       = 0x0008,
    TPM_ALG_XOR             = 0x000A,
    TPM_ALG_SHA256          = 0x000B,
    TPM_ALG_SHA384          = 0x000C,
    TPM_ALG_SHA512          = 0x000D,
    TPM_ALG_NULL            = 0x0010,
    TPM_ALG_SM3_256         = 0x0012,
    TPM_ALG_SM4             = 0x0013,
    TPM_ALG_RSASSA          = 0x0014,
    TPM_ALG_RSAES           = 0x0015,
    TPM_ALG_RSAPSS          = 0x0016,
    TPM_ALG_OAEP            = 0x0017,
    TPM_ALG_ECDSA           = 0x0018,
    TPM_ALG_ECDH            = 0x0019,
    TPM_ALG_ECDAA           = 0x001A,
    TPM_ALG_SM2             = 0x001B,
    TPM_ALG_ECSCHNORR       = 0x001C,
    TPM_ALG_ECMQV           = 0x001D,
    TPM_ALG_KDF1_SP800_56A  = 0x0020,
    TPM_ALG_KDF2            = 0x0021,
    TPM_ALG_KDF1_SP800_108  = 0x0022,
    TPM_ALG_ECC             = 0x0023,
    TPM_ALG_SYMCIPHER       = 0x0025,
    TPM_ALG_CAMELLIA        = 0x0026,
    TPM_ALG_CTR             = 0x0040,
    TPM_ALG_OFB             = 0x0041,
    TPM_ALG_CBC             = 0x0042,
    TPM_ALG_CFB             = 0x0043,
    TPM_ALG_ECB             = 0x0044,
} TPM_ALG_ID_T;
typedef UINT16 TPM_ALG_ID;

typedef enum {
    TPM_ECC_NONE        = 0x0000,
    TPM_ECC_NIST_P192   = 0x0001,
    TPM_ECC_NIST_P224   = 0x0002,
    TPM_ECC_NIST_P256   = 0x0003,
    TPM_ECC_NIST_P384   = 0x0004,
    TPM_ECC_NIST_P521   = 0x0005,
    TPM_ECC_BN_P256     = 0x0010,
    TPM_ECC_BN_P638     = 0x0011,
    TPM_ECC_SM2_P256    = 0x0020,
} TPM_ECC_CURVE_T;
typedef UINT16 TPM_ECC_CURVE;

/* Command Codes */
typedef enum {
    TPM_CC_FIRST                    = 0x0000011F,
    TPM_CC_NV_UndefineSpaceSpecial  = TPM_CC_FIRST,
    TPM_CC_EvictControl             = 0x00000120,
    TPM_CC_HierarchyControl         = 0x00000121,
    TPM_CC_NV_UndefineSpace         = 0x00000122,
    TPM_CC_ChangeEPS                = 0x00000124,
    TPM_CC_ChangePPS                = 0x00000125,
    TPM_CC_Clear                    = 0x00000126,
    TPM_CC_ClearControl             = 0x00000127,
    TPM_CC_ClockSet                 = 0x00000128,
    TPM_CC_HierarchyChangeAuth      = 0x00000129,
    TPM_CC_NV_DefineSpace           = 0x0000012A,
    TPM_CC_PCR_Allocate             = 0x0000012B,
    TPM_CC_PCR_SetAuthPolicy        = 0x0000012C,
    TPM_CC_PP_Commands              = 0x0000012D,
    TPM_CC_SetPrimaryPolicy         = 0x0000012E,
    TPM_CC_FieldUpgradeStart        = 0x0000012F,
    TPM_CC_ClockRateAdjust          = 0x00000130,
    TPM_CC_CreatePrimary            = 0x00000131,
    TPM_CC_NV_GlobalWriteLock       = 0x00000132,
    TPM_CC_GetCommandAuditDigest    = 0x00000133,
    TPM_CC_NV_Increment             = 0x00000134,
    TPM_CC_NV_SetBits               = 0x00000135,
    TPM_CC_NV_Extend                = 0x00000136,
    TPM_CC_NV_Write                 = 0x00000137,
    TPM_CC_NV_WriteLock             = 0x00000138,
    TPM_CC_DictionaryAttackLockReset = 0x00000139,
    TPM_CC_DictionaryAttackParameters = 0x0000013A,
    TPM_CC_NV_ChangeAuth            = 0x0000013B,
    TPM_CC_PCR_Event                = 0x0000013C,
    TPM_CC_PCR_Reset                = 0x0000013D,
    TPM_CC_SequenceComplete         = 0x0000013E,
    TPM_CC_SetAlgorithmSet          = 0x0000013F,
    TPM_CC_SetCommandCodeAuditStatus = 0x00000140,
    TPM_CC_FieldUpgradeData         = 0x00000141,
    TPM_CC_IncrementalSelfTest      = 0x00000142,
    TPM_CC_SelfTest                 = 0x00000143,
    TPM_CC_Startup                  = 0x00000144,
    TPM_CC_Shutdown                 = 0x00000145,
    TPM_CC_StirRandom               = 0x00000146,
    TPM_CC_ActivateCredential       = 0x00000147,
    TPM_CC_Certify                  = 0x00000148,
    TPM_CC_PolicyNV                 = 0x00000149,
    TPM_CC_CertifyCreation          = 0x0000014A,
    TPM_CC_Duplicate                = 0x0000014B,
    TPM_CC_GetTime                  = 0x0000014C,
    TPM_CC_GetSessionAuditDigest    = 0x0000014D,
    TPM_CC_NV_Read                  = 0x0000014E,
    TPM_CC_NV_ReadLock              = 0x0000014F,
    TPM_CC_ObjectChangeAuth         = 0x00000150,
    TPM_CC_PolicySecret             = 0x00000151,
    TPM_CC_Rewrap                   = 0x00000152,
    TPM_CC_Create                   = 0x00000153,
    TPM_CC_ECDH_ZGen                = 0x00000154,
    TPM_CC_HMAC                     = 0x00000155,
    TPM_CC_Import                   = 0x00000156,
    TPM_CC_Load                     = 0x00000157,
    TPM_CC_Quote                    = 0x00000158,
    TPM_CC_RSA_Decrypt              = 0x00000159,
    TPM_CC_HMAC_Start               = 0x0000015B,
    TPM_CC_SequenceUpdate           = 0x0000015C,
    TPM_CC_Sign                     = 0x0000015D,
    TPM_CC_Unseal                   = 0x0000015E,
    TPM_CC_PolicySigned             = 0x00000160,
    TPM_CC_ContextLoad              = 0x00000161,
    TPM_CC_ContextSave              = 0x00000162,
    TPM_CC_ECDH_KeyGen              = 0x00000163,
    TPM_CC_EncryptDecrypt           = 0x00000164,
    TPM_CC_FlushContext             = 0x00000165,
    TPM_CC_LoadExternal             = 0x00000167,
    TPM_CC_MakeCredential           = 0x00000168,
    TPM_CC_NV_ReadPublic            = 0x00000169,
    TPM_CC_PolicyAuthorize          = 0x0000016A,
    TPM_CC_PolicyAuthValue          = 0x0000016B,
    TPM_CC_PolicyCommandCode        = 0x0000016C,
    TPM_CC_PolicyCounterTimer       = 0x0000016D,
    TPM_CC_PolicyCpHash             = 0x0000016E,
    TPM_CC_PolicyLocality           = 0x0000016F,
    TPM_CC_PolicyNameHash           = 0x00000170,
    TPM_CC_PolicyOR                 = 0x00000171,
    TPM_CC_PolicyTicket             = 0x00000172,
    TPM_CC_ReadPublic               = 0x00000173,
    TPM_CC_RSA_Encrypt              = 0x00000174,
    TPM_CC_StartAuthSession         = 0x00000176,
    TPM_CC_VerifySignature          = 0x00000177,
    TPM_CC_ECC_Parameters           = 0x00000178,
    TPM_CC_FirmwareRead             = 0x00000179,
    TPM_CC_GetCapability            = 0x0000017A,
    TPM_CC_GetRandom                = 0x0000017B,
    TPM_CC_GetTestResult            = 0x0000017C,
    TPM_CC_Hash                     = 0x0000017D,
    TPM_CC_PCR_Read                 = 0x0000017E,
    TPM_CC_PolicyPCR                = 0x0000017F,
    TPM_CC_PolicyRestart            = 0x00000180,
    TPM_CC_ReadClock                = 0x00000181,
    TPM_CC_PCR_Extend               = 0x00000182,
    TPM_CC_PCR_SetAuthValue         = 0x00000183,
    TPM_CC_NV_Certify               = 0x00000184,
    TPM_CC_EventSequenceComplete    = 0x00000185,
    TPM_CC_HashSequenceStart        = 0x00000186,
    TPM_CC_PolicyPhysicalPresence   = 0x00000187,
    TPM_CC_PolicyDuplicationSelect  = 0x00000188,
    TPM_CC_PolicyGetDigest          = 0x00000189,
    TPM_CC_TestParms                = 0x0000018A,
    TPM_CC_Commit                   = 0x0000018B,
    TPM_CC_PolicyPassword           = 0x0000018C,
    TPM_CC_ZGen_2Phase              = 0x0000018D,
    TPM_CC_EC_Ephemeral             = 0x0000018E,
    TPM_CC_PolicyNvWritten          = 0x0000018F,
    TPM_CC_PolicyTemplate           = 0x00000190,
    TPM_CC_CreateLoaded             = 0x00000191,
    TPM_CC_PolicyAuthorizeNV        = 0x00000192,
    TPM_CC_EncryptDecrypt2          = 0x00000193,
    TPM_CC_LAST                     = TPM_CC_EncryptDecrypt2,

    CC_VEND                         = 0x20000000,
    TPM_CC_Vendor_TCG_Test          = CC_VEND + 0x0000,
#if defined(WOLFTPM_ST33) || defined(WOLFTPM_AUTODETECT)
    TPM_CC_SetMode                  = CC_VEND + 0x0307,
    TPM_CC_SetCommandSet            = CC_VEND + 0x0309,
#endif
#ifdef WOLFTPM_ST33
    TPM_CC_RestoreEK                = CC_VEND + 0x030A,
    TPM_CC_SetCommandSetLock        = CC_VEND + 0x030B,
    TPM_CC_GPIO_Config              = CC_VEND + 0x030F,
#endif
#ifdef WOLFTPM_NUVOTON
    TPM_CC_NTC2_PreConfig           = CC_VEND + 0x0211,
    TPM_CC_NTC2_GetConfig           = CC_VEND + 0x0213,
#endif
} TPM_CC_T;
typedef UINT32 TPM_CC;

/* Response Codes */
typedef enum {
    TPM_RC_SUCCESS  = 0x000,
    TPM_RC_BAD_TAG  = 0x01E,

    RC_VER1 = 0x100,
    TPM_RC_INITIALIZE           = RC_VER1 + 0x000,
    TPM_RC_FAILURE              = RC_VER1 + 0x001,
    TPM_RC_SEQUENCE             = RC_VER1 + 0x003,
    TPM_RC_PRIVATE              = RC_VER1 + 0x00B,
    TPM_RC_HMAC                 = RC_VER1 + 0x019,
    TPM_RC_DISABLED             = RC_VER1 + 0x020,
    TPM_RC_EXCLUSIVE            = RC_VER1 + 0x021,
    TPM_RC_AUTH_TYPE            = RC_VER1 + 0x024,
    TPM_RC_AUTH_MISSING         = RC_VER1 + 0x025,
    TPM_RC_POLICY               = RC_VER1 + 0x026,
    TPM_RC_PCR                  = RC_VER1 + 0x027,
    TPM_RC_PCR_CHANGED          = RC_VER1 + 0x028,
    TPM_RC_UPGRADE              = RC_VER1 + 0x02D,
    TPM_RC_TOO_MANY_CONTEXTS    = RC_VER1 + 0x02E,
    TPM_RC_AUTH_UNAVAILABLE     = RC_VER1 + 0x02F,
    TPM_RC_REBOOT               = RC_VER1 + 0x030,
    TPM_RC_UNBALANCED           = RC_VER1 + 0x031,
    TPM_RC_COMMAND_SIZE         = RC_VER1 + 0x042,
    TPM_RC_COMMAND_CODE         = RC_VER1 + 0x043,
    TPM_RC_AUTHSIZE             = RC_VER1 + 0x044,
    TPM_RC_AUTH_CONTEXT         = RC_VER1 + 0x045,
    TPM_RC_NV_RANGE             = RC_VER1 + 0x046,
    TPM_RC_NV_SIZE              = RC_VER1 + 0x047,
    TPM_RC_NV_LOCKED            = RC_VER1 + 0x048,
    TPM_RC_NV_AUTHORIZATION     = RC_VER1 + 0x049,
    TPM_RC_NV_UNINITIALIZED     = RC_VER1 + 0x04A,
    TPM_RC_NV_SPACE             = RC_VER1 + 0x04B,
    TPM_RC_NV_DEFINED           = RC_VER1 + 0x04C,
    TPM_RC_BAD_CONTEXT          = RC_VER1 + 0x050,
    TPM_RC_CPHASH               = RC_VER1 + 0x051,
    TPM_RC_PARENT               = RC_VER1 + 0x052,
    TPM_RC_NEEDS_TEST           = RC_VER1 + 0x053,
    TPM_RC_NO_RESULT            = RC_VER1 + 0x054,
    TPM_RC_SENSITIVE            = RC_VER1 + 0x055,
    RC_MAX_FM0                  = RC_VER1 + 0x07F,

    RC_FMT1 = 0x080,
    TPM_RC_ASYMMETRIC       = RC_FMT1 + 0x001,
    TPM_RC_ATTRIBUTES       = RC_FMT1 + 0x002,
    TPM_RC_HASH             = RC_FMT1 + 0x003,
    TPM_RC_VALUE            = RC_FMT1 + 0x004,
    TPM_RC_HIERARCHY        = RC_FMT1 + 0x005,
    TPM_RC_KEY_SIZE         = RC_FMT1 + 0x007,
    TPM_RC_MGF              = RC_FMT1 + 0x008,
    TPM_RC_MODE             = RC_FMT1 + 0x009,
    TPM_RC_TYPE             = RC_FMT1 + 0x00A,
    TPM_RC_HANDLE           = RC_FMT1 + 0x00B,
    TPM_RC_KDF              = RC_FMT1 + 0x00C,
    TPM_RC_RANGE            = RC_FMT1 + 0x00D,
    TPM_RC_AUTH_FAIL        = RC_FMT1 + 0x00E,
    TPM_RC_NONCE            = RC_FMT1 + 0x00F,
    TPM_RC_PP               = RC_FMT1 + 0x010,
    TPM_RC_SCHEME           = RC_FMT1 + 0x012,
    TPM_RC_SIZE             = RC_FMT1 + 0x015,
    TPM_RC_SYMMETRIC        = RC_FMT1 + 0x016,
    TPM_RC_TAG              = RC_FMT1 + 0x017,
    TPM_RC_SELECTOR         = RC_FMT1 + 0x018,
    TPM_RC_INSUFFICIENT     = RC_FMT1 + 0x01A,
    TPM_RC_SIGNATURE        = RC_FMT1 + 0x01B,
    TPM_RC_KEY              = RC_FMT1 + 0x01C,
    TPM_RC_POLICY_FAIL      = RC_FMT1 + 0x01D,
    TPM_RC_INTEGRITY        = RC_FMT1 + 0x01F,
    TPM_RC_TICKET           = RC_FMT1 + 0x020,
    TPM_RC_RESERVED_BITS    = RC_FMT1 + 0x021,
    TPM_RC_BAD_AUTH         = RC_FMT1 + 0x022,
    TPM_RC_EXPIRED          = RC_FMT1 + 0x023,
    TPM_RC_POLICY_CC        = RC_FMT1 + 0x024,
    TPM_RC_BINDING          = RC_FMT1 + 0x025,
    TPM_RC_CURVE            = RC_FMT1 + 0x026,
    TPM_RC_ECC_POINT        = RC_FMT1 + 0x027,
    RC_MAX_FMT1             = RC_FMT1 + 0x03F,

    RC_WARN = 0x900,
    TPM_RC_CONTEXT_GAP      = RC_WARN + 0x001,
    TPM_RC_OBJECT_MEMORY    = RC_WARN + 0x002,
    TPM_RC_SESSION_MEMORY   = RC_WARN + 0x003,
    TPM_RC_MEMORY           = RC_WARN + 0x004,
    TPM_RC_SESSION_HANDLES  = RC_WARN + 0x005,
    TPM_RC_OBJECT_HANDLES   = RC_WARN + 0x006,
    TPM_RC_LOCALITY         = RC_WARN + 0x007,
    TPM_RC_YIELDED          = RC_WARN + 0x008,
    TPM_RC_CANCELED         = RC_WARN + 0x009,
    TPM_RC_TESTING          = RC_WARN + 0x00A,
    TPM_RC_REFERENCE_H0     = RC_WARN + 0x010,
    TPM_RC_REFERENCE_H1     = RC_WARN + 0x011,
    TPM_RC_REFERENCE_H2     = RC_WARN + 0x012,
    TPM_RC_REFERENCE_H3     = RC_WARN + 0x013,
    TPM_RC_REFERENCE_H4     = RC_WARN + 0x014,
    TPM_RC_REFERENCE_H5     = RC_WARN + 0x015,
    TPM_RC_REFERENCE_H6     = RC_WARN + 0x016,
    TPM_RC_REFERENCE_S0     = RC_WARN + 0x018,
    TPM_RC_REFERENCE_S1     = RC_WARN + 0x019,
    TPM_RC_REFERENCE_S2     = RC_WARN + 0x01A,
    TPM_RC_REFERENCE_S3     = RC_WARN + 0x01B,
    TPM_RC_REFERENCE_S4     = RC_WARN + 0x01C,
    TPM_RC_REFERENCE_S5     = RC_WARN + 0x01D,
    TPM_RC_REFERENCE_S6     = RC_WARN + 0x01E,
    TPM_RC_NV_RATE          = RC_WARN + 0x020,
    TPM_RC_LOCKOUT          = RC_WARN + 0x021,
    TPM_RC_RETRY            = RC_WARN + 0x022,
    TPM_RC_NV_UNAVAILABLE   = RC_WARN + 0x023,
    RC_MAX_WARN             = RC_WARN + 0x03F,

    TPM_RC_NOT_USED         = RC_WARN + 0x07F,

    TPM_RC_H        = 0x000,
    TPM_RC_P        = 0x040,
    TPM_RC_S        = 0x800,
    TPM_RC_1        = 0x100,
    TPM_RC_2        = 0x200,
    TPM_RC_3        = 0x300,
    TPM_RC_4        = 0x400,
    TPM_RC_5        = 0x500,
    TPM_RC_6        = 0x600,
    TPM_RC_7        = 0x700,
    TPM_RC_8        = 0x800,
    TPM_RC_9        = 0x900,
    TPM_RC_A        = 0xA00,
    TPM_RC_B        = 0xB00,
    TPM_RC_C        = 0xC00,
    TPM_RC_D        = 0xD00,
    TPM_RC_E        = 0xE00,
    TPM_RC_F        = 0xF00,
    TPM_RC_N_MASK   = 0xF00,

    /* use negative codes for internal errors */
    TPM_RC_TIMEOUT = -100,
} TPM_RC_T;
typedef INT32 TPM_RC; /* type is unsigned 16-bits, but internally use signed 32-bit */

typedef enum {
    TPM_CLOCK_COARSE_SLOWER = -3,
    TPM_CLOCK_MEDIUM_SLOWER = -2,
    TPM_CLOCK_FINE_SLOWER   = -1,
    TPM_CLOCK_NO_CHANGE     = 0,
    TPM_CLOCK_FINE_FASTER   = 1,
    TPM_CLOCK_MEDIUM_FASTER = 2,
    TPM_CLOCK_COARSE_FASTER = 3,
} TPM_CLOCK_ADJUST_T;
typedef UINT8 TPM_CLOCK_ADJUST;

/* EA Arithmetic Operands */
typedef enum {
    TPM_EO_EQ           = 0x0000,
    TPM_EO_NEQ          = 0x0001,
    TPM_EO_SIGNED_GT    = 0x0002,
    TPM_EO_UNSIGNED_GT  = 0x0003,
    TPM_EO_SIGNED_LT    = 0x0004,
    TPM_EO_UNSIGNED_LT  = 0x0005,
    TPM_EO_SIGNED_GE    = 0x0006,
    TPM_EO_UNSIGNED_GE  = 0x0007,
    TPM_EO_SIGNED_LE    = 0x0008,
    TPM_EO_UNSIGNED_LE  = 0x0009,
    TPM_EO_BITSET       = 0x000A,
    TPM_EO_BITCLEAR     = 0x000B,
} TPM_EO_T;
typedef UINT16 TPM_EO;

/* Structure Tags */
typedef enum {
    TPM_ST_RSP_COMMAND          = 0x00C4,
    TPM_ST_NULL                 = 0X8000,
    TPM_ST_NO_SESSIONS          = 0x8001,
    TPM_ST_SESSIONS             = 0x8002,
    TPM_ST_ATTEST_NV            = 0x8014,
    TPM_ST_ATTEST_COMMAND_AUDIT = 0x8015,
    TPM_ST_ATTEST_SESSION_AUDIT = 0x8016,
    TPM_ST_ATTEST_CERTIFY       = 0x8017,
    TPM_ST_ATTEST_QUOTE         = 0x8018,
    TPM_ST_ATTEST_TIME          = 0x8019,
    TPM_ST_ATTEST_CREATION      = 0x801A,
    TPM_ST_CREATION             = 0x8021,
    TPM_ST_VERIFIED             = 0x8022,
    TPM_ST_AUTH_SECRET          = 0x8023,
    TPM_ST_HASHCHECK            = 0x8024,
    TPM_ST_AUTH_SIGNED          = 0x8025,
    TPM_ST_FU_MANIFEST          = 0x8029,
} TPM_ST_T;
typedef UINT16 TPM_ST;

/* Session Type */
typedef enum {
    TPM_SE_HMAC     = 0x00,
    TPM_SE_POLICY   = 0x01,
    TPM_SE_TRIAL    = 0x03,
} TPM_SE_T;
typedef UINT8 TPM_SE;


/* Startup Type */
typedef enum {
    TPM_SU_CLEAR = 0x0000,
    TPM_SU_STATE = 0x0001,
} TPM_SU_T;
typedef UINT16 TPM_SU;

/* Capabilities */
typedef enum {
    TPM_CAP_FIRST           = 0x00000000,
    TPM_CAP_ALGS            = TPM_CAP_FIRST,
    TPM_CAP_HANDLES         = 0x00000001,
    TPM_CAP_COMMANDS        = 0x00000002,
    TPM_CAP_PP_COMMANDS     = 0x00000003,
    TPM_CAP_AUDIT_COMMANDS  = 0x00000004,
    TPM_CAP_PCRS            = 0x00000005,
    TPM_CAP_TPM_PROPERTIES  = 0x00000006,
    TPM_CAP_PCR_PROPERTIES  = 0x00000007,
    TPM_CAP_ECC_CURVES      = 0x00000008,
    TPM_CAP_LAST            = TPM_CAP_ECC_CURVES,

    TPM_CAP_VENDOR_PROPERTY = 0x00000100,
} TPM_CAP_T;
typedef UINT32 TPM_CAP;

/* Property Tag */
typedef enum {
    TPM_PT_NONE    = 0x00000000,
    PT_GROUP       = 0x00000100,

    PT_FIXED = PT_GROUP * 1,
    TPM_PT_FAMILY_INDICATOR     = PT_FIXED + 0,
    TPM_PT_LEVEL                = PT_FIXED + 1,
    TPM_PT_REVISION             = PT_FIXED + 2,
    TPM_PT_DAY_OF_YEAR          = PT_FIXED + 3,
    TPM_PT_YEAR                 = PT_FIXED + 4,
    TPM_PT_MANUFACTURER         = PT_FIXED + 5,
    TPM_PT_VENDOR_STRING_1      = PT_FIXED + 6,
    TPM_PT_VENDOR_STRING_2      = PT_FIXED + 7,
    TPM_PT_VENDOR_STRING_3      = PT_FIXED + 8,
    TPM_PT_VENDOR_STRING_4      = PT_FIXED + 9,
    TPM_PT_VENDOR_TPM_TYPE      = PT_FIXED + 10,
    TPM_PT_FIRMWARE_VERSION_1   = PT_FIXED + 11,
    TPM_PT_FIRMWARE_VERSION_2   = PT_FIXED + 12,
    TPM_PT_INPUT_BUFFER         = PT_FIXED + 13,
    TPM_PT_HR_TRANSIENT_MIN     = PT_FIXED + 14,
    TPM_PT_HR_PERSISTENT_MIN    = PT_FIXED + 15,
    TPM_PT_HR_LOADED_MIN        = PT_FIXED + 16,
    TPM_PT_ACTIVE_SESSIONS_MAX  = PT_FIXED + 17,
    TPM_PT_PCR_COUNT            = PT_FIXED + 18,
    TPM_PT_PCR_SELECT_MIN       = PT_FIXED + 19,
    TPM_PT_CONTEXT_GAP_MAX      = PT_FIXED + 20,
    TPM_PT_NV_COUNTERS_MAX      = PT_FIXED + 22,
    TPM_PT_NV_INDEX_MAX         = PT_FIXED + 23,
    TPM_PT_MEMORY               = PT_FIXED + 24,
    TPM_PT_CLOCK_UPDATE         = PT_FIXED + 25,
    TPM_PT_CONTEXT_HASH         = PT_FIXED + 26,
    TPM_PT_CONTEXT_SYM          = PT_FIXED + 27,
    TPM_PT_CONTEXT_SYM_SIZE     = PT_FIXED + 28,
    TPM_PT_ORDERLY_COUNT        = PT_FIXED + 29,
    TPM_PT_MAX_COMMAND_SIZE     = PT_FIXED + 30,
    TPM_PT_MAX_RESPONSE_SIZE    = PT_FIXED + 31,
    TPM_PT_MAX_DIGEST           = PT_FIXED + 32,
    TPM_PT_MAX_OBJECT_CONTEXT   = PT_FIXED + 33,
    TPM_PT_MAX_SESSION_CONTEXT  = PT_FIXED + 34,
    TPM_PT_PS_FAMILY_INDICATOR  = PT_FIXED + 35,
    TPM_PT_PS_LEVEL             = PT_FIXED + 36,
    TPM_PT_PS_REVISION          = PT_FIXED + 37,
    TPM_PT_PS_DAY_OF_YEAR       = PT_FIXED + 38,
    TPM_PT_PS_YEAR              = PT_FIXED + 39,
    TPM_PT_SPLIT_MAX            = PT_FIXED + 40,
    TPM_PT_TOTAL_COMMANDS       = PT_FIXED + 41,
    TPM_PT_LIBRARY_COMMANDS     = PT_FIXED + 42,
    TPM_PT_VENDOR_COMMANDS      = PT_FIXED + 43,
    TPM_PT_NV_BUFFER_MAX        = PT_FIXED + 44,
    TPM_PT_MODES                = PT_FIXED + 45,
    TPM_PT_MAX_CAP_BUFFER       = PT_FIXED + 46,

    PT_VAR = PT_GROUP * 2,
    TPM_PT_PERMANENT            = PT_VAR + 0,
    TPM_PT_STARTUP_CLEAR        = PT_VAR + 1,
    TPM_PT_HR_NV_INDEX          = PT_VAR + 2,
    TPM_PT_HR_LOADED            = PT_VAR + 3,
    TPM_PT_HR_LOADED_AVAIL      = PT_VAR + 4,
    TPM_PT_HR_ACTIVE            = PT_VAR + 5,
    TPM_PT_HR_ACTIVE_AVAIL      = PT_VAR + 6,
    TPM_PT_HR_TRANSIENT_AVAIL   = PT_VAR + 7,
    TPM_PT_HR_PERSISTENT        = PT_VAR + 8,
    TPM_PT_HR_PERSISTENT_AVAIL  = PT_VAR + 9,
    TPM_PT_NV_COUNTERS          = PT_VAR + 10,
    TPM_PT_NV_COUNTERS_AVAIL    = PT_VAR + 11,
    TPM_PT_ALGORITHM_SET        = PT_VAR + 12,
    TPM_PT_LOADED_CURVES        = PT_VAR + 13,
    TPM_PT_LOCKOUT_COUNTER      = PT_VAR + 14,
    TPM_PT_MAX_AUTH_FAIL        = PT_VAR + 15,
    TPM_PT_LOCKOUT_INTERVAL     = PT_VAR + 16,
    TPM_PT_LOCKOUT_RECOVERY     = PT_VAR + 17,
    TPM_PT_NV_WRITE_RECOVERY    = PT_VAR + 18,
    TPM_PT_AUDIT_COUNTER_0      = PT_VAR + 19,
    TPM_PT_AUDIT_COUNTER_1      = PT_VAR + 20,
} TPM_PT_T;
typedef UINT32 TPM_PT;

/* PCR Property Tag */
typedef enum {
    TPM_PT_PCR_FIRST        = 0x00000000,
    TPM_PT_PCR_SAVE         = TPM_PT_PCR_FIRST,
    TPM_PT_PCR_EXTEND_L0    = 0x00000001,
    TPM_PT_PCR_RESET_L0     = 0x00000002,
    TPM_PT_PCR_EXTEND_L1    = 0x00000003,
    TPM_PT_PCR_RESET_L1     = 0x00000004,
    TPM_PT_PCR_EXTEND_L2    = 0x00000005,
    TPM_PT_PCR_RESET_L2     = 0x00000006,
    TPM_PT_PCR_EXTEND_L3    = 0x00000007,
    TPM_PT_PCR_RESET_L3     = 0x00000008,
    TPM_PT_PCR_EXTEND_L4    = 0x00000009,
    TPM_PT_PCR_RESET_L4     = 0x0000000A,
    TPM_PT_PCR_NO_INCREMENT = 0x00000011,
    TPM_PT_PCR_DRTM_RESET   = 0x00000012,
    TPM_PT_PCR_POLICY       = 0x00000013,
    TPM_PT_PCR_AUTH         = 0x00000014,
    TPM_PT_PCR_LAST         = TPM_PT_PCR_AUTH,
} TPM_PT_PCR_T;
typedef UINT32 TPM_PT_PCR;

/* Platform Specific */
typedef enum {
    TPM_PS_MAIN             = 0x00000000,
    TPM_PS_PC               = 0x00000001,
    TPM_PS_PDA              = 0x00000002,
    TPM_PS_CELL_PHONE       = 0x00000003,
    TPM_PS_SERVER           = 0x00000004,
    TPM_PS_PERIPHERAL       = 0x00000005,
    TPM_PS_TSS              = 0x00000006,
    TPM_PS_STORAGE          = 0x00000007,
    TPM_PS_AUTHENTICATION   = 0x00000008,
    TPM_PS_EMBEDDED         = 0x00000009,
    TPM_PS_HARDCOPY         = 0x0000000A,
    TPM_PS_INFRASTRUCTURE   = 0x0000000B,
    TPM_PS_VIRTUALIZATION   = 0x0000000C,
    TPM_PS_TNC              = 0x0000000D,
    TPM_PS_MULTI_TENANT     = 0x0000000E,
    TPM_PS_TC               = 0x0000000F,
} TPM_PS_T;
typedef UINT32 TPM_PS;


/* HANDLES */
typedef UINT32 TPM_HANDLE;

/* Handle Types */
typedef enum {
    TPM_HT_PCR              = 0x00,
    TPM_HT_NV_INDEX         = 0x01,
    TPM_HT_HMAC_SESSION     = 0x02,
    TPM_HT_LOADED_SESSION   = 0x02,
    TPM_HT_POLICY_SESSION   = 0x03,
    TPM_HT_ACTIVE_SESSION   = 0x03,
    TPM_HT_PERMANENT        = 0x40,
    TPM_HT_TRANSIENT        = 0x80,
    TPM_HT_PERSISTENT       = 0x81,
} TPM_HT_T;
typedef UINT8 TPM_HT;

/* Permanent Handles */
typedef enum {
    TPM_RH_FIRST        = 0x40000000,
    TPM_RH_SRK          = TPM_RH_FIRST,
    TPM_RH_OWNER        = 0x40000001,
    TPM_RH_REVOKE       = 0x40000002,
    TPM_RH_TRANSPORT    = 0x40000003,
    TPM_RH_OPERATOR     = 0x40000004,
    TPM_RH_ADMIN        = 0x40000005,
    TPM_RH_EK           = 0x40000006,
    TPM_RH_NULL         = 0x40000007,
    TPM_RH_UNASSIGNED   = 0x40000008,
    TPM_RS_PW           = 0x40000009,
    TPM_RH_LOCKOUT      = 0x4000000A,
    TPM_RH_ENDORSEMENT  = 0x4000000B,
    TPM_RH_PLATFORM     = 0x4000000C,
    TPM_RH_PLATFORM_NV  = 0x4000000D,
    TPM_RH_AUTH_00      = 0x40000010,
    TPM_RH_AUTH_FF      = 0x4000010F,
    TPM_RH_LAST         = TPM_RH_AUTH_FF,
} TPM_RH_T;
typedef UINT32 TPM_RH;

/* Handle Value Constants */
typedef enum {
    HR_HANDLE_MASK          = 0x00FFFFFF,
    HR_RANGE_MASK           = 0xFF000000,
    HR_SHIFT                = 24,
    HR_PCR                  = ((UINT32)TPM_HT_PCR << HR_SHIFT),
    HR_HMAC_SESSION         = ((UINT32)TPM_HT_HMAC_SESSION << HR_SHIFT),
    HR_POLICY_SESSION       = ((UINT32)TPM_HT_POLICY_SESSION << HR_SHIFT),
    HR_TRANSIENT            = ((UINT32)TPM_HT_TRANSIENT << HR_SHIFT),
    HR_PERSISTENT           = ((UINT32)TPM_HT_PERSISTENT << HR_SHIFT),
    HR_NV_INDEX             = ((UINT32)TPM_HT_NV_INDEX << HR_SHIFT),
    HR_PERMANENT            = ((UINT32)TPM_HT_PERMANENT << HR_SHIFT),
    PCR_FIRST               = (HR_PCR + 0),
    PCR_LAST                = (PCR_FIRST + IMPLEMENTATION_PCR-1),
    HMAC_SESSION_FIRST      = (HR_HMAC_SESSION + 0),
    HMAC_SESSION_LAST       = (HMAC_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1),
    LOADED_SESSION_FIRST    = HMAC_SESSION_FIRST,
    LOADED_SESSION_LAST     = HMAC_SESSION_LAST,
    POLICY_SESSION_FIRST    = (HR_POLICY_SESSION + 0),
    POLICY_SESSION_LAST     = (POLICY_SESSION_FIRST+MAX_ACTIVE_SESSIONS-1),
    TRANSIENT_FIRST         = (HR_TRANSIENT + 0),
    ACTIVE_SESSION_FIRST    = POLICY_SESSION_FIRST,
    ACTIVE_SESSION_LAST     = POLICY_SESSION_LAST,
    TRANSIENT_LAST          = (TRANSIENT_FIRST+MAX_LOADED_OBJECTS-1),
    PERSISTENT_FIRST        = (HR_PERSISTENT + 0),
    PERSISTENT_LAST         = (PERSISTENT_FIRST + 0x00FFFFFF),
    PLATFORM_PERSISTENT     = (PERSISTENT_FIRST + 0x00800000),
    NV_INDEX_FIRST          = (HR_NV_INDEX + 0),
    NV_INDEX_LAST           = (NV_INDEX_FIRST + 0x00FFFFFF),
    PERMANENT_FIRST         = TPM_RH_FIRST,
    PERMANENT_LAST          = TPM_RH_LAST,
} TPM_HC_T;
typedef UINT32 TPM_HC;


/* Attributes */
typedef UINT32 TPMA_ALGORITHM;
enum TPMA_ALGORITHM_mask {
    TPMA_ALGORITHM_asymmetric = 0x00000001,
    TPMA_ALGORITHM_symmetric  = 0x00000002,
    TPMA_ALGORITHM_hash       = 0x00000004,
    TPMA_ALGORITHM_object     = 0x00000008,
    TPMA_ALGORITHM_signing    = 0x00000010,
    TPMA_ALGORITHM_encrypting = 0x00000020,
    TPMA_ALGORITHM_method     = 0x00000040,
};

typedef UINT32 TPMA_OBJECT;
enum TPMA_OBJECT_mask {
    TPMA_OBJECT_fixedTPM            = 0x00000002,
    TPMA_OBJECT_stClear             = 0x00000004,
    TPMA_OBJECT_fixedParent         = 0x00000010,
    TPMA_OBJECT_sensitiveDataOrigin = 0x00000020,
    TPMA_OBJECT_userWithAuth        = 0x00000040,
    TPMA_OBJECT_adminWithPolicy     = 0x00000080,
    TPMA_OBJECT_derivedDataOrigin   = 0x00000200,
    TPMA_OBJECT_noDA                = 0x00000400,
    TPMA_OBJECT_encryptedDuplication= 0x00000800,
    TPMA_OBJECT_restricted          = 0x00010000,
    TPMA_OBJECT_decrypt             = 0x00020000,
    TPMA_OBJECT_sign                = 0x00040000,
};

typedef BYTE TPMA_SESSION;
enum TPMA_SESSION_mask {
    TPMA_SESSION_continueSession    = 0x01,
    TPMA_SESSION_auditExclusive     = 0x02,
    TPMA_SESSION_auditReset         = 0x04,
    TPMA_SESSION_decrypt            = 0x20,
    TPMA_SESSION_encrypt            = 0x40,
    TPMA_SESSION_audit              = 0x80,
};

typedef BYTE TPMA_LOCALITY;
enum TPMA_LOCALITY_mask {
    TPM_LOC_ZERO = 0x01,
    TPM_LOC_ONE = 0x02,
    TPM_LOC_TWO = 0x04,
    TPM_LOC_THREE = 0x08,
    TPM_LOC_FOUR = 0x10,
};

typedef UINT32 TPMA_PERMANENT;
enum TPMA_PERMANENT_mask {
    TPMA_PERMANENT_ownerAuthSet         = 0x00000001,
    TPMA_PERMANENT_endorsementAuthSet   = 0x00000002,
    TPMA_PERMANENT_lockoutAuthSet       = 0x00000004,
    TPMA_PERMANENT_disableClear         = 0x00000100,
    TPMA_PERMANENT_inLockout            = 0x00000200,
    TPMA_PERMANENT_tpmGeneratedEPS      = 0x00000400,
};

typedef UINT32 TPMA_STARTUP_CLEAR;
enum TPMA_STARTUP_CLEAR_mask {
    TPMA_STARTUP_CLEAR_phEnable     = 0x00000001,
    TPMA_STARTUP_CLEAR_shEnable     = 0x00000002,
    TPMA_STARTUP_CLEAR_ehEnable     = 0x00000004,
    TPMA_STARTUP_CLEAR_phEnableNV   = 0x00000008,
    TPMA_STARTUP_CLEAR_orderly      = 0x80000000,
};

typedef UINT32 TPMA_MEMORY;
enum TPMA_MEMORY_mask {
    TPMA_MEMORY_sharedRAM           = 0x00000001,
    TPMA_MEMORY_sharedNV            = 0x00000002,
    TPMA_MEMORY_objectCopiedToRam   = 0x00000004,
};

typedef UINT32 TPMA_CC;
enum TPMA_CC_mask {
    TPMA_CC_commandIndex = 0x0000FFFF,
    TPMA_CC_nv           = 0x00400000,
    TPMA_CC_extensive    = 0x00800000,
    TPMA_CC_flushed      = 0x01000000,
    TPMA_CC_cHandles     = 0x0E000000,
    TPMA_CC_rHandle      = 0x10000000,
    TPMA_CC_V            = 0x20000000,
};



/* Interface Types */

typedef BYTE TPMI_YES_NO;
typedef TPM_HANDLE TPMI_DH_OBJECT;
typedef TPM_HANDLE TPMI_DH_PARENT;
typedef TPM_HANDLE TPMI_DH_PERSISTENT;
typedef TPM_HANDLE TPMI_DH_ENTITY;
typedef TPM_HANDLE TPMI_DH_PCR;
typedef TPM_HANDLE TPMI_SH_AUTH_SESSION;
typedef TPM_HANDLE TPMI_SH_HMAC;
typedef TPM_HANDLE TPMI_SH_POLICY;
typedef TPM_HANDLE TPMI_DH_CONTEXT;
typedef TPM_HANDLE TPMI_RH_HIERARCHY;
typedef TPM_HANDLE TPMI_RH_ENABLES;
typedef TPM_HANDLE TPMI_RH_HIERARCHY_AUTH;
typedef TPM_HANDLE TPMI_RH_PLATFORM;
typedef TPM_HANDLE TPMI_RH_OWNER;
typedef TPM_HANDLE TPMI_RH_ENDORSEMENT;
typedef TPM_HANDLE TPMI_RH_PROVISION;
typedef TPM_HANDLE TPMI_RH_CLEAR;
typedef TPM_HANDLE TPMI_RH_NV_AUTH;
typedef TPM_HANDLE TPMI_RH_LOCKOUT;
typedef TPM_HANDLE TPMI_RH_NV_INDEX;

typedef TPM_ALG_ID TPMI_ALG_HASH;
typedef TPM_ALG_ID TPMI_ALG_ASYM;
typedef TPM_ALG_ID TPMI_ALG_SYM;
typedef TPM_ALG_ID TPMI_ALG_SYM_OBJECT;
typedef TPM_ALG_ID TPMI_ALG_SYM_MODE;
typedef TPM_ALG_ID TPMI_ALG_KDF;
typedef TPM_ALG_ID TPMI_ALG_SIG_SCHEME;
typedef TPM_ALG_ID TPMI_ECC_KEY_EXCHANGE;

typedef TPM_ST TPMI_ST_COMMAND_TAG;


/* Structures */

typedef struct TPMS_ALGORITHM_DESCRIPTION {
    TPM_ALG_ID alg;
    TPMA_ALGORITHM attributes;
} TPMS_ALGORITHM_DESCRIPTION;


typedef union TPMU_HA {
    BYTE sha512[TPM_SHA512_DIGEST_SIZE];
    BYTE sha384[TPM_SHA384_DIGEST_SIZE];
    BYTE sha256[TPM_SHA256_DIGEST_SIZE];
    BYTE sha224[TPM_SHA224_DIGEST_SIZE];
    BYTE sha[TPM_SHA_DIGEST_SIZE];
    BYTE md5[TPM_MD5_DIGEST_SIZE];
    BYTE H[TPM_MAX_DIGEST_SIZE];
} TPMU_HA;

typedef struct TPMT_HA {
    TPMI_ALG_HASH hashAlg;
    TPMU_HA digest;
} TPMT_HA;

typedef struct TPM2B_DIGEST {
    UINT16 size;
    BYTE buffer[sizeof(TPMU_HA)];
} TPM2B_DIGEST;

typedef struct TPM2B_DATA {
    UINT16 size;
    BYTE buffer[sizeof(TPMT_HA)];
} TPM2B_DATA;

typedef TPM2B_DIGEST TPM2B_NONCE;
typedef TPM2B_DIGEST TPM2B_AUTH;
typedef TPM2B_DIGEST TPM2B_OPERAND;

typedef struct TPM2B_EVENT {
    UINT16 size;
    BYTE buffer[1024];
} TPM2B_EVENT;

typedef struct TPM2B_MAX_BUFFER {
    UINT16 size;
    BYTE buffer[MAX_DIGEST_BUFFER];
} TPM2B_MAX_BUFFER;

typedef struct TPM2B_MAX_NV_BUFFER {
    UINT16 size;
    BYTE buffer[MAX_NV_BUFFER_SIZE];
} TPM2B_MAX_NV_BUFFER;


typedef TPM2B_DIGEST TPM2B_TIMEOUT;

typedef struct TPM2B_IV {
    UINT16 size;
    BYTE buffer[MAX_SYM_BLOCK_SIZE];
} TPM2B_IV;


/* Names */
typedef union TPMU_NAME {
    TPMT_HA digest;
    TPM_HANDLE handle;
} TPMU_NAME;

typedef struct TPM2B_NAME {
    UINT16 size;
    BYTE name[sizeof(TPMU_NAME)];
} TPM2B_NAME;


/* PCR */

typedef struct TPMS_PCR_SELECT {
    BYTE sizeofSelect;
    BYTE pcrSelect[PCR_SELECT_MIN];
} TPMS_PCR_SELECT;


typedef struct TPMS_PCR_SELECTION {
    TPMI_ALG_HASH hash;
    BYTE sizeofSelect;
    BYTE pcrSelect[PCR_SELECT_MIN];
} TPMS_PCR_SELECTION;


/* Tickets */

typedef struct TPMT_TK_CREATION {
    TPM_ST tag;
    TPMI_RH_HIERARCHY hierarchy;
    TPM2B_DIGEST digest;
} TPMT_TK_CREATION;

typedef struct TPMT_TK_VERIFIED {
    TPM_ST tag;
    TPMI_RH_HIERARCHY hierarchy;
    TPM2B_DIGEST digest;
} TPMT_TK_VERIFIED;

typedef struct TPMT_TK_AUTH {
    TPM_ST tag;
    TPMI_RH_HIERARCHY hierarchy;
    TPM2B_DIGEST digest;
} TPMT_TK_AUTH;

typedef struct TPMT_TK_HASHCHECK {
    TPM_ST tag;
    TPMI_RH_HIERARCHY hierarchy;
    TPM2B_DIGEST digest;
} TPMT_TK_HASHCHECK;

typedef struct TPMS_ALG_PROPERTY {
    TPM_ALG_ID alg;
    TPMA_ALGORITHM algProperties;
} TPMS_ALG_PROPERTY;

typedef struct TPMS_TAGGED_PROPERTY {
    TPM_PT property;
    UINT32 value;
} TPMS_TAGGED_PROPERTY;

typedef struct TPMS_TAGGED_PCR_SELECT {
    TPM_PT_PCR tag;
    BYTE sizeofSelect;
    BYTE pcrSelect[PCR_SELECT_MAX];
} TPMS_TAGGED_PCR_SELECT;

typedef struct TPMS_TAGGED_POLICY {
    TPM_HANDLE handle;
    TPMT_HA policyHash;
} TPMS_TAGGED_POLICY;


/* Lists */

typedef struct TPML_CC {
    UINT32 count;
    TPM_CC commandCodes[MAX_CAP_CC];
} TPML_CC;

typedef struct TPML_CCA {
    UINT32 count;
    TPMA_CC commandAttributes[MAX_CAP_CC];
} TPML_CCA;

typedef struct TPML_ALG {
    UINT32 count;
    TPM_ALG_ID algorithms[MAX_ALG_LIST_SIZE];
} TPML_ALG;

typedef struct TPML_HANDLE {
    UINT32 count;
    TPM_HANDLE handle[MAX_CAP_HANDLES];
} TPML_HANDLE;

typedef struct TPML_DIGEST {
    UINT32 count;
    TPM2B_DIGEST digests[8];
} TPML_DIGEST;

typedef struct TPML_DIGEST_VALUES {
    UINT32 count;
    TPMT_HA digests[HASH_COUNT];
} TPML_DIGEST_VALUES;

typedef struct TPML_PCR_SELECTION {
    UINT32 count;
    TPMS_PCR_SELECTION pcrSelections[HASH_COUNT];
} TPML_PCR_SELECTION;

typedef struct TPML_ALG_PROPERTY {
    UINT32 count;
    TPMS_ALG_PROPERTY algProperties[MAX_CAP_ALGS];
} TPML_ALG_PROPERTY;

typedef struct TPML_TAGGED_TPM_PROPERTY {
    UINT32 count;
    TPMS_TAGGED_PROPERTY tpmProperty[MAX_TPM_PROPERTIES];
} TPML_TAGGED_TPM_PROPERTY;

typedef struct TPML_TAGGED_PCR_PROPERTY {
    UINT32 count;
    TPMS_TAGGED_PCR_SELECT pcrProperty[MAX_PCR_PROPERTIES];
} TPML_TAGGED_PCR_PROPERTY;

typedef struct TPML_ECC_CURVE {
    UINT32 count;
    TPM_ECC_CURVE eccCurves[MAX_ECC_CURVES];
} TPML_ECC_CURVE;

typedef struct TPML_TAGGED_POLICY {
    UINT32 count;
    TPMS_TAGGED_POLICY policies[MAX_TAGGED_POLICIES];
} TPML_TAGGED_POLICY;


/* Capabilities Structures */

typedef union TPMU_CAPABILITIES {
    TPML_ALG_PROPERTY algorithms; /* TPM_CAP_ALGS */
    TPML_HANDLE handles; /* TPM_CAP_HANDLES */
    TPML_CCA command; /* TPM_CAP_COMMANDS */
    TPML_CC ppCommands; /* TPM_CAP_PP_COMMANDS */
    TPML_CC auditCommands; /* TPM_CAP_AUDIT_COMMANDS */
    TPML_PCR_SELECTION assignedPCR; /* TPM_CAP_PCRS */
    TPML_TAGGED_TPM_PROPERTY tpmProperties; /* TPM_CAP_TPM_PROPERTIES */
    TPML_TAGGED_PCR_PROPERTY pcrProperties; /* TPM_CAP_PCR_PROPERTIES */
    TPML_ECC_CURVE eccCurves; /* TPM_CAP_ECC_CURVES */
    TPML_TAGGED_POLICY authPolicies; /* TPM_CAP_AUTH_POLICIES */
} TPMU_CAPABILITIES;

typedef struct TPMS_CAPABILITY_DATA {
    TPM_CAP capability;
    TPMU_CAPABILITIES data;
} TPMS_CAPABILITY_DATA;

typedef struct TPMS_CLOCK_INFO {
    UINT64 clock;
    UINT32 resetCount;
    UINT32 restartCount;
    TPMI_YES_NO safe;
} TPMS_CLOCK_INFO;

typedef struct TPMS_TIME_INFO {
    UINT64 time;
    TPMS_CLOCK_INFO clockInfo;
} TPMS_TIME_INFO;

typedef struct TPMS_TIME_ATTEST_INFO {
    TPMS_TIME_INFO time;
    UINT64 firmwareVersion;
} TPMS_TIME_ATTEST_INFO;

typedef struct TPMS_CERTIFY_INFO {
    TPM2B_NAME name;
    TPM2B_NAME qualifiedName;
} TPMS_CERTIFY_INFO;

typedef struct TPMS_QUOTE_INFO {
    TPML_PCR_SELECTION pcrSelect;
    TPM2B_DIGEST pcrDigest;
} TPMS_QUOTE_INFO;

typedef struct TPMS_COMMAND_AUDIT_INFO {
    UINT64 auditCounter;
    TPM_ALG_ID digestAlg;
    TPM2B_DIGEST auditDigest;
    TPM2B_DIGEST commandDigest;
} TPMS_COMMAND_AUDIT_INFO;

typedef struct TPMS_SESSION_AUDIT_INFO {
    TPMI_YES_NO exclusiveSession;
    TPM2B_DIGEST sessionDigest;
} TPMS_SESSION_AUDIT_INFO;

typedef struct TPMS_CREATION_INFO {
    TPM2B_NAME objectName;
    TPM2B_DIGEST creationHash;
} TPMS_CREATION_INFO;

typedef struct TPMS_NV_CERTIFY_INFO {
    TPM2B_NAME indexName;
    UINT16 offset;
    TPM2B_MAX_NV_BUFFER nvContents;
} TPMS_NV_CERTIFY_INFO;


typedef TPM_ST TPMI_ST_ATTEST;
typedef union TPMU_ATTEST {
    TPMS_CERTIFY_INFO       certify;        /* TPM_ST_ATTEST_CERTIFY */
    TPMS_CREATION_INFO      creation;       /* TPM_ST_ATTEST_CREATION */
    TPMS_QUOTE_INFO         quote;          /* TPM_ST_ATTEST_QUOTE */
    TPMS_COMMAND_AUDIT_INFO commandAudit;   /* TPM_ST_ATTEST_COMMAND_AUDIT */
    TPMS_SESSION_AUDIT_INFO sessionAudit;   /* TPM_ST_ATTEST_SESSION_AUDIT */
    TPMS_TIME_ATTEST_INFO   time;           /* TPM_ST_ATTEST_TIME */
    TPMS_NV_CERTIFY_INFO    nv;             /* TPM_ST_ATTEST_NV */
} TPMU_ATTEST;

typedef struct TPMS_ATTEST {
    TPM_GENERATED magic;
    TPMI_ST_ATTEST type;
    TPM2B_NAME qualifiedSigner;
    TPM2B_DATA extraData;
    TPMS_CLOCK_INFO clockInfo;
    UINT64 firmwareVersion;
    TPMU_ATTEST attested;
} TPMS_ATTEST;

typedef struct TPM2B_ATTEST {
    UINT16 size;
    BYTE attestationData[sizeof(TPMS_ATTEST)];
} TPM2B_ATTEST;


/* Algorithm Parameters and Structures */

/* Symmetric */
typedef TPM_KEY_BITS TPMI_AES_KEY_BITS;

typedef union TPMU_SYM_KEY_BITS {
    TPMI_AES_KEY_BITS aes;
    TPM_KEY_BITS sym;
    TPMI_ALG_HASH xorr;
} TPMU_SYM_KEY_BITS;

typedef union TPMU_SYM_MODE {
    TPMI_ALG_SYM_MODE aes;
    TPMI_ALG_SYM_MODE sym;
} TPMU_SYM_MODE;

typedef struct TPMT_SYM_DEF {
    TPMI_ALG_SYM algorithm;
    TPMU_SYM_KEY_BITS keyBits;
    TPMU_SYM_MODE mode;
    //TPMU_SYM_DETAILS details;
} TPMT_SYM_DEF;

typedef TPMT_SYM_DEF TPMT_SYM_DEF_OBJECT;

typedef struct TPM2B_SYM_KEY {
    UINT16 size;
    BYTE buffer[MAX_SYM_KEY_BYTES];
} TPM2B_SYM_KEY;

typedef struct TPMS_SYMCIPHER_PARMS {
    TPMT_SYM_DEF_OBJECT sym;
} TPMS_SYMCIPHER_PARMS;

typedef struct TPM2B_LABEL {
    UINT16 size;
    BYTE buffer[LABEL_MAX_BUFFER];
} TPM2B_LABEL;

typedef struct TPMS_DERIVE {
    TPM2B_LABEL label;
    TPM2B_LABEL context;
} TPMS_DERIVE;

typedef struct TPM2B_DERIVE {
    UINT16 size;
    BYTE buffer[sizeof(TPMS_DERIVE)];
} TPM2B_DERIVE;

typedef union TPMU_SENSITIVE_CREATE {
    BYTE create[MAX_SYM_DATA];
    TPMS_DERIVE derive;
} TPMU_SENSITIVE_CREATE;

typedef struct TPM2B_SENSITIVE_DATA {
    UINT16 size;
    BYTE buffer[sizeof(TPMU_SENSITIVE_CREATE)];
} TPM2B_SENSITIVE_DATA;

typedef struct TPMS_SENSITIVE_CREATE {
    TPM2B_AUTH userAuth;
    TPM2B_SENSITIVE_DATA data;
} TPMS_SENSITIVE_CREATE;

typedef struct TPM2B_SENSITIVE_CREATE {
    UINT16 size;
    TPMS_SENSITIVE_CREATE sensitive;
} TPM2B_SENSITIVE_CREATE;

typedef struct TPMS_SCHEME_HASH {
    TPMI_ALG_HASH hashAlg;
} TPMS_SCHEME_HASH;

typedef struct TPMS_SCHEME_ECDAA {
    TPMI_ALG_HASH hashAlg;
    UINT16 count;
} TPMS_SCHEME_ECDAA;

typedef TPM_ALG_ID TPMI_ALG_KEYEDHASH_SCHEME;
typedef TPMS_SCHEME_HASH TPMS_SCHEME_HMAC;

typedef union TPMU_SCHEME_KEYEDHASH {
    TPMS_SCHEME_HMAC hmac;
} TPMU_SCHEME_KEYEDHASH;

typedef struct TPMT_KEYEDHASH_SCHEME {
    TPMI_ALG_KEYEDHASH_SCHEME scheme;
    TPMU_SCHEME_KEYEDHASH details;
} TPMT_KEYEDHASH_SCHEME;


/* Asymmetric */

typedef TPMS_SCHEME_HASH  TPMS_SIG_SCHEME_RSASSA;
typedef TPMS_SCHEME_HASH  TPMS_SIG_SCHEME_RSAPSS;
typedef TPMS_SCHEME_HASH  TPMS_SIG_SCHEME_ECDSA;

typedef TPMS_SCHEME_ECDAA TPMS_SIG_SCHEME_ECDAA;


typedef union TPMU_SIG_SCHEME {
    TPMS_SIG_SCHEME_RSASSA rsassa;
    TPMS_SIG_SCHEME_RSAPSS rsapss;
    TPMS_SIG_SCHEME_ECDSA  ecdsa;
    TPMS_SIG_SCHEME_ECDAA  ecdaa;
    TPMS_SCHEME_HMAC       hmac;
    TPMS_SCHEME_HASH       any;
} TPMU_SIG_SCHEME;

typedef struct TPMT_SIG_SCHEME {
    TPMI_ALG_SIG_SCHEME scheme;
    TPMU_SIG_SCHEME details;
} TPMT_SIG_SCHEME;


/* Encryption / Key Exchange Schemes */
typedef TPMS_SCHEME_HASH TPMS_ENC_SCHEME_OAEP;
typedef TPMS_SCHEME_HASH TPMS_KEY_SCHEME_ECDH;
typedef TPMS_SCHEME_HASH TPMS_KEY_SCHEME_ECMQV;

/* Key Derivation Schemes */
typedef TPMS_SCHEME_HASH TPMS_SCHEME_MGF1;
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF1_SP800_56A;
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF2;
typedef TPMS_SCHEME_HASH TPMS_SCHEME_KDF1_SP800_108;

typedef union TPMU_KDF_SCHEME {
    TPMS_SCHEME_MGF1            mgf1;
    TPMS_SCHEME_KDF1_SP800_56A  kdf1_sp800_56a;
    TPMS_SCHEME_KDF2            kdf2;
    TPMS_SCHEME_KDF1_SP800_108  kdf1_sp800_108;
    TPMS_SCHEME_HASH            any;
} TPMU_KDF_SCHEME;

typedef struct TPMT_KDF_SCHEME {
    TPMI_ALG_KDF scheme;
    TPMU_KDF_SCHEME details;
} TPMT_KDF_SCHEME;

typedef TPM_ALG_ID TPMI_ALG_ASYM_SCHEME;
typedef union TPMU_ASYM_SCHEME {
    TPMS_KEY_SCHEME_ECDH    ecdh;
    TPMS_SIG_SCHEME_RSASSA  rsassa;
    TPMS_SIG_SCHEME_RSAPSS  rsapss;
    TPMS_SIG_SCHEME_ECDSA   ecdsa;
    TPMS_ENC_SCHEME_OAEP    oaep;
    TPMS_SCHEME_HASH        anySig;
} TPMU_ASYM_SCHEME;

typedef struct TPMT_ASYM_SCHEME {
    TPMI_ALG_ASYM_SCHEME scheme;
    TPMU_ASYM_SCHEME details;
} TPMT_ASYM_SCHEME;

/* RSA */
typedef TPM_ALG_ID TPMI_ALG_RSA_SCHEME;
typedef struct TPMT_RSA_SCHEME {
    TPMI_ALG_RSA_SCHEME scheme;
    TPMU_ASYM_SCHEME details;
} TPMT_RSA_SCHEME;

typedef TPM_ALG_ID TPMI_ALG_RSA_DECRYPT;
typedef struct TPMT_RSA_DECRYPT {
    TPMI_ALG_RSA_DECRYPT scheme;
    TPMU_ASYM_SCHEME details;
} TPMT_RSA_DECRYPT;

typedef struct TPM2B_PUBLIC_KEY_RSA {
    UINT16 size;
    BYTE buffer[MAX_RSA_KEY_BYTES];
} TPM2B_PUBLIC_KEY_RSA;

typedef TPM_KEY_BITS TPMI_RSA_KEY_BITS;
typedef struct TPM2B_PRIVATE_KEY_RSA {
    UINT16 size;
    BYTE buffer[MAX_RSA_KEY_BYTES/2];
} TPM2B_PRIVATE_KEY_RSA;


/* ECC */
typedef struct TPM2B_ECC_PARAMETER {
    UINT16 size;
    BYTE buffer[MAX_ECC_KEY_BYTES];
} TPM2B_ECC_PARAMETER;

typedef struct TPMS_ECC_POINT {
    TPM2B_ECC_PARAMETER x;
    TPM2B_ECC_PARAMETER y;
} TPMS_ECC_POINT;

typedef struct TPM2B_ECC_POINT {
    UINT16 size;
    TPMS_ECC_POINT point;
} TPM2B_ECC_POINT;


typedef TPM_ALG_ID TPMI_ALG_ECC_SCHEME;
typedef TPM_ECC_CURVE TPMI_ECC_CURVE;
typedef TPMT_SIG_SCHEME TPMT_ECC_SCHEME;

typedef struct TPMS_ALGORITHM_DETAIL_ECC {
    TPM_ECC_CURVE curveID;
    UINT16 keySize;
    TPMT_KDF_SCHEME kdf;
    TPMT_ECC_SCHEME sign;
    TPM2B_ECC_PARAMETER p;
    TPM2B_ECC_PARAMETER a;
    TPM2B_ECC_PARAMETER b;
    TPM2B_ECC_PARAMETER gX;
    TPM2B_ECC_PARAMETER gY;
    TPM2B_ECC_PARAMETER n;
    TPM2B_ECC_PARAMETER h;
} TPMS_ALGORITHM_DETAIL_ECC;


/* Signatures */

typedef struct TPMS_SIGNATURE_RSA {
    TPMI_ALG_HASH hash;
    TPM2B_PUBLIC_KEY_RSA sig;
} TPMS_SIGNATURE_RSA;

typedef TPMS_SIGNATURE_RSA TPMS_SIGNATURE_RSASSA;
typedef TPMS_SIGNATURE_RSA TPMS_SIGNATURE_RSAPSS;

typedef struct TPMS_SIGNATURE_ECC {
    TPMI_ALG_HASH hash;
    TPM2B_ECC_PARAMETER signatureR;
    TPM2B_ECC_PARAMETER signatureS;
} TPMS_SIGNATURE_ECC;

typedef TPMS_SIGNATURE_ECC TPMS_SIGNATURE_ECDSA;
typedef TPMS_SIGNATURE_ECC TPMS_SIGNATURE_ECDAA;

typedef union TPMU_SIGNATURE {
    TPMS_SIGNATURE_ECDSA ecdsa;
    TPMS_SIGNATURE_ECDAA ecdaa;
    TPMS_SIGNATURE_RSASSA rsassa;
    TPMS_SIGNATURE_RSAPSS rsapss;
    TPMT_HA hmac;
    TPMS_SCHEME_HASH any;
} TPMU_SIGNATURE;

typedef struct TPMT_SIGNATURE {
    TPMI_ALG_SIG_SCHEME sigAlg;
    TPMU_SIGNATURE signature;
} TPMT_SIGNATURE;


/* Key/Secret Exchange */

typedef union TPMU_ENCRYPTED_SECRET {
    BYTE ecc[sizeof(TPMS_ECC_POINT)];     /* TPM_ALG_ECC */
    BYTE rsa[MAX_RSA_KEY_BYTES];          /* TPM_ALG_RSA */
    BYTE symmetric[sizeof(TPM2B_DIGEST)]; /* TPM_ALG_SYMCIPHER */
    BYTE keyedHash[sizeof(TPM2B_DIGEST)]; /* TPM_ALG_KEYEDHASH */
} TPMU_ENCRYPTED_SECRET;

typedef struct TPM2B_ENCRYPTED_SECRET {
    UINT16 size;
    BYTE secret[sizeof(TPMU_ENCRYPTED_SECRET)];
} TPM2B_ENCRYPTED_SECRET;


/* Key/Object Complex */

typedef TPM_ALG_ID TPMI_ALG_PUBLIC;

typedef union TPMU_PUBLIC_ID {
    TPM2B_DIGEST keyedHash;   /* TPM_ALG_KEYEDHASH */
    TPM2B_DIGEST sym;         /* TPM_ALG_SYMCIPHER */
    TPM2B_PUBLIC_KEY_RSA rsa; /* TPM_ALG_RSA */
    TPMS_ECC_POINT ecc;       /* TPM_ALG_ECC */
    TPMS_DERIVE derive;
} TPMU_PUBLIC_ID;

typedef struct TPMS_KEYEDHASH_PARMS {
    TPMT_KEYEDHASH_SCHEME scheme;
} TPMS_KEYEDHASH_PARMS;


typedef struct TPMS_ASYM_PARMS {
    TPMT_SYM_DEF_OBJECT symmetric;
    TPMT_ASYM_SCHEME scheme;
} TPMS_ASYM_PARMS;

typedef struct TPMS_RSA_PARMS {
    TPMT_SYM_DEF_OBJECT symmetric;
    TPMT_RSA_SCHEME scheme;
    TPMI_RSA_KEY_BITS keyBits;
    UINT32 exponent;
} TPMS_RSA_PARMS;

typedef struct TPMS_ECC_PARMS {
    TPMT_SYM_DEF_OBJECT symmetric;
    TPMT_ECC_SCHEME scheme;
    TPMI_ECC_CURVE curveID;
    TPMT_KDF_SCHEME kdf;
} TPMS_ECC_PARMS;

typedef union TPMU_PUBLIC_PARMS {
    TPMS_KEYEDHASH_PARMS keyedHashDetail;
    TPMS_SYMCIPHER_PARMS symDetail;
    TPMS_RSA_PARMS rsaDetail;
    TPMS_ECC_PARMS eccDetail;
    TPMS_ASYM_PARMS asymDetail;
} TPMU_PUBLIC_PARMS;

typedef struct TPMT_PUBLIC_PARMS {
    TPMI_ALG_PUBLIC type;
    TPMU_PUBLIC_PARMS parameters;
} TPMT_PUBLIC_PARMS;


typedef struct TPMT_PUBLIC {
    TPMI_ALG_PUBLIC type;
    TPMI_ALG_HASH nameAlg;
    TPMA_OBJECT objectAttributes;
    TPM2B_DIGEST authPolicy;
    TPMU_PUBLIC_PARMS parameters;
    TPMU_PUBLIC_ID unique;
} TPMT_PUBLIC;

typedef struct TPM2B_PUBLIC {
    UINT16 size;
    TPMT_PUBLIC publicArea;
} TPM2B_PUBLIC;

typedef struct TPM2B_TEMPLATE {
    UINT16 size;
    BYTE buffer[sizeof(TPMT_PUBLIC)];
} TPM2B_TEMPLATE;


/* Private Structures */

typedef struct TPM2B_PRIVATE_VENDOR_SPECIFIC {
    UINT16 size;
    BYTE buffer[PRIVATE_VENDOR_SPECIFIC_BYTES];
} TPM2B_PRIVATE_VENDOR_SPECIFIC;

typedef union TPMU_SENSITIVE_COMPOSITE {
    TPM2B_PRIVATE_KEY_RSA rsa;  /* TPM_ALG_RSA */
    TPM2B_ECC_PARAMETER ecc;    /* TPM_ALG_ECC */
    TPM2B_SENSITIVE_DATA bits;  /* TPM_ALG_KEYEDHASH */
    TPM2B_SYM_KEY sym;          /* TPM_ALG_SYMCIPHER */
    TPM2B_PRIVATE_VENDOR_SPECIFIC any;
} TPMU_SENSITIVE_COMPOSITE;


typedef struct TPMT_SENSITIVE {
    TPMI_ALG_PUBLIC sensitiveType;
    TPM2B_AUTH authValue;
    TPM2B_DIGEST seedValue;
    TPMU_SENSITIVE_COMPOSITE sensitive;
} TPMT_SENSITIVE;

typedef struct TPM2B_SENSITIVE {
    UINT16 size;
    TPMT_SENSITIVE sensitiveArea;
} TPM2B_SENSITIVE;


typedef struct TPMT_PRIVATE {
    TPM2B_DIGEST integrityOuter;
    TPM2B_DIGEST integrityInner;
    TPM2B_SENSITIVE sensitive;
} TPMT_PRIVATE;

typedef struct TPM2B_PRIVATE {
    UINT16 size;
    BYTE buffer[sizeof(TPMT_PRIVATE)];
} TPM2B_PRIVATE;


/* Identity Object */

typedef struct TPMS_ID_OBJECT {
    TPM2B_DIGEST integrityHMAC;
    TPM2B_DIGEST encIdentity;
} TPMS_ID_OBJECT;

typedef struct TPM2B_ID_OBJECT {
    UINT16 size;
    BYTE buffer[sizeof(TPMS_ID_OBJECT)];
} TPM2B_ID_OBJECT;


/* NV Storage Structures */

typedef UINT32 TPM_NV_INDEX;
enum TPM_NV_INDEX_mask {
    TPM_NV_INDEX_index = 0x00FFFFFF,
    TPM_NV_INDEX_RH_NV = 0xFF000000,
};

typedef enum TPM_NT {
    TPM_NT_ORDINARY = 0x0,
    TPM_NT_COUNTER  = 0x1,
    TPM_NT_BITS     = 0x2,
    TPM_NT_EXTEND   = 0x4,
    TPM_NT_PIN_FAIL = 0x8,
    TPM_NT_PIN_PASS = 0x9,
} TPM_NT;


typedef struct TPMS_NV_PIN_COUNTER_PARAMETERS {
    UINT32 pinCount;
    UINT32 pinLimit;
} TPMS_NV_PIN_COUNTER_PARAMETERS;

typedef UINT32 TPMA_NV;
enum TPMA_NV_mask {
    TPMA_NV_PPWRITE         = 0x00000001,
    TPMA_NV_OWNERWRITE      = 0x00000002,
    TPMA_NV_AUTHWRITE       = 0x00000004,
    TPMA_NV_POLICYWRITE     = 0x00000008,
    TPMA_NV_TPM_NT          = 0x000000F0,
    TPMA_NV_POLICY_DELETE   = 0x00000400,
    TPMA_NV_WRITELOCKED     = 0x00000800,
    TPMA_NV_WRITEALL        = 0x00001000,
    TPMA_NV_WRITEDEFINE     = 0x00002000,
    TPMA_NV_WRITE_STCLEAR   = 0x00004000,
    TPMA_NV_GLOBALLOCK      = 0x00008000,
    TPMA_NV_PPREAD          = 0x00010000,
    TPMA_NV_OWNERREAD       = 0x00020000,
    TPMA_NV_AUTHREAD        = 0x00040000,
    TPMA_NV_POLICYREAD      = 0x00080000,
    TPMA_NV_NO_DA           = 0x02000000,
    TPMA_NV_ORDERLY         = 0x04000000,
    TPMA_NV_CLEAR_STCLEAR   = 0x08000000,
    TPMA_NV_READLOCKED      = 0x10000000,
    TPMA_NV_WRITTEN         = 0x20000000,
    TPMA_NV_PLATFORMCREATE  = 0x40000000,
    TPMA_NV_READ_STCLEAR    = 0x80000000,
};

typedef struct TPMS_NV_PUBLIC {
    TPMI_RH_NV_INDEX nvIndex;
    TPMI_ALG_HASH nameAlg;
    TPMA_NV attributes;
    TPM2B_DIGEST authPolicy;
    UINT16 dataSize;
} TPMS_NV_PUBLIC;

typedef struct TPM2B_NV_PUBLIC {
    UINT16 size;
    TPMS_NV_PUBLIC nvPublic;
} TPM2B_NV_PUBLIC;


/* Context Data */

typedef struct TPM2B_CONTEXT_SENSITIVE {
    UINT16 size;
    BYTE buffer[MAX_CONTEXT_SIZE];
} TPM2B_CONTEXT_SENSITIVE;

typedef struct TPMS_CONTEXT_DATA {
    TPM2B_DIGEST integrity;
    TPM2B_CONTEXT_SENSITIVE encrypted;
} TPMS_CONTEXT_DATA;

typedef struct TPM2B_CONTEXT_DATA {
    UINT16 size;
    BYTE buffer[sizeof(TPMS_CONTEXT_DATA)];
} TPM2B_CONTEXT_DATA;

typedef struct TPMS_CONTEXT {
    UINT64 sequence;
    TPMI_DH_CONTEXT savedHandle;
    TPMI_RH_HIERARCHY hierarchy;
    TPM2B_CONTEXT_DATA contextBlob;
} TPMS_CONTEXT;


typedef struct TPMS_CREATION_DATA {
    TPML_PCR_SELECTION pcrSelect;
    TPM2B_DIGEST pcrDigest;
    TPMA_LOCALITY locality;
    TPM_ALG_ID parentNameAlg;
    TPM2B_NAME parentName;
    TPM2B_NAME parentQualifiedName;
    TPM2B_DATA outsideInfo;
} TPMS_CREATION_DATA;

typedef struct TPM2B_CREATION_DATA {
    UINT16 size;
    TPMS_CREATION_DATA creationData;
} TPM2B_CREATION_DATA;


/* Authorization Structures */
typedef struct TPMS_AUTH_COMMAND {
    TPMI_SH_AUTH_SESSION sessionHandle;
    TPM2B_NONCE nonce; /* nonceCaller */
    TPMA_SESSION sessionAttributes;
    TPM2B_AUTH hmac;
} TPMS_AUTH_COMMAND;

typedef struct TPMS_AUTH_RESPONSE {
    TPM2B_NONCE nonce;
    TPMA_SESSION sessionAttributes;
    TPM2B_AUTH hmac;
} TPMS_AUTH_RESPONSE;

/* Implementation specific authorization session information */
typedef struct TPM2_AUTH_SESSION {
    /* BEGIN */
    /* This section should match TPMS_AUTH_COMMAND */
    TPMI_SH_AUTH_SESSION sessionHandle;
    TPM2B_NONCE nonceCaller;
    TPMA_SESSION sessionAttributes;
    TPM2B_AUTH auth;
    /* END */

    /* additional auth data required for implementation */
    TPM2B_NONCE nonceTPM;
    TPMT_SYM_DEF symmetric;
    TPMI_ALG_HASH authHash;
    TPM2B_NAME name;
} TPM2_AUTH_SESSION;

/* Macros to determine TPM 2.0 Session type */
#define TPM2_IS_PWD_SESSION(sessionHandle) ((sessionHandle) == TPM_RS_PW)
#define TPM2_IS_HMAC_SESSION(sessionHandle) ((sessionHandle & 0xFF000000) == HMAC_SESSION_FIRST)
#define TPM2_IS_POLICY_SESSION(sessionHandle) ((sessionHandle & 0xFF000000) == POLICY_SESSION_FIRST)

/* Predetermined TPM 2.0 Indexes */
#define TPM_20_TPM_MFG_NV_SPACE        ((TPM_HT_NV_INDEX << 24) | (0x00 << 22))
#define TPM_20_PLATFORM_MFG_NV_SPACE   ((TPM_HT_NV_INDEX << 24) | (0x01 << 22))
#define TPM_20_OWNER_NV_SPACE          ((TPM_HT_NV_INDEX << 24) | (0x02 << 22))
#define TPM_20_TCG_NV_SPACE            ((TPM_HT_NV_INDEX << 24) | (0x03 << 22))

#define TPM_20_NV_INDEX_EK_CERTIFICATE (TPM_20_PLATFORM_MFG_NV_SPACE + 2)
#define TPM_20_NV_INDEX_EK_NONCE       (TPM_20_PLATFORM_MFG_NV_SPACE + 3)
#define TPM_20_NV_INDEX_EK_TEMPLATE    (TPM_20_PLATFORM_MFG_NV_SPACE + 4)

/* Predetermined TPM 2.0 Endorsement policy auth template */
static const BYTE TPM_20_EK_AUTH_POLICY[] = {
    0x83, 0x71, 0x97, 0x67, 0x44, 0x84, 0xb3, 0xf8, 0x1a, 0x90, 0xcc,
    0x8d, 0x46, 0xa5, 0xd7, 0x24, 0xfd, 0x52, 0xd7, 0x6e, 0x06, 0x52,
    0x0b, 0x64, 0xf2, 0xa1, 0xda, 0x1b, 0x33, 0x14, 0x69, 0xaa,
};



/* HAL IO Callbacks */
struct TPM2_CTX;

#ifdef WOLFTPM_SWTPM
struct wolfTPM_tcpContext {
    int fd;
};
#endif /* WOLFTPM_SWTPM */

#ifdef WOLFTPM_WINAPI
#include <tbs.h>

struct wolfTPM_winContext {
  TBS_HCONTEXT tbs_context;
};
#endif /* WOLFTPM_WINAPI */

/* make sure advanced IO is enabled for I2C */
#ifdef WOLFTPM_I2C
    #undef  WOLFTPM_ADV_IO
    #define WOLFTPM_ADV_IO
#endif

#ifdef WOLFTPM_ADV_IO
typedef int (*TPM2HalIoCb)(struct TPM2_CTX*, INT32 isRead, UINT32 addr,
    BYTE* xferBuf, UINT16 xferSz, void* userCtx);
#else
typedef int (*TPM2HalIoCb)(struct TPM2_CTX*, const BYTE* txBuf, BYTE* rxBuf,
    UINT16 xferSz, void* userCtx);
#endif

#if !defined(WOLFTPM2_NO_WOLFCRYPT) && !defined(WC_NO_RNG) && \
    !defined(WOLFTPM2_USE_HW_RNG)
    #define WOLFTPM2_USE_WOLF_RNG
#endif

typedef struct TPM2_CTX {
    TPM2HalIoCb ioCb;
    void* userCtx;
#ifdef WOLFTPM_SWTPM
    struct wolfTPM_tcpContext tcpCtx;
#endif
#ifdef WOLFTPM_WINAPI
    struct wolfTPM_winContext winCtx;
#endif
#ifndef WOLFTPM2_NO_WOLFCRYPT
#ifndef SINGLE_THREADED
    wolfSSL_Mutex hwLock;
#endif
    #ifdef WOLFTPM2_USE_WOLF_RNG
    WC_RNG rng;
    #endif
#endif /* !WOLFTPM2_NO_WOLFCRYPT */

    /* TPM TIS Info */
    int locality;
    word32 caps;
    word32 did_vid;
    byte rid;

    /* Pointer to current TPM auth sessions */
    TPM2_AUTH_SESSION* session;

    /* Command / Response Buffer */
    byte cmdBuf[MAX_COMMAND_SIZE];

    /* Informational Bits - use unsigned int for best compiler compatibility */
#ifndef WOLFTPM2_NO_WOLFCRYPT
    #ifndef SINGLE_THREADED
    unsigned int hwLockInit:1;
    #endif
    #ifndef WC_NO_RNG
    unsigned int rngInit:1;
    #endif
#endif
} TPM2_CTX;


/* TPM Specification Functions */
typedef struct {
    TPM_SU startupType;
} Startup_In;
WOLFTPM_API TPM_RC TPM2_Startup(Startup_In* in);

typedef struct {
    TPM_SU shutdownType;
} Shutdown_In;
WOLFTPM_API TPM_RC TPM2_Shutdown(Shutdown_In* in);


typedef struct {
    TPM_CAP capability;
    UINT32 property;
    UINT32 propertyCount;
} GetCapability_In;
typedef struct {
    TPMI_YES_NO moreData;
    TPMS_CAPABILITY_DATA capabilityData;
} GetCapability_Out;
WOLFTPM_API TPM_RC TPM2_GetCapability(GetCapability_In* in,
    GetCapability_Out* out);


typedef struct {
    TPMI_YES_NO fullTest;
} SelfTest_In;
WOLFTPM_API TPM_RC TPM2_SelfTest(SelfTest_In* in);

typedef struct {
    TPML_ALG toTest;
} IncrementalSelfTest_In;
typedef struct {
    TPML_ALG toDoList;
} IncrementalSelfTest_Out;
WOLFTPM_API TPM_RC TPM2_IncrementalSelfTest(IncrementalSelfTest_In* in,
    IncrementalSelfTest_Out* out);

typedef struct {
    TPM2B_MAX_BUFFER outData;
    UINT16 testResult; /* TPM_RC */
} GetTestResult_Out;
WOLFTPM_API TPM_RC TPM2_GetTestResult(GetTestResult_Out* out);


typedef struct {
    UINT16 bytesRequested;
} GetRandom_In;
typedef struct {
    TPM2B_DIGEST randomBytes; /* hardware max is 32-bytes */
} GetRandom_Out;
WOLFTPM_API TPM_RC TPM2_GetRandom(GetRandom_In* in, GetRandom_Out* out);

typedef struct {
    TPM2B_SENSITIVE_DATA inData;
} StirRandom_In;
WOLFTPM_API TPM_RC TPM2_StirRandom(StirRandom_In* in);

typedef struct {
    TPML_PCR_SELECTION pcrSelectionIn;
} PCR_Read_In;
typedef struct {
    UINT32 pcrUpdateCounter;
    TPML_PCR_SELECTION pcrSelectionOut;
    TPML_DIGEST pcrValues;
} PCR_Read_Out;
WOLFTPM_API TPM_RC TPM2_PCR_Read(PCR_Read_In* in, PCR_Read_Out* out);


typedef struct {
    TPMI_DH_PCR pcrHandle;
    TPML_DIGEST_VALUES digests;
} PCR_Extend_In;
WOLFTPM_API TPM_RC TPM2_PCR_Extend(PCR_Extend_In* in);


typedef struct {
    TPMI_DH_OBJECT parentHandle;
    TPM2B_SENSITIVE_CREATE inSensitive;
    TPM2B_PUBLIC inPublic;
    TPM2B_DATA outsideInfo;
    TPML_PCR_SELECTION creationPCR;
} Create_In;
typedef struct {
    TPM2B_PRIVATE outPrivate;
    TPM2B_PUBLIC outPublic;
    TPM2B_CREATION_DATA creationData;
    TPM2B_DIGEST creationHash;
    TPMT_TK_CREATION creationTicket;
} Create_Out;
WOLFTPM_API TPM_RC TPM2_Create(Create_In* in, Create_Out* out);

typedef struct {
    TPMI_DH_OBJECT parentHandle;
    TPM2B_SENSITIVE_CREATE inSensitive;
    TPM2B_PUBLIC inPublic;
} CreateLoaded_In;
typedef struct {
    TPM_HANDLE objectHandle;
    TPM2B_PRIVATE outPrivate;
    TPM2B_PUBLIC outPublic;
    TPM2B_NAME name;
} CreateLoaded_Out;
WOLFTPM_API TPM_RC TPM2_CreateLoaded(CreateLoaded_In* in,
    CreateLoaded_Out* out);


typedef struct {
    TPMI_RH_HIERARCHY primaryHandle;
    TPM2B_SENSITIVE_CREATE inSensitive;
    TPM2B_PUBLIC inPublic;
    TPM2B_DATA outsideInfo;
    TPML_PCR_SELECTION creationPCR;
} CreatePrimary_In;
typedef struct {
    TPM_HANDLE objectHandle;
    TPM2B_PUBLIC outPublic;
    TPM2B_CREATION_DATA creationData;
    TPM2B_DIGEST creationHash;
    TPMT_TK_CREATION creationTicket;
    TPM2B_NAME name;
} CreatePrimary_Out;
WOLFTPM_API TPM_RC TPM2_CreatePrimary(CreatePrimary_In* in,
    CreatePrimary_Out* out);

typedef struct {
    TPMI_DH_OBJECT parentHandle;
    TPM2B_PRIVATE inPrivate;
    TPM2B_PUBLIC inPublic;
} Load_In;
typedef struct {
    TPM_HANDLE objectHandle;
    TPM2B_NAME name;
} Load_Out;
WOLFTPM_API TPM_RC TPM2_Load(Load_In* in, Load_Out* out);


typedef struct {
    TPMI_DH_CONTEXT flushHandle;
} FlushContext_In;
WOLFTPM_API TPM_RC TPM2_FlushContext(FlushContext_In* in);


typedef struct {
    TPMI_DH_OBJECT itemHandle;
} Unseal_In;
typedef struct {
    TPM2B_SENSITIVE_DATA outData;
} Unseal_Out;
WOLFTPM_API TPM_RC TPM2_Unseal(Unseal_In* in, Unseal_Out* out);


typedef struct {
    TPMI_DH_OBJECT tpmKey;
    TPMI_DH_ENTITY bind;
    TPM2B_NONCE nonceCaller;
    TPM2B_ENCRYPTED_SECRET encryptedSalt;
    TPM_SE sessionType;
    TPMT_SYM_DEF symmetric;
    TPMI_ALG_HASH authHash;
} StartAuthSession_In;
typedef struct {
    TPMI_SH_AUTH_SESSION sessionHandle;
    TPM2B_NONCE nonceTPM;
} StartAuthSession_Out;
WOLFTPM_API TPM_RC TPM2_StartAuthSession(StartAuthSession_In* in,
    StartAuthSession_Out* out);

typedef struct {
    TPMI_SH_POLICY sessionHandle;
} PolicyRestart_In;
WOLFTPM_API TPM_RC TPM2_PolicyRestart(PolicyRestart_In* in);


typedef struct {
    TPM2B_SENSITIVE inPrivate;
    TPM2B_PUBLIC inPublic;
    TPMI_RH_HIERARCHY hierarchy;
} LoadExternal_In;
typedef struct {
    TPM_HANDLE objectHandle;
    TPM2B_NAME name;
} LoadExternal_Out;
WOLFTPM_API TPM_RC TPM2_LoadExternal(LoadExternal_In* in,
    LoadExternal_Out* out);

typedef struct {
    TPMI_DH_OBJECT objectHandle;
} ReadPublic_In;
typedef struct {
    TPM2B_PUBLIC outPublic;
    TPM2B_NAME name;
    TPM2B_NAME qualifiedName;
} ReadPublic_Out;
WOLFTPM_API TPM_RC TPM2_ReadPublic(ReadPublic_In* in, ReadPublic_Out* out);

typedef struct {
    TPMI_DH_OBJECT activateHandle;
    TPMI_DH_OBJECT keyHandle;
    TPM2B_ID_OBJECT credentialBlob;
    TPM2B_ENCRYPTED_SECRET secret;
} ActivateCredential_In;
typedef struct {
    TPM2B_DIGEST certInfo;
} ActivateCredential_Out;
WOLFTPM_API TPM_RC TPM2_ActivateCredential(ActivateCredential_In* in,
    ActivateCredential_Out* out);

typedef struct {
    TPMI_DH_OBJECT handle;
    TPM2B_DIGEST credential;
    TPM2B_NAME objectName;
} MakeCredential_In;
typedef struct {
    TPM2B_ID_OBJECT credentialBlob;
    TPM2B_ENCRYPTED_SECRET secret;
} MakeCredential_Out;
WOLFTPM_API TPM_RC TPM2_MakeCredential(MakeCredential_In* in,
    MakeCredential_Out* out);

typedef struct {
    TPMI_DH_OBJECT objectHandle;
    TPMI_DH_OBJECT parentHandle;
    TPM2B_AUTH newAuth;
} ObjectChangeAuth_In;
typedef struct {
    TPM2B_PRIVATE outPrivate;
} ObjectChangeAuth_Out;
WOLFTPM_API TPM_RC TPM2_ObjectChangeAuth(ObjectChangeAuth_In* in,
    ObjectChangeAuth_Out* out);


typedef struct {
    TPMI_DH_OBJECT objectHandle;
    TPMI_DH_OBJECT newParentHandle;
    TPM2B_DATA encryptionKeyIn;
    TPMT_SYM_DEF_OBJECT symmetricAlg;
} Duplicate_In;
typedef struct {
    TPM2B_DATA encryptionKeyOut;
    TPM2B_PRIVATE duplicate;
    TPM2B_ENCRYPTED_SECRET outSymSeed;
} Duplicate_Out;
WOLFTPM_API TPM_RC TPM2_Duplicate(Duplicate_In* in, Duplicate_Out* out);

typedef struct {
    TPMI_DH_OBJECT oldParent;
    TPMI_DH_OBJECT newParent;
    TPM2B_PRIVATE inDuplicate;
    TPM2B_NAME name;
    TPM2B_ENCRYPTED_SECRET inSymSeed;
} Rewrap_In;
typedef struct {
    TPM2B_PRIVATE outDuplicate;
    TPM2B_ENCRYPTED_SECRET outSymSeed;
} Rewrap_Out;
WOLFTPM_API TPM_RC TPM2_Rewrap(Rewrap_In* in, Rewrap_Out* out);

typedef struct {
    TPMI_DH_OBJECT parentHandle;
    TPM2B_DATA encryptionKey;
    TPM2B_PUBLIC objectPublic;
    TPM2B_PRIVATE duplicate;
    TPM2B_ENCRYPTED_SECRET inSymSeed;
    TPMT_SYM_DEF_OBJECT symmetricAlg;
} Import_In;
typedef struct {
    TPM2B_PRIVATE outPrivate;
} Import_Out;
WOLFTPM_API TPM_RC TPM2_Import(Import_In* in, Import_Out* out);

typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_PUBLIC_KEY_RSA message;
    TPMT_RSA_DECRYPT inScheme;
    TPM2B_DATA label;
} RSA_Encrypt_In;
typedef struct {
    TPM2B_PUBLIC_KEY_RSA outData;
} RSA_Encrypt_Out;
WOLFTPM_API TPM_RC TPM2_RSA_Encrypt(RSA_Encrypt_In* in, RSA_Encrypt_Out* out);


typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_PUBLIC_KEY_RSA cipherText;
    TPMT_RSA_DECRYPT inScheme;
    TPM2B_DATA label;
} RSA_Decrypt_In;
typedef struct {
    TPM2B_PUBLIC_KEY_RSA message;
} RSA_Decrypt_Out;
WOLFTPM_API TPM_RC TPM2_RSA_Decrypt(RSA_Decrypt_In* in, RSA_Decrypt_Out* out);


typedef struct {
    TPMI_DH_OBJECT keyHandle;
} ECDH_KeyGen_In;
typedef struct {
    TPM2B_ECC_POINT zPoint;
    TPM2B_ECC_POINT pubPoint;
} ECDH_KeyGen_Out;
WOLFTPM_API TPM_RC TPM2_ECDH_KeyGen(ECDH_KeyGen_In* in, ECDH_KeyGen_Out* out);


typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_ECC_POINT inPoint;
} ECDH_ZGen_In;
typedef struct {
    TPM2B_ECC_POINT outPoint;
} ECDH_ZGen_Out;
WOLFTPM_API TPM_RC TPM2_ECDH_ZGen(ECDH_ZGen_In* in, ECDH_ZGen_Out* out);

typedef struct {
    TPMI_ECC_CURVE curveID;
} ECC_Parameters_In;
typedef struct {
    TPMS_ALGORITHM_DETAIL_ECC parameters;
} ECC_Parameters_Out;
WOLFTPM_API TPM_RC TPM2_ECC_Parameters(ECC_Parameters_In* in,
    ECC_Parameters_Out* out);

typedef struct {
    TPMI_DH_OBJECT keyA;
    TPM2B_ECC_POINT inQsB;
    TPM2B_ECC_POINT inQeB;
    TPMI_ECC_KEY_EXCHANGE inScheme;
    UINT16 counter;
} ZGen_2Phase_In;
typedef struct {
    TPM2B_ECC_POINT outZ1;
    TPM2B_ECC_POINT outZ2;
} ZGen_2Phase_Out;
WOLFTPM_API TPM_RC TPM2_ZGen_2Phase(ZGen_2Phase_In* in, ZGen_2Phase_Out* out);


typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPMI_YES_NO decrypt;
    TPMI_ALG_SYM_MODE mode;
    TPM2B_IV ivIn;
    TPM2B_MAX_BUFFER inData;
} EncryptDecrypt_In;
typedef struct {
    TPM2B_MAX_BUFFER outData;
    TPM2B_IV ivOut;
} EncryptDecrypt_Out;
WOLFTPM_API TPM_RC TPM2_EncryptDecrypt(EncryptDecrypt_In* in,
    EncryptDecrypt_Out* out);

typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_MAX_BUFFER inData;
    TPMI_YES_NO decrypt;
    TPMI_ALG_SYM_MODE mode;
    TPM2B_IV ivIn;
} EncryptDecrypt2_In;
typedef struct {
    TPM2B_MAX_BUFFER outData;
    TPM2B_IV ivOut;
} EncryptDecrypt2_Out;
WOLFTPM_API TPM_RC TPM2_EncryptDecrypt2(EncryptDecrypt2_In* in,
    EncryptDecrypt2_Out* out);


typedef struct {
    TPM2B_MAX_BUFFER data;
    TPMI_ALG_HASH hashAlg;
    TPMI_RH_HIERARCHY hierarchy;
} Hash_In;
typedef struct {
    TPM2B_DIGEST outHash;
    TPMT_TK_HASHCHECK validation;
} Hash_Out;
WOLFTPM_API TPM_RC TPM2_Hash(Hash_In* in, Hash_Out* out);

typedef struct {
    TPMI_DH_OBJECT handle;
    TPM2B_MAX_BUFFER buffer;
    TPMI_ALG_HASH hashAlg;
} HMAC_In;
typedef struct {
    TPM2B_DIGEST outHMAC;
} HMAC_Out;
WOLFTPM_API TPM_RC TPM2_HMAC(HMAC_In* in, HMAC_Out* out);


typedef struct {
    TPMI_DH_OBJECT handle;
    TPM2B_AUTH auth;
    TPMI_ALG_HASH hashAlg;
} HMAC_Start_In;
typedef struct {
    TPMI_DH_OBJECT sequenceHandle;
} HMAC_Start_Out;
WOLFTPM_API TPM_RC TPM2_HMAC_Start(HMAC_Start_In* in, HMAC_Start_Out* out);


typedef struct {
    TPM2B_AUTH auth;
    TPMI_ALG_HASH hashAlg;
} HashSequenceStart_In;
typedef struct {
    TPMI_DH_OBJECT sequenceHandle;
} HashSequenceStart_Out;
WOLFTPM_API TPM_RC TPM2_HashSequenceStart(HashSequenceStart_In* in,
    HashSequenceStart_Out* out);

typedef struct {
    TPMI_DH_OBJECT sequenceHandle;
    TPM2B_MAX_BUFFER buffer;
} SequenceUpdate_In;
WOLFTPM_API TPM_RC TPM2_SequenceUpdate(SequenceUpdate_In* in);

typedef struct {
    TPMI_DH_OBJECT sequenceHandle;
    TPM2B_MAX_BUFFER buffer;
    TPMI_RH_HIERARCHY hierarchy;
} SequenceComplete_In;
typedef struct {
    TPM2B_DIGEST result;
    TPMT_TK_HASHCHECK validation;
} SequenceComplete_Out;
WOLFTPM_API TPM_RC TPM2_SequenceComplete(SequenceComplete_In* in,
    SequenceComplete_Out* out);


typedef struct {
    TPMI_DH_PCR pcrHandle;
    TPMI_DH_OBJECT sequenceHandle;
    TPM2B_MAX_BUFFER buffer;
} EventSequenceComplete_In;
typedef struct {
    TPML_DIGEST_VALUES results;
} EventSequenceComplete_Out;
WOLFTPM_API TPM_RC TPM2_EventSequenceComplete(EventSequenceComplete_In* in,
    EventSequenceComplete_Out* out);


typedef struct {
    TPMI_DH_OBJECT objectHandle;
    TPMI_DH_OBJECT signHandle;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
} Certify_In;
typedef struct {
    TPM2B_ATTEST certifyInfo;
    TPMT_SIGNATURE signature;
} Certify_Out;
WOLFTPM_API TPM_RC TPM2_Certify(Certify_In* in, Certify_Out* out);


typedef struct {
    TPMI_DH_OBJECT signHandle;
    TPMI_DH_OBJECT objectHandle;
    TPM2B_DATA qualifyingData;
    TPM2B_DIGEST creationHash;
    TPMT_SIG_SCHEME inScheme;
    TPMT_TK_CREATION creationTicket;
} CertifyCreation_In;
typedef struct {
    TPM2B_ATTEST certifyInfo;
    TPMT_SIGNATURE signature;
} CertifyCreation_Out;
WOLFTPM_API TPM_RC TPM2_CertifyCreation(CertifyCreation_In* in, CertifyCreation_Out* out);


typedef struct {
    TPMI_DH_OBJECT signHandle;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
    TPML_PCR_SELECTION PCRselect;
} Quote_In;
typedef struct {
    TPM2B_ATTEST quoted;
    TPMT_SIGNATURE signature;
} Quote_Out;
WOLFTPM_API TPM_RC TPM2_Quote(Quote_In* in, Quote_Out* out);

typedef struct {
    TPMI_RH_ENDORSEMENT privacyAdminHandle;
    TPMI_DH_OBJECT signHandle;
    TPMI_SH_HMAC sessionHandle;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
} GetSessionAuditDigest_In;
typedef struct {
    TPM2B_ATTEST auditInfo;
    TPMT_SIGNATURE signature;
} GetSessionAuditDigest_Out;
WOLFTPM_API TPM_RC TPM2_GetSessionAuditDigest(GetSessionAuditDigest_In* in,
    GetSessionAuditDigest_Out* out);

typedef struct {
    TPMI_RH_ENDORSEMENT privacyHandle;
    TPMI_DH_OBJECT signHandle;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
} GetCommandAuditDigest_In;
typedef struct {
    TPM2B_ATTEST auditInfo;
    TPMT_SIGNATURE signature;
} GetCommandAuditDigest_Out;
WOLFTPM_API TPM_RC TPM2_GetCommandAuditDigest(GetCommandAuditDigest_In* in,
    GetCommandAuditDigest_Out* out);

typedef struct {
    TPMI_RH_ENDORSEMENT privacyAdminHandle;
    TPMI_DH_OBJECT signHandle;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
} GetTime_In;
typedef struct {
    TPM2B_ATTEST timeInfo;
    TPMT_SIGNATURE signature;
} GetTime_Out;
WOLFTPM_API TPM_RC TPM2_GetTime(GetTime_In* in, GetTime_Out* out);

typedef struct {
    TPMI_DH_OBJECT signHandle;
    TPM2B_ECC_POINT P1;
    TPM2B_SENSITIVE_DATA s2;
    TPM2B_ECC_PARAMETER y2;
} Commit_In;
typedef struct {
    TPM2B_ECC_POINT K;
    TPM2B_ECC_POINT L;
    TPM2B_ECC_POINT E;
    UINT16 counter;
} Commit_Out;
WOLFTPM_API TPM_RC TPM2_Commit(Commit_In* in, Commit_Out* out);


typedef struct {
    TPMI_ECC_CURVE curveID;
} EC_Ephemeral_In;
typedef struct {
    TPM2B_ECC_POINT Q;
    UINT16 counter;
} EC_Ephemeral_Out;
WOLFTPM_API TPM_RC TPM2_EC_Ephemeral(EC_Ephemeral_In* in,
    EC_Ephemeral_Out* out);

typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_DIGEST digest;
    TPMT_SIGNATURE signature;
} VerifySignature_In;
typedef struct {
    TPMT_TK_VERIFIED validation;
} VerifySignature_Out;
WOLFTPM_API TPM_RC TPM2_VerifySignature(VerifySignature_In* in,
    VerifySignature_Out* out);


typedef struct {
    TPMI_DH_OBJECT keyHandle;
    TPM2B_DIGEST digest;
    TPMT_SIG_SCHEME inScheme;
    TPMT_TK_HASHCHECK validation;
} Sign_In;
typedef struct {
    TPMT_SIGNATURE signature;
} Sign_Out;
WOLFTPM_API TPM_RC TPM2_Sign(Sign_In* in, Sign_Out* out);


typedef struct {
    TPMI_RH_PROVISION auth;
    TPMI_ALG_HASH auditAlg;
    TPML_CC setList;
    TPML_CC clearList;
} SetCommandCodeAuditStatus_In;
WOLFTPM_API TPM_RC TPM2_SetCommandCodeAuditStatus(
    SetCommandCodeAuditStatus_In* in);


typedef struct {
    TPMI_DH_PCR pcrHandle;
    TPM2B_EVENT eventData;
} PCR_Event_In;
typedef struct {
    TPML_DIGEST_VALUES digests;
} PCR_Event_Out;
WOLFTPM_API TPM_RC TPM2_PCR_Event(PCR_Event_In* in, PCR_Event_Out* out);


typedef struct {
    TPMI_RH_PLATFORM authHandle;
    TPML_PCR_SELECTION pcrAllocation;
} PCR_Allocate_In;
typedef struct {
    TPMI_YES_NO allocationSuccess;
    UINT32 maxPCR;
    UINT32 sizeNeeded;
    UINT32 sizeAvailable;
} PCR_Allocate_Out;
WOLFTPM_API TPM_RC TPM2_PCR_Allocate(PCR_Allocate_In* in,
    PCR_Allocate_Out* out);

typedef struct {
    TPMI_RH_PLATFORM authHandle;
    TPM2B_DIGEST authPolicy;
    TPMI_ALG_HASH hashAlg;
    TPMI_DH_PCR pcrNum;
} PCR_SetAuthPolicy_In;
WOLFTPM_API TPM_RC TPM2_PCR_SetAuthPolicy(PCR_SetAuthPolicy_In* in);

typedef struct {
    TPMI_DH_PCR pcrHandle;
    TPM2B_DIGEST auth;
} PCR_SetAuthValue_In;
WOLFTPM_API TPM_RC TPM2_PCR_SetAuthValue(PCR_SetAuthValue_In* in);

typedef struct {
    TPMI_DH_PCR pcrHandle;
} PCR_Reset_In;
WOLFTPM_API TPM_RC TPM2_PCR_Reset(PCR_Reset_In* in);


typedef struct {
    TPMI_DH_OBJECT authObject;
    TPMI_SH_POLICY policySession;
    TPM2B_NONCE nonceTPM;
    TPM2B_DIGEST cpHashA;
    TPM2B_NONCE policyRef;
    INT32 expiration;
    TPMT_SIGNATURE auth;
} PolicySigned_In;
typedef struct {
    TPM2B_TIMEOUT timeout;
    TPMT_TK_AUTH policyTicket;
} PolicySigned_Out;
WOLFTPM_API TPM_RC TPM2_PolicySigned(PolicySigned_In* in,
    PolicySigned_Out* out);

typedef struct {
    TPMI_DH_ENTITY authHandle;
    TPMI_SH_POLICY policySession;
    TPM2B_NONCE nonceTPM;
    TPM2B_DIGEST cpHashA;
    TPM2B_NONCE policyRef;
    INT32 expiration;
} PolicySecret_In;
typedef struct {
    TPM2B_TIMEOUT timeout;
    TPMT_TK_AUTH policyTicket;
} PolicySecret_Out;
WOLFTPM_API TPM_RC TPM2_PolicySecret(PolicySecret_In* in,
    PolicySecret_Out* out);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_TIMEOUT timeout;
    TPM2B_DIGEST cpHashA;
    TPM2B_NONCE policyRef;
    TPM2B_NAME authName;
    TPMT_TK_AUTH ticket;
} PolicyTicket_In;
WOLFTPM_API TPM_RC TPM2_PolicyTicket(PolicyTicket_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPML_DIGEST pHashList;
} PolicyOR_In;
WOLFTPM_API TPM_RC TPM2_PolicyOR(PolicyOR_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_DIGEST pcrDigest;
    TPML_PCR_SELECTION pcrs;
} PolicyPCR_In;
WOLFTPM_API TPM_RC TPM2_PolicyPCR(PolicyPCR_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPMA_LOCALITY locality;
} PolicyLocality_In;
WOLFTPM_API TPM_RC TPM2_PolicyLocality(PolicyLocality_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    TPMI_SH_POLICY policySession;
    TPM2B_OPERAND operandB;
    UINT16 offset;
    TPM_EO operation;
} PolicyNV_In;
WOLFTPM_API TPM_RC TPM2_PolicyNV(PolicyNV_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_OPERAND operandB;
    UINT16 offset;
    TPM_EO operation;
} PolicyCounterTimer_In;
WOLFTPM_API TPM_RC TPM2_PolicyCounterTimer(PolicyCounterTimer_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM_CC code;
} PolicyCommandCode_In;
WOLFTPM_API TPM_RC TPM2_PolicyCommandCode(PolicyCommandCode_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
} PolicyPhysicalPresence_In;
WOLFTPM_API TPM_RC TPM2_PolicyPhysicalPresence(PolicyPhysicalPresence_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_DIGEST cpHashA;
} PolicyCpHash_In;
WOLFTPM_API TPM_RC TPM2_PolicyCpHash(PolicyCpHash_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_DIGEST nameHash;
} PolicyNameHash_In;
WOLFTPM_API TPM_RC TPM2_PolicyNameHash(PolicyNameHash_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_NAME objectName;
    TPM2B_NAME newParentName;
    TPMI_YES_NO includeObject;
} PolicyDuplicationSelect_In;
WOLFTPM_API TPM_RC TPM2_PolicyDuplicationSelect(PolicyDuplicationSelect_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_DIGEST approvedPolicy;
    TPM2B_NONCE policyRef;
    TPM2B_NAME keySign;
    TPMT_TK_VERIFIED checkTicket;
} PolicyAuthorize_In;
WOLFTPM_API TPM_RC TPM2_PolicyAuthorize(PolicyAuthorize_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
} PolicyAuthValue_In;
WOLFTPM_API TPM_RC TPM2_PolicyAuthValue(PolicyAuthValue_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
} PolicyPassword_In;
WOLFTPM_API TPM_RC TPM2_PolicyPassword(PolicyPassword_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
} PolicyGetDigest_In;
typedef struct {
    TPM2B_DIGEST policyDigest;
} PolicyGetDigest_Out;
WOLFTPM_API TPM_RC TPM2_PolicyGetDigest(PolicyGetDigest_In* in, PolicyGetDigest_Out* out);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPMI_YES_NO writtenSet;
} PolicyNvWritten_In;
WOLFTPM_API TPM_RC TPM2_PolicyNvWritten(PolicyNvWritten_In* in);

typedef struct {
    TPMI_SH_POLICY policySession;
    TPM2B_DIGEST templateHash;
} PolicyTemplate_In;
WOLFTPM_API TPM_RC TPM2_PolicyTemplate(PolicyTemplate_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    TPMI_SH_POLICY policySession;
} PolicyAuthorizeNV_In;
WOLFTPM_API TPM_RC TPM2_PolicyAuthorizeNV(PolicyAuthorizeNV_In* in);



WOLFTPM_API void _TPM_Hash_Start(void);
WOLFTPM_API void _TPM_Hash_Data(UINT32 dataSize, BYTE *data);
WOLFTPM_API void _TPM_Hash_End(void);


typedef struct {
    TPMI_RH_HIERARCHY authHandle;
    TPMI_RH_ENABLES enable;
    TPMI_YES_NO state;
} HierarchyControl_In;
WOLFTPM_API TPM_RC TPM2_HierarchyControl(HierarchyControl_In* in);

typedef struct {
    TPMI_RH_HIERARCHY_AUTH authHandle;
    TPM2B_DIGEST authPolicy;
    TPMI_ALG_HASH hashAlg;
} SetPrimaryPolicy_In;
WOLFTPM_API TPM_RC TPM2_SetPrimaryPolicy(SetPrimaryPolicy_In* in);

typedef struct {
    TPMI_RH_PLATFORM authHandle;
} ChangeSeed_In;

typedef ChangeSeed_In ChangePPS_In;
WOLFTPM_API TPM_RC TPM2_ChangePPS(ChangePPS_In* in);

typedef ChangeSeed_In ChangeEPS_In;
WOLFTPM_API TPM_RC TPM2_ChangeEPS(ChangeEPS_In* in);


typedef struct {
    TPMI_RH_CLEAR authHandle;
} Clear_In;
WOLFTPM_API TPM_RC TPM2_Clear(Clear_In* in);

typedef struct {
    TPMI_RH_CLEAR auth;
    TPMI_YES_NO disable;
} ClearControl_In;
WOLFTPM_API TPM_RC TPM2_ClearControl(ClearControl_In* in);

typedef struct {
    TPMI_RH_HIERARCHY_AUTH authHandle;
    TPM2B_AUTH newAuth;
} HierarchyChangeAuth_In;
WOLFTPM_API TPM_RC TPM2_HierarchyChangeAuth(HierarchyChangeAuth_In* in);

typedef struct {
    TPMI_RH_LOCKOUT lockHandle;
} DictionaryAttackLockReset_In;
WOLFTPM_API TPM_RC TPM2_DictionaryAttackLockReset(DictionaryAttackLockReset_In* in);

typedef struct {
    TPMI_RH_LOCKOUT lockHandle;
    UINT32 newMaxTries;
    UINT32 newRecoveryTime;
    UINT32 lockoutRecovery;
} DictionaryAttackParameters_In;
WOLFTPM_API TPM_RC TPM2_DictionaryAttackParameters(DictionaryAttackParameters_In* in);


typedef struct {
    TPMI_RH_PLATFORM auth;
    TPML_CC setList;
    TPML_CC clearList;
} PP_Commands_In;
WOLFTPM_API TPM_RC TPM2_PP_Commands(PP_Commands_In* in);

typedef struct {
    TPMI_RH_PLATFORM authHandle;
    UINT32 algorithmSet;
} SetAlgorithmSet_In;
WOLFTPM_API TPM_RC TPM2_SetAlgorithmSet(SetAlgorithmSet_In* in);

typedef struct {
    TPMI_RH_PLATFORM authorization;
    TPMI_DH_OBJECT keyHandle;
    TPM2B_DIGEST fuDigest;
    TPMT_SIGNATURE manifestSignature;
} FieldUpgradeStart_In;
WOLFTPM_API TPM_RC TPM2_FieldUpgradeStart(FieldUpgradeStart_In* in);

typedef struct {
    TPM2B_MAX_BUFFER fuData;
} FieldUpgradeData_In;
typedef struct {
    TPMT_HA nextDigest;
    TPMT_HA firstDigest;
} FieldUpgradeData_Out;
WOLFTPM_API TPM_RC TPM2_FieldUpgradeData(FieldUpgradeData_In* in,
    FieldUpgradeData_Out* out);

typedef struct {
    UINT32 sequenceNumber;
} FirmwareRead_In;
typedef struct {
    TPM2B_MAX_BUFFER fuData;
} FirmwareRead_Out;
WOLFTPM_API TPM_RC TPM2_FirmwareRead(FirmwareRead_In* in, FirmwareRead_Out* out);


typedef struct {
    TPMI_DH_CONTEXT saveHandle;
} ContextSave_In;
typedef struct {
    TPMS_CONTEXT context;
} ContextSave_Out;
WOLFTPM_API TPM_RC TPM2_ContextSave(ContextSave_In* in, ContextSave_Out* out);

typedef struct {
    TPMS_CONTEXT context;
} ContextLoad_In;
typedef struct {
    TPMI_DH_CONTEXT loadedHandle;
} ContextLoad_Out;
WOLFTPM_API TPM_RC TPM2_ContextLoad(ContextLoad_In* in, ContextLoad_Out* out);


typedef struct {
    TPMI_RH_PROVISION auth;
    TPMI_DH_OBJECT objectHandle;
    TPMI_DH_PERSISTENT persistentHandle;
} EvictControl_In;
WOLFTPM_API TPM_RC TPM2_EvictControl(EvictControl_In* in);


typedef struct {
    TPMS_TIME_INFO currentTime;
} ReadClock_Out;
WOLFTPM_API TPM_RC TPM2_ReadClock(ReadClock_Out* out);

typedef struct {
    TPMI_RH_PROVISION auth;
    UINT64 newTime;
} ClockSet_In;
WOLFTPM_API TPM_RC TPM2_ClockSet(ClockSet_In* in);

typedef struct {
    TPMI_RH_PROVISION auth;
    TPM_CLOCK_ADJUST rateAdjust;
} ClockRateAdjust_In;
WOLFTPM_API TPM_RC TPM2_ClockRateAdjust(ClockRateAdjust_In* in);


typedef struct {
    TPMT_PUBLIC_PARMS parameters;
} TestParms_In;
WOLFTPM_API TPM_RC TPM2_TestParms(TestParms_In* in);


typedef struct {
    TPMI_RH_PROVISION authHandle;
    TPM2B_AUTH auth;
    TPM2B_NV_PUBLIC publicInfo;
} NV_DefineSpace_In;
WOLFTPM_API TPM_RC TPM2_NV_DefineSpace(NV_DefineSpace_In* in);

typedef struct {
    TPMI_RH_PROVISION authHandle;
    TPMI_RH_NV_INDEX nvIndex;
} NV_UndefineSpace_In;
WOLFTPM_API TPM_RC TPM2_NV_UndefineSpace(NV_UndefineSpace_In* in);

typedef struct {
    TPMI_RH_NV_INDEX nvIndex;
    TPMI_RH_PLATFORM platform;
} NV_UndefineSpaceSpecial_In;
WOLFTPM_API TPM_RC TPM2_NV_UndefineSpaceSpecial(NV_UndefineSpaceSpecial_In* in);

typedef struct {
    TPMI_RH_NV_INDEX nvIndex;
} NV_ReadPublic_In;
typedef struct {
    TPM2B_NV_PUBLIC nvPublic;
    TPM2B_NAME nvName;
} NV_ReadPublic_Out;
WOLFTPM_API TPM_RC TPM2_NV_ReadPublic(NV_ReadPublic_In* in, NV_ReadPublic_Out* out);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    TPM2B_MAX_NV_BUFFER data;
    UINT16 offset;
} NV_Write_In;
WOLFTPM_API TPM_RC TPM2_NV_Write(NV_Write_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
} NV_Increment_In;
WOLFTPM_API TPM_RC TPM2_NV_Increment(NV_Increment_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    TPM2B_MAX_NV_BUFFER data;
} NV_Extend_In;
WOLFTPM_API TPM_RC TPM2_NV_Extend(NV_Extend_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    UINT64 bits;
} NV_SetBits_In;
WOLFTPM_API TPM_RC TPM2_NV_SetBits(NV_SetBits_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
} NV_WriteLock_In;
WOLFTPM_API TPM_RC TPM2_NV_WriteLock(NV_WriteLock_In* in);

typedef struct {
    TPMI_RH_PROVISION authHandle;
} NV_GlobalWriteLock_In;
WOLFTPM_API TPM_RC TPM2_NV_GlobalWriteLock(NV_GlobalWriteLock_In* in);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    UINT16 size;
    UINT16 offset;
} NV_Read_In;
typedef struct {
    TPM2B_MAX_NV_BUFFER data;
} NV_Read_Out;
WOLFTPM_API TPM_RC TPM2_NV_Read(NV_Read_In* in, NV_Read_Out* out);

typedef struct {
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
} NV_ReadLock_In;
WOLFTPM_API TPM_RC TPM2_NV_ReadLock(NV_ReadLock_In* in);

typedef struct {
    TPMI_RH_NV_INDEX nvIndex;
    TPM2B_AUTH newAuth;
} NV_ChangeAuth_In;
WOLFTPM_API TPM_RC TPM2_NV_ChangeAuth(NV_ChangeAuth_In* in);

typedef struct {
    TPMI_DH_OBJECT signHandle;
    TPMI_RH_NV_AUTH authHandle;
    TPMI_RH_NV_INDEX nvIndex;
    TPM2B_DATA qualifyingData;
    TPMT_SIG_SCHEME inScheme;
    UINT16 size;
    UINT16 offset;
} NV_Certify_In;
typedef struct {
    TPM2B_ATTEST certifyInfo;
    TPMT_SIGNATURE signature;
} NV_Certify_Out;
WOLFTPM_API TPM_RC TPM2_NV_Certify(NV_Certify_In* in, NV_Certify_Out* out);


/* Vendor Specific API's */
#if defined(WOLFTPM_ST33) || defined(WOLFTPM_AUTODETECT)
    /* Enable command code vendor API */
    typedef struct {
        TPMI_RH_HIERARCHY authHandle;
        TPM_CC commandCode;
        UINT32 enableFlag;
        UINT32 lockFlag;
    } SetCommandSet_In;
    WOLFTPM_API int TPM2_SetCommandSet(SetCommandSet_In* in);

    enum {
        TPMLib_2 = 0x01,
        TPMFips = 0x02,
        TPMLowPowerOff = 0x00,
        TPMLowPowerByRegister = 0x04,
        TPMLowPowerByGpio = 0x08,
        TPMLowPowerAuto = 0x0C,
    };
    typedef struct TPM_MODE_SET {
        BYTE CmdToLowPower;
        BYTE BootToLowPower;
        BYTE modeLock;
        BYTE mode;
    } TPM_MODE_SET;
    typedef struct {
        TPMI_RH_HIERARCHY authHandle;
        TPM_MODE_SET modeSet;
    } SetMode_In;
    WOLFTPM_API int TPM2_SetMode(SetMode_In* in);
#endif

/* Vendor Specific GPIO */
#ifdef WOLFTPM_ST33

    #ifdef WOLFTPM_I2C
        #define MAX_GPIO_COUNT 4
    #else /* SPI variant */
        #define MAX_GPIO_COUNT 2
    #endif

    /* ST33 variants can have different count of GPIO available:
     * - SPI variant - 0, 1 or 2
     * - I2C variant - 0, 1, 2, 3 or 4
     * The user can configure this option at build or use default value. */
    #ifndef TPM_GPIO_COUNT
        #define TPM_GPIO_COUNT MAX_GPIO_COUNT
    #endif

    #define TPM_GPIO_NUM_MIN (TPM_GPIO_A)
    #define TPM_GPIO_NUM_MAX (TPM_GPIO_A + TPM_GPIO_COUNT - 1)

    /* GPIO configuration uses specific range of NV space */
    #define TPM_NV_GPIO_SPACE     0x01C40000

    typedef enum {
        TPM_GPIO_PP = 0x00000000, /* GPIO A by default is a Physical Presence pin */
        TPM_GPIO_LP = 0x00000001, /* GPIO B can only be used as an input */
    #ifdef WOLFTPM_I2C
        /* Only the I2C variant of ST33 has GPIO C and D */
        TPM_GPIO_C  = 0x00000002,
        TPM_GPIO_D  = 0x00000003,
    #endif
    } TPMI_GPIO_NAME_T;
    typedef UINT32 TPMI_GPIO_NAME;

    /* For portability and readability in code */
    #define TPM_GPIO_A TPM_GPIO_PP
    #define TPM_GPIO_B TPM_GPIO_LP

    typedef enum {
        TPM_GPIO_MODE_STANDARD   = 0x00000000,
        TPM_GPIO_MODE_FLOATING   = 0x00000001,
        TPM_GPIO_MODE_PULLUP     = 0x00000002,
        TPM_GPIO_MODE_PULLDOWN   = 0x00000003,
        TPM_GPIO_MODE_OPENDRAIN  = 0x00000004,
        TPM_GPIO_MODE_PUSHPULL   = 0x00000005,
        TPM_GPIO_MODE_UNCONFIG   = 0x00000006,
        TPM_GPIO_MODE_DEFAULT    = TPM_GPIO_MODE_PULLDOWN,
        TPM_GPIO_MODE_MAX        = TPM_GPIO_MODE_UNCONFIG,
        TPM_GPIO_MODE_INPUT_MIN  = TPM_GPIO_MODE_FLOATING,
        TPM_GPIO_MODE_INPUT_MAX  = TPM_GPIO_MODE_PULLDOWN
    } TPMI_GPIO_MODE_T;
    typedef UINT32 TPMI_GPIO_MODE;

    typedef struct TPMS_GPIO_CONFIG {
        TPMI_GPIO_NAME name;
        TPMI_RH_NV_INDEX index;
        TPMI_GPIO_MODE mode;
    } TPMS_GPIO_CONFIG;

    typedef struct TPML_GPIO_CONFIG {
        UINT32 count;
        TPMS_GPIO_CONFIG gpio[MAX_GPIO_COUNT];
    } TPML_GPIO_CONFIG;

    typedef struct {
        TPMI_RH_PLATFORM authHandle;
        TPML_GPIO_CONFIG config;
    } GpioConfig_In;
    WOLFTPM_API int TPM2_GPIO_Config(GpioConfig_In* in);

#elif defined(WOLFTPM_NUVOTON)

    #define MAX_GPIO_COUNT 2

    /* NPCT7XX supports a maximum of 2 GPIO for user control */
    /* Added in FW-US version 7.2.3.0 or later */
    #ifndef TPM_GPIO_COUNT
    #define TPM_GPIO_COUNT MAX_GPIO_COUNT
    #endif

    /* For portability */
    #undef  TPM_GPIO_A
    #define TPM_GPIO_A 3 /* NPCT75xx GPIO start at number 3 */

    #define TPM_GPIO_NUM_MIN (TPM_GPIO_A)
    #define TPM_GPIO_NUM_MAX (TPM_GPIO_A + TPM_GPIO_COUNT - 1)

    /* GPIO configuration uses specific range of NV space */
    #define TPM_NV_GPIO_SPACE     0x01C40003

    /* Nuvoton GPIO Modes */
    typedef enum {
        TPM_GPIO_MODE_PUSHPULL   = 1,
        TPM_GPIO_MODE_OPENDRAIN  = 2,
        TPM_GPIO_MODE_PULLUP     = 3,
        TPM_GPIO_MODE_UNCONFIG   = 4,
        TPM_GPIO_MODE_DEFAULT    = TPM_GPIO_MODE_PUSHPULL,
        TPM_GPIO_MODE_MAX        = TPM_GPIO_MODE_UNCONFIG,
        TPM_GPIO_MODE_INPUT_MIN  = TPM_GPIO_MODE_PULLUP,
        TPM_GPIO_MODE_INPUT_MAX  = TPM_GPIO_MODE_PULLUP
    } TPMI_GPIO_MODE_T;
    typedef UINT32 TPMI_GPIO_MODE;

    typedef struct {
        BYTE Base0;
        BYTE Base1;
        BYTE GpioAltCfg;
        BYTE GpioInitValue;
        BYTE GpioPullUp;
        BYTE GpioPushPull;
        BYTE Cfg_A;
        BYTE Cfg_B;
        BYTE Cfg_C;
        BYTE Cfg_D;
        BYTE Cfg_E;
        BYTE Cfg_F;
        BYTE Cfg_G;
        BYTE Cfg_H;
        BYTE Cfg_I;
        BYTE Cfg_J;
        BYTE isValid;
        BYTE isLocked;
    } CFG_STRUCT;

    typedef struct {
        TPMI_RH_PLATFORM authHandle;
        CFG_STRUCT preConfig;
    } NTC2_PreConfig_In;
    WOLFTPM_API int TPM2_NTC2_PreConfig(NTC2_PreConfig_In* in);

    typedef struct {
        CFG_STRUCT preConfig;
    } NTC2_GetConfig_Out;
    WOLFTPM_API int TPM2_NTC2_GetConfig(NTC2_GetConfig_Out* out);

#endif /* WOLFTPM_ST33 || WOLFTPM_AUTODETECT */


/* Non-standard API's */

#define _TPM_Init TPM2_Init

WOLFTPM_API TPM_RC TPM2_Init(TPM2_CTX* ctx, TPM2HalIoCb ioCb, void* userCtx);

WOLFTPM_API TPM_RC TPM2_Init_ex(TPM2_CTX* ctx, TPM2HalIoCb ioCb, void* userCtx,
    int timeoutTries);

WOLFTPM_API TPM_RC TPM2_Init_minimal(TPM2_CTX* ctx);

WOLFTPM_API TPM_RC TPM2_Cleanup(TPM2_CTX* ctx);

/* Other API's - Not in TPM Specification */

WOLFTPM_API TPM_RC TPM2_ChipStartup(TPM2_CTX* ctx, int timeoutTries);

WOLFTPM_API TPM_RC TPM2_SetHalIoCb(TPM2_CTX* ctx, TPM2HalIoCb ioCb, void* userCtx);

WOLFTPM_API TPM_RC TPM2_SetSessionAuth(TPM2_AUTH_SESSION *session);

WOLFTPM_API int    TPM2_GetSessionAuthCount(TPM2_CTX* ctx);

WOLFTPM_API void      TPM2_SetActiveCtx(TPM2_CTX* ctx);

WOLFTPM_API TPM2_CTX* TPM2_GetActiveCtx(void);

WOLFTPM_API int TPM2_GetHashDigestSize(TPMI_ALG_HASH hashAlg);

WOLFTPM_API int TPM2_GetHashType(TPMI_ALG_HASH hashAlg);

WOLFTPM_API int TPM2_GetNonce(byte* nonceBuf, int nonceSz);

WOLFTPM_API void TPM2_SetupPCRSel(TPML_PCR_SELECTION* pcr, TPM_ALG_ID alg,
    int pcrIndex);

WOLFTPM_API const char* TPM2_GetRCString(int rc);

WOLFTPM_API const char* TPM2_GetAlgName(TPM_ALG_ID alg);

WOLFTPM_API int TPM2_GetCurveSize(TPM_ECC_CURVE curveID);

WOLFTPM_API int TPM2_GetTpmCurve(int curveID);

WOLFTPM_API int TPM2_GetWolfCurve(int curve_id);

WOLFTPM_API int TPM2_ParseAttest(const TPM2B_ATTEST* in, TPMS_ATTEST* out);

WOLFTPM_API int TPM2_HashNvPublic(TPMS_NV_PUBLIC* nvPublic, byte* buffer, UINT16* size);

WOLFTPM_API int TPM2_AppendPublic(byte* buf, word32 size, int* sizeUsed, TPM2B_PUBLIC* pub);

WOLFTPM_API int TPM2_ParsePublic(TPM2B_PUBLIC* pub, byte* buf, word32 size, int* sizeUsed);

WOLFTPM_LOCAL int TPM2_GetName(TPM2_CTX* ctx, UINT32 handleValue, int handleCnt, int idx, TPM2B_NAME* name);

#ifdef WOLFTPM2_USE_WOLF_RNG
WOLFTPM_API int TPM2_GetWolfRng(WC_RNG** rng);
#endif

typedef enum {
    TPM_VENDOR_UNKNOWN = 0,
    TPM_VENDOR_INFINEON = 0x15d1,
    TPM_VENDOR_STM = 0x104a,
    TPM_VENDOR_MCHP = 0x1114,
    TPM_VENDOR_NUVOTON = 0x1050,
    TPM_VENDOR_NATIONTECH = 0x1B4E,
} TPM_Vendor_t;


WOLFTPM_API UINT16 TPM2_GetVendorID(void);

#ifdef DEBUG_WOLFTPM

WOLFTPM_API void TPM2_PrintBin(const byte* buffer, word32 length);

WOLFTPM_API void TPM2_PrintAuth(const TPMS_AUTH_COMMAND* authCmd);

WOLFTPM_API void TPM2_PrintPublicArea(const TPM2B_PUBLIC* pub);
#else
#define TPM2_PrintBin(b, l)
#define TPM2_PrintAuth(b, l)
#define TPM2_PrintPublicArea(b)
#endif

#ifdef __cplusplus
    }  /* extern "C" */
#endif

#endif /* __TPM2_H__ */
```










## wolftpm/tpm2_wrap.h



### Classes

|                | Name           |
| -------------- | -------------- |
| struct | **[WOLFTPM2_SESSION]()**  |
| struct | **[WOLFTPM2_DEV]()**  |
| struct | **[WOLFTPM2_KEY]()**  |
| struct | **[WOLFTPM2_KEYBLOB]()**  |
| struct | **[WOLFTPM2_HASH]()**  |
| struct | **[WOLFTPM2_NV]()**  |
| struct | **[WOLFTPM2_HMAC]()**  |
| struct | **[WOLFTPM2_BUFFER]()**  |
| struct | **[WOLFTPM2_CAPS]()**  |
| struct | **[TpmCryptoDevCtx]()**  |

### Types

|                | Name           |
| -------------- | -------------- |
| enum| **[WOLFTPM2_MFG](#enum-wolftpm2-mfg)** { TPM_MFG_UNKNOWN = 0, TPM_MFG_INFINEON, TPM_MFG_STM, TPM_MFG_MCHP, TPM_MFG_NUVOTON, TPM_MFG_NATIONTECH} |
| typedef struct [WOLFTPM2_SESSION](#typedef-wolftpm2-session)**  |
| typedef struct [WOLFTPM2_DEV](#typedef-wolftpm2-dev)**  |
| typedef struct [WOLFTPM2_KEY](#typedef-wolftpm2-key)**  |
| typedef struct [WOLFTPM2_KEYBLOB](#typedef-wolftpm2-keyblob)**  |
| typedef struct [WOLFTPM2_HASH](#typedef-wolftpm2-hash)**  |
| typedef struct [WOLFTPM2_NV](#typedef-wolftpm2-nv)**  |
| typedef struct [WOLFTPM2_HMAC](#typedef-wolftpm2-hmac)**  |
| typedef struct [WOLFTPM2_BUFFER](#typedef-wolftpm2-buffer)**  |
| typedef enum [WOLFTPM2_MFG](#typedef-wolftpm2-mfg)**  |
| typedef struct [WOLFTPM2_CAPS](#typedef-wolftpm2-caps)**  |
| typedef int(*)(wc_CryptoInfo *info, struct TpmCryptoDevCtx *ctx) | **[CheckWolfKeyCallbackFunc](#typedef-checkwolfkeycallbackfunc)**  |
| typedef struct [TpmCryptoDevCtx](#typedef-tpmcryptodevctx)**  |

### Functions

|                | Name           |
| -------------- | -------------- |
| WOLFTPM_API int | **[wolfTPM2_Test]() * caps)<br>Test initialization of a TPM and optionally the TPM capabilities can be received.  |
| WOLFTPM_API int | **[wolfTPM2_Init](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Complete initialization of a TPM.  |
| WOLFTPM_API int | **[wolfTPM2_OpenExisting](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Use an already initialized TPM, in its current TPM locality.  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup]() * dev)<br>Easy to use TPM and wolfcrypt deinitialization.  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup_ex]() * dev, int doShutdown)<br>Deinitialization of a TPM (and wolfcrypt if it was used)  |
| WOLFTPM_API int | **[wolfTPM2_GetTpmDevId]() * dev)<br>Provides the device ID of a TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SelfTest]() * dev)<br>Asks the TPM to perform its self test.  |
| WOLFTPM_API int | **[wolfTPM2_GetCapabilities]() * caps)<br>Reported the available TPM capabilities.  |
| WOLFTPM_API int | **[wolfTPM2_UnsetAuth]() * dev, int index)<br>Clears one of the TPM Authorization slots, pointed by its index number.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuth]() * name)<br>Sets a TPM Authorization slot using the provided index, session handle, attributes and auth.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthPassword](#typedef-tpm2b-auth) * auth)<br>Sets a TPM Authorization slot using the provided user auth, typically a password.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandle]() * dev, int index, const WOLFTPM2_HANDLE * handle)<br>Sets a TPM Authorization slot using the user auth associated with a wolfTPM2 Handle.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthSession](#typedef-tpma-session) sessionAttributes)<br>Sets a TPM Authorization slot using the provided TPM session handle, index and session attributes.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandleName]() * dev, int index, const WOLFTPM2_HANDLE * handle)<br>Updates the Name used in a TPM Session with the Name associated with wolfTPM2 Handle.  |
| WOLFTPM_API int | **[wolfTPM2_StartSession](#typedef-tpm-se) sesType, int encDecAlg)<br>Create a TPM session, Policy, HMAC or Trial.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAuthSession_EkPolicy]() * tpmSession)<br>Creates a TPM session with Policy Secret to satisfy the default EK policy.  |
| WOLFTPM_API int | **[wolfTPM2_CreatePrimaryKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to prepare and create a TPM 2.0 Primary Key.  |
| WOLFTPM_API int | **[wolfTPM2_ChangeAuthKey]() * key, WOLFTPM2_HANDLE * parent, const byte * auth, int authSz)<br>Change the authorization secret of a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_CreateKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to prepare and create a TPM 2.0 Key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadKey]() * keyBlob, WOLFTPM2_HANDLE * parent)<br>Single function to load a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to create and load a TPM 2.0 Key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_CreateLoadedKey]() * publicTemplate, const byte * auth, int authSz)<br>Creates and loads a key using single TPM 2.0 operation, and stores encrypted private key material.  |
| WOLFTPM_API int | **[wolfTPM2_LoadPublicKey]() * pub)<br>Wrapper to load the public part of an external key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadPrivateKey]() * sens)<br>Single function to import an external private key and load it into the TPM in one step.  |
| WOLFTPM_API int | **[wolfTPM2_ImportPrivateKey]() * sens)<br>Single function to import an external private key and load it into the TPM in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey]() * key, const byte * rsaPub, word32 rsaPubSz, word32 exponent)<br>Helper function to import the public part of an external RSA key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey_ex](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to import the public part of an external RSA key.  |
| WOLFTPM_API int | **[wolfTPM2_ImportRsaPrivateKey](#typedef-tpmi-alg-hash) hashAlg)<br>Import an external RSA private key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey]() * key, const byte * rsaPub, word32 rsaPubSz, word32 exponent, const byte * rsaPriv, word32 rsaPrivSz)<br>Helper function to import and load an external RSA private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey_ex](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to import and load an external RSA private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPublicKey]() * key, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz)<br>Helper function to import the public part of an external ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_ImportEccPrivateKey]() * keyBlob, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz, const byte * eccPriv, word32 eccPrivSz)<br>Helper function to import the private material of an external ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPrivateKey]() * key, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz, const byte * eccPriv, word32 eccPrivSz)<br>Helper function to import and load an external ECC private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_ReadPublicKey](#typedef-tpm-handle) handle)<br>Helper function to receive the public part of a loaded TPM object using its handle.  |
| WOLFTPM_API int | **[wolfTPM2_CreateKeySeal]() * publicTemplate, const byte * auth, int authSz, const byte * sealData, int sealSize)<br>Using this wrapper a secret can be sealed inside a TPM 2.0 Key.  |
| WOLFTPM_API int | **[wolfTPM2_ComputeName]() * out)<br>Helper function to generate a hash of the public area of an object in the format expected by the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SensitiveToPrivate]().  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToWolf]() * tpmKey, RsaKey * wolfKey)<br>Extract a RSA TPM key and convert it to a wolfcrypt key.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToPemPub]() * keyBlob, byte * pem, word32 * pemSz)<br>Convert a public RSA TPM key to PEM format public key Note: pem and tempBuf must be different buffers, of equal size.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm]() * tpmKey)<br>Import a RSA wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm_ex]() * tpmKey)<br>Import a RSA wolfcrypt key into the TPM under a specific Primary Key or Hierarchy.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_PubPemToTpm]() * tpmKey, const byte * pem, word32 pemSz)<br>Import a PEM format public key from a file into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_TpmToWolf]() * tpmKey, ecc_key * wolfKey)<br>Extract a ECC TPM key and convert to to a wolfcrypt key.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm]() * tpmKey)<br>Import a ECC wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm_ex]() * tpmKey)<br>Import ECC wolfcrypt key into the TPM under a specific Primary Key or Hierarchy.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToPubPoint]() * pubPoint)<br>Import a ECC public key generated from wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SignHash]() * key, const byte * digest, int digestSz, byte * sig, int * sigSz)<br>Helper function to sign arbitrary data using a TPM key.  |
| WOLFTPM_API int | **[wolfTPM2_SignHashScheme](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to sign arbitrary data using a TPM key, and specify the signature scheme and hashing algorithm.  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHash]() * key, const byte * sig, int sigSz, const byte * digest, int digestSz)<br>Helper function to verify a TPM generated signature.  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHash_ex](#function-wolftpm2-verifyhash-ex)**([WOLFTPM2_DEV]() * key, const byte * sig, int sigSz, const byte * digest, int digestSz, int hashAlg) |
| WOLFTPM_API int | **[wolfTPM2_VerifyHashScheme](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to verify a TPM generated signature.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenKey]() * ecdhKey, int curve_id, const byte * auth, int authSz)<br>Generates and then loads a ECC key-pair with NULL hierarchy for Diffie-Hellman exchange.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGen]() * pubPoint, byte * out, int * outSz)<br>Generates ephemeral key and computes Z (shared secret)  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenZ]() * pubPoint, byte * out, int * outSz)<br>Computes Z (shared secret) using pubPoint and loaded private ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenKey]() * ecdhKey, int curve_id)<br>Generates ephemeral ECC key and returns array index (2 phase method)  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenZ]() * pubPoint, byte * out, int * outSz)<br>Computes Z (shared secret) using pubPoint and counter (2 phase method)  |
| WOLFTPM_API int | **[wolfTPM2_RsaEncrypt](#typedef-tpm-alg-id) padScheme, const byte * msg, int msgSz, byte * out, int * outSz)<br>Perform RSA encryption using a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_RsaDecrypt](#typedef-tpm-alg-id) padScheme, const byte * in, int inSz, byte * msg, int * msgSz)<br>Perform RSA decryption using a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_ReadPCR]() * dev, int pcrIndex, int hashAlg, byte * digest, int * pDigestLen)<br>Read the values of a specified TPM 2.0 Platform Configuration Registers(PCR)  |
| WOLFTPM_API int | **[wolfTPM2_ExtendPCR]() * dev, int pcrIndex, int hashAlg, const byte * digest, int digestLen)<br>Extend a PCR register with a user provided digest.  |
| WOLFTPM_API int | **[wolfTPM2_NVCreateAuth]() * nv, word32 nvIndex, word32 nvAttributes, word32 maxSize, const byte * auth, int authSz)<br>Creates a new NV Index to be later used for storing data into the TPM's NVRAM.  |
| WOLFTPM_API int | **[wolfTPM2_NVWriteAuth]() * nv, word32 nvIndex, byte * dataBuf, word32 dataSz, word32 offset)<br>Stores user data to a NV Index, at a given offest.  |
| WOLFTPM_API int | **[wolfTPM2_NVReadAuth]() * nv, word32 nvIndex, byte * dataBuf, word32 * pDataSz, word32 offset)<br>Reads user data from a NV Index, starting at the given offset.  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteAuth]() * dev, WOLFTPM2_HANDLE * parent, word32 nvIndex)<br>Destroys an existing NV Index.  |
| WOLFTPM_API int | **[wolfTPM2_NVCreate](#typedef-tpm-handle) authHandle, word32 nvIndex, word32 nvAttributes, word32 maxSize, const byte * auth, int authSz)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVWrite](#typedef-tpm-handle) authHandle, word32 nvIndex, byte * dataBuf, word32 dataSz, word32 offset)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVRead](#typedef-tpm-handle) authHandle, word32 nvIndex, byte * dataBuf, word32 * dataSz, word32 offset)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVDelete](#typedef-tpm-handle) authHandle, word32 nvIndex)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVReadPublic]() * nvPublic)<br>Extracts the public information about an nvIndex, such as maximum size.  |
| WOLFTPM_API int | **[wolfTPM2_NVStoreKey](#typedef-tpm-handle) persistentHandle)<br>Helper function to store a TPM 2.0 Key into the TPM's NVRAM.  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteKey]() * key)<br>Helper function to delete a TPM 2.0 Key from the TPM's NVRAM.  |
| WOLFTPM_API struct WC_RNG * | **[wolfTPM2_GetRng]() * dev)<br>Get the wolfcrypt RNG instance used for wolfTPM.  |
| WOLFTPM_API int | **[wolfTPM2_GetRandom]() * dev, byte * buf, word32 len)<br>Get a set of random number, generated with the TPM RNG or wolfcrypt RNG.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandle]() * dev, WOLFTPM2_HANDLE * handle)<br>Use to discard any TPM loaded object.  |
| WOLFTPM_API int | **[wolfTPM2_Clear]() * dev)<br>Deinitializes wolfTPM and wolfcrypt(if enabled)  |
| WOLFTPM_API int | **[wolfTPM2_HashStart](#typedef-tpmi-alg-hash) hashAlg, const byte * usageAuth, word32 usageAuthSz)<br>Helper function to start a TPM generated hash.  |
| WOLFTPM_API int | **[wolfTPM2_HashUpdate]() * hash, const byte * data, word32 dataSz)<br>Update a TPM generated hash with new user data.  |
| WOLFTPM_API int | **[wolfTPM2_HashFinish]() * hash, byte * digest, word32 * digestSz)<br>Finalize a TPM generated hash and get the digest output in a user buffer.  |
| WOLFTPM_API int | **[wolfTPM2_LoadKeyedHashKey]() * key, WOLFTPM2_HANDLE * parent, int hashAlg, const byte * keyBuf, word32 keySz, const byte * usageAuth, word32 usageAuthSz)<br>Creates and loads a new TPM key of KeyedHash type, typically used for HMAC operations.  |
| WOLFTPM_API int | **[wolfTPM2_HmacStart](#typedef-tpmi-alg-hash) hashAlg, const byte * keyBuf, word32 keySz, const byte * usageAuth, word32 usageAuthSz)<br>Helper function to start a TPM generated hmac.  |
| WOLFTPM_API int | **[wolfTPM2_HmacUpdate]() * hmac, const byte * data, word32 dataSz)<br>Update a TPM generated hmac with new user data.  |
| WOLFTPM_API int | **[wolfTPM2_HmacFinish]() * hmac, byte * digest, word32 * digestSz)<br>Finalize a TPM generated hmac and get the digest output in a user buffer.  |
| WOLFTPM_API int | **[wolfTPM2_LoadSymmetricKey]() * key, int alg, const byte * keyBuf, word32 keySz)<br>Loads an external symmetric key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_EncryptDecryptBlock](#function-wolftpm2-encryptdecryptblock)**([WOLFTPM2_DEV]() * key, const byte * in, byte * out, word32 inOutSz, byte * iv, word32 ivSz, int isDecrypt) |
| WOLFTPM_API int | **[wolfTPM2_EncryptDecrypt](#function-wolftpm2-encryptdecrypt)**([WOLFTPM2_DEV]() * key, const byte * in, byte * out, word32 inOutSz, byte * iv, word32 ivSz, int isDecrypt) |
| WOLFTPM_API int | **[wolfTPM2_SetCommand](#typedef-tpm-cc) commandCode, int enableFlag)<br>Vendor specific TPM command, used to enable other restricted TPM commands.  |
| WOLFTPM_API int | **[wolfTPM2_Shutdown]() * dev, int doStartup)<br>Helper function to shutdown or reset the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles]() * dev, word32 handleStart, word32 handleCount)<br>One-shot API to unload subsequent TPM handles.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles_AllTransient]() * dev)<br>One-shot API to unload all transient TPM handles.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA](#typedef-tpma-object) objectAttributes)<br>Prepares a TPM public template for new RSA key based on user selected object attributes.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC](#typedef-tpm-alg-id) sigScheme)<br>Prepares a TPM public template for new ECC key based on user selected object attributes.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_Symmetric](#typedef-tpm-alg-id) algMode, int isSign, int isDecrypt)<br>Prepares a TPM public template for new Symmetric key.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeyedHash](#typedef-tpm-alg-id) hashAlg, int isSign, int isDecrypt)<br>Prepares a TPM public template for new KeyedHash key.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeySeal](#typedef-tpm-alg-id) nameAlg)<br>Prepares a TPM public template for new key for sealing secrets.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_EK]() * publicTemplate)<br>Prepares a TPM public template for generating the TPM Endorsement Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_EK]() * publicTemplate)<br>Prepares a TPM public template for generating the TPM Endorsement Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_SRK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Storage Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_SRK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Storage Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_AIK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Attestation Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_AIK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Attestation Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetNvAttributesTemplate](#typedef-tpm-handle) auth, word32 * nvAttributes)<br>Prepares a TPM NV Index template.  |
| WOLFTPM_API int | **[wolfTPM2_CreateEK](#typedef-tpm-alg-id) alg)<br>Generates a new TPM Endorsement key, based on the user selected algorithm, RSA or ECC.  |
| WOLFTPM_API int | **[wolfTPM2_CreateSRK](#typedef-tpm-alg-id) alg, const byte * auth, int authSz)<br>Generates a new TPM Primary Key that will be used as a Storage Key for other TPM keys.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadAIK]() * srkKey, const byte * auth, int authSz)<br>Generates a new TPM Attestation Key under the provided Storage Key.  |
| WOLFTPM_API int | **[wolfTPM2_GetTime]() * getTimeOut)<br>One-shot API to generate a TPM signed timestamp.  |
| WOLFTPM_LOCAL int | **[wolfTPM2_RSA_Salt](#function-wolftpm2-rsa-salt)**(struct [WOLFTPM2_DEV]() * publicArea) |
| WOLFTPM_LOCAL int | **[wolfTPM2_EncryptSalt](#typedef-tpm2b-auth) * bindAuth, [TPM2B_DIGEST]() * salt) |
| WOLFTPM_API int | **[wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)**(int devId, wc_CryptoInfo * info, void * ctx)<br>A reference crypto callback API for using the TPM for crypto offload. This callback function is registered using wolfTPM2_SetCryptoDevCb or wc_CryptoDev_RegisterDevice.  |
| WOLFTPM_API int | **[wolfTPM2_SetCryptoDevCb]() * tpmCtx, int * pDevId)<br>Register a crypto callback function and return assigned devId.  |
| WOLFTPM_API int | **[wolfTPM2_ClearCryptoDevCb]() * dev, int devId)<br>Clears the registered crypto callback.  |

### Attributes

|                | Name           |
| -------------- | -------------- |
| | **[C](#variable-c)**  |

### Types Documentation

#### enum WOLFTPM2_MFG

| Enumerator | Value | Description |
| ---------- | ----- | ----------- |
| TPM_MFG_UNKNOWN | 0|   |
| TPM_MFG_INFINEON | |   |
| TPM_MFG_STM | |   |
| TPM_MFG_MCHP | |   |
| TPM_MFG_NUVOTON | |   |
| TPM_MFG_NATIONTECH | |   |




#### typedef WOLFTPM2_SESSION

```cpp
typedef struct WOLFTPM2_SESSION WOLFTPM2_SESSION;
```


#### typedef WOLFTPM2_DEV

```cpp
typedef struct WOLFTPM2_DEV WOLFTPM2_DEV;
```


#### typedef WOLFTPM2_KEY

```cpp
typedef struct WOLFTPM2_KEY WOLFTPM2_KEY;
```


#### typedef WOLFTPM2_KEYBLOB

```cpp
typedef struct WOLFTPM2_KEYBLOB WOLFTPM2_KEYBLOB;
```


#### typedef WOLFTPM2_HASH

```cpp
typedef struct WOLFTPM2_HASH WOLFTPM2_HASH;
```


#### typedef WOLFTPM2_NV

```cpp
typedef struct WOLFTPM2_NV WOLFTPM2_NV;
```


#### typedef WOLFTPM2_HMAC

```cpp
typedef struct WOLFTPM2_HMAC WOLFTPM2_HMAC;
```


#### typedef WOLFTPM2_BUFFER

```cpp
typedef struct WOLFTPM2_BUFFER WOLFTPM2_BUFFER;
```


#### typedef WOLFTPM2_MFG

```cpp
typedef enum WOLFTPM2_MFG WOLFTPM2_MFG;
```


#### typedef WOLFTPM2_CAPS

```cpp
typedef struct WOLFTPM2_CAPS WOLFTPM2_CAPS;
```


#### typedef CheckWolfKeyCallbackFunc

```cpp
typedef int(* CheckWolfKeyCallbackFunc) (wc_CryptoInfo *info, struct TpmCryptoDevCtx *ctx);
```


#### typedef TpmCryptoDevCtx

```cpp
typedef struct TpmCryptoDevCtx TpmCryptoDevCtx;
```



### Functions Documentation

#### function wolfTPM2_Test

```cpp
WOLFTPM_API int wolfTPM2_Test(
    TPM2HalIoCb ioCb,
    void * userCtx,
    WOLFTPM2_CAPS * caps
)
```

Test initialization of a TPM and optionally the TPM capabilities can be received. 

**Parameters**: 

  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL) 
  * **caps** to a structure of [WOLFTPM2_CAPS]() type for returning the TPM capabilities (can be NULL)


**See**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Init

```cpp
WOLFTPM_API int wolfTPM2_Init(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Complete initialization of a TPM. 

**Parameters**: 

  * **dev** pointer to an empty structure of [WOLFTPM2_DEV]() type 
  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL)


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;
WOLFTPM2_DEV dev;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Init failed
    goto exit;
}
```


#### function wolfTPM2_OpenExisting

```cpp
WOLFTPM_API int wolfTPM2_OpenExisting(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Use an already initialized TPM, in its current TPM locality. 

**Parameters**: 

  * **dev** pointer to an empty structure of [WOLFTPM2_DEV]() type 
  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL)


**See**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Cleanup

```cpp
WOLFTPM_API int wolfTPM2_Cleanup(
    WOLFTPM2_DEV * dev
)
```

Easy to use TPM and wolfcrypt deinitialization. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Calls wolfTPM2_Cleanup_ex with appropriate doShutdown parameter

_Example_

```cpp
int rc;

rc = wolfTPM2_Cleanup(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup failed
    goto exit;
}
```


#### function wolfTPM2_Cleanup_ex

```cpp
WOLFTPM_API int wolfTPM2_Cleanup_ex(
    WOLFTPM2_DEV * dev,
    int doShutdown
)
```

Deinitialization of a TPM (and wolfcrypt if it was used) 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type 
  * **doShutdown** flag value, if true a TPM2_Shutdown command will be executed


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_Cleanup_ex(&dev, 1);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```


#### function wolfTPM2_GetTpmDevId

```cpp
WOLFTPM_API int wolfTPM2_GetTpmDevId(
    WOLFTPM2_DEV * dev
)
```

Provides the device ID of a TPM. 

**Parameters**: 

  * **dev** pointer to an populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_GetCapabilities](#function-wolftpm2-getcapabilities)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * an integer value of a valid TPM device ID 
  * or INVALID_DEVID if the TPM initialization could not extract DevID


_Example_

```cpp
int tpmDevId;

tpmDevId = wolfTPM2_GetTpmDevId(&dev);
if (tpmDevId != INVALID_DEVID) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```


#### function wolfTPM2_SelfTest

```cpp
WOLFTPM_API int wolfTPM2_SelfTest(
    WOLFTPM2_DEV * dev
)
```

Asks the TPM to perform its self test. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_SelfTest(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_SelfTest failed
    goto exit;
}
```


#### function wolfTPM2_GetCapabilities

```cpp
WOLFTPM_API int wolfTPM2_GetCapabilities(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CAPS * caps
)
```

Reported the available TPM capabilities. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type 
  * **caps** pointer to an empty structure of [WOLFTPM2_CAPS]() type to store the capabilities


**See**: 

  * [wolfTPM2_GetTpmDevId](#function-wolftpm2-gettpmdevid)
  * [wolfTPM2_SelfTest](#function-wolftpm2-selftest)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;
WOLFTPM2_CAPS caps;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_GetCapabilities(&dev, &caps);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_GetCapabilities failed
    goto exit;
}
```


#### function wolfTPM2_UnsetAuth

```cpp
WOLFTPM_API int wolfTPM2_UnsetAuth(
    WOLFTPM2_DEV * dev,
    int index
)
```

Clears one of the TPM Authorization slots, pointed by its index number. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: unable to get lock on the TPM2 Context 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_SetAuth

```cpp
WOLFTPM_API int wolfTPM2_SetAuth(
    WOLFTPM2_DEV * dev,
    int index,
    TPM_HANDLE sessionHandle,
    const TPM2B_AUTH * auth,
    TPMA_SESSION sessionAttributes,
    const TPM2B_NAME * name
)
```

Sets a TPM Authorization slot using the provided index, session handle, attributes and auth. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **sessionHandle** integer value of TPM_HANDLE type 
  * **auth** pointer to a structure of type TPM2B_AUTH containing one TPM Authorization 
  * **sessionAttributes** integer value of type TPMA_SESSION, selecting one or more attributes for the Session 
  * **name** pointer to a [TPM2B_NAME]() structure


**See**: 

  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: It is recommended to use one of the other wolfTPM2 wrappers, like wolfTPM2_SetAuthPassword. Because the wolfTPM2_SetAuth wrapper provides complete control over the TPM Authorization slot for advanced use cases. In most scenarios, wolfTPM2_SetAuthHandle and SetAuthPassword are used.

#### function wolfTPM2_SetAuthPassword

```cpp
WOLFTPM_API int wolfTPM2_SetAuthPassword(
    WOLFTPM2_DEV * dev,
    int index,
    const TPM2B_AUTH * auth
)
```

Sets a TPM Authorization slot using the provided user auth, typically a password. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **auth** pointer to a structure of type TPM2B_AUTH, typically containing a TPM Key Auth


**See**: 

  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Often used for authorizing the loading and use of TPM keys, including Primary Keys

#### function wolfTPM2_SetAuthHandle

```cpp
WOLFTPM_API int wolfTPM2_SetAuthHandle(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

Sets a TPM Authorization slot using the user auth associated with a wolfTPM2 Handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **handle** pointer to a populated structure of WOLFTPM2_HANDLE type


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper is especially useful when using a TPM key for multiple operations and TPM Authorization is required again.

#### function wolfTPM2_SetAuthSession

```cpp
WOLFTPM_API int wolfTPM2_SetAuthSession(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_SESSION * tpmSession,
    TPMA_SESSION sessionAttributes
)
```

Sets a TPM Authorization slot using the provided TPM session handle, index and session attributes. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **tpmSession** sessionHandle integer value of TPM_HANDLE type 
  * **sessionAttributes** integer value of type TPMA_SESSION, selecting one or more attributes for the Session


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper is useful for configuring TPM sessions, e.g. session for parameter encryption

#### function wolfTPM2_SetAuthHandleName

```cpp
WOLFTPM_API int wolfTPM2_SetAuthHandleName(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

Updates the Name used in a TPM Session with the Name associated with wolfTPM2 Handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **handle** pointer to a populated structure of WOLFTPM2_HANDLE type


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Typically, this wrapper is used from another wrappers and in very specific use cases. For example, wolfTPM2_NVWriteAuth

#### function wolfTPM2_StartSession

```cpp
WOLFTPM_API int wolfTPM2_StartSession(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * session,
    WOLFTPM2_KEY * tpmKey,
    WOLFTPM2_HANDLE * bind,
    TPM_SE sesType,
    int encDecAlg
)
```

Create a TPM session, Policy, HMAC or Trial. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **session** pointer to an empty [WOLFTPM2_SESSION]() struct 
  * **tpmKey** pointer to a [WOLFTPM2_KEY]() that will be used as a salt for the session 
  * **bind** pointer to a WOLFTPM2_HANDLE that will be used to make the session bounded 
  * **sesType** byte value, the session type (HMAC, Policy or Trial) 
  * **encDecAlg** integer value, specifying the algorithm in case of parameter encryption


**See**: [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper can also be used to start TPM session for parameter encryption, see wolfTPM nvram or keygen example

#### function wolfTPM2_CreateAuthSession_EkPolicy

```cpp
WOLFTPM_API int wolfTPM2_CreateAuthSession_EkPolicy(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * tpmSession
)
```

Creates a TPM session with Policy Secret to satisfy the default EK policy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **session** pointer to an empty [WOLFTPM2_SESSION]() struct


**See**: 

  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * wolfTPM2_StartAuthSession 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments 
  * TPM_RC_FAILURE: check TPM return code, check available handles, check TPM IO


**Note**: This wrapper can be used only if the EK authorization is not changed from default

#### function wolfTPM2_CreatePrimaryKey

```cpp
WOLFTPM_API int wolfTPM2_CreatePrimaryKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_HANDLE primaryHandle,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to prepare and create a TPM 2.0 Primary Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **primaryHandle** integer value, specifying one of four TPM 2.0 Primary Seeds: TPM_RH_OWNER, TPM_RH_ENDORSEMENT, TPM_RH_PLATFORM or TPM_RH_NULL 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization for the Primary Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: TPM 2.0 allows only asymmetric RSA or ECC primary keys. Afterwards, both symmetric and asymmetric keys can be created under a TPM 2.0 Primary Key Typically, Primary Keys are used to create Hierarchies of TPM 2.0 Keys. The TPM uses a Primary Key to wrap the other keys, signing or decrypting.

#### function wolfTPM2_ChangeAuthKey

```cpp
WOLFTPM_API int wolfTPM2_ChangeAuthKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    const byte * auth,
    int authSz
)
```

Change the authorization secret of a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_UnloadHandle](#function-wolftpm2-unloadhandle)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: TPM does not allow the authorization secret of a Primary Key to be changed. Instead, use wolfTPM2_CreatePrimary to create the same PrimaryKey with a new auth.

#### function wolfTPM2_CreateKey

```cpp
WOLFTPM_API int wolfTPM2_CreateKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to prepare and create a TPM 2.0 Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying the a 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This function only creates the key material and stores it into the keyblob argument. To load the key use wolfTPM2_LoadKey

#### function wolfTPM2_LoadKey

```cpp
WOLFTPM_API int wolfTPM2_LoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent
)
```

Single function to load a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to a struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key)


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: To load a TPM 2.0 key its parent(Primary Key) should also be loaded prior to this operation. Primary Keys are laoded when they are created.

#### function wolfTPM2_CreateAndLoadKey

```cpp
WOLFTPM_API int wolfTPM2_CreateAndLoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to create and load a TPM 2.0 Key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_CreateLoadedKey

```cpp
WOLFTPM_API int wolfTPM2_CreateLoadedKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Creates and loads a key using single TPM 2.0 operation, and stores encrypted private key material. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type, contains private key material as encrypted data 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateAndLoadKey](#function-wolftpm2-createandloadkey)
  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadPublicKey

```cpp
WOLFTPM_API int wolfTPM2_LoadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub
)
```

Wrapper to load the public part of an external key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * wolfTPM2_wolfTPM2_LoadPrivateKey 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The key must be formated to the format expected by the TPM, see the 'pub' argument and the alternative wrappers.

#### function wolfTPM2_LoadPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_LoadPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

Single function to import an external private key and load it into the TPM in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **sens** pointer to a populated structure of [TPM2B_SENSITIVE]() type


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The private key material needs to be prepared in a format that the TPM expects, see the 'sens' argument

#### function wolfTPM2_ImportPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_ImportPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

Single function to import an external private key and load it into the TPM in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **sens** pointer to a populated structure of [TPM2B_SENSITIVE]() type


**See**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The primary key material needs to be prepared in a format that the TPM expects, see the 'sens' argument

#### function wolfTPM2_LoadRsaPublicKey

```cpp
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent
)
```

Helper function to import the public part of an external RSA key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer containing the public key material 
  * **rsaPubSz** integer value of word32 type, specifying the buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent


**See**: 

  * [wolfTPM2_LoadRsaPublicKey_ex](#function-wolftpm2-loadrsapublickey-ex)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Recommended for use, because it does not require TPM format of the public part

#### function wolfTPM2_LoadRsaPublicKey_ex

```cpp
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to import the public part of an external RSA key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer containing the public key material 
  * **rsaPubSz** integer value of word32 type, specifying the buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** value of TPMI_ALG_HASH type, specifying the TPM hashing algorithm


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the developer to specify TPM hashing algorithm and RSA scheme

#### function wolfTPM2_ImportRsaPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_ImportRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Import an external RSA private key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments 
  * BUFFER_E: arguments size is larger than what the TPM buffers allow


#### function wolfTPM2_LoadRsaPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz
)
```

Helper function to import and load an external RSA private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size


**See**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadRsaPrivateKey_ex

```cpp
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to import and load an external RSA private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** value of TPMI_ALG_HASH type, specifying the TPM hashing algorithm


**See**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)
  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadEccPublicKey

```cpp
WOLFTPM_API int wolfTPM2_LoadEccPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz
)
```

Helper function to import the public part of an external ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size


**See**: 

  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Recommended for use, because it does not require TPM format of the public part

#### function wolfTPM2_ImportEccPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_ImportEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

Helper function to import the private material of an external ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size 
  * **eccPriv** pointer to a byte buffer containing the private material 
  * **eccPrivSz** integer value of word32 type, specifying the private material size


**See**: 

  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)
  * wolfTPM2_LoadEccPrivateKey_ex 
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadEccPrivateKey

```cpp
WOLFTPM_API int wolfTPM2_LoadEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

Helper function to import and load an external ECC private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size 
  * **eccPriv** pointer to a byte buffer containing the private material 
  * **eccPrivSz** integer value of word32 type, specifying the private material size


**See**: 

  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ReadPublicKey

```cpp
WOLFTPM_API int wolfTPM2_ReadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM_HANDLE handle
)
```

Helper function to receive the public part of a loaded TPM object using its handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **handle** integer value of TPM_HANDLE type, specifying handle of a loaded TPM object


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The public part of a TPM symmetric keys contains just TPM meta data

#### function wolfTPM2_CreateKeySeal

```cpp
WOLFTPM_API int wolfTPM2_CreateKeySeal(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz,
    const byte * sealData,
    int sealSize
)
```

Using this wrapper a secret can be sealed inside a TPM 2.0 Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying the a 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated using one of the wolfTPM2_GetKeyTemplate_KeySeal 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes 
  * **sealData** pointer to a byte buffer, containing the secret(user data) to be sealed 
  * **sealSize** integer value, specifying the size of the seal buffer, in bytes


**See**: 

  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)
  * [TPM2_Unseal](#function-tpm2-unseal)
  * wolfTPM2_CreatePrimary 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The secret size can not be larger than 128 bytes

#### function wolfTPM2_ComputeName

```cpp
WOLFTPM_API int wolfTPM2_ComputeName(
    const TPM2B_PUBLIC * pub,
    TPM2B_NAME * out
)
```

Helper function to generate a hash of the public area of an object in the format expected by the TPM. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type, containing the public area of a TPM object 
  * **out** pointer to an empty struct of [TPM2B_NAME]() type, to store the computed name


**See**: [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Computed TPM name includes hash of the TPM_ALG_ID and the public are of the object

#### function wolfTPM2_SensitiveToPrivate

```cpp
WOLFTPM_API int wolfTPM2_SensitiveToPrivate(
    TPM2B_SENSITIVE * sens,
    TPM2B_PRIVATE * priv,
    TPMI_ALG_HASH nameAlg,
    TPM2B_NAME * name,
    const WOLFTPM2_KEY * parentKey,
    TPMT_SYM_DEF_OBJECT * sym,
    TPM2B_ENCRYPTED_SECRET * symSeed
)
```

Helper function to convert [TPM2B_SENSITIVE](). 

**Parameters**: 

  * **sens** pointer to a correctly populated structure of [TPM2B_SENSITIVE]() type 
  * **priv** pointer to an empty struct of [TPM2B_PRIVATE]() type 
  * **nameAlg** integer value of TPMI_ALG_HASH type, specifying a valid TPM2 hashing algorithm 
  * **name** pointer to a [TPM2B_NAME]() structure 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() structure, specifying a parentKey, if it exists 
  * **sym** pointer to a structure of TPMT_SYM_DEF_OBJECT type 
  * **symSeed** pointer to a structure of [TPM2B_ENCRYPTED_SECRET]() type


**See**: [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_TpmToWolf

```cpp
WOLFTPM_API int wolfTPM2_RsaKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    RsaKey * wolfKey
)
```

Extract a RSA TPM key and convert it to a wolfcrypt key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **wolfKey** pointer to an empty struct of RsaKey type, to store the converted key


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_WolfToTpm_ex](#function-wolftpm2-rsakey-wolftotpm-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_TpmToPemPub

```cpp
WOLFTPM_API int wolfTPM2_RsaKey_TpmToPemPub(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * keyBlob,
    byte * pem,
    word32 * pemSz
)
```

Convert a public RSA TPM key to PEM format public key Note: pem and tempBuf must be different buffers, of equal size. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **pem** pointer to an array of byte type, used as temporary storage for PEM conversation 
  * **pemSz** pointer to integer variable, to store the used buffer size


**See**: 

  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)
  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_WolfToTpm

```cpp
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a RSA wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of RsaKey type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated keys by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_RsaKey_WolfToTpm_ex

```cpp
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a RSA wolfcrypt key into the TPM under a specific Primary Key or Hierarchy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() struct, pointing to a Primary Key or TPM Hierarchy 
  * **wolfKey** pointer to a struct of RsaKey type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of wolfcrypt generated keys with wolfTPM

#### function wolfTPM2_RsaKey_PubPemToTpm

```cpp
WOLFTPM_API int wolfTPM2_RsaKey_PubPemToTpm(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    const byte * pem,
    word32 pemSz
)
```

Import a PEM format public key from a file into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key 
  * **pem** pointer to an array of byte type, containing a PEM formated public key material 
  * **pemSz** pointer to integer variable, specifying the size of PEM key data


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * wolfTPM2_RsaKey_TpmToPem 
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code)


#### function wolfTPM2_EccKey_TpmToWolf

```cpp
WOLFTPM_API int wolfTPM2_EccKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    ecc_key * wolfKey
)
```

Extract a ECC TPM key and convert to to a wolfcrypt key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **wolfKey** pointer to an empty struct of ecc_key type, to store the converted key


**See**: 

  * [wolfTPM2_EccKey_WolfToTpm](#function-wolftpm2-ecckey-wolftotpm)
  * [wolfTPM2_EccKey_WolfToTpm_ex](#function-wolftpm2-ecckey-wolftotpm-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_EccKey_WolfToTpm

```cpp
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a ECC wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated keys by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_EccKey_WolfToTpm_ex

```cpp
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import ECC wolfcrypt key into the TPM under a specific Primary Key or Hierarchy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() struct, pointing to a Primary Key or TPM Hierarchy 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: 

  * wolfTPM2_EccKey_WolfToTPM 
  * [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of wolfcrypt generated keys with wolfTPM

#### function wolfTPM2_EccKey_WolfToPubPoint

```cpp
WOLFTPM_API int wolfTPM2_EccKey_WolfToPubPoint(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    TPM2B_ECC_POINT * pubPoint
)
```

Import a ECC public key generated from wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt public ECC key 
  * **pubPoint** pointer to an empty struct of [TPM2B_ECC_POINT]() type


**See**: [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated public ECC key by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_SignHash

```cpp
WOLFTPM_API int wolfTPM2_SignHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz
)
```

Helper function to sign arbitrary data using a TPM key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **digest** pointer to a byte buffer, containing the arbitrary data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes


**See**: 

  * verifyHash 
  * signHashScheme 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_SignHashScheme

```cpp
WOLFTPM_API int wolfTPM2_SignHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to sign arbitrary data using a TPM key, and specify the signature scheme and hashing algorithm. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **digest** pointer to a byte buffer, containing the arbitrary data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **sigAlg** integer value of TPMI_ALG_SIG_SCHEME type, specifying a supported TPM 2.0 signature scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * signHash 
  * verifyHash 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_VerifyHash

```cpp
WOLFTPM_API int wolfTPM2_VerifyHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz
)
```

Helper function to verify a TPM generated signature. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM 2.0 key material 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **digest** pointer to a byte buffer, containing the signed data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes


**See**: 

  * signHash 
  * signHashScheme 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_VerifyHash_ex

```cpp
WOLFTPM_API int wolfTPM2_VerifyHash_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz,
    int hashAlg
)
```


#### function wolfTPM2_VerifyHashScheme

```cpp
WOLFTPM_API int wolfTPM2_VerifyHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to verify a TPM generated signature. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM 2.0 key material 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **digest** pointer to a byte buffer, containing the signed data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sigAlg** integer value of TPMI_ALG_SIG_SCHEME type, specifying a supported TPM 2.0 signature scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * signHash 
  * signHashScheme 
  * verifyHash 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHGenKey

```cpp
WOLFTPM_API int wolfTPM2_ECDHGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id,
    const byte * auth,
    int authSz
)
```

Generates and then loads a ECC key-pair with NULL hierarchy for Diffie-Hellman exchange. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ecdhKey** pointer to an empty structure of [WOLFTPM2_KEY]() type 
  * **curve_id** integer value, specifying a valid TPM_ECC_CURVE value 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHGen

```cpp
WOLFTPM_API int wolfTPM2_ECDHGen(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Generates ephemeral key and computes Z (shared secret) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **privKey** pointer to a structure of [WOLFTPM2_KEY]() type 
  * **pubPoint** pointer to an empty structure of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the generated shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: One shot API using private key handle to generate key-pair and return public point and shared secret

#### function wolfTPM2_ECDHGenZ

```cpp
WOLFTPM_API int wolfTPM2_ECDHGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Computes Z (shared secret) using pubPoint and loaded private ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **privKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle 
  * **pubPoint** pointer to a populated structure of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the computed shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHEGenKey

```cpp
WOLFTPM_API int wolfTPM2_ECDHEGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id
)
```

Generates ephemeral ECC key and returns array index (2 phase method) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ecdhKey** pointer to an empty structure of [WOLFTPM2_KEY]() type 
  * **curve_id** integer value, specifying a valid TPM_ECC_CURVE value


**See**: 

  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: One time use key

#### function wolfTPM2_ECDHEGenZ

```cpp
WOLFTPM_API int wolfTPM2_ECDHEGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * ecdhKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Computes Z (shared secret) using pubPoint and counter (2 phase method) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **ecdhKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle 
  * **pubPoint** pointer to an empty struct of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the computed shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The counter, array ID, can only be used one time

#### function wolfTPM2_RsaEncrypt

```cpp
WOLFTPM_API int wolfTPM2_RsaEncrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * msg,
    int msgSz,
    byte * out,
    int * outSz
)
```

Perform RSA encryption using a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **padScheme** integer value of TPM_ALG_ID type, specifying the padding scheme 
  * **msg** pointer to a byte buffer, containing the arbitrary data for encryption 
  * **msgSz** integer value, specifying the size of the arbitrary data buffer 
  * **out** pointer to a byte buffer, where the encrypted data will be stored 
  * **outSz** integer value, specifying the size of the encrypted data buffer


**See**: [wolfTPM2_RsaDecrypt](#function-wolftpm2-rsadecrypt)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaDecrypt

```cpp
WOLFTPM_API int wolfTPM2_RsaDecrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * in,
    int inSz,
    byte * msg,
    int * msgSz
)
```

Perform RSA decryption using a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **padScheme** integer value of TPM_ALG_ID type, specifying the padding scheme 
  * **in** pointer to a byte buffer, containing the encrypted data 
  * **inSz** integer value, specifying the size of the encrypted data buffer 
  * **msg** pointer to a byte buffer, containing the decrypted data 
  * **msgSz** pointer to size of the encrypted data buffer, on return set actual size


**See**: wolfTPM2_RsaEcnrypt 

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ReadPCR

```cpp
WOLFTPM_API int wolfTPM2_ReadPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    byte * digest,
    int * pDigestLen
)
```

Read the values of a specified TPM 2.0 Platform Configuration Registers(PCR) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **pcrIndex** integer value, specifying a valid PCR index, between 0 and 23 (TPM locality could have an impact on successful access) 
  * **hashAlg** integer value, specifying a TPM_ALG_SHA256 or TPM_ALG_SHA1 registers to be accessed 
  * **digest** pointer to a byte buffer, where the PCR values will be stored 
  * **pDigestLen** pointer to an integer variable, where the size of the digest buffer will be stored


**See**: [wolfTPM2_ExtendPCR](#function-wolftpm2-extendpcr)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure to specify the correct hashing algorithm, because there are two sets of PCR registers, one for SHA256 and the other for SHA1(deprecated, but still possible to be read)

#### function wolfTPM2_ExtendPCR

```cpp
WOLFTPM_API int wolfTPM2_ExtendPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    const byte * digest,
    int digestLen
)
```

Extend a PCR register with a user provided digest. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **pcrIndex** integer value, specifying a valid PCR index, between 0 and 23 (TPM locality could have an impact on successful access) 
  * **hashAlg** integer value, specifying a TPM_ALG_SHA256 or TPM_ALG_SHA1 registers to be accessed 
  * **digest** pointer to a byte buffer, containing the digest value to be extended into the PCR 
  * **digestLen** the size of the digest buffer


**See**: [wolfTPM2_ReadPCR](#function-wolftpm2-readpcr)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure to specify the correct hashing algorithm

#### function wolfTPM2_NVCreateAuth

```cpp
WOLFTPM_API int wolfTPM2_NVCreateAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

Creates a new NV Index to be later used for storing data into the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parent** pointer to a WOLFTPM2_HANDLE, specifying the TPM hierarchy for the new NV Index 
  * **nv** pointer to an empty structure of [WOLFTPM2_NV]() type, to hold the new NV Index 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success 
  * **nvAttributes** integer value, use wolfTPM2_GetNvAttributesTemplate to create correct value 
  * **maxSize** integer value, specifying the maximum number of bytes written at this NV Index 
  * **auth** pointer to a string constant, specifying the password authorization for this NV Index 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This is a wolfTPM2 wrapper around TPM2_NV_DefineSpace

#### function wolfTPM2_NVWriteAuth

```cpp
WOLFTPM_API int wolfTPM2_NVWriteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

Stores user data to a NV Index, at a given offest. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nv** pointer to a populated structure of [WOLFTPM2_NV]() type 
  * **nvIndex** integer value, holding an existing NV Index Handle value 
  * **dataBuf** pointer to a byte buffer, containing the user data to be written to the TPM's NVRAM 
  * **dataSz** integer value, specifying the size of the user data buffer, in bytes 
  * **offset** integer value of word32 type, specifying the offset from the NV Index memory start, can be zero


**See**: 

  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: User data size should be less or equal to the NV Index maxSize specified using wolfTPM2_CreateAuth

#### function wolfTPM2_NVReadAuth

```cpp
WOLFTPM_API int wolfTPM2_NVReadAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 * pDataSz,
    word32 offset
)
```

Reads user data from a NV Index, starting at the given offset. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nv** pointer to a populated structure of [WOLFTPM2_NV]() type 
  * **nvIndex** integer value, holding an existing NV Index Handle value 
  * **dataBuf** pointer to an empty byte buffer, used to store the read data from the TPM's NVRAM 
  * **pDataSz** pointer to an integer variable, used to store the size of the data read from NVRAM, in bytes 
  * **offset** integer value of word32 type, specifying the offset from the NV Index memory start, can be zero


**See**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: User data size should be less or equal to the NV Index maxSize specified using wolfTPM2_CreateAuth

#### function wolfTPM2_NVDeleteAuth

```cpp
WOLFTPM_API int wolfTPM2_NVDeleteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    word32 nvIndex
)
```

Destroys an existing NV Index. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parent** pointer to a WOLFTPM2_HANDLE, specifying the TPM hierarchy for the new NV Index 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success


**See**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVCreate

```cpp
WOLFTPM_API int wolfTPM2_NVCreate(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)

#### function wolfTPM2_NVWrite

```cpp
WOLFTPM_API int wolfTPM2_NVWrite(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)

#### function wolfTPM2_NVRead

```cpp
WOLFTPM_API int wolfTPM2_NVRead(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 * dataSz,
    word32 offset
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)

#### function wolfTPM2_NVDelete

```cpp
WOLFTPM_API int wolfTPM2_NVDelete(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)

#### function wolfTPM2_NVReadPublic

```cpp
WOLFTPM_API int wolfTPM2_NVReadPublic(
    WOLFTPM2_DEV * dev,
    word32 nvIndex,
    TPMS_NV_PUBLIC * nvPublic
)
```

Extracts the public information about an nvIndex, such as maximum size. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success 
  * **nvPublic** pointer to a [TPMS_NV_PUBLIC](), used to store the extracted nvIndex public information


**See**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVStoreKey

```cpp
WOLFTPM_API int wolfTPM2_NVStoreKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key,
    TPM_HANDLE persistentHandle
)
```

Helper function to store a TPM 2.0 Key into the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **primaryHandle** integer value, specifying a TPM 2.0 Hierarchy. typically TPM_RH_OWNER 
  * **key** pointer to a structure of [WOLFTPM2_KEY]() type, containing the TPM 2.0 key for storing 
  * **persistentHandle** integer value, specifying an existing nvIndex


**See**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVDeleteKey

```cpp
WOLFTPM_API int wolfTPM2_NVDeleteKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key
)
```

Helper function to delete a TPM 2.0 Key from the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **primaryHandle** integer value, specifying a TPM 2.0 Hierarchy. typically TPM_RH_OWNER 
  * **key** pointer to a structure of [WOLFTPM2_KEY]() type, containing the nvIndex handle value


**See**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetRng

```cpp
WOLFTPM_API struct WC_RNG * wolfTPM2_GetRng(
    WOLFTPM2_DEV * dev
)
```

Get the wolfcrypt RNG instance used for wolfTPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Only if wolfcrypt is enabled and configured for use instead of the TPM RNG

#### function wolfTPM2_GetRandom

```cpp
WOLFTPM_API int wolfTPM2_GetRandom(
    WOLFTPM2_DEV * dev,
    byte * buf,
    word32 len
)
```

Get a set of random number, generated with the TPM RNG or wolfcrypt RNG. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **buf** pointer to a byte buffer, used to store the generated random numbers 
  * **len** integer value of word32 type, used to store the size of the buffer, in bytes


**See**: [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Define WOLFTPM2_USE_HW_RNG to use the TPM RNG source

#### function wolfTPM2_UnloadHandle

```cpp
WOLFTPM_API int wolfTPM2_UnloadHandle(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * handle
)
```

Use to discard any TPM loaded object. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **handle** pointer to a structure of WOLFTPM2_HANDLE type, with a valid TPM 2.0 handle value


**See**: [wolfTPM2_Clear](#function-wolftpm2-clear)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Clear

```cpp
WOLFTPM_API int wolfTPM2_Clear(
    WOLFTPM2_DEV * dev
)
```

Deinitializes wolfTPM and wolfcrypt(if enabled) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: [wolfTPM2_Clear](#function-wolftpm2-clear)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HashStart

```cpp
WOLFTPM_API int wolfTPM2_HashStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    TPMI_ALG_HASH hashAlg,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Helper function to start a TPM generated hash. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **usageAuth** pointer to a string constant, specifying the authorization for subsequent use of the hash 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HashUpdate

```cpp
WOLFTPM_API int wolfTPM2_HashUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    const byte * data,
    word32 dataSz
)
```

Update a TPM generated hash with new user data. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **data** pointer to a byte buffer, containing the user data to be added to the hash 
  * **dataSz** integer value of word32 type, specifying the size of the user data, in bytes


**See**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the auth is correctly set

#### function wolfTPM2_HashFinish

```cpp
WOLFTPM_API int wolfTPM2_HashFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    byte * digest,
    word32 * digestSz
)
```

Finalize a TPM generated hash and get the digest output in a user buffer. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **digest** pointer to a byte buffer, used to store the resulting digest 
  * **digestSz** pointer to size of digest buffer, on return set to bytes stored in digest buffer


**See**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the auth is correctly set

#### function wolfTPM2_LoadKeyedHashKey

```cpp
WOLFTPM_API int wolfTPM2_LoadKeyedHashKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    int hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Creates and loads a new TPM key of KeyedHash type, typically used for HMAC operations. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty structure of [WOLFTPM2_KEY]() type, to store the generated key 
  * **parent** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **keyBuf** pointer to a byte array, containing derivation values for the new KeyedHash key 
  * **keySz** integer value, specifying the size of the derivation values stored in keyBuf, in bytes 
  * **usageAuth** pointer to a string constant, specifying the authorization of the new key 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: To generate HMAC using the TPM it is recommended to use the wolfTPM2_Hmac wrappers

#### function wolfTPM2_HmacStart

```cpp
WOLFTPM_API int wolfTPM2_HmacStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    WOLFTPM2_HANDLE * parent,
    TPMI_ALG_HASH hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Helper function to start a TPM generated hmac. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **parent** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **keyBuf** pointer to a byte array, containing derivation values for the new KeyedHash key 
  * **keySz** integer value, specifying the size of the derivation values stored in keyBuf, in bytes 
  * **usageAuth** pointer to a string constant, specifying the authorization for subsequent use of the hmac 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)
  * [wolfTPM2_LoadKeyedHashKey](#function-wolftpm2-loadkeyedhashkey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HmacUpdate

```cpp
WOLFTPM_API int wolfTPM2_HmacUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    const byte * data,
    word32 dataSz
)
```

Update a TPM generated hmac with new user data. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **data** pointer to a byte buffer, containing the user data to be added to the hmac 
  * **dataSz** integer value of word32 type, specifying the size of the user data, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * wolfTPM2_HMACFinish 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the TPM authorization is correctly set

#### function wolfTPM2_HmacFinish

```cpp
WOLFTPM_API int wolfTPM2_HmacFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    byte * digest,
    word32 * digestSz
)
```

Finalize a TPM generated hmac and get the digest output in a user buffer. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **digest** pointer to a byte buffer, used to store the resulting hmac digest 
  * **digestSz** integer value of word32 type, specifying the size of the digest, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the TPM authorization is correctly set

#### function wolfTPM2_LoadSymmetricKey

```cpp
WOLFTPM_API int wolfTPM2_LoadSymmetricKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int alg,
    const byte * keyBuf,
    word32 keySz
)
```

Loads an external symmetric key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty structure of [WOLFTPM2_KEY]() type, to store the TPM handle and key information 
  * **alg** integer value, specifying a valid TPM 2.0 symmetric key algorithm, e.g. TPM_ALG_CFB for AES CFB 
  * **keyBuf** pointer to a byte array, containing private material of the symmetric key 
  * **keySz** integer value, specifying the size of the key material stored in keyBuf, in bytes


**See**: 

  * [wolfTPM2_EncryptDecryptBlock](#function-wolftpm2-encryptdecryptblock)
  * [wolfTPM2_EncryptDecrypt](#function-wolftpm2-encryptdecrypt)
  * [TPM2_EncryptDecrypt2](#function-tpm2-encryptdecrypt2)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_EncryptDecryptBlock

```cpp
WOLFTPM_API int wolfTPM2_EncryptDecryptBlock(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * in,
    byte * out,
    word32 inOutSz,
    byte * iv,
    word32 ivSz,
    int isDecrypt
)
```


#### function wolfTPM2_EncryptDecrypt

```cpp
WOLFTPM_API int wolfTPM2_EncryptDecrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * in,
    byte * out,
    word32 inOutSz,
    byte * iv,
    word32 ivSz,
    int isDecrypt
)
```


#### function wolfTPM2_SetCommand

```cpp
WOLFTPM_API int wolfTPM2_SetCommand(
    WOLFTPM2_DEV * dev,
    TPM_CC commandCode,
    int enableFlag
)
```

Vendor specific TPM command, used to enable other restricted TPM commands. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **commandCode** integer value, representing a valid vendor command 
  * **enableFlag** integer value, non-zero values represent "to enable"


**See**: [TPM2_GPIO_Config](#function-tpm2-gpio-config)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Shutdown

```cpp
WOLFTPM_API int wolfTPM2_Shutdown(
    WOLFTPM2_DEV * dev,
    int doStartup
)
```

Helper function to shutdown or reset the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **doStartup** integer value, non-zero values represent "perform Startup after Shutdown"


**See**: [wolfTPM2_Init](#function-wolftpm2-init)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: If doStartup is set, then TPM2_Startup is performed right after TPM2_Shutdown

#### function wolfTPM2_UnloadHandles

```cpp
WOLFTPM_API int wolfTPM2_UnloadHandles(
    WOLFTPM2_DEV * dev,
    word32 handleStart,
    word32 handleCount
)
```

One-shot API to unload subsequent TPM handles. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **handleStart** integer value of word32 type, specifying the value of the first TPM handle 
  * **handleCount** integer value of word32 type, specifying the number of handles


**See**: [wolfTPM2_Init](#function-wolftpm2-init)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_UnloadHandles_AllTransient

```cpp
WOLFTPM_API int wolfTPM2_UnloadHandles_AllTransient(
    WOLFTPM2_DEV * dev
)
```

One-shot API to unload all transient TPM handles. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: 

  * [wolfTPM2_UnloadHandles](#function-wolftpm2-unloadhandles)
  * wolfTPM2_CreatePrimary 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: If there are Primary Keys as transient objects, they need to be recreated before TPM keys can be used

#### function wolfTPM2_GetKeyTemplate_RSA

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes
)
```

Prepares a TPM public template for new RSA key based on user selected object attributes. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new RSA template 
  * **objectAttributes** integer value of TPMA_OBJECT type, can contain one or more attributes, e.g. TPMA_OBJECT_fixedTPM


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes,
    TPM_ECC_CURVE curve,
    TPM_ALG_ID sigScheme
)
```

Prepares a TPM public template for new ECC key based on user selected object attributes. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new ECC key template 
  * **objectAttributes** integer value of TPMA_OBJECT type, can contain one or more attributes, e.g. TPMA_OBJECT_fixedTPM 
  * **curve** integer value of TPM_ECC_CURVE type, specifying a TPM supported ECC curve ID 
  * **sigScheme** integer value of TPM_ALG_ID type, specifying a TPM supported signature scheme


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_Symmetric

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_Symmetric(
    TPMT_PUBLIC * publicTemplate,
    int keyBits,
    TPM_ALG_ID algMode,
    int isSign,
    int isDecrypt
)
```

Prepares a TPM public template for new Symmetric key. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new Symmetric key template 
  * **keyBits** integer value, specifying the size of the symmetric key, typically 128 or 256 bits 
  * **algMode** integer value of TPM_ALG_ID type, specifying a TPM supported symmetric algorithm, e.g. TPM_ALG_CFB for AES CFB 
  * **isSign** integer value, non-zero values represent "a signing key" 
  * **isDecrypt** integer value, non-zero values represent "a decryption key"


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_KeyedHash

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeyedHash(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID hashAlg,
    int isSign,
    int isDecrypt
)
```

Prepares a TPM public template for new KeyedHash key. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template 
  * **hashAlg** integer value of TPM_ALG_ID type, specifying a TPM supported hashing algorithm, e.g. TPM_ALG_SHA256 for SHA 256 
  * **isSign** integer value, non-zero values represent "a signing key" 
  * **isDecrypt** integer value, non-zero values represent "a decryption key"


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_KeySeal

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeySeal(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID nameAlg
)
```

Prepares a TPM public template for new key for sealing secrets. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template 
  * **nameAlg** integer value of TPM_ALG_ID type, specifying a TPM supported hashing algorithm, typically TPM_ALG_SHA256 for SHA 256


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: There are strict requirements for a Key Seal, therefore most of the key parameters are predetermined by the wrapper

#### function wolfTPM2_GetKeyTemplate_RSA_EK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_EK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating the TPM Endorsement Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_EK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_EK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating the TPM Endorsement Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_RSA_SRK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Storage Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_SRK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Storage Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_RSA_AIK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Attestation Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_AIK

```cpp
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Attestation Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetNvAttributesTemplate

```cpp
WOLFTPM_API int wolfTPM2_GetNvAttributesTemplate(
    TPM_HANDLE auth,
    word32 * nvAttributes
)
```

Prepares a TPM NV Index template. 

**Parameters**: 

  * **auth** integer value, representing the TPM Hierarchy under which the new TPM NV index will be created 
  * **nvAttributes** pointer to an empty integer variable, to store the NV Attributes


**See**: 

  * wolfTPM2_CreateAuth 
  * wolfTPM2_WriteAuth 
  * wolfTPM2_ReadAuth 
  * wolfTPM2_DeleteAuth 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_CreateEK

```cpp
WOLFTPM_API int wolfTPM2_CreateEK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ekKey,
    TPM_ALG_ID alg
)
```

Generates a new TPM Endorsement key, based on the user selected algorithm, RSA or ECC. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ekKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store information about the new EK 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC, see Note above


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Although only RSA and ECC can be used for EK, symmetric keys can be created and used by the TPM

#### function wolfTPM2_CreateSRK

```cpp
WOLFTPM_API int wolfTPM2_CreateSRK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * srkKey,
    TPM_ALG_ID alg,
    const byte * auth,
    int authSz
)
```

Generates a new TPM Primary Key that will be used as a Storage Key for other TPM keys. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **srkKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store information about the new EK 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC, see Note above 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateEK](#function-wolftpm2-createek)
  * [wolfTPM2_CreateAndLoadAIK](#function-wolftpm2-createandloadaik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Although only RSA and ECC can be used for EK, symmetric keys can be created and used by the TPM

#### function wolfTPM2_CreateAndLoadAIK

```cpp
WOLFTPM_API int wolfTPM2_CreateAndLoadAIK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * aikKey,
    TPM_ALG_ID alg,
    WOLFTPM2_KEY * srkKey,
    const byte * auth,
    int authSz
)
```

Generates a new TPM Attestation Key under the provided Storage Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **aikKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store the newly generated TPM key 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC 
  * **srkKey** pointer to a [WOLFTPM2_KEY]() structure, pointing to valid TPM handle of a loaded Storage Key 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetTime

```cpp
WOLFTPM_API int wolfTPM2_GetTime(
    WOLFTPM2_KEY * aikKey,
    GetTime_Out * getTimeOut
)
```

One-shot API to generate a TPM signed timestamp. 

**Parameters**: 

  * **aikKey** pointer to a [WOLFTPM2_KEY]() structure, containign valid TPM handle of a loaded attestation key 
  * **getTimeOut** pointer to an empty structure of [GetTime_Out]() type, to store the output of the command


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The attestation key must be generated and loaded prior to this call

#### function wolfTPM2_RSA_Salt

```cpp
WOLFTPM_LOCAL int wolfTPM2_RSA_Salt(
    struct WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    TPM2B_DIGEST * salt,
    TPM2B_ENCRYPTED_SECRET * encSalt,
    TPMT_PUBLIC * publicArea
)
```


#### function wolfTPM2_EncryptSalt

```cpp
WOLFTPM_LOCAL int wolfTPM2_EncryptSalt(
    struct WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    StartAuthSession_In * in,
    TPM2B_AUTH * bindAuth,
    TPM2B_DIGEST * salt
)
```


#### function wolfTPM2_CryptoDevCb

```cpp
WOLFTPM_API int wolfTPM2_CryptoDevCb(
    int devId,
    wc_CryptoInfo * info,
    void * ctx
)
```

A reference crypto callback API for using the TPM for crypto offload. This callback function is registered using wolfTPM2_SetCryptoDevCb or wc_CryptoDev_RegisterDevice. 

**Parameters**: 

  * **devId** The devId used when registering the callback. Any signed integer value besides INVALID_DEVID 
  * **info** point to wc_CryptoInfo structure with detailed information about crypto type and parameters 
  * **ctx** The user context supplied when callback was registered with wolfTPM2_SetCryptoDevCb


**See**: 

  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * CRYPTOCB_UNAVAILABLE: Do not use TPM hardware, fall-back to default software crypto. 
  * WC_HW_E: generic hardware failure


#### function wolfTPM2_SetCryptoDevCb

```cpp
WOLFTPM_API int wolfTPM2_SetCryptoDevCb(
    WOLFTPM2_DEV * dev,
    CryptoDevCallbackFunc cb,
    TpmCryptoDevCtx * tpmCtx,
    int * pDevId
)
```

Register a crypto callback function and return assigned devId. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **cb** The wolfTPM2_CryptoDevCb API is a template, but you can also provide your own 
  * **tpmCtx** The user supplied context. For wolfTPM2_CryptoDevCb use [TpmCryptoDevCtx](), but can also be your own. 
  * **pDevId** Pointer to automatically assigned device ID.


**See**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ClearCryptoDevCb

```cpp
WOLFTPM_API int wolfTPM2_ClearCryptoDevCb(
    WOLFTPM2_DEV * dev,
    int devId
)
```

Clears the registered crypto callback. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **devId** The devId used when registering the callback


**See**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments



### Attributes Documentation

#### variable C

```cpp
C {
#endif


typedef struct WOLFTPM2_HANDLE {
    TPM_HANDLE      hndl;
    TPM2B_AUTH      auth;       
    TPMT_SYM_DEF    symmetric;
    TPM2B_NAME      name;
    int             policyAuth; 
} WOLFTPM2_HANDLE;
```



### Source code

```cpp
/* tpm2_wrap.h
 *
 * Copyright (C) 2006-2021 wolfSSL Inc.
 *
 * This file is part of wolfTPM.
 *
 * wolfTPM is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfTPM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */

#ifndef __TPM2_WRAP_H__
#define __TPM2_WRAP_H__

#include <wolftpm/tpm2.h>

#ifdef __cplusplus
    extern "C" {
#endif


typedef struct WOLFTPM2_HANDLE {
    TPM_HANDLE      hndl;
    TPM2B_AUTH      auth;       /* Used if policyAuth is not set */
    TPMT_SYM_DEF    symmetric;
    TPM2B_NAME      name;
    int             policyAuth; /* Handle requires Policy, not password Auth */
} WOLFTPM2_HANDLE;

#define TPM_SES_PWD 0xFF /* Session type for Password that fits in one byte */

typedef struct WOLFTPM2_SESSION {
    TPM_ST          type;         /* Trial, Policy or HMAC; or TPM_SES_PWD */
    WOLFTPM2_HANDLE handle;       /* Session handle from StartAuthSession */
    TPM2B_NONCE     nonceTPM;     /* Value from StartAuthSession */
    TPM2B_NONCE     nonceCaller;  /* Fresh nonce at each command */
    TPM2B_DIGEST    salt;         /* User defined */
    TPMI_ALG_HASH   authHash;
} WOLFTPM2_SESSION;

typedef struct WOLFTPM2_DEV {
    TPM2_CTX ctx;
    TPM2_AUTH_SESSION session[MAX_SESSION_NUM];
} WOLFTPM2_DEV;

typedef struct WOLFTPM2_KEY {
    WOLFTPM2_HANDLE   handle;
    TPM2B_PUBLIC      pub;
} WOLFTPM2_KEY;

typedef struct WOLFTPM2_KEYBLOB {
    WOLFTPM2_HANDLE   handle;
    TPM2B_PUBLIC      pub;
    TPM2B_NAME        name;
    TPM2B_PRIVATE     priv;
} WOLFTPM2_KEYBLOB;

typedef struct WOLFTPM2_HASH {
    WOLFTPM2_HANDLE handle;
} WOLFTPM2_HASH;

typedef struct WOLFTPM2_NV {
    WOLFTPM2_HANDLE handle;
} WOLFTPM2_NV;

typedef struct WOLFTPM2_HMAC {
    WOLFTPM2_HASH   hash;
    WOLFTPM2_KEY    key;

    /* option bits */
    word16 hmacKeyLoaded:1;
    word16 hmacKeyKeep:1;
} WOLFTPM2_HMAC;

#ifndef WOLFTPM2_MAX_BUFFER
    #define WOLFTPM2_MAX_BUFFER 2048
#endif

typedef struct WOLFTPM2_BUFFER {
    int size;
    byte buffer[WOLFTPM2_MAX_BUFFER];
} WOLFTPM2_BUFFER;

typedef enum WOLFTPM2_MFG {
    TPM_MFG_UNKNOWN = 0,
    TPM_MFG_INFINEON,
    TPM_MFG_STM,
    TPM_MFG_MCHP,
    TPM_MFG_NUVOTON,
    TPM_MFG_NATIONTECH,
} WOLFTPM2_MFG;
typedef struct WOLFTPM2_CAPS {
    WOLFTPM2_MFG mfg;
    char mfgStr[4 + 1];
    char vendorStr[(4 * 4) + 1];
    word32 tpmType;
    word16 fwVerMajor;
    word16 fwVerMinor;
    word32 fwVerVendor;

    /* bits */
    word16 fips140_2 : 1; /* using FIPS mode */
    word16 cc_eal4   : 1; /* Common Criteria EAL4+ */
    word16 req_wait_state : 1; /* requires SPI wait state */
} WOLFTPM2_CAPS;

/* NV Handles */
#define TPM2_NV_RSA_EK_CERT 0x01C00002
#define TPM2_NV_ECC_EK_CERT 0x01C0000A


/* Wrapper API's to simplify TPM use */

/* For devtpm and swtpm builds, the ioCb and userCtx are not used and should be set to NULL */

WOLFTPM_API int wolfTPM2_Test(TPM2HalIoCb ioCb, void* userCtx, WOLFTPM2_CAPS* caps);

WOLFTPM_API int wolfTPM2_Init(WOLFTPM2_DEV* dev, TPM2HalIoCb ioCb, void* userCtx);

WOLFTPM_API int wolfTPM2_OpenExisting(WOLFTPM2_DEV* dev, TPM2HalIoCb ioCb, void* userCtx);

WOLFTPM_API int wolfTPM2_Cleanup(WOLFTPM2_DEV* dev);

WOLFTPM_API int wolfTPM2_Cleanup_ex(WOLFTPM2_DEV* dev, int doShutdown);

WOLFTPM_API int wolfTPM2_GetTpmDevId(WOLFTPM2_DEV* dev);

WOLFTPM_API int wolfTPM2_SelfTest(WOLFTPM2_DEV* dev);

WOLFTPM_API int wolfTPM2_GetCapabilities(WOLFTPM2_DEV* dev, WOLFTPM2_CAPS* caps);

WOLFTPM_API int wolfTPM2_UnsetAuth(WOLFTPM2_DEV* dev, int index);

WOLFTPM_API int wolfTPM2_SetAuth(WOLFTPM2_DEV* dev, int index,
    TPM_HANDLE sessionHandle, const TPM2B_AUTH* auth, TPMA_SESSION sessionAttributes,
    const TPM2B_NAME* name);

WOLFTPM_API int wolfTPM2_SetAuthPassword(WOLFTPM2_DEV* dev, int index, const TPM2B_AUTH* auth);

WOLFTPM_API int wolfTPM2_SetAuthHandle(WOLFTPM2_DEV* dev, int index, const WOLFTPM2_HANDLE* handle);

WOLFTPM_API int wolfTPM2_SetAuthSession(WOLFTPM2_DEV* dev, int index,
    const WOLFTPM2_SESSION* tpmSession, TPMA_SESSION sessionAttributes);

WOLFTPM_API int wolfTPM2_SetAuthHandleName(WOLFTPM2_DEV* dev, int index, const WOLFTPM2_HANDLE* handle);

WOLFTPM_API int wolfTPM2_StartSession(WOLFTPM2_DEV* dev,
    WOLFTPM2_SESSION* session, WOLFTPM2_KEY* tpmKey,
    WOLFTPM2_HANDLE* bind, TPM_SE sesType, int encDecAlg);

WOLFTPM_API int wolfTPM2_CreateAuthSession_EkPolicy(WOLFTPM2_DEV* dev,
                                                    WOLFTPM2_SESSION* tpmSession);

WOLFTPM_API int wolfTPM2_CreatePrimaryKey(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEY* key, TPM_HANDLE primaryHandle, TPMT_PUBLIC* publicTemplate,
    const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_ChangeAuthKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    WOLFTPM2_HANDLE* parent, const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_CreateKey(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEYBLOB* keyBlob, WOLFTPM2_HANDLE* parent, TPMT_PUBLIC* publicTemplate,
    const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_LoadKey(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEYBLOB* keyBlob, WOLFTPM2_HANDLE* parent);

WOLFTPM_API int wolfTPM2_CreateAndLoadKey(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEY* key, WOLFTPM2_HANDLE* parent, TPMT_PUBLIC* publicTemplate,
    const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_CreateLoadedKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEYBLOB* keyBlob,
    WOLFTPM2_HANDLE* parent, TPMT_PUBLIC* publicTemplate,
    const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_LoadPublicKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const TPM2B_PUBLIC* pub);

WOLFTPM_API int wolfTPM2_LoadPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEY* key, const TPM2B_PUBLIC* pub,
    TPM2B_SENSITIVE* sens);

WOLFTPM_API int wolfTPM2_ImportPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEYBLOB* keyBlob, const TPM2B_PUBLIC* pub,
    TPM2B_SENSITIVE* sens);

WOLFTPM_API int wolfTPM2_LoadRsaPublicKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* rsaPub, word32 rsaPubSz, word32 exponent);

WOLFTPM_API int wolfTPM2_LoadRsaPublicKey_ex(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* rsaPub, word32 rsaPubSz, word32 exponent,
    TPMI_ALG_RSA_SCHEME scheme, TPMI_ALG_HASH hashAlg);

WOLFTPM_API int wolfTPM2_ImportRsaPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEYBLOB* keyBlob,
    const byte* rsaPub, word32 rsaPubSz, word32 exponent,
    const byte* rsaPriv, word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme, TPMI_ALG_HASH hashAlg);

WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEY* key,
    const byte* rsaPub, word32 rsaPubSz, word32 exponent,
    const byte* rsaPriv, word32 rsaPrivSz);

WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey_ex(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEY* key,
    const byte* rsaPub, word32 rsaPubSz, word32 exponent,
    const byte* rsaPriv, word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme, TPMI_ALG_HASH hashAlg);

WOLFTPM_API int wolfTPM2_LoadEccPublicKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    int curveId, const byte* eccPubX, word32 eccPubXSz,
    const byte* eccPubY, word32 eccPubYSz);

WOLFTPM_API int wolfTPM2_ImportEccPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEYBLOB* keyBlob,
    int curveId, const byte* eccPubX, word32 eccPubXSz,
    const byte* eccPubY, word32 eccPubYSz,
    const byte* eccPriv, word32 eccPrivSz);

WOLFTPM_API int wolfTPM2_LoadEccPrivateKey(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, WOLFTPM2_KEY* key,
    int curveId, const byte* eccPubX, word32 eccPubXSz,
    const byte* eccPubY, word32 eccPubYSz,
    const byte* eccPriv, word32 eccPrivSz);

WOLFTPM_API int wolfTPM2_ReadPublicKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const TPM_HANDLE handle);

WOLFTPM_API int wolfTPM2_CreateKeySeal(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEYBLOB* keyBlob, WOLFTPM2_HANDLE* parent,
    TPMT_PUBLIC* publicTemplate, const byte* auth, int authSz,
    const byte* sealData, int sealSize);

WOLFTPM_API int wolfTPM2_ComputeName(const TPM2B_PUBLIC* pub, TPM2B_NAME* out);

WOLFTPM_API int wolfTPM2_SensitiveToPrivate(TPM2B_SENSITIVE* sens, TPM2B_PRIVATE* priv,
    TPMI_ALG_HASH nameAlg, TPM2B_NAME* name, const WOLFTPM2_KEY* parentKey,
    TPMT_SYM_DEF_OBJECT* sym, TPM2B_ENCRYPTED_SECRET* symSeed);

#ifndef WOLFTPM2_NO_WOLFCRYPT
#ifndef NO_RSA

WOLFTPM_API int wolfTPM2_RsaKey_TpmToWolf(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* tpmKey,
    RsaKey* wolfKey);

WOLFTPM_API int wolfTPM2_RsaKey_TpmToPemPub(WOLFTPM2_DEV* dev,
                                         WOLFTPM2_KEY* keyBlob,
                                         byte* pem, word32* pemSz);

WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm(WOLFTPM2_DEV* dev, RsaKey* wolfKey,
    WOLFTPM2_KEY* tpmKey);

WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm_ex(WOLFTPM2_DEV* dev,
    const WOLFTPM2_KEY* parentKey, RsaKey* wolfKey, WOLFTPM2_KEY* tpmKey);

WOLFTPM_API int wolfTPM2_RsaKey_PubPemToTpm(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEY* tpmKey, const byte* pem, word32 pemSz);
#endif
#ifdef HAVE_ECC

WOLFTPM_API int wolfTPM2_EccKey_TpmToWolf(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* tpmKey,
    ecc_key* wolfKey);

WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm(WOLFTPM2_DEV* dev, ecc_key* wolfKey,
    WOLFTPM2_KEY* tpmKey);

WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm_ex(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* parentKey,
    ecc_key* wolfKey, WOLFTPM2_KEY* tpmKey);

WOLFTPM_API int wolfTPM2_EccKey_WolfToPubPoint(WOLFTPM2_DEV* dev, ecc_key* wolfKey,
    TPM2B_ECC_POINT* pubPoint);
#endif
#endif

WOLFTPM_API int wolfTPM2_SignHash(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* digest, int digestSz, byte* sig, int* sigSz);

WOLFTPM_API int wolfTPM2_SignHashScheme(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* digest, int digestSz, byte* sig, int* sigSz,
    TPMI_ALG_SIG_SCHEME sigAlg, TPMI_ALG_HASH hashAlg);

WOLFTPM_API int wolfTPM2_VerifyHash(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* sig, int sigSz, const byte* digest, int digestSz);

WOLFTPM_API int wolfTPM2_VerifyHash_ex(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* sig, int sigSz, const byte* digest, int digestSz,
    int hashAlg);

WOLFTPM_API int wolfTPM2_VerifyHashScheme(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* sig, int sigSz, const byte* digest, int digestSz,
    TPMI_ALG_SIG_SCHEME sigAlg, TPMI_ALG_HASH hashAlg);

WOLFTPM_API int wolfTPM2_ECDHGenKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* ecdhKey,
    int curve_id, const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_ECDHGen(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* privKey,
    TPM2B_ECC_POINT* pubPoint, byte* out, int* outSz);

WOLFTPM_API int wolfTPM2_ECDHGenZ(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* privKey,
    const TPM2B_ECC_POINT* pubPoint, byte* out, int* outSz);

WOLFTPM_API int wolfTPM2_ECDHEGenKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* ecdhKey,
    int curve_id);

WOLFTPM_API int wolfTPM2_ECDHEGenZ(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* parentKey,
    WOLFTPM2_KEY* ecdhKey, const TPM2B_ECC_POINT* pubPoint,
    byte* out, int* outSz);

WOLFTPM_API int wolfTPM2_RsaEncrypt(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    TPM_ALG_ID padScheme, const byte* msg, int msgSz, byte* out, int* outSz);

WOLFTPM_API int wolfTPM2_RsaDecrypt(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    TPM_ALG_ID padScheme, const byte* in, int inSz, byte* msg, int* msgSz);


WOLFTPM_API int wolfTPM2_ReadPCR(WOLFTPM2_DEV* dev,
    int pcrIndex, int hashAlg, byte* digest, int* pDigestLen);

WOLFTPM_API int wolfTPM2_ExtendPCR(WOLFTPM2_DEV* dev, int pcrIndex, int hashAlg,
    const byte* digest, int digestLen);

/* Newer API's that use WOLFTPM2_NV context and support auth */

WOLFTPM_API int wolfTPM2_NVCreateAuth(WOLFTPM2_DEV* dev, WOLFTPM2_HANDLE* parent,
    WOLFTPM2_NV* nv, word32 nvIndex, word32 nvAttributes, word32 maxSize,
    const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_NVWriteAuth(WOLFTPM2_DEV* dev, WOLFTPM2_NV* nv,
    word32 nvIndex, byte* dataBuf, word32 dataSz, word32 offset);

WOLFTPM_API int wolfTPM2_NVReadAuth(WOLFTPM2_DEV* dev, WOLFTPM2_NV* nv,
    word32 nvIndex, byte* dataBuf, word32* pDataSz, word32 offset);

WOLFTPM_API int wolfTPM2_NVDeleteAuth(WOLFTPM2_DEV* dev, WOLFTPM2_HANDLE* parent,
    word32 nvIndex);

/* older API's with improper auth support, kept only for backwards compatibility */
WOLFTPM_API int wolfTPM2_NVCreate(WOLFTPM2_DEV* dev, TPM_HANDLE authHandle,
    word32 nvIndex, word32 nvAttributes, word32 maxSize, const byte* auth, int authSz);
WOLFTPM_API int wolfTPM2_NVWrite(WOLFTPM2_DEV* dev, TPM_HANDLE authHandle,
    word32 nvIndex, byte* dataBuf, word32 dataSz, word32 offset);
WOLFTPM_API int wolfTPM2_NVRead(WOLFTPM2_DEV* dev, TPM_HANDLE authHandle,
    word32 nvIndex, byte* dataBuf, word32* dataSz, word32 offset);
WOLFTPM_API int wolfTPM2_NVDelete(WOLFTPM2_DEV* dev, TPM_HANDLE authHandle,
    word32 nvIndex);

WOLFTPM_API int wolfTPM2_NVReadPublic(WOLFTPM2_DEV* dev, word32 nvIndex,
    TPMS_NV_PUBLIC* nvPublic);

WOLFTPM_API int wolfTPM2_NVStoreKey(WOLFTPM2_DEV* dev, TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY* key, TPM_HANDLE persistentHandle);

WOLFTPM_API int wolfTPM2_NVDeleteKey(WOLFTPM2_DEV* dev, TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY* key);

WOLFTPM_API struct WC_RNG* wolfTPM2_GetRng(WOLFTPM2_DEV* dev);

WOLFTPM_API int wolfTPM2_GetRandom(WOLFTPM2_DEV* dev, byte* buf, word32 len);

WOLFTPM_API int wolfTPM2_UnloadHandle(WOLFTPM2_DEV* dev, WOLFTPM2_HANDLE* handle);

WOLFTPM_API int wolfTPM2_Clear(WOLFTPM2_DEV* dev);

WOLFTPM_API int wolfTPM2_HashStart(WOLFTPM2_DEV* dev, WOLFTPM2_HASH* hash,
    TPMI_ALG_HASH hashAlg, const byte* usageAuth, word32 usageAuthSz);

WOLFTPM_API int wolfTPM2_HashUpdate(WOLFTPM2_DEV* dev, WOLFTPM2_HASH* hash,
    const byte* data, word32 dataSz);

WOLFTPM_API int wolfTPM2_HashFinish(WOLFTPM2_DEV* dev, WOLFTPM2_HASH* hash,
    byte* digest, word32* digestSz);

WOLFTPM_API int wolfTPM2_LoadKeyedHashKey(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    WOLFTPM2_HANDLE* parent, int hashAlg, const byte* keyBuf, word32 keySz,
    const byte* usageAuth, word32 usageAuthSz);

WOLFTPM_API int wolfTPM2_HmacStart(WOLFTPM2_DEV* dev, WOLFTPM2_HMAC* hmac,
    WOLFTPM2_HANDLE* parent, TPMI_ALG_HASH hashAlg, const byte* keyBuf, word32 keySz,
    const byte* usageAuth, word32 usageAuthSz);

WOLFTPM_API int wolfTPM2_HmacUpdate(WOLFTPM2_DEV* dev, WOLFTPM2_HMAC* hmac,
    const byte* data, word32 dataSz);

WOLFTPM_API int wolfTPM2_HmacFinish(WOLFTPM2_DEV* dev, WOLFTPM2_HMAC* hmac,
    byte* digest, word32* digestSz);

WOLFTPM_API int wolfTPM2_LoadSymmetricKey(WOLFTPM2_DEV* dev,
    WOLFTPM2_KEY* key, int alg, const byte* keyBuf, word32 keySz);

#define WOLFTPM2_ENCRYPT NO
#define WOLFTPM2_DECRYPT YES
WOLFTPM_API int wolfTPM2_EncryptDecryptBlock(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* in, byte* out, word32 inOutSz, byte* iv, word32 ivSz,
    int isDecrypt);
WOLFTPM_API int wolfTPM2_EncryptDecrypt(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key,
    const byte* in, byte* out, word32 inOutSz,
    byte* iv, word32 ivSz, int isDecrypt);

WOLFTPM_API int wolfTPM2_SetCommand(WOLFTPM2_DEV* dev, TPM_CC commandCode,
    int enableFlag);

WOLFTPM_API int wolfTPM2_Shutdown(WOLFTPM2_DEV* dev, int doStartup);

WOLFTPM_API int wolfTPM2_UnloadHandles(WOLFTPM2_DEV* dev, word32 handleStart,
    word32 handleCount);

WOLFTPM_API int wolfTPM2_UnloadHandles_AllTransient(WOLFTPM2_DEV* dev);

/* Utility functions */

WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA(TPMT_PUBLIC* publicTemplate,
    TPMA_OBJECT objectAttributes);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC(TPMT_PUBLIC* publicTemplate,
    TPMA_OBJECT objectAttributes, TPM_ECC_CURVE curve, TPM_ALG_ID sigScheme);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_Symmetric(TPMT_PUBLIC* publicTemplate,
    int keyBits, TPM_ALG_ID algMode, int isSign, int isDecrypt);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeyedHash(TPMT_PUBLIC* publicTemplate,
    TPM_ALG_ID hashAlg, int isSign, int isDecrypt);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeySeal(TPMT_PUBLIC* publicTemplate, TPM_ALG_ID nameAlg);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_EK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_EK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_SRK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_SRK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_AIK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_AIK(TPMT_PUBLIC* publicTemplate);

WOLFTPM_API int wolfTPM2_GetNvAttributesTemplate(TPM_HANDLE auth, word32* nvAttributes);

WOLFTPM_API int wolfTPM2_CreateEK(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* ekKey, TPM_ALG_ID alg);

WOLFTPM_API int wolfTPM2_CreateSRK(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* srkKey, TPM_ALG_ID alg,
    const byte* auth, int authSz);
WOLFTPM_API int wolfTPM2_CreateAndLoadAIK(WOLFTPM2_DEV* dev, WOLFTPM2_KEY* aikKey,
    TPM_ALG_ID alg, WOLFTPM2_KEY* srkKey, const byte* auth, int authSz);

WOLFTPM_API int wolfTPM2_GetTime(WOLFTPM2_KEY* aikKey, GetTime_Out* getTimeOut);

/* moved to tpm.h native code. macros here for backwards compatibility */
#define wolfTPM2_SetupPCRSel  TPM2_SetupPCRSel
#define wolfTPM2_GetAlgName   TPM2_GetAlgName
#define wolfTPM2_GetRCString  TPM2_GetRCString
#define wolfTPM2_GetCurveSize TPM2_GetCurveSize

/* for salted auth sessions */
WOLFTPM_LOCAL int wolfTPM2_RSA_Salt(struct WOLFTPM2_DEV* dev, WOLFTPM2_KEY* tpmKey,
    TPM2B_DIGEST *salt, TPM2B_ENCRYPTED_SECRET *encSalt, TPMT_PUBLIC *publicArea);
WOLFTPM_LOCAL int wolfTPM2_EncryptSalt(struct WOLFTPM2_DEV* dev, WOLFTPM2_KEY* tpmKey,
    StartAuthSession_In* in, TPM2B_AUTH* bindAuth, TPM2B_DIGEST* salt);


#if defined(WOLF_CRYPTO_DEV) || defined(WOLF_CRYPTO_CB)
struct TpmCryptoDevCtx;
typedef int (*CheckWolfKeyCallbackFunc)(wc_CryptoInfo* info, struct TpmCryptoDevCtx* ctx);

typedef struct TpmCryptoDevCtx {
    WOLFTPM2_DEV* dev;
#ifndef NO_RSA
    WOLFTPM2_KEY* rsaKey;  /* RSA */
#endif
#ifdef HAVE_ECC
    WOLFTPM2_KEY* eccKey;  /* ECDSA */
    #ifndef WOLFTPM2_USE_SW_ECDHE
    WOLFTPM2_KEY* ecdhKey; /* ECDH */
    #endif
#endif
    CheckWolfKeyCallbackFunc checkKeyCb;
    WOLFTPM2_KEY* storageKey;
#ifdef WOLFTPM_USE_SYMMETRIC
    unsigned short useSymmetricOnTPM:1; /* if set indicates desire to use symmetric algorithms on TPM */
#endif
    unsigned short useFIPSMode:1; /* if set requires FIPS mode on TPM and no fallback to software algos */
} TpmCryptoDevCtx;

WOLFTPM_API int wolfTPM2_CryptoDevCb(int devId, wc_CryptoInfo* info, void* ctx);

WOLFTPM_API int wolfTPM2_SetCryptoDevCb(WOLFTPM2_DEV* dev, CryptoDevCallbackFunc cb,
    TpmCryptoDevCtx* tpmCtx, int* pDevId);

WOLFTPM_API int wolfTPM2_ClearCryptoDevCb(WOLFTPM2_DEV* dev, int devId);

#endif /* WOLF_CRYPTO_CB */

#ifdef __cplusplus
    }  /* extern "C" */
#endif

#endif /* __TPM2_WRAP_H__ */
```











## wolfTPM2 Wrappers

This module describes the rich API of wolfTPM called wrappers.  [More...](#detailed-description)

### Functions

|                | Name           |
| -------------- | -------------- |
| WOLFTPM_API int | **[wolfTPM2_Test]() * caps)<br>Test initialization of a TPM and optionally the TPM capabilities can be received.  |
| WOLFTPM_API int | **[wolfTPM2_Init](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Complete initialization of a TPM.  |
| WOLFTPM_API int | **[wolfTPM2_OpenExisting](#typedef-tpm2haliocb) ioCb, void * userCtx)<br>Use an already initialized TPM, in its current TPM locality.  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup]() * dev)<br>Easy to use TPM and wolfcrypt deinitialization.  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup_ex]() * dev, int doShutdown)<br>Deinitialization of a TPM (and wolfcrypt if it was used)  |
| WOLFTPM_API int | **[wolfTPM2_GetTpmDevId]() * dev)<br>Provides the device ID of a TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SelfTest]() * dev)<br>Asks the TPM to perform its self test.  |
| WOLFTPM_API int | **[wolfTPM2_GetCapabilities]() * caps)<br>Reported the available TPM capabilities.  |
| WOLFTPM_API int | **[wolfTPM2_UnsetAuth]() * dev, int index)<br>Clears one of the TPM Authorization slots, pointed by its index number.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuth]() * name)<br>Sets a TPM Authorization slot using the provided index, session handle, attributes and auth.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthPassword](#typedef-tpm2b-auth) * auth)<br>Sets a TPM Authorization slot using the provided user auth, typically a password.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandle]() * dev, int index, const WOLFTPM2_HANDLE * handle)<br>Sets a TPM Authorization slot using the user auth associated with a wolfTPM2 Handle.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthSession](#typedef-tpma-session) sessionAttributes)<br>Sets a TPM Authorization slot using the provided TPM session handle, index and session attributes.  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandleName]() * dev, int index, const WOLFTPM2_HANDLE * handle)<br>Updates the Name used in a TPM Session with the Name associated with wolfTPM2 Handle.  |
| WOLFTPM_API int | **[wolfTPM2_StartSession](#typedef-tpm-se) sesType, int encDecAlg)<br>Create a TPM session, Policy, HMAC or Trial.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAuthSession_EkPolicy]() * tpmSession)<br>Creates a TPM session with Policy Secret to satisfy the default EK policy.  |
| WOLFTPM_API int | **[wolfTPM2_CreatePrimaryKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to prepare and create a TPM 2.0 Primary Key.  |
| WOLFTPM_API int | **[wolfTPM2_ChangeAuthKey]() * key, WOLFTPM2_HANDLE * parent, const byte * auth, int authSz)<br>Change the authorization secret of a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_CreateKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to prepare and create a TPM 2.0 Key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadKey]() * keyBlob, WOLFTPM2_HANDLE * parent)<br>Single function to load a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadKey]() * publicTemplate, const byte * auth, int authSz)<br>Single function to create and load a TPM 2.0 Key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_CreateLoadedKey]() * publicTemplate, const byte * auth, int authSz)<br>Creates and loads a key using single TPM 2.0 operation, and stores encrypted private key material.  |
| WOLFTPM_API int | **[wolfTPM2_LoadPublicKey]() * pub)<br>Wrapper to load the public part of an external key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadPrivateKey]() * sens)<br>Single function to import an external private key and load it into the TPM in one step.  |
| WOLFTPM_API int | **[wolfTPM2_ImportPrivateKey]() * sens)<br>Single function to import an external private key and load it into the TPM in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey]() * key, const byte * rsaPub, word32 rsaPubSz, word32 exponent)<br>Helper function to import the public part of an external RSA key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey_ex](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to import the public part of an external RSA key.  |
| WOLFTPM_API int | **[wolfTPM2_ImportRsaPrivateKey](#typedef-tpmi-alg-hash) hashAlg)<br>Import an external RSA private key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey]() * key, const byte * rsaPub, word32 rsaPubSz, word32 exponent, const byte * rsaPriv, word32 rsaPrivSz)<br>Helper function to import and load an external RSA private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey_ex](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to import and load an external RSA private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPublicKey]() * key, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz)<br>Helper function to import the public part of an external ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_ImportEccPrivateKey]() * keyBlob, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz, const byte * eccPriv, word32 eccPrivSz)<br>Helper function to import the private material of an external ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPrivateKey]() * key, int curveId, const byte * eccPubX, word32 eccPubXSz, const byte * eccPubY, word32 eccPubYSz, const byte * eccPriv, word32 eccPrivSz)<br>Helper function to import and load an external ECC private key in one step.  |
| WOLFTPM_API int | **[wolfTPM2_ReadPublicKey](#typedef-tpm-handle) handle)<br>Helper function to receive the public part of a loaded TPM object using its handle.  |
| WOLFTPM_API int | **[wolfTPM2_CreateKeySeal]() * publicTemplate, const byte * auth, int authSz, const byte * sealData, int sealSize)<br>Using this wrapper a secret can be sealed inside a TPM 2.0 Key.  |
| WOLFTPM_API int | **[wolfTPM2_ComputeName]() * out)<br>Helper function to generate a hash of the public area of an object in the format expected by the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SensitiveToPrivate]().  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToWolf]() * tpmKey, RsaKey * wolfKey)<br>Extract a RSA TPM key and convert it to a wolfcrypt key.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToPemPub]() * keyBlob, byte * pem, word32 * pemSz)<br>Convert a public RSA TPM key to PEM format public key Note: pem and tempBuf must be different buffers, of equal size.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm]() * tpmKey)<br>Import a RSA wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm_ex]() * tpmKey)<br>Import a RSA wolfcrypt key into the TPM under a specific Primary Key or Hierarchy.  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_PubPemToTpm]() * tpmKey, const byte * pem, word32 pemSz)<br>Import a PEM format public key from a file into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_TpmToWolf]() * tpmKey, ecc_key * wolfKey)<br>Extract a ECC TPM key and convert to to a wolfcrypt key.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm]() * tpmKey)<br>Import a ECC wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm_ex]() * tpmKey)<br>Import ECC wolfcrypt key into the TPM under a specific Primary Key or Hierarchy.  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToPubPoint]() * pubPoint)<br>Import a ECC public key generated from wolfcrypt key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SignHash]() * key, const byte * digest, int digestSz, byte * sig, int * sigSz)<br>Helper function to sign arbitrary data using a TPM key.  |
| WOLFTPM_API int | **[wolfTPM2_SignHashScheme](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to sign arbitrary data using a TPM key, and specify the signature scheme and hashing algorithm.  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHash]() * key, const byte * sig, int sigSz, const byte * digest, int digestSz)<br>Helper function to verify a TPM generated signature.  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHashScheme](#typedef-tpmi-alg-hash) hashAlg)<br>Advanced helper function to verify a TPM generated signature.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenKey]() * ecdhKey, int curve_id, const byte * auth, int authSz)<br>Generates and then loads a ECC key-pair with NULL hierarchy for Diffie-Hellman exchange.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGen]() * pubPoint, byte * out, int * outSz)<br>Generates ephemeral key and computes Z (shared secret)  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenZ]() * pubPoint, byte * out, int * outSz)<br>Computes Z (shared secret) using pubPoint and loaded private ECC key.  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenKey]() * ecdhKey, int curve_id)<br>Generates ephemeral ECC key and returns array index (2 phase method)  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenZ]() * pubPoint, byte * out, int * outSz)<br>Computes Z (shared secret) using pubPoint and counter (2 phase method)  |
| WOLFTPM_API int | **[wolfTPM2_RsaEncrypt](#typedef-tpm-alg-id) padScheme, const byte * msg, int msgSz, byte * out, int * outSz)<br>Perform RSA encryption using a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_RsaDecrypt](#typedef-tpm-alg-id) padScheme, const byte * in, int inSz, byte * msg, int * msgSz)<br>Perform RSA decryption using a TPM 2.0 key.  |
| WOLFTPM_API int | **[wolfTPM2_ReadPCR]() * dev, int pcrIndex, int hashAlg, byte * digest, int * pDigestLen)<br>Read the values of a specified TPM 2.0 Platform Configuration Registers(PCR)  |
| WOLFTPM_API int | **[wolfTPM2_ExtendPCR]() * dev, int pcrIndex, int hashAlg, const byte * digest, int digestLen)<br>Extend a PCR register with a user provided digest.  |
| WOLFTPM_API int | **[wolfTPM2_NVCreateAuth]() * nv, word32 nvIndex, word32 nvAttributes, word32 maxSize, const byte * auth, int authSz)<br>Creates a new NV Index to be later used for storing data into the TPM's NVRAM.  |
| WOLFTPM_API int | **[wolfTPM2_NVWriteAuth]() * nv, word32 nvIndex, byte * dataBuf, word32 dataSz, word32 offset)<br>Stores user data to a NV Index, at a given offest.  |
| WOLFTPM_API int | **[wolfTPM2_NVReadAuth]() * nv, word32 nvIndex, byte * dataBuf, word32 * pDataSz, word32 offset)<br>Reads user data from a NV Index, starting at the given offset.  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteAuth]() * dev, WOLFTPM2_HANDLE * parent, word32 nvIndex)<br>Destroys an existing NV Index.  |
| WOLFTPM_API int | **[wolfTPM2_NVCreate](#typedef-tpm-handle) authHandle, word32 nvIndex, word32 nvAttributes, word32 maxSize, const byte * auth, int authSz)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVWrite](#typedef-tpm-handle) authHandle, word32 nvIndex, byte * dataBuf, word32 dataSz, word32 offset)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVRead](#typedef-tpm-handle) authHandle, word32 nvIndex, byte * dataBuf, word32 * dataSz, word32 offset)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVDelete](#typedef-tpm-handle) authHandle, word32 nvIndex)<br>Deprecated, use newer API.  |
| WOLFTPM_API int | **[wolfTPM2_NVReadPublic]() * nvPublic)<br>Extracts the public information about an nvIndex, such as maximum size.  |
| WOLFTPM_API int | **[wolfTPM2_NVStoreKey](#typedef-tpm-handle) persistentHandle)<br>Helper function to store a TPM 2.0 Key into the TPM's NVRAM.  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteKey]() * key)<br>Helper function to delete a TPM 2.0 Key from the TPM's NVRAM.  |
| WOLFTPM_API struct WC_RNG * | **[wolfTPM2_GetRng]() * dev)<br>Get the wolfcrypt RNG instance used for wolfTPM.  |
| WOLFTPM_API int | **[wolfTPM2_GetRandom]() * dev, byte * buf, word32 len)<br>Get a set of random number, generated with the TPM RNG or wolfcrypt RNG.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandle]() * dev, WOLFTPM2_HANDLE * handle)<br>Use to discard any TPM loaded object.  |
| WOLFTPM_API int | **[wolfTPM2_Clear]() * dev)<br>Deinitializes wolfTPM and wolfcrypt(if enabled)  |
| WOLFTPM_API int | **[wolfTPM2_HashStart](#typedef-tpmi-alg-hash) hashAlg, const byte * usageAuth, word32 usageAuthSz)<br>Helper function to start a TPM generated hash.  |
| WOLFTPM_API int | **[wolfTPM2_HashUpdate]() * hash, const byte * data, word32 dataSz)<br>Update a TPM generated hash with new user data.  |
| WOLFTPM_API int | **[wolfTPM2_HashFinish]() * hash, byte * digest, word32 * digestSz)<br>Finalize a TPM generated hash and get the digest output in a user buffer.  |
| WOLFTPM_API int | **[wolfTPM2_LoadKeyedHashKey]() * key, WOLFTPM2_HANDLE * parent, int hashAlg, const byte * keyBuf, word32 keySz, const byte * usageAuth, word32 usageAuthSz)<br>Creates and loads a new TPM key of KeyedHash type, typically used for HMAC operations.  |
| WOLFTPM_API int | **[wolfTPM2_HmacStart](#typedef-tpmi-alg-hash) hashAlg, const byte * keyBuf, word32 keySz, const byte * usageAuth, word32 usageAuthSz)<br>Helper function to start a TPM generated hmac.  |
| WOLFTPM_API int | **[wolfTPM2_HmacUpdate]() * hmac, const byte * data, word32 dataSz)<br>Update a TPM generated hmac with new user data.  |
| WOLFTPM_API int | **[wolfTPM2_HmacFinish]() * hmac, byte * digest, word32 * digestSz)<br>Finalize a TPM generated hmac and get the digest output in a user buffer.  |
| WOLFTPM_API int | **[wolfTPM2_LoadSymmetricKey]() * key, int alg, const byte * keyBuf, word32 keySz)<br>Loads an external symmetric key into the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_SetCommand](#typedef-tpm-cc) commandCode, int enableFlag)<br>Vendor specific TPM command, used to enable other restricted TPM commands.  |
| WOLFTPM_API int | **[wolfTPM2_Shutdown]() * dev, int doStartup)<br>Helper function to shutdown or reset the TPM.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles]() * dev, word32 handleStart, word32 handleCount)<br>One-shot API to unload subsequent TPM handles.  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles_AllTransient]() * dev)<br>One-shot API to unload all transient TPM handles.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA](#typedef-tpma-object) objectAttributes)<br>Prepares a TPM public template for new RSA key based on user selected object attributes.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC](#typedef-tpm-alg-id) sigScheme)<br>Prepares a TPM public template for new ECC key based on user selected object attributes.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_Symmetric](#typedef-tpm-alg-id) algMode, int isSign, int isDecrypt)<br>Prepares a TPM public template for new Symmetric key.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeyedHash](#typedef-tpm-alg-id) hashAlg, int isSign, int isDecrypt)<br>Prepares a TPM public template for new KeyedHash key.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeySeal](#typedef-tpm-alg-id) nameAlg)<br>Prepares a TPM public template for new key for sealing secrets.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_EK]() * publicTemplate)<br>Prepares a TPM public template for generating the TPM Endorsement Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_EK]() * publicTemplate)<br>Prepares a TPM public template for generating the TPM Endorsement Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_SRK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Storage Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_SRK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Storage Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_AIK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Attestation Key of RSA type.  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_AIK]() * publicTemplate)<br>Prepares a TPM public template for generating a new TPM Attestation Key of ECC type.  |
| WOLFTPM_API int | **[wolfTPM2_GetNvAttributesTemplate](#typedef-tpm-handle) auth, word32 * nvAttributes)<br>Prepares a TPM NV Index template.  |
| WOLFTPM_API int | **[wolfTPM2_CreateEK](#typedef-tpm-alg-id) alg)<br>Generates a new TPM Endorsement key, based on the user selected algorithm, RSA or ECC.  |
| WOLFTPM_API int | **[wolfTPM2_CreateSRK](#typedef-tpm-alg-id) alg, const byte * auth, int authSz)<br>Generates a new TPM Primary Key that will be used as a Storage Key for other TPM keys.  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadAIK]() * srkKey, const byte * auth, int authSz)<br>Generates a new TPM Attestation Key under the provided Storage Key.  |
| WOLFTPM_API int | **[wolfTPM2_GetTime]() * getTimeOut)<br>One-shot API to generate a TPM signed timestamp.  |
| WOLFTPM_API int | **[wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)**(int devId, wc_CryptoInfo * info, void * ctx)<br>A reference crypto callback API for using the TPM for crypto offload. This callback function is registered using wolfTPM2_SetCryptoDevCb or wc_CryptoDev_RegisterDevice.  |
| WOLFTPM_API int | **[wolfTPM2_SetCryptoDevCb]() * tpmCtx, int * pDevId)<br>Register a crypto callback function and return assigned devId.  |
| WOLFTPM_API int | **[wolfTPM2_ClearCryptoDevCb]() * dev, int devId)<br>Clears the registered crypto callback.  |

### Detailed Description

This module describes the rich API of wolfTPM called wrappers. 

wolfTPM wrappers are used in two main cases:

* Perform common TPM 2.0 tasks, like key generation and storage
* Perform complex TPM 2.0 tasks, like attestation and parameter encryption
wolfTPM enables quick and rapid use of TPM 2.0 thanks to its many wrapper functions. 


### Functions Documentation

#### function wolfTPM2_Test

```
WOLFTPM_API int wolfTPM2_Test(
    TPM2HalIoCb ioCb,
    void * userCtx,
    WOLFTPM2_CAPS * caps
)
```

Test initialization of a TPM and optionally the TPM capabilities can be received. 

**Parameters**: 

  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL) 
  * **caps** to a structure of [WOLFTPM2_CAPS]() type for returning the TPM capabilities (can be NULL)


**See**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Init

```
WOLFTPM_API int wolfTPM2_Init(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Complete initialization of a TPM. 

**Parameters**: 

  * **dev** pointer to an empty structure of [WOLFTPM2_DEV]() type 
  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL)


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;
WOLFTPM2_DEV dev;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Init failed
    goto exit;
}
```


#### function wolfTPM2_OpenExisting

```
WOLFTPM_API int wolfTPM2_OpenExisting(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

Use an already initialized TPM, in its current TPM locality. 

**Parameters**: 

  * **dev** pointer to an empty structure of [WOLFTPM2_DEV]() type 
  * **ioCb** function pointer to a IO callback (see examples/tpm_io.h) 
  * **userCtx** pointer to a user context (can be NULL)


**See**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Cleanup

```
WOLFTPM_API int wolfTPM2_Cleanup(
    WOLFTPM2_DEV * dev
)
```

Easy to use TPM and wolfcrypt deinitialization. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Calls wolfTPM2_Cleanup_ex with appropriate doShutdown parameter

_Example_

```cpp
int rc;

rc = wolfTPM2_Cleanup(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup failed
    goto exit;
}
```


#### function wolfTPM2_Cleanup_ex

```
WOLFTPM_API int wolfTPM2_Cleanup_ex(
    WOLFTPM2_DEV * dev,
    int doShutdown
)
```

Deinitialization of a TPM (and wolfcrypt if it was used) 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type 
  * **doShutdown** flag value, if true a TPM2_Shutdown command will be executed


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_Cleanup_ex(&dev, 1);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```


#### function wolfTPM2_GetTpmDevId

```
WOLFTPM_API int wolfTPM2_GetTpmDevId(
    WOLFTPM2_DEV * dev
)
```

Provides the device ID of a TPM. 

**Parameters**: 

  * **dev** pointer to an populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_GetCapabilities](#function-wolftpm2-getcapabilities)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * an integer value of a valid TPM device ID 
  * or INVALID_DEVID if the TPM initialization could not extract DevID


_Example_

```cpp
int tpmDevId;

tpmDevId = wolfTPM2_GetTpmDevId(&dev);
if (tpmDevId != INVALID_DEVID) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```


#### function wolfTPM2_SelfTest

```
WOLFTPM_API int wolfTPM2_SelfTest(
    WOLFTPM2_DEV * dev
)
```

Asks the TPM to perform its self test. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type


**See**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_SelfTest(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_SelfTest failed
    goto exit;
}
```


#### function wolfTPM2_GetCapabilities

```
WOLFTPM_API int wolfTPM2_GetCapabilities(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CAPS * caps
)
```

Reported the available TPM capabilities. 

**Parameters**: 

  * **dev** pointer to a populated structure of [WOLFTPM2_DEV]() type 
  * **caps** pointer to an empty structure of [WOLFTPM2_CAPS]() type to store the capabilities


**See**: 

  * [wolfTPM2_GetTpmDevId](#function-wolftpm2-gettpmdevid)
  * [wolfTPM2_SelfTest](#function-wolftpm2-selftest)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO communication and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


_Example_

```cpp
int rc;
WOLFTPM2_CAPS caps;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_GetCapabilities(&dev, &caps);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_GetCapabilities failed
    goto exit;
}
```


#### function wolfTPM2_UnsetAuth

```
WOLFTPM_API int wolfTPM2_UnsetAuth(
    WOLFTPM2_DEV * dev,
    int index
)
```

Clears one of the TPM Authorization slots, pointed by its index number. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: unable to get lock on the TPM2 Context 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_SetAuth

```
WOLFTPM_API int wolfTPM2_SetAuth(
    WOLFTPM2_DEV * dev,
    int index,
    TPM_HANDLE sessionHandle,
    const TPM2B_AUTH * auth,
    TPMA_SESSION sessionAttributes,
    const TPM2B_NAME * name
)
```

Sets a TPM Authorization slot using the provided index, session handle, attributes and auth. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **sessionHandle** integer value of TPM_HANDLE type 
  * **auth** pointer to a structure of type TPM2B_AUTH containing one TPM Authorization 
  * **sessionAttributes** integer value of type TPMA_SESSION, selecting one or more attributes for the Session 
  * **name** pointer to a [TPM2B_NAME]() structure


**See**: 

  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: It is recommended to use one of the other wolfTPM2 wrappers, like wolfTPM2_SetAuthPassword. Because the wolfTPM2_SetAuth wrapper provides complete control over the TPM Authorization slot for advanced use cases. In most scenarios, wolfTPM2_SetAuthHandle and SetAuthPassword are used.

#### function wolfTPM2_SetAuthPassword

```
WOLFTPM_API int wolfTPM2_SetAuthPassword(
    WOLFTPM2_DEV * dev,
    int index,
    const TPM2B_AUTH * auth
)
```

Sets a TPM Authorization slot using the provided user auth, typically a password. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **auth** pointer to a structure of type TPM2B_AUTH, typically containing a TPM Key Auth


**See**: 

  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Often used for authorizing the loading and use of TPM keys, including Primary Keys

#### function wolfTPM2_SetAuthHandle

```
WOLFTPM_API int wolfTPM2_SetAuthHandle(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

Sets a TPM Authorization slot using the user auth associated with a wolfTPM2 Handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **handle** pointer to a populated structure of WOLFTPM2_HANDLE type


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper is especially useful when using a TPM key for multiple operations and TPM Authorization is required again.

#### function wolfTPM2_SetAuthSession

```
WOLFTPM_API int wolfTPM2_SetAuthSession(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_SESSION * tpmSession,
    TPMA_SESSION sessionAttributes
)
```

Sets a TPM Authorization slot using the provided TPM session handle, index and session attributes. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **tpmSession** sessionHandle integer value of TPM_HANDLE type 
  * **sessionAttributes** integer value of type TPMA_SESSION, selecting one or more attributes for the Session


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper is useful for configuring TPM sessions, e.g. session for parameter encryption

#### function wolfTPM2_SetAuthHandleName

```
WOLFTPM_API int wolfTPM2_SetAuthHandleName(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

Updates the Name used in a TPM Session with the Name associated with wolfTPM2 Handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **index** integer value, specifying the TPM Authorization slot, between zero and three 
  * **handle** pointer to a populated structure of WOLFTPM2_HANDLE type


**See**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Typically, this wrapper is used from another wrappers and in very specific use cases. For example, wolfTPM2_NVWriteAuth

#### function wolfTPM2_StartSession

```
WOLFTPM_API int wolfTPM2_StartSession(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * session,
    WOLFTPM2_KEY * tpmKey,
    WOLFTPM2_HANDLE * bind,
    TPM_SE sesType,
    int encDecAlg
)
```

Create a TPM session, Policy, HMAC or Trial. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **session** pointer to an empty [WOLFTPM2_SESSION]() struct 
  * **tpmKey** pointer to a [WOLFTPM2_KEY]() that will be used as a salt for the session 
  * **bind** pointer to a WOLFTPM2_HANDLE that will be used to make the session bounded 
  * **sesType** byte value, the session type (HMAC, Policy or Trial) 
  * **encDecAlg** integer value, specifying the algorithm in case of parameter encryption


**See**: [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This wrapper can also be used to start TPM session for parameter encryption, see wolfTPM nvram or keygen example

#### function wolfTPM2_CreateAuthSession_EkPolicy

```
WOLFTPM_API int wolfTPM2_CreateAuthSession_EkPolicy(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * tpmSession
)
```

Creates a TPM session with Policy Secret to satisfy the default EK policy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **session** pointer to an empty [WOLFTPM2_SESSION]() struct


**See**: 

  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * wolfTPM2_StartAuthSession 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments 
  * TPM_RC_FAILURE: check TPM return code, check available handles, check TPM IO


**Note**: This wrapper can be used only if the EK authorization is not changed from default

#### function wolfTPM2_CreatePrimaryKey

```
WOLFTPM_API int wolfTPM2_CreatePrimaryKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_HANDLE primaryHandle,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to prepare and create a TPM 2.0 Primary Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **primaryHandle** integer value, specifying one of four TPM 2.0 Primary Seeds: TPM_RH_OWNER, TPM_RH_ENDORSEMENT, TPM_RH_PLATFORM or TPM_RH_NULL 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization for the Primary Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: TPM 2.0 allows only asymmetric RSA or ECC primary keys. Afterwards, both symmetric and asymmetric keys can be created under a TPM 2.0 Primary Key Typically, Primary Keys are used to create Hierarchies of TPM 2.0 Keys. The TPM uses a Primary Key to wrap the other keys, signing or decrypting.

#### function wolfTPM2_ChangeAuthKey

```
WOLFTPM_API int wolfTPM2_ChangeAuthKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    const byte * auth,
    int authSz
)
```

Change the authorization secret of a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_UnloadHandle](#function-wolftpm2-unloadhandle)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: TPM does not allow the authorization secret of a Primary Key to be changed. Instead, use wolfTPM2_CreatePrimary to create the same PrimaryKey with a new auth.

#### function wolfTPM2_CreateKey

```
WOLFTPM_API int wolfTPM2_CreateKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to prepare and create a TPM 2.0 Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying the a 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This function only creates the key material and stores it into the keyblob argument. To load the key use wolfTPM2_LoadKey

#### function wolfTPM2_LoadKey

```
WOLFTPM_API int wolfTPM2_LoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent
)
```

Single function to load a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to a struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key)


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: To load a TPM 2.0 key its parent(Primary Key) should also be loaded prior to this operation. Primary Keys are laoded when they are created.

#### function wolfTPM2_CreateAndLoadKey

```
WOLFTPM_API int wolfTPM2_CreateAndLoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Single function to create and load a TPM 2.0 Key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_CreateLoadedKey

```
WOLFTPM_API int wolfTPM2_CreateLoadedKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

Creates and loads a key using single TPM 2.0 operation, and stores encrypted private key material. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type, contains private key material as encrypted data 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying a TPM 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated manually or using one of the wolfTPM2_GetKeyTemplate_... wrappers 
  * **auth** pointer to a string constant, specifying the password authorization of the TPM 2.0 key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateAndLoadKey](#function-wolftpm2-createandloadkey)
  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadPublicKey

```
WOLFTPM_API int wolfTPM2_LoadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub
)
```

Wrapper to load the public part of an external key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * wolfTPM2_wolfTPM2_LoadPrivateKey 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The key must be formated to the format expected by the TPM, see the 'pub' argument and the alternative wrappers.

#### function wolfTPM2_LoadPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

Single function to import an external private key and load it into the TPM in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **sens** pointer to a populated structure of [TPM2B_SENSITIVE]() type


**See**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The private key material needs to be prepared in a format that the TPM expects, see the 'sens' argument

#### function wolfTPM2_ImportPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

Single function to import an external private key and load it into the TPM in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type 
  * **sens** pointer to a populated structure of [TPM2B_SENSITIVE]() type


**See**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The primary key material needs to be prepared in a format that the TPM expects, see the 'sens' argument

#### function wolfTPM2_LoadRsaPublicKey

```
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent
)
```

Helper function to import the public part of an external RSA key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer containing the public key material 
  * **rsaPubSz** integer value of word32 type, specifying the buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent


**See**: 

  * [wolfTPM2_LoadRsaPublicKey_ex](#function-wolftpm2-loadrsapublickey-ex)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Recommended for use, because it does not require TPM format of the public part

#### function wolfTPM2_LoadRsaPublicKey_ex

```
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to import the public part of an external RSA key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer containing the public key material 
  * **rsaPubSz** integer value of word32 type, specifying the buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** value of TPMI_ALG_HASH type, specifying the TPM hashing algorithm


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the developer to specify TPM hashing algorithm and RSA scheme

#### function wolfTPM2_ImportRsaPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Import an external RSA private key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments 
  * BUFFER_E: arguments size is larger than what the TPM buffers allow


#### function wolfTPM2_LoadRsaPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz
)
```

Helper function to import and load an external RSA private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size


**See**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadRsaPrivateKey_ex

```
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to import and load an external RSA private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **rsaPub** pointer to a byte buffer, containing the public part of the RSA key 
  * **rsaPubSz** integer value of word32 type, specifying the public part buffer size 
  * **exponent** integer value of word32 type, specifying the RSA exponent 
  * **rsaPriv** pointer to a byte buffer, containing the private material of the RSA key 
  * **rsaPrivSz** integer value of word32 type, specifying the private material buffer size 
  * **scheme** value of TPMI_ALG_RSA_SCHEME type, specifying the RSA scheme 
  * **hashAlg** value of TPMI_ALG_HASH type, specifying the TPM hashing algorithm


**See**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)
  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadEccPublicKey

```
WOLFTPM_API int wolfTPM2_LoadEccPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz
)
```

Helper function to import the public part of an external ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size


**See**: 

  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Recommended for use, because it does not require TPM format of the public part

#### function wolfTPM2_ImportEccPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

Helper function to import the private material of an external ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size 
  * **eccPriv** pointer to a byte buffer containing the private material 
  * **eccPrivSz** integer value of word32 type, specifying the private material size


**See**: 

  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)
  * wolfTPM2_LoadEccPrivateKey_ex 
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_LoadEccPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

Helper function to import and load an external ECC private key in one step. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a struct of WOLFTPM2_HANDLE type (can be NULL for external keys and the key will be imported under the OWNER hierarchy) 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **curveId** integer value, one of the accepted TPM_ECC_CURVE values 
  * **eccPubX** pointer to a byte buffer containing the public material of point X 
  * **eccPubXSz** integer value of word32 type, specifying the point X buffer size 
  * **eccPubY** pointer to a byte buffer containing the public material of point Y 
  * **eccPubYSz** integer value of word32 type, specifying the point Y buffer size 
  * **eccPriv** pointer to a byte buffer containing the private material 
  * **eccPrivSz** integer value of word32 type, specifying the private material size


**See**: 

  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ReadPublicKey

```
WOLFTPM_API int wolfTPM2_ReadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM_HANDLE handle
)
```

Helper function to receive the public part of a loaded TPM object using its handle. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty struct of [WOLFTPM2_KEY]() type 
  * **handle** integer value of TPM_HANDLE type, specifying handle of a loaded TPM object


**See**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The public part of a TPM symmetric keys contains just TPM meta data

#### function wolfTPM2_CreateKeySeal

```
WOLFTPM_API int wolfTPM2_CreateKeySeal(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz,
    const byte * sealData,
    int sealSize
)
```

Using this wrapper a secret can be sealed inside a TPM 2.0 Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to an empty struct of [WOLFTPM2_KEYBLOB]() type 
  * **parent** pointer to a struct of WOLFTPM2_HANDLE type, specifying the a 2.0 Primary Key to be used as the parent(Storage Key) 
  * **publicTemplate** pointer to a [TPMT_PUBLIC]() structure populated using one of the wolfTPM2_GetKeyTemplate_KeySeal 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes 
  * **sealData** pointer to a byte buffer, containing the secret(user data) to be sealed 
  * **sealSize** integer value, specifying the size of the seal buffer, in bytes


**See**: 

  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)
  * [TPM2_Unseal](#function-tpm2-unseal)
  * wolfTPM2_CreatePrimary 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The secret size can not be larger than 128 bytes

#### function wolfTPM2_ComputeName

```
WOLFTPM_API int wolfTPM2_ComputeName(
    const TPM2B_PUBLIC * pub,
    TPM2B_NAME * out
)
```

Helper function to generate a hash of the public area of an object in the format expected by the TPM. 

**Parameters**: 

  * **pub** pointer to a populated structure of [TPM2B_PUBLIC]() type, containing the public area of a TPM object 
  * **out** pointer to an empty struct of [TPM2B_NAME]() type, to store the computed name


**See**: [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Computed TPM name includes hash of the TPM_ALG_ID and the public are of the object

#### function wolfTPM2_SensitiveToPrivate

```
WOLFTPM_API int wolfTPM2_SensitiveToPrivate(
    TPM2B_SENSITIVE * sens,
    TPM2B_PRIVATE * priv,
    TPMI_ALG_HASH nameAlg,
    TPM2B_NAME * name,
    const WOLFTPM2_KEY * parentKey,
    TPMT_SYM_DEF_OBJECT * sym,
    TPM2B_ENCRYPTED_SECRET * symSeed
)
```

Helper function to convert [TPM2B_SENSITIVE](). 

**Parameters**: 

  * **sens** pointer to a correctly populated structure of [TPM2B_SENSITIVE]() type 
  * **priv** pointer to an empty struct of [TPM2B_PRIVATE]() type 
  * **nameAlg** integer value of TPMI_ALG_HASH type, specifying a valid TPM2 hashing algorithm 
  * **name** pointer to a [TPM2B_NAME]() structure 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() structure, specifying a parentKey, if it exists 
  * **sym** pointer to a structure of TPMT_SYM_DEF_OBJECT type 
  * **symSeed** pointer to a structure of [TPM2B_ENCRYPTED_SECRET]() type


**See**: [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_TpmToWolf

```
WOLFTPM_API int wolfTPM2_RsaKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    RsaKey * wolfKey
)
```

Extract a RSA TPM key and convert it to a wolfcrypt key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **wolfKey** pointer to an empty struct of RsaKey type, to store the converted key


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_WolfToTpm_ex](#function-wolftpm2-rsakey-wolftotpm-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_TpmToPemPub

```
WOLFTPM_API int wolfTPM2_RsaKey_TpmToPemPub(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * keyBlob,
    byte * pem,
    word32 * pemSz
)
```

Convert a public RSA TPM key to PEM format public key Note: pem and tempBuf must be different buffers, of equal size. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **keyBlob** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **pem** pointer to an array of byte type, used as temporary storage for PEM conversation 
  * **pemSz** pointer to integer variable, to store the used buffer size


**See**: 

  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)
  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaKey_WolfToTpm

```
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a RSA wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of RsaKey type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated keys by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_RsaKey_WolfToTpm_ex

```
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a RSA wolfcrypt key into the TPM under a specific Primary Key or Hierarchy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() struct, pointing to a Primary Key or TPM Hierarchy 
  * **wolfKey** pointer to a struct of RsaKey type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of wolfcrypt generated keys with wolfTPM

#### function wolfTPM2_RsaKey_PubPemToTpm

```
WOLFTPM_API int wolfTPM2_RsaKey_PubPemToTpm(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    const byte * pem,
    word32 pemSz
)
```

Import a PEM format public key from a file into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key 
  * **pem** pointer to an array of byte type, containing a PEM formated public key material 
  * **pemSz** pointer to integer variable, specifying the size of PEM key data


**See**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * wolfTPM2_RsaKey_TpmToPem 
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code)


#### function wolfTPM2_EccKey_TpmToWolf

```
WOLFTPM_API int wolfTPM2_EccKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    ecc_key * wolfKey
)
```

Extract a ECC TPM key and convert to to a wolfcrypt key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **tpmKey** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key 
  * **wolfKey** pointer to an empty struct of ecc_key type, to store the converted key


**See**: 

  * [wolfTPM2_EccKey_WolfToTpm](#function-wolftpm2-ecckey-wolftotpm)
  * [wolfTPM2_EccKey_WolfToTpm_ex](#function-wolftpm2-ecckey-wolftotpm-ex)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_EccKey_WolfToTpm

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import a ECC wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated keys by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_EccKey_WolfToTpm_ex

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

Import ECC wolfcrypt key into the TPM under a specific Primary Key or Hierarchy. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a [WOLFTPM2_KEY]() struct, pointing to a Primary Key or TPM Hierarchy 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt key 
  * **tpmKey** pointer to an empty struct of [WOLFTPM2_KEY]() type, to hold the imported TPM key


**See**: 

  * wolfTPM2_EccKey_WolfToTPM 
  * [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of wolfcrypt generated keys with wolfTPM

#### function wolfTPM2_EccKey_WolfToPubPoint

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToPubPoint(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    TPM2B_ECC_POINT * pubPoint
)
```

Import a ECC public key generated from wolfcrypt key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **wolfKey** pointer to a struct of ecc_key type, holding a wolfcrypt public ECC key 
  * **pubPoint** pointer to an empty struct of [TPM2B_ECC_POINT]() type


**See**: [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Allows the use of externally generated public ECC key by wolfcrypt to be used with TPM 2.0

#### function wolfTPM2_SignHash

```
WOLFTPM_API int wolfTPM2_SignHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz
)
```

Helper function to sign arbitrary data using a TPM key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **digest** pointer to a byte buffer, containing the arbitrary data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes


**See**: 

  * verifyHash 
  * signHashScheme 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_SignHashScheme

```
WOLFTPM_API int wolfTPM2_SignHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to sign arbitrary data using a TPM key, and specify the signature scheme and hashing algorithm. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **digest** pointer to a byte buffer, containing the arbitrary data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **sigAlg** integer value of TPMI_ALG_SIG_SCHEME type, specifying a supported TPM 2.0 signature scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * signHash 
  * verifyHash 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_VerifyHash

```
WOLFTPM_API int wolfTPM2_VerifyHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz
)
```

Helper function to verify a TPM generated signature. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM 2.0 key material 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **digest** pointer to a byte buffer, containing the signed data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes


**See**: 

  * signHash 
  * signHashScheme 
  * verifyHashScheme 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_VerifyHashScheme

```
WOLFTPM_API int wolfTPM2_VerifyHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

Advanced helper function to verify a TPM generated signature. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM 2.0 key material 
  * **sig** pointer to a byte buffer, containing the generated signature 
  * **sigSz** integer value, specifying the size of the signature buffer, in bytes 
  * **digest** pointer to a byte buffer, containing the signed data 
  * **digestSz** integer value, specifying the size of the digest buffer, in bytes 
  * **sigAlg** integer value of TPMI_ALG_SIG_SCHEME type, specifying a supported TPM 2.0 signature scheme 
  * **hashAlg** integer value of TPMI_ALG_HASH type, specifying a supported TPM 2.0 hash algorithm


**See**: 

  * signHash 
  * signHashScheme 
  * verifyHash 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHGenKey

```
WOLFTPM_API int wolfTPM2_ECDHGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id,
    const byte * auth,
    int authSz
)
```

Generates and then loads a ECC key-pair with NULL hierarchy for Diffie-Hellman exchange. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ecdhKey** pointer to an empty structure of [WOLFTPM2_KEY]() type 
  * **curve_id** integer value, specifying a valid TPM_ECC_CURVE value 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHGen

```
WOLFTPM_API int wolfTPM2_ECDHGen(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Generates ephemeral key and computes Z (shared secret) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **privKey** pointer to a structure of [WOLFTPM2_KEY]() type 
  * **pubPoint** pointer to an empty structure of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the generated shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: One shot API using private key handle to generate key-pair and return public point and shared secret

#### function wolfTPM2_ECDHGenZ

```
WOLFTPM_API int wolfTPM2_ECDHGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Computes Z (shared secret) using pubPoint and loaded private ECC key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **privKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle 
  * **pubPoint** pointer to a populated structure of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the computed shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ECDHEGenKey

```
WOLFTPM_API int wolfTPM2_ECDHEGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id
)
```

Generates ephemeral ECC key and returns array index (2 phase method) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ecdhKey** pointer to an empty structure of [WOLFTPM2_KEY]() type 
  * **curve_id** integer value, specifying a valid TPM_ECC_CURVE value


**See**: 

  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: One time use key

#### function wolfTPM2_ECDHEGenZ

```
WOLFTPM_API int wolfTPM2_ECDHEGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * ecdhKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

Computes Z (shared secret) using pubPoint and counter (2 phase method) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parentKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **ecdhKey** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle 
  * **pubPoint** pointer to an empty struct of [TPM2B_ECC_POINT]() type 
  * **out** pointer to a byte buffer, to store the computed shared secret 
  * **outSz** integer value, specifying the size of the shared secret, in bytes


**See**: 

  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The counter, array ID, can only be used one time

#### function wolfTPM2_RsaEncrypt

```
WOLFTPM_API int wolfTPM2_RsaEncrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * msg,
    int msgSz,
    byte * out,
    int * outSz
)
```

Perform RSA encryption using a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **padScheme** integer value of TPM_ALG_ID type, specifying the padding scheme 
  * **msg** pointer to a byte buffer, containing the arbitrary data for encryption 
  * **msgSz** integer value, specifying the size of the arbitrary data buffer 
  * **out** pointer to a byte buffer, where the encrypted data will be stored 
  * **outSz** integer value, specifying the size of the encrypted data buffer


**See**: [wolfTPM2_RsaDecrypt](#function-wolftpm2-rsadecrypt)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_RsaDecrypt

```
WOLFTPM_API int wolfTPM2_RsaDecrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * in,
    int inSz,
    byte * msg,
    int * msgSz
)
```

Perform RSA decryption using a TPM 2.0 key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to a struct of [WOLFTPM2_KEY]() type, holding a TPM key material 
  * **padScheme** integer value of TPM_ALG_ID type, specifying the padding scheme 
  * **in** pointer to a byte buffer, containing the encrypted data 
  * **inSz** integer value, specifying the size of the encrypted data buffer 
  * **msg** pointer to a byte buffer, containing the decrypted data 
  * **msgSz** pointer to size of the encrypted data buffer, on return set actual size


**See**: wolfTPM2_RsaEcnrypt 

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ReadPCR

```
WOLFTPM_API int wolfTPM2_ReadPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    byte * digest,
    int * pDigestLen
)
```

Read the values of a specified TPM 2.0 Platform Configuration Registers(PCR) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **pcrIndex** integer value, specifying a valid PCR index, between 0 and 23 (TPM locality could have an impact on successful access) 
  * **hashAlg** integer value, specifying a TPM_ALG_SHA256 or TPM_ALG_SHA1 registers to be accessed 
  * **digest** pointer to a byte buffer, where the PCR values will be stored 
  * **pDigestLen** pointer to an integer variable, where the size of the digest buffer will be stored


**See**: [wolfTPM2_ExtendPCR](#function-wolftpm2-extendpcr)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure to specify the correct hashing algorithm, because there are two sets of PCR registers, one for SHA256 and the other for SHA1(deprecated, but still possible to be read)

#### function wolfTPM2_ExtendPCR

```
WOLFTPM_API int wolfTPM2_ExtendPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    const byte * digest,
    int digestLen
)
```

Extend a PCR register with a user provided digest. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **pcrIndex** integer value, specifying a valid PCR index, between 0 and 23 (TPM locality could have an impact on successful access) 
  * **hashAlg** integer value, specifying a TPM_ALG_SHA256 or TPM_ALG_SHA1 registers to be accessed 
  * **digest** pointer to a byte buffer, containing the digest value to be extended into the PCR 
  * **digestLen** the size of the digest buffer


**See**: [wolfTPM2_ReadPCR](#function-wolftpm2-readpcr)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure to specify the correct hashing algorithm

#### function wolfTPM2_NVCreateAuth

```
WOLFTPM_API int wolfTPM2_NVCreateAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

Creates a new NV Index to be later used for storing data into the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parent** pointer to a WOLFTPM2_HANDLE, specifying the TPM hierarchy for the new NV Index 
  * **nv** pointer to an empty structure of [WOLFTPM2_NV]() type, to hold the new NV Index 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success 
  * **nvAttributes** integer value, use wolfTPM2_GetNvAttributesTemplate to create correct value 
  * **maxSize** integer value, specifying the maximum number of bytes written at this NV Index 
  * **auth** pointer to a string constant, specifying the password authorization for this NV Index 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: This is a wolfTPM2 wrapper around TPM2_NV_DefineSpace

#### function wolfTPM2_NVWriteAuth

```
WOLFTPM_API int wolfTPM2_NVWriteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

Stores user data to a NV Index, at a given offest. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nv** pointer to a populated structure of [WOLFTPM2_NV]() type 
  * **nvIndex** integer value, holding an existing NV Index Handle value 
  * **dataBuf** pointer to a byte buffer, containing the user data to be written to the TPM's NVRAM 
  * **dataSz** integer value, specifying the size of the user data buffer, in bytes 
  * **offset** integer value of word32 type, specifying the offset from the NV Index memory start, can be zero


**See**: 

  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: User data size should be less or equal to the NV Index maxSize specified using wolfTPM2_CreateAuth

#### function wolfTPM2_NVReadAuth

```
WOLFTPM_API int wolfTPM2_NVReadAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 * pDataSz,
    word32 offset
)
```

Reads user data from a NV Index, starting at the given offset. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nv** pointer to a populated structure of [WOLFTPM2_NV]() type 
  * **nvIndex** integer value, holding an existing NV Index Handle value 
  * **dataBuf** pointer to an empty byte buffer, used to store the read data from the TPM's NVRAM 
  * **pDataSz** pointer to an integer variable, used to store the size of the data read from NVRAM, in bytes 
  * **offset** integer value of word32 type, specifying the offset from the NV Index memory start, can be zero


**See**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: User data size should be less or equal to the NV Index maxSize specified using wolfTPM2_CreateAuth

#### function wolfTPM2_NVDeleteAuth

```
WOLFTPM_API int wolfTPM2_NVDeleteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    word32 nvIndex
)
```

Destroys an existing NV Index. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **parent** pointer to a WOLFTPM2_HANDLE, specifying the TPM hierarchy for the new NV Index 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success


**See**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVCreate

```
WOLFTPM_API int wolfTPM2_NVCreate(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)

#### function wolfTPM2_NVWrite

```
WOLFTPM_API int wolfTPM2_NVWrite(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)

#### function wolfTPM2_NVRead

```
WOLFTPM_API int wolfTPM2_NVRead(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 * dataSz,
    word32 offset
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)

#### function wolfTPM2_NVDelete

```
WOLFTPM_API int wolfTPM2_NVDelete(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex
)
```

Deprecated, use newer API. 

**See**: [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)

#### function wolfTPM2_NVReadPublic

```
WOLFTPM_API int wolfTPM2_NVReadPublic(
    WOLFTPM2_DEV * dev,
    word32 nvIndex,
    TPMS_NV_PUBLIC * nvPublic
)
```

Extracts the public information about an nvIndex, such as maximum size. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **nvIndex** integer value, holding the NV Index Handle given by the TPM upon success 
  * **nvPublic** pointer to a [TPMS_NV_PUBLIC](), used to store the extracted nvIndex public information


**See**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVStoreKey

```
WOLFTPM_API int wolfTPM2_NVStoreKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key,
    TPM_HANDLE persistentHandle
)
```

Helper function to store a TPM 2.0 Key into the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **primaryHandle** integer value, specifying a TPM 2.0 Hierarchy. typically TPM_RH_OWNER 
  * **key** pointer to a structure of [WOLFTPM2_KEY]() type, containing the TPM 2.0 key for storing 
  * **persistentHandle** integer value, specifying an existing nvIndex


**See**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_NVDeleteKey

```
WOLFTPM_API int wolfTPM2_NVDeleteKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key
)
```

Helper function to delete a TPM 2.0 Key from the TPM's NVRAM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **primaryHandle** integer value, specifying a TPM 2.0 Hierarchy. typically TPM_RH_OWNER 
  * **key** pointer to a structure of [WOLFTPM2_KEY]() type, containing the nvIndex handle value


**See**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetRng

```
WOLFTPM_API struct WC_RNG * wolfTPM2_GetRng(
    WOLFTPM2_DEV * dev
)
```

Get the wolfcrypt RNG instance used for wolfTPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Only if wolfcrypt is enabled and configured for use instead of the TPM RNG

#### function wolfTPM2_GetRandom

```
WOLFTPM_API int wolfTPM2_GetRandom(
    WOLFTPM2_DEV * dev,
    byte * buf,
    word32 len
)
```

Get a set of random number, generated with the TPM RNG or wolfcrypt RNG. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **buf** pointer to a byte buffer, used to store the generated random numbers 
  * **len** integer value of word32 type, used to store the size of the buffer, in bytes


**See**: [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Define WOLFTPM2_USE_HW_RNG to use the TPM RNG source

#### function wolfTPM2_UnloadHandle

```
WOLFTPM_API int wolfTPM2_UnloadHandle(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * handle
)
```

Use to discard any TPM loaded object. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **handle** pointer to a structure of WOLFTPM2_HANDLE type, with a valid TPM 2.0 handle value


**See**: [wolfTPM2_Clear](#function-wolftpm2-clear)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Clear

```
WOLFTPM_API int wolfTPM2_Clear(
    WOLFTPM2_DEV * dev
)
```

Deinitializes wolfTPM and wolfcrypt(if enabled) 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: [wolfTPM2_Clear](#function-wolftpm2-clear)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HashStart

```
WOLFTPM_API int wolfTPM2_HashStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    TPMI_ALG_HASH hashAlg,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Helper function to start a TPM generated hash. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **usageAuth** pointer to a string constant, specifying the authorization for subsequent use of the hash 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HashUpdate

```
WOLFTPM_API int wolfTPM2_HashUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    const byte * data,
    word32 dataSz
)
```

Update a TPM generated hash with new user data. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **data** pointer to a byte buffer, containing the user data to be added to the hash 
  * **dataSz** integer value of word32 type, specifying the size of the user data, in bytes


**See**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the auth is correctly set

#### function wolfTPM2_HashFinish

```
WOLFTPM_API int wolfTPM2_HashFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    byte * digest,
    word32 * digestSz
)
```

Finalize a TPM generated hash and get the digest output in a user buffer. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hash** pointer to a [WOLFTPM2_HASH]() structure 
  * **digest** pointer to a byte buffer, used to store the resulting digest 
  * **digestSz** pointer to size of digest buffer, on return set to bytes stored in digest buffer


**See**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the auth is correctly set

#### function wolfTPM2_LoadKeyedHashKey

```
WOLFTPM_API int wolfTPM2_LoadKeyedHashKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    int hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Creates and loads a new TPM key of KeyedHash type, typically used for HMAC operations. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty structure of [WOLFTPM2_KEY]() type, to store the generated key 
  * **parent** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **keyBuf** pointer to a byte array, containing derivation values for the new KeyedHash key 
  * **keySz** integer value, specifying the size of the derivation values stored in keyBuf, in bytes 
  * **usageAuth** pointer to a string constant, specifying the authorization of the new key 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: To generate HMAC using the TPM it is recommended to use the wolfTPM2_Hmac wrappers

#### function wolfTPM2_HmacStart

```
WOLFTPM_API int wolfTPM2_HmacStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    WOLFTPM2_HANDLE * parent,
    TPMI_ALG_HASH hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

Helper function to start a TPM generated hmac. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **parent** pointer to a structure of [WOLFTPM2_KEY]() type, containing a valid TPM handle of a primary key 
  * **hashAlg** integer value, specifying a valid TPM 2.0 hash algorithm 
  * **keyBuf** pointer to a byte array, containing derivation values for the new KeyedHash key 
  * **keySz** integer value, specifying the size of the derivation values stored in keyBuf, in bytes 
  * **usageAuth** pointer to a string constant, specifying the authorization for subsequent use of the hmac 
  * **usageAuthSz** integer value, specifying the size of the authorization, in bytes


**See**: 

  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)
  * [wolfTPM2_LoadKeyedHashKey](#function-wolftpm2-loadkeyedhashkey)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_HmacUpdate

```
WOLFTPM_API int wolfTPM2_HmacUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    const byte * data,
    word32 dataSz
)
```

Update a TPM generated hmac with new user data. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **data** pointer to a byte buffer, containing the user data to be added to the hmac 
  * **dataSz** integer value of word32 type, specifying the size of the user data, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * wolfTPM2_HMACFinish 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the TPM authorization is correctly set

#### function wolfTPM2_HmacFinish

```
WOLFTPM_API int wolfTPM2_HmacFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    byte * digest,
    word32 * digestSz
)
```

Finalize a TPM generated hmac and get the digest output in a user buffer. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **hmac** pointer to a [WOLFTPM2_HMAC]() structure 
  * **digest** pointer to a byte buffer, used to store the resulting hmac digest 
  * **digestSz** integer value of word32 type, specifying the size of the digest, in bytes


**See**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Make sure the TPM authorization is correctly set

#### function wolfTPM2_LoadSymmetricKey

```
WOLFTPM_API int wolfTPM2_LoadSymmetricKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int alg,
    const byte * keyBuf,
    word32 keySz
)
```

Loads an external symmetric key into the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **key** pointer to an empty structure of [WOLFTPM2_KEY]() type, to store the TPM handle and key information 
  * **alg** integer value, specifying a valid TPM 2.0 symmetric key algorithm, e.g. TPM_ALG_CFB for AES CFB 
  * **keyBuf** pointer to a byte array, containing private material of the symmetric key 
  * **keySz** integer value, specifying the size of the key material stored in keyBuf, in bytes


**See**: 

  * [wolfTPM2_EncryptDecryptBlock](#function-wolftpm2-encryptdecryptblock)
  * [wolfTPM2_EncryptDecrypt](#function-wolftpm2-encryptdecrypt)
  * [TPM2_EncryptDecrypt2](#function-tpm2-encryptdecrypt2)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_SetCommand

```
WOLFTPM_API int wolfTPM2_SetCommand(
    WOLFTPM2_DEV * dev,
    TPM_CC commandCode,
    int enableFlag
)
```

Vendor specific TPM command, used to enable other restricted TPM commands. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **commandCode** integer value, representing a valid vendor command 
  * **enableFlag** integer value, non-zero values represent "to enable"


**See**: [TPM2_GPIO_Config](#function-tpm2-gpio-config)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_Shutdown

```
WOLFTPM_API int wolfTPM2_Shutdown(
    WOLFTPM2_DEV * dev,
    int doStartup
)
```

Helper function to shutdown or reset the TPM. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **doStartup** integer value, non-zero values represent "perform Startup after Shutdown"


**See**: [wolfTPM2_Init](#function-wolftpm2-init)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: If doStartup is set, then TPM2_Startup is performed right after TPM2_Shutdown

#### function wolfTPM2_UnloadHandles

```
WOLFTPM_API int wolfTPM2_UnloadHandles(
    WOLFTPM2_DEV * dev,
    word32 handleStart,
    word32 handleCount
)
```

One-shot API to unload subsequent TPM handles. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **handleStart** integer value of word32 type, specifying the value of the first TPM handle 
  * **handleCount** integer value of word32 type, specifying the number of handles


**See**: [wolfTPM2_Init](#function-wolftpm2-init)

**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_UnloadHandles_AllTransient

```
WOLFTPM_API int wolfTPM2_UnloadHandles_AllTransient(
    WOLFTPM2_DEV * dev
)
```

One-shot API to unload all transient TPM handles. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct


**See**: 

  * [wolfTPM2_UnloadHandles](#function-wolftpm2-unloadhandles)
  * wolfTPM2_CreatePrimary 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: If there are Primary Keys as transient objects, they need to be recreated before TPM keys can be used

#### function wolfTPM2_GetKeyTemplate_RSA

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes
)
```

Prepares a TPM public template for new RSA key based on user selected object attributes. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new RSA template 
  * **objectAttributes** integer value of TPMA_OBJECT type, can contain one or more attributes, e.g. TPMA_OBJECT_fixedTPM


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes,
    TPM_ECC_CURVE curve,
    TPM_ALG_ID sigScheme
)
```

Prepares a TPM public template for new ECC key based on user selected object attributes. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new ECC key template 
  * **objectAttributes** integer value of TPMA_OBJECT type, can contain one or more attributes, e.g. TPMA_OBJECT_fixedTPM 
  * **curve** integer value of TPM_ECC_CURVE type, specifying a TPM supported ECC curve ID 
  * **sigScheme** integer value of TPM_ALG_ID type, specifying a TPM supported signature scheme


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_Symmetric

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_Symmetric(
    TPMT_PUBLIC * publicTemplate,
    int keyBits,
    TPM_ALG_ID algMode,
    int isSign,
    int isDecrypt
)
```

Prepares a TPM public template for new Symmetric key. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new Symmetric key template 
  * **keyBits** integer value, specifying the size of the symmetric key, typically 128 or 256 bits 
  * **algMode** integer value of TPM_ALG_ID type, specifying a TPM supported symmetric algorithm, e.g. TPM_ALG_CFB for AES CFB 
  * **isSign** integer value, non-zero values represent "a signing key" 
  * **isDecrypt** integer value, non-zero values represent "a decryption key"


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_KeyedHash

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeyedHash(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID hashAlg,
    int isSign,
    int isDecrypt
)
```

Prepares a TPM public template for new KeyedHash key. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template 
  * **hashAlg** integer value of TPM_ALG_ID type, specifying a TPM supported hashing algorithm, e.g. TPM_ALG_SHA256 for SHA 256 
  * **isSign** integer value, non-zero values represent "a signing key" 
  * **isDecrypt** integer value, non-zero values represent "a decryption key"


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_KeySeal

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeySeal(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID nameAlg
)
```

Prepares a TPM public template for new key for sealing secrets. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template 
  * **nameAlg** integer value of TPM_ALG_ID type, specifying a TPM supported hashing algorithm, typically TPM_ALG_SHA256 for SHA 256


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: There are strict requirements for a Key Seal, therefore most of the key parameters are predetermined by the wrapper

#### function wolfTPM2_GetKeyTemplate_RSA_EK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_EK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating the TPM Endorsement Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_EK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_EK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating the TPM Endorsement Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_RSA_SRK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Storage Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_SRK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Storage Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_RSA_AIK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Attestation Key of RSA type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetKeyTemplate_ECC_AIK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

Prepares a TPM public template for generating a new TPM Attestation Key of ECC type. 

**Parameters**: 

  * **publicTemplate** pointer to an empty structure of [TPMT_PUBLIC]() type, to store the new template


**See**: 

  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetNvAttributesTemplate

```
WOLFTPM_API int wolfTPM2_GetNvAttributesTemplate(
    TPM_HANDLE auth,
    word32 * nvAttributes
)
```

Prepares a TPM NV Index template. 

**Parameters**: 

  * **auth** integer value, representing the TPM Hierarchy under which the new TPM NV index will be created 
  * **nvAttributes** pointer to an empty integer variable, to store the NV Attributes


**See**: 

  * wolfTPM2_CreateAuth 
  * wolfTPM2_WriteAuth 
  * wolfTPM2_ReadAuth 
  * wolfTPM2_DeleteAuth 


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_CreateEK

```
WOLFTPM_API int wolfTPM2_CreateEK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ekKey,
    TPM_ALG_ID alg
)
```

Generates a new TPM Endorsement key, based on the user selected algorithm, RSA or ECC. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **ekKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store information about the new EK 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC, see Note above


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Although only RSA and ECC can be used for EK, symmetric keys can be created and used by the TPM

#### function wolfTPM2_CreateSRK

```
WOLFTPM_API int wolfTPM2_CreateSRK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * srkKey,
    TPM_ALG_ID alg,
    const byte * auth,
    int authSz
)
```

Generates a new TPM Primary Key that will be used as a Storage Key for other TPM keys. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **srkKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store information about the new EK 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC, see Note above 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateEK](#function-wolftpm2-createek)
  * [wolfTPM2_CreateAndLoadAIK](#function-wolftpm2-createandloadaik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: Although only RSA and ECC can be used for EK, symmetric keys can be created and used by the TPM

#### function wolfTPM2_CreateAndLoadAIK

```
WOLFTPM_API int wolfTPM2_CreateAndLoadAIK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * aikKey,
    TPM_ALG_ID alg,
    WOLFTPM2_KEY * srkKey,
    const byte * auth,
    int authSz
)
```

Generates a new TPM Attestation Key under the provided Storage Key. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **aikKey** pointer to an empty [WOLFTPM2_KEY]() structure, to store the newly generated TPM key 
  * **alg** can be only TPM_ALG_RSA or TPM_ALG_ECC 
  * **srkKey** pointer to a [WOLFTPM2_KEY]() structure, pointing to valid TPM handle of a loaded Storage Key 
  * **auth** pointer to a string constant, specifying the password authorization for the TPM 2.0 Key 
  * **authSz** integer value, specifying the size of the password authorization, in bytes


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_GetTime

```
WOLFTPM_API int wolfTPM2_GetTime(
    WOLFTPM2_KEY * aikKey,
    GetTime_Out * getTimeOut
)
```

One-shot API to generate a TPM signed timestamp. 

**Parameters**: 

  * **aikKey** pointer to a [WOLFTPM2_KEY]() structure, containign valid TPM handle of a loaded attestation key 
  * **getTimeOut** pointer to an empty structure of [GetTime_Out]() type, to store the output of the command


**See**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


**Note**: The attestation key must be generated and loaded prior to this call

#### function wolfTPM2_CryptoDevCb

```
WOLFTPM_API int wolfTPM2_CryptoDevCb(
    int devId,
    wc_CryptoInfo * info,
    void * ctx
)
```

A reference crypto callback API for using the TPM for crypto offload. This callback function is registered using wolfTPM2_SetCryptoDevCb or wc_CryptoDev_RegisterDevice. 

**Parameters**: 

  * **devId** The devId used when registering the callback. Any signed integer value besides INVALID_DEVID 
  * **info** point to wc_CryptoInfo structure with detailed information about crypto type and parameters 
  * **ctx** The user context supplied when callback was registered with wolfTPM2_SetCryptoDevCb


**See**: 

  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * CRYPTOCB_UNAVAILABLE: Do not use TPM hardware, fall-back to default software crypto. 
  * WC_HW_E: generic hardware failure


#### function wolfTPM2_SetCryptoDevCb

```
WOLFTPM_API int wolfTPM2_SetCryptoDevCb(
    WOLFTPM2_DEV * dev,
    CryptoDevCallbackFunc cb,
    TpmCryptoDevCtx * tpmCtx,
    int * pDevId
)
```

Register a crypto callback function and return assigned devId. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **cb** The wolfTPM2_CryptoDevCb API is a template, but you can also provide your own 
  * **tpmCtx** The user supplied context. For wolfTPM2_CryptoDevCb use [TpmCryptoDevCtx](), but can also be your own. 
  * **pDevId** Pointer to automatically assigned device ID.


**See**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments


#### function wolfTPM2_ClearCryptoDevCb

```
WOLFTPM_API int wolfTPM2_ClearCryptoDevCb(
    WOLFTPM2_DEV * dev,
    int devId
)
```

Clears the registered crypto callback. 

**Parameters**: 

  * **dev** pointer to a TPM2_DEV struct 
  * **devId** The devId used when registering the callback


**See**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)


**Return**: 

  * TPM_RC_SUCCESS: successful 
  * TPM_RC_FAILURE: generic failure (check TPM IO and TPM return code) 
  * BAD_FUNC_ARG: check the provided arguments








