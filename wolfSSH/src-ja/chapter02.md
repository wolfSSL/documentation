#  wolfSSH のビルド

wolfSSH はポータビリティを念頭において開発されているので、多くのシステム上で概ね容易にビルドできるはずです。もしビルドで問題がありましたら、遠慮なくサポートフォーラム https://www.wolfssl.com/forums を通じてサポートをお求めいただくか、support@wolfssl.com へ直接ご連絡ください。

この章では、Linux、un\*x 系（BSD、macOS）、および Windows 環境で wolfSSH をビルドする方法を説明し、非標準環境でのビルドに関するガイダンスも提供します。入門ガイドとサンプルは第 3 章に用意しています。

autotools システムを使ってビルドする際には、wolfSSH は単一の Makefile によってライブラリのすべての部分とサンプルをビルドします。これは Makefile を再帰的に使用する場合に比べてシンプルかつ高速です。

##  ソースコードの入手

最新の最新版は、次の GitHub サイトからダウンロードできます: [https://github.com/wolfSSL/wolfssh](https://github.com/wolfSSL/wolfssh)。

"Download ZIP" ボタンをクリックするか、ターミナルで次のコマンドを実行してください:
```
$ git clone https://github.com/wolfSSL/wolfssh.git
```
##  wolfSSH が依存するモジュール

wolfSSH は wolfCrypt に依存しているため、wolfSSL のコンフィギュレーションが必要です。wolfSSL はここからダウンロードできます: [https://github.com/wolfSSL/wolfssl](https://github.com/wolfSSL/wolfssl)。wolfSSH に必要な最も簡潔な wolfSSL の構成は、既定のビルドです。これは wolfSSL のルートフォルダから次のコマンドでビルドできます:

```
$ ./autogen.sh (GitHub からクローンした場合にのみ実行が必要)
$ ./configure --enable-wolfssh
$ make check
$ sudo make install
```
wolfSSH の鍵生成機能を利用するには、wolfSSL を keygen 付きでコンフィギュレーションする必要があります:
```
--enable-keygen
```
wolfSSL コードの大部分が不要な場合は、crypto only オプションで wolfSSL をコンフィギュレーションできます:
```
--enable-cryptonly
```

wolfSSH には `--enable-wolfssh`（`WOLFSSL_WOLFSSH` を定義します）付きでビルドした wolfSSL が必要です。このオプションなしでビルドされた wolfSSL に対して wolfSSH をビルドすると、`#error` で停止します。wolfSSH の一部の機能には、さらに次の wolfSSL オプションが必要です:

- X.509 証明書（`--enable-certs`）は wolfSSL の証明書マネージャーを使用するため、wolfSSL は `--enable-cryptonly` ではなく TLS 付きでビルドする必要があります。OCSP による問い合わせを可能にするには `--enable-ocsp` を追加してください。
- Curve25519 鍵交換には `--enable-curve25519` が必要です。
- ML-KEM ハイブリッド鍵交換には `--enable-mlkem` が必要です。
- ML-DSA のホスト鍵とユーザー認証には `--enable-mldsa` と wolfSSL 5.9.2 以降が必要です。
- TPM サポート（`--enable-tpm`）には `--enable-wolftpm` 付きでビルドした wolfSSL と wolfTPM が必要です。
- wolfssh クライアントアプリケーション（`--enable-sshclient`）には、スレッド対応の wolfSSL と wolfSSL の Base64 エンコーダー（`--enable-base64encode`、x86_64 でのみデフォルトで有効）が必要です。

##   autotools でのビルド

Linux、BSD、macOS、Solaris、その他の un\*x 系環境でビルドする場合は、autotools システムを使用します。wolfSSH をビルドするには次のコマンドを実行します:
```
$ ./autogen.sh (GitHub からクローンした場合にのみ実行が必要)
$ ./configure
$ make
$ make install
```
configure コマンドにはビルドオプションを追加できます。利用可能な configure オプションとその用途の一覧は、次のコマンドで参照できます:
```
$ ./configure --help
```
wolfSSH をビルドするには次を実行します:
```
$ make
```
wolfSSH が正しくビルドされたことを確認するために、次のコマンドで全てのテストがパスしたかどうかを確認してください:

```
$ make check
```

wolfSSH をインストールするには次を実行します:
```
$ make install
```

インストールにはスーパーユーザー権限が必要な場合があり、その場合は sudo を付けてインストールを実行してください:
```
$ sudo make install
```
wolfssh/src/ にある wolfSSH ライブラリのみをビルドし、追加のアイテム（サンプルとテスト）はビルドしたくない場合は、wolfSSH のルートフォルダから次のコマンドを実行できます:
```
$ make src/libwolfssh.la
```
##  ビルドオプション

`./configure` には次のオプションを指定できます。各機能オプションは、「wolfSSH プリプロセッサガードマクロ」の章でそのオプションに対応して記載されているプリプロセッサマクロも定義します。

| オプション | デフォルト | 説明 |
|-------------------------------|-----------|--------------------------------------------|
| `--with-wolfssl=PATH` | /usr/local | wolfSSL のインストールプレフィックス。`PATH/lib` と `PATH/include` が存在している必要があります。 |
| `--enable-debug` | 無効 | デバッグコードとログ出力を追加し、最適化を無効にします。 |
| `--disable-inline` | 有効 | インライン関数を無効にします。 |
| `--disable-examples` | 有効 | サンプルプログラムをビルドしません。 |
| `--disable-server` | 有効 | サーバーのコードを除外します。`--disable-client` と同時には指定できません。 |
| `--disable-client` | 有効 | クライアントのコードを除外します。`--disable-server` と同時には指定できません。 |
| `--enable-keygen` | 無効 | 鍵生成 API。wolfSSL には `--enable-keygen` が必要です。 |
| `--enable-keyboard-interactive` | 無効 | keyboard-interactive ユーザー認証。 |
| `--enable-scp` | 無効 | SCP サポート。 |
| `--enable-sftp` | 無効 | SFTP サポート。 |
| `--disable-sftp-zeroize` | 有効 | SFTP のファイルデータバッファを解放前にゼロクリアしません。 |
| `--enable-fwd` | 無効 | TCP/IP ポートフォワーディング。 |
| `--disable-term` | 有効 | 疑似端末サポートを除外します。 |
| `--enable-shell` | 無効 | echoserver でのシェルサポート。 |
| `--enable-agent` | 無効 | ssh-agent サポート。 |
| `--enable-certs` | 無効 | X.509 証明書サポート。 |
| `--enable-ossh-certs` | 無効 | OpenSSH 証明書によるユーザー認証。 |
| `--enable-windows-cert-store` | 無効 | Windows 証明書ストアから鍵と証明書を読み込みます。`--enable-certs` と mingw の Windows ホストが必要です。`crypt32` と `ncrypt` をリンクします。 |
| `--enable-tpm` | 無効 | wolfTPM による TPM 2.0 サポート。 |
| `--enable-smallstack` | 無効 | 大きなバッファをヒープから確保し、スタック使用量を削減します。 |
| `--enable-none-cipher` | 無効 | 暗号化と完全性保護を無効にする安全でない "none" 暗号および MAC のネゴシエーションを許可します。 |
| `--enable-sshd` | 無効 | wolfSSHd サーバーデーモンをビルドします。`--enable-shell` も有効にします。 |
| `--with-pam=PATH` | なし | wolfSSHd 用の PAM ライブラリのディレクトリ。 |
| `--enable-sshclient` | 無効 | wolfssh クライアントアプリケーションをビルドします。 |
| `--enable-all` | 無効 | keygen、keyboard-interactive、scp、sftp、fwd、shell、agent、sshd、sshclient、certs を有効にします。 |
| `--enable-distro` | 無効 | `--enable-all` に加えて、共有ライブラリとスタティックライブラリの両方をビルドします。 |

wolfssh クライアントアプリケーションはすべてのセッションの I/O をスレッド上で実行するため、スレッド対応の wolfSSL が必要です。シングルスレッドの wolfSSL に対して `--enable-sshclient` を指定すると configure エラーになりますが、`--enable-all` の場合は失敗せずにクライアントを除外します。

`--enable-all` は `--enable-ossh-certs`、`--enable-windows-cert-store`、`--enable-tpm`、`--enable-smallstack`、`--enable-none-cipher` を有効にしません。これらは明示的に追加してください。

ビルドツリー内の `./apps/wolfssh-options` は、有効になっている各ビルドオプションの名前を 1 行に 1 つずつ出力します。テストスクリプトでの使用を想定したもので、インストールはされません。

##  Windows 上でのビルド

Visual Studio のプロジェクトファイルは *ide\\winvs* ディレクトリにあります。

ソリューションファイル 'wolfssh.sln' により、wolfSSH とそのサンプルおよびテストプログラムをビルドできます。このソリューションは、スタティックおよびダイナミックの 32 ビットまたは 64 ビットライブラリの Debug ビルドと Release ビルドの両方を提供します。wolfSSL のビルドをコンフィギュレーションするには user_settings.h を使用してください。

このプロジェクトは、wolfSSH と wolfSSL のソースディレクトリが隣り合わせにインストールされ、そのフォルダ名にバージョン番号が含まれていないことを前提としています:

```
Projects\
wolfssh\
wolfssl\
```

`wolfssh\ide\winvs\user_settings.h` ファイルには、wolfSSL を適切な設定でコンフィギュレーションするための設定が含まれています。このファイルは `wolfssh\ide\winvs` ディレクトリから `wolfssl\IDE\WIN` へコピーする必要があります。一方のコピーを変更した場合は、両方のコピーを変更しなければなりません。`WOLFCRYPT_ONLY` オプションは wolfSSL ファイルのビルドを無効にし、wolfCrypt アルゴリズムのみをビルドします。wolfSSL も残すには、このオプションを削除してください。X.509 証明書サポートには TLS 層が必要なため、このファイルの X.509 ブロックでは `WOLFSSH_CERTS` を定義するとともに `WOLFCRYPT_ONLY` を削除しています。

各プロジェクトは、Windows 証明書ストアのサポート（`WOLFSSH_WINDOWS_CERT_STORE`）のために Windows の `crypt32.lib` および `ncrypt.lib` インポートライブラリとリンクします。これを使用するには、`user_settings.h` のコメントブロックの説明にしたがって、`WOLFSSH_CERTS` とともに `WOLFSSH_WINDOWS_CERT_STORE` を定義してください。

### Windows 上でのビルドに使用するユーザーマクロ

このソリューションでは、wolfSSL ライブラリとヘッダーの場所を示すためにユーザーマクロを使用します。すべてのパスは wolfssl64 ソリューションの既定のビルド出力先に設定されています。ユーザーマクロ wolfCryptDir は、ライブラリを検索するためのベースパスとして使用されます。初期値は `..\..\..\..\wolfssl` に設定されています。そして、例えば API テストプロジェクトの追加インクルードディレクトリの値は `$(wolfCryptDir)` に設定されています。

wolfCryptDir パスは、プロジェクトファイルからの相対パスでなければなりません。プロジェクトファイルはすべて 1 つ下のディレクトリにあります。

```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```
その他のユーザーマクロは、異なるビルド向けの wolfSSL ライブラリが見つかるディレクトリです。したがって、ユーザーマクロ 'wolfCryptDllRelease64' は初期値として次のように設定されています:
```
$(wolfCryptDir)\DLL Release\x64
```
この値は、echoserver の 64 ビット DLL Release ビルドのデバッグ環境で次のように設定して使用されます:
```
PATH=$(wolfCryptDllRelease64);%PATH%
```
デバッガーから echoserver を実行すると、そのディレクトリで wolfSSL DLL が見つかります。

##  非標準環境でのビルド

公式にはサポートしていませんが、非標準環境、特に組み込みおよびクロスコンパイル環境で wolfSSH をビルドしたいユーザーをできるだけお手伝いしようとしています。以下は、その際に理解しておいていただきたい点です:

1. ソースファイルとヘッダーファイルは、wolfSSH ダウンロードパッケージにある階層構造のまま維持する必要があります。
2. 一部のビルドシステムでは、wolfSSH ヘッダーファイルの場所を明示的に知る必要があるため、それを指定しなければならない場合があります。それらは <wolfssh_root>/wolfssh ディレクトリにあります。通常、<wolfssh_root> ディレクトリをインクルードパスに追加することでヘッダーの問題を解決できます。
3. wolfSSH は、configure プロセスがビッグエンディアンを検出しない限り、リトルエンディアンシステムを既定とします。非標準環境でビルドするユーザーは configure プロセスを使用していないため、ビッグエンディアンシステムを使用する場合は BIG_ENDIAN_ORDER を定義する必要があります。
4. ライブラリをビルドしてみて、何か問題が生じた場合はお知らせください。サポートが必要な場合は、support@wolfssl.com までご連絡ください。

##  クロスコンパイル
組み込みプラットフォームの多くのユーザーは、自身の環境向けにクロスコンパイルを行います。ライブラリをクロスコンパイルする最も簡単な方法は、configure システムを使用することです。configure システムは Makefile を生成し、それを使って wolfSSH をビルドできます。

クロスコンパイルを行う際には、次のようにコンフィギュレーションするホストを指定する必要があります:
```
$ ./configure --host=arm-linux
```
また、使用したいコンパイラやリンカーなどを指定する必要がある場合もあります:
```
$ ./configure --host=arm-linux CC=arm-linux-gcc AR=arm-
linux-ar
RANLIB=arm-linux
```
クロスコンパイル用に wolfSSH を正しくコンフィギュレーションできた後は、標準の autoconf の作法にしたがってライブラリのビルドとインストールを行えるはずです:

```
$ make
$ sudo make install
```
wolfSSH のクロスコンパイルに関する追加の Tips やフィードバックがありましたら、facts@wolfssl.com までお知らせください。

##  カスタムディレクトリへのインストール

wolfSSL のカスタムインストールディレクトリを設定するには、次のようにします:
```
$ ./configure --prefix=~/wolfSSL
$ make
$ make install
```
これにより、ライブラリは ~/wolfSSL/lib に、インクルードは ~/wolfSSL/include に配置されます。wolfSSH のカスタムインストールディレクトリを設定し、その wolfSSL のインストール先を参照させるには、次のようにします:
```
$ ./configure  --prefix=~/wolfssh  --with-wolfssl=~/wolfSSL
$ make
$ make install
```
--with-wolfssl オプションには wolfSSL のインストール先プレフィックスを指定します。その配下に lib/ と include/ があることが前提です。wolfSSH に wolfSSL の場所を伝えるのはこのオプションです。--libdir および --includedir オプションは wolfSSH 自身のライブラリとヘッダーのインストール先を設定するものであり、wolfSSL の検索先には影響しません。

上記のパスが実際の場所と一致していることを確認してください。
