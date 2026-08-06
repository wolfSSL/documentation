#  wolfSSH のビルド

wolfSSH はポータビリティを念頭において開発されているので、多くのシステム上で概ね容易にビルドできるはずです。もしビルドで問題がありましたら、遠慮なくサポートフォーラム https://www.wolfssl.com/forums を通じてサポートをお求めいただくか、support@wolfssl.com へ直接ご連絡ください。

この章では、Linux、un\*x 系（BSD、macOS）、および Windows 環境で wolfSSH をビルドする方法を説明し、非標準環境でのビルドに関するガイダンスも提供します。入門ガイドとサンプルは第 3 章に用意しています。

autotools システムを使ってビルドする際には、wolfSSH は単一の Makefile によってライブラリのすべての部分とサンプルをビルドします。これは Makefile を再帰的に使用する場合に比べてシンプルかつ高速です。

##  ソースコードの入手

最新の最新版は、次の GitHub サイトからダウンロードできます: [https://github.com/wolfSSL/wolfssh](https://github.com/wolfSSL/wolfssh)。

“Download ZIP” ボタンをクリックするか、ターミナルで次のコマンドを実行してください:
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
##  Windows 上でのビルド

Visual Studio のプロジェクトファイルは *ide\\winvs* ディレクトリにあります。

ソリューションファイル 'wolfssh.sln' により、wolfSSH とそのサンプルおよびテストプログラムをビルドできます。このソリューションは、スタティックおよびダイナミックの 32 ビットまたは 64 ビットライブラリの Debug ビルドと Release ビルドの両方を提供します。wolfSSL のビルドをコンフィギュレーションするには user_settings.h を使用してください。

このプロジェクトは、wolfSSH と wolfSSL のソースディレクトリが隣り合わせにインストールされ、そのフォルダ名にバージョン番号が含まれていないことを前提としています:

```
Projects\
wolfssh\
wolfssl\
```

`wolfssh\ide\winvs\user_settings.h` ファイルには、wolfSSL を適切な設定でコンフィギュレーションするための設定が含まれています。このファイルは `wolfssh\ide\winvs` ディレクトリから `wolfssl\IDE\WIN` へコピーする必要があります。一方のコピーを変更した場合は、両方のコピーを変更しなければなりません。`WOLFCRYPT_ONLY` オプションは wolfSSL ファイルのビルドを無効にし、wolfCrypt アルゴリズムのみをビルドします。wolfSSL も残すには、このオプションを削除してください。

### Windows 上でのビルドに使用するユーザーマクロ

このソリューションでは、wolfSSL ライブラリとヘッダーの場所を示すためにユーザーマクロを使用します。すべてのパスは wolfssl64 ソリューションの既定のビルド出力先に設定されています。ユーザーマクロ wolfCryptDir は、ライブラリを検索するためのベースパスとして使用されます。初期値は `..\..\..\..\wolfssl` に設定されています。そして、例えば API テストプロジェクトの追加インクルードディレクトリの値は `$(wolfCryptDir)` に設定されています。

wolfCryptDir パスは、プロジェクトファイルからの相対パスでなければなりません。プロジェクトファイルはすべて 1 つ下のディレクトリにあります。

```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```
その他のユーザーマクロは、異なるビルド向けの wolfSSL ライブラリが見つかるディレクトリです。したがって、ユーザーマクロ 'wolfCryptDllRelease64' は初期値として次のように設定されています:
```
$(wolfCryptDir)\x64\DLL Release
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
これにより、ライブラリは ~/wolfSSL/lib に、インクルードは ~/wolfssl/include に配置されます。wolfSSH のカスタムインストールディレクトリを設定し、カスタムの wolfSSL ライブラリおよびインクルードディレクトリを指定するには、次のようにします:
```
$ ./configure  --prefix=~/wolfssh  --libdir=~/wolfssl/lib  --includedir=~/wolfssl/include
$ make
$ make install
```
上記のパスが実際の場所と一致していることを確認してください。
