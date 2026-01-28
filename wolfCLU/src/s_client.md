### S_CLIENT Command
Basic TLS client for testing connections.

Arguments:

- [-connect] `<ip>:<port>` or `<[ipv6]>:<port>`
- [-starttls] protocol for STARTTLS (e.g., smtp)
- [-CAfile] CA file name for verification
- [-verify_return_error] close connection on verification error
- [-disable_stdin_check] disable stdin check

IPv6 Examples:

- `-connect '[::1]:11111'`
- `-connect '[fe80::63:57c0:9b88:77ca%en0]:11111'`
- `-connect '[2001:4860:4860::8888]:443'`

Example:

```
wolfssl s_client -connect 127.0.0.1:11111

wolfssl s_client -connect example.com:443 -CAfile ./certs/ca-cert.pem

wolfssl s_client -connect '[::1]:11111'
```
