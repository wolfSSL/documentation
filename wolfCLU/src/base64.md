### BASE64 Command

Encodes or decodes data using base64 encoding. By default, data is encoded to base64. Use the -d option to decode base64 data.

- [-in] input file to read from (default stdin)
- [-out] output file to write to (default stdout)
- [-d] decode the input data instead of encoding

Example for encoding:

```
wolfssl base64 -in plain_file.txt -out encoded_file.txt
```

Example for decoding:

```
wolfssl base64 -d -in encoded_file.txt -out decoded_file.txt
```
