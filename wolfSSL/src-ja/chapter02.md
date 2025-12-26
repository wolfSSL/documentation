# wolfSSLのビルド

wolfSSLはポータビリティを念頭に置いて書かれており、一般的にほとんどのシステムで容易にビルドできます。
wolfSSLをビルドするのが難しい場合は、サポートフォーラム(<https://www.wolfssl.com/forums>)を通してサポートを求めるか、[support@wolfssl.com](mailto:support@wolfssl.com)に遠慮なく直接お問い合わせください。

この章では、UnixとWindowsでwolfSSLをビルドする方法を説明し、非標準環境でwolfSSLをビルドする場合のガイダンスも提供します。
[第3章](chapter03.md)に入門ガイド、[第11章](chapter11.md)にSSLチュートリアルをご用意しています。

autoconf/automakeシステムを使用してwolfSSLをビルドする場合、単一のMakeFileを使用してwolfSSLライブラリの全てのパーツとサンプルプログラムを一度にビルドします。

## wolfSSLソースコードの取得

最新バージョンのwolfSSLは、wolfSSLのWebサイトからZIPファイルとしてダウンロードできます。

<https://wolfssl.jp/download/>

zipファイルをダウンロードしたら、`unzip`コマンドを使用してファイルを解凍します。
ネイティブの行末文字を使用するには、unzipを使用する際に`-a`オプションを有効にします。
[unzip man page]で、`-a`オプションが説明されています。

> [...] -aオプションでは、zipによってテキストファイル（ZipInfoリストで「b」ではなく「t」ラベルがついているファイル）と識別されると行末文字、ファイル終端文字を変換します。必要に応じて指定してください。[...]

**注**：wolfSSL 2.0.0RC3のリリースから、wolfSSLのディレクトリ構造と標準のインストールフォルダーが変更されました。
これらの変更は、オープンソースプロジェクトがwolfSSLを統合しやすくするために行われました。
ヘッダーと構造の変更の詳細については、[第9章](chapter09.md)の「ライブラリヘッダー」および「構造の使用」節を参照してください。

## \*nix上でビルド

Linux、\*BSD、OS X、Solaris、またはその他の\*nixのようなシステムにwolfSSLをビルドする場合、autoconfシステムを使用します。
wolfSSLをビルドするには、wolfSSLルートディレクトリから2つのコマンド`./configure`および`make`を実行するだけです。

`./configure`スクリプトはビルド環境をセットアップし、任意の数のビルドオプションを`./configure`に追加します。
利用可能なビルドオプションのリストについては、この章のビルドオプション節を参照するか、次のコマンドラインを実行して、`./configure`に渡すことができるオプションのリストを表示させてください。

```sh
./configure --help
```

`./configure`が正常に実行されたら、wolfSSLをビルドするために`make`を実行してください。

```sh
make
```

wolfSSLをインストールするには以下を実行します。

```sh
make install
```

インストールするには特権を必要とする場合もあるかもしれません。
その場合は次のようにsudoをコマンドの前に加えてください。

```sh
sudo make install
```

ビルドをテストするには、wolfSSLのルートディレクトリからtestsuiteプログラムを実行します。

```sh
./testsuite/testsuite.test
```

あるいは、autoconfを使用してtestsuiteを実行し、標準のwolfSSL APIおよび暗号テストを実行します。

```sh
make test
```

testsuiteプログラムの予想される出力に関する詳細は、[第3章](chapter03.md)のテストスイート節にあります。

もし、wolfSSLライブラリのみのビルドが必要で、そのほかのコンポーネント（サンプルプログラム、テストスイート、ベンチマークアプリケーション等）はビルドしたくない場合には、wolfSSLのルートディレクトリで下記コマンドを実行してください、

```sh
make src/libwolfSSL.la
```

## Windowsの上でのビルド

以下の説明に加えて、Visual StudioでwolfSSLをビルドするための手順とヒントは[ここ](https://wolfssl.com/wolfSSL/Docs-wolfSSL-visual-studio.html)でも提供しています。

### Visual Studio 2008

インストールのルートディレクトリに Visual Studio 2008 用のソリューションが含まれています。
Visual Studio 2010 以降で使用する場合、既存のプロジェクトファイルはインポートプロセス中に変換できるはずです。

**注意**:
新しいバージョンの Visual Studio にインポートする場合、「プロジェクトとインポートされたプロパティシートを上書きしますか？」と尋ねられます。
「いいえ」を選択すると、以下の問題を回避できます。
「はい」を選択すると、`SAFESEH` 指定のために `EDITANDCONTINUE` が無視されるという警告が表示されます。
testsuite、sslSniffer、server、echoserver、echoclient、client をそれぞれ右クリックして、プロパティ->構成プロパティ->リンカー->Advanced（Advanced ウィンドウの一番下までスクロール）を変更する必要があります。
「安全な例外ハンドラーを含むイメージ」を見つけ、右端の下矢印をクリックします。
これを前述の各プロジェクトに対して「いいえ」（`/SAFESEH:NO`）に変更します。
もう一つの選択肢は `EDITANDCONTINUE` を無効にすることですが、デバッグ目的では有用であるため推奨されません。

### Visual Studio 2010

wolfSSL ソリューションをビルドするには、Service Pack 1 をダウンロードする必要があります。
Visual Studioがリンカエラーを報告する場合は、プロジェクトをクリーンしてリビルドすると解消するはずです。

### Visual Studio 2013 (64ビットソリューション)

wolfSSLソリューションをビルドするには、Service Pack 4 をダウンロードする必要があります。
Visual Studioがリンカエラーを報告する場合は、プロジェクトをクリーンしてリビルドすると解消するはずです。

各ビルドをテストするには、Visual Studio メニューから「Build All」を選択し、testsuite プログラムを実行します。
Visual Studio プロジェクトのビルドオプションを編集するには、目的のプロジェクト（wolfSSL、echoclient、echoserver など）を選択し、「プロパティ」パネルを参照してください。

**注意**: wolfSSL v3.8.0 リリース以降、ビルドプリプロセッサマクロは `IDE/WIN/user_settings.h` にある中央ファイルに移動しました。
このファイルはプロジェクト内でも見つけることができます。
ECC や ChaCha20/Poly1305 などの機能を追加するには、`HAVE_ECC` や `HAVE_CHACHA` / `HAVE_POLY1305` などの `#defines` をここに追加します。

### Cygwin

Windows開発マシン上でWindows用のwolfSSLをビルドする場合は、リポジトリに含まれるVisual Studioプロジェクトファイルを使用してビルドすることをお勧めします。
しかしCygwinが必要な場合は、当社チームがビルドに成功した際のガイダンスがありますから以下にご紹介します。

1. <https://www.cygwin.com/install.html> にアクセスして `setup-x86_64.exe` をダウンロードします、
2. `setup-x86_64.exe` を実行し、希望する方法でインストールします。「Select Packages」段階に到達するまでインストールメニューをクリックします。
3. 「+」アイコンをクリックして「All」を展開します、
4. 「Archive」セクションに移動し、「unzip」ドロップダウンを選択して、「Skip」を 6.0-15（または他のバージョン）に変更します。
5. 「Devel」の下で「autoconf」ドロップダウンをクリックし、「Skip」を「10-1」（または他のバージョン）に変更します、
6. 「Devel」の下で「automake」ドロップダウンをクリックし、「Skip」を「10-1」（または他のバージョン）に変更します。
7. 「Devel」の下で「gcc-core」ドロップダウンをクリックし、「Skip」を 7.4.0-1 に変更します。（注：wolfSSL は GCC 9 または 10 をテストしておらず、比較的新しいものであるため、開発用に微調整する時間が多少経つまで使用することをお勧めしません）
8. 「Devel」の下で「git」ドロップダウンをクリックし、「Skip」を 2.29.0-1（または他のバージョン）に変更します。
9. 「Devel」の下で「libtool」ドロップダウンをクリックし、「Skip」を「2.4.6-5」（または他のバージョン）に変更します。
10. 「Devel」の下で「make」ドロップダウンをクリックし、「Skip」を 4.2.1-1（または他のバージョン）に変更します。
11. 「Next」をクリックして、インストールの残りの部分を進めます。

追加のパッケージとして、以下が必要です。

* unzip
* autoconf
* automake
* gcc-core
* git
* libtool
* make

#### インストール後の作業

Cygwinターミナルを開き、wolfSSLをクローンします。

```sh
git clone https://github.com/wolfSSL/wolfSSL.git
cd wolfSSL
./autogen.sh
./configure
make
make check
```

## 非標準環境でのビルド

公式にはサポートしていませんが、特に組み込み向けややクロスコンパイルシステムを使用して、非標準環境でwolfSSLをビルドしたいユーザーを支援するよう努めています。以下にいくつかの注意点を示します。

1. ソースファイルとヘッダーファイルは、wolfSSLダウンロードパッケージ内にあるのと同じディレクトリ構造を維持する必要があります。
2. 一部のビルドシステムでは、wolfSSLヘッダーファイルの場所を明示的に知りたい場合があるため、それを指定する必要があるかもしれません。それらは `<wolfSSL_root>/wolfSSL` ディレクトリにあります。通常は、インクルードパスに`<wolfSSL_root>` ディレクトリを追加してください。
3. wolfSSLは、configureプロセスがビッグエンディアンを検出しない限り、デフォルトでリトルエンディアンシステムとなります。非標準環境でビルドするユーザーはconfigureプロセスを使用していないため、ビッグエンディアンシステムを使用している場合は `BIG_ENDIAN_ORDER` を定義する必要があります。
4. wolfSSLは64ビット型を利用できると速度が向上します。configureプロセスはlongまたはlong longが64ビットかどうかを判断し、defineを設定します。したがって、システム上で `sizeof(long)` が8バイトの場合は、`SIZEOF_LONG 8`を定義してください。`sizeof(long long)` が8バイトの場合は、`SIZEOF_LONG_LONG 8` を定義します。
5. ライブラリのビルドで問題が発生した場合は、お知らせください。サポートが必要な場合は、[support@wolfssl.com](mailto:support@wolfssl.com) までご連絡ください。
6. ビルドを変更できる定義は、本章の後の節に示しています。多くのオプションの詳細な説明については、ビルドオプション節を参照してください。

### Yocto Linuxへのビルド

wolfSSLはYocto LinuxとOpenEmbeddedでwolfSSLをビルドするためのレシピも含んでいます。
これらのレシピはmeta-wolfSSLレイヤーとしてGitHubリポジトリで管理しています。

<https://github.com/wolfSSL/meta-wolfSSL>

Yocto LinuxでwolfSSLをビルドするにはGitとbitbakeが必要です。
以下に、Yocto Linux上でwolfSSL製品（レシピが存在するもの）をビルドする方法を説明します。

1. **wolfSSL metaをクローン**

    ```sh
    git clone https://github.com/wolfSSL/meta-wolfSSL
    ```

2. **「meta-wolfSSL」レイヤーをビルドのbblayers.confに挿入**

    `BBLAYERS`セクション内で、meta-wolfSSLがクローン作成された場所へのパスを追加します。

    ```sh
    BBLAYERS ?= "... \
    /path/to/meta-wolfSSL/ \
    ..."
    ```

3. **wolfSSL製品レシピをビルド**

    bitbakeを使用して、*wolfSSL*、*wolfssh*、*wolfmqtt*をビルドします。
    これらのレシピのいずれかをbitbakeコマンドに渡すだけです。
    （例：`bitbake wolfSSL`）
    これにより、ユーザーはコンパイルが問題なく成功することを確認できます。

4. **local.confを編集**

    最後のステップは、ビルドの`local.conf`ファイルを編集して、ビルド中のイメージに必要なライブラリを含めることです。
    希望するレシピの名前を含むように`IMAGE_INSTALL_append`行を編集します。
    以下にその例を示します。

    ```sh
    IMAGE_INSTALL_append="wolfSSL wolfssh wolfmqtt"
    ```

イメージがビルドされると、wolfSSLのデフォルトの場所（またはレシピからの関連製品）は`/usr/lib/`ディレクトリになります。

さらに、wolfSSLは後のビルドオプション節にリストされている有効化および無効化オプションを使用して、Yoctoにビルドする際にカスタマイズできます。
これには、`.bbappend`ファイルを作成し、wolfSSLアプリケーション/レシピレイヤー内に配置する必要があります。
このファイルの内容には、`EXTRA_OECONF`変数に連結する内容を指定する行を含める必要があります。
以下に、TLS 1.3有効化オプションを通じてTLS 1.3サポートを有効にする例を示します。

```sh
EXTRA_OECONF += "--enable-tls13"
```

Yoctoへのビルドに関する詳細なドキュメントは、meta-wolfSSL READMEに掲載しています。

<https://github.com/wolfSSL/meta-wolfSSL/blob/master/readme.md>

### Atollic TrueSTUDIOでのビルド

3.15.5以降のwolfSSLバージョンには、ARM M4-Cortexデバイス上でwolfSSLをビルドするために使用されるTrueSTUDIOプロジェクトファイルが含まれています。
TrueSTUDIOプロジェクトファイルは、ST Microelectronicsの一部であるAtollicによって作成されたもので、無料でダウンロードできます。
これを使用することで、STM32デバイス上でのビルドプロセスを簡素化できます。
TrueSTUDIOでwolfSSL静的ライブラリプロジェクトファイルをビルドするには、TrueSTUDIOを開いた後、ユーザーが以下の手順を実行する必要があります。

1. プロジェクトをワークスペースにインポートする（ファイル > インポート）
2. プロジェクトをビルドする（プロジェクト > プロジェクトのビルド）

ビルド時に`user_settings.h`内にある設定がインクルードされます。
`user_settings.h`ファイルのデフォルトの内容は最小限であり、多くの機能は含まれていません。
ユーザーはこのファイルを変更し、後の章に示すオプションで機能を追加または削除できます。

### IARでのビルド

`<wolfSSL_root>/IDE/IAR-EWARM`ディレクトリには、以下のファイルが含まれています。

1. ワークスペース：`wolfSSL.eww`
  ワークスペースには、wolfSSL-LibライブラリとwolfCrypt-test、wolfCrypt-benchmark
  実行可能プロジェクトが含まれています。
2. wolfSSL-Libプロジェクト：`lib/wolfSSL-lib.ewp`
  wolfCryptとwolfSSL関数の完全なセットライブラリを生成します。
3. テストスイートプロジェクト：`test/wolfCrypt-test.ewp`
  test.outテストスイート実行可能ファイルを生成します。
4. ベンチマークプロジェクト：`benchmark/wolfCrypt-benchmark.ewp`
  benchmark.outベンチマーク実行可能ファイルを生成します。

これらのプロジェクトは一般的なARM Cortex-M MPU向けに設定されています。
特定のターゲットMPU用のプロジェクトを生成するには、以下の手順を実行してください。

1. デフォルト設定：プロジェクトのデフォルトターゲットはCortex-M3シミュレータに設定されています。user_settings.hにはプロジェクトのデフォルトオプションが含まれています。シミュレータに対してビルドしてダウンロードできます。「view」->「Terminal I/O」でターミナルI/Oウィンドウを開き、実行を開始します。

2. プロジェクトオプション設定：各プロジェクトに適切な「ターゲット」オプションを選択します。

3. 実行可能プロジェクトの場合：MPU用の「SystemInit」と「startup」を追加し、デバッグ用の「ドライバ」を選択します。

4. ベンチマークプロジェクトの場合：current_time関数のオプションを選択するか、`WOLFSSL_USER_CURRTIME`オプションで独自の「current_time」ベンチマークタイマーを作成します。

5. ビルドとダウンロード：EWARMビルドとダウンロードのために、メニューバーの「Project->Make」と「Download and Debug」に進みます。

### macOSやiOSでのビルド

#### Xcode

`<wolfSSL_root>/IDE/XCODE`ディレクトリには、以下のファイルが含まれています：

1. `wolfSSL.xcworkspace` -- ライブラリとテストスイートクライアントを含むワークスペース
2. `wolfSSL_testsuite.xcodeproj` -- テストスイートを実行するプロジェクト
3. `wolfSSL.xcodeproj` -- wolfSSLおよび/またはwolfCrypt用のOS/xとiOSライブラリをビルドするプロジェクト
4. `wolfSSL-FIPS.xcodeproj` -- 利用可能な場合、wolfSSLとwolfCrypt-FIPSをビルドするプロジェクト
5. `user_settings.h` -- プロジェクト間で共有されるカスタムライブラリ設定

ライブラリは、ターゲットに応じて`libwolfSSL_osx.a`または`libwolfSSL_ios.a`として出力されます。
また、wolfSSL/wolfCrypt（およびCyaSSL/CtaoCrypt互換性）ヘッダーを`Build/Products/Debug`または`Build/Products/Release`にある`include`ディレクトリにコピーします。

ライブラリとテストスイートを適切にリンクするには、ビルドの場所をワークスペースに対して相対的に設定する必要があります。

1. File -> Workspace Settings（またはXcode -> Preferences -> Locations -> Locations）
2. Derived Data -> Advanced
3. Custom -> Relative to Workspace
4. Products -> Build/Products

これらのXcodeプロジェクトは、複数のプロジェクトでマクロを設定するための`user_settings.h`ファイルを有効にするために、`WOLFSSL_USER_SETTINGS`プリプロセッサを定義しています。

必要に応じて、Xcodeプリプロセッサは以下の手順で変更できます。

1. 「Project Navigator」でプロジェクトをクリックします。
2. 「Build Settings」タブをクリックします。
3. 「Apple LLVM 6.0 - Preprocessing」セクションまでスクロールします。
4. 「Preprocessor Macros」の開示を開き、「+」と「-」ボタンを使用して変更します。これをDebugとReleaseの両方に対して行ってください。

このプロジェクトは、デフォルト設定を使用してwolfSSLとwolfCryptをビルドする必要があります。

### GCC ARMでのビルド

`<wolfSSL_root>/IDE/GCC-ARM`ディレクトリには、Cortex Mシリーズ用のwolfSSLプロジェクト例がありますが、他のアーキテクチャに適用することもできます。

1. `gcc-arm-none-eabi`がインストールされていることを確認してください。
2. `Makefile.common`を変更します：
  * 正しいツールチェーンパス`TOOLCHAIN`を使用します。
  * 正しいアーキテクチャ「ARCHFLAGS」を使用します。[GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc-4.7.3/gcc/ARM-Options.html) `-mcpu=name`を参照してください。
  * linker.ldのメモリマップがフラッシュ/RAMと一致することを確認するか、`Makefile.common`の`SRC_LD = -T./linker.ld`をコメントアウトします。
3. `make`を使用して、静的ライブラリ（libwolfSSL.a）、wolfCryptテスト/ベンチマーク、およびwolfSSL TLSクライアントターゲットを`/Build`内の`.elf`と`.hex`としてビルドします。

#### 一般的なMakefileを使ったクロスコンパイルによるビルド

Cortex-A53を搭載したRaspberry Pi用の`Makefile.common`変更例を示します。

1. Makefile.common 内の`ARCHFLAGS`を`-mcpu=cortex-a53 -mthumb`に変更します。
2. カスタムメモリマップが適用されないため、`SRC_LD`をコメントアウトします。
3. `TOOLCHAIN`をクリアしてデフォルト`gcc`を使用します。"`TOOLCHAIN =`"　とします。
4. `LDFLAGS += --specs=nano.specs`と`LDFLAGS += --specs=nosys.specs`をコメントアウトしてください。

#### configureでのクロスコンパイルによるビルド

メインプロジェクトディレクトリの構成スクリプトは、gcc-arm-none-eabiツールでビルドするようにクロスコンパイルを実行できます。
以下の例ではツールへのパスが適切に設定されていると仮定します。

```sh
./configure \
  --host=arm-none-eabi \
  CC=arm-none-eabi-gcc \
  AR=arm-none-eabi-ar \
  STRIP=arm-none-eabi-strip \
  RANLIB=arm-none-eabi-ranlib \
  --prefix=/path/to/build/wolfssl-arm \
  CFLAGS="-march=armv8-a --specs=nosys.specs \
      -DHAVE_PK_CALLBACKS -DWOLFSSL_USER_IO -DWOLFSSL_NO_SOCK -DNO_WRITEV" \
  --disable-filesystem --enable-crypttests \
  --disable-shared
make
make install
```

32ビットアーキテクチャをビルドしている場合は、`-DTIME_T_NOT_64BIT`を`CFLAGS`に追加してください。

### Keil MDK-ARMでのビルド

Keil MDK-ARMでwolfSSLをビルドするための詳細な手順とヒントは[こちら](https://www.wolfssl.com/docs/keil-mdk-arm/)で見つけることができます。

**注意**：MDK-ARMがデフォルトではない場所にインストールされている場合、プロジェクトファイルの参照パス定義をすべて変更する必要があります。

## Cプリプロセッサマクロとして定義される機能

### 機能の削除

以下の定義は、wolfSSL から機能を削除するために使用できます。
これは、ライブラリ全体のフットプリントサイズを削減しようとしている場合に役立ちます。
`NO_<機能名>` 定義を定義することに加えて、ビルドから対応するソースファイルも削除できます。
ヘッダーファイルは対象外です。

#### NO_WOLFSSL_CLIENT

サーバーのみのビルド用です。クライアントに固有の呼び出しを削除します。
サイズのためにいくつかの呼び出しを削除する場合にのみ、これを使用します。

#### NO_WOLFSSL_SERVER

クライアントのみのビルド用です。サーバーに固有の呼び出しを削除します。
サイズのためにいくつかの呼び出しを削除する場合にのみ、これを使用します。

#### NO_DES3

DES3暗号化の使用を削除します。
一部の古いサーバーがそれを使用しているため、DES3はデフォルトで組み込まれており、SSL 3.0では必要です。
`NO_DH`および`NO_AES`は上記2つと同じで、広く使用されています。

#### NO_DSA

DSAの使用を削除します。
DSAは、一般的な使用が段階的に廃止されています。

#### NO_ERROR_STRINGS

エラー文字列を無効にします。
エラー文字列は、wolfSSLの場合は`src/internal.c`またはwolfCryptの`wolfcrypt/src/asn.c`にあります。

#### NO_HMAC

ビルドからHMACを削除します。

**注意**：SSL/TLSはHMACに依存します。wolfCryptのみを使用している場合、（ビルドオプション `WOLFCRYPT_ONLY`）HMACを無効にできます。

#### NO_MD4

ビルドからMD4を削除します。
MD4は解読されているため、使用してはなりません。

#### NO_MD5

ビルドからMD5を削除します。

#### NO_SHA

ビルドからSHA-1を削除します。

#### NO_SHA256

ビルドからSHA-256を削除します。

#### NO_PSK

事前共有キー拡張機能の使用をオフにします。
デフォルトでは組み込まれています。

#### NO_PWDBASED

PKCS＃12からPBKDF1、PBKDF2、PBKDFなどのパスワードベースの鍵導出関数を無効にします。

#### NO_RC4

ビルドからARC4ストリーム暗号の使用を削除します。
ARC4はまだ人気があり広く使用されているため、デフォルトで組み込まれています。

#### NO_SESSION_CACHE

セッションキャッシュが不要なときに定義できます。
これにより、メモリ使用量を約3KB減らすことができます。

#### NO_TLS

TLSをオフにします。
TLSをオフに設定することはお勧めしません。

#### SMALL_SESSION_CACHE

wolfSSLが使用するSSLセッションキャッシュのサイズを制限するように定義できます。
これにより、デフォルトのセッションキャッシュが33セッションから6セッションに短縮され、約2.5KB削減できます。

#### NO_RSA

RSAアルゴリズムのサポートを削除します。

#### WC_NO_RSA_OAEP

OAEPパディングのコードを削除します。

#### NO_AES_CBC

AES-CBCアルゴリズムサポートをオフにします。

#### NO_AES_DECRYPT

コードサイズを削減するために設定できます。
復号を無効にし、暗号化のみをサポートするように設定します。

#### WOLFCRYPT_ONLY

TLSを無効にしてwolfCryptのみを有効にします。

#### NO_CAMELLIA_CBC

Camellia CBCサポートを無効にします。
TLS暗号スイートにのみ適用されます。

#### NO_AES

AESアルゴリズムサポートを無効にします。

#### NO_AES_128

コンパイル時のAESキーサイズ選択に使用されます。

#### NO_AES_192

コンパイル時のAESキーサイズ選択に使用されます。

#### NO_AES_256

コンパイル時のAESキーサイズ選択に使用されます。

#### NO_AESGCM_AEAD

AES GCMを使用するTLS暗号スイートを無効にします。
AES GCM暗号スイートが有効になっていない場合に内部的に使用するものですが、暗号スイートを制限するためにも使用できます。

#### NO_ASN_TIME

ASNの時間チェックを無効にします。

**注意**：すべての証明書の開始/終了日チェックがスキップされるため、これは注意して使用する必要があります。

#### NO_CHECK_PRIVATE_KEY

このマクロは、デフォルトでオンになっている追加の秘密鍵チェックを無効にします。
これにより、秘密鍵が公開鍵のペアであることを検証するチェックが有効になります。
RSA、ECDSA、ED25519、ED448、Falcon、DilithiumおよびSphincsでサポートされています。

#### NO_DH

Diffie-Hellman（DH）サポートを無効にします。

#### NO_ED25519_CLIENT_AUTH

ED25519のTLSクライアント認証サポートを無効にします。
メッセージのキャッシュが必要なため、ED25519が使用されていない場合、TLS中のメモリ使用量を削減するために使用されます。

#### NO_ED448_CLIENT_AUTH

ED448のクライアント認証を無効にします。

#### NO_FORCE_SCR_SAME_SUITE

デフォルトでは、セキュアな再ネゴシエーションでは同じ暗号スイートを使用する必要があります。
これはその要件を無効にします。

#### NO_MULTIBYTE_PRINT

組み込みデバイスが問題を抱える可能性のある、マルチバイト文字をコンパイルアウトするために使用されます。

#### NO_OLD_SSL_NAMES

wolfSSLとOpenSSLを一緒に使用するための、古いOpenSSL互換性マクロの一部を無効にします。

#### NO_OLD_WC_NAMES

不要な名前空間を削除します。

#### NO_OLD_POLY1305

相互運用性のために使用される、古いChaCha20/Poly1305 TLS 1.2暗号スイートのサポートを無効にします。

#### NO_HANDSHAKE_DONE_CB

`wolfSSL_SetHsDoneCb`で設定されるハンドシェイクコールバックのサポートを無効にします。
このオプションはコードサイズを削減するのに役立ちます。

#### NO_STDIO_FILESYSTEM

これはstdio.hのインクルードを無効にします。
移植性を保つために使用されます。

#### NO_TLS_DH

TLS DHを除外します。
一時的な有限体Diffie-Hellman鍵合意に基づく暗号スイートをネゴシエートすべきではありません。

#### NO_WOLFSSL_CM_VERIFY

証明書マネージャの検証コールバックを無効にします。
検証コールバックはエラーをインターセプトして上書きすることを可能にします。
このオプションはコードサイズを削減するのに役立ちます。

#### NO_WOLFSSL_DIR

ディレクトリサポートを無効にします。

#### NO_WOLFSSL_RENESAS_TSIP_TLS_SESSION

TSIP TLSリンク共通鍵暗号化方式のみを無効します。

**注意**：これはルネサスRX TSIP固有の定義です。

#### NO_WOLFSSL_SHA256

これはTLS 1.3にのみ適用されます。
SHA2-256をwolfCryptから有効にして使用できるようにしますが、TLS 1.3からは除外します。

#### WOLFSSL_BLIND_PRIVATE_KEY

秘密鍵をブラインドするためのマスクとして使用されます。
ブラインド処理はロウハンマー攻撃から保護するために使用されます。

#### WOLFSSL_DTLS13_NO_HRR_ON_RESUME

これが定義されている場合、DTLSサーバーはクライアントの再開が成功した場合にクッキー交換を行いません。

再開はより速く（1 RTT少なく）なり、帯域幅の消費が少なくなります。
（1つのClientHelloと、1つのHelloVerifyRequest/HelloRetryRequestが少なくなります）
一方、有効なSessionID/チケット/pskが収集された場合、偽造されたclientHelloメッセージはサーバー上のリソースを消費します。

DTLS 1.3の場合、このオプションを使用すると、サーバーがEarly Data/0-RTT Dataを処理することもできます。
これがなければ、サーバーはクッキーを持つ検証済みClientHelloを受信するまでステートフル処理に入らないため、Early Dataはドロップされます。

クッキー交換なしでDTLS 1.3再開を許可するには、次のようにします。

1. `WOLFSSL_DTLS13_NO_HRR_ON_RESUME`を定義してwolfSSLをコンパイルする
2. `wolfSSL_dtls13_no_hrr_on_resume(ssl, 1)`をWOLFSSLオブジェクトに呼び出して、再開時のクッキー交換を無効にする
3. 通常の接続と同様に続行する

#### WOLFSSL_NO_CLIENT_AUTH

Ed25519とEd448を使用するために必要な、キャッシングコードを無効にします。

#### WOLFSSL_NO_CURRDIR

`wolfSSL/test.h`のテストパスに./をサポートしないプラットフォーム用の移植性マクロです。
テストツールにのみ適用されます。

#### WOLFSSL_NO_DEF_TICKET_ENC_CB

デフォルトのチケット暗号化コールバックを定義しません。
サーバーのみに適用されます。
アプリケーションはセッションチケットを使用するために独自のコールバックを設定する必要があります。

#### WOLFSSL_NO_SOCK

移植のため、組み込みソケットサポートを無効にするためのマクロです。
ソケットなしでTLSを使用する場合、通常は`WOLFSSL_USER_IO`を定義し、送信/受信にコールバックを使用します。

#### WOLFSSL_NO_TLS12

TLS 1.2を除外するために定義します。

#### WOLFSSL_PEM_TO_DER

PEMからDERへの変換を無効にします。

#### NO_DEV_URANDOM

`/dev/urandom`の使用を無効にします。

#### WOLFSSL_NO_SIGALG

署名アルゴリズムの拡張子を無効にします。

#### NO_RESUME_SUITE_CHECK

TLS接続を再開するときに暗号スイートのチェックを無効にします。

#### NO_ASN

ASNフォーマットの証明書処理のサポートをオフにします。

#### NO_OLD_TLS

SSLV3、TLSV1.0、TLSV1.1のサポートを削除します。

#### WOLFSSL_AEAD_ONLY

非AEADアルゴリズムのサポートを削除します。
AEADは、「認証された暗号化」の略であり、これらのアルゴリズム(AES-GCMなど)がデータを暗号化および復号化するだけでなく、そのデータの機密性と信頼性を保証するアルゴリズムです。

#### WOLFSSL_SP_NO_2048

RSA/DH 2048ビット単精度(SP)最適化を削除します。

#### WOLFSSL_SP_NO_3072

RSA/DH 3072ビット単精度(SP)最適化を削除します。

#### WOLFSSL_SP_NO_256

SECP256R1のECC単精度(SP)最適化を削除します。`WOLFSSL_SP_MATH`にのみ適用されます。

### 機能の有効化 (デフォルトで有効)

#### HAVE_TLS_EXTENSIONS

ほとんどの TLS ビルドに必要な TLS 拡張機能のサポートを有効にします。

`./configure` を使用する場合これはデフォルトでオンになっていますが、`WOLFSSL_USER_SETTINGS` でビルドする場合は手動で定義する必要があります。

#### HAVE_SUPPORTED_CURVES

TLS でサポートされている曲線と、TLS で使用されるキー共有拡張機能を有効にします。 
ECC、Curve25519、および Curve448 で必要です。

`./configure` を使用する場合これはデフォルトでオンになっていますが、`WOLFSSL_USER_SETTINGS` でビルドする場合は手動で定義する必要があります。

#### HAVE_EXTENDED_MASTER

TLS v1.2 以前で使用されるセッションキーの計算用に拡張マスターシークレット PRF を有効にします。
PRF方式はデフォルトでオンになっており、より安全であると考えられています。

`./configure` を使用する場合これはデフォルトでオンになっていますが、`WOLFSSL_USER_SETTINGS` でビルドする場合は手動で定義する必要があります。

#### HAVE_ENCRYPT_THEN_MAC

ブロック暗号による暗号化後にMACを実行するためのencrypt-then-macサポートを有効にします。
これがデフォルトで、セキュリティが向上します。

`./configure` を使用する場合これはデフォルトでオンになっていますが、`WOLFSSL_USER_SETTINGS` でビルドする場合は手動で定義する必要があります。

#### HAVE_ONE_TIME_AUTH

Poly認証を設定するため、TLS v1.2でChacha20/Poly1305を使用する場合に必要です。

`./configure` を使用する場合、これは ChaCha20/Poly1305 でデフォルトで有効になりますが、`WOLFSSL_USER_SETTINGS` でビルドする場合は手動で定義する必要があります。

### 機能の有効化 (デフォルトで無効)

#### WOLFSSL_CERT_GEN

wolfSSLの証明書生成機能をオンにします。
詳細については、[第7章 キーと証明書](chapter07.md)を参照してください。

#### WOLFSSL_DER_LOAD

`wolfSSL_CTX_der_load_verify_locations()`関数を使用して、wolfSSLコンテキスト(`WOLFSSL_CTX`)へのDERフォーマットされたCA証明書をロードできます。

#### WOLFSSL_DTLS

DTLS(Datagram TLS)の使用をオンにします。
これは広くサポートされていないか、使用されていません。

#### WOLFSSL_KEY_GEN

wolfSSLのRSA鍵生成機能をオンにします。
詳細については、[第7章 キーと証明書](chapter07.md)を参照してください。

#### WOLF_PRIVATE_KEY_ID

これはPKCS11で使用され、キーIDとラベルAPIのサポートを有効にします。
FIPS v5以前は暗号コールバックで`WOLF_PRIVATE_KEY_ID`をサポートしていません。

#### WOLFSSL_WOLFSENTRY_HOOKS

`wolfSSL_CTX_set_AcceptFilter()`と`wolfSSL_CTX_set_ConnectFilter()`を使用した一般的なネットワーク`accept`および`connect`フィルターフックのサポートをTLSレイヤーに追加します。
また、サンプルクライアントおよびサーバーアプリケーションでのwolfSentry統合も有効化します。

#### WOLFSSL_CERT_EXT

証明書拡張、鍵および証明書生成機能です。

#### WOLFSSL_CERT_REQ

証明書要求、鍵および証明書生成機能です。

#### WOLFSSL_SSLKEYLOGFILE

これはWiresharkで使用されるキーロギングを有効にします。
マスターシークレットとクライアントランダムがファイルに書き込まれるため、コンパイラが警告を発するようになります。
これはテストに役立ちますが、本番環境ではお勧めしません。

#### WOLFSSL_SSLKEYLOGFILE_OUTPUT

このマクロはキーロギングのファイル名を定義します。
`WOLFSSL_SSLKEYLOGFILE`と共に使用してください。

#### WOLFSSL_HAVE_WOLFSCEP

wolfSCEPが利用可能かどうかを確認するためにautoconfで使用される機能を有効にします。

#### WOLFSSL_HAVE_MIN

このマクロはライブラリの移植性を高めるためのもので、MIN/MAXがすでにプラットフォームによって定義されているかどうかを示します。
重複定義を防ぎます。

#### WOLFSSL_HAVE_TLS_UNIQUE

「tls-unique」チャネルバインディングとして使用するために、TLSハンドシェイク後に「Finished」メッセージを保持します。

libest portで追加：アプリケーションが「tls-unique」チャネルバインディングタイプを取得できるようにします。

- [RFC 5929 Section 3](https://tex2e.github.io/rfc-translater/html/rfc5929.html#3--The-tls-unique-Channel-Binding-Type)

これはESTプロトコルで使用され、「所有証明」を通じてTLSセッションに登録をバインドします。

- [RFC 7030 Section 3.4](https://tex2e.github.io/rfc-translater/html/rfc7030.html#3-4--Proof-of-Possession)
- [RFC 7030 Section 3.5](https://tex2e.github.io/rfc-translater/html/rfc7030.html#3-5--Linking-Identity-and-POP-Information)

#### WOLFSSL_ENCRYPTED_KEYS

暗号化キーPKCS8サポートを有効にします。このマクロはPKCS8パスワードベースのキー暗号化を有効にします。

- [RFC 5208](https://tex2e.github.io/rfc-translater/html/rfc5208)

#### WOLFSSL_CUSTOM_OID

サブジェクトおよび要求拡張用のカスタムOIDサポートを有効にする証明書機能です。
これはカスタムOIDを持つ証明書の解析にも適用されます。

#### WOLFSSL_RIPEMD

RIPEMD-160サポートを有効にします。

#### WOLFSSL_SHA384

SHA-384サポートを有効にします。

#### WOLFSSL_SHA512

SHA-512サポートを有効にします。

#### WOLFSSL_AES_DIRECT

AES ECBモードのダイレクトサポートを有効にします。
それ自体ではECBモードは安全とは見なされません。
この機能はPKCS7に必要です。

**警告**：ほぼすべてのユースケースで、ECBモードは安全性が低いと考えられています。可能な限りECB APIを直接使用することは避けてください。

#### DEBUG_WOLFSSL

デバッグ機能を含めてビルドします。
詳細は[第8章 デバッグ](chapter08.md)を参照してください。

#### HAVE_AESCCM

AES-CCMサポートを有効にします。

#### HAVE_AESGCM

AES-GCMサポートを有効にします。

#### WOLFSSL_AES_XTS

AES-XTSサポートを有効にします。

#### HAVE_CAMELLIA

Camelliaサポートを有効にします。

#### HAVE_CHACHA

Chacha20サポートを有効にします。

#### HAVE_POLY1305

Poly1305サポートを有効にします。

#### HAVE_CRL

証明書失効リスト(CRL)サポートを有効にします。

#### HAVE_CRL_IO

CRL URLでインラインHTTPリクエストをブロックできるようにします。
CRLを`WOLFSSL_CTX`にロードし、作成したすべてのwolfSSLオブジェクトに適用します。

#### HAVE_ECC

楕円曲線暗号化(ECC)サポートを有効にします。

#### HAVE_LIBZ

接続上のデータの圧縮を可能にする拡張機能です。
通常、使用すべきではありません。
「ビルドオプション」節にある`--with-libz=PATH`の下のメモを参照してください。

#### OPENSSL_EXTRA

ライブラリにさらに多くのOpenSSL互換性を組み込み、wolfSSL OpenSSL互換性レイヤーを有効にします。
これにより、OpenSSLで動作するように設計された既存のアプリケーションへの移植を容易にします。
デフォルトでオフになっています。

#### HAVE_EXT_CACHE

内部キャッシュの代わりに外部セッションキャッシュを使用するためのサポートを有効にします。

#### WOLFSSL_WPAS_SMALL

WPAサプリカントサポート用の互換性レイヤーの小さなサブセットを有効にします。

#### OPENSSL_ALL

統合テスト用のすべての互換性機能のサポートを有効にします。

#### OPENSSL_COEXIST

OpenSSL互換レイヤーです。
古い名前を無効にする必要があります。
wolfSSLとOpenSSLが共存できるようにするモードです。

#### OPENSSL_VERSION_NUMBER

OpenSSL互換性を実装するバージョン番号を指定します。

#### WOLFSSL_NGINX

OpenSSL互換性をもつアプリケーション固有のマクロです。
`(--enable-nginx) WOLFSSL_NGINX`を使用します。

#### WOLFSSL_ERROR_CODE_OPENSSL

OpenSSL互換性API `wolfSSL_EVP_PKEY_cmp`は成功時に0、失敗時に-1を返します。
この動作はOpenSSLとは異なります。`EVP_PKEY_cmp`は以下を返します。

- 1: 2つのキーが一致する
- 0: 一致しない
- -1: キータイプが異なる
- -2: 操作がサポートされていない

この関数がOpenSSLと同じ動作をするようにしたい場合は、`WS_RETURN_CODE`がOpenSSLと同等の動作に戻り値を変換するように、`WOLFSSL_ERROR_CODE_OPENSSL`を定義してください。

#### WOLFSSL_HARDEN_TLS

[RFC 9325](https://tex2e.github.io/rfc-translater/html/rfc9325)で指定された推奨事項を実装します。
このマクロは、望ましいセキュリティビット数に定義する必要があります。
現在実装されている値は112ビットと128ビットです。
以下のマクロは特定のチェックを無効にします。

- `WOLFSSL_HARDEN_TLS_ALLOW_TRUNCATED_HMAC`
- `WOLFSSL_HARDEN_TLS_ALLOW_OLD_TLS`
- `WOLFSSL_HARDEN_TLS_NO_SCR_CHECK`
- `WOLFSSL_HARDEN_TLS_NO_PKEY_CHECK`
- `WOLFSSL_HARDEN_TLS_ALLOW_ALL_CIPHERSUITES`

#### WOLFSSL_ASIO

OpenSSL互換性をもつアプリケーション固有のマクロです。

#### WOLFSSL_QT

OpenSSL互換性をもつアプリケーション固有のマクロです。
QT用のDH Extra、OpenSSL all、OpenSSH、およびstatic ephemeralを有効にします。

#### WOLFSSL_HAPROXY

OpenSSL互換性をもつアプリケーション固有のマクロです。

#### WOLFSSL_ASN_TEMPLATE

デュアルアルゴリズム証明書機能です。
デフォルトで新しいASNテンプレート`asn.c`コードを使用するため、ASN.1テンプレート機能が必要です。

#### WOLFSSL_ASYNC_IO

非同期クリーンアップで使用されます。

#### WOLFSSL_ATMEL

`atmel_get_random_number`関数を使用してランダムデータをシードするASFフックを有効にします。

#### WOLFSSL_CMAC

追加のCMACアルゴリズムを有効にします。

**注意**：`WOLFSSL_AES_DIRECT`が必要です。

#### WOLFSSL_ESPIDF_ERROR_PAUSE

`test.c`でのみ使用され、テストエラー時にデバッグ目的で遅延を追加します。

#### TEST_IPV6

テストアプリケーションでのIPv6のテストをオンにします。
wolfSSLはIPニュートラルですが、テストアプリケーションはデフォルトでIPv4を使用しています。

#### TEST_NONBLOCK_CERTS

非ブロッキングOCSPレスポンスのテストにのみ使用されます。
`WOLFSSL_NONBLOCK_OCSP`と`OCSP_WANT_READ`で有効になります。

#### TEST_OPENSSL_COEXIST

以下のビルドオプションを有効にする場合に使用します。

```sh
./configure --enable-opensslcoexist
```

#### TEST_PK_PRIVKEY

PKコールバックのテストにのみ使用されます。
`wolfSSL/test.h`ではPKコールバックでロード・使用される実際の秘密鍵を渡すために、コンテキストを使用します。

#### TEST_BUFFER_SIZE

サンプルのクライアント/サーバー`-B`オプションで使用される、TLSベンチマークテストバッファサイズのオーバーライドを可能にします。

#### FORCE_BUFFER_TEST

ファイルシステムを使用する代わりに、`test_certs.h`バッファの使用を強制します。
`wolfSSL/test.h`の内部テストにのみ使用されます。

#### WOLFSSL_FORCE_MALLOC_FAIL_TEST

ランダムなmallocの失敗を誘発するための内部テスト用に定義します。

#### WOLFSSL_POST_HANDSHAKE_AUTH

TLS拡張機能、ポストハンドシェイク認証に使用されます。

#### WOLFSSL_PSK_MULTI_ID_PER_CS

TLS 1.3 PSKにおいて、暗号スイートごとに複数のIDを処理します。

#### WOLFSSL_PUBLIC_ASN

内部で使用されるASN.1 APIを公開します。
これは、内部の`asn.h` APIを使用して解析したいお客様に役立ちます。

#### WOLFSSL_QUIC

QUICプロトコルのサポートを有効にします。
詳細については[こちら](https://github.com/wolfSSL/wolfSSL/blob/master/doc/QUIC.md)を参照してください。

#### WOLFSSL_QUIC_MAX_RECORD_CAPACITY

最大quicキャパシティを1024*1024 -- 1 MBとして定義します。

#### WOLFSSL_RENESAS_FSPSM_TLS

まだサポートしていない、TLS関連機能です。

#### WOLFSSL_RENESAS_TSIP_TLS

TSIP TLSリンク共通鍵暗号化方式のみを無効にするためのものです。

#### WOLFSSL_SM2

SM暗号を使用するために定義します。

#### WOLFSSL_SM3

SM暗号を使用するために定義します。

#### WOLFSSL_SM4

SM暗号を使用するために定義します。

#### WOLFSSL_SM4_CBC

SM4 CBCのSM設定です。

#### WOLFSSL_SM4_CCM

SM4 CCMのSM設定です。

#### WOLFSSL_SM4_GCM

SM4 GCMのSM設定です。

#### WOLFSSL_SNIFFER_CHAIN_INPUT

Chain Inputオプションでは、スニファーが入力を生のパケットへのポインタではなく、`struct iovec`リストとして受け取ることができます。

#### XSLEEP_MS

テストのみに使用されます。
カスタム遅延を定義できます。

#### XSNPRINTF

snprintf関数をオーバーライドできます。

#### DEFAULT_TIMEOUT_SEC

`HAVE_IO_TIMEOUT`と一緒に使用して、`wolfio.c`ソケットタイムアウトを秒単位で指定します。
これはOCSPおよびCRL HTTPの内部ソケットコードで使用されます。

#### HAVE_IO_TIMEOUT

証明書の失効に関するものです。
IOオプションは接続タイムアウトのサポートを有効にしますが、デフォルトではオフです。

#### HAVE_OCSP

オンライン証明書ステータスプロトコル（OCSP）サポートを有効にします。

#### HAVE_CSHARP

C＃ラッパーに必要な構成オプションをオンにします。

#### HAVE_CURVE25519

Curve25519アルゴリズムの使用をオンにします。

#### HAVE_ED25519

ED25519アルゴリズムの使用をオンにします。

#### WOLFSSL_DH_CONST

Diffie Hellman Operationsを実行するときにフローティングポイント値の使用をオフにし、`XPOW()`および`XLOG()`のテーブルを使用します。
外部数学ライブラリへの依存関係を削除します。

#### WOLFSSL_TRUST_PEER_CERT

信頼できるピア証明書の使用をオンにします。
これにより、CA証明書を使用するのではなく、ピア証明書に接続することができます。
信頼できるピア証明書がPeer Certチェーンよりも一致している場合にオンになっていると、ピアが検証されたと見なされます。
CA証明書を使用することが望ましいです。

#### WOLFSSL_STATIC_MEMORY

静的メモリバッファと機能の使用をオンにします。
これにより、動的ではなく静的メモリを使用できます。

#### WOLFSSL_STATIC_MEMORY_LEAN

合わせて、`WOLFSSL_STATIC_MEMORY`の定義が必要です。
65k未満のメモリプールサイズを必要とする構造体に対してより小さい型サイズを使用し、IOバッファなどの使用可能な機能を制限してフットプリントサイズを削減します。

#### WOLFSSL_SESSION_EXPORT

DTLSセッションのエクスポートとインポートの使用をオンにします。
これにより、DTLSセッションの現在の状態をシリアル化および送受信することができます。

#### WOLFSSL_ARMASM

ARMv8ハードウェアアクセラレーションの使用をオンにします。

#### WC_RSA_NONBLOCK

Fast Math RSAノンブロッキングサポートをオンにして、RSA操作をより小さな仕事の塊に分割して処理します。
この機能は、`wc_RsaSetNonBlock()`を呼び出し、`FP_WOULDBLOCK`戻りコードをチェックすることにより有効になります。

#### WC_RSA_BLINDING

タイミング耐性を有効にするために使用されます。

#### WC_RSA_PSS

RSA PSSパディングを有効にします。
TLS 1.3でサポートされる唯一のRSAパディングスキームはPSSです（仕様によるものです）。
PSSパディングはランダムパディングを使用します。

#### WOLFSSL_RSA_VERIFY_ONLY

RSA用の小さなビルドをオンにします。
[`WOLFSSL_RSA_PUBLIC_ONLY`](#wolfSSL_rsa_public_only)、[`WOLFSSL_RSA_VERIFY_INLINE`](#wolfSSL_rsa_verify_inline)、[`NO_SIG_WRAPPER`](#no_sig_wrapper)、[`WOLFCRYPT_ONLY`](#wolfcrypt_only)を定義してください。

#### WOLFSSL_RSA_PUBLIC_ONLY

RSAの公開キーのみの小さなビルドをオンにします。
[`WOLFCRYPT_ONLY`](#wolfcrypt_only)を定義してください。

#### WOLFSSL_SHA3

SHA3使用のビルドをオンにします。
これは、SHA3-224、SHA3-256、SHA3-384、SHA3-512のSHA3 Keccakのサポートです。
さらに、`WOLFSSL_SHA3_SMALL`を使用してパフォーマンスとリソース使用のトレードオフを行うことができます。

#### USE_ECDSA_KEYSZ_HASH_ALGO

エフェメラルECDHE鍵サイズまたは次に使用可能な次の最高値と一致するハッシュアルゴリズムを選択します。
この回避策は、SHA512でハッシュされたP-256鍵などのシナリオを正しくサポートしていないいくつかのピアに関する問題を解決します。

#### WOLFSSL_ALT_CERT_CHAINS

この定義によってCA証明書が通信相手から提示されることを許可しますが、有効なチェーンの一部としては使用しません。
デフォルトのwolfSSLの動作は、提示されたすべてのピア証明書の検証を要求することです。
これにより、中間CA証明書を信頼できるものとして扱い、Root CA証明書まで至るCAの署名エラーは無視されません。
代替の証明書チェーンモードでは、ピア証明書が信頼できるCAに検証する必要があります。

#### WOLFSSL_SYS_CA_CERTS

`wolfSSL_CTX_load_system_CA_certs()`が呼び出されたとき、wolfSSL証明書マネージャーにそれらをロードするか、システム認証APIを呼び出すことで、wolfSSLが検証のためにシステムのCA証明書を使用できるようにします。
詳細は`wolfSSL_CTX_load_system_CA_certs()`を参照してください。
このプリプロセッサマクロは、`--enable-sys-ca-certs`構成オプションによって自動的に設定されます。

#### WOLFSSL_APPLE_NATIVE_CERT_VERIFICATION

TLSピア証明書を認証する際にAppleのネイティブトラストAPIの使用を有効にします。
[WOLFSSL_SYS_CA_CERTS](#WOLFSSL_SYS_CA_CERTS)が定義されている必要があります。
iOSや他のAppleデバイスで`configure`または`CMake`でビルドする場合、このマクロをユーザーが設定する必要はありませんが、macOSでネイティブ検証方法を使用したい場合は明示的に設定する必要があります。

#### WOLFSSL_CUSTOM_CURVES

標準以外の曲線を許可します。計算では、曲線"a"変数が含まれています。`HAVE_ECC_SECPR2`、`HAVE_ECC_SECPR3`、`HAVE_ECC_BRAINPOOL`および`HAVE_ECC_KOBLITZ`を使用して、追加の曲線タイプを有効にできます。

#### HAVE_COMP_KEY

ECC圧縮鍵サポートを有効にします。

#### WOLFSSL_EXTRA_ALERTS

TLS接続中に追加のアラートを送信できるようにします。
この機能は、[`--enable-opensslextra`](#--enable-opensslextra)を使用すると自動的に有効になります。

#### WOLFSSL_DEBUG_TLS

TLS接続中に追加のデバッグプリントアウトを有効にします。

#### HAVE_BLAKE2

Blake2Sアルゴリズムのサポートを有効にします。

#### HAVE_FALLBACK_SCSV

サーバー側でのSignaling Cipher Suite Value(SCSV)サポートを有効にします。
これはクライアントから送信される暗号スイート`0x56 0x00`を処理し、TLSバージョンのダウングレードを許可しないことを示します。

#### HAVE_AEAD

TLS 1.3に必要なAEADを有効にします。

#### HAVE_AES_CBC

AES CBCのオプションを有効にします。

#### HAVE_ALPN

ALPNを有効にします。

#### HAVE_CAVIUM_OCTEON_SYNC

Marvell Cavium/Octeonハードウェアのブロッキング（同期）バージョンを有効にします。

#### HAVE_CERTIFICATE_STATUS_REQUEST

証明書ステータス要求機能としての証明書失効に使用されます。

#### HAVE_CERTIFICATE_STATUS_REQUEST_V2

証明書ステータス要求機能としての証明書失効に使用されます。

#### HAVE_IO_TIMEOUT

証明書失効に関するものです。
IOオプションは接続タイムアウトのサポートを有効にしますが、デフォルトではオフです。

#### HAVE_CURL

cURLとリンクする際、wolfSSLライブラリのサブセットをビルドするために使用されます。

#### HAVE_CURVE448

Curve448サポート用に定義します。
追加のマクロ設定を変更できます。
デフォルトでは共有シークレット、キーのエクスポート、およびインポートが有効になっています。

#### HAVE_DANE

このオプションは`HAVE_RPK`（生の公開鍵）でのみサポートされ、将来追加される可能性がある場合のプレースホルダーです。

#### HAVE_DILITHIUM

DILITHIUM量子暗号化/署名アルゴリズムを含めるために有効にします。

#### HAVE_ED25519_KEY_IMPORT

ED25519の設定です。
署名、検証、共有シークレット、インポート、およびエクスポートの詳細な制御のためにEd255519およびCurve25519オプションを有効にします。

#### HAVE_EX_DATA

CTX/WOLFSSLのユーザー情報用の「追加」EXデータAPIを有効にします。

#### HAVE_EX_DATA_CLEANUP_HOOKS

インデックスでRSAキーに対して追加データとクリーンアップコールバックを設定します。

#### HAVE_FALCON

OpenQuantumSafeからの量子後暗号FALCONを有効にします。

#### HAVE_FIPS

さまざまなFIPSバージョンを実装する際に使用されます。

#### HAVE_KEYING_MATERIAL

[RFC 8446 Section 7.5](https://tex2e.github.io/rfc-translater/html/rfc8446#7-5--Exporters)に基づいてキーイング材料のエクスポートを有効にします。

#### HAVE_OID_DECODING

ASNテンプレートコードに含まれています。
一部のケースでデコードに使用されます。

#### HAVE_MAX_FRAGMENT

最大フラグメントサイズを設定します。
TLS拡張機能です。

#### WOLFSSL_PSK_ONE_ID

TLS 1.3を持つPSK IDを1つだけサポートできます。

#### SHA256_MANY_REGISTERS

すべてのデータをレジスタに保持し、部分的にループを展開するSHA256の処理を指定します。

#### WOLFCRYPT_HAVE_SRP

wolfCryptセキュアリモートパスワードサポートを有効にします。

#### WOLFSSL_MAX_STRENGTH

最強のセキュリティ機能のみを有効にし、弱いまたは廃止予定の機能を無効にします。
タイミングベースのサイドチャネル攻撃から保護するためのコンスタント実行により性能が劣化します。

#### MAX_RECORD_SIZE

最大レコードサイズを決定します。
標準では2^14が最大サイズです。

#### MAX_CERTIFICATE_SZ

証明書メッセージペイロードの最大サイズを定義します。
証明書あたり2KB、`MAX_CHAIN_DEPTH`個の証明書を想定しています。

#### MAX_CHAIN_DEPTH

最大チェーン深度を定義します。

#### MAX_CIPHER_NAME

最大暗号名を定義します。

#### MAX_DATE_SIZE

バイトlastdateまたはバイトnextdateとして使用される日付の最大サイズを定義します。

#### MAX_EARLY_DATA_SZ

最大早期データサイズを定義するために使用されます。

#### WOLFSSL_MAX_SEND_SZ

最大送信サイズを指定するために定義します。

#### WOLFSSL_MAX_SUITE_SZ

最大スイートサイズを指定するために定義します。
小さすぎるとエラーが発生します。

#### MAX_WOLFSSL_FILE_SIZE

4 MBの割り当てサイズ制限があります。

#### WOLFSSL_MAXQ10XX_TLS

maxq10xxに使用しているTLSバージョンを知らせます。

#### WOLFSSL_MAX_SIGALGO

最大署名アルゴリズムをオーバーライドする機能を有効にします。

#### WOLFSSL_MEM_GUARD

指定されたメモリガードを割り当てることができます。

#### WOLFSSL_STATIC_EPHEMERAL

TLSスニファーサポートです

#### SSL_SNIFFER_EXPORTS

WIN32スニファーエクスポートです。

#### WOLFSSL_SNIFFER_KEYLOGFILE

SSLキーログファイルオプションは、スニファーが[NSSキーログファイル](https://web.archive.org/web/20220531072242/https://firefox-source-docs.mozilla.org/security/nss/legacy/key_log_format/index.html)から取得したマスターシークレットを使用してTLSトラフィックを復号化できるようにします。
これにより、スニファーは一時的な暗号スイートを使用するTLS接続でも、すべてのTLSトラフィックを復号化できます。
キーログファイルスニッフィングはTLSバージョン1.2および1.3でサポートされています。

wolfSSLは、スニファー機能とは別に、`--enable-keylog-export`構成オプションを使用してキーログファイルをエクスポートするように構成できます。
（注意：これは本質的に安全ではないため、本番環境では絶対に行わないでください）

キーログファイルのスニファーサポートを有効にするには、以下の構成コマンドラインを使用してビルドします。

```sh
./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_KEYLOGFILE
```

#### WOLFSSL_SNIFFER_STORE_DATA_CB

Store Data Callbackオプションを使用すると、スニファーは再割り当てされたデータポインタではなくカスタムバッファにアプリケーションデータを保存する際に呼び出されるコールバックを取ることができます。
コールバックはすべてのデータが消費されるまでループで呼び出されます。
このオプションを有効にするには、以下の構成コマンドラインを使用してビルドします。

```sh
./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_STORE_DATA_CB
```

#### WOLFSSL_SNIFFER_WATCH

Session Watchingオプションを使用すると、スニファーは初期設定なしで提供された任意のパケットを監視できます。
すべてのTLSセッションのデコードを開始し、サーバーの証明書が検出されると、その証明書はユーザーが提供したコールバック関数に渡され、適切な秘密鍵を提供する必要があります。
このオプションを有効にするには、以下の構成コマンドラインを使用してビルドします。

```sh
./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_WATCH
```

#### STATIC_BUFFER_LEN

レコードヘッダーからメモリをフラグメント化しないでください。
`RECORD_HEADER_SZ`に展開します。

#### STATIC_CHUNKS_ONLY

ユーザーは、小さな静的バッファを使用している場合（デフォルト）に16K出力オプションをオフにするオプションがあり、SSL_writeが持っているレコードよりも大きなデータを書き込もうとすると、ユーザーが静的バッファチャンクでのみ書き込むように指示しない限り、動的に取得します。

#### WOLFSSL_DEF_PSK_CIPHER

ユーザー定義のPSK暗号を有効にします。

#### WOLFSSL_OLD_PRIME_CHECK

より高速なDHとRSAの素数チェックを使用する機能を有効にします。

#### WOLFSSL_STATIC_RSA

静的暗号スイートのみをサポートするレガシーシステム向けに残されています。
静的な鍵を使用する暗号は強く非推奨とされており、避けられない場合以外は決して使用しないでください。
[`WOLFSSL_STATIC_PSK`](#wolfSSL_static_psk)および[`WOLFSSL_STATIC_DH`](#wolfSSL_static_dh)も参照してください。

#### WOLFSSL_STATIC_PSK

静的な鍵を使用する暗号は非推奨とされています。
[`WOLFSSL_STATIC_RSA`](#wolfSSL_static_rsa)を参照してください。

#### WOLFSSL_STATIC_DH

静的な鍵を使用する暗号は非推奨とされています。
[`WOLFSSL_STATIC_RSA`](#wolfSSL_static_rsa)を参照してください。

#### HAVE_NULL_CIPHER

NULL暗号のサポートをオンにします。
このオプションはセキュリティの観点から強く非推奨ですが、稀に暗号化/復号化操作を実行するには小さすぎるシステムがあります。
そのようなシステムでも、このマクロを有効化して少なくともメッセージやピアを認証し、メッセージの改ざんを防ぐことだけができます。

#### HAVE_ANON

匿名の暗号スイートのサポートをオンにします。
推奨されませんが、インターネットから切り離された、またはプライベートネットワークに関連するいくつかの有効なユースケースがあります。

#### HAVE_LIBOQS

OpenQuantumSafeチームのLiboQS統合のサポートをオンにします。
詳細は[付録G ポスト量子暗号の実験](appendix07.md)を参照してください。

#### WOLFSSL_SP_4096

RSA/DH 4096ビット単精度(SP)サポートを有効にします。

#### WOLFSSL_SP_384

ECC SECP384R1単精度(SP)サポートを有効にします。
`WOLFSSL_SP_MATH`にのみ適用されます。

#### WOLFSSL_SP_1024

Sakkeペアリングベースの単精度(SP)サポートを有効にします。

#### ATOMIC_USER

アトミックレコードレイヤーコールバックを有効にします。

#### BIG_ENDIAN_ORDER

デフォルトはリトルエンディアンです。
このマクロを定義することで、ビッグエンディアン環境で動作できます。

#### WOLFSSL_32BIT_MILLI_TIME

関数`TimeNowInMilliseconds()`は符号なし32ビット値を返します。
デフォルトの動作は符号付き64ビット値を返すことです。

#### WOLFSSL_MAX_DHKEY_BITS

DH最大ビットサイズは8の倍数でなければなりません。
DH最大ビットサイズは16384を超えたり、`WOLFSSL_MIN_DHKEY_BITS`より大きくすることはできません。

#### WOLFSSL_MIN_DHKEY_BITS

DH最小ビットサイズは8の倍数でなければなりません。
112ビットのセキュリティでは、DHは少なくとも2048ビットのキーが必要であり、最小ビットサイズは16000を超えてはなりません。

#### WOLFSSL_MAX_MTU

最大予想MTUです。
1500 - 100バイトで、UDPとIPヘッダーを考慮しています。

#### IGNORE_NETSCAPE_CERT_TYPE

ネットスケープ証明書タイプを入力する場所を確保するために定義します。

#### SESSION_CERTS

証明書用のTLSセッションキャッシュです。

#### WOLFSSL_DUAL_ALG_CERTS

デュアルアルゴリズム証明書の必須機能です。

#### CRL_MAX_REVOKED_CERTS

RevokedCertsを保持するバッファの数を指定します。
デフォルト値は4に設定されています。

#### CRL_STATIC_REVOKED_LIST

バイナリ検索を可能にするRevokedCertsの固定静的リストを有効にします。

#### SESSION_INDEX

キャッシュ内のセッションの場所を識別します。
インデックスセッション/行シフトを指定します。

#### SESSION_TICKET_HINT_DEFAULT

チケットヒントのデフォルトは、デフォルトのヒント値を設定するために使用されます。
チケットキーの寿命はチケットのライフヒントよりも長くなければなりません。

#### WOLFSSL_DTLS13

wolfSSL DTLS 1.3を有効にします。

#### WOLFSSL_TLS13

TLS 1.3プロトコル実装を有効にします。

#### WOLFSSL_TLS13_IGNORE_AEAD_LIMITS

[RFC 9147 Section 4.5.3](https://tex2e.github.io/rfc-translater/html/rfc9147#4-5-3--AEAD-Limits) に示された制限です。
鍵更新が必要な制限を、ハードな復号化失敗制限の中間地点として指定しています。

#### WOLFSSL_TLS13_MIDDLEBOX_COMPAT

TLS 1.3ハンドシェイクでミドルボックス互換性を有効にします。
これには、暗号化されたメッセージの前にChangeCipherSpecを送信することとセッションIDを含めることが含まれます。

#### WOLFSSL_TLS13_SHA512

ハンドシェイクでのSHA-512ダイジェストの生成を許可します。
ただし、現時点ではどの暗号スイートもSHA-512を必要としません。
これにより、TLS v1.3ではまだ使用されていませんが、ハンドシェイクメッセージのSHA2-512ハッシュの計算が可能になります。

#### WOLFSSL_UIP

CONTIKIが定義されている場合、これはUIPの実装です。

#### TLS13_MAX_TICKET_AGE

最大チケット期間を指定します。
TLS 1.3の場合、これは7日間です。

#### TLS13_TICKET_NONCE_STATIC_SZ

`TLS13_TICKET_NONCE_STATIC_SZ`はこの`FIPS_VERSION_GE`ではサポートされていません。

#### TLS13_TICKET_NONCE_MAX_SZ

チケットナンス用のバージョン最大サイズを定義します。
最大サイズは255バイトとして定義されています。

#### WOLFSSL_TICKET_ENC_AES128_GCM

デフォルトコールバックでセッションチケットの暗号化/復号化にAES128-GCMを使用します。
これはサーバーのみで適用されます。
ChaCha20/Poly1305がコンパイルされていない場合、これがデフォルトのアルゴリズムです。

#### WOLFSSL_TICKET_ENC_AES256_GCM

デフォルトコールバックでセッションチケットの暗号化/復号化にAES256-GCMを使用します。
これはサーバーのみで適用されます。

#### WOLFSSL_TICKET_ENC_CHACHA20_POLY1305

デフォルトコールバックでセッションチケットの暗号化/復号化にChaCha20-Poly1305を使用します。
何も定義されていない場合、デフォルトのアルゴリズムが使用され、アルゴリズムがコンパイルされます。
これはサーバーのみで適用されます。

#### WOLFSSL_TICKET_EXTRA_PADDING_SZ

チケットの追加パディングサイズを32として定義します。

#### WOLFSSL_TICKET_HAVE_ID

チケットにIDがあることを確認するために使用します。
サポートが組み込まれていて、チケットにIDが含まれている場合にのみキャッシュに追加します。
そうでなければ、キャッシュからチケットを取得する方法がありません。

#### WOLFSSL_TICKET_KEY_LIFETIME

デフォルトの寿命は、キーを使用した最初のチケットの発行から1時間です。
これはヒントよりも長くなければなりません。

#### WOLFSSL_TICKET_NONCE_MALLOC

チケットナンスの動的割り当てを有効にします。
HKDF展開コールバックを無効にする必要があります。

#### SHOW_CERTS

定義されている場合、証明書を表示します。
組み込みデバッグに使用します。

#### SHOW_SECRETS

デバッグに使用されます。
適用可能なシークレットを表示します。

#### DEBUG_UNIT_TEST_CERTS

名前制約テストをデバッグする際に使用されます。
複雑な定義ガードを持つ複数の場所で使用できるように静的ではありません。

#### DEBUG_WOLFSSL_VERBOSE

`OPENSSL_EXTRA`または`DEBUG_WOLFSSL_VERBOSE`マクロを使用する場合、`WOLFSSL_ERROR`は新しい関数`WOLFSSL_ERROR_LINE`にマップされ、`WOLFSSL_ERROR`が呼び出される行番号と関数名を取得します。

#### SOCKET_INVALID

無効なソケットを定義するために使用され、`-1`として定義されています。

#### WOLFSSL_SOCKET_INVALID

テストに使用され、無効なソケットを示すために使用される値のオーバーライドのみを許可します。
通常は`-1`です。

#### WOLFSSL_SOCKET_IS_INVALID

ソケット処理で使用されます。

#### WOLFSSL_SRTP

SRTPをアクティブにするために使用されます。

#### WOLFSSL_CIPHER_CHECK_SZ

暗号化操作が機能したことを確認するために64ビットが必要な暗号チェックサイズとして定義されています。

#### DTLS_CID_MAX_SIZE

DTLS 1.3パーシングコードは、レコードを復号化するために静的バッファにレコードヘッダーをコピーします。
CID最大サイズを増やすと、このバッファも増加し、セッションごとの実行時メモリフットプリントに影響します。
DTLS CIDの最大サイズは255バイトです。

#### DTLS13_EPOCH_SIZE

DTLS 1.3エポックを使用した、移植性を高めるためのマクロです。
DTLSエポックにバインドされた鍵を保存し、必要に応じて適切な鍵/エポックを設定する方法を実装します。

#### DTLS13_RETRANS_RN_SIZE

DTLS 1.3における移植性を高めるためのマクロです。
DTLS 1.3で再送信前のサイズを識別するために使用されます。

#### WOLFSSL_DTLS_FRAG_POOL_SZ

指定された時間あたりに許可されるフラグメントの数を定義します。

#### WOLFSSL_CLIENT_SESSION_DEFINED

APIが使用する不透明な構造体を宣言します。

#### WOLFSSL_COND

このシステムがCOND_TYPEシグナリングをサポートしている場合に定義されます。
シグナリングAPIに渡されるべきタイプです。

#### WOLFSSL_DTLS_CH_FRAG

サーバーがフラグメント化された2番目/検証済み（有効なクッキー応答を含む）ClientHelloメッセージを処理できるようにします。
1番目/未検証（クッキー拡張を含まない）ClientHelloはフラグメント化されていてはならず、DTLSサーバーがステートレスに処理できるようにする必要があります。
これはDTLS 1.3でのみ実装されています。
ユーザーは、実行時にこれを明示的に有効にするために、サーバーで`wolfSSL_dtls13_allow_ch_frag()`を呼び出す必要があります。

**注意**：DTLS 1.3 + pqcを`WOLFSSL_DTLS_CH_FRAG`なしで使用すると、おそらく失敗します。この場合、`--enable-dtls-frag-ch`を使用して有効にします。

#### WOLFSSL_DTLS_MTU_ADDITIONAL_READ_BUFFER

私たちとは少し異なるMTUを持つピアと連携できるように、追加のバイトを読み取る必要がある場合に使用します。

#### WOLFSSL_DTLS_WINDOW_WORDS

ウィンドウのストレージサイズをチェックするか、インデックスがウィンドウに対して有効かどうかを確認するために使用されます。

#### WOLFSSL_EXPORT_SPC_SZ

CipherSpecsから使用されるバイト数を指定するために定義します。

#### WOLFSSL_MIN_DOWNGRADE

最小ダウングレードバージョンを指定します。

#### WOLFSSL_MIN_DTLS_DOWNGRADE

最小DTLSダウングレードバージョンを指定します。

#### WOLFSSL_MIN_ECC_BITS

許可されるECCキーサイズの最小値を設定できます。

#### WOLFSSL_MIN_RSA_BITS

デフォルトでは、wolfSSLはRSAキーサイズを最小1024ビットに制限しています。
512ビットキーなどの小さく安全性の低いRSAキーのデコードを許可するには、コンパイラフラグ`-DWOLFSSL_MIN_RSA_BITS=512`をCFLAGSまたはCPPFLAGSに追加するか、ユーザー設定ヘッダーで定義する必要があります。

#### WOLFSSL_MODE_AUTO_RETRY_ATTEMPTS

無限リトライループの可能性を制限するために使用されます。

#### WOLFSSL_MULTICAST

DTLSマルチキャスト機能です。

#### WOLFSSL_MULTICAST_PEERS

最大許容100ピアとして定義されたマルチキャスト機能です。

#### WOLFSSL_NAMES_STATIC

Position Independent Code（PIC）のための静的ECC構造体を使用します。

#### WOLFSSL_SEND_HRR_COOKIE

DTLS 1.3で使用されるTLS拡張機能です。

#### WOLFSSL_SEP

機能証明書ポリシーセット拡張です。

#### WOLFSSL_SESSION_ID_CTX

アプリケーションセッションコンテキストIDをコピーするために使用されます。

#### WOLFSSL_SESSION_TIMEOUT

秒単位のデフォルトセッション再開キャッシュタイムアウトは、タイムアウトを手動で定義するために使用されます。

#### KEEP_OUR_CERT

SSL証明書を返す能力を確保するために使用されます。

#### KEEP_PEER_CERT

ピア証明書を保持します。
OpenSSL互換性レイヤーの一部はピア証明書を必要とします。

#### WOLFSSL_SIGNER_DER_CERT

これは署名に使用されるDER/ASN.1の保持を可能にします。
これは`wolfSSL_X509_STORE_get1_certs`など、互換性レイヤーで使用されます。

#### CA_TABLE_SIZE

wolfSSL証明書マネージャー署名者テーブルで使用されます。
デフォルトの`CA_TABLE_SIZE`は11ですが、実際のニーズに基づいて調整できます。
各`WOLFSSL_CTX`には独自の証明書マネージャー（CM）があります。

#### ECDHE_SIZE

コンパイル時にこれをオーバーライドできるようにするために定義します。
ECDHEサーバーサイズはデフォルトで256ビットであり、これは事前に決められたECDHE曲線サイズを設定できます。
デフォルトは32バイトです。

#### CIPHER_NONCE

認証に実装される暗号化番号として使用されます。
これは擬似乱数であり、整合性のみの暗号スイートです。

#### WOLFSSL_USE_POPEN_HOST

wolfio.cソケットオープンコードでホストとポストでソケットを作成するためにpopenを使用します。
CRLとOCSPで使用されます。

#### CloseSocket

ソケットを閉じるために使用される関数をオーバーライドする方法です。
CRL、OCSP、BIOで使用されます。

#### CONFIG_POSIX_API

ネットワーキングシステムコール用のPOSIX名を有効にします。

#### WOLFSSL_USER_CURRTIME

マクロ`WOLFSSL_USER_CURRTIME`を使用してgettimedayなしで`test.h`で使用するオプションを追加します。

#### WOLFSSL_USER_MUTEX

ユーザー定義ミューテックスのオプションです。

#### DEFAULT_MIN_ECCKEY_BITS

ECCkeyの最小ビット数を識別します。

#### DEFAULT_MIN_RSAKEY_BITS

RSAキーの最小ビット数を識別します。

#### EXTERNAL_SERIAL_SIZE

バッファに符号なしバイナリでX509シリアル番号を書き込む生のシリアル番号バイトです。
すべての場合において、バッファは少なくとも`EXTERNAL_SERIAL_SIZE`（32）である必要があります。
成功した場合、`WOLFSSL_SUCCESS`を返します。

**注意**：これはユーザーが定義できない内部マクロです。

#### LARGE_STATIC_BUFFERS

組み込みコールバックには大きな静的バッファが必要です。
16Kまでの大きなバッファを有効にするオプションを提供してください。

#### LIBWOLFSSL_VERSION_STRING

これはwolfSSLバージョン文字列であり、リリースバンドルまたは`./configure`が実行されたときに入力されます。
また、`LIBWOLFSSL_VERSION_HEX`にはこの32ビットHEXバージョンもあります。
これらは`wolfSSL/version.h`から来ています。

### wolfSSLのカスタマイズ及び移植

#### WOLFSSL_USER_SETTINGS

定義されている場合、ユーザー固有の設定ファイルを使用できます。
ファイルには`user_settings.h`と名前が付けられ、インクルートパスに存在する必要があります。
これは、標準の`settings.h`ファイルの前に含まれるため、デフォルト設定をオーバーライドできます。

#### WOLFSSL_CALLBACKS

デバッガがない環境でシグナルを使用するデバック用のコールバックの利用を可能にする拡張機能です。
デフォルトではオフです。
ブロッキングソケットを使用してタイマーを設定するためにも使用できます。
詳しくは[第6章 コールバック](chapter06.md)をご覧ください。

#### WOLF_CRYPTO_CB

暗号コールバックサポートを有効にします。
この機能は、[`--enable-cryptocb`](#enable-cryptocb)を使用すると自動的に有効になります。

#### WOLFSSL_DYN_CERT

`WOLFSSL_NO_MALLOC`が設定されていても、証明書を解析するときに `subjectCN` および `publicKey` フィールドの割り当てを許可します。 
RSA証明書で`WOLFSSL_NO_MALLOC`オプションを使用する場合、ピアの証明書で証明書を検証するために、CAの公開鍵を保持する必要があります。
`ca->publicKey`がNULL であるため、これはConfirmSignatureエラー -173 BAD_FUNC_ARG として表示されます。

#### WOLFSSL_USER_IO

ユーザーがデフォルトのI/O関数[`EmbedSend()`](wolfio_8h.md#function-embedsend)および[`EmbedReceive()`](wolfio_8h.md#function-embedrecieve)の自動設定を削除できます。
カスタムI/O抽象化レイヤに使用されます(詳細については[第5章](chapter05.md)「抽象化レイヤー」節を参照)。

#### NO_FILESYSTEM

stdio(標準入出力関数)が使用できないために、証明書とキーファイルをロードできない場合に使用されます。
これにより、ファイルの代わりにバッファを使用できます。

#### NO_INLINE

頻繁に使用されるライン数の少ない関数の自動インライン化を無効にします。
この定義により、wolfSSLが遅くなり、実際にはこれらが小さな関数であるため、通常は関数呼び出し/ Returnよりもはるかに小さくなります。
autoconfを使用していない場合は、コンパイル済みファイルのリストに`wolfcrypt/src/misc.c`を追加する必要があります。

#### NO_DEV_RANDOM

デフォルトの`/dev/random`乱数ジェネレーターの使用を無効にします。
定義されている場合、ユーザーはOS固有の`GenerateSeed()`関数(`wolfcrypt/src/random.c`で見つかった)を記述する必要があります。

#### NO_MAIN_DRIVER

通常のビルド環境で使用されて、テストアプリケーションが独自に呼び出されるか、テストスイートドライバーアプリケーションを介して呼び出されます。
`test.c`、`client.c`、`server.c`、`echoclient.c`、`echoserver.c`、および`testsuite.c`でテストファイルで使用する必要があります。

#### NO_WRITEV

`writev()`セマンティクスのシミュレーションを無効にします。

#### SINGLE_THREADED

ミューテックスの使用をオフにします。
wolfSSLは現在、セッションキャッシュの保護にのみ使用しています。
wolfSSLの使用が常に単一スレッドからに限定されている場合は、この機能をオンにすることができます。

#### USER_TICKS

time(0)の使用が可能でない場合、ユーザーは自分のクロックチェック関数を定義できます。
カスタム機能には秒単位の正確さが必要ですが、エポックと相関がある必要はありません。
`wolfSSL_int.c`の機能を参照してください。

#### USER_TIME

ユーザーが自身で定義した構造体を使用する(または必要とする)場合のtime.h構造体の使用を無効にします。
実装の詳細については`wolfcrypt/src/asn.c`を参照してください。
ユーザーは`XTIME()`,`XGMTIME()`、および`XVALIDATE_DATE()`を定義および/または実装する必要があります。

#### USE_CERT_BUFFERS_256

`<wolfSSL_root>/wolfSSL/certs_test.h`にある256ビットのテスト用証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_1024

`<wolfSSL_root>/wolfSSL/certs_test.h`にある1024ビットのテスト用証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_2048

`<wolfSSL_root>/wolfSSL/certs_test.h`にある2048ビットテスト証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_3072

`<wolfSSL_root>/wolfSSL/certs_test.h`にある3072ビットのテスト用証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_4096

`<wolfSSL_root>/wolfSSL/certs_test.h`にある4096ビットのテスト用証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_25519

`<wolfSSL_root>/wolfSSL/certs_test.h`にあるEd25519のテスト用証明書と鍵バッファを有効にします。ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_WOLFSSL_IO

このマクロはsend/recvコールバックを有効にします。
使用例は[こちら](https://github.com/wolfSSL/wolfSSL-examples/blob/master/tls/client-tls-callback.c#L6)で見ることができます。

#### CUSTOM_RAND_GENERATE_SEED

ユーザーが`wc_GenerateSeed(byte* output, word32 sz)`に相当するカスタム機能を定義できるようにします。

#### CUSTOM_RAND_GENERATE_BLOCK

ユーザーがカスタム乱数生成機能を定義できるようにします。
使用例は以下の通りです。

```sh
./configure --disable-hashdrbg
CFLAGS="-DCUSTOM_RAND_GENERATE_BLOCK= custom_rand_generate_block"
```

```c
/* RNG */
/* #define HAVE_HASHDRBG */
extern int custom_rand_generate_block(unsigned char* output, unsigned int sz);
```

#### NO_PUBLIC_GCM_SET_IV

独自のカスタムハードウェアポートを作成していて、[`wc_AesGcmSetIV()`](group__AES.md#function-wc_aesgcmsetiv)の公開実装が提供されていない場合は、これを使用してください。

#### NO_PUBLIC_CCM_SET_NONCE

独自のカスタムハードウェアポートを作成していて、`wc_AesGcmSetNonce()`の公開実装が提供されていない場合は、これを使用してください。

#### NO_GCM_ENCRYPT_EXTRA

独自のカスタムハードウェアポートを行っていて、`wc_AesGcmEncrypt_ex()`の実装が提供されていない場合は、これを使用してください。

#### WOLFSSL_STM32[F1 | F2 | F4 | F7 | L4]

適切なSTM32デバイス用にビルドするときにこれらの定義のいずれかを使用します。
必要に応じて、[wolfSSLポーティングガイド](https://www.wolfssl.com/documentation/manuals/jp/wolfssl-porting-guide/)を確認し`wolfSSL-root/wolfSSL/wolfcrypt/settings.h`を更新します。

#### WOLFSSL_STM32_CUBEMX

Cubemxツールを使用してハードウェア抽象化レイヤー(HAL)APIを生成する場合、この設定を使用してwolfSSLに適切なサポートを追加します。

#### WOLFSSL_CUBEMX_USE_LL

Cubemxツールを使用してAPIを生成する場合、HAL(ハードウェア抽象化層)または低層(LL)の2つのオプションがあります。
この定義を使用して、`WOLFSSL_STM32[F1/F2/F4/F7/L4]`の`wolfSSL-root/wolfSSL/wolfcrypt/settings.h`に含まれるヘッダーを制御します。

#### NO_STM32_CRYPTO

STM32のハードウェア暗号サポートを提供しない場合に定義します。

#### NO_STM32_HASH

STM32のハードウェアハッシュサポートを提供しない場合に定義します。

#### NO_STM32_RNG

STM32のハードウェアRNGサポートを提供しない場合のためにに定義します。

#### XTIME_MS

TLS 1.3を使用するときに使用するための関数をミリ秒単位でマッピングするためのマクロです。

使用例

```c
extern time_t m2mb_xtime_ms(time_t * timer);
#define XTIME_MS(tl) m2mb_xtime_ms((tl))
```

#### WOLFSSL_CIPHER_TEXT_CHECK

TLS接続中のAES暗号化操作に対する可能なグリッチ攻撃をチェックするためにこれを定義します。

#### RTTHREAD

RT-THREADマクロは、rtthread IoTをwolfSSLにポーティングする際に使用されます。

#### SO_REUSEPORT

ローカルアドレスとポートの再利用を許可します。

#### INTIME_RTOS

INtime RTOS用のポート設定です。

#### WOLFSSL_SGX

SGXへのポーティング時に使用します。

### メモリまたはコードの使用量の削減

#### TFM_TIMING_RESISTANT

スタックサイズが小さいシステムでFast Math([`USE_FAST_MATH`](#use_fast_math))を使用するときに定義できます。
これにより大きな静的配列が削除されます。

#### ECC_TIMING_RESISTANT

サイドチャネルと差分電力分析（DPA）攻撃を防ぐために`ecc.c`でコードを有効にするタイミング耐性機能として使用されます。

#### FUSION_RTOS

Fusion RTOS実装は、チケットが最初に見られた時と送信された時の違いを表すために使用されます。
32ビット値としてミリ秒単位の時間を返します。

#### WOLFSSL_SMALL_STACK

スタックサイズが小さいデバイスに使用できます。
これにより、`wolfcrypt/src/integer.c`の動的メモリの使用が増加しますが、パフォーマンスが遅くなる可能性があります。

#### ALT_ECC_SIZE

Fast MathとRSA/DHを使用する場合は、ECCメモリ消費量を削減するためにこれを定義できます。
ECCポイントにスタックを使用する代わりに、ヒープから割り当てます。

#### ECC_SHAMIR

ECC Mathのバリエーションは、わずかに高速ですが、ヒープの使用量を2倍にします。

#### RSA_LOW_MEM

定義された場合、CRTは使用されていないため、一部のメモリを保存しますが、RSA操作を遅くします。
デフォルトではオフになっています。

#### WOLFSSL_SHA3_SMALL

SHA3を有効の場合、このマクロはビルドサイズを縮小します。

#### WOLFSSL_SMALL_CERT_VERIFY

DecodedCertを使用せずに証明書署名を確認します。
一部のコードでは2倍になりますが、ピークヒープメモリの使用が小さくなります。
[`WOLFSSL_NONBLOCK_OCSP`](#wolfSSL_nonblock_ocsp)では使用できません。

#### GCM_SMALL

テーブルを使用する代わりに実行時に計算することで、AES GCMコードサイズを減らすオプションです。
可能なオプションは、`GCM_SMALL`,`GCM_WORD32`,`GCM_TABLE`です。

#### CURVED25519_SMALL

[`CURVE25519_SMALL`](#curve25519_small)および[`ED25519_SMALL`](#ed25519_small)を定義します。

#### CURVE25519_SMALL

CURVE25519のスモールメモリオプションです。
これはより少ないメモリを使用しますが、遅いです。

#### ED25519_SMALL

ED25519のスモールメモリオプションです
これはより少ないメモリを使用しますが、遅いです。

#### USE_SLOW_SHA

ローリングループを使用しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。

#### USE_SLOW_SHA256

ローリングループを使用しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。
約2k小さくできますが、約25％遅くなります。

#### USE_SLOW_SHA512

ローリングループを使用しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。
2倍以上小さくできますが、50％が遅くなります。

#### ECC_USER_CURVES

ユーザーが有効になっているECCカーブサイズを選択できるようにします。
デフォルトでは256ビットカーブのみが有効になっています。
他の曲線を使用できるようにするには、`HAVE_ECC192`,`HAVE_ECC224`などを使用します。

#### WOLFSSL_SP_NO_MALLOC

SPコードでは常にStackを使用して、Heap `xmalloc()`/`xrealloc()`/`xfree()`呼び出しは行われません。

#### WOLFSSL_SP_NO_DYN_STACK

動的スタックアイテムの使用を無効にします。
コードサイズが小さく、小さなスタックではなく使用されます。

#### WOLFSSL_SP_FAST_MODEXP

コードサイズを犠牲にして、より高速な`mod_exp`実装でコンパイルします。

#### WC_DISABLE_RADIX_ZERO_PAD

16進文字列出力で先頭ゼロの印刷を無効にします。

例えば、値8は通常「0x08」と表示されますが、このマクロが定義されている場合、「0x8」と表示されます。
このマクロを定義すると、コードサイズを削減できます。

#### WC_ASN_NAME_MAX

X.509証明書フィールドの最大名前サポートのオーバーライドを許可します。

#### OPENSSL_EXTRA_X509_SMALL

証明書用の特別な小さなOpenSSL互換レイヤーです。

### パフォーマンスを向上させる

#### USE_INTEL_SPEEDUP

AES、Chacha20、Poly1305、SHA256、SHA512、Ed25519およびCurve25519の加速にIntelのAVX/AVX2命令を使用できます。

#### WOLFSSL_AESNI

IntelとAMDチップセットに組み込まれているAESアクセラレーション操作を使用できます。
この定義を使用する場合、`aes_asm.asm`(AT＆T構文を備えたWindows用)または`aes_asm.S`ファイルは、Intel AESの新しい命令セット(AESNI)を介して最適化するために使用されます。

#### HAVE_INTEL_RDSEED

DRBGシードソース用のIntelのRDSEEDを有効にします。

#### HAVE_INTEL_RDRAND

wolfsSLのランダムソースのIntelのRDRAND命令を有効にします。

#### FP_ECC

ECC固定点キャッシュを有効にします。
これにより、同じ秘密鍵に対する繰り返し操作が高速化されます。
`FP_ENTRIES`および`FP_LUT`を使用してエントリとLUTビットの数を定義して、デフォルトの静的メモリ使用量を削減することもできます。

#### WOLFSSL_ASYNC_CRYPT

これにより、Intel QuickAssistやMarvell(Cavium)Nitrox Vなどのハードウェアベースのアダプターを使用した非同期暗号化のサポートが可能になります。
非同期コードは公開コードに含まれていません。評価のために必要でしたら、 [info@wolfssl.jp](mailto:info@wolfssl.jp) までお問い合わせください。

#### WOLFSSL_NO_ASYNC_IO

これは非同期I/Oネットワーキングを無効にします。
非同期I/Oはデフォルトでオンになっており、ハンドシェイキングプロセス中に最大約140バイトを占めることがあります。
ネットワークインターフェースが書き込み時に`SOCKET_EWOULDBLOCK`または`SOCKET_EAGAIN`（またはカスタムI/Oコールバックの場合は`WOLFSSL_CBIO_ERR_WANT_WRITE`）を返さない場合、`WOLFSSL_NO_ASYNC_IO`を定義して、wolfSSLがハンドシェイクメッセージを構築している間に状態を保存しないようにできます。

### GCMパフォーマンスチューニング

GCMパフォーマンスには4つのバリエーションがあります。

* `GCM_SMALL`  - 最小のフットプリント、最も遅い(FIPS検証済み)
* `GCM_WORD32` - 中程度(FIPS検証済み)
* `GCM_TABLE`  -  高速(FIPS検証済み)
* `GCM_TABLE_4BIT`  - 最速(FIPS検証済み)

### wolfSSLの数学ライブラリオプション

wolfSSLには3つの数学ライブラリがあります。

* Big Integer
* Fast Math
* Single Precision Math

wolfSSLをビルドするときは、これらの1つだけを使用する必要があります。

Big Integer Libraryは最も移植性の高いオプションで、アセンブリなしでC言語で書かれています。そのため、特定のアーキテクチャに最適化されていません。すべての数学変数はヒープ上でインスタンス化されます。スタック使用量は最小限です。残念ながら、Big Integer Libraryはタイミング耐性がありません。

Fast Math Libraryは良いオプションです。Cとアセンブリの両方を使用して実装されています。そのため、特定のアーキテクチャに最適化されています。すべての数学変数はスタック上でインスタンス化されます。ヒープ使用量は最小限です。`TFM_TIMING_RESISTANT`マクロが定義されている場合、タイミング耐性を持たせることができます。このライブラリはFIPS 140-2および140-3認証を取得しています。

Single Precision (SP) Math Libraryは推奨ライブラリです。Cとアセンブリの両方を使用して実装されています。そのため、特定のアーキテクチャに最適化されています。すべての数学変数はスタック上でインスタンス化されます。ヒープ使用量は最小限です。常にタイミング耐性があります。一般的にはコードサイズを犠牲にして速度が最適化されていますが、不要なコードをコンパイルしないように高度に構成可能です。このライブラリはDO-178C認証を取得しています。

#### Big Integer ライブラリ (廃止予定)

このライブラリは2023年末までにwolfSSL/wolfCryptライブラリから廃止および削除される予定です。必要に応じて、`--enable-heapmath`または`CFLAGS=-DUSE_INTEGER_HEAP_MATH`で有効にすることができます。

パブリックドメインのLibTomMathライブラリからフォークされました。LibTomMathの詳細については、<https://www.libtom.net/LibTomMath/>を参照してください。私たちのフォークは元のパブリックドメインコードよりもかなり活発でセキュアであることに注意してください。

これは一般的に最も移植性が高く、使い始めるのが最も簡単です。通常のbig integerライブラリのマイナス点は、より遅く、すべてのメモリがヒープから割り当てられるため多くのヒープメモリを使用し、`XREALLOC()`実装を必要とし、タイミング耐性がないことです。実装は`integer.c`にあります。

#### Fast Math

##### USE_FAST_MATH

パブリックドメインのLibTomFastMathライブラリからフォークされました。
LibTomFastMathの詳細については、<https://www.libtom.net/TomsFastMath>を参照してください。
私たちのフォークは元のLibTomFastMathのパブリックドメインコードよりもかなり活発でセキュアであることに注意してください。
私たちはパフォーマンス、セキュリティ、コード品質を向上させました。
また、FastMathコードはFIPS 140-2および140-3認証を取得しています。

FastMathライブラリは可能であればアセンブリを使用し、RSA、DH、DSAなどの非対称秘密/公開鍵操作を高速化します。
アセンブリの組み込みはコンパイラとプロセッサの組み合わせに依存します。
一部の組み合わせでは追加の構成フラグが必要になり、一部は不可能な場合もあります。
新しいアセンブリルーチンでFastMathを最適化するための支援はコンサルティングベースで利用可能です。
アーキテクチャ固有の最適化を参照してください。

FastMathでは、すべてのメモリはスタック上に割り当てられます。
FastMathを使用する場合、スタックメモリの使用量が大きくなる可能性があるため、このオプションを使用する場合は[`TFM_TIMING_RESISTANT`](#tfm_timing_resistant)も定義することをお勧めします。
TFM_TIMING_RESISTANTが定義されている場合、FastMathコードはタイミング耐性があります。
これにより、一定時間のための大きな数学ウィンドウが減少し、メモリ使用量が少なくなります。
秘密鍵操作中にショートカットが少なく、したがって分岐が少ないため、スタックの使用量が少なくなります。
これにより、タイミング攻撃が実際の脅威であり、悪意のある第三者に秘密鍵を複製するのに十分な情報を与える可能性があるため、実装がより安全になります。

例えば、ia32では、すべてのレジスタが利用可能である必要があるため、高い最適化とフレームポインタの省略に注意する必要があります。
wolfSSLはデバッグビルド以外ではGCCに`-O3 -fomit-frame-pointer`を追加します。
異なるコンパイラを使用している場合は、これらを構成中に手動で`CFLAGS`に追加する必要があるかもしれません。

macOSでは、`CFLAGS`に`-mdynamic-no-pic`も追加する必要があります。
さらに、OS Xでia32の共有モードでビルドしている場合は、`LDFLAGS`にもオプションを渡す必要があります。

```sh
LDFLAGS="-Wl,-read_only_relocs,warning"
```

これにより、一部のシンボルに対してエラーではなく警告が表示されます。

FastMathは動的およびスタックメモリの使用方法も変更します。
通常の数学ライブラリは大きな整数に動的メモリを使用します。
FastMathはデフォルトで4096ビットの整数を保持する固定サイズのバッファを使用し、2048ビットで2048ビットの乗算を可能にします。
4096ビットで4096ビットの乗算が必要な場合は、`wolfSSL/wolfcrypt/tfm.h`の`FP_MAX_BITS`を変更してください。
`FP_MAX_BITS`が増加すると、公開鍵操作で使用されるバッファがより大きくなるため、実行時のスタック使用量も増加します。
`FP_MAX_BITS`は最大キーサイズの2倍である必要があります。
例えば、最大のキーが2048ビットの場合、`FP_MAX_BITS`は4096であるべきで、4096ビットの場合は`FP_MAX_BITS`は8192であるべきです。
ECCのみを使用する場合、これは最大ECCキーサイズの2倍に減らすことができます。
ライブラリのいくつかの関数は複数の一時的な大きな整数を使用するため、スタックは比較的大きくなる可能性があります。
これは、スタックサイズが低い値に設定されている組み込みシステムやスレッド環境でのみ問題になるはずです。
FastMathを使用している環境で公開鍵操作中にスタック破壊が発生した場合は、スタック使用量に対応するためにスタックサイズを増やしてください。

autoconfシステムを使用せずにFastMathを有効にする場合は、`USE_FAST_MATH`を定義し、`tfm.c`をwolfSSLビルドに追加し、`integer.c`を削除する必要があります。
`ALT_ECC_SIZE`を定義すると、ECCポイントはスタックではなくヒープからのみ割り当てられます。

##### アーキテクチャ固有の最適化

`USE_FAST_MATH`でアセンブリの最適化のために以下のマクロを定義できます。

* `TFM_ARM`
* `TFM_SSE2`
* `TFM_AVR32`
* `TFM_PPC32`
* `TFM_PPC64`
* `TFM_MIPS`
* `TFM_X86`
* `TFM_X86_64`

これらのいずれも定義されていないか、`TFM_NO_ASM`が定義されている場合、`TFM_ISO`が定義され、ISO Cポータブルコードが使用されます。

##### アルゴリズム固有の最適化

有効にすると、それぞれのECC曲線に対して乗算と二乗計算の最適化された実装が使用されます。

* `TFM_ECC192`
* `TFM_ECC224`
* `TFM_ECC256`
* `TFM_ECC384`
* `TFM_ECC521`

##### TFM_SMALL_SET

小さい数の乗算のためのスピード最適化を行います。
1-16ワードのコンバ(Comba)乗算と二乗の実装を含みます。
ECC操作の性能を向上させるのに役立ちます。

##### TFM_HUGE_SET

より大きな数の乗算のための速度最適化を行います。
20、24、28、32、48、64ワードコンバ(Comba)乗算と、ビットサイズが許す場所での二乗の実装が含まれています。
RSA/DH/DSA操作のパフォーマンスの向上に役立ちます。

##### TFM_SMALL_MONT_SET

Intelアーキテクチャ上の小さな数値のモンゴメリーリダクションのための速度最適化を行います。
1〜16ワードモンゴメリーリダクションの実装が含まれています。
ECC操作の性能を向上させるのに役立ちます。

#### 独自の単精度(SP)数学ライブラリのサポート

SP数学ライブラリは推奨されるデフォルトのオプションであり、DO-178C認定を受けています。 
このライブラリを使用すると、特定の鍵サイズと一般的な曲線に対する公開鍵の操作が高速化されます。 
次のような正しいコードファイルが含まれていることをご確認ください。

* `sp_c32.c`
* `sp_c64.c`
* `sp_arm32.c`
* `sp_arm64.c`
* `sp_armthumb.c`
* `sp_cortexm.c`
* `sp_int.c`
* `sp_x86_64.c`
* `sp_x86_64_asm.S`
* `sp_x86_64_asm.asm`

##### WOLFSSL_SP

単精度演算ライブラリのサポートを有効にします。

#### WOLFSSL_SP_MATH

SP数学とアルゴリズムのみを有効にします。
通常(`integer.c`)またはFAST(`tfm.c`)などの大きな整数演算コードを排除します。
鍵サイズと曲線をSPでサポートされているものだけに制限します。

#### WOLFSSL_SP_MATH_ALL

SP数学とアルゴリズムを有効にします。
SPではサポートされていない鍵サイズと曲線のために、通常(`integer.c`)またはFAST(`tfm.c`)などの大きな整数数学コードを実装しています。

#### WOLFSSL_SP_SMALL

SP Mathを使用する場合、これはコードの小さなバージョンを使用し、大きなスタック変数を回避します。

##### SP_WORD_SIZE

1ワードを1ワードに保存するための32ビットまたは64ビットのデータ型。

##### WOLFSSL_SP_NONBLOCK

単一の精度数学の「非ブロッキング」モードを有効にします。
これにより、長い操作のためにFP_WouldBlockを返し、機能が完了するまで再度呼び出す必要があります。
現在、これはECCでのみサポートされており、`WC_ECC_NONBLOCK`と組み合わせて使用されています。

##### WOLFSSL_SP_FAST_NCT_EXPTMOD

より速い非一定の時間モジュール式指数の実装を可能にします。
公開鍵操作にのみ使用されます。秘密鍵操作ではありません。

##### WOLFSSL_SP_INT_NEGATIVE

マルチプレシジョン数値を負にすることができます。
(暗号化操作には必要ありません。)

##### WOLFSSL_SP_INT_DIGIT_ALIGN

`sp_int_digit`ポインタの非整列アクセスが許可されていない場合に有効にします。

##### WOLFSSL_HAVE_SP_RSA

2048、3072、4096ビットのための単精度RSA。

##### WOLFSSL_HAVE_SP_DH

2048、3072、4096ビットの単精度DH。

##### WOLFSSL_HAVE_SP_ECC

SECP256R1およびSECP384R1用の単精度ECC。

##### WOLFSSL_SP_LARGE_CODE

大きなバイナリーサイズとなりますが、単精度(SP)スピードアップを許可します。
一部の組み込みプラットフォームには適していない可能性があります。

##### WOLFSSL_SP_DIV_WORD_HALF

２倍の長さのワードを使用して除算が利用できないことを示します。
たとえば、32ビットCPUで、ライブラリから64ビット除算でコンパイルしたくない場合は、このマクロを定義すると、半分のワードサイズを使用して除算が行われる実装を有効化します。

##### WOLFSSL_SP_DIV_32

32ビット除算が利用できず、wolfSSLが独自の単精度(SP)実装を使用する必要があることを示します。

##### WOLFSSL_SP_DIV_64

64ビット除算が利用できず、WOLFSSLは独自の単精度(SP)実装を使用する必要があることを示します。

##### WOLFSSL_SP_ASM

より高速な単一精度(SP)プラットフォーム固有のアセンブリコードの実装を有効にします。
プラットフォームが検出されます。

##### WOLFSSL_SP_X86_64_ASM

単精度(SP) Intel x64アセンブリの実装を有効にします。

##### WOLFSSL_SP_ARM32_ASM

単精度(SP) Aarch32アセンブリの実装を有効にします。

##### WOLFSSL_SP_ARM64_ASM

単精度(SP) Aarch64アセンブリの実装を有効にします。

##### WOLFSSL_SP_ARM_CORTEX_M_ASM

単精度(SP) Cortex-Mファミリー(Cortex-M4を含む)アセンブリの実装を有効にします。

##### WOLFSSL_SP_ARM_THUMB_ASM

単精度(SP) ARM Thumbアセンブリの実装を有効にします(-mthumbと一緒に使用)。

##### WOLFSSL_SP_X86_64

単精度(SP)I ntel X86 64ビットアセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_X86

単精度(SP) Intel X86アセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_PPC64

単精度(SP) PPC64アセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_PPC

単精度(SP) PPCアセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_MIPS64

単精度(SP) MIPS64アセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_MIPS

単精度(SP) MIPSアセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_RISCV64

単精度(SP) RISCV64アセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_RISCV32

単精度(SP) RISCV32アセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_S390X

単精度(SP) S390Xアセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

### スタックまたはチップ固有の定義

wolfSSLは、さまざまなプラットフォームとTCP/IPスタック用にビルドできます。
次の定義のほとんどは`wolfSSL/wolfcrypt/settings.h`にあり、デフォルトでコメントアウトされています。
以下を参照する特定のチップまたはスタックのサポートを有効にするために、それぞれのコメントを解除できます。

#### IPHONE

iOSで使用するためにビルドする場合に定義します。

#### THREADX

ThreadX RTOS(<https://www.rtos.com>)で使用するためにビルドするときに定義します。

#### MICRIUM

MicriumのµC/OS-III RTOS(<https://www.micrium.com>)で使用するためにビルドするときに定義します。

#### MBED

mbedプロトタイピングプラットフォーム(<https://www.mbed.org>)で使用するためにビルドするときに定義します。

#### MICROCHIP_PIC32

マイクロチップのPIC32プラットフォーム(<https://www.microchip.com>)で使用するためにビルドするときに定義します。

#### MICROCHIP_TCPIP_V5

マイクロチップTCP/IPスタックのバージョン5を定義できます。

#### MICROCHIP_TCPIP

マイクロチップTCP/IPスタックバージョン6以降に定義できます。

#### WOLFSSL_MICROCHIP_PIC32MZ

PIC32MZハードウェア暗号化エンジン用に定義できます。

#### FREERTOS

Freertos(<https://www.freertos.org>)で使用するためにビルドするときに定義できます。
LwIPを使用している場合は、[`WOLFSSL_LWIP`](#wolfSSL_lwip)も定義します。

#### FREERTOS_WINSIM

Freertos Windows Simulator(<https://www.freertos.org>)で使用するためにビルドするときに定義できます。

#### WOLFSSL_CHIBIOS

ChibiOS RTOSで使用するためにビルドする場合に定義します。

#### WOLFSSL_CMSIS_RTOS

Mbed CMIS-RTOSで使用するためにビルドする場合に定義します。

#### WOLFSSL_CMSIS_RTOSv2

Mbed CMIS-RTOSv2で使用するためにビルドする場合に定義します。

#### WOLFSSL_LWIP_NATIVE

LWIPネイティブのプラットフォームで使用します。

#### WOLFSSL_DEOS

この定義を使用して、[ここ](https://www.ddci.com/products_deos_do_178c_arinc_653/)で利用可能なDeos RTOSのwolfSSLサポートを有効にできます。

#### WOLFSSL_ESPIDF

ESP-IDFでビルドする場合に使用します。

#### WOLFSSL_LINUXKM

Linuxカーネルモジュール用にビルドする場合に使用します。

#### WORD64_AVAILABLE

64ビット型がサポートされていることを示す移植用マクロです。
通常は`SIZEOF_LONG_LONG 8`を使用する方が良いです。

#### WOLFSSL_NUCLEUS_1_2

Nucleus 1.2でビルドする場合に使用します。

#### WOLFSSL_PICOTCP

PicoTCPでビルドする場合に使用します。

#### WOLFSSL_RENESAS_RA6M3G

RENESAS RA6M3Gでビルドする場合に使用します。

#### WOLFSSL_RENESAS_RA6M4

RENESAS RA6M4でビルドする場合に使用します。

#### WOLFSSL_RIOT_OS

RIOT-OSでビルドする場合に使用します。

#### WOLFSSL_uITRON4

uITRON4用にビルドする場合に使用します。

#### WOLFSSL_uTKERNEL2

uT-Kernelでビルドする場合に使用します。

#### WOLFSSL_VXWORKS

VxWorksでビルドする場合に使用します。

#### DEVKITPRO

devkitPro用にビルドする場合に使用します。

#### WOLFSSL_VXWORKS_6_x

VxWorks 6.x専用の実装でのみ使用されます。

#### WOLFSSL_WICED

WICED Studio用にビルドする場合に使用されます。

#### FREESCALE_KSDK_FREERTOS

このマクロの古い名前は`FREESCALE_FREE_RTOS`です。
Freescale KSDK FreeRTOS用にビルドする場合に使用されます。

#### FREESCALE_KSDK_MQX

Freescale KSDK MQX/RTCS/MFS用にビルドする場合に使用されます。

#### FREESCALE_MQX_5_0

Freescale Classic MQXバージョン5.0用にビルドする場合に使用されます。

#### WOLFSSL_KEIL_TCP_NET

TCPスタック（`MDK_CONF_NETWORK`）を構成します。
デフォルトではKeil TCP `WOLFSSL_KEIL_TCP_NET`を使用します。
なしの場合は0、ユーザーIOコールバックの場合は2を使用します。

#### INTEL_GALILEO

ArduinoとwolfSSLを構成する際に使用されます。
Intel Galileoプラットフォーム用にビルドする場合は`#define INTEL_GALILEO`を追加します。

#### HAVE_KEIL_RTX

MDK-RTX-TCP-FS構成用のwolfSSL。

#### EBSNET

EBSNET製品とRTIPを使用するときに定義できます。

#### WOLFSSL_EMBOS

SEGGER embOS (<https://www.segger.com/products/rtos/embos/>) のビルド時に定義できます。
emNETを使用する場合は、[`WOLFSSL_EMNET`](#wolfSSL_emnet) も定義します。

#### WOLFSSL_EMNET

SEGGER emNET TCP/IPスタック (<https://www.segger.com/products/connectivity/emnet/>) のビルド時に定義できます。

#### WOLFSSL_LWIP

LWIP TCP/IPスタック(<https://savannah.nongnu.org/projects/lwip/>)でwolfSSLを使用するときに定義できます。

#### WOLFSSL_ISOTP

通常、CANバスに使用されるISO-TPトランスポートプロトコルでwolfSSLを使用する場合、定義できます。
使用例は[wolfssl-examplesリポジトリ](https://github.com/wolfSSL/wolfSSL-examples)にあります。

#### WOLFSSL_GAME_BUILD

ゲームコンソールのためにwolfSSLをビルドするときに定義できます。

#### WOLFSSL_LSR

LSR用にビルドする場合は定義できます。

#### FREESCALE_MQX

Freescale MQX/RTCS/MFS(<https://www.freescale.com>)用にビルドするときに定義できます。
これにより、`FREESCALE_K70_RNGA`が定義され、Kinetis H/W乱数ジェネレーターアクセラレータのサポートが可能になります。

#### WOLFSSL_STM32F2

STM32F2(<https://www.st.com/internet/mcu/subclass/1520.jsp>)用のビルド時に定義できます。
これは、wolfSSLでSTM32F2ハードウェア暗号化およびハードウェアRNGサポートを可能にします。

#### COMVERGE

Comverge設定を使用する場合は定義できます。

#### WOLFSSL_QL

QL SEP設定を使用している場合は定義できます。

#### WOLFSSL_EROAD

eroadのためにビルドを定義することができます。

#### WOLFSSL_IAR_ARM

IAR Ewarm用にビルドする場合は定義できます。

#### WOLFSSL_TIRTOS

TI-RTOS用のビルド時に定義できます。

#### WOLFSSL_ROWLEY_ARM

Rowley CrossWorksでビルドするときに定義できます。

#### WOLFSSL_NRF51

Nordic NRF51に移植するときに定義できます。

#### WOLFSSL_NRF51_AES

NORDIC NRF51に移植するときにENCRYPTをAES 128 ECB Encryptに内蔵AESハードウェアを使用するように定義できます。

#### WOLFSSL_CONTIKI

Contikiオペレーティングシステムのサポートを有効にするために定義できます。

#### WOLFSSL_APACHE_MYNEWT

Apache MyNewtポート層を有効にするように定義できます。

#### WOLFSSL_APACHE_HTTPD

Apache HTTPD Webサーバーのサポートを有効にするために定義できます。

#### ASIO_USE_WOLFSSL

wolfSSLをASIO互換バージョンとしてビルドするように定義できます。
その後、ASIOは`BOOST_ASIO_USE_WOLFSSL` プリプロセッサ定義に依存します。

#### WOLFSSL_CRYPTOCELL

ARM Cryptocellを使用できるように定義できます。

#### WOLFSSL_SIFIVE_RISC_V

RISC-V SiFive/HiFiveポートの使用を有効にするために定義できます。

#### WOLFSSL_MDK_ARM

MDK ARMのサポートを追加します。

#### WOLFSSL_MDK5

MDK5 ARMのサポートを追加します。

### OS特有の定義

#### USE_WINDOWS_API

UNIX/Linux APIに対して、WindowsライブラリAPIの使用を指定します。

#### WIN32_LEAN_AND_MEAN

Microsoft Win32 LeanとMean Buildのサポートを追加します。

#### FREERTOS_TCP

FreeRTOS TCPスタックのサポートを追加します。

#### WOLFSSL_SAFERTOS

SafeRTOSのサポートを追加します。

## ビルドオプション

以下は、wolfSSLライブラリのビルド方法をカスタマイズするために`./configure`スクリプトに追加される可能性のあるオプションです。
デフォルトでは共有ライブラリとしてのみビルドされ、スタティックライブラリとしてのビルドが無効になっています。
これによりビルド時間が半分に短縮されます。
必要に応じて、どちらのモードも明示的に無効化または有効化できます。

### `--enable-debug`

wolfSSLデバッグサポートを有効にし、デバッグ情報を含めてコンパイルします。
デバッグログを出力するには、このビルドオプションを加えた上で
メッセージを`stderr`に出力するマクロ[`DEBUG_WOLFSSL`](#debug_wolfSSL)を定義します。
その後[`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfSSL_debugging_on)を実行するとデバッグログ出力が有効化されます。
同様に[`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfSSL_debugging_off)を実行することで、デバッグログ出力を停止できます。
詳細は[第8章 デバッグ](chapter08.md)を参照してください。

### `--enable-distro`

wolfSSL Distro Buildを有効にします。

### `--enable-singlethread`

シングルスレッドモードを有効にし、マルチスレッド保護を無効にします。

シングルスレッドモードを有効にすると、セッションキャッシュのマルチスレッド保護がオフになります。
アプリケーションがシングルスレッドであること、またはアプリケーションがマルチスレッドであっても一度に1つのスレッドだけがライブラリにアクセスする場合にのみ、シングルスレッドモードを有効にしてください。

### `--enable-dtls`

wolfSSL DTLSのサポートを有効にします。

DTLSサポートを有効にすると、ライブラリのユーザーはTLSおよびSSLに加えてDTLSプロトコルも使用できるようになります。
詳細については、[第4章](chapter04.md)「DTLS」節を参照してください。

### `--disable-rng`

RNGのコンパイルと使用を無効にします。

### `--enable-sctp`

wolfSSL DTLS-SCTPサポートを有効にします。

### `--enable-openssh`

OpenSSH互換ビルドを有効にします。

### `--enable-apachehttpd`

Apache httpd互換ビルドを有効にします。

### `--enable-openvpn`

OpenVPN互換ビルドを有効にします。

### `--enable-opensslextra`

追加のOpenSSL API互換性を有効にし、サイズを増加させます。

OpenSSL Extraを有効にすると、より多くのOpenSSL互換関数が含まれます。
これを指定しないベーシックビルドで、ほとんどのTLS/SSLニーズ対応できる関数を使用できます。
しかし10〜100のOpenSSL関数を使用するアプリケーションを移植する場合には、これを有効にすることでよりスムーズに移植できるようになります。
wolfSSL OpenSSL互換レイヤーは現在も継続して開発しています。
必要な関数が欠落している場合はお問い合わせください。
OpenSSL互換レイヤーの詳細については、[第13章 OpenSSL互換性](chapter13.md)を参照してください。

### `--enable-opensslall`

wolfSSL がサポートする openSSL互換性レイヤーのOpenSSL APIをすべて有効にします。

### `--enable-maxstrength`

最大強度ビルドを有効にし、TSLv1.2-AEAD-PFS暗号のみを許可します。
また、グリッチ検出も有効になります。
相互運用性の問題が発生する可能性があるため、これはデフォルトで無効になっています。

### `--disable-harden`

ハードニング、タイミング耐性とRSAブラインドを無効にします。
この機能を無効にするとパフォーマンスが向上する可能性があります。

**注意** ハードニングはサイドチャネル攻撃に対する緩和策を提供します。慎重に
検討した後にのみこの機能を無効にしてください。

user_settings.hで無効にするには、以下のようにします。

* `#define WC_NO_CACHE_RESISTANT`
* `#define WC_NO_HARDEN`
* `WC_RSA_BLINDING`が定義されている場合、削除する
* `ECC_TIMING_RESISTANT`が定義されている場合、削除する
* `TFM_TIMING_RESISTANT`が定義されている場合、削除する

### `--enable-ipv6`

IPv6のテストを有効にします。wolfSSL自体はIP中立です

IPv6を有効にすると、テストアプリケーションがIPv4の代わりにIPv6を使用するように変更されます。
wolfSSL自体はIP中立で、どちらのバージョンも使用できますが、現在のテストアプリケーションはIP依存です。

### `--enable-bump`

SSLバンプビルドを有効にします。

### `--enable-leanpsk`

LEAN PSKビルドを有効にします。

PSKを使用し、ライブラリから多くの機能を削除して非常に小さなビルドを構成します。
これを有効にすると、ビルドサイズは約21kBになります。

### `--enable-leantls`

LEAN TLS 1.2クライアントのみ（クライアント認証なし）、ECC256、AES128およびSHA256（Shamirなし）をサポートするよう構成します。
現時点では、他のビルドオプションと組み合わせて使用することを想定していません。

### `--enable-bigcache`

ビッグセッションキャッシュを有効にします。

ビッグセッションキャッシュを有効にすると、セッションキャッシュが33セッションから20,027セッションまで増加します。
デフォルトのセッションキャッシュサイズ33は、一般的なTLSクライアントと組み込みサーバーに適しています。
ビッグセッションキャッシュは、1分あたり約200の新しいセッションを処理するような、中程度の負荷がかかるサーバーに適しています。

### `--enable-hugecache`

巨大なセッションキャッシュを有効にします。

巨大なセッションキャッシュを有効にすると、セッションキャッシュサイズが65,791セッションに増加します。
このオプションは、1分あたり13,000(1秒あたり200)を越える新規セッションを処理するような、重い負荷のかかるサーバー向けです。

### `--enable-smallcache`

小さなセッションキャッシュを有効にします。

小さなセッションキャッシュを有効にすると、wolfSSLは6セッションのみを保存し、RAM使用量を500バイト未満に収めます。
これは、デフォルトのRAM使用量3kBが大きすぎると感じる埋め込みデバイスに適しています。

### `--enable-savesession`

永続的なセッションキャッシュを有効にします。

このオプションを有効にすることで、アプリケーションがwolfSSLセッションキャッシュをメモリバッファに保持(保存)して復元できるようになります。

### `--enable-savecert`

永続的な証明書キャッシュを有効にします。

このオプションを有効にすることで、アプリケーションがwolfSSL証明書キャッシュをメモリバッファに保持(保存)して復元できるようになります。

### `--enable-atomicuser`

アトミックユーザーレコードレイヤを有効にします。

このオプションを有効にすると、ユーザーアトミックレコードレイヤの処理コールバックがオンになります。
これにより、アプリケーションは独自のMAC /暗号化および復号化/検証コールバックを登録することができます。

### `--enable-pkcallbacks`

公開鍵コールバックを有効にします。

### `--enable-sniffer`

wolfSSL Snifferのサポートを有効にします。

スニファー（SSL検査）サポートを有効にすると、SSLトラフィックパケットの収集と、正しいキーファイルを使用したそれらのパケットの復号が可能になります。

現在、スニファーは以下のRSA暗号をサポートしています。

CBC暗号：

* AES-CBC
* Camellia-CBC
* 3DES-CBC

ストリーム暗号：

* RC4

### `--enable-aesgcm`

AES-GCMサポートを有効にします。

このオプションを有効にすると公開鍵コールバックが有効になり、アプリケーションは独自のECC署名/検証とRSA署名/検証を許可し、コールバックを識別して暗号化/復号できます。

### `--enable-aesccm`

AES-CCMサポートを有効にします。

AES-CCMを有効にすると、以下の暗号スイートがwolfSSLに追加されます。
wolfSSLは、速度とメモリ消費のバランスを取った4つの異なるAES-GCM実装を提供しています。
利用可能な場合、wolfSSLは64ビットまたは32ビットの計算を使用します。
組み込みアプリケーションの場合、RAMベースのルックアップテーブル（セッションあたり8KB）を使用する高速な8ビットバージョン（64ビットバージョンと同程度の速度）と、追加のRAMを消費しないより遅い8ビットバージョンがあります。
--enable-aesgcm設定オプションは、`=word32`、`=table`、または`=small`などのオプションで変更できます（例：`--enable-aesgcm=table`）。

### `--disable-aescbc`

AES-CBCをコンパイルアウトするために[`--disable-aescbc`](#--disable-aescbc)で使用されていました。

AES-GCMは、AESの8バイト認証(CCM-8)を備えたCBC-MACモードでカウンターを有効にします。

### `--enable-aescfb`

AES-CFBモードサポートをオンにします。

### `--enable-aesctr`

wolfSSL AES-CTRサポートを有効にします。

AES-CTRを有効にすると、カウンタモードが有効になります。

### `--enable-aesni`

wolfSSL Intel AES-NIサポートを有効にします。

AES-NIサポートを有効にすると、AES-NIをサポートするチップを使用する際にチップから直接AES命令を呼び出せるようになります。
これにより、AES関数の速度が向上します。
AES-NIに関する詳細については、[第4章 機能](chapter04.md)を参照してください。

### `--enable-intelasm`

IntelおよびAMDプロセッサ向けのASM高速化を有効にします。

wolfSSL用にintelasmオプションを有効にすると、プロセッサの拡張機能を活用してAESのパフォーマンスを劇的に向上させます。
この設定オプションが有効な場合に活用される命令セットには、AVX1、AVX2、BMI2、RDRAND、RDSEED、AESNI、およびADXが含まれます。
これらはIntelプロセッサに最初に導入され、AMDプロセッサも近年採用し始めています。
有効にすると、wolfSSLはプロセッサをチェックし、プロセッサがサポートする命令セットを活用します。

### `--enable-camellia`

Camelliaサポートを有効にします。

### `--enable-md2`

MD2サポートを有効にします。

### `--enable-nullcipher`

wolfSSL NULL暗号サポート（暗号化なし）を有効にします。

### `--enable-ripemd`

wolfSSL ripemd-160サポートを有効にします。

### `--enable-blake2`

wolfSSL Blake2サポートを有効にします。

### `--enable-blake2s`

wolfSSL Blake2Sサポートを有効にします。

### `--enable-sha3`

x86\_64およびAarch64では、デフォルトで有効になっています。
wolfSSL SHA3のサポートを有効にします。
小型ビルド用に、`=small`を設定できます。

### `--enable-sha512`

x86\_64ではデフォルトで有効になっています。
wolfSSL SHA-512サポートを有効にします。

### `--enable-sessioncerts`

セッション証明書保存を有効にします。

### `--enable-keygen`

鍵生成機能を有効にします。
RSA鍵生成にのみ適用されます。

### `--enable-certgen`

証明書生成機能を有効にします。

### `--enable-cert`

証明書の拡張機能を有効にします。
サポートしている拡張機能については、第7章を参照してください。

### `--enable-certreq`

証明書リクエスト生成を有効にします。

### `--enable-sep`

SEP拡張機能を有効にします。

### `--enable-hkdf`

HKDF（HMAC-KDF）を有効にします。

### `--enable-x963kdf`

X9.63 KDFサポートを有効にします。

### `--enable-dsa`

デジタル署名アルゴリズム(DSA)を有効にします。
FIPS 186-4で定義されているNIST承認のデジタル署名アルゴリズムとRSAおよびECDSAは、Secure Hash Standard (FIPS 180-4) で定義されている承認されたハッシュ関数と組み合わせて使用する場合、デジタル署名の生成と検証に使用されます。

### `--enable-eccshamir`

x86\_64ではデフォルトで有効になっています。
ECC Shamirを有効にします。

### `--enable-ecc`

x86\_64ではデフォルトで有効になっています。
ECCを有効にします。
このオプションを有効にすると、ECCサポートと暗号スイートがwolfSSLに組み込まれます。

### `--enable-ecccustcurves`

ECCカスタムカーブを有効にします。
すべてのカーブタイプを有効にするには、 `=all` を指定します。

### `--enable-compkey`

圧縮鍵のサポートを有効にします。

### `--enable-curve25519`

Curve25519を有効にします。
Curve25519\_SMALLの場合は`--enable-curve25519=small`と指定します。

楕円曲線は128ビットのセキュリティを提供し、ECDH鍵合意と共に使用されます(後の「クロスコンパイル」節を参照)。
Curve25519を有効にすると、Curve25519アルゴリズムを使用できます。

デフォルトのCurve25519は、より多くのメモリを使用し実行時間が速くなるように設計されています。
オプション`--enable-curve25519=small`を使用することで、速度は低下しますがメモリの使用量を抑えることができます。

### `--enable-ed25519`

Ed25519を有効にします。
Ed25519\_SMALLの場合は`--enable-ed25519=small`と指定します。

Ed25519オプションを有効にすると、Ed25519アルゴリズムを使用できます。

デフォルトのEd25519は、より多くのメモリを使用し実行時間が速くなるように設計されています。
オプション`--enable-ed25519=small`を使用することで、速度は低下しますがメモリの使用量を抑えることができます。

### `--enable-fpecc`

固定小数点キャッシュECCを有効にします。

### `--enable-eccencrypt`

ECC暗号化を有効にします。

### `--enable-psk`

PSK（事前共有鍵）を有効にします。

### `--disable-errorstrings`

エラー文字列テーブルを無効にします。

### `--disable-oldtls`

古いTLSバージョン（1.2未満）を無効にします。

### `--enable-sslv3`

SSLバージョン3.0を有効にします。

### `--enable-stacksize`

サンプルプログラムでのスタックサイズ情報を有効にします。

### `--disable-memory`

メモリコールバックを無効にします。

### `--disable-rsa`

RSAを無効にします。

### `--enable-rsapss`

RSA-PSSを有効にします。

### `--disable-dh`

DHを無効にします。

### `--enable-anon`

匿名認証を有効にします。

### `--disable-asn`

ASNを無効にします。

### `--disable-aes`

AESを無効にします。

### `--disable-coding`

Base16/64コーディングを無効にします。

### `--enable-base64encode`

x86\_64ではデフォルトで有効になっています。
Base64エンコーディングを有効にします。

### `--disable-des3`

DES3を無効にします。

### `--enable-arc4`

ARC4を有効にします。

### `--disable-md5`

MD5を無効にします。

### `--disable-sha`

Shaを無効にします。

### `--enable-webserver`

Webサーバーを有効にします。

これにより、wolfSSL組み込みWebサーバーで構築する際に完全な機能を提供するための、標準ビルドに必要な機能がオンになります。

### `--enable-fips`

FIPS 140-2を有効にします。

**注意**: 別途、ライセンス契約が必要です。

### `--enable-sha224`

x86\_64ではデフォルトで有効になっています。
wolfSSL SHA-224サポートを有効にします。

### `--disable-poly1305`

wolfSSL Poly1305サポートを無効にします。

### `--disable-chacha`

chachaを無効にします。

### `--disable-hashdrbg`

ハッシュDRBGサポートを無効にします。

### `--disable-filesystem`

ファイルシステムのサポートを無効にします。

これにより、ファイルシステムの使用を無効にできます。
このオプションは[`NO_FILESYSTEM`](#no_filesystem)を定義します。

### `--disable-inline`

インライン関数を無効にします。

このオプションを無効にすると、wolfSSLの関数インライン化が無効になります。
関数インライン化が有効な場合、関数プレースホルダはリンクされず、代わりに関数呼び出し時にコードブロックが挿入されます。

### `--enable-ocsp`

オンライン証明書ステータスプロトコル(OCSP)を有効にします。

このオプションを有効にすると、OCSP(Online Certificate Status Protocol)サポートがwolfSSLに追加されます。
[RFC 6960](https://tex2e.github.io/rfc-translater/html/rfc6960)に記載されているように、X.509証明書の失効状態を取得するために使用されます。

### `--enable-ocspstapling`

OCSPステーリングを有効にします。
TLS1.3使用時、Certificateメッセージへの複数OCSP Staplingを無効にするには`=no-multi`を指定します。

### `--enable-ocspstapling2`

OCSPステープリングバージョン2を有効にします。

### `--enable-crl`

CRL(証明書失効リスト)を有効にします。

### `--enable-crl-monitor`

CRLモニターを有効にします。

このオプションを有効にすると、特定のCRL(証明書の失効リスト)ディレクトリを積極的に監視する機能が追加されます。

### `--enable-sni`

サーバー名表示を有効にします(SNI)。

このオプションを有効にすると、TLSサーバー名表示(SNI)拡張機能がオンになります。

### `--enable-maxfragment`

最大フラグメント長を有効にします。

このオプションを有効にすると、TLSの最大フラグメント長拡張機能がオンになります。

### `--enable-alpn`

アプリケーションレイヤープロトコルネゴシエーション(ALPN)を有効にします。

### `--enable-truncatedhmac`

切り詰められたキー付きハッシュMAC（HMAC）を有効にします。

このオプションを有効にすると、TLS切り詰めHMAC拡張機能がオンになります。

### `--enable-renegotiation-indication`

再ネゴシエーションの表示を有効にします。

[RFC 5746](https://tex2e.github.io/rfc-translater/html/rfc5746)で説明されているように、この仕様は、再ネゴシエーションを実行するTLS接続に結び付けることにより、再ネゴシエーションスプライシングを含むSSL/TLS攻撃を防ぎます。

### `--enable-secure-renegotiation`

安全な再ネゴシエーションを有効にします。

### `--enable-supportedcurves`

サポートされている楕円曲線を有効にします。

このオプションを有効にすると、TLSサポートECC曲線拡張機能がオンになります。

### `--enable-session-ticket`

セッションチケットを有効にします。

### `--enable-extended-master`

拡張マスターシークレットを有効にします。

### `--enable-tlsx`

すべてのTLS拡張機能を有効にします。

このオプションを有効にすると、現在wolfSSLでサポートしているすべてのTLS拡張機能がオンになります。

### `--enable-pkcs7`

PKCS＃7サポートを有効にします。

### `--enable-pkcs11`

PKCS＃11アクセスを有効にします。

### `--enable-ssh`

wolfSSHオプションを有効にします。

### `--enable-scep`

wolfSCEP（Simple Certificate Enrollment Protocol）を有効にします。

IETFによって定義されているように、SCEPはHTTP上でPKCS#7とPKCS#10を活用するPKIです。
CERTはSCEPが証明書要求を強力に認証しないことに注意しています。

### `--enable-srp`

安全なリモートパスワードを有効にします。

### `--enable-smallstack`

スタックの使用量を抑えます。

### `--enable-valgrind`

ユニットテストでValgrindを有効にします。

このオプションを有効にすると、wolfSSLユニットテストを実行するときにValgrindがオンになります。
これは、開発サイクルの早い段階で問題を発見するのに役立ちます。

### `--enable-testcert`

テスト証明書を有効にします。

このオプションが有効になると、通常は公開されないASN証明書APIの一部が公開されます。
これはwolfCryptテストアプリケーション（`wolfcrypt/test/test.c`）で使用されているように、テストに役立ちます。

### `--enable-iopool`

I/Oプールの例を有効にします。

### `--enable-certservice`

証明書サービスを有効にします。(Windows Server)

### `--enable-jni`

wolfSSL JNIを有効にします。

### `--enable-lighty`

Lighttpd/Lightyを有効にします。

### `--enable-stunnel`

`stunnel`を有効にします。

### `--enable-md4`

MD4を有効にします。

### `--enable-pwdbased`

pwdbasedを有効にします。

### `--enable-scrypt`

scryptを有効にします。

### `--enable-cryptonly`

wolfCryptのみを有効にします。

### `--disable-examples`

サンプルプログラムのビルドを無効にします。

サンプルプログラムのビルドを有効にすると、wolfSSLのサンプルアプリケーションがビルドされます。
詳細は、[第3章 入門](chapter03.md)をご参照ください。

### `--disable-crypttests`

暗号ベンチマーク/テストを無効にします。

### `--enable-fast-rsa`

Intel IPPを使用したRSAを有効にします。

fast-rsaを有効にすると、IPPライブラリを使用してRSA操作が高速化されます。
通常よりも多くのメモリを使用するようになります。
IPPライブラリが見つからない場合、設定中にエラーメッセージが表示されます。
autoconfははじめに`wolfssl_root/IPP`ディレクトリを探索し、次はLinuxシステムの`/usr/lib/`などのマシン上のライブラリの標準的な場所を確認します。

RSA操作に使用されるライブラリは、`wolfssl-X.X.X/IPP/`ディレクトリにあります。（X.X.Xは現在のwolfSSLバージョン番号）
バンドルされたライブラリからのビルドはディレクトリの場所とIPPの名前に依存しているため、サブディレクトリIPPのファイル構造は変更しないでください。

メモリを割り当てる際、fast-rsa操作のメモリタグは`DYNAMIC_TYPE_USER_CRYPTO`です。
これにより、fast-rsaオプションを有効化した場合の、RSA操作によるメモリ使用状況を確認できます。

### `--enable-staticmemory`

静的メモリ使用を有効にします。

### `--enable-mcapi`

マイクロチップAPIを有効にします。

### `--enable-asynccrypt`

非同期暗号を有効にします。

### `--enable-sessionexport`

セッションのエクスポートとインポートを有効にします。

### `--enable-aeskeywrap`

AESキーラップサポートを有効にします。

### `--enable-jobserver`

値：`yes`(デフォルト)/ `no`/`#`

`make`を使用する場合、マルチスレッドビルドを使用してwolfSSLをビルドします。
`yes`（デフォルト）はCPUコアの数を検出し、そのカウントに対して推奨されるジョブ数を使用してビルドします。
これは`make -j`オプションと同様に機能します。
手動で固定値を指定したい場合には、その値を使用します。

### `--enable-shared[=PKGS]`

wolfSSLライブラリを共有ライブラリとしてビルドします。
デフォルトで有効です。

共有ライブラリビルドを無効にすると、wolfSSL共有ライブラリがビルドされるのを除外します。デフォルトでは、時間とスペースを節約するために共有ライブラリのみがビルドされています。

### `--enable-static[=PKGS]`

wolfSSLライブラリをスタティックライブラリとしてビルドします。
デフォルトでは無効です。使用する場合はこのオプションを指定してください。

### `--with-liboqs=PATH`

OpenQuantumsafeインストールへのパスです。
デフォルトでは`/usr/local`を参照します。

これにより、wolfSSLが実験的なTLS 1.3 Quantum-Safe KEMグループ、ハイブリッド量子セーフKEMグループ、LiboqsとのwolfSSL統合を介してFalcon Signature Schemeを使用する機能がオンになります。
詳細については、このドキュメントの「Quantum-Safe Cryptographyの実験」を参照してください。

### `--with-libz=PATH`

オプションで圧縮用にlibzを含めます。

libzを有効にすると、libzライブラリからの圧縮サポートがwolfSSLで可能になります。
このオプションを含めて[`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression)を呼び出すことについては、よくご検討ください。
送信前にデータを圧縮すると、送受信されるメッセージの実際のサイズが減少します。
しかし、圧縮されたデータはほとんどのネットワークにおいて、そのまま送信するよりも分析に時間がかかります。

### `--with-cavium`

cavium/softwareディレクトリへのパス。

### `--with-user-crypto`

USER\_CRYPTO インストールへのパス。
デフォルトでは`/usr/local`を参照します。

### `--enable-rsavfy`

RSA検証のみのサポートを有効にします。

**注意**:  [`--enable-cryptonly`](#--enable-cryptonly)が必要です。

### `--enable-rsapub`

デフォルト値：RSA公開鍵のみのサポートを有効にします。

**注意**:  [`--enable-cryptonly`](#--enable-cryptonly)が必要です。

### `--enable-armasm`

ARMV8 ASMサポートを有効にします。

デフォルトの構成は、64か32ビットシステムに基づいてMCPUまたはMFPUを設定します。
CPPFLAGSを使用して渡されたMCPUまたはMFPU設定を上書きしません。
一部のコンパイラでは、constraiantsのために`-mstrict-align`が必要になる場合があり、`CPPFLAGS`でユーザーがMCPU/MFPUフラグを渡さない限り、`-mstrict-align`もデフォルトで設定されます。

### `--disable-tlsv12`

TLS 1.2のサポートを無効にします。

### `--enable-tls13`

TLS 1.3サポートを有効にします。

このビルドオプションを[`--disable-tlsv12`](#--disable-tlsv12)および[`--disable-oldtls`](#--disable-oldtlx)と組み合わせて、TLS 1.3のみのwolfSSLビルドを生成できます。

### `--enable-all`

SSL v3を除くすべてのwolfSSL機能を有効にします。

### `--enable-xts`

AES-XTSモードを有効にします。

### `--enable-asio`

ASIOを有効にします。

一緒に[`--enable-opensslextra`](#--enable-opensslextra)と[`--enable-opensslall`](#--enable-opensslall)を有効にする必要があります。
これら2つのオプションが有効になっていない場合、autoconfツールは自動的にこれらのオプションを有効にします。

### `--enable-qt`

Qt 5.12以降のサポートを有効にします。

wolfSSL QTポートと互換性のあるwolfSSLビルド設定を有効にします。
QTソースファイルにパッチを当てるには、wolfSSLが提供するパッチファイルが必要です。

### `--enable-qt-test`

Qtテスト互換ビルドを有効にします。

組み込みのQTテストの実行との互換性のために、wolfSSLをビルドするためのサポートを有効にします。

### `--enable-apache-httpd`

Apache httpdサポートを有効にします。

### `--enable-afalg`

ハードウェアアクセラレーション用のLinuxモジュールAF\_ALGの使用を有効にします。
Xilinxでの追加使用は`=xilinx`、`=xilinx-rsa`、`=xilinx-aes`、`=xilinx-sha3`で可能です。

[`--enable-devcrypto`](#--enable-devcrypto)と同様に、暗号操作のオフロードのためにLinuxカーネルモジュール（AF\_ALG）を活用します。
一部のハードウェアでは、Linuxの暗号ドライバを通じてパフォーマンス加速が可能です。
PetalinuxとXilinxの場合、フラグ`--enable-afalg=xilinx`を使用して、AF\_ALGのXilinxインターフェースを使用するようにwolfSSLに指示できます。

### `--enable-devcrypto`

ハードウェアアクセラレーション用のLinux `/dev/crypto`の使用を有効にします。

`aes`（すべてのaesサポート）、`hash`（すべてのハッシュアルゴリズム）、および`cbc`（aes-cbcのみ）の任意の組み合わせを引数で指定できます。
オプションが指定されていない場合、デフォルトで`all`を使用します。

### `--enable-mcast`

wolfSSL DTLSマルチキャストサポートを有効にします。

### `--disable-pkcs12`

PKCS12コードを無効にします。

### `--enable-fallback-scsv`

シグナリング暗号スイート値(SCSV)を有効にします。

### `--enable-psk-one-id`

TLS 1.3を使用した単一のPSK IDのサポートを有効にします。

### `--enable-cryptocb`

暗号コールバックを有効にします。
wc_CryptoCb_RegisterDeviceを使用して暗号コールバックを登録し、wolfSSL_CTX_SetDevidを使用して関連付けられているdevidを設定します。
`--enable-cryptocb`で次の2つの定義を使用して、RSAまたはECCソフトウェアフォールバックをコンパイルして、ソフトウェアRSA/ECCが不要な場合のフットプリント削減のために最適化できます。

* WOLF\_CRYPTO\_CB\_ONLY\_RSA  -  RSAソフトウェア暗号フォールバックをコンパイルアウトします。
* WOLF\_CRYPTO\_CB\_ONLY\_ECC  -  ECCソフトウェア暗号フォールバックをコンパイルアウトします。

WOLF\_CRYPTO\_CB\_ONLY\_*オプションを使用するには、サンプルプログラムのビルドを無効にする必要があります。
[`--disable-examples`](#disable-examples)を参照してください

### `--enable-reproducible-build`

バイナリジッター(タイムスタンプやその他の非機能メタデータ)を抑制し、同一のハッシュを持つビット単位で同一のバイナリパッケージを生成できるようにします。

### `--enable-sys-ca-certs`
wolfSSLが`wolfSSL_CTX_load_system_CA_certs()`が呼び出されたときに、検証のために信頼されたシステムCA証明書を使用できるようにします。
これは、wolfSSL証明書マネージャーにそれらをロードするか、システム認証APIを呼び出すことによって行われます。
詳細については、`wolfSSL_CTX_load_system_CA_certs()`を参照してください。

## 特別な数学最適化フラグ

### `--enable-fastmath`

FastMath の実装を有効にします。 
単精度(SP)演算が有効な場合、FastMath と Big Integer ライブラリの両方が無効になります。

USE_FAST_MATHおよびBig Integer Math Library節を参照してください。

### `--enable-fasthugemath`

Fast Math +巨大なコードを有効にします。

FastHugeMathの有効化にはFastMathライブラリのサポートが含まれます。
公開鍵に関する実装に一般的な鍵サイズのループを展開することで、コードサイズが大幅に増加します。
fasthugemathを使用する前後でベンチマークユーティリティを実行して、わずかな速度向上がコードサイズの増加に見合うかどうかをご確認ください。

### `--enable-sp-math`

制限されたアルゴリズムスイートを使用した単精度(SP)数学実装を有効にします。
サポートされていないアルゴリズムは無効になっています。
`--enable-sp`、`--enable-sp-math-all`、`--enable-fastmath`、`--enable-fasthugemath`よりも優先されます。

- 整数ライブラリーの実装を `sp_int.c` の実装に置き換えます。
- 最小限の実装で、`sp_int.c` の一部を有効にしますが、すべてではありません。
- RSA/ECC/DH操作を実行できるようにするには、`--enable-sp`と組み合わせて、`sp_x86_64.c`や`sp_arm.c`などのソリューション（ターゲットシステムに応じた以下のファイルリスト）をオンにする必要があります。
- `--enable-sp-math-all` (下記) と組み合わせてはいけません

ファイルリスト (プラットフォームに依存します。システムの仕様に基づいて構成によって選択されるか、Makefile/IDE ソリューションを使用する場合は手動で制御できます):

- sp_arm32.c
- sp_arm64.c
- sp_armthumb.c
- sp_cortexm.c
- sp_dsp32.c
- sp_x86_64.c
- sp_x86_64_asm.S
- sp_x86_64_asm.asm

### `--enable-sp-math-all`

デフォルトで有効になっています。
完全なアルゴリズムスイートを持つ単精度（SP）数学実装を有効にします。
サポートされていないアルゴリズムが有効になっていますが、最適化されていません。 
`--enable-sp`、`--enable-fastmath`、`--enable-fasthugemath` よりも優先されます。

- 数学の実装を `sp_int.c` の実装に置き換えます。
- 完全な実装であり、 `--enable-sp` の動作に依存しません
- `--enable-sp` と組み合わせて、可能であれば、32 ビットの `sp_c32.c` または 64 ビットの `sp_c64.c` で移植可能な C アセンブリ (ハードウェア固有でないアセンブリ) で記述された実装を使用できるようにすることができます。 それ以外(不可能な場合) には、`sp_int.c` の実装が使用されます。 移植可能な C アセンブリは、ハードウェアの最適化が利用できないターゲットでパフォーマンスを大幅に向上させます。
- `--enable-sp-math` (上記) と組み合わせてはいけません

**注**: 鍵の長さがビット [256, 384, 521, 1024, 2048, 3072, 4096] の非対称暗号を使用している場合は、最大のパフォーマンスを得るために `--enable-sp-math` オプションの使用をご検討ください。ただしフットプリントサイズは大きくなります。

### `--enable-sp-asm`

単精度(SP)アセンブリの実装を有効にします。

Intel x86_64およびARMアーキテクチャを使用したアセンブリを通して、単精度性能の向上を可能にするために使用できます。

### `--enable-sp=OPT`

RSA、DH、およびECCの単一精度(SP)数学を有効にして、パフォーマンスを改善します。

+OPT には多くの値を設定できます。
以下は、enable-sp を呼び出す方法と、結果として定義される結果のマクロのリストです。
これらはすべて、カンマ区切りのリストで組み合わせることができます。
例えば、`--enable-sp=ec256,ec384`のようにします。
定義されるマクロの意味は、上記の「wolfSSL独自の単精度(SP)数学サポート」節に記載しています。

**注**:
1) `--enable-sp=small --enable-sp-math` を使用することで、より小さくできる可能性があります。
2) `--enable-sp-math-all=small`...

(1)は特定のキーサイズのみ実装しているのに対し、(2)はすべてのキーサイズをサポートする実装を持っているためです。

**注**：これはx86_64用で、他の構成フラグはありません。結果は、指定するアーキテクチャやその他の構成フラグによって異なる場合があります。たとえば、`WOLFSSL_SP_384`と`WOLFSSL_SP_4096`は、Intel X86_64に対してのみ有効になります。

#### `--enable-sp=no`または`--disable-sp`

新しいマクロは定義されません。
`--enable-sp`を使用しないのと同等です。

#### `--enable-sp`または`--enable-sp=yes`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_SP_384
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE

#### `--enable-sp=small`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_4096
* WOLFSSL_SP_384
* WOLFSSL_SP_4096
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_384

#### `--enable-sp=smallfast`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_4096
* WOLFSSL_SP_384
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_FAST_MODEXP

#### `--enable-sp=ec256`または`--enable-sp=p256`または`--enable-sp=p256`

* WOLFSSL_HAVE_SP_ECC

#### `--enable-sp=smallec256`または`--enable-sp=smallp256`または`--enable-sp=small256`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec384`または`--enable-sp=p384`または`--enable-sp=384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec384`または`--enable-sp=smallp384`または`--enable-sp=small384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec1024`または`--enable-sp=p1024`または`--enable-sp=1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec1024`または`--enable-sp=smallp1024`または`--enable-sp=small1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=2048`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=small2048`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=3072`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=small3072`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa3072`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=smallrsa3072`

* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=4096` または `--enable-sp=+4096`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072

#### `--enable-sp=small4096`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa4096`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa4096`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=nomalloc`

* WOLFSSL_SP_NO_MALLOC

#### `--enable-sp=nonblock`

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK
* WOLFSSL_SP_SMALL

#### `asm`

他のアルゴリズムオプションと組み合わせて、それらのオプションに対してアセンブリコードがオンになっていることを示します。
例えば、`--enable-sp=rsa2048,asm`のように設定します。

## クロスコンパイル

組み込み機器プラットフォーム上の多くのユーザーは、wolfSSLをクロスコンパイルしています。
ライブラリをクロスコンパイルさせる最も簡単な方法は、`./configure`システムを使用することです。
MakeFileを生成し、wolfSSLをビルドするために使用できます。

クロスコンパイルを行う場合、次のように`./configure`にホストを指定する必要があります。

```sh
./configure --host=arm-linux
```

また、使用するコンパイラ、リンカーなどを指定する必要がある場合があります。

```sh
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```

mallocをオーバーライドしていることを検出し、
`rpl_malloc`および/または`rpl_realloc`についてconfigureシステムがエラーを報告することがあります。

未定義参照が発生する場合は、`./configure`に以下を追加してください。

```sh
ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
```

クロスコンパイルのためにwolfSSLを正しく設定した後は、ライブラリのビルドとインストールのための標準的なautoconfの手順に従うことができるはずです。

```sh
make
sudo make install
```

wolfSSLのクロスコンパイルに関する追加のヒントやフィードバックがある場合は、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお知らせください。

### サンプルツールチェーンを使ったクロスコンパイルのコンフィグオプション例

#### armebv7-eabihf-glibc

```sh
./configure --host=armeb-linux \
        CC=armeb-linux-gcc LD=armeb-linux-ld \
        AR=armeb-linux-ar \
        RANLIB=armeb-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv5-eabi-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv6-eabihf-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv7-eabihf-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv7m-uclibc

```sh
./configure --enable-static --disable-shared \
        --host=arm-linux CC=arm-linux-gcc \
        LD=arm-linux-ld AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### arm-none-eabi-gcc

```sh
./configure --host=arm-none-eabi \
        CC=arm-none-eabi-gcc LD=arm-none-eabi-ld \
        AR=arm-none-eabi-ar RANLIB=arm-none-eabi-ranlib \
        CFLAGS="-DNO_WOLFSSL_DIR \
        -DWOLFSSL_USER_IO -DNO_WRITEV \
        -mcpu=cortex-m4 -mthumb -Os \
        -specs=rdimon.specs" CPPFLAGS="-I./"
```

#### mips32--glibc

```sh
./configure --host=mips-linux \
        CC=mips-linux-gcc LD=mips-linux-ld \
        AR=mips-linux-ar \
        RANLIB=mips-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### PowerPC64LE-POWER8-GLIBC

```sh
./configure --host=powerpc64le-buildroot-linux-gnu \
        CC=powerpc64le-buildroot-linux-gnu-gcc \
        LD=powerpc64le-buildroot-linux-gnu-ld \
        AR=powerpc64le-buildroot-linux-gnu-ar \
        RANLIB=powerpc64le-buildroot-linux-gnu-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### x86-64-core-i7-glibc

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### x86-64-core-i7-musl

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \CPPFLAGS="-I./"
```

#### x86-64-core-i7-uclibc

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

## 移植向けビルド

wolfSSLは多くの環境やデバイスに移植（ポート）されています。
これらのポートの一部とそれらのマニュアルはディレクトリ`wolfSSL-X.X.X/IDE`にあります。
ここで、x.x.xは現在のwolfSSLバージョン番号です。
このディレクトリには、環境用のwolfSSLをビルドするために使用されているIDEの有用な情報とコードも含まれています。

ポートリスト：

* Arduino
* LPCXPRESSO
* Wiced Studio
* CSBench
* SGX WindowsとLinux
    * これらのディレクトリ(`wolfSSL/IDE/WIN-SGX`および`wolfSSL/IDE/LINUX-SGX`)には、Intel SGXプロジェクトで使用されるライブラリとしてwolfSSLをビルドするためのMakefilesおよびVisual Studioソリューションが含まれています。
* Hexagon
    * このディレクトリ(`wolfSSL/IDE/HEXAGON`)には、Hexagonツールチェーンを備えたビルド用のMakeFileが含まれています。ECC検証操作をDSPプロセッサにオフロードするためのwolfSSLをビルドするために使用できます。ディレクトリには、ビルドに必要な手順を支援するReadMeファイルが含まれています。
* Hexiwear
* NetBurner M68K
    * ディレクトリ(`wolfSSL/IDE/M68K`)には、NetBurner RTOを使用してMCF5441Xデバイス用のwolfSSLをビルドするためのMakeFileがあります。
* Renesas
    * このディレクトリ(`wolfSSL/IDE/Renesas`)は、ルネサスデバイスの異なる複数のビルドを含みます。ハードウェアアクセラレーションを使用して実証するビルド例もあります。
* XCode
* Eclipse
* Espressif
* IAR-EWARM
* Kinetis Design Studio(KDS)
* Rowley Crossworks ARM
* OpenSTM32
* RISCV
* Zephyr
* mynewt
* INTIME-RTOS

## NXP CAAM向けのビルド

### i.MX8(Linux)

#### 既知の問題

- HSMセッション(wc_SECO_CloseHSMおよびwolfSSL_CLeanupまたはwolfCrypt_Cleanup)を閉じる前に、開いているHSMキーストアセッションを終了すると、次回NVMを起動したときにセグメンテーションフォールトが発生します。 これを回避するには、電源を入れ直す必要があります。

#### 制限事項

- 多量の入力（１MByte）を扱うSECOでのAES操作は”共有メモリに十分なスペースがありません”とエラーになります。
- 2つの鍵ストアを生成した後、3つ目を生成しようとすると失敗します。鍵ストアをリセットするために`rm -rf /etc/seco_hsm`を実行し電源を再投入してください。

#### イントロ

i.MX8デバイスには、高度なセキュリティのためのSECOハードウェアモジュールが用意されています。
このモジュールはAES操作とキーストレージ、限定的なECC操作とキーストレージを処理し、RNGを提供します。
wolfSSLは可能な限りSECOを利用するように拡張されています。

一部のアルゴリズムはi.MX8のCAAMでサポートされていますが、SECOモジュールではまだサポートされていません。
これらのケースでは、wolfSSLは/dev/cryptoを通じてLinux CAAMドライバーを呼び出し、CAAMに直接ジョブを作成します。

NXP Linux CAAMドライバーではデフォルトでサポートされているアルゴリズムもありますが、CAAMがサポートするすべてのアルゴリズムがサポートされているわけではありません。
wolfSSLはLinux CAAMドライバーを拡張して、追加のアルゴリズムのサポートを追加しています。

同じアプリケーションから両方の経路でCAAMにアクセスするには、異なるコードパスに関連付けられた`devId`を`WOLFSSL_CAAM_DEVID`または`WOLFSSL_SECO_DEVID`のいずれかに設定できます。
これらのIDは、構造体を最初に初期化する際に使用され、構造体の存続期間中に使用されるコードパスを設定します。
ソフトウェアのみを使用する場合は、デフォルトの`INVALID_DEVID`を設定する必要があります。
この例外は、キーストアを使用しないSECO項目です：TRNGおよびハッシュ。

使用されたソフトウェアのバージョンは以下のとおりです。

- imx-seco-libs ブランチ imx_5.4.24_2.1.0
- NXP「repo」ツールとYoctoビルド
- wolfSSL 5.2.0以降（5.2.0リリース後に開発したためです）

#### サポートされるアルゴリズム

サポートされるアルゴリズム、モード、オペレーションとして、以下を含みます。

- AES (ECB, CBC, CCM, GCM)
- AES CMAC
- SHA256, SHA384
- ECC 256/384（鍵生成、署名、検証、ecdh）
- RSA 3072（鍵生成、署名、検証）
- HMAC
- Curve25519
- TRNG

#### イメージのビルド

##### "repo"セットアップ

以下に示すNXP「repo」コマンドツールのセットアップは、Ubuntu 18.04 LTSで実施しました。

```sh
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib
sudo apt-get install build-essential chrpath socat cpio python python3 python3-pip
sudo apt-get install python3-pexpect xz-utils debianutils iputils-ping python3-git
sudo apt-get install python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm curl
sudo apt-get install ca-certificates
```

```sh
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

git config --global user.name "Your Git Name"
git config --global user.email "Your Email"
```

2022年1月11日現在、GitHubは認証されていないGit接続を許可しなくなりました。
このドキュメントが作成された時点 (2022年3月) では、NXPのリポジトリツールはこれをまだ考慮していません。
この問題を回避するには、次のコマンドを使用してgit://github.com/ を https://github.com/ にリダイレクトしてください。

```sh
git config --global url."https://github.com/".insteadOf git://github.com/
```

ビルド用のディレクトリを作成します。

```sh
mkdir imx-yocto-bsp
cd imx-yocto-bsp/
```

NXPの「repo」コマンドツールを設定した後、目的のLinuxバージョンでディレクトリを初期化して同期します。この場合は5.4.24_2.1.0です。

```sh
repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-zeus -m imx-5.4.24-2.1.0.xml
repo sync

DISTRO=fsl-imx-wayland MACHINE=imx8qxpc0mek source imx-setup-release.sh -b build-xwayland
```

##### 追加のYocto CAAM レイヤー

次に、cryptodev-module、cryptodev-linux、および`linux-imx/drivers/crypto/caam/*`のファイルにパッチを適用するCAAMドライバー拡張レイヤーをダウンロードします。
ベースblobとECDSA（署名/検証/鍵生成）は[こちら]https://source.codeaurora.org/external/imxsupport/imx_sec_apps/）にあります。
RSAブラックキー、ECDH、およびCurve25519サポートを持つ拡張レイヤーは`meta-imx-expand-caam`です。
これらのディレクトリを他の既存の`meta-*`ディレクトリの横にある`sources`ディレクトリに配置します。

```sh
# 直前のコマンドのbuild-xwayland ディレクトリに居る想定

# クローンするかあるいはzipファイルを解凍
git clone -b caam_expansion https://github.com/JacobBarthelmeh/imx_sec_apps
cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
cp -r imx_sec_apps/meta-imx-expand-caam ../sources/

# あるいは

git clone https://source.codeaurora.org/external/imxsupport/imx_sec_apps.git
# "meta-imx-expand-caam" はwolfSSLが提供します
unzip meta-imx-expand-caam.zip

cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
mv meta-imx-expand-caam ../sources/
```

これらのレイヤーをビルドに追加します。
最初にecdsaを、次にCAAM拡張を追加します。

```sh
vim conf/local.conf
EXTRA_IMAGE_FEATURES_append = " dev-pkgs tools-sdk tools-debug ssh-server-openssh "
IMAGE_INSTALL_append = " cryptodev-module cryptodev-linux eckey "
```

このビルドではデバッグツールとSSHサーバーを追加しましたが、必ずしも必要ではありません。
追加する重要な項目は`cryptodev-module`と`cryptodev-linux`です。
`eckey`は、BLOBのカプセル化とカプセル化解除を行うためのNXPのデモツールです。

**オプション**: cryptodevモジュールの自動ロードを追加するには、次の行を`conf/local.conf`に追加します。

```sh
KERNEL_MODULE_AUTOLOAD += "cryptodev"
```

それ以外の場合は、電源を入れ直すたびに`modprobe cryptodev`を使用してモジュールをロードする必要があります。

##### ビルドとデプロイ

イメージのビルドの開始には次のコマンドを使います。
そのあとで、もしSDカードを使っているならばカードに書き込みます。

```sh
bitbake core-image-base

cd tmp/deploy/images/imx8qxpc0mek/
bzcat core-image-base-imx8qxpc0mek.sdcard.bz2 | sudo dd of=/dev/diskX bs=5m
```
注: `5m`はmacOSの場合に使用し、Linuxの場合は`5M`を使用します。`diskX`はSDカードの場所、つまりMacであれば`disc2`、Linuxであれば`sdbX`に置き換える必要があります。実行する前に、SDカードのディスク番号を確認してください。

後ほど`wolfSSL/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```sh
export CRYPTODEV_DIR=`pwd`/tmp/sysroots-components/aarch64/cryptodev-linux/usr/include/
```

クロスコンパイルのためにツールチェーンをインストールするに、次のYoctoコマンドを使用します。

```sh
bitbake meta-toolchain
sudo ./tmp/deploy/sdk/<version>.sh
```

#### NXP HSMのビルド

##### zlibのビルド

これを行うには複数の方法があり、その一つはYoctoビルドに追加する方法です。bitbakeを使用してビルドする方法は次のとおりです。

```sh
cd build-xwayland
bitbake zlib
```

このコマンドは実行結果を`tmp/sysroots-components/aarch64/zlib/usr/`ディレクトリに配置します。

後ほど`wolfSSL/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```sh
export ZLIB_DIR=`pwd`/tmp/sysroots-components/aarch64/zlib/usr/
```

##### NXP HSMライブラリのビルド

NXP HSM ライブラリをダウンロードし、必要なzlibが見つかるようにMakefileや環境変数を調整します。

```sh
git clone https://github.com/NXP/imx-seco-libs.git
cd imx-seco-libs
git checkout imx_5.4.24_2.1.0
```

```sh
vim Makefile
CFLAGS = -O1 -Werror -fPIC -I$(ZLIB_DIR)/include -L$(ZLIB_DIR)/lib
```

さらに

```sh
make
make install
```

後ほど`wolfSSL/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```sh
export HSM_DIR=`pwd`/export/usr/
```

`make install` を行うとデフォルトで結果を`export`サブディレクトリに配置します。

#### wolfSSLのビルド

##### Autoconfを使用したビルド

開発ツールを使用してYoctoイメージをセットアップすると、wolfSSLをシステム上に直接構築できます。
より最小限のアプローチとして、クロスコンパイルを使用できます。

デバッグメッセージは `--enable-debug` で有効にできます。
SECO作業に固有の追加のデバッグメッセージは、マクロ`DEBUG_SECO`を定義し、`/dev/crypto`呼び出しの`DEBUG_DEVCRYPTO`を定義することで有効にできます。
どちらの追加のデバッグメッセージもprintfを使用し、stdoutパイプに出力します。

SECOで使用するための重要な有効化オプションがいくつかあります。 
`--enable-caam=seco`、`--enable-devcrypto=seco`、`--with-seco=/hsm-lib/export`などです。

HSM SECO のみを使用したビルド例 (追加アルゴリズムのdevcryptoサポートなし)

```sh
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

# wolfSSLのビルドで依存しているコンポーネントをインストール
sudo apt-get install autoconf automake libtool

./autogen.sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \ --enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB"
make
```

HSM SECOと追加のdevcryptoサポートを使ってのビルド例。
インクルードパスとして`crypto/cryptpdev.h`を指定する必要があります。

```sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR" --enable-devcrypto=seco \
--enable-curve25519
make
```

`wolfCrypt_Init` / `wolfSSL_Init`関数呼び出しで早期にエラーを出すフェイルセーフがあります。
一つのケースは、cryptodevモジュールがロードされていないか、目的の操作に利用可能なサポートがない場合です。
初期化操作が失敗する可能性がある別のケースは、NXP HSMをセットアップできなかった場合です。

アプリケーションが初期化に失敗している場合、wolfSSLビルドに`--enable-debug`を追加し、wolfSSLの初期化前に`wolfSSL_Debugging_ON()`関数呼び出しを行うと、失敗の理由に関する有用なデバッグメッセージが表示されます。

デバッグオプションを有効にしてビルドする例

```sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR -DDEBUG_SECO -DDEBUG_DEVCRYPTO" \
--enable-devcrypto=seco --enable-curve25519
```

##### user_settings.hを使用したビルド

autotoolsなしでビルドするために有効にできるマクロは次のとおりです。

***CAAM***

- `WOLFSSL_CAAM` - CAAMサポートを有効にするメインマクロスイッチ。
- `WOLF_CRYPTO_CB` - CAAMサポートは暗号コールバックを利用します。
- `WOLFSSL_SECO_CAAM` - CAAMでのSECO HSM使用を有効にします（AES-GCMが必要で、平文鍵をHSMにインポートするためのアルゴリズムとして使用されます）。
- `WOLFSSL_HASH_KEEP` - SHA256などのアルゴリズムでハッシュする場合、メッセージを構築し、Final呼び出し時にのみハッシュするために送信します。
- `WOLFSSL_CAAM_ECC` - CAAM ECCサポートを有効にします。
- `WOLFSSL_CAAM_CMAC` - CAAM CMACサポートを有効にします。
- `WOLFSSL_CAAM_CIPHER` - CAAM AESサポートを有効にします。
- `WOLFSSL_CAAM_HMAC` - CAAM HMACサポートを有効にします。
- `WOLFSSL_CAAM_HASH` - SHA256などのCAAMハッシングサポートを有効にします。
- `WOLFSSL_CAAM_CURVE25519` - CAAM Curve25519サポートを有効にします。

***cryptodev-linux***

- `WOLFSSL_DEVCRYPTO` - `cryptodev-linux`使用を有効にするメインマクロスイッチ。
- `WOLFSSL_DEVCRYPTO_HMAC` - `cryptodev-linux`でのHMACサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_RSA` - `cryptodev-linux`でのRSAサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_CURVE25519` - `cryptodev-linux`でのCurve25519サポートを有効にします。
- `WOLFSSL_DEVCRYPTO_ECDSA` - `cryptodev-linux`でのECDSAサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_HASH_KEEP` - `cryptodev-linux`でのハッシュ蓄積サポートを有効にします。

***CAAMサポートのためにコンパイルする必要がある追加ファイル***

- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_aes.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_cmac.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_rsa.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_ecdsa.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_x25519.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_hash.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_hmac.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_init.c`
- `wolfSSL/wolfcrypt/src/port/caam/wolfcaam_seco.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_ecdsa.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_x25519.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_rsa.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_hmac.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_hash.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/devcrypto_aes.c`
- `wolfSSL/wolfcrypt/src/port/devcrypto/wc_devcrypto.c`
- `wolfSSL/wolfcrypt/src/cryptocb.c`


#### サンプルプログラム

##### Testwolfcryptの実行

wolfSSLにバンドルされている単体テストは、`wolfcrypt/test/test.c`にあります。
デバイス上でテストを構築して実行する例は次のとおりです。
これは`WOLFSSL_CAAM_DEVID`を使用するため、NXP HSMライブラリではなくcryptodevモジュールを使用していることにご注意ください。

```sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR \
--with-seco=$HSM_DIR --enable-caam=seco --enable-cmac --enable-aesgcm \
--enable-aesccm --enable-keygen CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR" \
--enable-devcrypto=seco --enable-curve25519 --enable-sha224 --enable-static \
--disable-shared --disable-filesystem
make

scp wolfcrypt/test/testwolfcrypt root@192.168.0.14:/tmp
ssh root@192.168.0.14
root@imx8qxpc0mek:~# /tmp/testwolfcrypt
------------------------------------------------------------------------------
 wolfSSL version 5.2.0
------------------------------------------------------------------------------
error	test passed!
MEMORY   test passed!
base64   test passed!
asn  	test passed!
RANDOM   test passed!
MD5  	test passed!
SHA  	test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-3	test passed!
Hash 	test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
HMAC-SHA3   test passed!
HMAC-KDF	test passed!
GMAC 	test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES  	test passed!
AES192   test passed!
AES256   test passed!
AES-GCM  test passed!
AES-CCM  test passed!
RSA  	test passed!
DH   	test passed!
PWDBASED test passed!
ECC  	test passed!
ECC buffer test passed!
CURVE25519 test passed!
CMAC 	test passed!
COMPRESS test passed!
logging  test passed!
time test passed!
mutex	test passed!
memcb	test passed!
crypto callback test passed!
Test complete
Exiting main with return code: 0
root@imx8qxpc0mek:~#
```

そのほかのサンプルプログラムを、wolfSSL-examplesリポジトリの`caam/seco`ディレクトリ配下に用意しています。

```sh
git clone https://github.com/wolfSSL/wolfSSL-examples
cd wolfSSL-examples/caam/seco
make
```

##### ソースコードをコンパイル[user_settings.hを使用]

wolfSSLにリンクする単一のソースファイルを構築するには、次のコマンドを使用します。
前のステップの環境変数がまだ設定されていると仮定します。

```sh
source /opt/fsl-imx-xwayland/5.4-zeus/environment-setup-aarch64-poky-linux

$CC -DWOLFSSL_USER_SETTINGS -I /path/to/user_settings.h \
-I $CRYPTODEV_DIR -I $HSM_DIR/include -I ./wolfSSL server-dtls.c \
libwolfSSL.a $HSM_DIR/lib/hsm_lib.a $HSM_DIR/lib/seco_nvm_manager.a \
$ZLIB_DIR/lib/libz.a -lpthread -lm
```

#### API

##### 追加されたAPI

- `void wc_SECO_AesSetKeyID(Aes* aes, int keyId);`  
    - この関数はSECOキーIDを`Aes`構造体にセットする際に使用します。
    - `Aes`構造体が初期化された後で、暗号化/復号操作に使用される前に呼び出される必要があります。

- `int wc_SECO_AesGetKeyID(Aes* aes);`  
    - `Aes`構造体にセットされているSECOキーIDのゲッター関数です。

- `void wc_SECO_CMACSetKeyID(Cmac* cmac, int keyId);`  
    - `wc_SECO_AesSetKeyID`関数と似ていますが、対象が`Cmac`構造体になっています。

- `int wc_SECO_CMACGetKeyID(Cmac* cmac);`  
    - `Cmac`構造体にセットされているSECOキーIDのゲッター関数です。

- `int wc_SECO_OpenHSM(word32 keyStoreId, word32 nonce, word16 maxUpdates, byte flag);`  
    - この関数はキーストアが必要となるどの操作（ECCやAES）の前に呼び出される必要があります。  
    - 最初の引数はキーストアID、`nonce`は特定の32ビットの連番で、キーストアを新規に作成する場合や、既存のキーストアをアンロックするのに使用されます。  
    - `maxUpdates`はキーストアが更新できる最大回数を指定します。  
    - `flag`はオプショナルフラグで、キーストアが生成されているのかを示すために使用されます。  
    - HSMキーストアを生成するためには`flag`は`CAAM_KEYSTORE_CREATE`でなければなりません。  
    - `CAAM_KEYSTORE_UPDATE`は既存のキーストアをオープンし更新します。

- `int wc_SECO_CloseHSM(void);`  
    - この関数は、キーストアの使用が完了したとき、`wolfCrypt_Cleanup`/`wolfSSL_Cleanup`を呼び出す前に呼び出す必要があります。  
    - 現在オープンしているキーストアを閉じます。

- `int wc_SECO_GenerateKey(int flags, int group, byte* out, int outSz, int keyType, int keyInfo, unsigned int* keyIdOut);`  
    - この関数は、SECOで新しいキーを生成するために使用できます。  
    - キー生成の場合、`flags`は`CAAM_GENERATE_KEY`である必要があります。  
    - キーを更新する場合、`flags`は`CAAM_UPDATE_KEY`である必要があります。  
    - `keyIdOut`引数は、キーの作成時に設定される入出力引数であり、キーの更新時に入力として設定する必要があります。  
    - キーを更新する場合は、一時的なタイプである必要があり、更新のために`group`を0に設定する必要があります。  
    - 一時的なタイプは`keyInfo`引数として設定されます。  
    - `keyInfo`と`keyType`の可能なオプションは以下のとおりです。
        - `CAAM_KEY_TRANSIENT` (`keyInfo`)  
        - `CAAM_KEY_PERSISTENT` (`keyInfo`)  
        - `CAAM_KEYTYPE_ECDSA_P256` (`keyType`)  
        - `CAAM_KEYTYPE_ECDSA_P384` (`keyType`)  
        - `CAAM_KEYTYPE_AES128` (`keyType`)

- `int wc_SECO_DeleteKey(unsigned int keyId, int group, int keyTypeIn);`  
    - キーストアから鍵を削除するのに使用されます。


##### CAAMをサポートするネイティブwolfSSL API

これは、このドキュメントで概説されているSECOビルドでCAAMサポートを備えたネイティブwolfSSL APIのリストです。

AES暗号化と復号化操作の生成には、次のプロセスで鍵を生成できます。  
`wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut)`を使用します。  
ここで`groupID`は指定されたグループ番号、`pubOut`は32バイトのバッファ、変数`keyIdOut`は生成された新しい鍵IDに設定されます。  
この生成された新しい鍵IDは、`wc_SECO_AesSetKeyID(Aes, keyIdOut)`を使用して`Aes`構造体に設定できます。  
鍵IDが構造体に設定され、`Aes`構造体が`WOLFSSL_SECO_DEVID`タイプとして初期化されると、すべての暗号化および復号化操作にその鍵IDが使用されます。

###### ***AES (ECB/CBC)***

AES ECB/CBC鍵を生成する代わりに、`Aes`構造体が`WOLFSSL_SECO_DEVID`で初期化されている場合は、プレーンテキストキーを渡して関数`wc_AesSetKey`を呼び出すことができます。  
API `wc_AesSetKey`は、一意の`KEK`を使用して鍵を暗号化し、`SECO HSM`にインポートしようとします。  
インポートが成功すると、値`0`が返され、鍵IDが`Aes`構造体に設定されます。

- CBC暗号化は`wc_AesCbcEncrypt`で行われ、復号は`wc_AesCbcDecrypt`で行われます。
- ECB暗号化は`wc_AesEcbEncrypt`で行われ、復号は`wc_AesEcbDecrypt`で行われます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes)`を使用して解放する必要があります。

###### ***AES-GCM***

- GCM暗号化は`wc_AesGcmEncrypt`で行われ、復号は`wc_AesGcmDecrypt`で行われます。

AES-GCM暗号化関数は、`Aes`構造体、出力バッファ、入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト必要)、MACまたはタグとして知られる、タグサイズ(`16`バイトが必要)、追加データ、追加データサイズ（4バイト）を引数として取ります。  
暗号化の場合、入力バッファは暗号化され、タグバッファは作成された`MAC`で埋められます。

AES-GCM復号の場合、関数は`Aes`構造体、プレーンテキスト出力バッファ、暗号テキスト入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト)、暗号化呼び出しで以前に作成されたタグ、タグバッファサイズ、追加データ、追加のデータサイズを引数として取ります。  
復号化時にタグバッファがチェックされ、メッセージの整合性が検証されます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes)`を使用して解放する必要があります。

###### ***AES-CCM***

- CCM暗号化は`wc_AesCcmEncrypt`、復号は`wc_AesCcmDecrypt`で行われます。

AES-CCM暗号化関数は、`Aes`構造体、出力バッファ、入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ (12 バイトが必要)、MACまたはタグとして知られる、タグサイズ(16バイト必要)、 追加データ、追加データサイズ（0バイト）を引数として取ります。
追加のデータバッファは `NULL`にする必要があり、NXP HSMライブラリではサイズ 0 が必要です。 
暗号化の場合、入力バッファは暗号化され、タグバッファは作成されたMACで埋められます。

AES-CCM復号の場合、関数は`Aes`構造体、プレーンテキスト出力バッファ、暗号テキスト入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト)、暗号化呼び出しで以前に作成されたタグ、タグバッファサイズ、追加データ、 追加のデータサイズを引数に取ります。
暗号化関数と同様に、追加のデータバッファーは`NULL`である必要があります。
復号時にタグバッファがチェックされ、メッセージの整合性が検証されます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes)`を使用して解放する必要があります。

###### ***AES CMAC***

AES CMAC操作の場合、`wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut);` を使用してAES鍵を生成できます。
ここで、`groupID`は指定されたグループ番号、`pubOut`は32バイトのバッファーであり、変数`keyIdOut`は生成された新しいキーIDに設定されます。
生成されたこの新しいキーID は、`wc_SECO_CMACSetKeyID(Cmac, keyIdOut)`を使用して`Aes`構造体に設定できます。
キーIDが構造内に設定され、Aes構造体が`WOLFSSL_SECO_DEVID`タイプとして初期化されると、すべての暗号化および復号化操作にそのキーIDが使用されます。

SMライブラリはシングル ショットタイプであるため、`wc_CmacUpdate`を呼び出すたびに入力が内部バッファに保存されます。
その後、`wc_CmacFinal`が呼び出されると、MACを作成するためにバッファ全体がハードウェアに渡されます。

###### ***RSA***

RSA操作では、cryptodev-linuxモジュールが使用されます。
これには、`WOLFSSL_CAAM_DEVID`で初期化されたときのデフォルトであるAES-ECB暗号化されたブラックプライベートキーのサポートが含まれます。

cryptodev-linuxモジュールで使用されるネイティブwolfSSL APIの例は次のとおりです。

```lang-c
wc_InitRsaKey_ex(key, heap-hint (can be NULL), WOLFSSL_CAAM_DEVID);
wc_MakeRsaKey(key, 3072, WC_RSA_EXPONENT, &rng);
wc_RsaSSL_Sign or wc_RsaPublicEncrypt
wc_RsaSSL_Verify or wc_RsaPrivateDecrypt
wc_FreeRsaKey(key)
```

###### ***ECC***

ECC署名および検証操作では、cryptodev-linuxモジュールまたは NXP HSMライブラリのいずれかを使用できます。
共有シークレットを作成するためのECDH操作は、cryptodev-linuxモジュールを使用してのみ実行できます。

SECOで使用する場合 (NXP HSMライブラリを使用)、`ecc_key`構造体を初期化するときに `WOLFSSL_SECO_DEVID`のdev IDフラグを使用する必要があります。cryptodev-linuxモジュールで使用するには、dev IDフラグ `WOLFSSL_CAAM_DEVID`を使用する必要があります。
関数 `wc_ecc_init_ec(key, heap-hint (NULL可), dev ID)` による初期化後、どちらのユースケースも、署名と検証を行うためのネイティブの wolfSSL関数呼び出しの同じ関数に従います。

`ecc_key`構造体の初期化後の関数呼び出しの例は次のようになります。

```lang-c
wc_ecc_make_key(&rng, ECC_P256_KEYSIZE, key);
wc_ecc_sign_hash(hash, hashSz, sigOut, sigOutSz, &rng, key);
wc_ecc_verify_hash(sig, sigSz, hash, hashSz, &result, key);
```

また、cryptodev-linuxモジュール(`WOLFSSL_CAAM_DEVID`)を使用すると、ECDH関数を使用できます。

```lang-c
wc_ecc_shared_secret(keyA, keyB, sharedSecret, sharedSecretSz);
```

###### ***ハッシュ (Sha256, Sha384, HMAC)***

SHA256およびSHA384の操作では、NXP HSMライブラリを使用します。
HMAC操作では、cryptodev-linuxモジュールが使用されます。

デフォルトでは、SHA操作は NXP HSMライブラリを利用しようとしますが、明示的にdev IDに設定すると、WOLFSSL_SECO_DEVIDを使用できます。

```lang-c
wc_InitSha256_ex(sha256, heap-hint, WOLFSSL_SECO_DEVID);
wc_InitSha384_ex(sha384, heap-hint, WOLFSSL_SECO_DEVID);
```

NXP HSMライブラリはハッシュのシングルショット操作をサポートしているため、"update"を呼び出すたびに"final"関数が呼び出されるまでバッファが保存され、その後ハッシュダイジェストを作成するためにバッファ全体がハードウェアに渡されます。
HMACが cryptodev-linuxを使用する場合、Hmac構造体はdev ID `WOLFSSL_CAAM_DEVID` を使用して初期化する必要があります。

```lang-c
wc_HmacInit(hmac, heap-hint, WOLFSSL_CAAM_DEVID);
```
その後、通常のネイティブwolfSSL APIと同じように使用できます。

```lang-c
wc_HmacSetKey(hmac, hash-type, key, keySz);
wc_HmacUpdate(hmac, input, inputSz);
wc_HmacFinal(hmac, digestOut);
```

###### ***Curve25519***

Curve25519ポイント乗算はcryptodev-linuxモジュールを使用して行われ、ハードウェアで使用するためにdev ID `WOLFSSL_CAAM_DEVID`で初期化する必要があります。

API 呼び出しの例は次のようになります。

```lang-c
wc_curve25519_init_ex(key, heap-hint, WOLFSSL_CAAM_DEVID);
wc_curve25519_make_key(&rng, CURVE25519_KEYSIZE,  key);
wc_curve25519_shared_secret(key, keyB, sharedSecretOut, sharedSecretOutSz);
```

###### ***RNG***

wolfSSL HASH-DRBGに乱数シードを与えるために使われるTRNGでは、NXP HSMライブラリを利用します。
これは、wolfSSLが`--enable-caam=seco`でビルドされるときに、`wolfcrypt/src/random.c`ファイルにコンパイルされます。
wolfSSLのすべてのRNG初期化では、シードにTRNGが使用されます。
標準のRNG API呼び出しは次のようになります。

```lang-c
wc_InitRng(rng);
wc_RNG_GenerateBlock(rng, output, outputSz);
wc_FreeRng(rng);
```

### i.MX8 (QNX)

(ドキュメントは現在準備中です。ご入用でしたら、 [info@wolfssl.jp](mailto:info@wolfssl.jp) までお問い合わせください。)

### i.MX6 (QNX)

(ドキュメントは現在準備中です。ご入用でしたら、 [info@wolfssl.jp](mailto:info@wolfssl.jp) までお問い合わせください。)

### IMXRT1170 (FreeRTOS)

IMXRT1170で使用するIDEセットアップの例は、`IDE/MCUEXPRESSO/RT1170` ディレクトリにあります。

#### ビルド手順

1. MCUEXPRESSOを開き、ワークスペースを`wolfSSL/IDE/MCUEXPRESSO/RT1170`に設定します。
2. ファイル -> ファイル システムからプロジェクトを開く... -> ディレクトリ : 参照先を `wolfSSL/IDE/MCUEXPRESSO/RT1170` ディレクトリに設定し、「ディレクトリの選択」をクリックします。
3. `wolfSSL_cm7`、`wolfcrypt_test_cm7`、`CSR_example`、`PKCS7_example`を選択します。
4. プロジェクトを右クリック -> SDK 管理 -> SDK コンポーネントを更新し、「はい」をクリックします。
5. `FreeRTOSConfig.h` の `configTOTAL_HEAP_SIZE` のサイズを、CSR および PKCS7 の例では 60240、`wolfcrypt_test_cm7` では約 100000 に増やします。
6. (ノートボードファイルを再作成する必要があります。これは、同じ設定を持つ新しいプロジェクトを作成し、生成された`board/*`ファイルをコピーすることで実行できます)
7. プロジェクトをビルドします。

#### RT1170 CAAM ドライバーの拡張

ファイル`RT1170/fsl_caam_h.patch`および`RT1170/fsl_caam_c.patch`には、Blobの作成/オープン、および ECC ブラックキーの生成と使用のための既存のNXP CAAMドライバーへの変更が含まれています。

パッチを適用するには、まずcaamドライバーを含むプロジェクトを作成します。
これにより、ドライバーディレクトリにベースとなる`fsl_caam.c`と`fsl_caam.h`が生成されます
(つまり、`PKCS7_example_cm7/drivers/fls_caam.{c,h}`)。 
基本ファイルが生成されたら、ドライバー ディレクトリに"cd"してパッチを適用します。

```
cd PKCS7_example_cm7/drivers/
patch -p1 < ../../fsl_caam_c.patch
patch -p1 < ../../fsl_caam_h.patch
```

`fsl_caam.h`のパッチには、ECCとBlobの拡張（`CAAM_ECC_EXPANSION`および`CAAM_BLOB_EXPANSION`）の両方に対するマクロが定義されています。
wolfSSLコードはこれらのマクロが定義されている（パッチが適用されている）ことを検出すると、拡張ドライバーの使用をコンパイルしようとします。

