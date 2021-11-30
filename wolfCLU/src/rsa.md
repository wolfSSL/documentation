### RSA Command

Does RSA operations. Including reading in RSA keys, outputing RSA keys or modulus, and reading encrypted PEM files. Can handle both DER and PEM format for input and output. The following is a list of options

- [-in] file input for key to read
- [-inform] PEM or DER input format
- [-out] file to write result to (defaults to stdout)
- [-outform] PEM or DER output format
- [-passin] password for PEM encrypted files
- [-noout] do not print the key out when set
- [-modulus] print out the RSA modulus (n value)
- [-RSAPublicKey_in] expecting a public key input