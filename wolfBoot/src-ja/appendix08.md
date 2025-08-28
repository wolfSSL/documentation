# ポスト量子署名

wolfBootはポスト量子署名のサポートを追加しています。
現在、[LMS/HSS](https://tex2e.github.io/rfc-translater/html/rfc8554.html)および[XMSS/XMSS^MT](https://tex2e.github.io/rfc-translater/html/rfc8391.html)のサポートが追加しています。

LMS/HSSとXMSS/XMSS^MTはどちらもポスト量子ステートフルハッシュベース署名（HBS）方式です。
これらは小さな公開鍵、比較的高速な署名と検証を行いますが、署名サイズが大きいことで知られています。
ただし、署名サイズはそれぞれのパラメータによって調整可能であり、サイズと処理時間のトレードオフがあります。

ステートフルHBS方式は、基礎となるハッシュ関数とマークルツリーのセキュリティに基づいており、暗号学的に関連する量子コンピュータの出現によって破られることは予想されていません。
このため、NIST SP 800-208とNSAのCNSA 2.0スイートの両方で推奨されています。

ステートフルHBSサポートとwolfSSL/wolfCryptの詳細については、以下のリンクをご参照ください。

- <https://www.wolfssl.com/documentation/manuals/jp/wolfssl/appendix07.html>
- <https://github.com/wolfSSL/wolfssl-examples/tree/master/pq/stateful_hash_sig>

## サポートされているPQ署名方法

以下の4つのPQ署名オプションをサポートしています。

- LMS: `wc_lms.c`と`wc_lms_impl.c`によるwolfcrypt実装を使用します。
- XMSS: `wc_xmss.c`と`wc_xmss_impl.c`によるwolfcrypt実装を使用します。
- ext_LMS: `ext_lms.c`からの外部統合を使用します。
- ext_XMSS: `ext_xmss.c`からの外部統合を使用します。

wolfcrypt実装はより高性能であり、推奨しています。
外部統合は実験的であり、相互運用性のテスト用です。

### LMS/HSS設定

新しいLMSシミュレーションサンプルを以下に掲載しています。

```
config/examples/sim-lms.config
```

`LMS_LEVELS`、`LMS_HEIGHT`、`LMS_WINTERNITZ`、`IMAGE_SIGNATURE_SIZE`、（オプションで）`IMAGE_HEADER_SIZE`を設定する必要があります。

```
SIGN?=LMS
...
LMS_LEVELS=2
LMS_HEIGHT=5
LMS_WINTERNITZ=8
...
IMAGE_SIGNATURE_SIZE=2644
IMAGE_HEADER_SIZE?=5288
```

LMSでは、署名サイズはパラメータの関数です。
LMSパラメータに基づいて署名の長さを計算するために、追加されたヘルパースクリプト`tools/lms/lms_siglen.sh`を使用してください。

```
$ ./tools/lms/lms_siglen.sh  2 5 8
levels:     2
height:     5
winternitz: 8
signature length: 2644
```

### XMSS/XMSS^MT設定

新しいXMSSシミュレーションサンプルを以下に掲載しています。

```
config/examples/sim-xmss.config
```

`XMSS_PARAMS`、`IMAGE_SIGNATURE_SIZE`、（オプションで）`IMAGE_HEADER_SIZE`を設定する必要があります。

```
SIGN?=XMSS
...
XMSS_PARAMS='XMSS-SHA2_10_256'
...
IMAGE_SIGNATURE_SIZE=2500
IMAGE_HEADER_SIZE?=5000
```

`XMSS_PARAMS`はNIST SP 800-208の表10および11からのSHA256パラメータセット文字列であれば何でも構いません。
XMSS/XMSS^MTパラメータ文字列に基づいて署名の長さを計算するには、ヘルパースクリプト`tools/xmss/xmss_siglen.sh`を使用してください。

使用例：

```
$ ./tools/xmss/xmss_siglen.sh XMSS-SHA2_10_256
parameter set:    XMSS-SHA2_10_256
signature length: 2500
```

```
$ ./tools/xmss/xmss_siglen.sh XMSSMT-SHA2_20/2_256
parameter set:    XMSSMT-SHA2_20/2_256
signature length: 4963
```


## 外部PQ統合のビルド

### ext_LMSサポート

wolfCryptの外部LMS/HSSサポートには、[hash-sigsライブラリ](https://github.com/cisco/hash-sigs)が必要です。
hash-sigsをwolfBootでビルドするために準備するには、次の手順を使用します。

```sh
$ cd lib
$ mkdir hash-sigs
$ ls
 CMakeLists.txt  hash-sigs  wolfssl  wolfTPM
$ cd hash-sigs
$ mkdir lib
$ git clone https://github.com/cisco/hash-sigs.git src
$ cd src
$ git checkout b0631b8891295bf2929e68761205337b7c031726
$ git apply ../../../tools/lms/0001-Patch-to-support-wolfBoot-LMS-build.patch
```

これ以上は必要ありません。
wolfBootが必要なhash-sigsビルド成果物を自動的に生成します。

注意：hash-sigsプロジェクトは静的ライブラリのみをビルドします。

- `hss_verify.a`: シングルスレッドの検証専用静的ライブラリ
- `hss_lib.a`: シングルスレッドの静的ライブラリ
- `hss_lib_thread.a`: マルチスレッドの静的ライブラリ

keytoolsユーティリティは`hss_lib.a`にリンクされており、鍵生成、署名、検証機能がすべて必要です。
ただし、wolfBootは検証機能のみが必要なため、`hss_verify.a`ビルドルールのオブジェクトのサブセットに直接リンクされます。

### ext_XMSSサポート

wolfCryptの外部XMSS/XMSS^MTサポートには、[xmss-referenceライブラリ](https://github.com/XMSS/xmss-reference.git)のパッチ適用版が必要です。
xmss-referenceをwolfBootでビルドするために、以下の手順でご用意ください。

```sh
$ cd lib
$ git clone https://github.com/XMSS/xmss-reference.git xmss
$ ls
CMakeLists.txt  wolfPKCS11  wolfTPM  wolfssl  xmss
$ cd xmss
$ git checkout 171ccbd26f098542a67eb5d2b128281c80bd71a6
$ git apply ../../tools/xmss/0001-Patch-to-support-wolfSSL-xmss-reference-integration.patch
```

パッチは追加のreadme `patch_readme.md` を作成するもので、追加コメントを記載しています。

パッチ適用ステップ以外は何も必要ありません。
wolfBootが必要なxmssビルド成果物を処理します。
