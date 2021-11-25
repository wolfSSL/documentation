### S_CLIENT Command
Very basic TLS connection supported. Currently does not verify the peer, -CAfile option is not yet completed.

Arguments:

- [-connect] <ip>:<port>


Example :

```
wolfssl s_client -connect 127.0.0.1:11111
```