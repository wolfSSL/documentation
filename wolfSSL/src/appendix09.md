# wolfSM (ShangMi)

This appendix provides information about the Chinese National Standard's cryptographic algorithms known as ShangMi (SM) in wolfSSL.

wolfSM support includes:
* SM3 - Hash Function
* SM4 - Cipher
* SM2 - ECDH key agreement and a signature scheme using the specified 256-bit elliptic curve.

The code must be installed into wolfSSL in order to be used.

Note that the test and build configuration code is already in wolfSSL.

## Building wolfSM

Once the wolfSM files have been installed into wolfSSL, you can build SM algorithms into wolfSSL.

Choose which algorithms you require on the configure line:
* `--enable-sm3`
* `--enable-sm4-ecb`
* `--enable-sm4-cbc`
* `--enable-sm4-ctr`
* `--enable-sm4-gcm`
* `--enable-sm4-ccm`
* `--enable-sm2`

For example, to include SM3, SM4-GCM and SM2:

```sh
./autogen.sh
./configure --enable-sm3 --enable-sm4-gcm --enable-sm2
make
sudo make install
```

### Optimized SM2

To use optimized implementations of SM2 you can either use C only code or C code with the faster assembly code.

For C code only: `--enable-sp`
For C and assembly code: `--enable-sp --enable-sp-asm`

Optimized C code is available for 32 and 64 bit CPUs.

Assembly code is available for the following platforms:
* Intel x64
* Aarch64
* ARM 32-bit
* ARM Thumb2
* ARM Thumb

## Testing wolfSM

To test that the SM ciphers are working use the following command:

```sh
make test
```

To benchmark the algorithms enabled:

```sh
./wolfcrypt/benchmark/benchmark
```

To benchmark specific algorithms, add to the command line the option/s matching the algorithm/s:
* SM2: `-sm2`
* SM3: `-sm3`
* SM4: `-sm4` or
  * SM4-CBC: `-sm4-cbc`
  * SM4-GCM: `-sm4-gcm`
  * SM4-CCM: `-sm4-ccm`

### Testing TLS

SM ciphers are able to be used with TLSv1.2 and TLSv1.3.

Note: SM2, SM3 and at least one SM4 cipher must be built in order for SM ciphers suite to work. All algorithms must be SM.

The cipher suites added are:
  - ECDHE-ECDSA-SM4-CBC-SM3 (TLSv1.2, `--enable-sm2 --enable-sm3 --enable-sm4-cbc`)
  - ECDHE-ECDSA-SM4-GCM-SM3 (TLSv1.2, `--enable-sm2 --enable-sm3 --enable-sm4-gcm`)
  - ECDHE-ECDSA-SM4-CCM-SM3 (TLSv1.2, `--enable-sm2 --enable-sm3 --enable-sm4-ccm`)
  - TLS13-SM4-GCM-SM3 (TLSv1.3, `--enable-sm2 --enable-sm3 --enable-sm4-gcm`)
  - TLS13-SM4-CCM-SM3 (TLSv1.3, `--enable-sm2 --enable-sm3 --enable-sm4-ccm`)

#### Example of using SM cipher suites with TLSv1.2

An example of testing TLSv1.2 with "ECDHE-ECDSA-SM4-CBC-SM3" cipher suite:

```sh
./examples/server/server -v 3 -l ECDHE-ECDSA-SM4-CBC-SM3 \
    -c ./certs/sm2/server-sm2.pem -k ./certs/sm2/server-sm2-priv.pem \
    -A ./certs/sm2/client-sm2.pem -V &
./examples/client/client -v 3 -l ECDHE-ECDSA-SM4-CBC-SM3 \
    -c ./certs/sm2/client-sm2.pem -k ./certs/sm2/client-sm2-priv.pem \
    -A ./certs/sm2/root-sm2.pem -C
```

The output using the commands above will be:

```
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3
SSL curve name is SM2P256V1
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3
SSL curve name is SM2P256V1
Client message: hello wolfssl!
I hear you fa shizzle!
```

#### Example of using SM cipher suites with TLSv1.3

An example of testing TLSv1.3 with "TLS13-SM4-GCM-SM3" cipher suite:

```sh
./examples/server/server -v 4 -l TLS13-SM4-GCM-SM3 \
    -c ./certs/sm2/server-sm2.pem -k ./certs/sm2/server-sm2-priv.pem \
    -A ./certs/sm2/client-sm2.pem -V &
./examples/client/client -v 4 -l TLS13-SM4-GCM-SM3 \
    -c ./certs/sm2/client-sm2.pem -k ./certs/sm2/client-sm2-priv.pem \
    -A ./certs/sm2/root-sm2.pem -C
```

The output using the commands above will be:

```
SSL version is TLSv1.3
SSL cipher suite is TLS_SM4_GCM_SM3
SSL curve name is SM2P256V1
SSL version is TLSv1.3
SSL cipher suite is TLS_SM4_GCM_SM3
SSL curve name is SM2P256V1
Client message: hello wolfssl!
I hear you fa shizzle!
```
