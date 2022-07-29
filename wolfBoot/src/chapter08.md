# Troubleshooting

## Python errors when signing a key

```
Traceback (most recent call last):
  File "tools/keytools/keygen.py", line 135, in <module>
    rsa = ciphers.RsaPrivate.make_key(2048)
AttributeError: type object 'RsaPrivate' has no attribute 'make_key'
```

```
Traceback (most recent call last):
  File "tools/keytools/sign.py", line 189, in <module>
    r, s = ecc.sign_raw(digest)
AttributeError: 'EccPrivate' object has no attribute 'sign_raw'
```

You need to install the latest wolfcrypt-py here: https://github.com/wolfSSL/wolfcrypt-py

Use `pip3 install wolfcrypt`.

Or to install based on a local wolfSSL installation use:

```
cd wolfssl
./configure --enable-keygen --enable-rsa --enable-ecc --enable-ed25519 --enable-des3 CFLAGS="-DFP_MAX_BITS=8192 -DWOLFSSL_PUBLIC_MP"
make
sudo make install
cd wolfcrypt-py
USE_LOCAL_WOLFSSL=/usr/local pip3 install .
```


## Python errors in command line parser running `keygen.py`

```
Traceback (most recent call last):
  File "tools/keytools/keygen.py", line 173, in <module>
    parser.add_argument('-i', dest='pubfile', nargs='+', action='extend')
  File "/usr/lib/python3.7/argparse.py", line 1361, in add_argument
    raise ValueError('unknown action "%s"' % (action_class,))
ValueError: unknown action "extend"
```

The version of the python interpreter installed on the system is too old. To run
`keygen.py` you need to upgrade python to v.3.8 or greater.

## Contact support

If you run into problems and need help, contact us at  _support@wolfssl.com_ 
