# OpenSSL Version Compatibility

wolfProvider supports all release versions of OpenSSL 3.x. It is continuously tested against a range of OpenSSL 3.x releases, from OpenSSL 3.0.6 through the latest 3.x release. Both FIPS and non-FIPS wolfProvider builds are tested.

Some features have a minimum OpenSSL requirement:

- Post-Quantum algorithms (ML-KEM, ML-DSA) and LMS require OpenSSL 3.6 or later.

OpenSSL 3.0.3 through 3.0.5 are not recommended due to an upstream ECX `EVP_PKEY_cmp` bug; use OpenSSL 3.0.6 or later on the 3.0.x series.

If you are interested in having wolfSSL add support to wolfProvider for other OpenSSL versions, please contact wolfSSL at [facts@wolfssl.com](mailto:facts@wolfssl.com).
