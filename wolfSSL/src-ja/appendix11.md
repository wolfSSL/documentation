# wolfSM (ShangMi)

この章では、wolfSSLにおける中国国家標準の暗号化アルゴリズムであるShangMi（SM）に関する情報を提供します。

wolfSMは以下の要素をサポートしています。

* SM3 - ハッシュ関数
* SM4 - 暗号
* SM2 - ECDH鍵共有と指定された256ビット楕円曲線を使用した署名スキーム

使用するためには、コードをwolfSSLにインストールする必要があります。
ただし、テストとビルド設定コードはすでにwolfSSLに含まれています。

## wolfSMの取得とインストール

### GitHubからwolfSMを取得する

GitHubからwolfSMリポジトリをクローンします。

```sh
git clone https://github.com/wolfssl/wolfsm.git
```

### GitHubからwolfSSLを取得する

SMアルゴリズム実装をビルドしてテストするにはwolfSSLが必要です。
wolfSMの隣にGitHubからwolfSSLリポジトリをチェックアウトします。

```sh
# ディレクトリ構造は次のようになります。
# <install-dir>
# ├── wolfsm
# └── wolfssl
```

```sh
cd .. # wolfsm を含むディレクトリに移動
git clone https://github.com/wolfssl/wolfssl.git
```

### SMコードをwolfSSLにインストールする

wolfSSLにSMコードをインストールするには、インストールスクリプトを使用します。

```sh
cd wolfsm
./install.sh
```

## wolfSMのビルド

wolfSMファイルをwolfSSLにインストールした後に、SMアルゴリズムをwolfSSLにビルドできます。

configure時に必要なアルゴリズムをご選択ください。

* `--enable-sm3`
* `--enable-sm4-ecb`
* `--enable-sm4-cbc`
* `--enable-sm4-ctr`
* `--enable-sm4-gcm`
* `--enable-sm4-ccm`
* `--enable-sm2`

例えばSM3、SM4-GCM、SM2を含める場合、次のようにします。

```sh
./autogen.sh
./configure --enable-sm3 --enable-sm4-gcm --enable-sm2
make
sudo make install
```

### SM2の最適化実装

SM2の最適化された実装を使用するには、Cのみのコードを使用するか、より高速なアセンブリコードを備えたCコードを使用できます。

- Cコードのみの場合： `--enable-sp`
- Cとアセンブリコードの場合： `--enable-sp --enable-sp-asm`

最適化されたCコードは、32ビットおよび64ビットCPUで利用可能です。

アセンブリコードは、以下のプラットフォームで利用可能です。

* Intel x64
* Aarch64
* ARM 32-bit
* ARM Thumb2
* ARM Thumb

## wolfSMのテスト

SM暗号が動作することをテストするには、次のコマンドを実行します。

```sh
make test
```

次のコマンドで、有効化されたアルゴリズムのベンチマークも実行できます。

```sh
./wolfcrypt/benchmark/benchmark
```

特定のアルゴリズムのベンチマークを行うには、アルゴリズムに対応するオプションをコマンドラインに追加してください。

* SM2: `-sm2`
* SM3: `-sm3`
* SM4: `-sm4` もしくは、
    * SM4-CBC: `-sm4-cbc`
    * SM4-GCM: `-sm4-gcm`
    * SM4-CCM: `-sm4-ccm`

### TLSのテスト

SM暗号はTLS 1.2およびTLS 1.3で使用できます。

**注意**: SM暗号スイートを動作させるには、SM2、SM3、および少なくとも1つのSM4暗号をビルドする必要があります。すべてのアルゴリズムはSMである必要があります。

追加される暗号スイートは以下の通りです。

 - ECDHE-ECDSA-SM4-CBC-SM3（TLSv1.2、`--enable-sm2 --enable-sm3 --enable-sm4-cbc`）
 - ECDHE-ECDSA-SM4-GCM-SM3（TLSv1.2、`--enable-sm2 --enable-sm3 --enable-sm4-gcm`）
 - ECDHE-ECDSA-SM4-CCM-SM3（TLSv1.2、`--enable-sm2 --enable-sm3 --enable-sm4-ccm`）
 - TLS13-SM4-GCM-SM3（TLSv1.3、`--enable-sm2 --enable-sm3 --enable-sm4-gcm`）
 - TLS13-SM4-CCM-SM3（TLSv1.3、`--enable-sm2 --enable-sm3 --enable-sm4-ccm`）

#### TLS 1.2でSM暗号スイートを使用する

「ECDHE-ECDSA-SM4-CBC-SM3」暗号スイートを使用してTLS 1.2をテストする例を以下に示します。

```sh
./examples/server/server -v 3 -l ECDHE-ECDSA-SM4-CBC-SM3 \
    -c ./certs/sm2/server-sm2.pem -k ./certs/sm2/server-sm2-priv.pem \
    -A ./certs/sm2/client-sm2.pem -V &
./examples/client/client -v 3 -l ECDHE-ECDSA-SM4-CBC-SM3 \
    -c ./certs/sm2/client-sm2.pem -k ./certs/sm2/client-sm2-priv.pem \
    -A ./certs/sm2/root-sm2.pem -C
```

実行結果は以下のようになります。

```
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3
SSL curve name is SM2P256V1
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3
SSL curve name is SM2P256V1
Client message: hello wolfssl!
I hear you fa shizzle!
```

#### TLS 1.3でSM暗号スイートを使用する

「TLS13-SM4-GCM-SM3」暗号スイートを使用してTLS 1.3をテストする例を以下に示します。

```sh
./examples/server/server -v 4 -l TLS13-SM4-GCM-SM3 \
    -c ./certs/sm2/server-sm2.pem -k ./certs/sm2/server-sm2-priv.pem \
    -A ./certs/sm2/client-sm2.pem -V &
./examples/client/client -v 4 -l TLS13-SM4-GCM-SM3 \
    -c ./certs/sm2/client-sm2.pem -k ./certs/sm2/client-sm2-priv.pem \
    -A ./certs/sm2/root-sm2.pem -C
```

実行結果は以下のようになります。

```
SSL version is TLSv1.3
SSL cipher suite is TLS_SM4_GCM_SM3
SSL curve name is SM2P256V1
SSL version is TLSv1.3
SSL cipher suite is TLS_SM4_GCM_SM3
SSL curve name is SM2P256V1
Client message: hello wolfssl!
I hear you fa shizzle!
```
