# Hardware and Platforms

## Hardware Acceleration

wolfSSL ships more than 30 hardware and platform ports in `wolfcrypt/src/port/`
(NXP, ST, Renesas, Microchip, Cypress PSoC 6, Silicon Labs, Espressif, Xilinx,
Intel QuickAssist and more), plus hand-optimized assembly for Intel AES-NI/AVX,
ARMv8 and RISC-V. Check that directory for your part before writing a driver.

## Crypto Callbacks

For hardware without an in-tree port, the crypto callback interface
(`--enable-cryptocb`) is the one hook you implement. Compared with the
alternatives in Mbed TLS:

- Crypto `_ALT` macros (3.6) replace a software implementation at compile
  time, for every caller. They are gone in 4.x.
- PSA drivers (4.x) follow a specification still marked beta. Only part of the
  dispatch layer is code-generated, and the rest is wired up by hand.
- wolfSSL crypto callbacks are registered at runtime under a device ID that an
  object or a whole TLS context opts into. A callback returns
  `CRYPTOCB_UNAVAILABLE` to fall back to software, and the interface covers
  hashes, ciphers, MACs, RNG and the classic and post-quantum public-key
  algorithms, so a secure element or HSM can take over ML-KEM or ML-DSA as
  well. ML-KEM decapsulation with a key held only by the device needs a wolfSSL
  release after 5.9.4.

Offloading ECDSA signing for every TLS connection on a context looks like
this:

```c
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/cryptocb.h>
#include <wolfssl/ssl.h>

#define MY_HW_DEVID 0x48570001

int my_hw_ecdsa_sign(const byte* hash, word32 hashSz, byte* sig,
                     word32* sigSz, ecc_key* key);

static int myHwCallback(int devId, wc_CryptoInfo* info, void* ctx)
{
    (void)devId;
    (void)ctx;
    if (info->algo_type == WC_ALGO_TYPE_PK &&
        info->pk.type == WC_PK_TYPE_ECDSA_SIGN) {
        return my_hw_ecdsa_sign(info->pk.eccsign.in, info->pk.eccsign.inlen,
                                info->pk.eccsign.out, info->pk.eccsign.outlen,
                                info->pk.eccsign.key);
    }
    return CRYPTOCB_UNAVAILABLE; /* everything else stays in software */
}

int use_hw(WOLFSSL_CTX* ctx)
{
    if (wc_CryptoCb_RegisterDevice(MY_HW_DEVID, myHwCallback, NULL) != 0)
        return -1;
    return wolfSSL_CTX_SetDevId(ctx, MY_HW_DEVID) == WOLFSSL_SUCCESS ? 0 : -1;
}
```

`sig` receives a DER signature; convert raw r and s with
`wc_ecc_rs_raw_to_sig()`. To keep the private key in the secure element, load
it with `wolfSSL_CTX_use_PrivateKey_Id()` and the same device ID. The same
mechanism powers wolfHSM, wolfTPM and PKCS#11, and PK callbacks
(`--enable-pkcallbacks`) offer a TLS-level alternative.

Call `use_hw()` before `wolfSSL_new()`: each `WOLFSSL` takes the context's
device ID when it is created. For a session that already exists, set it with
`wolfSSL_SetDevId()`.

## Zephyr

Zephyr's TLS sockets (`SOL_TLS`) are built on Mbed TLS. wolfSSL ships a
[Zephyr module](https://github.com/wolfSSL/wolfssl/tree/master/zephyr), and the
[wolfSSL OSP repository](https://github.com/wolfSSL/osp/tree/master/zephyr) has
a patch for each supported Zephyr release that switches the TLS sockets to
wolfSSL; re-apply it when you move to a new release. Subsystems that use the
PSA Crypto API, such as Bluetooth, run on wolfCrypt unchanged with
[wolfPSA](https://github.com/wolfSSL/wolfPSA) as Zephyr's PSA crypto provider.

## ESP-IDF

wolfSSL is available as a managed component in the Espressif Component
Registry. Build instructions and examples are in
[IDE/Espressif](https://github.com/wolfSSL/wolfssl/tree/master/IDE/Espressif)
in the wolfSSL repository.

## Other Platforms

wolfSSL has projects for more than 60 IDEs and platforms in its `IDE/`
directory, plus Arduino and PlatformIO packages and Linux and BSD kernel
modules. Builds without a configure step use `user_settings.h`, with templates
in `examples/configs/`.
