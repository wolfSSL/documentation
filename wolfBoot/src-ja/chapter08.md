

# トラブルシューティング




## 鍵に署名するときのPythonエラー：




```
Traceback (most recent call last):
  File "tools/keytools/keygen.py", line 135, in <module>
    rsa=ciphers.RsaPrivate.make_key(2048)
AttributeError: type object 'RsaPrivate' has no attribute 'make_key'
```



```
Traceback (most recent call last):
  File "tools/keytools/sign.py", line 189, in <module>
    r, s=ecc.sign_raw(digest)
AttributeError: 'EccPrivate' object has no attribute 'sign_raw'
```



[最新のwolfCrypt-py](https://github.com/wolfssl/wolfcrypt-py)をインストールする必要があります


```
pip3 install wolfcrypt
```

を使用します。


または、ローカルのwolfSSLに基づいてインストールするには：



```
cd wolfssl
./configure --enable-keygen --enable-rsa --enable-ecc --enable-ed25519 --enable-des3 CFLAGS="-DFP_MAX_BITS=8192 -DWOLFSSL_PUBLIC_MP"
make
sudo make install
cd wolfcrypt-py
USE_LOCAL_WOLFSSL=/usr/local pip3 install .
```
## keyden.py実行時のPythonエラー：


```
Traceback (most recent call last):
  File "tools/keytools/keygen.py", line 173, in <module>
    parser.add_argument('-i', dest='pubfile', nargs='+', action='extend')
  File "/usr/lib/python3.7/argparse.py", line 1361, in add_argument
    raise ValueError('unknown action "%s"' % (action_class,))
ValueError: unknown action "extend"
```

インストールされているPythonインタープリターが古すぎます。keygen.pyを実行するにはpythonをv3.8以上に更新してください。

## サポートへの問い合わせ

問題が発生してサポートが必要な場合は、support@wolfssl.com　までお問い合わせください
