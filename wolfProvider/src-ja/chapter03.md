# wolfProviderのビルド

## wolfProviderのダウンロード

wolfProviderの最新バージョンは、wolfSSL Inc. から直接入手できます。
詳細については、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお問い合わせください。


## パッケージ構成

wolfProviderパッケージは、以下のように構成しています。

```
certs/               (ユニットテストで使用されるテスト用証明書、鍵)
provider.conf        (wolfProviderを使用する場合のOpenSSLコンフィギュレーションファイルサンプル)
include/
    wolfprovider/      (wolfProviderヘッダーファイル)
openssl_patches/
    1.0.2h/tests/    (OpenSSL 1.0.2h テストアプリ用パッチ)
    1.1.1b/tests/    (OpenSSL 1.1.1b テストアプリ用パッチ)
scripts/             (wolfProvider テストスクリプト)
src/                 (wolfProvider ソースファイル)
test/                (wolfProvider テストファイル)
user_settings.h      (user_settings.hサンプル)
```

## OpenSSLのバージョンに関する注意事項

次に示すアルゴリズムを利用するには、併記したOpenSSLバージョンが必要です。

- SHA-3：OpenSSL バージョン1.1.1以降が必要
- EC_KEY_METHOD：OpenSSL バージョン1.1.1以降が必要

## *nix上でのビルド

最も簡単な方法は、以下のように `scripts/build-wolfprovider.sh` スクリプトを使用することです。

```
./scripts/build-wolfprovider.sh
```

このスクリプトは必要に応じて依存関係を取得し、コンパイルします。
異なるリリースを使用したい場合など、デフォルトでないパラメータを使用するには、次のように環境変数として設定してください。

```
OPENSSL_TAG=openssl-3.2.0 WOLFSSL_TAG=v5.7.2-stable WOLFPROV_DEBUG=1 scripts/build-wolfprovider.sh
```

あるいは、以下のガイドを使用して各コンポーネントを手動でコンパイルすることもできます。

### OpenSSLをビルド

すでにインストールされたOpenSSLを使用することも、新しく1からOpenSSLをコンパイルして使用することもできます。
以下に、*nix(Linux, Unix)上でOpenSSLをコンパイルする一般的な手法を示します。
より詳しいビルド手順をお求めでしたら、OpenSSLの[INSTALLファイル](https://github.com/openssl/openssl/blob/master/INSTALL.md)や[ドキュメント](https://docs.openssl.org/master/)をご参照ください。

```
git clone https://github.com/openssl/openssl.git
cd openssl
./config no-fips -shared
make
sudo make install
```

### wolfSSLをビルド

wolfProviderでwolfSSL FIPS版を使用するには、特定のFIPS検証済みソースバンドルやセキュリティポリシーで指定されたビルド手順に従う必要があります。
まずコンフィギュレーションオプションとして`--enable-fips`が必要で、かつ **WOLFSSL_PUBLIC_MP** が定義された状態でwolfSSLをコンパイルします。
以下に、Linuxで「wolfCrypt Linux FIPSv5バンドル」をビルドする例を示します。

```
cd wolfssl-X.X.X-commercial-fips-linuxv5
./configure **--enable-fips=v5 CFLAGS=”-DWOLFSSL_PUBLIC_MP”**
make
./wolfcrypt/test/testwolfcrypt
#--< ここで、fips_test.c内のverifyCoreを開き、testwolfcryptスクリプトが出力するハッシュ値に更新してください >--

make
./wolfcrypt/test/testwolfcrypt

#--< すべてのテストでPASSできるはずです >--

sudo make install
```

非FIPS版のwolfSSLを使用する場合は、以下のようになります。

```
cd wolfssl-X.X.X

./configure --enable-opensslcoexist --enable-cmac --enable-keygen --enable-sha --enable-des3 --enable-aesctr --enable-aesccm --enable-x963kdf --enable-compkey CPPFLAGS="-DHAVE_AES_ECB -DWOLFSSL_AES_DIRECT -DWC_RSA_NO_PADDING -DWOLFSSL_PUBLIC_MP -DHAVE_PUBLIC_FFDHE -DWOLFSSL_DH_EXTRA -DWOLFSSL_PSS_LONG_SALT -DWOLFSSL_PSS_SALT_LEN_DISCOVER -DRSA_MIN_SIZE=1024" --enable-certgen --enable-aeskeywrap --enable-enckeys --enable-base16 --with-eccminsz=192
make
sudo make install
```

より良いAES-GCMサポートのために、利用可能であれば `--enable-aesgcm-stream` を追加してください。

X25519鍵交換のサポートを含めるために `--enable-curve25519` を追加してください。

X448鍵交換のサポートを含めるために `--enable-curve448` を追加してください。

Ed25519署名と証明書のサポートを含めるために `--enable-ed25519` を追加してください。

Ed448署名と証明書のサポートを含めるために `--enable-ed448` を追加してください。

OpenSSLでPKCS#12を使用する場合は、 `--enable-pwdbased` を追加してください。

事前定義された6144ビットおよび8192ビットDHパラメータを有効にするために、CPPFLAGSに `-DHAVE_FFDHE_6144 -DHAVE_FFDHE_8192 -DFP_MAX_BITS=16384` を追加してください。

同じ鍵でHMACを繰り返し実行してパフォーマンスを向上させる場合は `--enable-hmac-copy` を追加してください。
（wolfSSL 5.7.8以降で利用可能です。）

SP整数演算を使用するために `--enable-sp=yes,asm' '--enable-sp-math-all'` を追加してください。
使用する際は `-DFP_MAX_BITS=16384` を `-DSP_INT_BITS=8192` に置き換えてください。

FIPS v2バンドルからビルドしており、gitリポジトリからではない場合は、`-DWOLFSSL_PSS_LONG_SALT -DWOLFSSL_PSS_SALT_LEN_DISCOVER` を削除し、上記のconfigureコマンドに `--enable-fips=v2` を追加してください。
FIPS Readyバンドルを使用している場合は、`--enable-fips=v2` を `--enable-fips=ready` に変更してください。

`--with-eccminsz=192` がwolfSSLでサポートされていない場合は、CPPFLAGSに `-DECC_MIN_KEY_SZ=192` を追加してください。

wolfSSLをGitHubリポジトリから取得された場合は、`./configure`を実行する前に`autogen.sh`スクリプトを実行する必要があります。
これにより、configureスクリプトが生成されます。

```
./autogen.sh
```

### wolfProviderをビルド

Linuxなどの*nixライクな環境でwolfProviderをビルドする場合は、autoconfをご利用ください。
wolfProviderをビルドするには、wolfProviderのルートディレクトリ上で次のコマンドを実行します。

```
./configure
make
```

wolfProviderをGitHubリポジトリから取得された場合は、`./configure`を実行する前に`autogen.sh`スクリプトを実行する必要があります。

```
./autogen.sh
```

任意の数のビルドオプションを `./configure` に追加できます。 
利用可能なビルドオプションの一覧については、後の「ビルドオプション」セクションに掲載しているほか、
次のコマンドを実行することで表示できます。

```
./configure  --help
```

wolfProviderは通常、システムにインストールされたデフォルトのOpenSSLライブラリを使用します。
`--with-openssl`オプションにより、特定のディレクトリに存在するOpenSSLを使用することもできます。

```
./configure --with-openssl=/usr/local/ssl
```

デフォルト以外のOpenSSLを使用する場合、ライブラリ検索パスに追加しなければならないケースがあります。
Linuxシステムでは、次のように`LD_LIBRARY_PATH`を編集します。

```
export LD_LIBRARY_PATH=/usr/local/ssl:$LD_LIBRARY_PATH
```

wolfProviderをビルドしインストールするには、以下のコマンドを実行します。

```
make
make install
```

インストール時にはroot権限を求められる場合があります。
その際は、コマンドの前に`sudo`を付加します。

```
sudo make install
```

ビルド結果をテストするには、wolfProviderのルートディレクトリで以下のコマンドを実行します。

```
./test/unit.test
```

次のように、autoconfを使用して実行することもできます。

```
make check
```

ライブラリが見つからない場合、
`error while loading shared libraries: libssl.so.3` 
のようなエラーが発生します。
環境変数`LD_LIBRARY_PATH`を編集することで解決しないかお試しください。

## WinCE上でのビルド

wolfProviderとの互換性を保つために、wolfCryptの`user_settings.h`ファイルに以下の定義があることをご確認ください。

```
#define WOLFSSL_CMAC
#define WOLFSSL_KEY_GEN
#undef NO_SHA
#undef NO_DES
#define WOLFSSL_AES_COUNTER
#define HAVE_AESCCM
#define HAVE_AES_ECB
#define WOLFSSL_AES_DIRECT
#define WC_RSA_NO_PADDING
#define WOLFSSL_PUBLIC_MP
#define ECC_MIN_KEY_SZ=192
```

使用するアルゴリズムと機能に応じて、`user_settings.h`ファイルにwolfProviderフラグを追加します。
wolfProviderディレクトリにある`user_settings.h`ファイルで、wolfProviderユーザー設定フラグを参照できます。

Windows CE用のwcecompat、wolfCrypt、およびOpenSSLをビルドし、それらのパスを参照できるようにします。

wolfProviderディレクトリでソースファイルを開き、OpenSSL、wolfCrypt、および `user_settings.h` パスを使用しているディレクトリに変更します。 
INCLUDESセクションとTARGETLIBSセクションのパスを更新する必要があります。

Visual StudioでwolfProviderプロジェクトをロードします。
ベンチマークまたは単体テストを実行する場合は、「bench.c」、または「unit.h」と「unit.c」のいずれかを含めます。

プロジェクトをビルドすると、実行可能ファイルwolfProvider.exeが作成されます。
この実行可能ファイルに`--help`の引数をつけて実行すると、オプションの一覧を表示できます。 
wolfProviderを静的エンジンとして使用するには`--static`を付けて実行する必要があります。

## ビルドオプション (./configure に指定するオプション)

ライブラリの構築方法をカスタマイズするために`./configure`スクリプトに追加できるオプションを以下に示します。

デフォルトでは、ビルド時間を半分にするために共有ライブラリのみをビルドします。
必要に応じて、静的ライブラリをビルドしたり共有ライブラリのビルドを無効化したりできます。

| オプション   | デフォルト | 意味 |
| :--------- | :---------------: | :-------------- |
| --enable-static   | **無効** | 静的ライブラリとしてビルド   |
| --enable-shared   | 有効     | 共有ライブラリとしてビルド |
| --enable-debug    | **無効** | wolfProviderのデバッグ出力を有効にする |
| --enable-coverage | **無効** | コードカバレッジレポートを作成する用ビルド |
| --enable-usersettings | **無効** | user_settings.h を使用しMakefileの CFLAGSを使用しない |
| --enable-dynamic-provider | 有効 | wolfProvider をダイナミックエンジンとしてロードする |
| --enable-singlethreaded | **無効** |  wolfProviderをシングルスレッド環境で使用する |
| --enable-digest | 有効 |  ダイジェストの生成にwc_Hash APIを使用する |
| --enable-sha | 有効 |  SHA-1 を有効にする|
| --enable-sha224 | 有効 |  SHA2-224 を有効にする|
| --enable-sha256 | 有効 |  SHA2-256 を有効にする|
| --enable-sha384 | 有効 |  SHA2-384 を有効にする|
| --enable-sha512 | 有効 |  SHA2-512 を有効にする|
| --enable-sha3 | 有効 |  SHA3 を有効にする|
| --enable-sha3-224 | 有効 |  SHA3-224 を有効にする|
| --enable-sha3-256 | 有効 |  SHA3-256 を有効にする|
| --enable-sha3-384 | 有効 |  SHA3-384 を有効にする|
| --enable-sha3-512 | 有効 |  SHA3-512 を有効にする|
| --enable-cmac | 有効 |  CMAC を有効にする|
| --enable-hmac | 有効 |  HMAC を有効にする|
| --enable-des3cbc| 有効 |  3DES-CBC を有効にする|
| --enable-aesecb | 有効 |  AES-ECB を有効にする|
| --enable-aescbc | 有効 |  AES-CBC を有効にする|
| --enable-aesctr | 有効 |  AES-CTR を有効にする|
| --enable-aesgcm | **無効** |  AES-GCM を有効にする|
| --enable-aesccm | **無効** |  AES-CCM を有効にする|
| --enable-rand | 有効 |  RAND を有効にする|
| --enable-rsa | 有効 |  RSA を有効にする|
| --enable-dh | 有効 |  DH を有効にする|
| --enable-evp-pkey | 有効 |  EVP_PKEY APIs を有効にする|
| --enable-ec-key | 有効 |  ECC using EC_KEY を有効にする|
| --enable-ecdsa | 有効 |  ECDSA を有効にする|
| --enable-ecdh | 有効 |  ECDH を有効にする|
| --enable-eckg | 有効 |  EC Key Generation を有効にする|
| --enable-p192 | 有効 |  EC Curve P-192 を有効にする|
| --enable-p224 | 有効 |  EC Curve P-224 を有効にする|
| --enable-p256 | 有効 |  EC Curve P-256 を有効にする|
| --enable-p384 | 有効 |  EC Curve P-384 を有効にする|
| --enable-p521 | 有効 |  EC Curve P-521 を有効にする|
| --with-openssl=DIR |   | OpenSSLのインストール場所を指定。指定しない場合はシステムのデフォルトライブラリパスとインクルードパスが使われます。|

## ビルド用マクロ定義

wolfProviderは、お客様がwolfProviderのビルド方法を設定できるようにするいくつかのプリプロセッサマクロを公開しています。
以下にその一覧を示します。

| マクロ定義  | 意味 |
| :---------- | :--------------------- |
| WOLFPROVIDER_DEBUG | デバッグシンボル、最適化レベル、デバッグロギングを使用してwolfProviderをビルドします |
| WP_NO_DYNAMIC_PROVIDER |  wolfProviderをダイナミックエンジンとしてビルドしない。ダイナミックエンジンとは、OpenSSLが実行時に動的にロードするエンジンのことです。 |
| WP_SINGLE_THREADED | wolfProviderをシングルスレッドモードでビルドする。このマクロ定義によりグローバルリソースの使用の排他用に内部的に使用するロック機構を取り除きます。|
| WP_USE_HASH | ハッシュアルゴリズムを wc_Hash APIを使って有効にする |
| WP_HAVE_SHA1   |  SHA-1 を有効にする |
| WP_HAVE_SHA224 |  SHA-2 224を有効にする |
| WP_HAVE_SHA256 |  SHA-2 256を有効にする |
| WP_HAVE_SHA384 |  SHA-2 384を有効にする |
| WP_HAVE_SHA512 |  SHA-2 512を有効にする |
| WP_SHA1_DIRECT | SHA-1 をwc_Sha APIを使って有効にする。WP_USE_HASHとは同時に指定できません。 |
| WP_SHA224_DIRECT |  SHA-2 224 を wc_Sha224 APIを使って有効にする。WP_USE_HASHとは同時に指定できません。 |
| WP_SHA256_DIRECT |  SHA-2 256 を wc_Sha256 APIを使って有効にする。WP_USE_HASHとは同時に指定できません。 |
| WP_HAVE_SHA3_224 |  SHA-3  224を有効にする（OpenSSL 1.0.2では利用不可）|
| WP_HAVE_SHA3_256 |  SHA-3  256を有効にする（OpenSSL 1.0.2では利用不可）|
| WP_HAVE_SHA3_384 |  SHA-3  384を有効にする（OpenSSL 1.0.2では利用不可）|
| WP_HAVE_SHA3_512 |  SHA-3  512を有効にする（OpenSSL 1.0.2では利用不可）|
| WP_HAVE_EVP_PKEY | EVP_PKEY APIを使用する機能を有効にする（RSA, DH等も含む） |
| WP_HAVE_CMAC |  CMACを有効にする |
| WP_HAVE_HMAC |  HMACを有効にする |
| WP_HAVE_DES3CBC |  DES3-CBCを有効にする |
| WP_HAVE_AESECB |  AES-ECBを有効にする |
| WP_HAVE_AESCBC |  AES-CBCを有効にする |
| WP_HAVE_AESCTR |  AES-countee modeを有効にする |
| WP_HAVE_AESGCM |  AES-GCMを有効にする |
| WP_HAVE_AESCCM | AES-CCMを有効にする |
| WP_HAVE_RANDOM |  wolfCryptの疑似乱数生成実装を有効にする |
| WP_HAVE_RSA |  RSA操作(署名、検証、鍵生成等)を有効にする |
| WP_HAVE_DH |  Diffie-Hellman操作(鍵生成、共有シークレット計算等)を有効にする |
| WP_HAVE_ECC |  楕円曲線暗号を有効にする |
| WP_HAVE_EC_KEY | EC_KEY_METHODのサポートを有効にする（OpenSSL 1.0.2では利用不可） |
| WP_HAVE_ECDSA |  ECDSA を有効にする |
| WP_HAVE_ECDH |  EC Diffie-Hellman操作を有効にする |
| WP_HAVE_ECKEYGEN |  EC鍵生成を有効にする |
| WP_HAVE_EC_P192 |  EC Curve P192を有効にする |
| WP_HAVE_EC_P224 |  EC Curve P224を有効にする |
| WP_HAVE_EC_P256 |  EC Curve P256を有効にする |
| WP_HAVE_EC_P384 |  EC Curve P384を有効にする |
| WP_HAVE_EC_P512 |  EC Curve P512を有効にする |
| WP_HAVE_DIGEST | ダイジェストアルゴリズムをベンチマークとユニットテストのコードに含めてコンパイルする |
| WOLFPROVIDER_USER_SETTINGS | ユーザーの指定した定義をuser_settings.hファイルから読み込む |

