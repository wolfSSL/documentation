# wolfProviderのビルド

## wolfProviderのダウンロード

wolfProviderの最新バージョンは、wolfSSL Inc. から直接入手できます。
詳細については、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお問い合わせください。


## パッケージ構成

wolfProviderパッケージは、以下のように構成しています。

```
certs/                      (ユニットテストで使用されるテスト用証明書、鍵)
examples/                   (実装例)
include/
    wolfprovider/           (wolfProviderヘッダーファイル)
IDE/                        (IDE向けプロファイル)
scripts/                    (wolfProvider テスト/ビルドスクリプト)
src/                        (wolfProvider ソースファイル)
test/                       (wolfProvider テストファイル)
provider.conf               (wolfProviderを使用する場合のOpenSSLコンフィギュレーションファイルサンプル)
provider-fips.conf          (wolfProvider FIPS版を使用する場合のOpenSSLコンフィギュレーションファイルサンプル)
user_settings.h             (user_settings.hサンプル)
```

## *nix上でのビルド

最も簡単な方法は、以下のように `scripts/build-wolfprovider.sh` スクリプトを使用することです。

```
./scripts/build-wolfprovider.sh
```

このスクリプトはOpenSSLとwolfSSLをデフォルトのオプションセットでクローン、構成、コンパイル、インストールします。

これらの構成オプションを変更するには、以下の2つの方法があります。

スクリプトを呼び出す前に、各種環境変数を設定する方法:

```
OPENSSL_TAG=openssl-3.2.0 WOLFSSL_TAG=v5.7.2-stable WOLFPROV_DEBUG=1 ./scripts/build-wolfprovider.sh
```

スクリプトの引数として指定する方法：

```
./scripts/build-wolfprovider.sh --openssl-ver=openssl-3.2.0 --wolfssl-ver=v5.7.2-stable --debug
```

これらの方法を組み合わせて、目的のビルドの組み合わせを実現することもできます。

環境変数とスクリプト引数の完全なリストについては、`./scripts/build-wolfprovider.sh --help` を実行してください。

必要に応じて、以下のガイドを使用して各コンポーネントを手動でコンパイルすることもできます。

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
以下に、Linuxで「wolfCrypt Linux FIPSv2バンドル」をビルドする例を示します。

```
cd wolfssl-X.X.X-commercial-fips-linuxv
./configure --enable-fips=v2 CFLAGS="-DWOLFSSL_PUBLIC_MP"
make
./wolfcrypt/test/testwolfcrypt
#--< ここで、fips_test.c内のverifyCoreを開き、testwolfcryptスクリプトが出力するハッシュ値に更新してください >--

make
./wolfcrypt/test/testwolfcrypt

#--< すべてのテストでPASSできるはずです >--

sudo make install
```

可能であれば、`make` を実行してから `./fips-hash.sh` ユーティリティを実行し、もう一度 `make` を実行する方が簡単かもしれません。
このユーティリティは、testwolfcrypt のハッシュ出力を使用して `fips_test.c` を更新するプロセスを自動化します。

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

| オプション | デフォルト値 | 説明 |
| :---------------- | :---------------: | :----------------------------- |
| --disable-option-checking | **無効** | | 認識されない --enable/--with オプションを無視する |
| --enable-silent-rules | **無効** | ビルド出力の詳細度を低くする (元に戻す: "make V=1") |
| --disable-silent-rules | **無効** | ビルド出力の詳細度を高くする (元に戻す: "make V=0") |
| --enable-static | **無効** | 静的ライブラリをビルドする |
| --enable-pic[=PKGS] | 両方使用 | PIC/非PIC オブジェクトのみを使用する |
| --enable-shared | 有効 | 共有ライブラリをビルドする |
| --enable-fast-install[=PKGS] | 有効 | 高速にインストールできるよう最適化する |
| --enable-aix-soname=aix\|svr4\|both | **aix** | AIXで提供する共有ライブラリのバージョン管理 (別名 "SONAME") バリアント |
| --enable-dependency-tracking | **無効** | 遅い依存関係抽出を拒否しない |
| --disable-dependency-tracking | **無効** | ワンタイムビルドを高速化する |
| --disable-libtool-lock | **無効** | ロックを回避する (並列ビルドが失敗する可能性があります) |
| --enable-debug | **無効** | wolfProviderのデバッグ出力を有効にする |
| --enable-coverage | **無効** | コードカバレッジ統計を生成するようにビルドする |
| --enable-usersettings | **無効** | user_settings.h を使用し、MakefileのCFLAGSを使用しない |
| --enable-dynamic | 有効 | wolfProviderをダイナミックプロバイダーとしてロードできるようにする |
| --enable-singlethreaded | **無効** | wolfProviderをシングルスレッド環境で使用する |
| | | | |
| --with-openssl=DIR | | リンクするOpenSSLのインストール場所。設定されていない場合は、システムのデフォルトのライブラリとインクルードパスが使用されます。 |
| --with-wolfssl=DIR | | リンクするwolfSSLのインストール場所。設定されていない場合は、システムのデフォルトのライブラリとインクルードパスが使用されます。 |

## ビルド用マクロ定義

wolfProviderは、お客様がwolfProviderのビルド方法を設定できるようにするいくつかのプリプロセッサマクロを公開しています。
以下にその一覧を示します。

| 定義 | 説明 |
| :---------------- | :----------------------------- |
| WOLFPROVIDER_USER_SETTINGS | user_settings.hを使用する |
| WOLFPROV_DEBUG | デバッグ情報を出力する |
| WP_CHECK_FORCE_FAIL | テスト目的で障害チェックを強制する |
| WP_ALLOW_NON_FIPS | FIPSモードで特定の非FIPSアルゴリズムを許可する |
| WP_HAVE_AESCCM | CCM (Counter with CBC-MAC) モードでのAES暗号化を有効化 |
| WP_HAVE_AESCFB | CFB (Cipher Feedback) モードでのAES暗号化を有効化 |
| WP_HAVE_AESCBC | CBC (Cipher Block Chaining) モードでのAES暗号化を有効化 |
| WP_HAVE_AESCTR | CTR (Counter) モードでのAES暗号化を有効化 |
| WP_HAVE_AESCTS | CTS (Ciphertext Stealing) モードのAES暗号化を有効化 |
| WP_HAVE_AESECB | ECB (Electronic Codebook) モードのAES暗号化を有効化 |
| WP_HAVE_AESGCM | GCM (Galois/Counter Mode) モードのAES暗号化を有効化 |
| WP_HAVE_CMAC | CMAC (Cipher-based Message Authentication Code)を有効化 |
| WP_HAVE_DES3CBC | CBCモードのTriple DES暗号化を有効化 |
| WP_HAVE_DH | Diffie-Hellman鍵交換を有効化 |
| WP_HAVE_DIGEST | 汎用ダイジェスト/ハッシュアルゴリズムを有効化 |
| WP_HAVE_ECC | 汎用楕円曲線暗号を有効化 |
| WP_HAVE_EC_P192 | P-192 楕円曲線を有効化 |
| WP_HAVE_EC_P224 | P-224 楕円曲線を有効化 |
| WP_HAVE_EC_P256 | P-256 楕円曲線を有効化 |
| WP_HAVE_EC_P384 | P-384 楕円曲線を有効化 |
| WP_HAVE_EC_P521 | P-521 楕円曲線を有効化 |
| WP_HAVE_ECDH | ECDH (楕円曲線 Diffie-Hellman) 鍵交換を有効化 |
| WP_HAVE_ECDSA | ECDSA (楕円曲線デジタル署名アルゴリズム) を有効化 |
| WP_HAVE_ECKEYGEN | 楕円曲線鍵生成を有効化 |
| WP_HAVE_ED25519 | Ed25519 楕円曲線署名を有効化 |
| WP_HAVE_ED448 | Ed448 楕円曲線署名を有効化 |
| WP_HAVE_GMAC | GMAC (ガロア/カウンターモード認証) を有効化 |
| WP_HAVE_HKDF | HKDF (HMACベースの鍵導出関数) を有効化 |
| WP_HAVE_HMAC | HMAC (ハッシュベースのメッセージ認証コード) を有効化 |
| WP_HAVE_KRB5KDF | Kerberos 5 鍵導出関数を有効化 |
| WP_HAVE_MD5 | MD5 ハッシュアルゴリズムを有効化 |
| WP_HAVE_MD5_SHA1 | MD5+SHA1 の組み合わせを有効化 |
| WP_HAVE_PBE | パスワードベースの暗号化を有効化 |
| WP_HAVE_RANDOM | 乱数生成を有効化 |
| WP_HAVE_RSA | RSA 暗号化と署名を有効化 |
| WP_HAVE_SHA1 | SHA1 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA224 | SHA224 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA256 | SHA256 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA384 | SHA384 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA3 | SHA3 ファミリ ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA3_224 | SHA3-224 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA3_256 | SHA3-256 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA3_384 | SHA3-384 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA3_512 | SHA3-512 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA512 | SHA512 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA512_224 | SHA512/224 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHA512_256 | SHA512/256 ハッシュアルゴリズムを有効化 |
| WP_HAVE_SHAKE_256 | SHAKE256 拡張出力関数を有効化 |
| WP_HAVE_TLS1_PRF | TLS1 擬似乱数関数を有効化 |
| WP_HAVE_X25519 | X25519 楕円曲線を有効化 |
| WP_HAVE_X448 | X448 楕円曲線を有効化 |
| WP_RSA_PSS_ENCODING | RSA-PSS (確率的署名スキーム) エンコードを有効化 |
