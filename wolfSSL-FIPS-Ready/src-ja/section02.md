# wolfSSL FIPS Ready版のビルド手順

通常版と大きな差はありませんが、いくつかの追加手順が必要です。

ここでは、LinuxまたはmacOS環境でwolfSSL FIPS Ready GPL v3版を利用し、システムに共有ライブラリとしてインストールする手順を示します。

## ソースコードの解凍

```
$ tar xzvf wolfssl-5.6.4-gplv3-fips-ready.tar.gz
$ cd wolfssl-5.6.0-gplv3-fips-ready 
```

ソースコードを解凍し、生成されたディレクトリに移動します。商用リリースを受け取った場合は、gplv3をcommercialに、.tar.gz を .7z に、tar xzvf を 7z x -p<password> に置き換えてください。

## ビルドを構成 

```
$ ./configure --enable-fips=ready
```

このコマンドは、FIPS Ready版のwolfSSLを構築するようにMakefileを構成します。

## ライブラリのビルド

```
$ make
```

これにより、すべてのソースがコンパイルされライブラリがリンクされます。 また、サンプルツールとテストツールも構築します。

## コアメモリのハッシュを更新

```
$ ./fips-hash.sh

$ make # Re-build once the hash has been updated
```

このステップでコア内メモリ テストのハッシュを計算し、更新する必要があります。 wolfCrypt テストは、fips-hash.sh スクリプトによって呼び出されたときに失敗するはずです。次のメッセージが出力されます。(ハッシュ値は一意であることにご注意ください)

```
in my Fips callback, ok = 0, err = -203

message = In Core Integrity check FIPS error

hash = 8D29242F610EAEA179605BB1A99974EBC72B0ECDB26B483B226A729F36FC82A2

In core integrity hash check failure, copy above hash

into verifyCore[] in fips_test.c and rebuild
```

ビルド時に他のオプションを追加するとハッシュ値が変化する可能性があるため、この手順を繰り返す必要があります。 またアプリケーションに変更を加えると、アプリケーションを再コンパイルしたときにメモリ内の FIPS 境界が移動する可能性があります。 アプリケーションのみが更新された場合のハッシュの変化は、モジュールが影響を受けていることを示すものではなく、メモリ内の所定の位置にシフトされたことを示します。 これは、静的ライブラリとして使用する場合に発生します。 共有ライブラリではこの問題は発生しません。

4.1 提供している fips-hash.sh スクリプトを使用せずに上記を実行する場合は、ファイル wolfcrypt/src/fips_test.c を編集してハッシュを手動で更新するか、次のような設定を使用することができます。

```
$ ./configure --enable-fips=ready CFLAGS=”-DWOLFCRYPT_FIPS_CORE_HASH_VALUE=8D29242F610EAEA179605BB1A99974EBC72B0ECDB26B483B226A729F36FC82A2”
```

4.2 再びmakeを実行します。 

## ビルドの検証

```
$ make check
```

Makefile 内のチェック ターゲットは、wolfSSLおよびwolfCryptで提供されるすべてのテストツールとスクリプトです。すべてが正常であれば、次の出力が表示されるはずです。

```

PASS: scripts/resume.test

PASS: scripts/external.test

PASS: scripts/google.test

PASS: testsuite/testsuite.test

PASS: scripts/openssl.test

PASS: tests/unit.test

=======================================================================

Testsuite summary for wolfssl 4.0.0

=======================================================================

# TOTAL: 6

# PASS:  6

# SKIP:  0

# XFAIL: 0

# FAIL:  0

# XPASS: 0

# ERROR: 0

=======================================================================

```

## ライブラリのインストール

```
$ make install
```

Makefile 内のinstallターゲットにより、すべてのヘッダーとライブラリがシステムにインストールされます。デフォルトでは /usr/local 配下にインストールします。

これで、アプリケーションのビルド時にwolfSSL FIPS Ready版をご利用いただけます。
