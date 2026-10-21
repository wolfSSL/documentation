# Getting Started

Follow the steps in How to Use This Guide in chapter 1, then test against your
existing Mbed TLS peers. Once the port works, turn on what you gain: DTLS 1.3
and crypto callbacks for your hardware. The ML-KEM hybrid groups are on by
default; for `user_settings.h` builds, see
[Configuration Equivalents](chapter09.md).

## Interoperability Testing

wolfSSL's CI runs interoperability tests against Mbed TLS 3.6 for TLS, DTLS
and DTLS Connection ID. The samples in this guide were also tested against
Mbed TLS 4.1.

For quick tests on a host, the wolfSSL example client and server pair with the
Mbed TLS `ssl_client2` and `ssl_server2` programs:

```sh
# wolfSSL client against an Mbed TLS server; -g sends an HTTP GET
./examples/client/client -h <host> -p <port> -A <test-ca.crt> -g

# wolfSSL server for an Mbed TLS client; -d skips the client certificate request
./examples/server/server -p <port> -d

# Mbed TLS client against that server, trusting the wolfSSL test CA
ssl_client2 server_port=<port> ca_file=<wolfssl>/certs/ca-cert.pem server_name=example.com
```

`test-ca.crt` from the Mbed TLS test data signs the RSA certificate that
`ssl_server2` uses by default for TLS 1.2. For TLS 1.3 it presents an ECDSA
certificate whose CA, `test-ca2.crt`, carries a NULL signature parameter that
wolfSSL rejects, so start it with `crt_file=server2-sha256.crt
key_file=server2.key` instead. Run the wolfSSL examples with `-?` for the full
list of options.

## Source and Releases

The wolfSSL source is at
[github.com/wolfSSL/wolfssl](https://github.com/wolfSSL/wolfssl), and release
archives are available from
[wolfssl.com/download](https://www.wolfssl.com/download/).
