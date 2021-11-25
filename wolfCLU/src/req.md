### REQ Command
Used for creating a certificate request or a self-signed certificate. Can handle some basic parsing of a .conf file for certificate setup. If no configuration file is used then stdin is prompted for certificate information.

Available arguments are:    

- [-in] input file to read from
- [-out] file to write to (default stdout)
- [-key] public key to put into certificate request
- [-inform] der or pem format for '-in'
- [-outform] der or pem format for '-out'
- [-config] file to parse for certificate configuration
- [-days] number of days should be valid for
- [-x509] generate self signed certificate

Example:

```
wolfssl ecparam -genkey -out ecc.key -name secp384r1
wolfssl req -new -x509 -days 3650 -config selfsigned.conf -key ecc.key -out ecc.cert \
-outform der -sha256
```