### S_SERVER Command

A simple SSL/TLS server for testing. Listens on a specified port and handles incoming SSL/TLS connections.

Arguments:

- [-port] Port number to listen on
- [-key] Private key file (PEM format)
- [-cert] Certificate file (PEM format)
- [-noVerify] Disable client certificate verification
- [-CAfile] CA certificate file for client verification (PEM format)
- [-version] SSL/TLS version: 0=SSLv3, 1=TLS1.0, 2=TLS1.1, 3=TLS1.2, 4=TLS1.3
- [-naccept] Number of connections to accept (default: 1)
- [-www] Send HTTP response in HTML format
- [-readyFile] Create a ready file for external monitoring

Usage Examples:

Start a simple TLS server on port 4433:

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem
```

Start server with client certificate verification:

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem -CAfile ca-cert.pem
```

Start server accepting multiple connections with HTTP response:

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem -naccept 10 -www
```
