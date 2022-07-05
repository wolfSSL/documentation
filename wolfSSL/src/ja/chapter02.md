

# Building Wolfssl



Wolfsslはポータビリティを念頭に置いて書かれており、一般的にほとんどのシステムでビルドするのは簡単なべきです。Wolfsslをビルドするのが難しい場合は、サポートフォーラム(<https://www.wolfssl.com/forums>)を通してサポートを求めることを躊躇しないでください。または[support@wolfssl.com](mailto:support@wolfssl.com)に直接お問い合わせください。


この章では、UnixとWindowsでwolfSSLをビルドする方法について説明し、非標準環境でwolfSSLをビルドするためのガイダンスを提供します。[第3章](chapter03.md#getting-started)に「Getting Start」ガイドと[第11章](chapter11.md#ssl-tutorial)にSSLチュートリアルがあります。


AutoCONF/Automakeシステムを使用してwolfSSLをビルドする場合、wolfSSLは単一のMakeFileを使用してライブラリのすべての部品と例をビルドします。



## wolfSSLソースコードの取得



最新バージョンのwolfSSLは、wolfSSLのWebサイトからZIPファイルとしてダウンロードできます。


<https://www.wolfssl.com/download>


zipファイルをダウンロードしたら、`unzip`コマンドを使用してファイルを解凍します。ネイティブライン終了を使用するには、unzipを使用しているときに`-a`修飾子を有効にします。[アンジッパーマニュアル]ページから、`-a`修飾機能機能が説明されています。


> [...] -aオプションでは、zipによって識別されたファイルがテキストファイル(
> ZipInfoリストの「T」ラベルは、自動的に 'b')ではなく
>そのように抽出された、線の終わり、ファイルの終わり文字を変換する
>そしてキャラクターは必要に応じてそれ自体を設定します。[...]


**注**：wolfSSL 2.0.0RC3のリリースから、wolfSSLのディレクトリ構造と標準のインストール場所が変更されました。これらの変更は、オープンソースプロジェクトがwolfSSLを統合しやすくするために行われました。ヘッダーと構造の変更の詳細については、[ライブラリヘッダー](chapter09.md#library-headers)および[構造の使用](#structure-usage)を参照してください。



## \*nixの上にビルド



Linux、\*BSD、OS X、Solaris、またはその他の\*nixのようなシステムにwolfSSLをビルドする場合、AutoCONFシステムを使用します。wolfSSLをビルドするには、wolfSSLルートディレクトリ`./configure`および`make`から2つのコマンドを実行する必要があります。


`./configure`スクリプトはビルド環境をセットアップし、任意の数のビルドオプションを`./configure`に追加します。利用可能なビルドオプションのリストについては、[オプションをビルドします](#build-options)を参照するか、次のコマンドラインを実行して、`./configure`に合格する可能性のあるオプションのリストを表示してください。脚本：



```sh
./configure --help
```



`./configure`が正常に実行されたら、wolfSSLをビルドするために実行してください。



```sh
make
```



wolfSSL実行をインストールするには：



```sh
make install
```



スーパーユーザー特権をインストールする必要があるかもしれません。その場合はsudoを使ってコマンドの前にあります。



```sh
sudo make install
```



ビルドをテストするには、Root wolfSSLディレクトリからTestSuiteプログラムを実行します。



```sh
./testsuite/testsuite.test
```



あるいは、AutoConfを使用してTestSuiteを実行し、標準のwolfSSL APIおよび暗号テストを実行できます。



```sh
make test
```



TestSuiteプログラムの予想出力に関する詳細は[テストスイートセクション](chapter03.md#testsuite)にあります。ルートディレクトリ：



```sh
make src/libwolfssl.la
```




## Windowsの上のビルド



以下の手順に加えて、Visual Studio [ここ](https://wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio.html)を使用してwolfSSLをビルドするための指示とヒントを見つけることができます。



### VS 2008




インストールのルートディレクトリには、Visual Studio 2008にソリューションが含まれています。Visual Studio 2010以降で使用するために、既存のプロジェクトファイルをインポートプロセス中に変換できるはずです。


**ノート**：
VSの新しいバージョンにインポートする場合、「プロジェクトとその輸入プロパティシートを上書きしたいですか？」と尋ねられます。「いいえ」を選択して、以下を回避できます。それ以外の場合、「はい」を選択した場合、`SAFESEH`仕様により`EDITANDCONTINUE`が無視されているという警告が表示されます。TestSuite、sslsniffer、server、echoserver、echoclient、clientを個別に修正し、プロパティを変更する必要があります -  \>構成プロパティ -  \>リンカー -  \> Advanced(Advanced Windowの下部までスクロール)。「画像には安全な例外ハンドラー」を見つけ、右端のドロップダウン矢印をクリックします。前述のそれぞれについて、これをNO(`/SAFESEH:NO`)に変更します。もう1つのオプションは、`EDITANDCONTINUE`を無効にすることです。これは、デバッグの目的に役立つため、推奨されないことがわかりました。



### VS 2010




更新されたら、wolfSSLソリューションをビルドするために、Service Pack 1をダウンロードする必要があります。vsがリンカーエラーを報告する場合、プロジェクトをクリーニングして再ビルドします。リンカーエラーを処理する必要があります。



### VS 2013(64ビットソリューション)



更新されたら、wolfSSLソリューションをビルドするために、Service Pack 4をダウンロードする必要があります。VSがリンカーエラーを報告する場合、プロジェクトをクリーンしてからプロジェクトを再ビルドすると、リンカーエラーが処理される必要があります。


各ビルドをテストするには、Visual Studioメニューから「すべてのビルド」を選択し、TestSuiteプログラムを実行します。Visual Studioプロジェクトでビルドオプションを編集するには、希望するプロジェクト(wolfSSL、Echoclient、Echoserverなど)を選択し、「プロパティ」パネルを参照します。


**注**：wolfSSL v3.8.0リリース後、ビルドプリプロセッサマクロは`IDE/WIN/user_settings.h`にある集中ファイルに移動しました。このファイルはプロジェクトにあります。ECCやCHACHA20/POLY1305などの機能を追加するには、`HAVE_ECC`または`HAVE_CHACHA`/`HAVE_POLY1305`などです。



### Cygwin




WindowsのWindowsのWindowsのWindowsのWindowsのWindowsをビルドする場合は、付属のVisual Studioプロジェクトファイルを使用してwolfSSLをビルドすることをお勧めします。しかし、Cygwinが必要な場合は、当社のチームが成功したビルドをどのように達成したかについての短いガイドです。



1. <https://www.cygwin.com/install.html>に移動し、`setup-x86_64.exe`をダウンロードしてください


2. 実行してインストールを実行します。「パッケージの選択」ステージに達するまで、インストールメニューをクリックしてください。


3. 「+」アイコンをクリックして、「すべて」を展開します


4. 次に、「アーカイブ」セクションに移動し、「unzip "ドロップダウン」を選択し、「スキップ」を6.0-15(または他のバージョン)に変更します。


5. 「devel」の下で「autoconf」をクリックして「ドロップダウン」し、「10-1」(または他のバージョン)に「スキップ」を変更します


6. 「Devel」の下で「Automake」をクリックして「ドロップダウン」し、「10-1」(または他のバージョン)に「スキップ」を変更します


7. 「Devel」で「GCC-Core」ドロップダウンをクリックして「Skip」を7.4.0-1に変更します(注：wolfSSLはGCC 9または10をテストしていません。開発のために微調整される少し時間がかかります。


8. 「Devel」で「git」ドロップダウンをクリックして「スキップ」を2.29.0-1(またはその他のバージョン)に変更します。


9. 「Devel」の下で「libtool」をクリックして「ドロップダウン」し、「2.4.6-5」(または他のバージョン)に「スキップ」を変更します

10.「Devel」で「作る」ドロップダウンをクリックして「スキップ」を4.2.1-1(またはその他のバージョン)に変更します。
11.「次」をクリックして、残りのインストールを進めます。


追加のパッケージリストには、次のものが含まれています。



* unzip



* autoconf



* automake



* GCC-Core


* git



* libtool.


* make





#### インストールを投稿します



Cygwinターミナルを開き、wolfSSLをクローン：



```sh
git clone https://github.com/wolfssl/wolfssl.git
cd wolfssl
./autogen.sh
./configure
make
make check
```




## 標準以外の環境にビルド



公式にはサポートされていませんが、特に埋め込まれたクロスコンパイルシステムを使用して、非標準環境でwolfSSLをビルドしたいユーザーを支援しようとしています。以下は、これを始めることに関するいくつかのメモです。



1. ソースファイルとヘッダファイルは、wolfSSLダウンロードパッケージにあるのと同じディレクトリ構造に残る必要があります。


2. 一部のビルドシステムは、wolfSSLヘッダーファイルがどこにあるかを明示的に知っておくように、それを指定する必要があるかもしれません。それらは`<wolfssl_root>/wolfssl`ディレクトリにあります。通常は、ヘッダーの問題を解決するためのINCLUDEパスに`<wolfssl_root>`ディレクトリを追加できます。


3. wolfSSLは、構成プロセスがBig Endianを検出しない限り、リトルエンディアンシステムにデフォルトです。非標準環境でビルドするユーザーはConfigureプロセスを使用していないため、Big Endianシステムを使用する場合は`BIG_ENDIAN_ORDER`を定義する必要があります。


4. wolfSSLは、64ビットタイプを使用可能にすることからスピードワイヤを短縮します。構成プロセスは、長い間または長い長いが64ビットであるかどうかを判断し、定義を設定します。そのため、`sizeof(long)`がシステム上の8バイトである場合は、`SIZEOF_LONG 8`を定義します.`sizeof(long long)`が8バイトの場合は、`SIZEOF_LONG_LONG 8`を定義します。


5. ライブラリをビルドしてみてください。問題が発生した場合はお知らせください。サポートが必要な場合は、[info@wolfssl.com](mailto:info@wolfssl.com)までお問い合わせください。


6. ビルドを変更できるいくつかの定義は、以下の次のサブセクションにリストされています。多くのオプションの詳細な説明については、[オプションをビルドします](#build-options)を参照してください。




### Yocto Linuxへのビルド



wolfSSLには、Yocto LinuxとOpenembededにWolfsSLをビルドするためのレシピも含まれています。これらのレシピは、githubリポジトリとしてMeta-wolfsslレイヤー内で維持されています。Yocto LinuxにWolfsslをビルドするには、GitとBitbakeが必要です。次の手順には、Yocto Linux上にビルドされたwolfSSL製品(レシピが存在する)を入手する方法をリストします。



1. **クローニングwolfSSLメタ**



これは、次のURLのgit cloneコマンドを介して行うことができます。
    <https://github.com/wolfssl/meta-wolfssl>



2. **「Meta-WolfsSl」レイヤーをビルドのbblayers.confに挿入**



`BBLAYERS`セクション内で、Meta-wolfSSLの場所へのパスを追加します
    クローン化されました。例：



    ```sh
    BBLAYERS ?= "... \
    /path/to/meta-wolfssl/ \
    ..."
    ```




3. ** wolfSSL製品レシピをビルドする**



BitBakeは、次の3つのwolfSSL製品レシピのうちの1つを作成するために使用できます。
    * wolfssl *、* wolfssh *、* wolfmqtt *。これらのレシピの1つをBitbakeに渡すだけです
    コマンド(例：`bitbake wolfssl`)。これにより、ユーザーは個人的に
    コンパイルの確認は問題なく成功します。



4. ** local.conf **を編集する**



最後のステップは、ビルドのlocal.confファイルを編集することです。
    ビルドされている画像に含まれます。`IMAGE_INSTALL_append`行を編集します
    目的のレシピの名前を含める。この例を以下に示します。



    ```sh
    IMAGE_INSTALL_apped="wolfssl wolfssh wolfmqtt"
    ```



画像がビルドされると、wolfSSLのデフォルトの場所(またはレシピから関連する製品)が`/usr/lib/`ディレクトリになります。


さらに、[オプションをビルドします](#build-options)にリストされている有効化オプションと無効化オプションを使用してYoctoにビルドするときに、wolfSSLをカスタマイズできます。これには、`.bbappend`ファイルを作成してwolfSSLアプリケーション/レシピレイヤー内に配置する必要があります。このファイルの内容には、`EXTRA_OECONF`変数に連結するコンテンツを指定する行を含める必要があります。この例を以下に示します。



```sh
EXTRA_OECONF += "--enable-tls13"
```



Yoctoへのビルドに関するさらなるドキュメントは、ここにあるMeta-Wolfssl Readmeにあります。<https：//github.com/wolfssl/meta-wolfssl/blob/master/readme.md>



### 環式トゥルーストディオのビルド



3.15.5に続くwolfSSLのバージョンには、ARM M4皮質デバイスにwolfSSLをビルドするために使用されるTruestudioプロジェクトファイルが含まれています。Truestudioプロジェクトファイルは、STM32デバイス上のビルドプロセスを簡素化し、自由にダウンロードでき、St Microelectronicsの一部であるAtollicによって作成されています。TruestudioでwolfSSL Static Library Projectファイルをビルドするには、Truestudioを開いた後、ユーザーが次の手順を実行する必要があります。



1. プロジェクトをワークスペースにインポートする(ファイル>インポート)


2. プロジェクトをビルド(プロジェクト>ビルドプロジェクト)



ビルドには、ビルドタイムに`user_settings.h`内にある設定が含まれます。`user_settings.h`ファイルのデフォルトコンテンツは最小限であり、多くの機能は含まれていません。ユーザーは、このファイルを変更し、この章の残りの部分にリストされているオプションを備えた機能を追加または削除できます。



### IARと一緒にビルド



`<wolfssl_root>/IDE/IAR-EWARM`ディレクトリには、次のファイルが含まれています。



1. ワークスペース：`wolfssl.eww`

ワークスペースには、wolfSSL-LIBライブラリとWolfCrypt-Test、WolfCrypt-Benchmarkが含まれます
   実行可能プロジェクト。

2. Wolfssl-Libプロジェクト：`lib/wolfSSL-lib.ewp`

WolfCryptとwolfSSL関数のフルセットライブラリを生成します。

3. テストスイートプロジェクト：`test/wolfCrypt-test.ewp`

テスト。テストスイート実行可能ファイルを生成します

4. ベンチマークプロジェクト：`benchmark/wolfCrypt-benchmark.ewp`

Benchmark.Out Benchmark Execupabilを生成します


これらのプロジェクトは、ジェネリックアームCortex-M MPUに設定されています。特定のターゲットMPUのプロジェクトを生成するには、次の手順を実行します。



1. デフォルト設定：プロジェクトのデフォルトターゲットは、Cortex-M3シミュレーターに設定されます。user_settings.hには、プロジェクトのデフォルトオプションが含まれています。ビルドできます

シミュレータにダウンロードしてください。「ビュー」 - >「端末I/O」、「ターミナルI/O」で「端末入出力」ウィンドウを開き、実行を開始します。



2. プロジェクトオプション設定：各プロジェクトで、適切な「ターゲット」オプションを選択します。




3. 実行可能プロジェクトの場合：MPUに "systeminit"と "startup"を追加し、デバッグ "ドライバ"を選択してください。




4. ベンチマークプロジェクトの場合：current_time関数のオプションを選択するか、wolfssl_user_currtimeオプションで独自の「current_time」ベンチマークタイマーを作成します。




5. ビルドとダウンロード：ewarm build and downloadのメニューバーで「project-> make」と「downow "and" debug "に移動します。




### OS XとiOSにビルド




#### XCODE




`<wolfssl_root>/IDE/XCODE`ディレクトリには、次のファイルが含まれています。



1. `wolfssl.xcworkspace`  - ライブラリとTestSuiteクライアントを使用したワークスペース


2. `wolfssl_testsuite.xcodeproj` -TestSuiteを実行するプロジェクト。


3. `wolfssl.xcodeproj`  -  wolfSSLおよび/またはWolfCrypt用のOS/XおよびIOSライブラリをビルドするためのプロジェクト


4. `wolfssl-FIPS.xcodeproj`-利用可能な場合はwolfsslとwolfcrypt-fipsをビルドするプロジェクト


5. `user_settings.h`-プロジェクト間で共有されるカスタムライブラリ設定



ライブラリは、ターゲットに応じて`libwolfssl_osx.a`または`libwolfssl_ios.a`として出力されます。また、wolfssl/wolfcrypt(およびcyassl/ctaocryptをコピーします
互換性)にある`include`ディレクトリにヘッダー
`Build/Products/Debug`または`Build/Products/Release`。


ライブラリとテストスイートが適切にリンクするためには、ビルドの場所をワークスペースにリアルなものとして構成する必要があります。



1. ファイル - >ワークスペースの設定(またはxcode-> feprences-> locations-> locations)


2. 派生データ - > Advanced


3. カスタム - >ワークスペース対応


4. 製品 - >ビルド/製品



これらのXcodeプロジェクトは、`WOLFSSL_USER_SETTINGS`プリプロセッサを定義して、複数のプロジェクトにマクロを設定するための`user_settings.h`ファイルを有効にします。


必要に応じて、Xcode Preprocessorsをこれらの手順で変更できます。



1. プロジェクトナビゲータのプロジェクトをクリックしてください。


2. [設定のビルド]タブをクリックします。


3. 「Apple LLVM 6.0  - 前処理」のセクションまでスクロールします。


4. 「プリプロセッサマクロ」の開示を開き、「+」を使用して

" - "変更するボタン。デバッグとリリースの両方でこれを行うことを忘れないでください。


このプロジェクトは、デフォルト設定を使用してwolfSSLとWolfCryptをビルドする必要があります。



### GCCアーム付きのビルド



`<wolfssl_root>/IDE/GCC-ARM`ディレクトリでは、Cortex MシリーズのためのwolfSSLプロジェクトの例がありますが、他のアーキテクチャには採用できます。



1. 必ず`gcc-arm-none-eabi`が設置されていることを確認してください。


2. `Makefile.common`を変更します。

*正しいツールチェーンパス`TOOLCHAIN`を使用します。
   *正しいアーキテクチャ「Archflags」を使用します。[GCCアームオプション](https://gcc.gnu.org/onlinedocs/gcc-4.7.3/gcc/ARM-Options.html) `-mcpu=name`を参照してください。
   * linker.ldのメモリマップを確認するフラッシュ/RAMと一致するか、Makefile.commonの`SRC_LD=-T./linker.ld`をコメントします。

3. `/Build`に静的ライブラリ(libwolfssl.a)、WolfCryptテスト/ベンチマーク、およびwolfSSL TLSクライアントターゲットを作成するには、`make`を使用します。




#### ジェネリックメイクファイルのクロスコンパイルを備えたビルド



例`Makefile.common` Cortex-A53を使用したラズベリーPIの変更点：



1. Makefile.common Change `ARCHFLAGS`から`-mcpu=cortex-a53 -mthumb`


2. カスタムメモリマップが適用されないため、`SRC_LD`をコメントアウトしています。


3. クリア`TOOLCHAIN`では、デフォルト`gcc`を使用します.SET `TOOLCHAIN =`


4. ノーズとナノに`LDFLAGS += --specs=nano.specs`と`LDFLAGS += --specs=nosys.specs`をコメントアウトしてください。




#### クロスコンパイル付きの構成を備えたビルド



メインプロジェクトディレクトリの構成スクリプトは、クロスコンパイルを実行できます
GCC-Arm-None-eabiツールでビルドします。ツールがインストールされていると仮定します
実行可能パス：



```sh
./configure \
  --host=arm-non-eabi \
  CC=arm-none-eabi-gcc \
  AR=arm-none-eabi-ar \
  STRIP=arm-none-eabi-strip \
  RANLIB=arm-none-eabi-ranlib \
  --prefix=/path/to/build/wolfssl-arm \
  CFLAGS="-march=armv8-a --specs=nosys.specs \
      -DHAVE_PK_CALLBACKS -DWOLFSSL_USER_IO -DNO_WRITEV" \
  --disable-filesystem --enable-fastmath \
  --disable-shared
make
make install
```



32ビットアーキテクチャをビルドしている場合は、`-DTIME_T_NOT_64BIT`を追加してください。
cflagsのリスト。



### Keil Mdk-Armのビルド



Keil MDK-ARM [ここ](https://www.wolfssl.com/docs/keil-mdk-arm/)にwolfSSLをビルドするための詳細な説明とヒントを見つけることができます。


**注**：MDK-ARMがデフォルトのインストール場所にインストールされていない場合、プロジェクトファイルの参照パス定義をすべて変更する必要があります。
場所をインストールします。



## Cプリプロセッサマクロとして定義されている機能




### 機能の削除



以下の定義は、wolfSSLから機能を削除するために使用できます。これは、ライブラリのフットプリントサイズ全体を縮小しようとしている場合に役立ちます。`NO_<feature-name>`定義を定義することに加えて、ビルドからそれぞれのソースファイルも削除することもできます(ヘッダーファイルではなく)。



#### NO_WOLFSSL_CLIENT




クライアントに固有の呼び出しを削除し、サーバーのみのビルド用です。サイズのためにいくつかの呼び出しを削除する場合にのみ、これを使用する必要があります。



#### NO_WOLFSSL_SERVER




同様に、サーバー側に固有のコールを削除します。



#### NO_DES3




DES3暗号化の使用を削除します。一部の古いサーバーがそれを使用しているため、DES3はデフォルトで組み込まれており、SSL 3.0では必要です。`NO_DH`および`NO_AES`は上記2つと同じであるため、広く使用されています。



#### NO_DSA




DSAは、一般的な使用を段階的に廃止されているため、削除します。



#### NO_ERROR_STRINGS




エラー文字列を無効にします。エラー文字列は、wolfSSLの場合は`src/internal.c`またはWolfCryptの`wolfcrypt/src/asn.c`にあります。



#### NO_HMAC




ビルドからHMACを削除します。


**注意**：SSL/TLSはHMACに依存しますが、WolfCrypt IEビルドオプション`WOLFCRYPT_ONLY`を使用している場合は、この場合、HMACを無効にすることができます。



#### NO_MD4




ビルドからMD4を削除すると、MD4が壊れているため、使用してはなりません。



#### NO_MD5




ビルドからMD5を削除します。



#### NO_SHA




ビルドからSHA-1を削除します。



#### NO_SHA256




ビルドからSHA-256を削除します。



#### NO_PSK




事前共有キー拡張機能の使用をオフにします。デフォルトでは組み込まれています。



#### NO_PWDBASED




PKCS＃12からPBKDF1、PBKDF2、PBKDFなどのパスワードベースのキー派生関数を無効にします。



#### NO_RC4




ビルドからARC4ストリーム暗号の使用を削除します。ARC4は、まだ人気があり、広く使用されているため、デフォルトで組み込まれています。



#### NO_SESSION_CACHE




セッションキャッシュが不要なときに定義できます。これにより、メモリをほぼ3 KBだけ減らす必要があります。



#### NO_TLS




TLSをオフにします。TLSの電源を切ることはお勧めしません。



#### SMALL_SESSION_CACHE




wolfSSLで使用されるSSLセッションキャッシュのサイズを制限するように定義できます。これにより、デフォルトのセッションキャッシュが33セッションから6セッションに短縮され、約2.5 KBを保存します。



#### NO_RSA




RSAアルゴリズムのサポートを削除します。



#### WC_NO_RSA_OAEP




OAEPパディングのコードを削除します。



#### NO_AES_CBC




AES-CBCアルゴリズムサポートをオフにします。



#### NO_DEV_URANDOM




`/dev/urandom`の使用を無効にします



#### WOLFSSL_NO_SIGALG




署名アルゴリズムの拡張子を無効にします



#### NO_RESUME_SUITE_CHECK




TLS接続を再開するときに暗号スイートのチェックを無効にします



#### NO_ASN




ASNフォーマットの証明書処理のサポートを削除します。



#### NO_OLD_TLS




SSLV3、TLSV1.0、TLSV1.1のサポートを削除します



#### WOLFSSL_AEAD_ONLY




非AEADアルゴリズムのサポートを削除します。AEADは、これらのアルゴリズム(AES-GCMなど)がデータを暗号化および復号化するだけでなく、そのデータの機密性と信頼性を保証するだけでなく、これらのアルゴリズム(AES-GCMなど)を意味する「認証された暗号化」の略です。



#### WOLFSSL_SP_NO_2048




RSA/DH 2048ビットシングルエシジョン(SP)最適化を削除します。



#### WOLFSSL_SP_NO_3072




RSA/DH 3072ビットシングルエシジョン(SP)最適化を削除します。



#### WOLFSSL_SP_NO_256




SECP256R1のECC単精度(SP)最適化を削除します。`WOLFSSL_SP_MATH`にのみ適用されます。



### デフォルトでは機能を無効にすることができます




#### WOLFSSL_CERT_GEN




wolfSSLの証明書生成機能をオンにします。詳細については、[キーと証明書](chapter07.md#keys-and-certificates)を参照してください。



#### WOLFSSL_DER_LOAD




Function [`wolfSSL_CTX_der_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_der_load_verify_locations)を使用して、wolfSSLコンテキスト(`WOLFSSL_CTX`)へのDERフォーマットされたCA証明書をロードできます。



#### WOLFSSL_DTLS




DTLSまたはDatagram TLSの使用をオンにします。これは広くサポートされていないか、使用されていません。



#### WOLFSSL_KEY_GEN




wolfSSLのRSAキー生成機能をオンにします。詳細については、[キーと証明書](chapter07.md#keys-and-certificates)を参照してください。



#### WOLFSSL_RIPEMD




RIPemD-160サポートを有効にします。



#### WOLFSSL_SHA384




SHA-384サポートを有効にします。



#### WOLFSSL_SHA512




SHA-512サポートを有効にします。



#### DEBUG_WOLFSSL




デバッグする機能にビルドします。Debugging wolfSSLの詳細については、[デバッグ](chapter08.md#debugging)を参照してください。



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




CRL URLでインラインHTTPリクエストをブロックできるようにします。CRLを`WOLFSSL_CTX`にロードし、作成したすべてのwolfSSLオブジェクトに適用します。



#### HAVE_ECC




楕円曲線暗号化(ECC)サポートを有効にします。



#### HAVE_LIBZ




接続上のデータの圧縮を可能にする拡張機能です。通常、使用するべきではありません。configure notes libzの下のメモを参照してください。



#### HAVE_OCSP




オンライン証明書ステータスプロトコル(OCSP)サポートを有効にします。



#### OPENSSL_EXTRA




ライブラリへのOpenSSL互換性をさらにビルドし、wolfSSL OpenSSL互換性レイヤーを可能にして、OpenSSLで動作するように設計された既存のアプリケーションへの移植を容易にします。デフォルトでオフになっています。



#### TEST_IPV6




テストアプリケーションでのIPv6のテストをオンにします。wolfSSL適切なのはIPニュートラルですが、テストアプリケーションはデフォルトでIPv4を使用しています。



#### HAVE_CSHARP




C＃ラッパーに必要な構成オプションをオンにします。



#### HAVE_CURVE25519




Curve25519アルゴリズムの使用をオンにします。



#### HAVE_ED25519




ED25519アルゴリズムの使用をオンにします。



#### WOLFSSL_DH_CONST




Diffie Hellman Operationsを実行するときにフローティングポイント値の使用をオフにし、`XPOW()`および`XLOG()`のテーブルを使用します。外部数学ライブラリへの依存関係を削除します。



#### WOLFSSL_TRUST_PEER_CERT




信頼できるピア証明書の使用をオンにします。これにより、CAを使用するのではなく、ピア証明書に接続することができます。信頼できるピア証明書がPeer Certチェーンよりも一致している場合にオンになっていると、ピアが検証されたと見なされます。CASを使用することが好ましい。



#### WOLFSSL_STATIC_MEMORY




静的メモリバッファと機能の使用をオンにします。これにより、動的ではなく静的メモリを使用できます。



#### WOLFSSL_SESSION_EXPORT




DTLSセッションのエクスポートとインポートの使用をオンにします。これにより、DTLSセッションの現在の状態をシリアル化および送受信することができます。



#### WOLFSSL_ARMASM




ARMV8ハードウェアアクセラレーションの使用をオンにします。



#### WC_RSA_NONBLOCK




RSA操作をより小さな仕事の塊に分割するためのFast MathRSAノンブロッキングサポートをオンにします。機能は、[`wc_RsaSetNonBlock()`](group__RSA.md#function-wc_rsasetnonblock)を呼び出し、`FP_WOULDBLOCK`戻りコードをチェックすることにより有効になります。



#### WOLFSSL_RSA_VERIFY_ONLY




RSA用の小さなビルドをオンにしてください。マクロ[`WOLFSSL_RSA_PUBLIC_ONLY`](#wolfssl_rsa_public_only)、[`WOLFSSL_RSA_VERIFY_INLINE`](#wolfssl_rsa_verify_inline)、[`NO_SIG_WRAPPER`](#no_sig_wrapper)、および[`WOLFCRYPT_ONLY`](#wolfcrypt_only)で使用する必要があります。



#### WOLFSSL_RSA_PUBLIC_ONLY




RSAの公開キーのみの小さなビルドをオンにします。Macro [`WOLFCRYPT_ONLY`](#wolfcrypt_only)で使用する必要があります。



#### WOLFSSL_SHA3




SHA3使用用のビルドをオンにします。これは、SHA3-224、SHA3-256、SHA3-384、SHA3-512のSHA3 Keccakのサポートです。さらに、`WOLFSSL_SHA3_SMALL`を使用して、リソースの使用のためにパフォーマンスをトレードオフできます。



#### USE_ECDSA_KEYSZ_HASH_ALGO




エフェメラルECDHEキーサイズまたは次に使用可能な次の最高値と一致するハッシュアルゴリズムを選択します。この回避策は、SHA512でハッシュされたP-256キーなどのシナリオを正しくサポートしていないいくつかのピアに関する問題を解決します。



#### WOLFSSL_ALT_CERT_CHAIN




CAはPeerによって表示されることを許可しますが、有効なチェーンの一部ではありません。デフォルトのwolfSSLの動作は、提示されたすべてのピア証明書の検証を要求することです。これにより、中間CAを信頼できるようにロードし、CAの根本へのCAの署名障害は無視されません。代替の証明書チェーンモードでは、ピア証明書が信頼できるCAに検証する必要があります。



#### WOLFSSL_CUSTOM_CURVES




標準以外の曲線を許可します。計算では、曲線「A」変数が含まれています。[`HAVE_ECC_SECPR2`](#have_ecc_secpr2)、[`HAVE_ECC_SECPR3`](#have_ecc_secpr3)、[`HAVE_ECC_BRAINPOOL`](#have_ecc_brainpool)および[`HAVE_ECC_KOBLITZ`](#have_ecc_koblitz)を使用して、追加の曲線タイプを有効にできます。



#### HAVE_COMP_KEY




ECC圧縮キーサポートを有効にします。



#### WOLFSSL_EXTRA_ALERTS




TLS接続中に追加のアラートを送信できるようにします。この機能は、[`--enable-opensslextra`](#--enable-opensslextra)を使用すると自動的に有効になります。



#### WOLFSSL_DEBUG_TLS




TLS接続中に追加のデバッグプリントアウトを有効にします



#### HAVE_BLAKE2




Blake2Sアルゴリズムのサポートを有効にします



#### HAVE_FALLBACK_SCSV




サーバー側でCipher Suite値(SCSV)サポートをシグナリングすることができます。これにより、クライアントから送信されたCipher Suite 0x56 0x00が、TLSバージョンのダウングレードが許可されていないことを通知します。



#### WOLFSSL_PSK_ONE_ID




TLS 1.3を持つPSK IDを1つだけサポートできます。



#### SHA256_MANY_REGISTERS




すべてのデータをレジスタに保持し、部分的にループを展開するSHA256バージョン。



#### WOLFCRYPT_HAVE_SRP




WolfCryptセキュアリモートパスワードサポートを有効にします



#### WOLFSSL_MAX_STRENGTH




最強のセキュリティ機能のみを有効にし、弱いまたは廃止予定の機能を無効にします。タイミングベースのサイドチャネル攻撃から保護するための近時の絶え間ない時間実行による性能が遅くなります。



#### WOLFSSL_STATIC_RSA




静的暗号は強く推奨されており、避けられない場合は決して使用しないでください。ただし、静的暗号スイートのみをサポートするレガシーシステムがまだあります。そのためには、静的RSA Cipher Suitesのみをサポートするレガシピアに接続する必要がある場合は、wolfSSLの静的RSAのサポートを有効にします。([`WOLFSSL_STATIC_PSK`](#wolfssl_static_psk)および[`WOLFSSL_STATIC_DH`](#wolfssl_static_dh)も参照)



#### WOLFSSL_STATIC_PSK




静的暗号は非常に落胆しています[`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)を参照してください



#### WOLFSSL_STATIC_DH




静的暗号は非常に落胆しています[`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)を参照してください



#### HAVE_NULL_CIPHER




null暗号のサポートをオンにします。このオプションはセキュリティの観点から非常に落胆していますが、一部のシステムは暗号化/復号化操作を実行するには小さすぎます。少なくともメッセージやピアを認証して、メッセージの改ざんを防ぐことができます。



#### HAVE_ANON




匿名の暗号スイートのサポートをオンにします。(決してお勧めしませんが、閉じたネットワークまたはプライベートネットワークを含むいくつかの有効なユースケースがWebから切り離されています)



#### HAVE_LIBOQS




OpenQuantumsafeチームのLiboQS統合のサポートをオンにします。詳細については、このドキュメントの「Quantum-Safe Cryptographyの実験」を参照してください。



#### WOLFSSL_SP_4096




RSA/DH 4096ビットシングルエシジョン(SP)サポートを有効にします。



#### WOLFSSL_SP_384




ECC SECP384R1単精度(SP)サポートを有効にします。`WOLFSSL_SP_MATH`にのみ適用されます。



#### WOLFSSL_SP_1024




Sakkeペアリングベースの暗号化単精度(SP)サポートを有効にします。



### Wolfsslをカスタマイズまたは移植する




#### WOLFSSL_USER_SETTINGS




定義されている場合、ユーザー固有の設定ファイルを使用できます。ファイルには`user_settings.h`に名前が付けられ、含まれるパスに存在する必要があります。これは、標準の`settings.h`ファイルの前に含まれるため、デフォルト設定をオーバーライドできます。



#### WOLFSSL_CALLBACKS




デバッガを使用せずに環境内の信号を使用することでコールバックをデバッグすることを可能にする拡張機能です。デフォルトではオフです。ブロッキングソケットを使用してタイマーを設定するためにも使用できます。詳しくは[コールバック](chapter06.md#callbacks)をご覧ください。



#### WOLF_CRYPTO_CB




暗号コールバックサポートを有効にします。この機能は、[`--enable-cryptocb`](#enable-cryptocb)を使用すると自動的に有効になります。



#### WOLFSSL_USER_IO




ユーザーがデフォルトのI/O関数[`EmbedSend()`](wolfio_8h.md#function-embedsend)および[`EmbedReceive()`](wolfio_8h.md#function-embedrecieve)の自動設定を削除できます。カスタムI/O抽象化レイヤに使用されます(詳細については[抽象化レイヤー](chapter05.md#abstraction-layers)を参照)。



#### NO_FILESYSTEM




STDIOが証明書とキーファイルをロードできない場合に使用されます。これにより、ファイル1の代わりにバッファ拡張子を使用することができます。



#### NO_INLINE




小型の高使用されている機能の自動インライン化を無効にします。これを回すと、Wolfsslが遅くなり、実際にはこれらが小さな関数であるため、通常は関数呼び出し/ Returnよりもはるかに小さくなります。AUTOCONFを使用していない場合は、コンパイル済みファイルのリストに`wolfcrypt/src/misc.c`を追加する必要があります。



#### NO_DEV_RANDOM




デフォルトの`/dev/random`乱数ジェネレーターの使用を無効にします。定義されている場合、ユーザーはOS固有の`GenerateSeed()`関数(`wolfcrypt/src/random.c`で見つかった)を記述する必要があります。



#### NO_MAIN_DRIVER




通常のビルド環境で使用されて、テストアプリケーションが独自に呼び出されるか、テストスイートドライバーアプリケーションを介して呼び出されます。`test.c`、`client.c`、`server.c`、`echoclient.c`、`echoserver.c`、および`testsuite.c`でテストファイルで使用する必要があります。



#### NO_WRITEV




`writev()`セマンティクスのシミュレーションを無効にします。



#### SINGLE_THREADED




ミューテックスの使用をオフにするスイッチです。wolfSSLは現在、セッションキャッシュにのみ使用しています。wolfSSLの使用が常にシングルスレッドになっている場合は、これをオンにすることができます。



#### USER_TICKS




時間(0)が望まれない場合、ユーザーは自分のクロックチェック機能を定義できます。カスタム機能には2番目の正確さが必要ですが、エポックと相関がある必要はありません。`wolfssl_int.c`の機能を参照してください。



#### USER_TIME




ユーザーが自分自身を使用する(または必要とする)場合のTime.h構造体の使用を無効にします。実装の詳細については`wolfcrypt/src/asn.c`を参照してください。ユーザーは`XTIME()`,`XGMTIME()`、および`XVALIDATE_DATE()`を定義および/または実装する必要があります。



#### USE_CERT_BUFFERS_1024




`<wolfssl_root>/wolfssl/certs_test.h`にある1024ビットのテスト証明書とキーバッファを有効にします。ファイルシステムのないエンベデッドシステムをテストして移植するときに役立ちます。



#### USE_CERT_BUFFERS_2048




`<wolfssl_root>/wolfssl/certs_test.h`にある2048ビットテスト証明書とキーバッファを有効にします。ファイルシステムなしでエンベデッドシステムをテストして移植するときに役立ちます。



#### CUSTOM_RAND_GENERATE_SEED




ユーザーが`wc_GenerateSeed(byte* output, word32 sz)`に相当するカスタム機能を定義できるようにします。



#### CUSTOM_RAND_GENERATE_BLOCK




ユーザーがカスタム乱数生成機能を定義できるようにします。使用例は以下の通りである。



```sh
./configure --disable-hashdrbg
CFLAGS="-DCUSTOM_RAND_GENERATE_BLOCK= custom_rand_generate_block"
```



または



```c
/* RNG */
/* #define HAVE_HASHDRBG */
extern int custom_rand_generate_block(unsigned char* output, unsigned int sz);
```




#### NO_PUBLIC_GCM_SET_IV




独自のカスタムハードウェアポートを作成していて、[`wc_AesGcmSetIV()`](group__AES.md#function-wc_aesgcmsetiv)の公開実装が提供されていない場合は、これを使用してください



#### NO_PUBLIC_CCM_SET_NONCE




独自のカスタムハードウェアポートを作成していて、`wc_AesGcmSetNonce()`の公開実装が提供されていない場合は、これを使用してください



#### NO_GCM_ENCRYPT_EXTRA




独自のカスタムハードワレポートを行っていて、`wc_AesGcmEncrypt_ex()`の実装が提供されていない場合は、これを使用してください



#### WOLFSSL_STM32[F1 | F2 | F4 | F7 | L4]




適切なSTM32デバイス用にビルドするときにこれらの定義のいずれかを使用します。必要に応じて、wolfSSLポーティングガイド(<https://www.wolfssl.com/docs/porting-guide/>)に関して`wolfssl-root/wolfssl/wolfcrypt/settings.h`セクションを更新します。



#### WOLFSSL_STM32_CUBEMX




Cubemxツールを使用してハードウェア抽象化レイヤー(HAL)APIを生成する場合、この設定を使用してwolfSSLに適切なサポートを追加します。



#### WOLFSSL_CUBEMX_USE_LL




Cubemxツールを使用してAPIを生成する場合、HAL(ハードウェア抽象化層)または低層(LL)の2つのオプションがあります。この定義を使用して、`WOLFSSL_STM32[F1/F2/F4/F7/L4]`セクションの`wolfssl-root/wolfssl/wolfcrypt/settings.h`に含まれるヘッダーを制御します。



#### NO_STM32_CRYPTO




STM32の部分がハードウェア暗号サポートを提供しない場合のために



#### NO_STM32_HASH




STM32部品がハードウェアハッシュサポートを提供しない場合のために



#### NO_STM32_RNG




STM32部品がハードウェアRNGサポートを提供しない場合のために



#### XTIME_MS




TLS 1.3を使用するときに使用するための関数をミリ秒単位でマッピングするためのマクロ。例：



```c
extern time_t m2mb_xtime_ms(time_t * timer);
#define XTIME_MS(tl) m2mb_xtime_ms((tl))
```




### メモリまたはコードの使用量を削減します




#### TFM_TIMING_RESISTANT




スタックサイズが小さいシステムでFast Math([`USE_FAST_MATH`](#use_fast_math))を使用するときに定義できます。これは大きな静的アレイを取り除くでしょう。



#### WOLFSSL_SMALL_STACK




スタックサイズが小さいデバイスに使用できます。これにより、`wolfcrypt/src/integer.c`の動的メモリの使用が増加しますが、パフォーマンスが遅くなる可能性があります。



#### ALT_ECC_SIZE




Fast MathとRSA/DHを使用する場合は、ECCメモリ消費量を削減するためにこれを定義できます。ECCポイントにスタックを使用する代わりに、ヒープから割り当てます。



#### ECC_SHAMIR




ECC Mathのバリエーションは、わずかに高速ですが、ヒープの使用量を2倍にします。



#### RSA_LOW_MEM




定義された場合、CRTは使用されていないため、一部のメモリを保存しますが、RSA操作を遅くします。デフォルトでオフになっています。



#### WOLFSSL_SHA3_SMALL




SHA3を有効にすると、このマクロはビルドサイズを縮小します。



#### WOLFSSL_SMALL_CERT_VERIFY




DecodedCertを使用せずに証明書署名を確認します。一部のコードでは2倍になりますが、ピークヒープメモリの使用が小さくなります。[`WOLFSSL_NONBLOCK_OCSP`](#wolfssl_nonblock_ocsp)では使用できません。



#### GCM_SMALL




テーブルを使用する代わりに実行時に計算することで、AES GCMコードサイズを減らすオプション。可能なオプションは、`GCM_SMALL`,`GCM_WORD32`または`GCM_TABLE`です。



#### CURVED25519_SMALL




[`CURVE25519_SMALL`](#curve25519_small)および[`ED25519_SMALL`](#ed25519_small)を定義します。



#### CURVE25519_SMALL




CURVE25519には小メモリオプションを使用してください。これはより少ないメモリを使用しますが、遅いです。



#### ED25519_SMALL




ED25519の小さなメモリオプションを使用します。これはより少ないメモリを使用しますが、遅いです。



#### USE_SLOW_SHA




ロープのレオロールのないループではなくコードサイズを縮小します。これにより、SHAのパフォーマンスが低下します。



#### USE_SLOW_SHA256




ロープのレオロールのないループではなくコードサイズを縮小します。これにより、SHAのパフォーマンスが低下します。約2kが小さく、約25％遅い。



#### USE_SLOW_SHA512




ロープのレオロールのないループではなくコードサイズを縮小します。これにより、SHAのパフォーマンスが低下します。2倍の小さいですが、50％が遅くなります。



#### ECC_USER_CURVES




ユーザーが有効になっているECCカーブサイズを選択できるようにします。デフォルトでは256ビットカーブのみが有効になっています。他の人が使用できるようにするには、`HAVE_ECC192`,`HAVE_ECC224`などを使用します。



#### WOLFSSL_SP_NO_MALLOC




SPコードでは、常にStackを使用して、Heap xmalloc()/xrealloc()/xfree()呼び出しは行われません。



#### WOLFSSL_SP_NO_DYN_STACK




動的スタックアイテムの使用を無効にします。コードサイズが小さく、小さなスタックではなく使用されます。



#### WOLFSSL_SP_FAST_MODEXP




コードサイズを犠牲にして、より高速なmod_exp実装でコンパイルします。



#### WC_DISABLE_RADIX_ZERO_PAD




六角形の文字列出力での先頭ゼロの印刷を無効にします。たとえば、このマクロが定義されている場合、値8は文字列「0x8」として印刷されますが、定義されていない場合は「0x08」として印刷されます。このマクロを定義すると、コードサイズを削減できます。



### パフォーマンスを向上させる




#### USE_INTEL_SPEEDUP




AES、Chacha20、Poly1305、SHA256、SHA512、ED25519およびCURV25519の加速にINTELのAVX/AVX2命令を使用できます。



#### WOLFSSL_AESNI




IntelとAMDチップセットに組み込まれているAES加速操作を使用できます。この定義を使用する場合、`aes_asm.asm`(AT＆T構文を備えたWindows用)または`aes_asm.S`ファイルは、Intel AESの新しい命令セット(AESNI)を介して最適化するために使用されます。



#### HAVE_INTEL_RDSEED




DRBGシードソース用のIntelのRDSEEDを有効にします。



#### HAVE_INTEL_RDRAND




WolfsSLのランダムソースのIntelのRDRAND命令を有効にします。



#### FP_ECC




ECC固定点キャッシュを有効にします。これにより、同じ秘密鍵に対する繰り返し操作が高速化されます。`FP_ENTRIES`および`FP_LUT`を使用してエントリとLUTビットの数を定義して、デフォルトの静的メモリ使用量を削減することもできます。



#### WOLFSSL_ASYNC_CRYPT




これにより、Intel QuickAssistやMarvell(Cavium)Nitrox Vなどのハードウェアベースのアダプターを使用した非同期暗号化のサポートが可能になります。非同期コードは公開コードに含まれておらず、facts@wolfssl.comでメールで連絡することで評価できます。



### GCMパフォーマンスチューニング



GCMパフォーマンスには4つのバリエーションがあります。



* `GCM_SMALL`  - 最小のフットプリント、最も低い(FIPS検証済み)


* `GCM_WORD32`-中程度(FIPS検証)


* `GCM_TABLE`  -  FAST(FIPS検証済み)


* `GCM_TABLE_4BIT`  - 最速(まだFIPS検証されていない、FIPS 140-3に含まれます)




### WolfsSLの数学オプション



wolfsslには3つの数学ライブラリがあります。



* integ整形


* Fast Math


* 単精度数学



wolfSSLをビルドするときは、これらの1つだけを使用する必要があります。


Big Integerライブラリは、アセンブリなしでCで書かれているため、最も携帯用のオプションです。そのため、特定のアーキテクチャに最適化されていません。すべての数学変数は、ヒープにインスタンス化されています。最小限のスタック使用量。残念ながら、Big Integerライブラリはタイミングに耐性がありません。


Fast Mathライブラリは良い選択肢です。Cとアセンブリの両方を使用して実装されます。そのため、特定のアーキテクチャの最適化があります。すべての数学変数は、スタックにインスタンス化されています。最小限のヒープ使用。`TFM_TIMING_RESISTANT`マクロが定義されている場合、タイミングに耐性にすることができます。FIPS 140-2および140-3の認定を取得しました。


単一精度(SP)数学ライブラリが推奨ライブラリです。Cとアセンブリの両方を使用して実装されます。そのため、特定のアーキテクチャの最適化があります。すべての数学変数は、スタックにインスタンス化されています。最小限のヒープ使用。常にタイミングに耐性があります。通常、コードサイズのコストで速度で最適化されていますが、不要なコードをコンパイルするために高度に構成可能です。DO-178C認定を取得しました。



#### 大きな整数数学ライブラリ



パブリックドメインLibtommath Libraryからフォーク。Libtommathの詳細については、<https://www.libtom.net/libtommath/>を参照してください。フォークは、元のパブリックドメインコードよりもかなりアクティブで安全であることに注意してください。


組み込みターゲットの場合、マクロの構成や変更なしでビルドされていない場合、マクロはこの実装を使用します。これは一般に最もポータビリティがあり、一般的に最も簡単に進むのが最も簡単です。通常のビッグ整数ライブラリのネガは、すべてのメモリがヒープから割り当てられ、`XREALLOC()`の実装が必要であり、タイミング耐性がないため、多くのヒープメモリを使用していることです。実装は`integer.c`にあります。



#### Fast Math




##### USE_FAST_MATH




パブリックドメインlibtomfastmathライブラリからフォーク。libtomfastmathの詳細については、<https://www.libtom.net/tomsfastmath>を参照してください。フォークは、libtomfastmathの元のパブリックドメインコードよりもかなりアクティブで安全です。パフォーマンス、セキュリティ、コードの品質が向上しました。また、FASTMATHコードをFIPS 140-2および140-3の認定を介して取得しました。


FastMathオプションは、可能であれば、アセンブリを使用する高速ビッグ整数ライブラリに切り替わります。FastMathオプションは、RSA、DH、DSAなどの非対称プライベート/公開鍵操作をスピードアップします。デフォルトでは、wolfSSLの設定スクリプトはx86_64とAARCHアーキテクチャのFastMathライブラリを使用するように設定されています。このオプションは、可能であれば、ビッグ整数ライブラリをアセンブリを使用するより速いものに切り替えます。組み立て包含は、コンパイラとプロセッサの組み合わせに依存します。いくつかの組み合わせは追加の構成フラグを必要とし、いくつかは不可能かもしれません。新しいアセンブリルーチンを使用してFastMathを最適化するのに役立ちます。コンサルティングベースで入手できます。アセンブリコードの使用は、使用されるコンパイラとプロセッサによって異なります。Archetecture固有の最適化を参照してください。


FastMathの場合、すべてのメモリがスタックに割り当てられます。FastMathを使用するときにスタックメモリの使用量が大きくなる可能性があるため、このオプションを使用するときにも[`TFM_TIMING_RESISTANT`](#tfm_timing_resistant)を定義することをお勧めします。TFM_TIMING_RSISTANTが定義されている場合、FastMathコードは処理時間一定化です。これにより、より少ないメモリを使用する一定の時間のために、大きな数学ウィンドウのいくつかが減少します。ショートカットがないため、秘密鍵操作中に分岐が少なくなるため、これは少ないスタックを使用します。これはまた、タイミング攻撃が本当の脅威であり、悪意のある第三者に秘密鍵を再現するのに十分な情報を与えることができます。


たとえば、IA32では、すべてのレジスタを利用可能である必要があり、フレームポインタを省略する必要があります。wolfsslは、デバッグ以外のビルドのためにGCCに`-O3 -fomit-frame-pointer`を追加します。別のコンパイラを使用している場合は、設定中に手動で`CFLAGS`に追加する必要があります。


OS Xは`-mdynamic-no-pic`を`CFLAGS`に追加する必要があります。さらに、OS XでIA32の共有モードでビルドする場合は、`LDFLAGS`にオプションを渡す必要があります。



```sh
LDFLAGS="-Wl,-read_only_relocs,warning"
```



これはエラーの代わりにいくつかのシンボルの警告を与えます。


FastMathは動的およびスタックメモリの使用方法を変更します。通常の数学ライブラリは大きな整数に動的メモリを使用します。 FastMathはデフォルトで4096ビットの整数を保持する固定サイズバッファを使用し、2048ビットで2048ビットの乗算を可能にします。 4096ビット×4096ビット乗算が必要な場合は、`wolfssl/wolfcrypt/tfm.h`で`FP_MAX_BITS`を変更した場合、`FP_MAX_BITS`が増加すると、公開鍵操作で使用されているバッファーが大きくなるため、これもランタイムスタックの使用量を増やします。 `FP_MAX_BITS`最大キーサイズを2倍にする必要があります。たとえば、最大のキーが2048ビットの場合、`FP_MAX_BITS`が4096であるべきであり、4096ビット`FP_MAX_BITS`の場合は8192です。ECCのみを使用する場合は、これを最大限のECCキーサイズ2回に短縮できます。ライブラリ内のいくつかの関数はいくつかの一時的な大きな整数を使用します。つまり、スタックは比較的大きくなる可能性があります。これは組み込みシステムまたはスタックサイズが低い値に設定されているスレッド環境でのみ再生されるべきです。これらの環境での公開鍵操作中にFastMathでスタック破損が発生した場合は、スタックサイズを増やしてスタック使用量を収容してください。


AutoCONFシステムを使用せずにFastMathを有効にしている場合は、`USE_FAST_MATH`を定義し、`integer.c`を削除しながら`tfm.c`をwolfSSLビルドに追加する必要があります。



##### アーキテクチャ固有の最適化



USE_FAST_MATHを使用したアセンブリ最適化に次のマクロを定義できます。



* `TFM_ARM`



* `TFM_SSE2`



* `TFM_AVR32`



* `TFM_PPC32`



* `TFM_PPC64`



* `TFM_MIPS`



* `TFM_X86`



* `TFM_X86_64`




これらのいずれも定義されていないか、TFM_NO_ASMが定義されていない場合、`TFM_ISO`が定義され、ISO Cポータブルコードが使用されます。



##### アルゴリズム固有の最適化



有効にすると、乗算と正方形の最適化された実装がそれぞれのECC曲線に使用されます。



* `TFM_ECC192`



* `TFM_ECC224`



* `TFM_ECC256`



* `TFM_ECC384`



* `TFM_ECC521`





##### TFM_SMALL_SET




小さい数の乗算のためのスピード最適化1-16ワードコンバイの乗算と二乗の実装を含みます。ECC操作の性能を向上させるのに役立ちます。



##### TFM_HUGE_SET




より大きな数の乗算のための速度最適化。20、24、28、32、48、64ワードコンバの乗算と、ビットサイズが許す場所での正方形の実装が含まれています。RSA/DH/DSA操作のパフォーマンスの向上に役立ちます。



##### TFM_SMALL_MONT_SET




Intelアーキテクチャ上の小さな数値のモンゴメリーの削減のための速度最適化。1〜16ワードモンゴメリー削減の実装が含まれています。ECC操作の性能を向上させるのに役立ちます。



#### 独自の単精度(SP)数学の支援



SP Mathは推奨オプションであり、DO-178C認定を通じて取得されていますが、まだデフォルトではありません。これらを使用して、一般的な特定のキーサイズと曲線の公開キー操作をスピードアップします。次のような正しいコードファイルを必ず含めてください。



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




単精度数学のサポートを有効にします。



#### WOLFSSL_SP_MATH




SP数学とアルゴリズムのみを有効にします。通常(`integer.c`)またはFAST(`tfm.c`)などの大きな整数数学コードを排除します。キーサイズと曲線をSPでサポートされているものだけに制限します。



#### WOLFSSL_SP_MATH_ALL




SP数学とアルゴリズムを有効にします。SPではサポートされていないキーサイズと曲線のために、通常(`integer.c`)またはFAST(`tfm.c`)などの大きな整数数学コードを実装しています。



#### WOLFSSL_SP_SMALL




SP Mathを使用する場合、これはコードの小さなバージョンを使用し、大きなスタック変数を回避します。



##### SP_WORD_SIZE




1ワードを1ワードに保存するための32ビットまたは64ビットのデータ型。



##### WOLFSSL_SP_NONBLOCK




単一の精度数学の「非ブロッキング」モードを有効にします。これにより、長い操作のためにFP_WouldBlockを返し、機能が完了するまで再度呼び出す必要があります。現在、これはECCでのみサポートされており、`WC_ECC_NONBLOCK`と組み合わせて使用されています。



##### WOLFSSL_SP_FAST_NCT_EXPTMOD




より速い非一定の時間モジュール式指数の実装を可能にします。公開鍵操作にのみ使用されます。秘密鍵操作ではありません。



##### WOLFSSL_SP_INT_NEGATIVE




マルチエシジョン数値を負にすることができます。(暗号化操作には必要ありません。)



##### WOLFSSL_SP_INT_DIGIT_ALIGN




SP_INT_DIGITポインターへの整理されていないアクセスを有効にすることは許可されていません。



##### WOLFSSL_HAVE_SP_RSA




2048,3072および4096ビットのための単精度RSA。



##### WOLFSSL_HAVE_SP_DH




2048、3072、および4096ビットの単一精度DH。



##### WOLFSSL_HAVE_SP_ECC




SECP256R1およびSECP384R1用の単精度ECC。



##### WOLFSSL_SP_LARGE_CODE




より大きな2進数のコストで来る単精度(SP)スピードアップを許可します。一部の組み込みプラットフォームには適していない可能性があります。



##### WOLFSSL_SP_DIV_WORD_HALF




二重の長さの単語を使用して除算が利用できないことを示します。たとえば、32ビットCPUで、ライブラリから64ビット部門でコンパイルしたくない場合は、このマクロターンを定義して、半ワードサイズの部分を使用して除算が行われる実装を定義します。



##### WOLFSSL_SP_DIV_32




32ビット分割が利用できず、wolfSSLが独自の単精度(SP)実装を使用する必要があることを示します。



##### WOLFSSL_SP_DIV_64




64ビット分割が利用できず、WOLFSSLは独自の単精度(SP)実装を使用する必要があることを示します。



##### WOLFSSL_SP_ASM




より高速な単一精度(SP)プラットフォーム固有のアセンブリコードの実装を有効にします。プラットフォームが検出されます。



##### WOLFSSL_SP_X86_64_ASM




単一精度(SP)Intel X64アセンブリの実装を有効にします。



##### WOLFSSL_SP_ARM32_ASM




単精度(SP)AARCH32アセンブリの実装を有効にします。



##### WOLFSSL_SP_ARM64_ASM




シングルペシジョン(SP)AARCH64アセンブリの実装を有効にします。



##### WOLFSSL_SP_ARM_CORTEX_M_ASM




単一精度(SP)cortex-Mファミリー(cortex-M4を含む)アセンブリの実装を有効にします。



##### WOLFSSL_SP_ARM_THUMB_ASM




単精度(SP)ARM Thumbアセンブリの実装を有効にします(-mthumbと一緒に使用)。



##### WOLFSSL_SP_X86_64




単精度(SP)Intel X86 64ビットアセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_X86




単精度(SP)Intel X86アセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_PPC64




シングルペシジョン(SP)PPC64アセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_PPC




単精度(SP)PPCアセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_MIPS64




シングルペシジョン(SP)MIPS64アセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_MIPS




単精度(SP)MIPSアセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_RISCV64




シングルペシジョン(SP)RISCV64アセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_RISCV32




シングルペシジョン(SP)RISCV32アセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



##### WOLFSSL_SP_S390X




単精度(SP)S390Xアセンブリスピードアップマクロを有効にします。`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。`sp_int.c`を参照してください。



### スタックまたはチップ固有の定義



wolfSSLは、さまざまなプラットフォームとTCP/IPスタック用にビルドできます。次の定義のほとんどは`./wolfssl/wolfcrypt/settings.h`にあり、デフォルトでコメントアウトされています。以下を参照する特定のチップまたはスタックのサポートを有効にするために、それぞれを作成できません。



#### IPHONE




iOSで使用するためにビルドする場合は定義できます。



#### THREADX




ThreadX RTOS(<https：//www.rtos.com>)で使用するためにビルドするときに定義できます。



#### MICRIUM




MicriumのµC/OS-III RTO(<https://www.micrium.com>)のサポートを有効にするために、wolfSSLをビルドするときに定義できます。



#### MBED




MBEDプロトタイピングプラットフォーム用にビルドするときに定義できます(<https://www.mbed.org>)。



#### MICROCHIP_PIC32




マイクロチップのPIC32プラットフォーム(<https://www.microchip.com>)のビルド時に定義できます。



#### MICROCHIP_TCPIP_V5




マイクロチップTCP/IPスタックのバージョン5を定義できます。



#### MICROCHIP_TCPIP




マイクロチップTCP/IPスタックバージョン6以降に定義できます。



#### WOLFSSL_MICROCHIP_PIC32MZ




PIC32MZハードウェア暗号化エンジン用に定義できます。



#### FREERTOS




Freertos(<https://www.freertos.org>)のためにビルドするときに定義できます。LWIPを使用している場合は、[`WOLFSSL_LWIP`](#wolfssl_lwip)も定義します。



#### FREERTOS_WINSIM




Freertos Windows Simulator(<https://www.freertos.org>)用にビルドするときに定義できます。



#### EBSNET




EBSNET製品とRTIPを使用するときに定義できます。



#### WOLFSSL_LWIP




LWIP TCP/IPスタック(<https://savannah.nongnu.org/projects/lwip/>)でwolfSSLを使用するときに定義できます。



#### WOLFSSL_ISOTP




通常、缶バスに使用されるISO-TPトランスポートプロトコルでwolfSSLを使用する場合、定義できます。使用例は[wolfSSL-例リポジトリ](https://github.com/wolfssl/wolfssl-examples)にあります。



#### WOLFSSL_GAME_BUILD




ゲームコンソールのためにWolfsslをビルドするときに定義できます。



#### WOLFSSL_LSR




LSR用にビルドする場合は定義できます。



#### FREESCALE_MQX




Freescale MQX/RTCS/MFS(<https://www.freescale.com>)用にビルドするときに定義できます。これにより、`FREESCALE_K70_RNGA`が定義され、Kinetis H/W乱数ジェネレーターアクセラレータのサポートが可能になります



#### WOLFSSL_STM32F2




STM32F2用のビルド時に定義できます。これは、wolfSSL(<https://www.st.com/internet/mcu/subclass/1520.jsp>)でSTM32F2ハードウェア暗号化およびハードウェアRNGサポートを可能にします。



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




wolfSSLをASIO互換バージョンとしてビルドするように定義できます。その後、ASIOは`BOOST_ASIO_USE_WOLFSSL` Preprocessor Defineに依存しています。



#### WOLFSSL_CRYPTOCELL




ARM Cryptocellを使用できるように定義できます。



#### WOLFSSL_SIFIVE_RISC_V




RISC-V sifive/hifiveポートを使用して有効にするために定義できます。



#### WOLFSSL_MDK_ARM




MDKアームのサポートを追加します



#### WOLFSSL_MDK5




MDK5 ARMのサポートを追加します



### OS特有の定義




#### USE_WINDOWS_API




UNIX/Linux APIとは対照的に、WindowsライブラリAPIの使用を指定します。



#### WIN32_LEAN_AND_MEAN




Microsoft Win32 LeanとMean Buildのサポートを追加します。



#### FREERTOS_TCP




Freertos TCPスタックのサポートを追加します



#### WOLFSSL_SAFERTOS




Safertosのサポートを追加します



## オプションをビルドします



以下は、wolfSSLライブラリのビルド方法をカスタマイズするために`./configure`スクリプトに追加される可能性のあるオプションです。


デフォルトでは、wolfSSLは共有モードでのみビルドされ、静的モードが無効になっています。これにより、ビルド時間が2倍スピードアップされます。どちらのモードも明示的に無効にするか、必要に応じて有効にすることができます。



### `--enable-debug`



wolfSSLデバッグサポートを有効にします。デバッグサポートを有効にすると、デバッグ情報を備え、メッセージを`stderr`に出力する定数[`DEBUG_WOLFSSL`](#debug_wolfssl)を定義することで、[`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on)をオンにします。実行時にデバッグロジングをオフにするには、[`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off)を呼び出します。詳細については、[デバッグ](chapter08.md#debugging)を参照してください。



### `--enable-distro`



wolfSSL Distro Buildを有効にします。



### `--enable-singlethread`



単一のスレッドモード、マルチスレッド保護なしを有効にします。


単一のスレッドモードを有効にすると、セッションキャッシュのマルチスレッド保護がオフになります。アプリケーションがシングルスレッドであるか、アプリケーションがマルチスレッドであり、一度に1つのスレッドのみがライブラリにアクセスすることがわかっている場合にのみ、単一のスレッドモードを有効にします。



### `--enable-dtls`



wolfSSL DTLSのサポートを有効にします


DTLSサポートを有効にすることで、ライブラリのユーザーがTLSおよびSSLに加えてDTLSプロトコルを使用できます。詳細については、[DTLS](chapter04.md#dtls)セクションを参照してください。



### `--disable-rng`



RNGのコンパイルと使用を無効にします



### `--enable-sctp`



wolfSSL DTLS-SCTPサポートを有効にします



### `--enable-openssh`



OpenSSH互換性ビルドを有効にします



### `--enable-apachehttpd`



Apache HTTPD互換性のビルドを有効にします



### `--enable-openvpn`



OpenVPN互換性Build.を有効にします



### `--enable-opensslextra`



追加のOpenSSL API互換性を有効にすると、サイズが増加します


OpenSSL Extraを有効にするには、OpenSSL互換性の大規模なセットが含まれています。基本的なビルドは、ほとんどのTLS/SSLニーズに十分な機能を有効にしますが、10Sまたは100のOpenSSLコールを使用するアプリケーションを移植する場合、これによりサポートが向上します。wolfSSL openSSL互換性レイヤーはアクティブな開発中です。したがって、必要な機能が欠落している場合は、お問い合わせください。お問い合わせください。OpenSSL互換性レイヤーの詳細については、[OpenSSL互換性](chapter13.md#openssl-compatibility)を参照してください。



### `--enable-opensslall`



OpenSSL APIをすべて有効にします。



### `--enable-maxstrength`



最大強度ビルドを有効にすると、TSLV1.2-AEAD-PFS暗号のみが可能になります



### `--disable-harden`



硬化したビルドを無効にし、タイミングの抵抗と盲検化を可能にします



### `--enable-ipv6`



IPv6のテストを有効にする、wolfssl適切なのはIPニュートラルです


IPv6を有効にするテストアプリケーションは、IPv4の代わりにIPv6を使用します。wolfSSL適切なIS IP Neutralでは、どちらのバージョンを使用できますが、現在テストアプリケーションはIPに依存しています。



### `--enable-bump`



SSLバンプビルドを有効にします



### `--enable-leanpsk`



LEAN PSKビルドを有効にします。


PSKを使用して非常に小さなビルドを使用し、ライブラリから多くの機能を排除します。この有効化を備えた組み込みシステム上のwolfSSLのおおよそのビルドサイズは21kbです。



### `--enable-leantls`



無駄のないTLS 1.2クライアントのみ(クライアント認証なし)、ECC256、AES128、およびSHA256を実装します。他のビルドオプションと組み合わせてではなく、現時点ではそれ自体で使用されることを意味していました。


有効化すると、TLS 1.2クライアントのみをサポートする小さなフットプリントTLSクライアント(クライアント認証なし)、ECC256、AES128、SHA256をサポートします。他のビルドオプションと組み合わせてではなく、現時点ではそれ自体で使用されることを意味していました。



### `--enable-bigcache`



ビッグセッションキャッシュを有効にします。


ビッグセッションキャッシュを有効にすると、セッションキャッシュが33セッションから20,027セッションまで増加します。デフォルトのセッションキャッシュサイズ33は、TLSクライアントと組み込みサーバーに適しています。ビッグセッションキャッシュは、基本的に1分あたり200個の新しいセッションを可能にする、重い負荷の下ではないサーバーに適しています。



### `--enable-hugecache`



巨大なセッションキャッシュを有効にします。


巨大なセッションキャッシュを有効にすると、セッションキャッシュサイズが65,791セッションに増加します。このオプションは、重い負荷がかかるサーバー向けで、1分あたり13,000を超える新しいセッションが可能であるか、1秒あたり200を超える新しいセッションが可能です。



### `--enable-smallcache`



小さなセッションキャッシュを有効にします。


小さなセッションキャッシュを有効にすると、wolfSSLは6セッションのみを保存します。これは、3kB近くのデフォルトがRAMが多すぎる埋め込みクライアントまたはシステムに役立つ場合があります。この定義では、500バイト未満のRAMを使用します。



### `--enable-savesession`



永続的なセッションキャッシュを有効にします。


このオプションを有効にすることで、アプリケーションがwolfsslセッションキャッシュをメモリバッファに保持(保存)して復元できます。



### `--enable-savecert`



永続的な証明書キャッシュを有効にします。


このオプションを有効にすることで、アプリケーションが持続(保存)され、wolfSSL証明書キャッシュをメモリバッファーに復元できます。



### `--enable-atomicuser`



アトミックユーザーレコードレイヤを有効にします。


このオプションを有効にすると、ユーザーアトミックレコードレイヤの処理コールバックがオンになります。これにより、アプリケーションは独自のMAC /暗号化および復号化/検証コールバックを登録することができます。



### `--enable-pkcallbacks`



公開鍵コールバックを有効にします



### `--enable-sniffer`



wolfSSL Snifferのサポートを有効にします。


SNIFFER(SSL検査)サポートを有効にすると、SSLトラフィックパケットの収集と、正しいキーファイルでそれらのパケットを復号化する機能が可能になります。


現在、スニファーは次のRSA暗号をサポートしています。


CBC暗号：



* AES-CBC



* Camellia-CBC


* 3DES-CBC




ストリーム暗号：



* RC4





### `--enable-aesgcm`



AES-GCMサポートを有効にします。


このオプションを解決すると、Public Keyコールバックがオンになり、アプリケーションは独自のECCサイン/ VerifyとRSAの署名/署名/確認を許可し、コールバックを識別して暗号化/復号化することができます。



### `--enable-aesccm`



AES-CCMサポートを有効にします


AES-GCMを有効にすると、これらの暗号スイートがwolfSSLに追加されます。wolfSSLは、AES-GCMのバランス速度とメモリ消費の4つの異なる実装を提供します。利用可能な場合、wolfSSLは64ビットまたは32ビットの数学を使用します。組み込みアプリケーションの場合、64ビットバージョンに匹敵する速度であるRAMベースのルックアップテーブル(セッションあたり8kb)を使用するスピーディーな8ビットバージョンと、追加のRAMを占有しない8ビットバージョンが遅いバージョンがあります。。-ENABLE-AESGCM構成オプションは、オプション`=word32`、`=table`、または`=small`、つまり`--enable-aesgcm=table`で変更できます。



### `--disable-aescbc`



AES-CBCをコンパイルするために[`--disable-aescbc`](#--disable-aescbc)で使用されていました


AES-GCMは、AESの8バイト認証(CCM-8)を備えたCBC-MACモードでカウンターを有効にします。



### `--enable-aescfb`



AES-CFBモードサポートをオンにします



### `--enable-aesctr`



wolfSSL AES-CTRサポートを有効にします


AES-CTRを有効にすると、カウンタモードが可能になります。



### `--enable-aesni`



Wolfssl Intel AES-NIサポートを有効にします


AES-NIサポートの有効化AES-NIサポートチップを使用する場合、AES命令をチップから直接呼び出すことができます。これにより、AES機能の速度が速くなります。AES-NIの詳細については[機能](chapter04.md#features)を参照してください。



### `--enable-intelasm`



IntelおよびAMDプロセッサのASMスピードアップを有効にします。


wolfSSLのIntelasmオプションを有効にすると、AESパフォーマンスを劇的に強化するプロセッサの拡張機能を利用します。Configureオプションが有効になっているときに命令セットは、AVX1、AVX2、BMI2、RDRAND、RDSEED、AESNI、およびADXを含む。これらは最初にIntelプロセッサに導入され、AMDプロセッサは近年採用を開始しました。有効にすると、wolfSSLはプロセッサをチェックし、プロセッサがサポートする命令を設定します。



### `--enable-camellia`



Camelliaサポートを有効にします



### `--enable-md2`



MD2サポートを有効にします



### `--enable-nullcipher`



wolfssl null cipherサポートを有効にする(暗号化なし)



### `--enable-ripemd`



wolfssl ripemd-160サポートを有効にします



### `--enable-blake2`



wolfSSL Blake2のサポートを有効にします



### `--enable-blake2s`



wolfSSL Blake2Sサポートを有効にします



### `--enable-sha3`



x86 \ _64およびAarch64では、デフォルトで有効になっています。


wolfSSL SHA3のサポートを有効にします(小型ビルド用`=small`)



### `--enable-sha512`



x86 \ _64ではデフォルトで有効になっています。


wolfSSL SHA-512サポートを有効にします



### `--enable-sessioncerts`



セッション証明書保存を有効にします



### `--enable-keygen`



キーの生成を有効にします



### `--enable-certgen`



CERT生成を有効にします



### `--enable-certreq`



CERTリクエストの生成を有効にします



### `--enable-sep`



SEP拡張機能を有効にします



### `--enable-hkdf`



hkdf(hmac-kdf)を有効にする



### `--enable-x963kdf`



X9.63 KDFサポートを有効にします



### `--enable-dsa`



デジタル署名アルゴリズム(DSA)を有効にします。


NISTは、FIPS 186-4で定義されているRSAおよびECDSAとともに、RSAおよびECDSAとともに承認されたデジタル署名アルゴリズムと、安全なハッシュ標準(FIPS 180-4)で定義された承認されたハッシュ関数と組み合わせて使用する場合、デジタル署名を生成および検証するために使用されます。



### `--enable-eccshamir`



x86 \ _64ではデフォルトで有効になっています


ECC Shamirを有効にします



### `--enable-ecc`



x86 \ _64ではデフォルトで有効になっています


ECCを有効にします。


このオプションを有効にすると、ECCサポートと暗号スイートがwolfSSLに組み込まれます。



### `--enable-ecccustcurves`



ECCカスタムカーブを有効にする(`=all`すべてのカーブタイプを有効にする)



### `--enable-compkey`



圧縮鍵のサポートを有効にします



### `--enable-curve25519`



Curve25519を有効にします(またはCurve25519 \ _SMALLの場合は`--enable-curve25519=small`)。


楕円曲線は128ビットのセキュリティを提供し、ECDH鍵合意と共に使用されます([クロスコンパイル](#cross-compiling)参照)。Curve25519を有効にすると、Curve25519アルゴリズムを使用できます。デフォルトのCurve25519は、より多くのメモリを使用するように設定されていますが、実行時間が速いです。アルゴリズムを使用するには、メモリが少なく、オプション`--enable-curve25519=small`を使用できます。より少ないメモリを使用すると、スピードではトレードオフがあります。



### `--enable-ed25519`



ED25519(またはED25519 \ _smallの`--enable-ed25519=small`)を有効にする


ED25519オプションを有効にすると、ED25519アルゴリズムを使用できます。デフォルトのED25519は、より多くのメモリを使用するように設定されていますが、実行時間が速いです。アルゴリズムを使用するには、メモリが少なく、オプション`--enable-ed25519=small`を使用できます。curve25519と同様に、この有効化オプションが少なく、スピードとメモリ間のトレードオフです。



### `--enable-fpecc`



固定点キャッシュECCを有効にします



### `--enable-eccencrypt`



ECC暗号化を有効にします



### `--enable-psk`



PSK(事前共有キー)を有効にする



### `--disable-errorstrings`



エラー文字列テーブルを無効にします



### `--disable-oldtls`



古いTLSバージョン<1.2を無効にします



### `--enable-sslv3`



SSLバージョン3.0を有効にします



### `--enable-stacksize`



例のスタックサイズ情報を有効にします



### `--disable-memory`



メモリコールバックを無効にします



### `--disable-rsa`



RSAを無効にします



### `--enable-rsapss`



RSA-PSSを有効にします



### `--disable-dh`



DHを無効にします



### `--enable-anon`



匿名を有効にします



### `--disable-asn`



ASNを無効にします



### `--disable-aes`



AESを無効にします



### `--disable-coding`



コーディングベース16/64を無効にする



### `--enable-base64encode`



x86 \ _64ではデフォルトで有効になっています


base64エンコーディングを有効にします



### `--disable-des3`



DES3を無効にします



### `--enable-arc4`



ARC4を有効にします



### `--disable-md5`



MD5を無効にします



### `--disable-sha`



Shaを無効にします



### `--enable-webserver`



Webサーバーを有効にします。


これは、YASSL内蔵Webサーバーを使用してビルドするための完全な機能を可能にする標準ビルドを介して必要とされる機能をオンにします。



### `--enable-fips`



FIPS 140-2を有効にする(ライセンスを実装する必要があります。)



### `--enable-sha224`



x86 \ _64ではデフォルトで有効になっています


wolfSSL SHA-224サポートを有効にします



### `--disable-poly1305`



wolfSSL Poly1305サポートを無効にします



### `--disable-chacha`



chachaを無効にします



### `--disable-hashdrbg`



ハッシュDRBGサポートを無効にします



### `--disable-filesystem`



ファイルシステムのサポートを無効にします。


これにより、ファイルシステムの使用を無効にすることができます。このオプションは[`NO_FILESYSTEM`](#no_filesystem)を定義します。



### `--disable-inline`



インライン機能を無効にします。


このオプションを無効にすると、wolfSSLにインランスを組み込む機能が無効になります。リンクされていない関数プレースホルダーは、関数インラインが有効になっているときに、コードブロックが関数呼び出しに挿入されます。



### `--enable-ocsp`



オンライン証明書ステータスプロトコル(OCSP)を有効にします。


このオプションを有効にすると、OCSP(Online Certificate Status Protocol)サポートがwolfSSLに追加されます。RFC 6960に記載されているように、X.509証明書の失効状態を取得するために使用されます。



### `--enable-ocspstapling`



OCSPステーリングを有効にします



### `--enable-ocspstapling2`



OCSPステープリングバージョン2を有効にします



### `--enable-crl`



CRL(証明書の取り消しリスト)を有効にする



### `--enable-crl-monitor`



CRLモニターを有効にします。


このオプションを有効にすると、特定のCRL(証明書の取り消しリスト)ディレクトリを積極的に監視する機能が追加されます。



### `--enable-sni`



サーバー名表示を有効にします(SNI)。


このオプションを有効にすると、TLSサーバー名表示(SNI)拡張子がオンになります。



### `--enable-maxfragment`



最大フラグメント長を有効にします。


このオプションを有効にすると、TLSの最大フラグメント長拡張機能がオンになります。



### `--enable-alpn`



アプリケーションレイヤープロトコルネゴシエーション(ALPN)を有効にする



### `--enable-truncatedhmac`



切り捨てられた鍵付きハッシュMac(HMAC)を有効にします。


このオプションを有効にすると、TLS切り捨てられたHMAC拡張機能がオンになります。



### `--enable-renegotiation-indication`



再交渉の表示を有効にします。


[RFC 5746](https://datatracker.ietf.org/doc/html/rfc5746)で説明されているように、この仕様は、再交渉を実行するTLS接続に結び付けることにより、再交渉スプライシングを含むSSL/TLS攻撃を防ぎます。



### `--enable-secure-renegotiation`



安全なRenegotationを有効にします



### `--enable-supportedcurves`



サポートされている楕円曲線を有効にします。


このオプションを有効にすると、TLSサポートされているECC曲線拡張がオンになります。



### `--enable-session-ticket`



セッションチケットを有効にします



### `--enable-extended-master`



拡張マスターシークレットを有効にします



### `--enable-tlsx`



すべてのTLS拡張機能を有効にします。


このオプションを有効にすると、現在wolfSSLでサポートされているすべてのTLS拡張機能がオンになります。



### `--enable-pkcs7`



PKCS＃7サポートを有効にします



### `--enable-pkcs11`



PKCS＃11アクセスを有効にします



### `--enable-ssh`



wolfsshオプションを有効にします



### `--enable-scep`



wolfscepを有効にする(簡単な証明書登録プロトコル)


インターネットエンジニアリングタスクフォースによって定義されているように、単純な証明書登録プロトコルは、PKCS＃7とPKCS＃10を介したPKIです。SCEPは証明書要求を強く認証しないという証明書について説明します。



### `--enable-srp`



安全なリモートパスワードを有効にします



### `--enable-smallstack`



小さなスタックの使用を有効にします



### `--enable-valgrind`



ユニットテストでValgrindを有効にします。


このオプションを有効にすると、wolfSSLユニットテストを実行するときにValgrindがオンになります。これは、開発サイクルの早い段階で問題をキャッチするのに役立ちます。



### `--enable-testcert`



テスト証明書を有効にします。


このオプションが有効になっている場合、通常は公開されていないASN証明書APIの一部を公開します。これは、WolfCryptテストアプリケーション(`wolfcrypt/test/test.c`)に見られるように、テストの目的に役立ちます。



### `--enable-iopool`



I/Oプールの例を有効にします



### `--enable-certservice`



証明書サービスを有効にする(Windows Server)



### `--enable-jni`



Wolfssl Jniを有効にします



### `--enable-lighty`



Lighttpd/Lightyを有効にします



### `--enable-stunnel`



スタンネルを有効にします



### `--enable-md4`



MD4を有効にします



### `--enable-pwdbased`



pwdbasedを有効にします



### `--enable-scrypt`



scryptを有効にします



### `--enable-cryptonly`



WolfCryptのみを有効にします



### `--disable-examples`



ビルド例を無効にします。


有効にすると、wolfSSLのサンプルアプリケーションがビルドされます([クライアント](chapter03.md#client-example)、[サーバ](chapter03.md#server-example)、[心エコリント](chapter03.md#echoclient-example)、[エコーサーバー](chapter03.md#echoserver-example))。



### `--disable-crypttests`



クリプトベンチ/テストを無効にします



### `--enable-fast-rsa`



Intel IPPを使用してRSAを有効にします。


FAST-RSAの有効化IPPライブラリを使用してRSA操作を高速化します。それはより大きなメモリ消費量を有し、デフォルトのRSAはwolfsslによって設定されています。IPPライブラリが見つからない場合は、設定中にエラーメッセージが表示されます。AUTOCONFが検索する最初の場所は、Directory `wolfssl_root/IPP`にあります.2番目は、Linuxシステム上の`/usr/lib/`などのマシン上のライブラリの標準的な場所です。


RSA操作に使用されるライブラリは、ディレクトリ`wolfssl-X.X.X/IPP/`にあり、X.X.Xは現在のwolfSSLバージョン番号です。バンドルされたライブラリからのビルドは、IPPのディレクトリの場所と名前に依存するため、サブディレクトリIPPのファイル構造を変更しないでください。


メモリを割り当てる場合、高速RSA操作には`DYNAMIC_TYPE_USER_CRYPTO`のメモリタグがあります。



### `--enable-staticmemory`



静的メモリ使用を有効にします



### `--enable-mcapi`



マイクロチップAPIを有効にします



### `--enable-asynccrypt`



非同期暗号を有効にします



### `--enable-sessionexport`



セッションのエクスポートとインポートを有効にします



### `--enable-aeskeywrap`



AESキーラップサポートを有効にします



### `--enable-jobserver`



値：`yes`(デフォルト)/ `no`/`#`


`make`を使用すると、マルチスレッドビルドを使用したWOLFSSLをビルドすると、`yes`(デフォルト)CPUコアの数を検出し、そのカウントの推奨されるジョブを使用して、正確な数を指定します。これは`make -j`オプションと同様に機能します。



### `--enable-shared[=PKGS]`



ビルディング共有wolfSSLライブラリ[デフォルト=はい]


共有ライブラリビルドを無効にすると、wolfSSL共有ライブラリがビルドされているのを除外します。デフォルトでは、時間とスペースを節約するために共有ライブラリのみがビルドされています。



### `--enable-static[=PKGS]`



Static wolfSSLライブラリのビルド[デフォルト=いいえ]



### `--with-liboqs=PATH`



OpenQuantumsafeインストールへのパス(デフォルト`/usr/local`)。


これにより、wolfSSLが実験的なTLS 1.3 Quantum-Safe KEMグループ、ハイブリッド量子セーフKEMグループ、LiboqsとのwolfSSL統合を介してFalcon Signature Schemeを使用する機能がオンになります。詳細については、このドキュメントの「Quantum-Safe Cryptographyの実験」を参照してください。



### `--with-libz=PATH`



オプションで、圧縮用のLIBZを含めます。


LIBZを有効にすることで、LIBZライブラリのwolfSSLでの圧縮サポートが可能になります。このオプションを含めて[`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression)を呼び出して使用することについてよく考えてみてください。送信前にデータを圧縮すると、送信されたメッセージの実際のサイズが減少している場合、圧縮によって保存されたデータの量は通常、それを送信するよりも分析するよりも時間がかかります。最も遅いネットワークを除くすべてのすべてに生まれます。



### `--with-cavium`



キャビウム/ソフトウェアディレクトリへのパス。



### `--with-user-crypto`



ユーザー\ _cryptoインストールへのパス(デフォルト`/usr/local`)。



### `--enable-rsavfy`



RSA Verify Onlyサポートを有効にします(** Note **は[`--enable-cryptonly`](#--enable-cryptonly)を必要とします)。



### `--enable-rsapub`



デフォルト値：有効なRSA公開キーのみサポート(**注**には[`--enable-cryptonly`](#--enable-cryptonly)が必要です)



### `--enable-armasm`



ARMV8 ASMサポートを有効にします。


デフォルトの構成は、64対32ビットシステムに基づいてMCPUまたはMFPUを設定します。CPPFLAGSを使用して渡されたMCPUまたはMFPU設定を上書きしません。一部のコンパイラでは、constraiantsのために`-mstrict-align`が必要になる場合があり、`CPPFLAGS`でユーザーがMCPU/MFPUフラグに合格しない限り、`-mstrict-align`もデフォルトで設定されます。



### `--disable-tlsv12`



TLS 1.2のサポートを無効にします



### `--enable-tls13`



TLS 1.3サポートを有効にします


このビルドオプションを[`--disable-tlsv12`](#--disable-tlsv12)および[`--disable-oldtls`](#--disable-oldtlx)と組み合わせて、TLS 1.3のみであるwolfSSLビルドを生成できます。



### `--enable-all`



SSL V3を除くすべてのwolfSSL機能を有効にします



### `--enable-xts`



AES-XTSモードを有効にします



### `--enable-asio`



ASIOを有効にします。


オプション[`--enable-opensslextra`](#--enable-opensslextra)と[`--enable-opensslall`](#--enable-opensslall)がwolfSSLを設定するときに有効にする必要があります。これら2つのオプションが有効になっていない場合、autoconfツールは自動的にこれらのオプションを有効にして、wolfSSLを設定するときにASIOを有効にします。



### `--enable-qt`



QT 5.12以降のサポートを有効にします。


wolfSSL QTポートと互換性のあるwolfSSLビルド設定を有効にします。QTソースファイルにパッチを当てるには、wolfSSLからパッチファイルが必要です。



### `--enable-qt-test`



QTテスト互換性のビルドを有効にします。


組み込みのQTテストの実行との互換性のために、wolfSSLをビルドするためのサポートを有効にします。



### `--enable-apache-httpd`



Apache httpdサポートを有効にします



### `--enable-afalg`



ハードウェアの付着にLinuxモジュールAF \ _Algを使用できるようにします。`=xilinx`、`=xilinx-rsa`、`=xilinx-aes`、`=xilinx-sha3`での追加のXilinx使用


Crypto操作をオフロードするためのLinuxカーネルモジュール(AF \ _alg)を活用するという点で[`--enable-devcrypto`](#--enable-devcrypto)と似ています。一部のハードウェアでは、モジュールにはLinux Cryptoドライバを介して利用可能なパフォーマンスアクセラレーションがあります。ザイリンクスを使用したPetalinuxの場合、Flag `--enable-afalg=xilinx`を使用して、af \ _algのザイリンクスインタフェースを使用するようにwolfSSLに指示できます。



### `--enable-devcrypto`



ハードウェアアクセラレーションにLinux `/dev/crypto`を使用できます。


引数を受け取る機能があり、`aes`(すべてのAESサポート)、`hash`(すべてのハッシュアルゴリズム)、および`cbc`(AES-CBCのみ)の任意の組み合わせを受け取ることができます。オプションが与えられていない場合、`all`を使用することはデフォルトです。



### `--enable-mcast`



wolfSSL DTLSマルチキャストサポートを有効にします



### `--disable-pkcs12`



PKCS12コードを無効にします



### `--enable-fallback-scsv`



シグナリング暗号スイート値(SCSV)を有効にします。



### `--enable-psk-one-id`



TLS 1.3を使用した単一のPSK IDのサポートを有効にします



### `--enable-cryptocb`



暗号コールバックを有効にします。wc_cryptocb_registerDeviceを使用して暗号コールバックを登録し、wolfssl_ctx_setdevidを使用して関連付けられているdevidを設定します。


`--enable-cryptocb`で次の2つの定義を使用して、RSAまたはECCソフトウェアフォールバックをコンパイルして、ソフトウェアRSA/ECCが不要な場合のフットプリント削減のために最適化できます。



* WOLF_CRYPTO_CB_ONLY_RSA  -  RSAソフトウェアCrypto Fallackをコンパイルします


* WOLF_CRYPTO_CB_ONLY_ECC  -  ECCソフトウェアCrypto Fallackをコンパイルします



wolf_crypto_cb_only_*オプションの使用には、例を無効にする必要があります。[`--disable-examples`](#disable-examples)を参照してください



## 特別な数学最適化フラグ




### `--enable-fastmath`



x86 \ _64およびAarch64では、デフォルトで有効になっています。他のすべてのアーキテクチャでは、デフォルトはBig Integer Mathライブラリです。Single Precision(SP)数学が有効になっていると、FastMathとBig Integerライブラリの両方が無効になっています。


use_fast_mathおよびBig Integer Math Libraryセクションを参照してください。



### `--enable-fasthugemath`



Fast Math +巨大なコードを有効にします。


FastHugeMathの有効化にはFastMathライブラリのサポートが含まれており、公開鍵操作中の一般的なキーサイズの場合はロープのレオップを展開することでコードサイズを大幅に増やします。FastHugeMathを使用して、わずかなスピードアップがコードサイズの増加する価値があるかどうかを確認する前後にベンチマークユーティリティを使用してみてください。



### `--enable-sp-math`



制限されたアルゴリズムスイートを使用した単一精度(SP)数学実装を有効にします。サポートされていないアルゴリズムは無効になっています。オーバーライド`--enable-sp`、`--enable-sp-math-all`、`--enable-fastmath`および`--enable-fasthugemath`。



### `--enable-sp-math-all`



フルアルゴリズムスイートで単精度(SP)数学の実装を有効にします。サポートされていないアルゴリズムが有効になっていますが、オプション化されていません。オーバーライド`--enable-sp`,`--enable-fastmath` ,`--enable-fasthugemath`。



### `--enable-sp-asm`



単一精度(SP)アセンブリの実装を有効にします。


Intel x86 \ _64およびARMアーキテクチャを使用したアセンブリを通して単精度性能の向上を可能にするために使用できます。



### `--enable-sp=OPT`



RSA、DH、およびECCの単一精度(SP)数学を有効にして、パフォーマンスを改善します。


OPTには多くの可能な値があります。以下は、Enable-SPを呼び出す方法のリストと、結果として定義される結果のマクロです。これらはすべて、com睡分離リストに組み合わせることができます。たとえば、`--enable-sp=ec256,ec384`。定義されるマクロの意味は、[wolfSSL独自の単一精度(SP)数学サポート]セクションで上記で定義されています。


**注**：これはx86_64用で、他の構成フラグはありません。結果は、指定するアーキテクチャやその他の構成フラグによって異なる場合があります。たとえば、Wolfssl_sp_384およびWolfssl_sp_4096は、Intel X86_64に対してのみ有効になります。



#### `--enable-sp=no`または`--disable-sp`



新しいマクロは定義されていません。`--enable-sp`を使用しないことに相当します。



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





#### `--enable-sp=4096`または`--enable-sp=+4096`




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



他のアルゴリズムオプションと組み合わせて、それらのオプションに対してアセンブリコードがオンになっていることを示します。例えば、`--enable-sp=rsa2048,asm`。



## クロスコンパイル



埋め込まれたプラットフォーム上の多くのユーザーは、環境のためにwolfSSLをcrossしています。ライブラリを交差させる最も簡単な方法は、`./configure`システムを使用することです。MakeFileを生成し、wolfSSLをビルドするために使用できます。


クロスコンパイルの場合、次のような`./configure`にホストを指定する必要があります。



```sh
./configure --host=arm-linux
```



また、使用するコンパイラ、リンカーなどを指定する必要がある場合があります。



```sh
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```



Configure Systemには、Cross ComplingとMallocをオーバーライドするユーザーの検出時に表示される可能性があるバグがあります。`rpl_malloc`および/または`rpl_realloc`への未定義参照を取得した場合は、`./configure`行に次のものを追加してください。



```sh
ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
```



クロスコンパイルのためにwolfSSLを正しく設定した後は、ライブラリのビルドとインストールのための標準的なAutoConfプラクティスに従うことができるはずです。



```sh
make
sudo make install
```



WolfsSLのクロスコンパイルに関する追加のヒントやフィードバックがある場合は、[info@wolfssl.com](mailto:info@wolfssl.com)までお知らせください。



### サンプルクロスコンパイルツールチェーンビルドの構成オプションを構成します




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
./configure --enable-static --disable-shared \--host=arm-linux CC=arm-linux-gcc \
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




#### MIPS32  -  glibc.




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




## 2.7ビルディングポート



wolfSSLは多くの環境やデバイスに移植されました。これらのポートの一部とそれらのマニュアルはディレクトリ`wolfssl-X.X.X/IDE`にあります。ここで、x.x.xは現在のwolfSSLバージョン番号です。このディレクトリには、環境用のwolfSSLをビルドするために使用されているIDEの有用な情報とコードも含まれています。


ポートリスト：



* Arduino



* LPCXPRESSO



* Wiced Studio



* csbench


* SGX WindowsとLinux

*これらのディレクトリ(`wolfssl/IDE/WIN-SGX`および`wolfssl/IDE/LINUX-SGX`)には、Intel SGXプロジェクトで使用されるライブラリとしてwolfSSLをビルドするためのMakefilesおよびVisual Studioソリューションが含まれています。

* Hexagon


*このディレクトリ(`wolfssl/IDE/HEXAGON`)には、Hexagonツールチェーンを備えたビルド用のMakeFileが含まれています。ECC検証操作をDSPプロセッサにオフロードするためのwolfSSLをビルドするために使用できます。ディレクトリには、ビルドに必要な手順を支援するReadMeファイルが含まれています。

* Hexiwear



* NetBurner M68K

*ディレクトリ(`wolfssl/IDE/M68K`)には、NetBurner RTOを使用してMCF5441Xデバイス用のwolfSSLをビルドするためのMakeFileがあります。

* ルネサス

*このディレクトリ(`wolfssl/IDE/Renesas`)は、ルネサスデバイスの異なる複数のビルドを含みます。ハードウェアアクセラレーションを使用して実証するビルド例もあります。

* xcode


* Eclipse



* Espressif



* IAR-EWARM



* Kinetis Design Studio(KDS)


* Rowley Crossworks Arm


* OpenSTM32


* RISCV



* Zephyr



* mynewt


* INTIME-RTOS

