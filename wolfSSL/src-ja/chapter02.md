# wolfSSLのビルド

wolfSSLはポータビリティを念頭に置いて書かれており、一般的にほとんどのシステムで容易にビルドできます。
wolfSSLをビルドするのが難しい場合は、サポートフォーラム(<https://www.wolfssl.com/forums>)を通してサポートを求めるか、[support@wolfssl.com](mailto:support@wolfssl.com)に遠慮なく直接お問い合わせください。

この章では、UnixとWindowsでwolfSSLをビルドする方法を説明し、非標準環境でwolfSSLをビルドする場合のガイダンスも提供します。
[第3章](chapter03.md)に入門ガイド、[第11章](chapter11.md)にSSLチュートリアルをご用意しています。

autoconf/automakeシステムを使用してwolfSSLをビルドする場合、単一のMakefileを使用してwolfSSLライブラリの全てのパーツとサンプルプログラムを一度にビルドします。
これは、Makefileを再帰的に使用するよりもシンプルかつ高速です。

## wolfSSLソースコードの取得

最新バージョンのwolfSSLは、wolfSSLのWebサイトからZIPファイルとしてダウンロードできます。

<https://wolfssl.jp/download/>

zipファイルをダウンロードしたら、`unzip`コマンドを使用してファイルを解凍します。
ネイティブの行末文字を使用するには、unzipを使用する際に`-a`オプションを有効にします。
unzipのmanページでは、`-a`オプションの機能が次のように説明されています。

> [...] -aオプションを指定すると、zipによってテキストファイル（zipinfoのリストで「b」ではなく「t」ラベルがついているファイル）と識別されたファイルは、テキストとして自動的に展開され、必要に応じて行末文字、ファイル終端文字、および文字セットそのものが変換されます。[...]

ソースコードはGitHubからも入手できます。

```sh
git clone https://github.com/wolfSSL/wolfssl.git
```

gitでチェックアウトしたソースには`configure`スクリプトが含まれていません。
以下の手順に進む前に、wolfSSLのルートディレクトリで`./autogen.sh`を実行して生成してください。
これにはautoconf（2.69以降）、automake（1.13.4以降）、およびlibtool（2.4.2以降）が必要です。
リリース版のZIPファイルには、すでに`configure`が含まれています。

**注**：wolfSSLヘッダーファイルの場所については、[第9章](chapter09.md)の「ライブラリヘッダー」節を参照してください。
wolfSSLネイティブの構造体の名前については、[第9章](chapter09.md)の「構造体の使用」節を参照してください。

## Unix系システムでのビルド

Linux、\*BSD、OS X、Solaris、またはその他の\*nixのようなシステムにwolfSSLをビルドする場合、autoconfシステムを使用します。
wolfSSLをビルドするには、wolfSSLルートディレクトリから2つのコマンド`./configure`および`make`を実行するだけです（gitでチェックアウトしたソースからビルドする場合は、先に`./autogen.sh`を実行してください）。

`./configure`スクリプトはビルド環境をセットアップし、任意の数のビルドオプションを`./configure`に追加します。
利用可能なビルドオプションのリストについては、この章の「ビルドオプション」節を参照するか、次のコマンドラインを実行して、`./configure`に渡すことができるオプションのリストを表示させてください。

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

`./configure`は、ビルド設定を記録したヘッダー`wolfssl/options.h`を生成します。
アプリケーションをライブラリと同じ設定でコンパイルするために、アプリケーションでは他のどのwolfSSLヘッダーよりも前に`#include <wolfssl/options.h>`を記述する必要があります（または、wolfSSLのヘッダーに`options.h`を自動的にインクルードさせる`WOLFSSL_USE_OPTIONS_H`を定義します）。

ビルドをテストするには、wolfSSLのルートディレクトリからtestsuiteプログラムを実行します。

```sh
./testsuite/testsuite.test
```

あるいは、autoconfを使用してtestsuiteを実行し、標準のwolfSSL APIおよび暗号テストを実行します。

```sh
make test
```

testsuiteプログラムの予想される出力に関する詳細は、[第3章](chapter03.md)の「テストスイート」節にあります。
もし、wolfSSLライブラリのみのビルドが必要で、そのほかのコンポーネント（サンプルプログラム、テストスイート、ベンチマークアプリケーション等）はビルドしたくない場合には、wolfSSLのルートディレクトリで下記コマンドを実行してください。

```sh
make src/libwolfssl.la
```

### DebianおよびRPMパッケージのビルド

必要なオプションを指定して`./configure`を実行した後、`make deb`を実行するとその構成でDebianパッケージ（Debian、Ubuntu、Linux Mintおよびその派生ディストリビューション向け）を、`make rpm`を実行するとRPMパッケージ（RHEL、Fedora、CentOS、SUSE、openSUSE向け）をビルドできます。
`make deb-docker`および`make rpm-docker`は、同じパッケージをDockerコンテナ内でビルドします。

## CMakeによるビルド

wolfSSLは、CMake 3.16以降（3.22以降を推奨）を使用して構成およびビルドすることもできます。
autoconfによるビルドが主要なビルドシステムです。
CMakeによるビルドは一般的に使用されるオプションをサポートしていますが、`./configure`の全てのオプションをサポートしているわけではありません。

CMakeではソースディレクトリ内でのビルドが許可されていないため、別のビルドディレクトリを作成します。
wolfSSLのルートディレクトリから次のように実行します。

```sh
mkdir build
cd build
cmake ..
cmake --build .
```

`cmake --build .`は、基盤となるビルドツール（Unix系システムではデフォルトで`make`）を実行します。
このビルドツールを直接実行することもできます。

ビルドオプションは、`cmake`コマンドラインで`-D<option>=yes`または`-D<option>=no`を使用して設定します。
例えば、`cmake .. -DWOLFSSL_TLS13=no`は`./configure --disable-tls13`と同等であり、`cmake .. -DWOLFSSL_CURVE25519=yes`は`./configure --enable-curve25519`と同等です。
全てのオプションをその説明と現在の値とともに一覧表示するには、ビルドディレクトリから`cmake -LH ..`を実行するか、CMake GUIを使用するか、初回実行後に`CMakeCache.txt`を参照してください。
その他の便利な設定は次のとおりです。

* `-DCMAKE_BUILD_TYPE=Debug`は、デバッグ情報付きでビルドします。
* `-DBUILD_SHARED_LIBS=OFF`は、デフォルトの共有ライブラリの代わりに静的ライブラリをビルドします。
* `-DWOLFSSL_EXAMPLES=no`および`-DWOLFSSL_CRYPT_TESTS=no`は、サンプルアプリケーション、およびwolfCryptテストとベンチマークのビルドをスキップします。

`./configure`と同様に、CMakeもビルド設定を記録した`wolfssl/options.h`を生成します。
デフォルトでは、このファイルはソースツリーではなくビルドディレクトリに書き込まれます。
サンプルプログラム、ユニットテスト、wolfCryptテストおよびベンチマークもビルドディレクトリにビルドされ、そこで`ctest`を実行するとユニットテストとwolfCryptテストが実行されます。

### CMakeによるwolfSSLのインストールと利用

`cmake --install .`は、ライブラリ、ヘッダー（`options.h`を含む）、pkg-configファイル`wolfssl.pc`、およびCMakeパッケージファイルをインストールします。
インストール先を選択するには`--prefix /path/to/install`を追加するか、構成時に`CMAKE_INSTALL_PREFIX`を設定します。
これにより、他のCMakeプロジェクトは`find_package()`でwolfSSLを検出し、インポートされた`wolfssl::wolfssl`ターゲットにリンクできます。

```cmake
find_package(wolfssl CONFIG REQUIRED)
target_link_libraries(my_app PRIVATE wolfssl::wolfssl)
```

wolfSSLを標準以外の場所にインストールした場合は、そのプロジェクトの構成時に`-DCMAKE_PREFIX_PATH=/path/to/install`を指定します。
最小限のサンプルプロジェクトが`cmake/consumer`にあります。
autoconfによるビルドの`make install`も、`find_package(wolfssl)`をサポートするために`$(libdir)/cmake/wolfssl`の下にCMakeパッケージファイルをインストールします。
これを無効にするには`./configure --disable-cmake-install`を使用します。

### WindowsでのCMake

CMake GUIを使用する場合は、「Where is the source code」にwolfSSLのルートディレクトリを、「Where to build the binaries」にビルドディレクトリ（例えば`wolfssl/build`）を設定し、「Configure」をクリックして必要に応じてオプションを変更した後、「Generate」をクリックします。
ビルドディレクトリに生成された`wolfssl.sln`をVisual Studioで開きます。
あるいは、Visual Studio開発者コマンドプロンプトから（または`vcvars64.bat`を実行した後に）上記のコマンドラインの手順を実行することもできます。

ルートディレクトリにある`CMakePresets.json`では、`vs2022-x64`プリセットを定義しています。
`cmake --preset vs2022-x64`を実行すると、`build`ディレクトリにVisual Studio 2022 x64ソリューションが生成されます。
Visual Studio 2022（17.1以降）でwolfSSLフォルダーを直接開いた場合も、このファイルが使用されます。

## vcpkgによるインストール

wolfSSLは[vcpkg](https://github.com/microsoft/vcpkg)のポートとしても利用できます。
このポートはwolfSSLが最新の状態に維持しています。

```sh
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
./vcpkg install wolfssl
```

Windowsでは、`./bootstrap-vcpkg.sh`の代わりに`bootstrap-vcpkg.bat`を実行します。

## Windowsの上でのビルド

以下の説明に加えて、Visual StudioでwolfSSLをビルドするための手順とヒントは[ここ](https://wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio.html)でも提供しています。
WindowsではCMakeを使用してwolfSSLをビルドすることもできます。
「WindowsでのCMake」節を参照してください。

### Visual Studio

wolfSSLのルートディレクトリにあるソリューション`wolfssl64.sln`を開きます。
このソリューションは、wolfSSLライブラリ（`wolfssl.vcxproj`）、testsuite、sslSniffer、およびclient、server、echoclient、echoserverの各サンプルプログラムを、Win32、x64、ARM64向けにビルドします。
これらのプロジェクトはVisual Studio 2012（v110）のプラットフォームツールセットを使用しています。
より新しいバージョンのVisual Studioでは、インストールされているツールセットにプロジェクトを再ターゲットできます。

Visual Studio 2022向けには、v143ツールセットを使用するライブラリプロジェクト`wolfssl-VS2022.vcxproj`を用意しています。
ソリューション`wolfcrypt/test/test-VS2022.sln`および`wolfcrypt/benchmark/benchmark-VS2022.sln`は、このライブラリをwolfCryptテストおよびベンチマークアプリケーションと共にビルドします。

FIPSビルド用のソリューション（wolfSSLから提供されるFIPSソースバンドルが必要です）は、`IDE/WIN10`（FIPS v2およびFIPS v5以降）、`IDE/WIN-PQ-FIPSv7`（FIPS 140-3 v7.0.0）、`IDE/WIN`（当初のFIPS証明書 #2425）にあります。
各ディレクトリのREADMEを参照してください。

各ビルドをテストするには、Visual Studioメニューから「Build > Build Solution」を選択し、testsuiteプログラムを実行します。
Visual Studioプロジェクトのビルドオプションを編集するには、目的のプロジェクト（wolfssl、echoclient、echoserverなど）を選択し、「プロパティ」パネルを参照してください。

**注意**：wolfSSL v3.8.0リリース以降、ビルドプリプロセッサマクロは`IDE/WIN/user_settings.h`にある中央ファイルに移動しました。
このファイルはプロジェクト内でも見つけることができます。
ChaCha20/Poly1305やCurve25519などの機能を追加するには、`HAVE_CHACHA` / `HAVE_POLY1305`や`HAVE_CURVE25519`などの`#defines`をここに追加します。

### Cygwin

Windows開発マシン上でWindows用のwolfSSLをビルドする場合は、リポジトリに含まれるVisual Studioプロジェクトファイルを使用してビルドすることをお勧めします。
しかしCygwinが必要な場合は、当社チームがビルドに成功した際のガイダンスがありますから以下にご紹介します。

1. <https://www.cygwin.com/install.html> にアクセスして `setup-x86_64.exe` をダウンロードします。
2. `setup-x86_64.exe` を実行し、希望する方法でインストールします。
   「Select Packages」段階に到達するまでインストールメニューをクリックします。
3. 「+」アイコンをクリックして「All」を展開します。
4. 「Archive」セクションに移動し、「unzip」ドロップダウンをクリックして、「Skip」を現在のバージョンに変更します。
5. 「Devel」の下で、「autoconf」、「automake」、「gcc-core」、「git」、「libtool」、「make」のそれぞれについて同様に操作し、各パッケージの現在のバージョンを選択します。
6. 「Next」をクリックして、インストールの残りの部分を進めます。

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
git clone https://github.com/wolfssl/wolfssl.git
cd wolfssl
./autogen.sh
./configure
make
make check
```

## 各社IDEによるビルド

wolfSSLサイトからwolfSSLソースコード一式をダウンロード、解凍して以下の設定をします。

### 1. wolfSSLライブラリー生成プロジェクト

- **コンパイル対象のソースファイルの登録**  
  `./src`内の全ての`*.c`ファイルと、`./wolfcrypt/src`直下の全ての`*.c`ファイルを登録します。
  `./wolfcrypt/src/port/<vendor>/`内のファイルおよびアセンブリファイル（`.S` / `.asm`）は、ターゲットに応じて必要な場合にのみ追加します。  
  以下のファイルは他のソースファイルから`#include`されるもので、個別にコンパイルしてはならないため、除外してください。

        src/ssl_*.c          (all ssl_*.c files; keep src/ssl.c itself)
        src/x509.c  src/x509_str.c
        src/bio.c  src/conf.c
        src/pk.c  src/pk_ec.c  src/pk_rsa.c
        wolfcrypt/src/evp.c  wolfcrypt/src/evp_pk.c
        wolfcrypt/src/asn_orig.c  wolfcrypt/src/asn_tsp.c
        wolfcrypt/src/asm.c
        wolfcrypt/src/misc.c  (unless NO_INLINE is defined)

- **コンフィグレーションオプションの定義**  
  ファイル名`user_settings.h`のヘッダーファイルにコンフィグレーション定義を格納します。  
  以下を参照してください。
    - `wolfssl/examples/configs/README.md`
    - `wolfssl/examples/configs/user_settings_template.h`

- **プリディファインドマクロ名の登録**  
  `WOLFSSL_USER_SETTINGS`を定義すると、ビルド時に上記の`user_settings.h`ファイルがインクルードされます。

- **インクルードパスの登録**  
  wolfSSLソースファイルルートのパスと上記`user_settings.h`のパスを登録します。

---

### 2. アプリケーション実行ファイル生成プロジェクト

- 手順1で生成したwolfSSLライブラリーをリンク対象として登録します。
- wolfSSLソースファイルルートのパスと、手順1で定義したコンフィグレーションオプション（`user_settings.h`）のパスをインクルードパスとして登録します。
- プリディファインドマクロ名として`"WOLFSSL_USER_SETTINGS"`を指定します。

## 非標準環境でのビルド

公式にはサポートしていませんが、特に組み込み向けやクロスコンパイルシステムを使用して、非標準環境でwolfSSLをビルドしたいユーザーを支援するよう努めています。
以下にいくつかの注意点を示します。

1. ソースファイルとヘッダーファイルは、wolfSSLダウンロードパッケージ内にあるのと同じディレクトリ構造を維持する必要があります。
2. 一部のビルドシステムでは、wolfSSLヘッダーファイルの場所を明示的に知りたい場合があるため、それを指定する必要があるかもしれません。
   それらは`<wolfssl_root>/wolfssl`ディレクトリにあります。
   通常は、インクルードパスに`<wolfssl_root>`ディレクトリを追加することでヘッダーの問題を解決できます。
3. wolfSSLは、configureプロセスがビッグエンディアンを検出しない限り、デフォルトでリトルエンディアンシステムとなります。
   非標準環境でビルドするユーザーはconfigureプロセスを使用していないため、ビッグエンディアンシステムを使用している場合は`BIG_ENDIAN_ORDER`を定義する必要があります。
4. wolfSSLは64ビット型を利用できると速度が向上します。
   configureプロセスはlongまたはlong longが64ビットかどうかを判断し、defineを設定します。
   したがって、システム上で`sizeof(long)`が8バイトの場合は、`SIZEOF_LONG 8`を定義してください。
   そうでなく、`sizeof(long long)`が8バイトの場合は、`SIZEOF_LONG_LONG 8`を定義します。
   どちらも定義されていない場合、`wolfssl/wolfcrypt/types.h`はこれらの検出を試みます。
   `HAVE_LIMITS_H`または`_WIN32`が定義されている場合は`limits.h`から、それ以外の場合は一般的な64ビットコンパイラマクロ（`__x86_64__`や`__aarch64__`など）から検出します。
   手動での定義は、この検出が失敗した場合にのみ必要です。
5. ライブラリのビルドを試み、問題が発生した場合はお知らせください。
   サポートが必要な場合は、[support@wolfssl.com](mailto:support@wolfssl.com)までご連絡ください。
6. ビルドを変更できる定義の一部は、「Cプリプロセッサマクロとして定義される機能」節に示しています。
   多くのオプションの詳細な説明については、「ビルドオプション」節を参照してください。

### Yocto Linuxへのビルド

wolfSSLはYocto LinuxとOpenEmbeddedでwolfSSLをビルドするためのレシピも含んでいます。
これらのレシピはmeta-wolfSSLレイヤーとしてGitHubリポジトリ（<https://github.com/wolfSSL/meta-wolfssl>）で管理しています。
Yocto LinuxでwolfSSLをビルドするにはGitとbitbakeが必要です。
以下に、Yocto Linux上でwolfSSL製品（レシピが存在するもの）をビルドする方法を説明します。

1. **wolfSSL metaをクローン**

    次のURLをgit cloneコマンドでクローンします。
    <https://github.com/wolfSSL/meta-wolfssl>

2. **「meta-wolfSSL」レイヤーをビルドのbblayers.confに挿入**

    `BBLAYERS`セクション内で、meta-wolfsslをクローンした場所へのパスを追加します。
    例：

    ```sh
    BBLAYERS ?= "... \
    /path/to/meta-wolfssl/ \
    ..."
    ```

3. **wolfSSL製品レシピをビルド**

    bitbakeを使用して、*wolfssl*、*wolfssh*、*wolfmqtt*、*wolftpm*、*wolfclu*、*wolfpkcs11*、*wolfprovider*、*wolfengine*などのwolfSSL製品レシピをビルドできます（全一覧はmeta-wolfssl READMEを参照してください）。
    これらのレシピのいずれかをbitbakeコマンドに渡すだけです（例：`bitbake wolfssl`）。
    これにより、ユーザーはコンパイルが問題なく成功することを確認できます。

4. **local.confを編集**

    最後のステップは、ビルドの`local.conf`ファイルを編集して、ビルド中のイメージに必要なライブラリを含めることです。
    希望するレシピの名前を含むように`IMAGE_INSTALL:append`行を編集します。
    以下にその例を示します。

    ```sh
    IMAGE_INSTALL:append = " wolfssl wolfssh wolfmqtt"
    ```

    引用符内の先頭にスペースがあることに注意してください。
    `append`は区切り文字を追加しないため、このスペースがないと最初の名前が直前のエントリーに連結されてしまいます。
    コロンによるオーバーライド構文は、Yocto Dunfell (3.1)以降で使用されます。
    それより古いリリースでは、代わりに`IMAGE_INSTALL_append`を使用します。

イメージがビルドされると、wolfSSLのデフォルトの場所（またはレシピからの関連製品）は`/usr/lib/`ディレクトリになります。

さらに、wolfSSLは「ビルドオプション」節にリストされている有効化および無効化オプションを使用して、Yoctoにビルドする際にカスタマイズできます。
これには、`.bbappend`ファイルを作成し、wolfSSLアプリケーション/レシピレイヤー内に配置する必要があります。
このファイルの内容には、`EXTRA_OECONF`変数に連結する内容を指定する行を含める必要があります。
以下に、デフォルトで無効になっているCurve25519のサポートを有効にする例を示します。

```sh
EXTRA_OECONF += " --enable-curve25519"
```

Yoctoへのビルドに関する詳細なドキュメントは、meta-wolfssl README（<https://github.com/wolfSSL/meta-wolfssl/blob/master/README.md>）に掲載しています。

### STM32CubeIDEでのビルド

STM32デバイス向けには、wolfSSLをSTM32CubeMXおよびSTM32CubeIDE用のCubeパックであるI-CUBE-wolfSSLとして提供しています。
CubeMXプロジェクトにwolfSSLパックのコンポーネントを追加し（「Software Packs」->「Select Components」）、パックのパラメータを設定してコードを生成した後、STM32CubeIDEでプロジェクトを開きます。
`<wolfssl_root>/IDE/STM32Cube`のサンプルは、wolfCryptテスト、wolfCryptベンチマーク、およびTLSクライアント/サーバーテストを実行します。
パックのインストール方法、サンプルプロジェクト、および設定オプションについては、`<wolfssl_root>/IDE/STM32Cube/README.md`を参照してください。

### IARでのビルド

`<wolfssl_root>/IDE/IAR-EWARM/Projects`ディレクトリには、以下のファイルが含まれています。

1. ワークスペース：`wolfssl.eww`
   ワークスペースには、wolfSSL-LibライブラリとwolfCrypt-test、wolfCrypt-benchmark実行可能プロジェクトが含まれています。
2. wolfSSL-Libプロジェクト：`lib/wolfSSL-Lib.ewp`
   wolfCryptとwolfSSL関数の完全なセットライブラリを生成します。
3. テストスイートプロジェクト：`test/wolfCrypt-test.ewp`
   test.outテストスイート実行可能ファイルを生成します。
4. ベンチマークプロジェクト：`benchmark/wolfCrypt-benchmark.ewp`
   benchmark.outベンチマーク実行可能ファイルを生成します。

Segger embOS RTOSで使用するためのプロジェクトは`<wolfssl_root>/IDE/IAR-EWARM/embOS`にあります。

これらのプロジェクトは一般的なARM Cortex-M MCU向けに設定されています。
特定のターゲットMCU用のプロジェクトを生成するには、以下の手順を実行してください。

1. デフォルト設定：プロジェクトのデフォルトターゲットはCortex-M3シミュレータに設定されています。
   user_settings.hにはプロジェクトのデフォルトオプションが含まれています。
   シミュレータに対してビルドしてダウンロードできます。
   「view」->「Terminal I/O」でターミナルI/Oウィンドウを開き、実行を開始します。

2. プロジェクトオプション設定：各プロジェクトに適切な「ターゲット」オプションを選択します。

3. 実行可能プロジェクトの場合：MPU用の「SystemInit」と「startup」を追加し、デバッグ用の「ドライバ」を選択します。

4. ベンチマークプロジェクトの場合：current_time関数のオプションを選択するか、`WOLFSSL_USER_CURRTIME`オプションで独自の「current_time」ベンチマークタイマーを作成します。

5. ビルドとダウンロード：EWARMビルドとダウンロードのために、メニューバーの「Project->Make」と「Download and Debug」に進みます。

### macOSやiOSでのビルド

#### XCODE

`<wolfssl_root>/IDE/XCODE`ディレクトリには、以下のファイルが含まれています。

1. `wolfssl.xcworkspace` -- ライブラリとテストスイートクライアントを含むワークスペース
2. `wolfssl_testsuite.xcodeproj` -- テストスイートを実行するプロジェクト
3. `wolfssl.xcodeproj` -- wolfSSLおよび/またはwolfCrypt用のmacOS、iOS、tvOSライブラリをビルドするプロジェクト
4. `wolfssl-FIPS.xcodeproj` -- 利用可能な場合、wolfSSLとwolfCrypt-FIPSをビルドするプロジェクト
5. `user_settings.h` -- プロジェクト間で共有されるカスタムライブラリ設定

ライブラリは、ターゲットに応じて`libwolfssl_osx.a`、`libwolfssl_ios.a`、または`libwolfssl_tvos.a`として出力されます。
また、wolfSSL/wolfCryptヘッダーを`Build/Products/Debug`または`Build/Products/Release`にある`include`ディレクトリにコピーします。

ライブラリとテストスイートを適切にリンクするには、ビルドの場所をワークスペースに対して相対的に設定する必要があります。

1. File -> Workspace Settings（またはXcode -> Settings -> Locations）
2. Derived Data -> Advanced
3. Custom -> Relative to Workspace
4. Products -> Build/Products

これらのXcodeプロジェクトは、複数のプロジェクトでマクロを設定するための`user_settings.h`ファイルを有効にするために、`WOLFSSL_USER_SETTINGS`プリプロセッサを定義しています。

必要に応じて、Xcodeプリプロセッサは以下の手順で変更できます。

1. 「Project Navigator」でプロジェクトをクリックします。
2. 「Build Settings」タブをクリックします。
3. 「Apple Clang - Preprocessing」セクションまでスクロールします。
4. 「Preprocessor Macros」の開示を開き、「+」と「-」ボタンを使用して変更します。
   これをDebugとReleaseの両方に対して行ってください。

このプロジェクトでは、デフォルト設定でwolfSSLとwolfCryptをビルドできるはずです。

#### configureでビルドするユニバーサルフレームワーク

`<wolfssl_root>/IDE/apple-universal/build-wolfssl-framework.sh`は、`./configure`を使用してwolfSSLをmacOS、iOS、tvOS、watchOSの各デバイスおよびそのシミュレータ向けの静的ライブラリとしてビルドし、その結果をXcodeプロジェクトに追加できる`xcframework`としてパッケージ化します。
追加のconfigureオプションは`-c "<options>"`で渡すことができます。
このディレクトリには、このフレームワークを使用するマルチプラットフォームXcodeアプリのサンプルも含まれています。
詳細はその`README.md`を参照してください。

Apple Silicon (ARM64) Macで`./configure`を使用してビルドする場合は、ホストCPUが`aarch64`として検出されていることを確認してください。
検出されていない場合は、`./configure`に`--host=aarch64-apple-darwin`を渡してください。

### GCC ARMでのビルド

`<wolfssl_root>/IDE/GCC-ARM`ディレクトリには、Cortex Mシリーズ用のwolfSSLプロジェクト例がありますが、他のアーキテクチャに適用することもできます。

1. `gcc-arm-none-eabi`がインストールされていることを確認してください。
2. `Makefile.common`を変更します。
   * 正しいツールチェーンパス`TOOLCHAIN`を使用します。
   * 正しいアーキテクチャ「ARCHFLAGS」を使用します。[GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html) `-mcpu=name`を参照してください。
   * linker.ldのメモリマップがフラッシュ/RAMと一致することを確認するか、`Makefile.common`の`SRC_LD = -T./linker.ld`をコメントアウトします。
3. `make`を使用して、静的ライブラリ（libwolfssl.a）、wolfCryptテスト/ベンチマーク、およびwolfSSL TLSクライアントとサーバーのターゲットを`./Build`内に`.elf`と`.hex`としてビルドします。

#### 一般的なMakefileを使ったクロスコンパイルによるビルド

Cortex-A53を搭載したRaspberry Pi用の`Makefile.common`変更例を示します。

1. Makefile.common内の`ARCHFLAGS`を`-mcpu=cortex-a53 -mthumb`に変更します。
2. カスタムメモリマップが適用されないため、`SRC_LD`をコメントアウトします。
3. `TOOLCHAIN`をクリアしてデフォルトの`gcc`を使用します。
   `TOOLCHAIN =`と設定します。
4. `LDFLAGS += --specs=nano.specs`と`LDFLAGS += --specs=nosys.specs`の行をコメントアウトしてください。

#### configureでのクロスコンパイルによるビルド

メインプロジェクトディレクトリのconfigureスクリプトは、gcc-arm-none-eabiツールでビルドするようにクロスコンパイルを実行できます。
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

wolfSSLは、Keil MDK 5向けに`wolfSSL::wolfSSL` CMSISパックとして配布しています。

1. Keil Pack Installerでパックをインストールします（「Generic」の下にあります）。
2. Project -> Manage -> 「Run-Time Environment」でプロジェクトにパックを追加し、wolfCrypt COREとwolfSSL CORE（必要に応じてテストまたはサンプルのコンポーネントも）にチェックを入れます。
3. `WOLFSSL_USER_SETTINGS`を定義します（Options for Target -> C/C++ -> Preprocessor Symbols）。
4. パックの`user_settings.h`を、その`MDK_CONF_*`設定で構成します。
   例えば、数学ライブラリ（`MDK_CONF_MATH`）、RTOS（`MDK_CONF_THREAD`）、TCPスタック（`MDK_CONF_NETWORK`）などを設定します。

サンプルプロジェクト（ライブラリのビルド、wolfCryptテストとベンチマーク、TLSクライアントとサーバーのサンプル）は`<wolfssl_root>/IDE/MDK5-ARM/Projects`にあります。
詳細は`<wolfssl_root>/IDE/MDK5-ARM/README.md`を参照してください。

## Cプリプロセッサマクロとして定義される機能

### 機能の削除

以下の定義は、wolfSSL から機能を削除するために使用できます。
これは、ライブラリ全体のフットプリントサイズを削減しようとしている場合に役立ちます。
`NO_<feature-name>` 定義を定義することに加えて、ビルドから対応するソースファイルも削除できます。
ヘッダーファイルは対象外です。

#### NO_WOLFSSL_CLIENT

サーバーのみのビルド用です。クライアントに固有の呼び出しを削除します。
サイズのためにいくつかの呼び出しを削除する場合にのみ、これを使用します。

#### NO_WOLFSSL_SERVER

クライアントのみのビルド用です。サーバーに固有の呼び出しを削除します。
サイズのためにいくつかの呼び出しを削除する場合にのみ、これを使用します。

#### NO_DES3

3DES（Triple-DES）のサポートを削除します。
`./configure`でビルドする場合（[`--enable-des3`](#--enable-des3)で有効にします）およびCMakeでビルドする場合（`WOLFSSL_DES3`のデフォルトは`no`です）、3DESはデフォルトで無効です。
user_settings.hでビルドする場合は、`NO_DES3`を定義しない限り組み込まれます。
`NO_DES3`を定義すると、[`NO_DES3_TLS_SUITES`](#no_des3_tls_suites)も定義されます。

#### NO_DES3_TLS_SUITES

wolfCryptでは3DESを利用可能なまま、3DESのTLS暗号スイートを削除します。
`./configure`およびCMakeでは、`--enable-des3-tls-suites`（CMakeでは`WOLFSSL_DES3_TLS_SUITES=yes`）を指定しない限りデフォルトで定義されます。
また、`NO_DES3`を設定すると自動的に定義されます。

#### NO_DSA

DSAの使用を削除します。
DSAは、一般的な使用が段階的に廃止されています。

#### NO_ERROR_STRINGS

エラー文字列を無効にします。
エラー文字列は、wolfSSLの場合は`src/internal.c`、wolfCryptの場合は`wolfcrypt/src/error.c`にあります。

#### NO_HMAC

ビルドからHMACを削除します。

**注意**：SSL/TLSはHMACに依存します。wolfCryptのみを使用している場合、（ビルドオプション `WOLFCRYPT_ONLY`）HMACを無効にできます。

#### NO_MD4

ビルドからMD4を削除します。
MD4は解読されているため、使用してはなりません。

#### NO_MD5

ビルドからMD5を削除します。

#### STM32_NOMD5

STM32ハードウェアによるMD5アクセラレーションを無効にします。
STM32の暗号機能を有効にしたまま、MD5にはソフトウェア実装を使用する場合に使用します。

#### NO_SHA

ビルドからSHA-1を削除します。

#### NO_SHA256

ビルドからSHA-256を削除します。

#### NO_PSK

事前共有鍵（PSK）のサポート（PSK暗号スイートとTLS 1.3の外部PSKコールバック）を削除します。
`./configure`では、`--enable-psk`を指定しない限り`NO_PSK`が定義されます（PSKはデフォルトで無効です）。
user_settings.hでビルドする場合は、`NO_PSK`を定義しない限りPSKが組み込まれます。

#### NO_PWDBASED

PBKDF1、PBKDF2、PKCS #12のPBKDFなどのパスワードベースの鍵導出関数を無効にします。

#### NO_PKCS7_STREAM

PKCS#7ストリーミングモードを無効にします。
ストリーミングモードでは、PKCS#7データを逐次的に処理できます。

#### NO_PKCS7_ENCRYPTED_DATA

PKCS#7 EncryptedDataコンテンツタイプを無効にします。
SignedDataまたはEnvelopedDataのみが必要な場合に、コードサイズを削減できます。

#### NO_PKCS7_COMPRESSED_DATA

PKCS#7 CompressedDataコンテンツタイプを無効にします。
CompressedDataのサポートは、zlibサポート（[`HAVE_LIBZ`](#have_libz)）も定義されている場合にのみ組み込まれます。
`HAVE_LIBZ`が定義されていない場合は、何も通知されずに除外されます。

#### NO_PKCS8

PKCS#8鍵パッケージのサポートを削除します（`--disable-pkcs8`）。
PKCS#12はPKCS#8を必要とするため、[`NO_PKCS12`](#no_pkcs12)も定義しない限り、[`HAVE_PKCS8`](#have_pkcs8)は定義されたままになります。

#### NO_PKCS12

PKCS#12のサポートを削除します（`--disable-pkcs12`）。
[`HAVE_PKCS12`](#have_pkcs12)を参照してください。

#### NO_RC4

ARC4（RC4）ストリーム暗号を削除します。
RC4は非推奨（RFC 7465）であるため、`WOLFSSL_ALLOW_RC4`が定義されていない限り（`--enable-arc4`で設定されます）、すべてのビルドで`NO_RC4`が強制的に定義されます。

#### NO_SESSION_CACHE

セッションキャッシュが不要なときに定義できます。
これにより、セッションキャッシュとクライアントセッションキャッシュが削除されます。
これらはデフォルトで33セッションを保持し、メモリ使用量はそれぞれ約13kBと約17kBです（`wolfssl/ssl_sess.h`のコメントに基づく推定値であり、正確なサイズはビルドオプションによって異なります）。

#### NO_CLIENT_CACHE

クライアントセッションキャッシュを削除します。
クライアントは、`wolfSSL_SetServerID()`で設定したIDによってサーバーとの以前のセッションを検索するために、このキャッシュを使用します。
メインのセッションキャッシュには影響しません。

#### NO_TLS

libwolfsslの他の部分（例えば証明書マネージャやOpenSSL互換レイヤー）を残したまま、TLSプロトコルを除いてビルドします。
TLSが不要な場合に、より小さなライブラリにすることができます。
`--disable-tls`で設定されます。
wolfCryptのみをビルドする[`WOLFCRYPT_ONLY`](#wolfcrypt_only)とは異なり、SSLレイヤーのTLS以外の部分は引き続きコンパイルされます。

#### SMALL_SESSION_CACHE

wolfSSLが使用するSSLセッションキャッシュのサイズを制限するように定義できます。
これにより、デフォルトのセッションキャッシュが33セッションから6セッションに短縮されます。
`wolfssl/ssl_sess.h`のコメントによると、セッションキャッシュは約13kBから約2kBに、クライアントセッションキャッシュは約17kBから約3kBに縮小されます。

#### NO_RSA

RSAアルゴリズムのサポートを削除します。

#### WC_NO_RSA_OAEP

OAEPパディングのコードを削除します。

#### WOLFSSL_RSA_VERIFY_INLINE

出力をコピーするRSA検証関数（`wc_RsaSSL_Verify()`、`wc_RsaSSL_Verify_ex()`、`wc_RsaSSL_Verify_ex2()`）を削除し、インプレースで処理する`wc_RsaSSL_VerifyInline()`のみを残します。
`wc_RsaSSL_VerifyInline()`は、出力をコピーする代わりに入力バッファ内を指すポインタを返します。
コードサイズとメモリ使用量を削減します。

#### NO_RSA_BOUNDS_CHECK

RSA入力データの境界チェックを無効にします。
デフォルトでは、wolfSSLはNIST SP 800-56Bの要求に従い、入力値cが`1 < c < n - 1`を満たすことをチェックします。

#### WC_RSA_NO_FERMAT_CHECK

RSA鍵生成時の、フェルマー法による素因数分解に対する近接チェックを無効にします。
デフォルトでは、wolfSSLは`p`と`q`が近すぎないことを検証します。
`p`と`q`が近すぎると、その鍵はフェルマーの素因数分解法に対して脆弱になります。

#### WOLFSSL_SE050_NO_RSA

NXP SE050セキュアエレメントを介したRSAを無効にします。
その他のSE050の操作は引き続き利用できます。

#### NO_AES_CBC

AES-CBCアルゴリズムサポートをオフにします。

#### NO_AES_DECRYPT

コードサイズを削減するために設定できます。
復号を無効にし、暗号化のみをサポートするように設定します。

#### WOLFCRYPT_ONLY

TLSを無効にしてwolfCryptのみを有効にします。

#### NO_CAMELLIA_CBC

Camellia-CBCのTLS暗号スイートのみを無効にします。
CamelliaはwolfCryptでは引き続き利用できます。

#### NO_AES

AESアルゴリズムサポートを無効にします。

#### NO_AES_128

128ビットAES鍵のサポートを削除します（`WOLFSSL_AES_128`が定義されません）。

#### NO_AES_192

192ビットAES鍵のサポートを削除します（`WOLFSSL_AES_192`が定義されません）。

#### NO_AES_256

256ビットAES鍵のサポートを削除します（`WOLFSSL_AES_256`が定義されません）。

#### NO_AESGCM_AEAD

AES-GCMのTLS暗号スイートが1つもビルドされない場合に自動的に定義される内部フラグです。
このマクロを自分で定義しても、AES-GCM暗号スイートは削除されません。
AES-GCM暗号スイートを削除するには、AES-GCM（`HAVE_AESGCM`）を含めずにビルドするか、例えば`wolfSSL_CTX_set_cipher_list()`を使用して実行時に暗号リストを制限してください。

#### NO_ASN_TIME

ASNの時間チェックを無効にします。

**注意**：すべての証明書の開始/終了日チェックがスキップされるため、これは注意して使用する必要があります。

#### NO_BIO

BIO（Basic I/O）抽象化レイヤーを無効にします。
`BIO_new()`、`BIO_read()`、`BIO_write()`などのBIO機能が不要な場合に、コードサイズを削減できます。

#### WOLFSSL_NO_OPENSSL_RAND_CB

`OPENSSL_EXTRA`を使用する場合に、OpenSSLのRANDメソッドコールバックのサポート（`wolfSSL_RAND_set_rand_method()`）を削除してコードサイズを削減します。
`OPENSSL_EXTRA_X509_SMALL`を使用すると自動的に定義されます。

#### NO_VERIFY_OID

証明書の解析時のOID検証を無効にします。

#### NO_SKID

Subject Key Identifier拡張の処理を無効にします。

#### NO_STRICT_ECDSA_LEN

ECDSA署名長の厳密なチェックを緩和します。
相互運用性のために、最小長ではないDERエンコーディングのECDSA署名を許可します。

#### NO_WOLFSSL_SKIP_TRAILING_PAD

従来形式で暗号化されたPEM秘密鍵（DEK-Infoヘッダーを持つDES3またはAES-CBC）を復号した際に、ブロック暗号のパディングを除去する処理を無効にします。

#### NO_WOLFSSL_STUB

未実装のOpenSSL互換関数のスタブ実装を無効にします。
スタブがない場合、未実装の関数を呼び出すと、実行時の失敗ではなくリンカーエラーになります。

#### WOLFSSL_MLDSA_NO_ASN1

ML-DSAの鍵と署名のASN.1エンコード/デコードを無効にします。
代わりにRAW形式を使用します。
従来の名前である`WOLFSSL_DILITHIUM_NO_ASN1`も、引き続きエイリアスとして使用できます。

#### WOLFSSL_DISABLE_EARLY_SANITY_CHECKS

受信したTLSメッセージに対する早期のサニティチェックを無効にします。
仕様に準拠していないTLS実装との相互運用性のために必要になる場合があります。

#### NO_CHECK_PRIVATE_KEY

秘密鍵が証明書の公開鍵と一致することを確認するチェック（例えば`wolfSSL_CTX_check_private_key()`や`wolfSSL_check_private_key()`）を削除します。
このチェックはデフォルトで組み込まれています。
このチェックは、RSA、ECDSA、Ed25519、Ed448、Falcon、ML-DSA、SLH-DSAの鍵をサポートしています。

#### NO_CIPHER_SUITE_ALIASES

暗号スイート名のエイリアスを無効にします。
別名は認識されず、主要な暗号スイート名のみが認識されます。

#### NO_CHAPOL_AEAD

ChaCha20-Poly1305 AEAD暗号スイートを無効にします。
アルゴリズム自体はコンパイルされているものの、ChaCha20-Poly1305のサポートが不要な場合に使用します。

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

シンボルの衝突（例えばOpenSSLのヘッダーとの衝突）を避けるため、`wc_`/`WC_`プレフィックスを持たない従来のwolfCryptの名前（例えば`Md5`、`MD5_DIGEST_SIZE`、`Sha256`）を削除します。
[`OPENSSL_COEXIST`](#openssl_coexist)を使用すると自動的に定義されます。

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

TSIP TLSリンク共通鍵暗号化方式のみを無効にします。

**注意**：これはルネサスRX TSIP固有の定義です。

#### WOLFSSL_DTLS13_NO_HRR_ON_RESUME

これが定義されている場合、DTLSサーバーはクライアントの再開が成功した場合にクッキー交換を行いません。
再開はより速く（1 RTT少なく）なり、帯域幅の消費が少なくなります（1つのClientHelloと、1つのHelloVerifyRequest/HelloRetryRequestが少なくなります）。
一方、有効なSessionID/チケット/pskが収集された場合、偽造されたclientHelloメッセージはサーバー上のリソースを消費します。
DTLS 1.3の場合、このオプションを使用すると、サーバーがEarly Data/0-RTT Dataを処理することもできます。
これがなければ、サーバーはクッキーを持つ検証済みClientHelloを受信するまでステートフル処理に入らないため、Early Dataはドロップされます。
DTLS 1.2における同等の機能については、[`WOLFSSL_DTLS_NO_HVR_ON_RESUME`](#wolfssl_dtls_no_hvr_on_resume)を参照してください。

クッキー交換なしでDTLS 1.3再開を許可するには、次のようにします。

- `WOLFSSL_DTLS13_NO_HRR_ON_RESUME`を定義してwolfSSLをコンパイルする
- `wolfSSL_dtls13_no_hrr_on_resume(ssl, 1)`をWOLFSSLオブジェクトに呼び出して、再開時のクッキー交換を無効にする
- 通常の接続と同様に続行する

#### WOLFSSL_DTLS_NO_HVR_ON_RESUME

[`WOLFSSL_DTLS13_NO_HRR_ON_RESUME`](#wolfssl_dtls13_no_hrr_on_resume)のDTLS 1.2版です。
ClientHelloが（セッションIDまたはセッションチケットによって）有効なセッションを再開する場合、DTLS 1.2サーバーはHelloVerifyRequestによるクッキー交換を省略します。
実行時の関数呼び出しは不要です。
同じトレードオフが当てはまります。
再開は1ラウンドトリップ速くなりますが、有効なセッションIDまたはチケットを含む偽造されたClientHelloメッセージは、サーバー上のリソースを消費します。

#### WOLFSSL_NO_CLIENT_AUTH

TLSクライアント証明書認証（TLS 1.2およびTLS 1.3）を削除します。
クライアントは、CertificateRequestに応答してCertificateメッセージとCertificateVerifyメッセージを送信しなくなります。
サーバーでは、必要なクライアント証明書が送信されなかった場合にハンドシェイクを失敗させるチェックが削除されます（空のクライアントCertificateメッセージは引き続き拒否されます）。
サーバーのみのビルド（`NO_WOLFSSL_CLIENT`）では、サーバーはクライアントのCertificateメッセージも処理できなくなります。
また、Ed25519およびEd448のクライアント認証に必要なハンドシェイクメッセージのキャッシュも削除されます。
そのキャッシュのみを削除するには、[`NO_ED25519_CLIENT_AUTH`](#no_ed25519_client_auth)と[`NO_ED448_CLIENT_AUTH`](#no_ed448_client_auth)を使用してください。

#### WOLFSSL_NO_CURRDIR

`wolfssl/test.h`のテストパスに./をサポートしないプラットフォーム用の移植性マクロです。
テストツールにのみ適用されます。

#### WOLFSSL_NO_DEF_TICKET_ENC_CB

デフォルトのチケット暗号化コールバックを定義しません。
サーバーのみに適用されます。
アプリケーションはセッションチケットを使用するために独自のコールバックを設定する必要があります。

#### WOLFSSL_NO_DTLS_SIZE_CHECK

1つのレコードに収まらない（MTUまたは最大フラグメント長のため）DTLSアプリケーションデータを`wolfSSL_write()`がどのように扱うかを変更します。
デフォルトでは、wolfSSLは`DTLS_SIZE_ERROR`で失敗します。
このマクロを定義すると、代わりにデータを複数のレコードに分割します。
受信したレコードに対するチェックには影響しません。

#### WOLFSSL_NO_ETM_ALERT

[`WOLFSSL_EXTRA_ALERTS`](#wolfssl_extra_alerts)が定義されている場合に、Encrypt-Then-MACレコードのMAC検証に失敗したとき、またはレコードが長すぎるときに送信される、致命的な`bad_record_mac`または`record_overflow`アラートを抑制します。
接続は引き続き失敗します（`DECRYPT_ERROR`または`BUFFER_ERROR`）。
MAC-then-encryptへのフォールバックは行われません。

#### WOLFSSL_NO_SOCK

移植のため、組み込みソケットサポートを無効にするためのマクロです。
ソケットなしでTLSを使用する場合、通常は`WOLFSSL_USER_IO`を定義し、送信/受信にコールバックを使用します。

#### WOLFSSL_NO_STRICT_CIPHER_SUITE

TLS 1.2（またはそれ以前）のクライアントにおいて、ServerHelloで選択された暗号スイートがClientHelloで提示したものであるかどうかのチェックと、セキュアな再ネゴシエーションの際に暗号スイートが変更されていないかどうかのチェックを省略します。
誤動作するサーバーや悪意のあるサーバーに対する保護が弱まるため、推奨されません。

#### WOLFSSL_NO_TICKET_EXPIRE

セッションチケットの有効期限チェックを無効にします。
セッションチケットは、経過時間に関係なく受け入れられます。

#### WOLFSSL_NO_TLS12

TLS 1.2を除外するために定義します。
TLS 1.2のコードがコンパイルされなくなるため、ピアはTLS 1.2をネゴシエートできなくなります。
wolfSSL 5.9.4以降では、[`--disable-tlsv12`](#--disable-tlsv12)を指定するとこのマクロが設定されます。

#### WOLFSSL_NO_SIGALG

署名アルゴリズム拡張を無効にします。

#### NO_RESUME_SUITE_CHECK

再開されたセッションが同じ暗号スイートを使用していることのチェックを無効にします。

#### NO_ASN

ASNフォーマットの証明書処理のサポートをオフにします。

#### NO_CODING

Base64およびBase16のエンコードとデコードを削除します（`--disable-coding`）。
`NO_CODING`を定義すると[`WOLFSSL_PEM_TO_DER`](#wolfssl_pem_to_der)が定義されなくなるため、PEMのサポートも削除されます。

#### NO_CERTS

wolfSSLにおけるすべての証明書処理を無効にします。
証明書の処理が不要なPSKのみの構成で使用すると、コードサイズを大幅に削減できます。

#### WOLFSSL_NO_PEM

PEMのサポートを削除します。
[`WOLFSSL_PEM_TO_DER`](#wolfssl_pem_to_der)が定義されないため、PEMからDERへの変換関数はビルドされず、証明書と鍵はDER形式（`WOLFSSL_FILETYPE_ASN1`）でのみ読み込むことができます。
このマクロに対応するconfigureオプションはありません。
user_settings.hまたは`CFLAGS`で定義してください。

#### NO_SIG_WRAPPER

`wolfcrypt/src/signature.c`の署名ラッパーAPI（`wc_SignatureGetSize()`、`wc_SignatureGenerate()`、`wc_SignatureVerify()`、およびそれらの`Hash`版と`_ex`版）を削除します。
RSAが無効でECCの署名と検証が利用できない場合、[`--enable-rsavfy`](#--enable-rsavfy)を指定した場合、および`WOLFSSL_TINY_TLS13`プロファイルを使用した場合に、自動的に定義されます。

#### NO_OLD_TLS

SSLv3、TLSv1.0、TLSv1.1のサポートを削除します。
`./configure`とCMakeは、デフォルトでこのマクロを定義します。
古いTLSのサポートが明示的に要求された場合（例えば[`--enable-oldtls`](#--enable-oldtls)、`--enable-tlsv10`、`--enable-sslv3`を指定した場合）にのみ、未定義のままになります。
user_settings.hでビルドする場合は自動的に定義されないため、`NO_OLD_TLS`をご自身で定義してください。
`NO_OLD_TLS`を定義しないビルドでは、TLS 1.0とSSL 3.0を使用するには、さらにそれぞれ`WOLFSSL_ALLOW_TLSV10`と`WOLFSSL_ALLOW_SSLV3`が必要です。

**警告**：`NO_OLD_TLS`を未定義のままにすると、RFC 9846、RFC 8996、RFC 9325に**準拠しない**ビルドになります。
RFC 8996はTLS 1.0とTLS 1.1を非推奨としており、RFC 9846はSSL 2.0、SSL 3.0、TLS 1.0、TLS 1.1を「いかなる理由があってもネゴシエートしてはならない（MUST NOT be negotiated for any reason）」と規定しています。
レガシーシステムとの相互運用性のために必要な場合にのみ`NO_OLD_TLS`を定義せずにビルドし、そのようなビルドについてはこれらのRFCへの準拠を主張しないでください。

#### WOLFSSL_AEAD_ONLY

非AEADのTLS暗号スイート（Encrypt-Then-MACを含む、HMACを使用するCBC暗号およびストリーム暗号）を削除します。
アルゴリズム自体はwolfCryptに残ります。
AEADは「認証付き暗号（authenticated encryption with associated data）」の略です。
これらのアルゴリズム（AES-GCMなど）は、データを暗号化および復号するだけでなく、そのデータの完全性と真正性も保証します。

#### WOLFSSL_SP_NO_2048

RSA/DH 2048ビット単精度(SP)最適化を削除します。

#### WOLFSSL_SP_NO_3072

RSA/DH 3072ビット単精度(SP)最適化を削除します。

#### WOLFSSL_SP_NO_256

`WOLFSSL_HAVE_SP_ECC`を使用する場合に、SP P-256（SECP256R1）実装を削除します。
`WOLFSSL_SP_MATH`（SPのみの数学ライブラリ）を使用する場合は、曲線テーブルからもP-256を削除します（`NO_ECC256`）。

### 対称暗号、ハッシュ、KDFオプション

以下の定義は、オプションまたはレガシーの対称暗号、ハッシュ、鍵導出の機能を有効にします。

#### WOLFSSL_DES_ECB

DES-ECB（Electronic Codebook）モードを有効にします。
デフォルトでは無効です。
一部のレガシーなプロトコルで使用されます。

#### HAVE_HKDF

RFC 5869に準拠したHKDF（HMACベースのExtract-and-Expand鍵導出関数）を有効にします。
TLS 1.3の鍵導出や、共有秘密からの汎用的な鍵導出に使用されます。

#### WOLFSSL_HMAC_COPY_HASH

HMAC操作のたびに再初期化する代わりに、ハッシュの状態をコピーします。
同じ鍵を複数のHMAC計算に使用する場合に、パフォーマンスが向上します。

#### HAVE_X963_KDF

ANSI X9.63鍵導出関数を有効にします。
PKCS#7 EnvelopedDataにおけるECCベースの鍵合意に使用されます。

#### WC_RC2

RC2暗号のサポートを有効にします。
主にレガシーなPKCS#12ファイルとの互換性のために必要です。

#### WOLFSSL_MD2

MD2ハッシュアルゴリズムのサポートを有効にします。
レガシーな証明書との互換性のためにのみ必要です。
新しいアプリケーションでの使用は推奨されません。

### RSAオプション

以下の定義は、オプションのRSAの動作を有効にしたり調整したりします。

#### WC_RSA_DIRECT

RSAの直接暗号化/復号API（`wc_RsaDirect`）を有効にします。
パディングなしのRAW RSA操作を提供し、独自のプロトコルに役立ちます。

#### WC_RSA_NO_PADDING

パディングなしのRSAモードを有効にします。
パディング方式を一切適用せずにRSA操作を実行できます。
注意して使用してください。
通常は独自の実装でのみ使用します。

#### WOLFSSL_RSA_KEY_CHECK

`wc_CheckRsaKey()`によるRSA鍵ペアの整合性チェックを有効にします。
公開鍵と秘密鍵の要素が数学的に整合していることを検証します。

#### WOLFSSL_RSA_CHECK_D_ON_DECRYPT

各復号操作の前に、RSA秘密指数`d`を検証します。
パフォーマンスと引き換えに、フォールト注入攻撃に対する追加のセキュリティを提供します。

#### WOLFSSL_RSA_DECRYPT_TO_0_LEN

RSA復号操作が長さ0の結果（空の平文）を返すことを許可します。
デフォルトでは、長さ0の復号結果はエラーとして扱われます。

#### SHOW_GEN

RSA鍵生成中に進捗インジケーター（ドット）を表示します。
時間のかかる鍵生成の間、ユーザーへのフィードバックとして役立ちます。

#### WOLFSSL_PSS_LONG_SALT

RSA-PSS署名で、ハッシュの出力長より長いソルト長を使用できるようにします。
実装によっては、鍵サイズからオーバーヘッドを差し引いた値に等しいソルト長を使用します。

#### WOLFSSL_PSS_SALT_LEN_DISCOVER

RSA-PSS検証のソルト長の値として`RSA_PSS_SALT_LEN_DISCOVER`を追加します。
この値を渡すと、検証側は呼び出し元にソルト長の指定を求める代わりに、デコードしたPSSパディング（0x01区切りバイトの位置）からソルト長を割り出します。

#### WC_RSA_NONBLOCK_TIME

時間ベースのノンブロッキングRSA操作を有効にします。
設定可能な時間が経過した後に、RSA操作が処理を中断して制御を戻せるようにします。
[`WC_RSA_NONBLOCK`](#wc_rsa_nonblock)が必要です。

#### WOLFSSL_MP_INVMOD_CONSTANT_TIME

wolfSSL 5.9.4より後のバージョンで削除されました。
RSA鍵生成では常に`u = q^-1 mod p`を`q^(p-2) mod p`として計算し、DSA署名では常に逆元をブラインドするため、このマクロを定義しても効果はありません。

#### FP_MAX_BITS

fast math（`USE_FAST_MATH`）を使用する場合の最大鍵サイズをビット単位で設定します。
値は鍵サイズの2倍に設定する必要があります。
例えば、RSA 3072の場合は6144に設定します。
デフォルトは4096です（RSA 2048までサポートします）。

### ハードウェア暗号・非同期暗号オプション

以下の定義は、特定のアルゴリズムのハードウェアアクセラレーションまたは非同期処理を有効にします。

#### WC_ASYNC_ENABLE_3DES

wolfSSL非同期暗号フレームワークを介した、非同期3DES操作を有効にします。

#### FREESCALE_LTC_DES

Freescale/NXP LTCハードウェアによるDES/3DESアクセラレーションを有効にします。

#### STM32_HMAC

STM32 HASHペリフェラルを使用した、STM32ハードウェアによるHMACアクセラレーションを有効にします。

#### WC_ASYNC_ENABLE_HMAC

wolfSSL非同期暗号フレームワークを介した、非同期HMAC操作を有効にします。

#### WOLFSSL_DEVCRYPTO_HMAC

Linuxの`/dev/crypto`インターフェースを介した、HMACアクセラレーションを有効にします。

#### WOLFSSL_KCAPI_HMAC

Linuxカーネル暗号API（AF_ALG）を介したHMAC操作を有効にします。

#### HAVE_MD5_CUST_API

ハードウェアポート（STM32 HASH、PIC32MZ、i.MX6 CAAM）が独自の`wc_InitMd5_ex()`、`wc_Md5Update()`、`wc_Md5Final()`を提供する場合に、`wolfcrypt/src/md5.c`によって設定される内部フラグです。
このマクロを自分で定義すると、ソフトウェアのMD5 APIは省略され、アプリケーションがこれらの関数を提供する必要があります。

#### WC_ASYNC_ENABLE_MD5

wolfSSL非同期暗号フレームワークを介した、非同期MD5操作を有効にします。

#### WC_ASYNC_ENABLE_RSA

wolfSSL非同期暗号フレームワークを介した、非同期RSA操作を有効にします。
RSA操作をハードウェアアクセラレータにオフロードできます。

#### WOLFSSL_KCAPI_RSA

Linuxカーネル暗号API（AF_ALG）を介したRSA操作を有効にします。
RSAをカーネルの暗号サブシステムにオフロードします。

#### WOLFSSL_AFALG_XILINX_RSA

Xilinxプラットフォームにおいて、Xilinx暗号ハードウェアを使用したAF_ALG経由のRSAアクセラレーションを有効にします。

#### WOLFSSL_XILINX_CRYPT

Xilinx FPGA/SoCプラットフォームにおいて、RSAおよびその他のアルゴリズムに対するXilinxハードウェア暗号アクセラレーションを有効にします。

### PKCS#7、PKCS#8、PKCS#12オプション

以下の定義は、PKCS#7（CMS）、S/MIME、PKCS#8、PKCS#12のサポートを有効にしたり調整したりします。

#### HAVE_PKCS7

PKCS#7（Cryptographic Message Syntax）のサポートを有効にします。
署名データ、エンベロープデータ、暗号化データ、圧縮データの各コンテンツタイプに対応しています。

#### WOLFSSL_PKCS7_MAX_DECOMPRESSION

PKCS#7 CompressedDataの最大展開率を設定します。
展開後の出力は、圧縮された入力のサイズの最大でこの倍数までに制限されます。
デフォルトは1031（zlibの最大圧縮率）です。
悪意を持って細工された圧縮データによるメモリ枯渇を防止します。

#### HAVE_PKCS7_RSA_RAW_SIGN_CALLBACK

PKCS#7におけるRAW RSA署名用のカスタムコールバックを有効にします。
HSMや外部の署名処理との統合が可能になります。

#### HAVE_PKCS7_ECC_RAW_SIGN_CALLBACK

PKCS#7におけるRAW ECC署名用のカスタムコールバックを有効にします。
HSMや外部の署名処理との統合が可能になります。

#### HAVE_SMIME

メールの署名と暗号化のための、S/MIME（Secure/Multipurpose Internet Mail Extensions）のサポートを有効にします。

#### HAVE_PKCS8

暗号化された秘密鍵および暗号化されていない秘密鍵をインポート/エクスポートするための、PKCS#8秘密鍵形式のサポートを有効にします。
デフォルトで有効です。
[`NO_PKCS8`](#no_pkcs8)が定義されていない限り自動的に定義され、`HAVE_PKCS12`が定義されている場合は常に定義されます。

#### HAVE_PKCS12

秘密鍵、証明書、CAチェーンを1つの暗号化ファイルにまとめるための、PKCS#12（PFX）形式のサポートを有効にします。
デフォルトで有効です。
[`NO_PKCS12`](#no_pkcs12)が定義されていない限り、自動的に定義されます。

### 証明書・ASN.1オプション

以下の定義は、オプションの証明書の生成、解析、検証の機能を有効にしたり、チェックを緩和したりします。

#### WOLFSSL_CERT_PIV

政府機関向けスマートカードアプリケーションのための、PIV（Personal Identity Verification）証明書のサポートを有効にします。

#### WOLFSSL_CERT_GEN_CACHE

`wc_SetIssuerBuffer()`、`wc_SetSubjectBuffer()`、`wc_SetAltNamesBuffer()`、`wc_SetDatesBuffer()`などの関数がデコードした証明書を、呼び出しのたびに再デコードする代わりに、呼び出し間で`Cert`構造体にキャッシュしたままにします。
この場合、アプリケーションは`wc_SetCert_Free()`でこれを解放する必要があり、`wc_SetCert_Free()`は公開APIになります。

#### WOLFSSL_CERT_SIGN_CB

証明書署名用のコールバック関数を有効にし、外部での署名処理（HSMなど）を可能にします。

#### WOLFSSL_CERT_NAME_ALL

イニシャル、名（given name）、DN修飾子を含む、証明書の名前のすべての要素を保存します。
メモリ使用量は増えますが、名前のすべての要素にアクセスできます。

#### WOLFSSL_MULTI_ATTRIB

証明書における、複数値の相対識別名（RDN）属性を有効にします。

#### WOLFSSL_PEM_TO_DER

PEMからDERへの変換関数（`wc_PemToDer()`、`wc_KeyPemToDer()`、`wc_CertPemToDer()`、`wc_PemPubKeyToDer()`など）と、PEM形式の証明書と鍵の読み込みを有効にします。
[`WOLFSSL_NO_PEM`](#wolfssl_no_pem)または[`NO_CODING`](#no_coding)が定義されていない限り、デフォルトで定義されます。

#### WOLFSSL_DER_TO_PEM

DERからPEM形式への変換関数を有効にします。

#### WOLFSSL_PUB_PEM_TO_DER

公開鍵のPEMからDER形式への変換を有効にします。

#### WOLFSSL_KEY_TO_DER

`wc_RsaKeyToDer()`（RSA秘密鍵からDERへの変換）と、`wc_RsaKeyToPublicDer()`が使用するRSA公開鍵のDERエンコードを有効にします。
RSAが`WOLFSSL_KEY_GEN`、`WOLFSSL_CERT_GEN`、`OPENSSL_EXTRA`、`WOLFSSL_KCAPI_RSA`、`WOLFSSL_SE050`のいずれかとともに有効になっている場合に、自動的に定義されます（FIPSビルドおよびセルフテストビルドでは`WOLFSSL_KEY_GEN`の場合のみ）。
ECC鍵は`wc_EccKeyToDer()`を使用し、このマクロには依存しません。

#### ASN_BER_TO_DER

BER（Basic Encoding Rules）からDER（Distinguished Encoding Rules）への変換を有効にします。
BERでエンコードされた証明書やCMS/PKCS#7データの解析に必要です。

#### WOLFSSL_DUP_CERTPOL

証明書ポリシー拡張内で、重複した証明書ポリシーOIDを許可します。
デフォルトでは、重複は検証エラーになります。

#### ALLOW_SELFSIGNED_INVALID_CERTSIGN

CAではない（cA基本制約を持たない）自己発行証明書が、Key Usage拡張でkeyCertSignを示すことを許可します。
デフォルトでは、これはRFC 5280のセクション4.2.1.9に違反するため、`KEYUSAGE_E`で拒否されます。
これは、自己発行であるかどうかにかかわらずそのような証明書を受け入れる`ALLOW_INVALID_CERTSIGN`よりも、適用範囲を限定したオプトインです。

#### ALLOW_V1_EXTENSIONS

X.509 v1証明書に拡張が含まれることを許可します。
RFC 5280では、拡張はv3証明書でのみ有効です。

#### USE_WOLF_VALIDDATE

プラットフォームの実装の代わりに、wolfSSL独自の日付検証の実装を使用します。

#### USE_WOLF_TM

システムが提供する`struct tm`の代わりに、wolfSSL独自の`struct tm`の定義を使用します。
標準の`struct tm`がないプラットフォームで必要です。

#### WC_ASN_RUNTIME_DATE_CHECK_CONTROL

証明書の日付チェックを実行時に制御できるようにします。
APIを介して、実行時に日付検証を有効または無効にできます。

#### WOLFSSL_AFTER_DATE_CLOCK_SKEW

証明書のnot-after日付チェックにおける、クロックスキューの許容値（秒単位）を設定します。
有効期限をわずかに過ぎた証明書を、有効とみなすことができます。

#### WOLFSSL_BEFORE_DATE_CLOCK_SKEW

証明書のnot-before日付チェックにおける、クロックスキューの許容値（秒単位）を設定します。
有効期間の開始よりわずかに前の証明書を、受け入れることができます。

#### WOLFSSL_ALT_NAMES

証明書の生成と解析において、Subject Alternative Name（SAN）のサポートを有効にします。

#### WOLFSSL_ALT_NAMES_NO_REV

Subject Alternative Nameを、順序を逆にせずに保存します。
デフォルトでは、SANは逆順で保存されます。

#### WOLFSSL_IP_ALT_NAME

iPAddress Subject Alternative Nameエントリの、人間が読める文字列形式（`ipString`）を生成します。
これは、ピア証明書の検証時にIPアドレスをiPAddress SANエントリと照合するために必要であり、互換レイヤーと出力関数でも使用されます。
RAWのiPAddressエントリは、このマクロがなくても（例えば名前制約のチェックのために）解析されます。

#### WOLFSSL_RID_ALT_NAME

registeredID Subject Alternative Nameエントリの、人間が読める文字列形式（`ridString`）を生成します。
これは互換レイヤーと出力関数で使用されます。
RAWのregisteredIDエントリは、このマクロがなくても解析されます。

#### WOLFSSL_EKU_OID

Extended Key Usage OIDのサポートを有効にし、標準のセット以外の追加のOIDを使用できるようにします。

#### WOLFSSL_ACERT

X.509属性証明書（RFC 5755）のサポートを有効にします。

#### IGNORE_KEY_EXTENSIONS

証明書の検証時に、Key Usage拡張とExtended Key Usage拡張を無視します。

#### WOLFSSL_ALLOW_CRIT_AIA

Authority Information Access（AIA）拡張がcriticalとしてマークされることを許可します。
デフォルトでは、criticalなAIAは検証エラーになります。

#### WOLFSSL_ALLOW_CRIT_AKID

Authority Key Identifier拡張がcriticalとしてマークされることを許可します。

#### WOLFSSL_ALLOW_CRIT_SKID

Subject Key Identifier拡張がcriticalとしてマークされることを許可します。

#### WOLFSSL_ALLOW_NO_CN_IN_SAN

従来のホスト名チェックに戻します。
証明書がSAN拡張を持つ場合でも、まずサブジェクトのCNを照合し、それが失敗した場合にのみSubject Alternative Name（SAN）エントリを試します。
デフォルトでは、証明書がSAN拡張を持つ場合はSANエントリのみがチェックされ（RFC 5280のセクション4.2.1.6）、CNは無視されます。

#### WC_ASN_UNKNOWN_EXT_CB

不明な証明書拡張を処理するためのコールバックを有効にします。
コールバックはOIDと拡張データを受け取り、独自の処理を行うことができます。

#### WOLFSSL_ASN_ALL

オプションのASN.1機能をすべて一度に有効にします。

#### WOLFSSL_ASN_CA_ISSUER

Authority Information Access拡張内の、CA Issuerフィールドの解析を有効にします。

#### WOLFSSL_ASN_PRINT

DERエンコードされたデータのデバッグや検査のための、ASN.1構造の出力関数を有効にします。

#### WOLFSSL_ASN_INT_LEAD_0_ANY

ASN.1 INTEGERのエンコーディングで、任意の先頭ゼロバイトを許可します。
デフォルトでは、最小長のエンコーディングのみが受け入れられます。

#### WOLFSSL_ASN_PARSE_KEYUSAGE

証明書の処理中に、Key Usage拡張の解析を有効にします。

#### WOLFSSL_ASN_TIME_STRING

ASN.1の時刻値を、人間が読める文字列形式に変換する機能を有効にします。

#### ASN_TEMPLATE_SKIP_ISCA_CHECK

ASN.1テンプレートベースの証明書解析において、isCAチェックをスキップします。

#### HAVE_OID_ENCODING

OID（Object Identifier）エンコードのサポートを有効にし、ドット区切りの10進表記からASN.1 OIDを生成できるようにします。

#### WOLFSSL_OLD_OID_SUM

古いOID合計値の計算方法を使用します。
特定のOID合計値に依存するアプリケーションとの後方互換性のためのものです。

#### WC_ENABLE_ASYM_KEY_IMPORT

RFC 5958の汎用的な非対称鍵パッケージのインポートヘルパーを有効にします。
Ed25519、Curve25519、Ed448、Curve448（鍵のインポートが有効な場合）、Falcon、ML-DSA、ML-KEM、FrodoKEM、SLH-DSA、LMS、XMSSのいずれかが有効な場合（LMSとXMSSは検証専用でない場合のみ）に自動的に定義されるため、通常は手動で定義する必要はありません。

#### WC_ENABLE_ASYM_KEY_EXPORT

RFC 5958の汎用的な非対称鍵パッケージのエクスポートヘルパーを有効にします。
Ed25519、Curve25519、Ed448、Curve448（鍵のエクスポートが有効な場合）、Falcon、ML-DSA、ML-KEM、FrodoKEM、SLH-DSA、LMS、XMSSのいずれかが有効な場合（LMSとXMSSは検証専用でない場合のみ）に自動的に定義されるため、通常は手動で定義する必要はありません。

#### WOLFSSL_X509_NAME_AVAILABLE

`wolfcrypt/src/asn.c`の内部でのみ使用される内部フラグです。
このフラグにより、証明書パーサーは、互換レイヤーで使用される`WOLFSSL_X509_NAME`のサブジェクトおよび発行者オブジェクトも構築します。
`WOLFCRYPT_ONLY`なしで`OPENSSL_EXTRA`または`OPENSSL_EXTRA_X509_SMALL`が設定されている場合に自動的に定義されるため、自分で定義しないでください。
X509_NAME APIを有効にするには、代わりに[`OPENSSL_EXTRA`](#openssl_extra)を使用してください。

#### WOLFSSL_HAVE_ISSUER_NAMES

効率的にアクセスできるよう、発行者名の各要素へのポインタ、その長さ、エンコーディングを保存します。

#### WOLFSSL_VERIFY_CB_ALL_CERTS

ピア証明書だけでなく、チェーン内のすべての証明書に対して証明書検証コールバックを呼び出します。

#### WOLFSSL_LOCAL_X509_STORE

グローバルなX509証明書ストアの代わりに、SSLコンテキストごとのローカルなストアを使用します。
コンテキスト間の分離が向上します。

#### WOLFSSL_COPY_CERT

SSLオブジェクトに証明書を読み込む際に、証明書バッファを参照する代わりにコピーし、SSLオブジェクトがデータの独自のコピーを所有するようにします。

#### WOLFSSL_COPY_KEY

SSLオブジェクトに秘密鍵を読み込む際に、秘密鍵バッファを参照する代わりにコピーし、SSLオブジェクトがデータの独自のコピーを所有するようにします。

### OCSPオプション

以下のオプションは、OCSPのサポートを調整します。

#### HAVE_OCSP_RESPONDER

OCSPレスポンダー機能を有効にします。
wolfSSLが、OCSPレスポンスに署名して送信するOCSPレスポンダーとして動作できるようになります。

#### WOLFSSL_OCSP_PARSE_STATUS

詳細なステータス情報を得るために、OCSPレスポンスのステータスフィールドの解析を有効にします。

#### WOLFSSL_OCSP_SCREEN_RESPONDER

OCSPの堅牢化オプションです。
Authority Information Access拡張から取得したレスポンダーのホストが内部のアドレス範囲（ループバック、リンクローカル、プライベートネットワーク）に解決される場合は、そのホストを拒否します。
これにより、攻撃者が用意した証明書によってOCSPチェックが自身のサービスに向けられること（サーバーサイドリクエストフォージェリ、CWE-918）を防ぎます。

#### WOLFSSL_OCSP_FAIL_IF_NOT_SUPPORTED

ビルドマクロではなく、実行時に指定するOCSPの堅牢化オプションです。
`wolfSSL_CTX_EnableOCSP()`、`wolfSSL_EnableOCSP()`、または`wolfSSL_CertManagerEnableOCSP()`のoptions引数に渡します。
これを設定すると、OCSPレスポンダーを示していない証明書は、デフォルトのソフトフェイル動作ではなく、`OCSP_NEED_URL`で拒否されます。
このオプションを設定しない場合、レスポンダーがなくても結果は`OCSP_NO_URL`になるだけで、有効になっているCRLチェックは引き続き実行されます。

### ポスト量子暗号オプション

以下の定義は、オプションのポスト量子アルゴリズムの機能を制御します。

#### WOLFSSL_MLDSA_FIPS204_DRAFT

最終版のFIPS 204のパラメータセットに加えてFIPS 204ドラフト版のML-DSAパラメータセット（例えば`WC_ML_DSA_44_DRAFT`）を追加し、ドラフト形式の署名に必要な、コンテキストを使用しない署名/検証API（`WOLFSSL_MLDSA_NO_CTX`）を有効にします。
`--enable-mldsa`に`draft`を追加すると設定されます（例えば`--enable-mldsa=yes,draft`）。
従来の名前である`WOLFSSL_DILITHIUM_FIPS204_DRAFT`も、引き続きエイリアスとして使用できます。

#### HAVE_SPHINCS

廃止されました。
このマクロはliboqs統合を通じて標準化前のSPHINCS+を有効にするものでしたが、liboqs統合はwolfSSL 5.9.2で削除されたため、現在は定義しても何も起こりません。
代わりに、ネイティブのSLH-DSA（FIPS 205）実装を使用してください。
[`WOLFSSL_HAVE_SLHDSA`](#wolfssl_have_slhdsa)を参照してください。

#### WOLFSSL_HAVE_SLHDSA

wolfCryptで、SLH-DSAステートレスハッシュベース署名方式（FIPS 205、SPHINCS+の標準化版）を有効にします。
デフォルトでは、6つのSHAKEパラメータセット（レベル128、192、256のそれぞれについて、smallとfastの各バリアント）のみがビルドされます。
6つのSHA2パラメータセットには、さらに`WOLFSSL_SLHDSA_SHA2`が必要です。
`--enable-slhdsa=yes,sha2`を指定すると12個すべてがビルドされ、`sha2-128s`などのオプションで個別のセットを選択できます。
configureフラグは[`--enable-slhdsa`](#--enable-slhdsa)です。
TLS 1.3またはDTLS 1.3が有効な場合、draft-reddy-tls-slhdsaの署名方式でハンドシェイクに署名できます。
コードポイントは、[付録G](appendix07.md#c-9-slh-dsa-fips-205)の署名アルゴリズム一覧に記載されています。
`WOLFSSL_SLHDSA_VERIFY_ONLY`（`--enable-slhdsa=verify-only`で設定されます）は検証機能のみを残します。
`WOLF_CRYPTO_CB_ONLY_SLHDSA`は、アルゴリズムを暗号コールバックデバイスにオフロードする構成向けに、ソフトウェア実装を削除します。

#### WOLFSSL_HAVE_FRODOKEM

wolfCryptで、FrodoKEM鍵カプセル化メカニズムを有効にします。
これは実験的な機能であり、`--enable-experimental`が必要です。
実装には、fast、small、small-stackの各Cコード、x86_64、AArch64、AArch32、Thumb2向けのアセンブリ、さらにASN.1形式の鍵とX.509証明書のサポートが含まれます。
[`--enable-frodokem`](#--enable-frodokem)で有効にします。

### TLSオプション

以下の定義は、オプションのTLSの動作を有効にしたり調整したりします。

#### WOLFSSL_ALTERNATIVE_DOWNGRADE

バージョンのダウングレードを許可するクライアント（例えば`wolfSSLv23_client_method()`を使用する場合）において、最初のClientHelloのレコード層のバージョンを、サポートする最も高いバージョンではなく、ダウングレード可能な最小バージョンに設定します。
新しいバージョンのレコードを拒否するサーバーに対して役立ちます。

#### WOLFSSL_ALLOW_MAX_FRAGMENT_ADJUST

最初のTLSネゴシエーションが完了した後に、最大フラグメントサイズを実行時に調整できるようにします。

#### WOLFSSL_ALLOW_NO_SUITES

利用可能な暗号スイートがない場合でも、SSL/CTXオブジェクトの作成を許可します。
通常、ビルド構成に一致する暗号スイートがない場合はエラーになります。

#### WOLFSSL_DTLS13_SEND_MOREACK_DEFAULT

ハンドシェイク中に中断を検出した際に、DTLS 1.3がピアに直ちにACKを送信するかどうかのデフォルト値を、0（デフォルト）または1で設定します。
ACKを直ちに送信すると遅延は最小になりますが、必要以上に帯域幅を使用する可能性があります。
このマクロは値を取ります（例えば`#define WOLFSSL_DTLS13_SEND_MOREACK_DEFAULT 1`）。
値なしで定義するとコンパイルできません。
この設定は、[`wolfSSL_dtls13_set_send_more_acks()`](group__Setup.md#function-wolfssl_dtls13_set_send_more_acks)によって接続ごとに変更できます。

#### WOLFSSL_BLIND_PRIVATE_KEY

`WOLFSSL_CTX`または`WOLFSSL`オブジェクトが保持する秘密鍵を、ランダムなマスクとXORした状態で保存し、使用中にのみマスクを解除します。
これにより、ロウハンマーなどのメモリ攻撃から秘密鍵を保護します。

#### WOLFSSL_JNI

Java JNI（wolfSSL JNI/JSSE）との互換性に必要なAPIと動作を有効にします。

#### WOLFSSL_OPENVPN

wolfSSLで、OpenVPNとの互換性のための動作を有効にします。
OpenVPNのTLSプロバイダーとしてwolfSSLを使用する場合に必要です。

### デバッグオプション

以下の定義は、開発およびテスト用の追加のデバッグ出力やチェックを有効にします。

#### WC_PKCS7_STREAM_DEBUG

PKCS#7ストリーミング操作のデバッグ出力を有効にします。

#### WOLFSSL_DEBUG_ASN_TEMPLATE

ASN.1テンプレートを使用する際のデバッグ出力を有効にします。
`WOLFSSL_ASN_TEMPLATE`と併用する場合にのみ関連します。

#### WOLFSSL_DEBUG_CERTS

解析、検証、チェーン構築など、証明書処理操作のデバッグログを有効にします。
`WOLFSSL_NO_DEBUG_CERTS`が定義されていない限り、[`DEBUG_WOLFSSL`](#debug_wolfssl)を使用すると自動的に有効になります。
`DEBUG_WOLFSSL`なしで定義した場合、`wolfSSL_CertDebugging_ON()`が呼び出されるか、`WOLFSSL_CERT_LOG_ENABLED_DEFAULT`が1に定義されるまで、証明書に関するメッセージは実行時に出力されません。

#### WOLFSSL_ASN_TEMPLATE_TYPE_CHECK

テスト用にコンパイラの型の問題をより適切にテストするためにASN関数を使用します。
`WOLFSSL_ASN_TEMPLATE`と併用する場合にのみ関連します。

#### WOLFSSL_DEBUG_DTLS

DTLSのデバッグ支援です。
wolfSSLがChangeCipherSpecメッセージをFinishedメッセージと同じデータグラムに強制的に入れないようにし、各レコードを個別に観察できるようにします。
ログ出力は追加されません。

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
`./configure`とuser_settings.hのどちらでビルドする場合でも、`HAVE_POLY1305`が定義されていれば自動的に定義されます。

#### WOLFSSL_ASN_TEMPLATE

テンプレートベースのASN.1処理を使用する新しいバージョンのASN解析コードを有効にします。
この解析は標準的なASN.1ルールに準拠し、テンプレート構造を使用してエンコードとデコードを指示することで、パーサーコードがテンプレート間で汎用化できるようにします。
`WOLFSSL_ASN_ORIGINAL`（`--enable-asn=original`）または`NO_ASN`が定義されていない限り、user_settings.hを使用したビルドを含むすべてのビルドで、これがデフォルトです。

### 機能の有効化 (デフォルトで無効)

**注意**：このセクションのマクロの一部は、`./configure`ビルドではデフォルトでオンになっているか、明示的に無効にしない限り`wolfssl/wolfcrypt/settings.h`によって常に定義されます。
そのような場合は、各項目にデフォルトと無効にする方法を記載しています。
`WOLFSSL_USER_SETTINGS`を使用する場合はconfigureのデフォルトが適用されないため、configureが設定するマクロは手動で定義する必要があります。

#### WOLFSSL_CERT_GEN

wolfSSLの証明書生成機能をオンにします。
詳細については、[第7章 鍵と証明書](chapter07.md)を参照してください。

#### WOLFSSL_DER_LOAD

[`wolfSSL_CTX_der_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_der_load_verify_locations)関数を使用して、wolfSSLコンテキスト(`WOLFSSL_CTX`)へのDERフォーマットされたCA証明書をロードできます。

#### WOLFSSL_DTLS

DTLS(Datagram TLS) 1.2のサポートをオンにします。
DTLS 1.3には[`WOLFSSL_DTLS13`](#wolfssl_dtls13)も必要です。
`--enable-dtls`で有効になります。

#### WOLFSSL_DTLS_CID

DTLS Connection ID（RFC 9146）のサポートを有効にします。
トランスポートアドレスではなくCIDによって接続を識別することで、IPアドレスが変化してもDTLS接続を維持できるようにします。

#### WOLFSSL_DTLS_DROP_STATS

DTLS接続品質の監視やデバッグのために、DTLSパケットのドロップ統計の追跡を有効にします。

#### WOLFSSL_DTLS_DISALLOW_FUTURE

次に期待されるシーケンス番号よりも、リプレイウィンドウサイズ（`DTLS_SEQ_BITS`）を超えて先のシーケンス番号を持つDTLSレコードを拒否します。
デフォルトでは、そのようなレコードは受け入れられ、ウィンドウが前方にスライドします。

#### WOLFSSL_ALLOW_TLSV10

TLS 1.0接続を許可します。
TLS 1.0はセキュリティ上の理由からデフォルトで無効になっています。
レガシー互換性が必要な場合にのみ有効にしてください。
`NO_OLD_TLS`が定義されていないことが必要です。
`--enable-tlsv10`は旧バージョンのTLSをオンにすることでこの条件を満たします。

**警告**：`WOLFSSL_ALLOW_TLSV10`を定義すると、RFC 9846、RFC 8996、RFC 9325に**準拠しない**ビルドになります。
TLS 1.0はRFC 8996で非推奨とされており、RFC 9846では「MUST NOT be negotiated for any reason」（いかなる理由でもネゴシエートしてはならない）と規定されています。

#### WOLFSSL_ALLOW_SSLV3

SSL 3.0接続を許可します。
SSL 3.0はセキュリティ上の理由からデフォルトで無効になっています。
レガシー互換性が必要な場合にのみ有効にしてください。
`NO_OLD_TLS`が定義されていないことが必要です。
`--enable-sslv3`は旧バージョンのTLSをオンにすることでこの条件を満たします。

**警告**：`--enable-sslv3`でビルドするとRFC 7568に違反し、RFC 9846、RFC 8996、RFC 9325に**準拠しない**ビルドになります。
RFC 7568はSSL 3.0を非推奨としており、「SSLv3 MUST NOT be used.」（SSLv3を使用してはならない）と規定しています。

#### WOLFSSL_ALLOW_TLS_SHA1

TLS 1.2以降のハンドシェイクで、SHA-1署名アルゴリズム（例えばrsa_pkcs1_sha1やecdsa_sha1）を提示および使用できるようにします。
RFC 9155がTLS 1.2でのSHA-1署名アルゴリズムを非推奨としているため、デフォルトではこれらはTLS 1.0および1.1でのみ提示されます。
暗号スイートには影響しません。

#### WOLFSSL_EITHER_SIDE

同じ`WOLFSSL_CTX`をクライアント接続とサーバー接続の両方に使用できるようにします。
デフォルトでは、コンテキストは作成時にクライアント用またはサーバー用のいずれかとして構成されます。

#### WOLFSSL_EGD_NBLOCK

EGD（Entropy Gathering Daemon）を使用するシステムで、乱数生成のためのノンブロッキングEGDサポートを有効にします。

#### HAVE_SNI

サーバー名表示(SNI) TLS拡張（RFC 6066）のサポートを有効にします。
クライアントが接続先のホスト名を示せるようにし、TLS上でのバーチャルホスティングを可能にします。
x86、x86_64、aarch64上の`./configure`ビルドではデフォルトで有効です。
`--disable-sni`で無効にできます。

#### WOLFSSL_ALWAYS_KEEP_SNI

サーバー側で、サーバーが`wolfSSL_UseSNI()`でSNIを設定していない場合でもクライアントが送信したSNIホスト名を保存し、アプリケーションが`wolfSSL_SNI_GetRequest()`で読み取れるようにします（ステータスは`WOLFSSL_SNI_FORCE_KEEP`）。
SNI受信コールバックが登録されている場合も同じ動作になります。

#### WOLFSSL_ALWAYS_VERIFY_CB

検証が成功した場合でも、常に証明書検証コールバックを呼び出します。
デフォルトでは、コールバックは失敗時にのみ呼び出されます。

#### HAVE_TRUNCATED_HMAC

切り詰めHMAC（Truncated HMAC）TLS拡張（RFC 6066）を有効にします。
帯域幅を削減するために、フルサイズのHMACタグの代わりに80ビットのHMACタグを使用できるようにします。

#### HAVE_TIME_T_TYPE

`time_t`型がすでに存在するプラットフォームで、`USER_TIME`、`TIME_OVERRIDES`、または同様のカスタム時刻ポートを使用する場合に定義します。
これを定義しない場合、これらの構成ではwolfSSLが独自の`time_t`（`USE_WOLF_TIME_T`、`typedef long time_t`）を提供します。
configureもCMakeもこのマクロを設定しません。

#### HAVE_SECURE_RENEGOTIATION

セキュアな再ネゴシエーション（RFC 5746）のサポートを有効にします。
アクティブなセッション中に、TLS接続で暗号スイートや鍵を再ネゴシエートできるようにします。

#### HAVE_SERVER_RENEGOTIATION_INFO

サーバー側の再ネゴシエーション情報拡張を有効にします。
ServerHelloメッセージで、セキュアな再ネゴシエーションをサポートしていることを示します。
`./configure`ビルドではデフォルトで有効です。
`--disable-secure-renegotiation-info`で無効にできます。

#### HAVE_SESSION_TICKET

TLSセッションチケット（RFC 5077）のサポートを有効にします。
サーバーがセッションチケットを発行できるようにし、サーバー側でセッション状態を保持することなく、より高速なセッション再開を可能にします。
TLS 1.3のセッション再開に必要です。

#### HAVE_TRUSTED_CA

Trusted CA Indication TLS拡張（RFC 6066）を有効にします。
クライアントが信頼するCA証明書をサーバーに示せるようにし、サーバーが適切な証明書チェーンを選択するのに役立ちます。

#### HAVE_RPK

Raw Public Key（RFC 7250）のサポートを有効にします。
TLSでX.509証明書の代わりに生の公開鍵を使用できるようにし、リソースが限られた環境でのハンドシェイクのオーバーヘッドを削減します。

#### HAVE_ECH

Encrypted Client Hello（ECH）のサポートを有効にします。
ClientHelloを暗号化し、SNIなどの機密性の高いフィールドを受動的な観測者から保護します。

#### WOLFSSL_NO_CA_NAMES

CertificateRequestメッセージでCA名を送信しないようにします。
サーバーが多数の信頼済みCAを持つ場合に、ハンドシェイクメッセージのサイズを削減します。

#### WOLFSSL_NO_SERVER_GROUPS_EXT

サーバーの最優先グループがクライアントのリストに含まれていない場合に、サーバーがサポートするグループをTLS拡張で送信しないようにします。

#### HAVE_FFDHE

RFC 7919で標準化されたグループを使用する、有限体Diffie-Hellman Ephemeral（FFDHE）鍵交換を有効にします。
通常、このマクロを自分で定義する必要はありません。
DHが有効で、以下のグループサイズマクロのいずれかが定義されている場合、settings.hが自動的に定義します。

#### HAVE_FFDHE_2048, HAVE_FFDHE_3072, HAVE_FFDHE_4096, HAVE_FFDHE_6144, HAVE_FFDHE_8192

各マクロはRFC 7919のFFDHEグループ（ffdhe2048からffdhe8192）を1つずつ有効にし、それを通じて[`HAVE_FFDHE`](#have_ffdhe)も有効にします。
`./configure`は、DHがTLS 1.3またはサポートされる曲線（supported curves）拡張とともに有効になっている場合、デフォルトで`HAVE_FFDHE_2048`を定義します。
`--disable-dh`で無効にできます。
その他のグループサイズはデフォルトでオフです。

#### HAVE_SECRET_CALLBACK

TLSシークレットコールバックを有効にし、アプリケーションがハンドシェイク中にTLS鍵マテリアルを受け取れるようにします。
キーロギング、デバッグ、外部ツールとの連携に使用されます。

#### HAVE_PK_CALLBACKS

公開鍵操作コールバックを有効にし、アプリケーションがデフォルトのRSA、ECC、DH操作を独自の実装（例えばHSMやセキュアエレメントとの統合）で置き換えられるようにします。

#### WOLFSSL_SNIFFER

TLSパケットスニッフィングのサポートを有効にします。
wolfSSLスニファーライブラリを使用し、秘密鍵によってTLSトラフィックを復号して検査できるようにします。

#### HAVE_WEBSERVER

組み込みWebサーバーが必要とするOpenSSL互換レイヤーの小さなサブセット（例えば`wolfSSL_CTX_ctrl()`のオプション、ロッキングコールバック関数、X.509検証エラーコード）を有効にし、[`WOLFSSL_ENCRYPTED_KEYS`](#wolfssl_encrypted_keys)をオンにします。
`--enable-webserver`で設定されます。

#### HAVE_WOLF_EVENT

非同期操作のためのwolfイベント駆動処理のサポートを有効にします。
保留中の非同期暗号操作を管理するためのイベントキューを提供します。

#### HAVE_WRITE_DUP

`wolfSSL_write_dup()`を有効にします。
この関数は確立済みの接続から書き込み専用の2つ目の`WOLFSSL`オブジェクトを作成し、あるスレッドが元のオブジェクトで読み取りを行いながら、別のスレッドが複製で書き込みを行えるようにします。
`--enable-writedup`で設定されます。

#### WOLFSSL_HAVE_PRF

TLS疑似乱数関数（PRF）へのアクセスを有効にします。
アプリケーションがTLS PRFを使用して追加の鍵マテリアルを導出できるようにします。
`wc_PRF()`、`wc_PRF_TLS()`、`wc_PRF_TLSv1()`を公開します。
`NO_KDF`または`NO_HMAC`が設定されていない限り、settings.hによって自動的に定義されます。

#### WOLFSSL_REQUIRE_TCA

クライアント側の設定です。
クライアントがtrusted_ca_keys拡張を送信したにもかかわらずサーバーがそれを承認しなかった場合に、`TCA_ABSENT_ERROR`でハンドシェイクを失敗させます。
RFC 6066ではサーバーの応答は任意とされているため、デフォルトではクライアントは処理を継続します。

#### WOLFSSL_DH_EXTRA

wolfCryptの`DhKey`構造体に公開鍵と秘密鍵の値を追加し、OpenSSL互換DH APIが使用する`wc_DhImportKeyPair()`、`wc_DhExportKeyPair()`、およびDH鍵のコピーを有効にします。
`WOLFSSL_QT`、`OPENSSL_ALL`、`WOLFSSL_OPENSSH`、または`WOLFSSL_STATIC_EPHEMERAL`を定義すると自動的に定義されます。

#### WOLFSSL_CURVE25519_BLINDING

タイミングサイドチャネル攻撃から保護するために、wolfCryptでX25519秘密鍵操作のスカラーブラインディングを有効にします。
TLSだけでなく、鍵のすべての使用に適用されます。
`wc_curve25519_set_rng()`で鍵にRNGを設定する必要があります。
RNGが利用可能な場合、C実装（`CURVE25519_SMALL`やアセンブリ実装ではないもの）ではデフォルトでオンです。
`NO_CURVE25519_BLINDING`でオフにできます。

#### WOLFSSL_KEY_GEN

wolfSSLのRSA鍵生成機能をオンにします。
詳細については、[第7章 鍵と証明書](chapter07.md)を参照してください。

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
`--enable-keylog-export`で有効になり、このオプションは`SHOW_SECRETS`と`HAVE_SECRET_CALLBACK`も設定します。

#### WOLFSSL_SSLKEYLOGFILE_OUTPUT

このマクロはキーロギングのファイル名を定義します。
`WOLFSSL_SSLKEYLOGFILE`と共に使用してください。
デフォルトは`sslkeylog.log`です。
`SSLKEYLOGFILE`環境変数が設定されている場合にそのパスを優先させるには、`WOLFSSL_SSLKEYLOGFILE_USE_ENV`を定義してください。

#### WOLFSSL_HAVE_WOLFSCEP

wolfSCEPが利用可能かどうかを確認するためにautoconfで使用される機能を有効にします。

#### WOLFSSL_HAVE_MIN

このマクロはライブラリの移植性を高めるためのもので、MIN/MAXがすでにプラットフォームによって定義されているかどうかを示します。
重複定義を防ぎます。

#### WOLFSSL_HAVE_TLS_UNIQUE

「tls-unique」チャネルバインディングとして使用するために、TLSハンドシェイク後に「Finished」メッセージを保持します。
libest portで追加：アプリケーションが「tls-unique」チャネルバインディングタイプ（[RFC 5929 Section 3](https://tex2e.github.io/rfc-translater/html/rfc5929.html#3--The-tls-unique-Channel-Binding-Type)）を取得できるようにします。
これはESTプロトコルで使用され、「所有証明」（[RFC 7030 Section 3.4](https://tex2e.github.io/rfc-translater/html/rfc7030.html#3-4--Proof-of-Possession)および[RFC 7030 Section 3.5](https://tex2e.github.io/rfc-translater/html/rfc7030.html#3-5--Linking-Identity-and-POP-Information)）を通じてTLSセッションに登録をバインドします。

#### WOLFSSL_ENCRYPTED_KEYS

パスワードで暗号化されたPEM秘密鍵の読み込みと書き出しを有効にします。
対象は、従来の暗号化PEM（`Proc-Type` / `DEK-Info`ヘッダー）と、パスワードコールバックを介した暗号化PKCS#8 PEMです。
PKCS#8の暗号化/復号API自体（`wc_EncryptPKCS8Key()`）は[`HAVE_PKCS8`](#have_pkcs8)によって提供されます。
[`--enable-enckeys`](#--enable-enckeys)で設定され、`OPENSSL_EXTRA`、`OPENSSL_EXTRA_X509_SMALL`、または`HAVE_WEBSERVER`を定義した場合も自動的に設定されます。
PKCS#8のRFCドキュメントは[RFC 5208](https://tex2e.github.io/rfc-translater/html/rfc5208)を参照してください。

#### WOLFSSL_CUSTOM_OID

サブジェクトおよび要求拡張用のカスタムOIDサポートを有効にする証明書機能です。
これはカスタムOIDを持つ証明書の解析にも適用されます。

#### WOLFSSL_RIPEMD

RIPEMD-160サポートを有効にします。

#### WOLFSSL_SHA224

SHA-224サポートを有効にします。
x86_64およびaarch64上の`./configure`ビルドではデフォルトで有効です。
`--disable-sha224`で無効にできます。

#### WOLFSSL_SHA384

SHA-384サポートを有効にします。
`./configure`ビルドではデフォルトで有効です。
`--disable-sha384`で無効にできます。

#### WOLFSSL_SHA512

SHA-512サポートを有効にします。
`./configure`ビルドではデフォルトで有効です。
`--disable-sha512`で無効にできます。

#### WOLFSSL_AES_DIRECT

単一ブロックのAES API `wc_AesEncryptDirect()` / `wc_AesDecryptDirect()`を有効にします（複数ブロックのECB APIは[`HAVE_AES_ECB`](#have_aes_ecb)です）。
それ自体ではECBモードは安全とは見なされません。
AESキーラップ（したがってPKCS#7）、CMAC、CTR、CFB、OFB、XTSに必要です。
CTR、CFB、OFB、XTSに対しては、settings.hが自動的にこのマクロをオンにします。
**警告**：ほぼすべてのユースケースで、ECBモードは安全性が低いと考えられています。
可能な限りECB APIを直接使用することは避けてください。

#### DEBUG_WOLFSSL

デバッグ機能を含めてビルドします。
詳細は[第8章 デバッグ](chapter08.md)を参照してください。

#### HAVE_AESCCM

AES-CCMサポートを有効にします。

#### HAVE_AESGCM

AES-GCMサポートを有効にします。
`./configure`ビルドではデフォルトで有効です。
`--disable-aesgcm`で無効にできます。

#### WOLFSSL_AES_XTS

AES-XTSサポートを有効にします。

#### WOLFSSL_AES_128

AES-128の鍵サイズのサポートを有効にします。
AESが有効な場合、settings.hによって常に定義されます。
より大きな鍵サイズのみが必要な場合は、[`NO_AES_128`](#no_aes_128)を定義してAES-128を削除し、コードサイズを削減できます。

#### WOLFSSL_AES_192

AES-192の鍵サイズのサポートを有効にします。
AESが有効で、`AES_MAX_KEY_SIZE`が192以上の場合、settings.hによって常に定義されます。
[`NO_AES_192`](#no_aes_192)を定義すると、AES-192を削除してコードサイズを削減できます。

#### WOLFSSL_AES_256

AES-256の鍵サイズのサポートを有効にします。
AESが有効で、`AES_MAX_KEY_SIZE`が256の場合、settings.hによって常に定義されます。
不要な場合は、[`NO_AES_256`](#no_aes_256)を定義してAES-256を削除できます。

#### AES_MAX_KEY_SIZE

AESの最大鍵サイズをビット単位で設定します。
デフォルトは256です。
コードサイズとメモリ使用量を削減するために、128または192に設定できます。

#### HAVE_AES_ECB

AES-ECB（Electronic Codebook）モードを有効にします。
デフォルトでオフです。
ECBモードは各ブロックを独立して暗号化するため、ほとんどのアプリケーションでは一般に推奨されませんが、一部のプロトコルでは必要です。

#### HAVE_AES_DECRYPT

AES復号のサポートを有効にします。
AESが有効な場合、settings.hによって常に定義されます。
AES暗号化のみを必要とするプラットフォーム（例えばGCMの暗号化のみ）でコードサイズを節約するには、[`NO_AES_DECRYPT`](#no_aes_decrypt)を定義してください。

#### WOLFSSL_AES_COUNTER

AES-CTR（カウンタ）モードを有効にします。
インクリメントするカウンタを使用して、ブロック暗号をストリーム暗号に変換します。

#### WOLFSSL_AES_CFB

AES-CFB（Cipher Feedback）モードを有効にします。
[`WOLFSSL_NO_AES_CFB_1_8`](#wolfssl_no_aes_cfb_1_8)で制限しない限り、CFB-1、CFB-8、CFB-64、CFB-128のサブモードが含まれます。

#### WOLFSSL_NO_AES_CFB_1_8

[`WOLFSSL_AES_CFB`](#wolfssl_aes_cfb)が有効な場合に、AES-CFB-1およびAES-CFB-8のサブモードを無効にします。
CFB-64/128のみが必要な場合にコードサイズを削減します。

#### WOLFSSL_AES_OFB

AES-OFB（Output Feedback）モードを有効にします。
OFBモードはAESをストリーム暗号に変換し、パディングを必要としません。

#### WOLFSSL_AES_CTS

AES-CTS（Ciphertext Stealing）モードを有効にします。
CTSでは、ブロックサイズの倍数ではないデータをパディングなしで暗号化できます。

#### WOLFSSL_AES_SIV

AES-SIV（Synthetic Initialization Vector）モード（RFC 5297）を有効にします。
ノンスの誤用に耐性のあるAEADモードで、決定論的な認証付き暗号化を提供します。

#### WOLFSSL_AES_EAX

AES-EAX AEADモードを有効にします。
EAXはCTRモードとOMAC（CMAC）から構成される2パスのAEAD方式で、関連データ付き認証付き暗号化を提供します。

#### HAVE_AES_KEYWRAP

AESキーラップ（RFC 3394）のサポートを有効にします。
安全に転送するために暗号鍵をラップ（暗号化）する際に使用されます。

#### WOLFSSL_AES_CBC_LENGTH_CHECKS

AES-CBC操作において、入力データ長の厳密な検証を有効にします。
有効にすると、入力長がAESブロックサイズの倍数でない場合に、CBCの暗号化/復号がエラーを返します。

#### HAVE_AESGCM_DECRYPT

AESブロック復号を削除した場合でも、AES-GCM復号を残します。
このマクロはデフォルトではどこでも定義されません。
GCM復号は[`HAVE_AES_DECRYPT`](#have_aes_decrypt)または`HAVE_AESGCM_DECRYPT`が定義されている場合は常にビルドされるため、このマクロを未定義のままにしてもGCM復号は削除されません。
[`NO_AES_DECRYPT`](#no_aes_decrypt)と一緒に定義すると、AES復号の残りの部分を削除しつつ、AES-GCM復号を残すことができます。

#### WOLFSSL_AESGCM_STREAM

ストリーミングAES-GCM APIを有効にします。
AES-GCMデータを一度にすべて処理するのではなく段階的に処理できるため、大きなデータやメモリが制約された環境で役立ちます。

#### WC_AES_GCM_DEC_AUTH_EARLY

復号を実行する前にGCMタグを認証します。
認証タグが一致しない場合にすぐに失敗するため、無効な暗号文を不必要に復号することを避けられます。

#### GCM_TABLE

AES-GCM（GHASH）のガロア体乗算に、事前計算された8ビット（256エントリ、鍵ごとに4 KB）のルックアップテーブルを使用します。
[`GCM_SMALL`](#gcm_small)より高速ですが、より多くのメモリを使用します。
`--enable-aesgcm=table`で選択されます。
[`GCM_TABLE_4BIT`](#gcm_table_4bit)と[`GCM_WORD32`](#gcm_word32)も参照してください。

#### GCM_TABLE_4BIT

AES-GCM（GHASH）のガロア体乗算に、4ビット（鍵ごとに512バイト）のルックアップテーブルを使用します。
[`GCM_TABLE`](#gcm_table)より小さくなります。
`./configure`（`--enable-aesgcm`は特に指定しない限り`4bit`を選択します）および`WOLFSSL_ARMASM`では、これがデフォルトです。

#### GCM_WORD32

AES-GCMのガロア体乗算に、32ビットワードの実装を使用します。
[`GCM_SMALL`](#gcm_small)および[`GCM_TABLE`](#gcm_table)の代替となるもので、64ビットをサポートしないプラットフォームで適しています。

#### WOLFSSL_AESXTS_STREAM

ストリーミングAES-XTS APIを有効にします。
単一の操作ではなく、複数回のupdate呼び出しにわたってAES-XTSデータを段階的に処理できるようにします。

#### WC_AESXTS_STREAM_NO_REQUEST_ACCOUNTING

ストリーミングAES-XTS APIのリクエストアカウンティングを無効にします。
不要な場合に、データユニット境界を追跡するオーバーヘッドを取り除きます。

#### WC_AES_XTS_SUPPORT_SIMULTANEOUS_ENC_AND_DEC_KEYS

AES-XTSコンテキストが暗号化鍵と復号鍵の両方を同時に保持できるようにします。
デフォルトでは、メモリを節約するために、XTSコンテキストは一度に一方向のみをサポートします。

#### HAVE_CAMELLIA

Camelliaサポートを有効にします。

#### HAVE_CHACHA

ChaCha20サポートを有効にします。
`./configure`ビルドでは（FIPSビルドを除き）デフォルトで有効です。
`--disable-chacha`で無効にできます。

#### HAVE_POLY1305

Poly1305サポートを有効にします。
`./configure`ビルドでは（FIPSビルドを除き）デフォルトで有効です。
`--disable-poly1305`で無効にできます。

#### POLY130564

64ビットプラットフォームでより高いパフォーマンスを得るために、64ビットのPoly1305実装を使用します。
64ビットをサポートするプラットフォームでは自動的に選択されます。

#### USE_INTEL_POLY1305_SPEEDUP

Intel/AMDプロセッサーでスループットを最大化するために、Intel AVX/AVX2で最適化されたPoly1305実装を有効にします。
x86_64で[`USE_INTEL_SPEEDUP`](#use_intel_speedup)（`--enable-intelasm`）が定義されている場合、`NO_POLY1305_ASM`が定義されていない限り自動的に設定されます。
`WOLFSSL_POLY1305_NO_AVX512`が定義されていない限り、AVX-512のコードパスも含まれます。
このマクロではなく、`USE_INTEL_SPEEDUP`を定義してください。

#### HAVE_CRL

証明書失効リスト(CRL)サポートを有効にします。

#### HAVE_CRL_IO

CRL URLでインラインHTTPリクエストをブロックできるようにします。
CRLを`WOLFSSL_CTX`にロードし、作成したすべてのwolfSSLオブジェクトに適用します。

#### HAVE_ECC

楕円曲線暗号化(ECC)サポートを有効にします。
`./configure`ビルドではデフォルトで有効です。
`--disable-ecc`で無効にできます。

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

#### OLD_HELLO_ALLOWED

SSLv2のレコード形式を使用してより新しいプロトコルバージョンをネゴシエートするレガシークライアントとの後方互換性のために、SSLv2形式のClientHelloメッセージを許可します。

#### WOLFSSL_NGINX

OpenSSL互換性をもつアプリケーション固有のマクロです。
`(--enable-nginx) WOLFSSL_NGINX`を使用します。

#### WOLFSSL_ERROR_CODE_OPENSSL

OpenSSL互換性API `wolfSSL_EVP_PKEY_cmp`は成功時に0、失敗時に-1を返します。
この動作はOpenSSLとは異なります。
`EVP_PKEY_cmp`は以下を返します。

- `1`: 2つのキーが一致する
- `0`: 一致しない
- `-1`: キータイプが異なる
- `-2`: 操作がサポートされていない

この関数がOpenSSLと同じ動作をするようにしたい場合は、`WS_RETURN_CODE`がOpenSSLと同等の動作に戻り値を変換するように、`WOLFSSL_ERROR_CODE_OPENSSL`を定義してください。

#### WOLFSSL_HARDEN_TLS

[RFC 9325](https://tex2e.github.io/rfc-translater/html/rfc9325)で指定された推奨事項を実装します。
このマクロは、望ましいセキュリティビット数に定義する必要があります。
現在実装されている値は112ビットと128ビットです。
`--enable-harden-tls[=112|128]`で有効になります（`yes`は`112`と同じです）。
以下のマクロは特定のチェックを無効にします。

- `WOLFSSL_HARDEN_TLS_ALLOW_TRUNCATED_HMAC`
- `WOLFSSL_HARDEN_TLS_ALLOW_OLD_TLS`
- `WOLFSSL_HARDEN_TLS_NO_SCR_CHECK`
- `WOLFSSL_HARDEN_TLS_NO_PKEY_CHECK`
- `WOLFSSL_HARDEN_TLS_ALLOW_ALL_CIPHERSUITES`

#### WOLFSSL_ASIO

OpenSSL互換性をもつアプリケーション固有のマクロです。

#### WOLFSSL_QT

Qtフレームワークが必要とするOpenSSL互換APIと動作を有効にします（`--enable-qt`）。
また、[`WOLFSSL_DH_EXTRA`](#wolfssl_dh_extra)もオンにします。

#### WOLFSSL_QNX_CAAM

QNXベースのシステムでハードウェアアクセラレーションによる暗号処理を行うために、QNX CAAM（Cryptographic Acceleration and Assurance Module）のサポートを有効にします。

#### WOLFSSL_HAPROXY

OpenSSL互換性をもつアプリケーション固有のマクロです。

#### WOLFSSL_ASYNC_IO

ノンブロッキングI/Oからの戻り（`WANT_READ` / `WANT_WRITE`）、保留中のOCSPルックアップ、遅延されたチェーン検証コールバック、または非同期暗号処理の後に、TLS関数が処理を再開できるようにします。
settings.hによってデフォルトで定義されます。
[`WOLFSSL_NO_ASYNC_IO`](#wolfssl_no_async_io)でオフにできますが、非同期暗号処理、`WOLFSSL_NONBLOCK_OCSP`、または`WOLFSSL_CHAIN_VERIFY_CB`がこのマクロを必要とする場合はオフになりません。

#### WOLFSSL_ASYNC_CRYPT_SW

テスト用に、ソフトウェアベースの非同期暗号処理シミュレーションを有効にします。
実際の非同期ハードウェアを必要とせずに、非同期の動作をシミュレートします。

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

テスト専用です。
`wolfssl/ssl.h`が実際のOpenSSLヘッダーもインクルードするようにし、`--enable-opensslcoexist`ビルドでシンボルの衝突がないことを確認します。
OpenSSLのインクルードパスとともにCFLAGSで指定してください。
configureはこのマクロを設定しません。

#### TEST_PK_PRIVKEY

PKコールバックのテストにのみ使用されます。
`wolfssl/test.h`ではPKコールバックでロード・使用される実際の秘密鍵を渡すために、コンテキストを使用します。

#### TEST_BUFFER_SIZE

サンプルのクライアント/サーバー`-B`オプションで使用される、TLSベンチマークテストバッファサイズのオーバーライドを可能にします。

#### FORCE_BUFFER_TEST

ファイルシステムを使用する代わりに、`test_certs.h`バッファの使用を強制します。
`wolfssl/test.h`の内部テストにのみ使用されます。

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
詳細については[こちら](https://github.com/wolfSSL/wolfssl/blob/master/doc/QUIC.md)を参照してください。

#### WOLFSSL_QUIC_MAX_RECORD_CAPACITY

最大quicキャパシティを1024*1024 -- 1 MBとして定義します。

#### WOLFSSL_RENESAS_FSPSM_TLS

`WOLFSSL_RENESAS_FSPSM`に加えて、Renesas FSP Security ModuleへのTLSレイヤーのオフロード（例えば証明書検証、マスターシークレット生成、TLS HMAC）を有効にします。
すべてのボードがサポートしているわけではありません。
`IDE/Renesas/e2studio`配下にある各ボードの`user_settings.h`を参照してください。

#### WOLFSSL_REFCNT_ERROR_RETURN

内部用のマクロです。
参照カウントが（アトミック操作ではなく）ミューテックスで保護される場合に`wolfssl/wolfcrypt/wc_port.h`が定義し、参照カウント関数が返す可能性のあるエラーを呼び出し元がチェックするようにします。
ユーザーが定義しないでください。

#### WOLFSSL_RENESAS_TSIP_TLS

`WOLFSSL_RENESAS_TSIP`に加えて、TLSレイヤーでのRenesas TSIPの使用（例えばTLS 1.3の鍵交換と鍵導出、TLS HMAC、証明書検証）を有効にします。
wolfCryptのみのアクセラレーションを行う場合は、このマクロを未定義のままにして`WOLFSSL_RENESAS_TSIP_CRYPTONLY`を定義してください。

#### WOLFSSL_SM2

SM2楕円曲線署名と鍵交換を有効にします（`--enable-sm2`、ECCが必要です）。
SM2、SM3、SM4の実装は、別パッケージのwolfSM（https://github.com/wolfSSL/wolfsm）に含まれています。

#### WOLFSSL_SM3

SM3ハッシュを有効にします（`--enable-sm3`）。
wolfSMパッケージが必要です。

#### WOLFSSL_SM4

SM4ブロック暗号を有効にします。
`--enable-sm4-ecb`、`--enable-sm4-cbc`、`--enable-sm4-ctr`、`--enable-sm4-gcm`、`--enable-sm4-ccm`のいずれかのオプションを使用すると設定されます。
wolfSMパッケージが必要です。

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

C#ラッパーに必要な構成オプションをオンにします。

#### HAVE_CURVE25519

Curve25519アルゴリズムの使用をオンにします。

#### HAVE_ED25519

ED25519アルゴリズムの使用をオンにします。

#### HAVE_ED448

Ed448署名を有効にします。
[`--enable-ed448`](#--enable-ed448)で有効になります。

#### WOLFSSL_DH_CONST

Diffie Hellman Operationsを実行するときにフローティングポイント値の使用をオフにし、`XPOW()`および`XLOG()`のテーブルを使用します。
外部数学ライブラリへの依存関係を削除します。

#### WOLFSSL_TRUST_PEER_CERT

信頼できるピア証明書の使用をオンにします。
これにより、CAを使用する代わりに、接続と照合するためのピア証明書をロードできます。
有効にした場合、信頼できるピア証明書が一致すると、ピアの証明書チェーンはロードされず、ピアは検証済みと見なされます。
CA証明書を使用することが望ましいです。

#### WOLFSSL_STATIC_MEMORY

静的メモリバッファと機能の使用をオンにします。
これにより、動的ではなく静的メモリを使用できます。

#### WOLFSSL_STATIC_MEMORY_LEAN

合わせて、`WOLFSSL_STATIC_MEMORY`の定義が必要です。
65k未満のメモリプールサイズを必要とする構造体に対してより小さい型サイズを使用し、IOバッファなどの使用可能な機能を制限してフットプリントサイズを削減します。

#### WOLFSSL_SESSION_EXPORT

TLS（`wolfSSL_tls_export()` / `wolfSSL_tls_import()`）およびDTLS（`wolfSSL_dtls_export()` / `wolfSSL_dtls_import()`）のセッションのエクスポートとインポートをオンにします。
これにより、セッションの現在の状態をシリアル化および送受信することができます。
`--enable-sessionexport`で有効になります。

#### WOLFSSL_SESSION_EXPORT_DEBUG

セッションのエクスポートおよびインポート操作のデバッグログを有効にします。
セッションのシリアル化に関する問題の診断に役立ちます。

#### WOLFSSL_SESSION_EXPORT_NOPEER

エクスポートされるセッションから、ピアのネットワークアドレス（IPアドレス、ポート、アドレスファミリー）を除外します。
このマクロを定義しない場合、エクスポートとインポートでは、ピアアドレスの取得/設定I/Oコールバック（`wolfSSL_CTX_SetIOGetPeer()` / `wolfSSL_CTX_SetIOSetPeer()`）を通じてピアアドレスを保存および復元します。
`--enable-sessionexport=nopeer`で設定されます。

#### WOLFSSL_ARMASM

ARMv8ハードウェアアクセラレーションの使用をオンにします。

#### WC_RSA_NONBLOCK

RSAノンブロッキングサポートをオンにして、RSA操作をより小さな仕事の塊に分割して処理します。
この機能は、Fast Math（`fp_exptmod_nb`、`TFM_TIMING_RESISTANT`が必要）、またはSPのsmallノンブロッキング演算（`WOLFSSL_SP_NONBLOCK`と、`WOLFSSL_SP_SMALL`、`WOLFSSL_SP_NO_MALLOC`、`RSA_LOW_MEM`）によって実現されます。
`--enable-rsa=nonblock`で有効になります。
この機能は、[`wc_RsaSetNonBlock()`](group__RSA.md#function-wc_rsasetnonblock)を呼び出し、`FP_WOULDBLOCK` / `MP_WOULDBLOCK`戻りコードをチェックすることにより有効になります。

#### WC_RSA_BLINDING

タイミング耐性（RSA秘密鍵のブラインディング）を有効にするために使用されます。
`./configure`ビルドでは、RNGが有効な場合に`--enable-harden`によってデフォルトで有効になります。
`--disable-harden`で無効にできます。

#### WC_RSA_PSS

RSA PSSパディングを有効にします。
TLS 1.3でサポートされる唯一のRSAパディングスキームはPSSです（仕様によるものです）。
PSSパディングはランダムパディングを使用します。
`./configure`はRSAとTLS 1.3が有効な場合（デフォルト）は常にこのマクロをオンにするため、そのようなビルドから除外するにはTLS 1.3も無効にする（`--disable-tls13`）必要があります。
それ以外の場合は、`--enable-rsapss`で有効にしてください。

#### WOLFSSL_RSA_VERIFY_ONLY

RSA検証のみを使用する小さなビルドをオンにします。
[`WOLFSSL_RSA_PUBLIC_ONLY`](#wolfssl_rsa_public_only)、[`WOLFSSL_RSA_VERIFY_INLINE`](#wolfssl_rsa_verify_inline)、[`NO_SIG_WRAPPER`](#no_sig_wrapper)、[`WOLFCRYPT_ONLY`](#wolfcrypt_only)マクロと一緒に使用してください。

#### WOLFSSL_RSA_PUBLIC_ONLY

RSAの公開鍵のみを使用する小さなビルドをオンにします。
[`WOLFCRYPT_ONLY`](#wolfcrypt_only)マクロと一緒に使用してください。

#### WOLFSSL_SHA3

SHA3使用のビルドをオンにします。
これは、SHA3-224、SHA3-256、SHA3-384、SHA3-512のSHA3 Keccakのサポートです。
さらに、`WOLFSSL_SHA3_SMALL`を使用してパフォーマンスとリソース使用のトレードオフを行うことができます。
`./configure`ビルドではデフォルトで有効です。
x86_64およびaarch64では直接有効になり、その他のホストではデフォルトの[`WOLFSSL_HAVE_MLKEM`](#wolfssl_have_mlkem)ビルドが必要とするために有効になります。
`--disable-sha3`で無効にできますが、その場合はデフォルトのML-KEMビルドも無効になります。

#### USE_ECDSA_KEYSZ_HASH_ALGO

エフェメラルECDHE鍵サイズまたは次に使用可能な次の最高値と一致するハッシュアルゴリズムを選択します。
この回避策は、SHA512でハッシュされたP-256鍵などのシナリオを正しくサポートしていないいくつかのピアに関する問題を解決します。

#### WOLFSSL_ALT_CERT_CHAINS

有効なチェーンの一部ではないCA証明書を、通信相手が提示することを許可します。
デフォルトのwolfSSLの動作は、提示されたすべてのピア証明書の検証を要求することです。
また、中間CA証明書を信頼済みとしてロードし、ルートまでのチェーン上位にあるCAについての署名者不在（no signer）エラーを無視できるようにします。
代替の証明書チェーンモードでは、ピア証明書が信頼できるCAまで検証できることのみが要求されます。

#### WOLFSSL_SYS_CA_CERTS

[`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs)が呼び出されたとき、wolfSSL証明書マネージャーにそれらをロードするか、システム認証APIを呼び出すことで、wolfSSLが検証のためにシステムのCA証明書を使用できるようにします。
詳細は[`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs)を参照してください。
このプリプロセッサマクロは、デフォルトで有効になっている`--enable-sys-ca-certs`構成オプションによって自動的に設定されます。
`--disable-sys-ca-certs`で無効にできます。

#### WOLFSSL_SYS_CRYPTO_POLICY

利用可能なアルゴリズムや鍵サイズを制限するための、システムレベルの暗号ポリシー設定（例えば`/etc/crypto-policies`）に従います。

#### WOLFSSL_APPLE_NATIVE_CERT_VALIDATION

TLSピア証明書を認証する際にAppleのネイティブトラストAPIの使用を有効にします。
[WOLFSSL_SYS_CA_CERTS](#wolfssl_sys_ca_certs)が定義されている必要があります。
iOSや他のAppleデバイスで`configure`または`CMake`でビルドする場合、このマクロをユーザーが設定する必要はありませんが、macOSでネイティブ検証方法を使用したい場合は明示的に設定する必要があります。

#### WOLFSSL_TEST_APPLE_NATIVE_CERT_VALIDATION

Appleネイティブ証明書検証のテストモードを有効にします。
Apple証明書検証との統合のユニットテストに使用されます。

#### WOLFSSL_CUSTOM_CURVES

標準以外の曲線を許可します。
計算では、曲線"a"変数が含まれています。
[`HAVE_ECC_SECPR2`](#have_ecc_secpr2)、[`HAVE_ECC_SECPR3`](#have_ecc_secpr3)、[`HAVE_ECC_BRAINPOOL`](#have_ecc_brainpool)および[`HAVE_ECC_KOBLITZ`](#have_ecc_koblitz)を使用して、追加の曲線タイプを有効にできます。

#### HAVE_ECC_SECPR2

追加の素数曲線secp160r2、prime192v2、prime239v2を有効にします。
`--enable-ecccustcurves=all`で設定されます（`--enable-all`および`--enable-distro`でも設定されます）。

#### HAVE_ECC_SECPR3

追加の素数曲線prime192v3およびprime239v3を有効にします。
`--enable-ecccustcurves=all`で設定されます（`--enable-all`および`--enable-distro`でも設定されます）。

#### HAVE_ECC_BRAINPOOL

Brainpool曲線brainpoolP160r1からbrainpoolP512r1を有効にします。
`WOLFSSL_CUSTOM_CURVES`が必要です（定義されていない場合はエラーでビルドが停止します）。
[`--enable-brainpool`](#--enable-brainpool)で設定されます。
このオプションは、[`--enable-ecccustcurves`](#--enable-ecccustcurves)を使用する場合は常にデフォルトでオンになります。

#### HAVE_ECC_KOBLITZ

Koblitz曲線secp160k1、secp192k1、secp224k1、secp256k1を有効にします。
`WOLFSSL_CUSTOM_CURVES`が必要です（定義されていない場合はエラーでビルドが停止します）。
`--enable-ecccustcurves=all`で設定されます（`--enable-all`および`--enable-distro`でも設定されます）。

#### HAVE_COMP_KEY

ECC圧縮鍵サポートを有効にします。

#### WOLFSSL_EXTRA_ALERTS

TLS接続中に追加のアラートを送信できるようにします。
この機能は、[`--enable-opensslextra`](#--enable-opensslextra)を使用すると自動的に有効になります。

#### WOLFSSL_EXTRA

完全なOpenSSL互換レイヤーなしで、いくつかのAPIを有効にします。
対象は`wolfSSL_get_keys()`、`wolfSSL_set_quiet_shutdown()` / `wolfSSL_CTX_set_quiet_shutdown()`、`wolfSSL_set_accept_state()`です。

#### WOLFSSL_DEBUG_TLS

TLS接続中に追加のデバッグプリントアウトを有効にします。

#### WOLFSSL_DEBUG_TRACE_ERROR_CODES

デバッグのために、エラーコードの発生元のトレースを有効にします。
wolfSSLソースコード内でエラーコードが生成された場所をログに記録します。

#### WOLFSSL_DEBUG_MEMORY

メモリ割り当てのデバッグを有効にします。
`malloc()`および`free()`の呼び出しを、ファイル名と行番号の情報とともにログに記録します。

#### WOLFSSL_DEBUG_OPENSSL

OpenSSL互換レイヤー関数のデバッグログを有効にします。
どのOpenSSL互換APIが呼び出されているかをトレースするのに役立ちます。
wolfSSL 5.9.4以降は、[`WOLFSSL_VERBOSE_LOGGING`](#wolfssl_verbose_logging)のエイリアスとして機能します。

#### WOLFSSL_VERBOSE_LOGGING

最も出力量の多いトレースメッセージ（`WOLFSSL_MSG_VERBOSE()`および`WOLFSSL_ENTER_VERBOSE()`）を`DEBUG_WOLFSSL`ビルドに含めます。
このレベルのトレースは1回のAPI呼び出しで数千回出力されることがあるため、通常のデバッグビルドではコンパイル時に除外されており、これによってデバッグ出力量が約62%削減されます。
このマクロ単独では何も行いません。
`DEBUG_WOLFSSL`も必要です。
詳細は[第8章 デバッグ](chapter08.md)の「詳細ログ」節を参照してください。

#### HAVE_BLAKE2B

BLAKE2bアルゴリズムのサポートを有効にします。
`--enable-blake2b`（別名`--enable-blake2`）で有効になります。

#### HAVE_BLAKE2S

BLAKE2sアルゴリズムのサポートを有効にします。
`--enable-blake2s`で有効になります。

#### HAVE_BLAKE2

[`HAVE_BLAKE2B`](#have_blake2b)の旧名です。
settings.hにより`HAVE_BLAKE2B`にマッピングされます。

#### HAVE_FALLBACK_SCSV

効果はありません。
以前は、サーバー側でのSignaling Cipher Suite Value(SCSV)サポートを有効にするマクロでした。
これはクライアントから送信される暗号スイート`0x56 0x00`を処理し、TLSバージョンのダウングレードを許可しないことを示すものです。
wolfSSL 5.9.4以降、サーバーは常にTLS_FALLBACK_SCSV（RFC 7507）をチェックします。

#### HAVE_AEAD

内部用のマクロです。
AEAD暗号（AES-GCM、AES-CCM、ChaCha20-Poly1305、ARIA、SM4-GCM/CCM、またはTLS 1.3のNULL暗号）がビルドされる場合に、`wolfssl/internal.h`によって自動的に定義されます。
直接定義しないでください。

#### HAVE_AES_CBC

AES CBCのオプションを有効にします。
AESが有効な場合、settings.hにより常に定義されます。
削除するには[`NO_AES_CBC`](#no_aes_cbc)を定義してください。

#### HAVE_ALPN

Application-Layer Protocol Negotiation（ALPN）TLS拡張（RFC 7301）を有効にします。
`--enable-alpn`で有効になります。

#### HAVE_CAVIUM_OCTEON_SYNC

Marvell Cavium/Octeonハードウェアのブロッキング（同期）バージョンを有効にします。

#### HAVE_CERTIFICATE_STATUS_REQUEST

status_request TLS拡張（RFC 6066）によるOCSPステープリングを有効にします。
`--enable-ocspstapling`で有効になります。

#### HAVE_CERTIFICATE_STATUS_REQUEST_V2

複数のOCSPレスポンスを格納できるstatus_request_v2 TLS拡張（RFC 6961）によるOCSPステープリングを有効にします。
`--enable-ocspstapling2`で有効になります。

#### HAVE_CURL

cURLとリンクする際、wolfSSLライブラリのサブセットをビルドするために使用されます。

#### HAVE_CURVE448

Curve448サポート用に定義します。
追加のマクロ設定を変更できます。
デフォルトでは共有シークレット、キーのエクスポート、およびインポートが有効になっています。

#### HAVE_CURVE448_SHARED_SECRET

Curve448の共有シークレット計算を有効にします。
[`HAVE_CURVE448`](#have_curve448)が有効な場合はデフォルトで有効です。

#### HAVE_CURVE448_KEY_EXPORT

Curve448の公開鍵のエクスポートを有効にします。
[`HAVE_CURVE448`](#have_curve448)が有効な場合はデフォルトで有効です。

#### HAVE_CURVE448_KEY_IMPORT

Curve448の公開鍵のインポートを有効にします。
[`HAVE_CURVE448`](#have_curve448)が有効な場合はデフォルトで有効です。

#### WOLFSSL_NO_ECDHX_SHARED_ZERO_CHECK

wolfSSL 5.9.2以降、Curve25519およびCurve448の共有シークレット計算では、計算結果がすべてゼロの場合にデフォルトで`ECC_OUT_OF_RANGE_E`を返して拒否します（RFC 7748 Section 6.1、位数の小さいピアの点への対策）。
このチェックをスキップするには、`WOLFSSL_NO_ECDHX_SHARED_ZERO_CHECK`を定義してください。

#### HAVE_DANE

DANE（RFC 6698）サポート用のプレースホルダーです。
このマクロを参照するコードはないため、現時点では定義しても効果はありません。

#### WOLFSSL_HAVE_MLKEM

wolfCryptでのML-KEM（FIPS 203）鍵カプセル化と、TLS 1.3のML-KEMおよびハイブリッド鍵交換グループを有効にします。
`./configure`によるビルドではデフォルトで有効であり、SHA-3とSHAKEも有効になります。
ただし、SHA-3またはSHAKEを明示的に無効にした場合や、v7より古いFIPSビルドの場合は有効になりません。
無効にするには[`--disable-mlkem`](#--disable-mlkem)を使用します（`--enable-kyber`は[`--enable-mlkem`](#--disable-mlkem)の別名です）。

#### WOLFSSL_HAVE_MLDSA

wolfCryptでのML-DSA（FIPS 204）署名を有効にします。
[`--enable-mldsa`](#--enable-mldsa)（別名`--enable-dilithium`）によって設定されます。

#### HAVE_DILITHIUM

[`WOLFSSL_HAVE_MLDSA`](#wolfssl_have_mldsa)の旧名です。
settings.hは`HAVE_DILITHIUM`を`WOLFSSL_HAVE_MLDSA`にマッピングします。
また、`WOLFSSL_NO_DILITHIUM_LEGACY_GATES`が定義されていない限り、`WOLFSSL_HAVE_MLDSA`が設定されている場合は常に`HAVE_DILITHIUM`も定義します。

#### WOLFSSL_MLDSA_VERIFY_ONLY

ML-DSAの署名検証のみを残し、鍵生成と署名を削除します。
`--enable-mldsa=verify-only`で有効にできます。

#### WOLFSSL_MLDSA_VERIFY_SMALLEST_MEM

メモリ使用量が最小となるML-DSA検証処理を使用します。
TI C2000 C28xのような、リソースが非常に限られたターゲットを対象としています。

#### WOLFSSL_HAVE_LMS

wolfCryptでLMS/HSSステートフルハッシュベース署名スキーム（RFC 8554）を有効にします。
[`--enable-lms`](#--enable-lms)によって設定され、このオプションは`verify-only`（`WOLFSSL_LMS_VERIFY_ONLY`）と`small`（`WOLFSSL_WC_LMS_SMALL`）の値も受け付けます。
秘密鍵は署名のたびに変化するため、署名には`wc_LmsKey_SetWriteCb()`と`wc_LmsKey_SetReadCb()`で設定する鍵状態コールバックが必要です。

#### WOLFSSL_HAVE_XMSS

wolfCryptでXMSS/XMSS^MTステートフルハッシュベース署名スキーム（RFC 8391）を有効にします。
[`--enable-xmss`](#--enable-xmss)によって設定され、このオプションは`verify-only`（`WOLFSSL_XMSS_VERIFY_ONLY`）と`small`（`WOLFSSL_WC_XMSS_SMALL`）の値も受け付けます。
秘密鍵は署名のたびに変化するため、署名には`wc_XmssKey_SetWriteCb()`と`wc_XmssKey_SetReadCb()`で設定する鍵状態コールバックが必要です。

#### HAVE_DH_DEFAULT_PARAMS

効果はなく、ビルドの互換性のために残されています。
`--enable-defaultdhparams`（デフォルトで有効）とCMakeオプション`WOLFSSL_DH_DEFAULT_PARAMS`は引き続きこのマクロを定義しますが、ライブラリのコードはこれを参照しません。

#### HAVE_ED25519_KEY_IMPORT

Ed25519の鍵のインポートを有効にします。
[`HAVE_ED25519`](#have_ed25519)が有効な場合はデフォルトで有効であり、`NO_ED25519_KEY_IMPORT`を定義すると削除できます。
関連するマクロ`HAVE_ED25519_MAKE_KEY`、`HAVE_ED25519_SIGN`、`HAVE_ED25519_VERIFY`、`HAVE_ED25519_KEY_EXPORT`も同様に動作し、それぞれに対応する`NO_ED25519_*`マクロがあります。

#### HAVE_EX_DATA

CTX/WOLFSSLのユーザー情報用の「追加」EXデータAPIを有効にします。

#### HAVE_EX_DATA_CLEANUP_HOOKS

SSL、CTX、SESSION、X509、X509_STORE、X509_STORE_CTX、BIO、RSAの各オブジェクトのex_dataに対してクリーンアップコールバックを登録する、`*_set_ex_data_with_cleanup()`版の関数（および汎用の`wolfSSL_CRYPTO_set_ex_data_with_cleanup()`）を追加します。

#### HAVE_EX_DATA_CRYPTO

SSL/CTX/X509オブジェクトに加えて、RSA鍵やECC鍵などのwolfCryptオブジェクトに対しても追加データ（ex_data）のサポートを有効にします。

#### HAVE_FALCON

Falconポスト量子署名スキーム（レベル1および5）を有効にします。
wolfSSL 5.9.4では、従来のliboqsラッパーが、暗号コールバックとARM DSP / AArch64 NEONによる高速化をサポートするネイティブのwolfCrypt実装に置き換えられました。
[`--enable-falcon`](#--enable-falcon)はこのスキームを有効にし、浮動小数点 / FFTのバックエンドとメモリプロファイルも選択します。
Falconは標準化されていないため、`--enable-falcon`には`--enable-experimental`も必要です。

#### HAVE_FIPS

さまざまなFIPSバージョンを実装する際に使用されます。

#### HAVE_FUZZER

セキュリティテストのためのファジング用コールバックのサポートを有効にします。
TLSレコードの処理中にレコードを変更または検査できるコールバックを設定できるようになります。

#### HAVE_KEYING_MATERIAL

[RFC 8446 Section 7.5](https://tex2e.github.io/rfc-translater/html/rfc8446#7-5--Exporters)に基づいてキーイング材料のエクスポートを有効にします。

#### HAVE_OID_DECODING

ASNテンプレートコードに含まれています。
一部のケースでデコードに使用されます。

#### HAVE_MAX_FRAGMENT

最大フラグメントサイズを設定します。
TLS拡張機能です。

#### HAVE_MEMCACHED

memcachedとwolfSSLの互換性のために必要なAPIと動作を有効にします。

#### WOLFSSL_PSK_ONE_ID

TLS 1.3でPSK IDを1つだけサポートします。

#### WOLFSSL_PSK_IDENTITY_ALERT

ハンドシェイク中にPSK IDの検索に失敗した場合、一般的なハンドシェイク失敗ではなく、特定のTLSアラートを送信します。

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

#### MAX_EX_DATA

SSL/CTX/X509オブジェクトごとに格納できる追加データ（ex_data）エントリの最大数を設定します。
定義されていない場合のデフォルトは5です。

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

#### WOLFSSL_STATIC_EPHEMERAL

固定（「静的」）のエフェメラル(EC)DH鍵を、[`wolfSSL_CTX_set_ephemeral_key()`](ssl_8h.md#function-wolfssl_ctx_set_ephemeral_key)または`wolfSSL_set_ephemeral_key()`で読み込めるようにします。
これにより、スニファーはエフェメラル鍵交換を使用するトラフィックを復号化できます。
1つのエフェメラル鍵を複数の接続で再利用すると前方秘匿性が失われるため、テスト、検査、またはデバッグの目的にのみ使用してください。
`--enable-sniffer`により自動的に設定されます。

#### SSL_SNIFFER_EXPORTS

WIN32スニファーエクスポートです。

#### WOLFSSL_SNIFFER_KEYLOGFILE

SSLキーログファイルオプションは、スニファーが[NSSキーログファイル](https://web.archive.org/web/20220531072242/https://firefox-source-docs.mozilla.org/security/nss/legacy/key_log_format/index.html)から取得したマスターシークレットを使用してTLSトラフィックを復号化できるようにします。
これにより、スニファーは一時的な暗号スイートを使用するTLS接続でも、すべてのTLSトラフィックを復号化できます。
キーログファイルスニッフィングはTLSバージョン1.2および1.3でサポートされています。
wolfSSLは、スニファー機能とは別に、`--enable-keylog-export`構成オプションを使用してキーログファイルをエクスポートするように構成できます。
（注意：これは本質的に安全ではないため、本番環境では絶対に行わないでください）
キーログファイルのスニファーサポートを有効にするには、`./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_KEYLOGFILE`という構成コマンドラインを使用して、これまでと同様にビルドします。

#### WOLFSSL_SNIFFER_STORE_DATA_CB

Store Data Callbackオプションを使用すると、スニファーは再割り当てされたデータポインタではなくカスタムバッファにアプリケーションデータを保存する際に呼び出されるコールバックを取ることができます。
コールバックはすべてのデータが消費されるまでループで呼び出されます。
このオプションを有効にするには、`./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_STORE_DATA_CB`という構成コマンドラインを使用して、これまでと同様にビルドします。

#### WOLFSSL_SNIFFER_WATCH

Session Watchingオプションを使用すると、スニファーは初期設定なしで提供された任意のパケットを監視できます。
すべてのTLSセッションのデコードを開始し、サーバーの証明書が検出されると、その証明書はユーザーが提供したコールバック関数に渡され、適切な秘密鍵を提供する必要があります。
このオプションを有効にするには、`./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_WATCH`という構成コマンドラインを使用して、これまでと同様にビルドします。

#### STATIC_BUFFER_LEN

各SSLオブジェクト内の静的な入力バッファおよび出力バッファのサイズです。
オーバーライドできます。
デフォルトは`RECORD_HEADER_SZ`であり、静的に保持されるのはレコードヘッダーのみで、それより大きなバッファは必要に応じて確保されます。
[`LARGE_STATIC_BUFFERS`](#large_static_buffers)を使用すると、1レコード全体とオーバーヘッドを合わせたサイズになります。

#### STATIC_CHUNKS_ONLY

ユーザーは、小さな静的バッファを使用している場合（デフォルト）に16K出力オプションをオフにするオプションがあり、SSL_writeが持っているレコードよりも大きなデータを書き込もうとすると、ユーザーが静的バッファチャンクでのみ書き込むように指示しない限り、動的に取得します。

#### WOLFSSL_DEF_PSK_CIPHER

PSKコールバックが暗号スイートを指定しない場合に、外部PSKとともに使用されるTLS 1.3暗号スイートの2バイト目です（1バイト目は`TLS13_BYTE`）。
例えば、TLS 1.3版のコールバックではなく、`wolfSSL_CTX_set_psk_client_callback()`および`wolfSSL_CTX_set_psk_server_callback()`で設定したコールバックを使用する場合が該当します。
デフォルトは`TLS_AES_128_GCM_SHA256`です。
変更するには、コンパイル時にこのマクロを定義してください。

#### WOLFSSL_OLD_PRIME_CHECK

より高速なDHとRSAの素数チェックを使用する機能を有効にします。

#### WOLFSSL_OLD_SET_CURVES_LIST

古い形式で曲線を設定するアプリケーションとの後方互換性のために、旧方式の曲線リスト解析を使用します。

#### WOLFSSL_OLD_TIMINGPADVERIFY

CBC暗号スイートに対して、旧方式のタイミングベースのパディング検証を使用します。
新しい方式の方が、より定数時間に近い動作となります。

#### WOLFSSL_OLDTLS_AEAD_CIPHERSUITES

TLS 1.2より前のバージョンのTLSで、AEAD暗号スイート（GCM、CCM）を有効にします。
これらの暗号スイートは通常、TLS 1.2以降でのみ利用可能です。

#### WOLFSSL_OLDTLS_SHA2_CIPHERSUITES

TLS 1.2より前のバージョンのTLSで、SHA-2ベースの暗号スイートを有効にします。
これらの暗号スイートは通常、TLS 1.2以降でのみ利用可能です。

#### WOLFSSL_STATIC_RSA

静的な鍵を使用する暗号は強く非推奨とされており、避けられない場合以外は決して使用しないでください。
しかし、静的暗号スイートのみをサポートするレガシーシステムも依然として存在します。
そのため、静的RSA暗号スイートのみをサポートするレガシーなピアに接続する必要がある場合は、このマクロを使用してwolfSSLで静的RSAのサポートを有効にしてください。
（[`WOLFSSL_STATIC_PSK`](#wolfssl_static_psk)および[`WOLFSSL_STATIC_DH`](#wolfssl_static_dh)も参照してください。）

#### WOLFSSL_STRONGEST_HASH_SIG

TLSハンドシェイク中の署名処理において、利用可能な最も強力なハッシュアルゴリズムを優先します。

#### WOLFSSL_STATIC_PSK

静的PSK暗号スイートを有効にする機能です。
静的な鍵を使用する暗号は強く非推奨とされています。
[`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)を参照してください。

#### WOLFSSL_STATIC_DH

静的ECDH暗号スイートを有効にする機能です。
静的な鍵を使用する暗号は強く非推奨とされています。
[`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)を参照してください。

#### HAVE_NULL_CIPHER

NULL暗号のサポートをオンにします。
このオプションはセキュリティの観点から強く非推奨ですが、稀に暗号化/復号化操作を実行するには小さすぎるシステムがあります。
そのようなシステムでも、このマクロを有効化して少なくともメッセージやピアを認証し、メッセージの改ざんを防ぐことだけができます。

#### HAVE_ANON

匿名の暗号スイートのサポートをオンにします。
推奨されませんが、インターネットから切り離された、またはプライベートネットワークに関連するいくつかの有効なユースケースがあります。

#### HAVE_ATEXIT

プログラムの終了時に自動的にクリーンアップされるように、`wolfSSL_Cleanup()`を`atexit()`ハンドラーとして登録します。
`OPENSSL_EXTRA`と組み合わせた場合にのみ効果があります。

#### HAVE_LIBOQS

wolfSSL 5.9.4で削除されました。
liboqsはどのアルゴリズムにも使用されなくなりました。
ポスト量子アルゴリズム（ML-KEM、ML-DSA、SLH-DSA、Falcon、FrodoKEM、LMS、XMSS）はすべてwolfCryptにネイティブ実装されており、このマクロを定義しても効果はありません。
詳細については、本書の[付録I ポスト量子暗号の実験](appendix09.md)をご参照ください。

#### HAVE_LIGHTY

lighttpd WebサーバーとwolfSSLの互換性のために必要なAPIと動作を有効にします。

#### WOLFSSL_SP_4096

RSA/DH 4096ビット単精度(SP)サポートを有効にします。

#### WOLFSSL_SP_384

ECC SECP384R1単精度(SP)サポートを有効にします。
SP ECC実装（`--enable-sp`による`WOLFSSL_HAVE_SP_ECC`）が必要です。
configureはこのマクロとあわせて`HAVE_ECC384`も定義します。
[`WOLFSSL_SP_MATH`](#wolfssl_sp_math)を使用する場合は、settings.hが`HAVE_ECC384`を自動的に定義します。

#### WOLFSSL_SP_1024

SAKKEペアリングベース暗号の単精度(SP)サポートを有効にします。

#### ATOMIC_USER

アトミックレコードレイヤーコールバックを有効にします。

#### BIG_ENDIAN_ORDER

デフォルトはリトルエンディアンです。
このマクロを定義することで、ビッグエンディアン環境で動作できます。

#### WOLFSSL_32BIT_MILLI_TIME

関数`TimeNowInMilliseconds()`は符号なし32ビット値を返します。
デフォルトの動作は符号付き64ビット値を返すことです。

#### WOLFSSL_MAX_DHKEY_BITS

TLSで受け入れるDH鍵の最大ビットサイズです。
8の倍数で、16384以下、かつ[`WOLFSSL_MIN_DHKEY_BITS`](#wolfssl_min_dhkey_bits)以上である必要があります。
デフォルトは数学ライブラリによって異なり、SP mathでは`SP_INT_BITS`、fast mathでは（`FP_MAX_BITS`が16384以上の場合）`FP_MAX_BITS / 2`、それ以外の場合は4096です。

#### WOLFSSL_MIN_DHKEY_BITS

TLSで受け入れるDH鍵の最小ビットサイズです。
デフォルトは`DH_MIN_SIZE`（1024、FIPSビルドでは2048）です。
[`WOLFSSL_HARDEN_TLS`](#wolfssl_harden_tls)を112または128に設定した場合、デフォルトはそれぞれ2048または3072になります。
112ビットのセキュリティでは少なくとも2048ビットのDH鍵が必要なため、この場合2048未満の値は拒否されます。
8の倍数で、16000以下、かつ`DH_MIN_SIZE`以上である必要があります。

#### WOLFSSL_MAX_MTU

最大予想MTUです。
1500 - 100バイトで、UDPとIPヘッダーを考慮しています。

#### IGNORE_NETSCAPE_CERT_TYPE

Netscape Certificate Type証明書拡張のデコードをスキップします。

#### SESSION_CERTS

証明書用のTLSセッションキャッシュです。

#### WOLFSSL_DUAL_ALG_CERTS

X9.146のデュアル鍵/署名（ハイブリッド）証明書と、TLS 1.3でのその使用を有効にします。
`--enable-dual-alg-certs`によって設定され、`--enable-experimental`も必要です。

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
`./configure`によるビルドではデフォルトで有効です。
無効にするには`--disable-tls13`を使用します。

#### WOLFSSL_TLS13_IGNORE_AEAD_LIMITS

TLS 1.3およびDTLS 1.3におけるAEAD使用制限（RFC 9846 Section 5.5、RFC 9147 Section 4.5.3）の適用を無効にします。
デフォルトでは、1つの鍵で送信したレコード数がその暗号の制限に達すると、wolfSSLは鍵を更新します。
DTLS 1.3では、復号化に失敗したレコードもカウントします（制限は[RFC 9147 Section 4.5.3](https://tex2e.github.io/rfc-translater/html/rfc9147#4-5-3--AEAD-Limits)で規定されています）。
ハードな復号化失敗制限の中間地点で鍵更新を要求し、ハードな制限に達すると接続を失敗させます。

#### WOLFSSL_TLS13_DRAFT

ドラフト実装とのテストのために、TLS 1.3ドラフト仕様のパラメータを使用します。
本番環境では使用しないでください。

#### WOLFSSL_TLS13_MIDDLEBOX_COMPAT

TLS 1.3ハンドシェイクでミドルボックス互換性を有効にします。
これには、暗号化されたメッセージの前にChangeCipherSpecを送信することとセッションIDを含めることが含まれます。
wolfSSL 5.9.4以降、TLS 1.3サーバーは、空でないlegacy_session_idを含むClientHelloに対して、すべてのビルドでChangeCipherSpecレコードを返信します（RFC 8446 Appendix D.4）。
このマクロを定義すると、クライアント側でも同様に、セッションIDを設定し、自身のChangeCipherSpecを送信するようになります。

#### WOLFSSL_TLS13_NULL_CIPHER_IN_DEFAULT

TLS 1.3のNULL暗号スイート（`TLS_SHA256_SHA256`、`TLS_SHA384_SHA384`）をデフォルトの暗号スイートリストに戻します。
wolfSSL 5.9.4以降、これらの暗号スイートは`--enable-nullcipher`でコンパイルされますが、明示的に設定しない限り提示されません。

#### WOLFSSL_TLS13_TICKET_CHECK_PSK_MODES

RFC 9846で規定されたオプションのハードニングです。
定義すると、TLS 1.3サーバーは、ClientHelloにpsk_key_exchange_modes拡張を含めたクライアントに対してのみNewSessionTicketメッセージを送信します。

#### WOLFSSL_TLS13_SHA512

TLS 1.3のみのビルドで、SHA-512のトランスクリプトハッシュを保持します。
wolfSSL 5.9.4以降では、このマクロが定義されていない限り、そのようなビルドからTLS 1.2のトランスクリプト状態（ハンドシェイクハッシュは864バイトから352バイトになります）とSHA-512のトランスクリプトが削除されます。
[`--enable-tls13-sha512`](#--enable-tls13-sha512)またはCMakeオプション`WOLFSSL_TLS13_SHA512`で有効にします。
`WOLFSSL_SHA512`が必要です。
SHA-512を使用するTLS 1.3暗号スイートはないため、TLS 1.3ではHelloRetryRequestのクッキーHMACにのみ使用され、それもSHA-256とSHA-384が利用できない場合に限られます。

#### WOLFSSL_TLS_READ_AHEAD

TLS受信の先読み（read-ahead）を有効にします。
受信処理では、レコードヘッダーとレコード本体を1つずつ読み取る代わりに、`recv()`呼び出しのたびにバッファに収まるだけのバイトを読み込むため、1レコードあたりの`recv()`呼び出し回数が減ります。
[`--enable-readahead`](#--enable-readahead)で組み込み、実行時に`wolfSSL_set_read_ahead()`または`wolfSSL_CTX_set_read_ahead()`で有効にします。

#### WOLFSSL_BUILD_MSG_NO_ZERO_COPY

wolfSSL 5.9.4でレコード構築処理に追加された、AEADアプリケーションデータのゼロコピー暗号化を無効にします（ゼロコピー暗号化により、送信処理は約1%から3%高速になります）。
このマクロを定義すると、従来のコピーしてから暗号化する動作に戻ります。

#### WOLFSSL_X25519_NO_MASK_PEER

wolfSSL 5.9.4以降では、wolfCryptおよびTLS 1.2 / 1.3の鍵交換において、RFC 7748の要求に従い、ピアのX25519公開値の最上位ビットを拒否せずにマスクします。
このマクロを定義すると、従来どおり拒否する動作に戻ります。

#### WOLFSSL_TLS13_IGNORE_PT_ALERT_ON_ENC

TLS 1.3で暗号化されたレコードが期待される場面で受信した平文のアラートを無視します。
一部の実装との相互運用性が向上する場合があります。
この許容は、wolfSSLがピアからのレコードの復号化を開始した時点で始まり、ピアが最初の暗号化レコードを送信した時点とハンドシェイクが完了した時点のいずれか早い方で終了します。
その後は、平文のアラートは再び致命的なエラーとなります。
暗号化されたアラートは通常どおり処理され、無視された平文のアラートも`WOLFSSL_ALERT_COUNT_MAX`の制限に対してカウントされます。

#### WOLFSSL_TLS13_TICKET_BEFORE_FINISHED

サーバーがクライアントのFinishedメッセージを受信する前に、NewSessionTicketメッセージを送信できるようにします。
TLS 1.3仕様のSection 4.6.1、第4段落を参照してください。

#### WOLFSSL_EARLY_DATA

TLS 1.3の0-RTT（Zero Round Trip Time）早期データのサポートを有効にします。
クライアントがハンドシェイクの最初のフライトでアプリケーションデータを送信できるようになり、接続確立が高速化されます。
PSKまたはセッションチケットによるセッション再開が必要です。

#### WOLFSSL_EARLY_DATA_GROUP

送信時に、早期データメッセージをClientHelloとまとめます。
メッセージを結合することで、ネットワークのラウンドトリップ数を削減します。

#### WOLFSSL_CHECK_SIG_FAULTS

フォールトインジェクション攻撃を検出するため、署名後にECC署名を検証します。
ハードウェアへのフォールト攻撃が懸念される環境で有用です。

#### WOLFSSL_CIPHER_INTERNALNAME

API経由で暗号スイート情報を報告する際に、IANA標準名ではなくwolfSSL内部の暗号スイート名を使用します。

#### WOLFSSL_NO_CLIENT_CERT_ERROR

TLS 1.3のクライアント側の動作を変更します。
サーバーが証明書を要求し、クライアントが証明書を持っていない場合、`certificate_required`アラートと`NO_CERT_ERROR`でハンドシェイクを中止します（クライアントの証明書チェーンがサーバーの受け入れない署名アルゴリズムを使用している場合は`unsupported_certificate`アラートで中止します）。
デフォルトでは、クライアントは空のCertificateメッセージを送信します（RFC 8446 Section 4.4.2）。
サーバー側で証明書を必須にするには`WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT`を使用します。

#### WOLFSSL_NONBLOCK_OCSP

ノンブロッキングのOCSPステープリング処理を有効にします。
TLSハンドシェイク中に、OCSPの問い合わせを非同期に実行できるようになります。

#### WOLFSSL_TLS_OCSP_MULTI

TLSで複数のOCSPレスポンスのサポートを有効にし、エンドエンティティ証明書に加えて中間証明書のOCSPレスポンスもステープリングできるようにします。

#### WOLFSSL_CERT_SETUP_CB

`wolfSSL_CTX_set_cert_cb()`で設定する証明書セットアップコールバックを有効にし、ハンドシェイク中に証明書と鍵を動的に選択できるようにします。
サーバーは、ClientHelloの処理中（TLS 1.2およびTLS 1.3）、暗号スイートの照合前にこのコールバックを呼び出すため、ClientHelloの内容に基づいて選択できます。
クライアントは、CertificateRequestを受信したときにこのコールバックを呼び出します。
`wolfSSL_get_client_suites_sigalgs()`も追加されます。
`--enable-cert-setup-cb`によって設定されます。

#### WOLFSSL_RW_THREADED

読み取り/書き込みのスレッドサポートを有効にし、同一のSSLセッションに対して別々のスレッドが同時にTLSの読み取りと書き込みを実行できるようにします。

#### WOLFSSL_PRIORITIZE_PSK

TLS 1.3ハンドシェイク中に暗号スイートを選択する際、暗号スイートの順序ではなくPSKの順序を優先します。
PSKコールバックの順序によって優先度が決まります。

#### WOLFSSL_UIP

CONTIKIが定義されている場合、これはUIPの実装です。

#### TLS13_MAX_TICKET_AGE

最大チケット期間を指定します。
TLS 1.3の場合、これは7日間です。

#### TLS13_TICKET_NONCE_STATIC_SZ

TLS 1.3のチケットナンスを保持する静的バッファのサイズです（デフォルトは8、最大255）。
v5.3より古いFIPSビルドではサポートされていません。

#### TIME_OVERRIDES

システムの時刻関数を使用する代わりに、アプリケーションが独自の時刻関数（`XTIME`、`XGMTIME`など）を提供します。

#### TLS13_TICKET_NONCE_MAX_SZ

チケットナンス用のバージョン最大サイズを定義します。
最大サイズは255バイトとして定義されています。

#### WOLFSSL_TICKET_ENC_AES128_GCM

デフォルトコールバックでセッションチケットの暗号化/復号化にAES128-GCMを使用します。
これはサーバーのみで適用されます。
ChaCha20-Poly1305がコンパイルされていて、どちらのAES-GCMチケットマクロも定義されていない場合、デフォルトのチケット暗号はChaCha20-Poly1305です。
それ以外の場合は、`WOLFSSL_AES_256`が利用可能であればAES-256-GCMがデフォルトとなり、利用できない場合にのみAES-128-GCMがデフォルトとなります。

#### WOLFSSL_TICKET_ENC_AES256_GCM

デフォルトコールバックでセッションチケットの暗号化/復号化にAES256-GCMを使用します。
これはサーバーのみで適用されます。

#### WOLFSSL_TICKET_ENC_CHACHA20_POLY1305

デフォルトコールバックでセッションチケットの暗号化/復号化にChaCha20-Poly1305を使用します。
ChaCha20-Poly1305がコンパイルされていて、`WOLFSSL_TICKET_ENC_AES128_GCM`と`WOLFSSL_TICKET_ENC_AES256_GCM`のどちらも定義されていない場合も、これがデフォルトとなります。
これはサーバーのみで適用されます。

#### WOLFSSL_TICKET_ENC_CBC_HMAC

セッションチケットの暗号化に、AEAD暗号の代わりにCBC+HMACを使用します。
AEADをサポートしないビルド向けの代替手段となります。

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

#### SHOW_SIZES

初期化時に、wolfSSLの主要な構造体のサイズを表示します。
デバッグや、リソースの限られたシステムでのメモリ分析に役立ちます。

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

wolfSSLが受信を要求する（DTLS 1.2では送信もする）コネクションIDの最大サイズです。
デフォルトは10バイト、最大は255です。
[`WOLFSSL_DTLS_CID`](#wolfssl_dtls_cid)を使用するDTLS 1.2および1.3に適用されます。
DTLSのパーシングコードは、レコードを復号化するために静的バッファにレコードヘッダーをコピーします。
CID最大サイズを増やすと、このバッファも増加し、セッションごとの実行時メモリフットプリントに影響します。

#### DTLS13_EPOCH_SIZE

DTLS 1.3エポックを使用した、移植性を高めるためのマクロです。
DTLSエポックにバインドされた鍵を保存し、必要に応じて適切な鍵/エポックを設定する方法を実装します。

#### DTLS13_RETRANS_RN_SIZE

DTLS 1.3における移植性を高めるためのマクロです。
DTLS 1.3で再送信前のサイズを識別するために使用されます。

#### WOLFSSL_DTLS_FRAG_POOL_SZ

1つのDTLSハンドシェイクメッセージを再構築する間にバッファリングされる、個別のフラグメントバケットの最大数です。
デフォルトは10、最大は255です。

#### WOLFSSL_DTLS_MTU

DTLS通信中の最大データグラムサイズを制御するための、DTLS MTU（Maximum Transmission Unit）管理APIを有効にします。

#### WOLFSSL_COND

このシステムがCOND_TYPEシグナリングをサポートしている場合に定義されます。
シグナリングAPIに渡されるべきタイプです。

#### WOLFSSL_DTLS_CH_FRAG

サーバーがフラグメント化された2番目/検証済み（有効なクッキー応答を含む）ClientHelloメッセージを処理できるようにします。
1番目/未検証（クッキー拡張を含まない）ClientHelloはフラグメント化されていてはならず、DTLSサーバーがステートレスに処理できるようにする必要があります。
これはDTLS 1.3でのみ実装されています。
ユーザーは、実行時にこれを明示的に有効にするために、サーバーで`wolfSSL_dtls13_allow_ch_frag()`を呼び出す必要があります（ML-KEMビルドでのみデフォルトで有効です）。
**注意**：DTLS 1.3 + pqcを`WOLFSSL_DTLS_CH_FRAG`なしで使用すると、おそらく失敗します。
この場合、`--enable-dtls-frag-ch`を使用して有効にします（ML-KEMビルドでは自動的に有効になります）。
`wolfSSL_disable_cookie()`でクッキーを無効にした場合、DTLS 1.3サーバーがフラグメント化された1番目のClientHelloを処理できるのは、このマクロを有効にしてビルドし、かつ`wolfSSL_dtls13_allow_ch_frag()`が有効な場合のみです。
それ以外の場合、フラグメントは破棄されます。

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

#### WOLFSSL_MYSQL_COMPATIBLE

wolfSSLで、MySQLプロトコルとの互換性のための動作を有効にします。
MySQLのTLSプロバイダーとしてwolfSSLを使用する場合に必要です。

#### WOLFSSL_NAMES_STATIC

ルックアップテーブル内の名前文字列（例えば、暗号スイート名、証明書の名前コンポーネント名、Curve25519およびLMS/XMSSのパラメータ名）を、ポインタではなく固定サイズの配列に格納し、テーブルの再配置を不要にします。
これはPosition Independent Code（PIC）向けの機能です。
settings.hは、再配置テーブルを使用するLinuxカーネルモジュールビルド（`--enable-kernel-reloc-tables`による`WC_SYM_RELOC_TABLES`）およびIAR ROPIビルドで、このマクロを自動的に定義します。
静的なECC曲線テーブルには`WOLFSSL_ECC_CURVE_STATIC`を使用します。

#### WOLFSSL_SEND_HRR_COOKIE

TLS 1.3 / DTLS 1.3のHelloRetryRequestクッキー拡張のサーバー側（クッキーの送信、実行時に`wolfSSL_send_hrr_cookie()`で選択）を有効にします。
クライアント側（受信したクッキーのエコー）は、クライアントサポートを含むTLS 1.3ビルドに常に組み込まれます。
[`WOLFSSL_TLS13_COOKIE`](#wolfssl_tls13_cookie)を参照してください。
ステートレスなDTLS 1.3サーバー（`wolfDTLS_accept_stateless()`）に必要です。

wolfSSL 5.9.4では、DTLSのクッキーモードが、アプリケーションが設定する単一のポリシーになりました。
`wolfSSL_enable_cookie()`と`wolfSSL_disable_cookie()`は、DTLS 1.2、DTLS 1.3、TLS 1.3のサーバークッキーを切り替えます。
`wolfSSL_disable_hrr_cookie()`は単に`wolfSSL_disable_cookie()`を呼び出します。
ハンドシェイクがClientHelloの処理方法を決定した後は、これらの設定関数は`BAD_STATE_E`を返します。
クッキーシークレットの変更は、すべて成功するか何も変更されないかのいずれかであり、新しいシークレットが完全に構築されてから古いシークレットが解放されます。
検証専用のセカンダリクッキーシークレットにより、アプリケーションはシークレットをローテーションできます。

#### WOLFSSL_TLS13_COOKIE

TLS 1.3クッキー拡張のクライアント側のクッキーエコーを、サーバー側を含めずに有効にします。
wolfSSL 5.9.4で`WOLFSSL_SEND_HRR_COOKIE`から分離されました。
このマクロを定義する必要はありません。
`wolfssl/internal.h`は、クライアントサポートを含むすべてのTLS 1.3ビルド（RFC 8446 Section 9.2により、クッキーのサポートは必須です）と、`WOLFSSL_SEND_HRR_COOKIE`が定義されている場合に、このマクロを自動的に定義します。

#### WOLFSSL_SEP

機能証明書ポリシーセット拡張です。

#### WOLFSSL_SECURE_RENEGOTIATION_ON_BY_DEFAULT

明示的なAPI呼び出しを必要とせずに、新しく作成されるすべてのSSLコンテキストでセキュアな再ネゴシエーションをデフォルトで有効にします。

#### WOLFSSL_SESSION_ID_CTX

アプリケーションセッションコンテキストIDをコピーするために使用されます。

#### WOLFSSL_SESSION_TIMEOUT

秒単位のデフォルトセッション再開キャッシュタイムアウトは、タイムアウトを手動で定義するために使用されます。

#### WOLFSSL_SET_CIPHER_BYTES

名前文字列の代わりに、生の2バイト値で暗号スイートを設定できるようにします。
プログラムから暗号スイートを設定する場合に便利です。

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

内部用のマクロです。
AES、AES-GCM、ARIA、ChaCha20-Poly1305、またはTLS 1.3がビルドされる場合に、`wolfssl/internal.h`によって自動的に定義されます。
暗号の状態に、レコードごとのナンスバッファを追加します。
ユーザーが設定するオプションではありません。

#### CloseSocket

ソケットを閉じるために使用される関数をオーバーライドする方法です。
CRL、OCSP、BIOで使用されます。

#### CONFIG_POSIX_API

ネットワーキングシステムコール用のPOSIX名を有効にします。

#### WOLFSSL_USER_CURRTIME

マクロ`WOLFSSL_USER_CURRTIME`を使用して、gettimeofday関数なしで`test.h`で使用するオプションを追加します。

#### WOLFSSL_USER_MUTEX

`WOLFSSL_USER_MUTEX`によるユーザー定義ミューテックスのオプションです。

#### DEFAULT_MIN_ECCKEY_BITS

サンプルクライアントとサンプルサーバー（`wolfssl/test.h`）が使用する、デフォルトの最小ECC鍵サイズです（224ビット、`WOLFSSL_MAX_STRENGTH`の場合は256ビット）。
ライブラリの制限については、[`WOLFSSL_MIN_ECC_BITS`](#wolfssl_min_ecc_bits)を参照してください。

#### DEFAULT_MIN_RSAKEY_BITS

サンプルクライアントとサンプルサーバー（`wolfssl/test.h`）が使用する、デフォルトの最小RSA鍵サイズです（1024ビット、`WOLFSSL_MAX_STRENGTH`の場合は2048ビット）。
ライブラリの制限については、[`WOLFSSL_MIN_RSA_BITS`](#wolfssl_min_rsa_bits)を参照してください。

#### EXTERNAL_SERIAL_SIZE

バッファに符号なしバイナリでX509シリアル番号を書き込む生のシリアル番号バイトです。
すべての場合において、バッファは少なくとも`EXTERNAL_SERIAL_SIZE`（32）である必要があります。
成功した場合、`WOLFSSL_SUCCESS`を返します。
**注意**：これはユーザーが定義できない内部マクロです。

#### LARGE_STATIC_BUFFERS

各SSLオブジェクト内の静的な入力および出力レコードバッファを、レコードヘッダーのみを保持するデフォルトの静的バッファではなく、レコード全体を保持できる大きさにします（`RECORD_SIZE`が、`MAX_RECORD_SIZE`の16 KBにレコードヘッダーとオーバーヘッドを加えたサイズになります）。
[`WOLFSSL_CALLBACKS`](#wolfssl_callbacks)を定義すると、強制的に有効になります。

#### LIBWOLFSSL_VERSION_STRING

これはwolfSSLバージョン文字列であり、リリースバンドルまたは`./configure`が実行されたときに入力されます。
また、`LIBWOLFSSL_VERSION_HEX`にはこの32ビットHEXバージョンもあります。
これらは`wolfssl/version.h`から来ています。

#### WOLFSSL_HAVE_ERROR_QUEUE

内部マクロであり、`OPENSSL_EXTRA`（Windows以外のビルド）、`DEBUG_WOLFSSL_VERBOSE`、または`HAVE_MEMCACHED`が定義されている場合に、`wolfssl/wolfcrypt/logging.h`によって自動的に設定されます。
`wolfSSL_ERR_get_error()`および関連する関数で使用される、OpenSSL互換のエラーキューを有効にします。
直接定義しないでください。
`OPENSSL_EXTRA`ビルドでキューを無効にするには、`NO_ERROR_QUEUE`を定義してください。

#### WOLFSSL_HAVE_CERT_SERVICE

wolfSSL証明書サービス製品向けに、[`--enable-certservice`](#--enable-certservice)（`WOLFSSL_CERT_GEN`、ECC、`OPENSSL_EXTRA`も有効にします）によって設定されます。
このマクロはマーカー関数`wolfSSL_cert_service()`を追加するのみで、この関数は同製品のconfigureスクリプトによってチェックされます。
ハンドシェイクコールバックは追加しません。

### wolfSSLのカスタマイズ及び移植

#### WOLFSSL_USER_SETTINGS

定義されている場合、ユーザー固有の設定ファイルを使用できます。
ファイルには`user_settings.h`と名前が付けられ、インクルードパスに存在する必要があります。
これは、標準の`settings.h`ファイルの前に含まれるため、デフォルト設定をオーバーライドできます。

#### WOLFSSL_CALLBACKS

デバッガがない環境でシグナルを使用するデバッグ用のコールバックの利用を可能にする拡張機能です。
デフォルトではオフです。
ブロッキングソケットを使用してタイマーを設定するためにも使用できます。
詳しくは[第6章 コールバック](chapter06.md)をご覧ください。

#### WOLF_CRYPTO_CB

暗号コールバックサポートを有効にします。
この機能は、[`--enable-cryptocb`](#--enable-cryptocb)を使用すると自動的に有効になります。

#### WOLF_CRYPTO_CB_FIND

登録済みの暗号デバイスをデバイスIDで検索するための、デバイス検索コールバック関数を有効にします。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### WOLF_CRYPTO_CB_CMD

暗号コールバックデバイスの登録時および登録解除時に呼び出されるコマンドコールバック関数を有効にします。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### WOLF_CRYPTO_CB_COPY

アルゴリズム構造体のコピーコールバックを有効にし、暗号コールバックフレームワークを介してハッシュや暗号の状態をコピーできるようにします。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### WOLF_CRYPTO_CB_FREE

アルゴリズム構造体の解放コールバックを有効にし、暗号コールバックフレームワークを介して暗号オブジェクトのクリーンアップを行えるようにします。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### WOLF_CRYPTO_CB_AES_SETKEY

AES鍵設定処理に対する暗号コールバックサポートを有効にします。
鍵スケジューリングをハードウェアで処理できるようになります。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### WOLF_CRYPTO_CB_RSA_PAD

RSAパディング処理に対する暗号コールバックサポートを有効にし、ハードウェアや外部モジュールによる独自のパディング処理を可能にします。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)が必要です。

#### DEBUG_CRYPTOCB

暗号コールバック処理用のデバッグ用InfoString関数を有効にします。
どの暗号処理がハードウェアに回されているかをデバッグする際に役立ちます。

#### WC_USE_DEVID

ハードウェア固有のデバイス（CAAMなど）が検出されない場合に、暗号コールバックで使用するデフォルトのデバイスIDを指定します。

#### WC_NO_DEFAULT_DEVID

暗号コールバックフレームワークにおけるデフォルトデバイスIDの自動選択を無効にします。
定義した場合、アプリケーションはすべての暗号処理でデバイスIDを明示的に渡す必要があります。

#### WOLFSSL_CAAM_DEVID

NXP CAAMハードウェア暗号用のデバイスID定数（値は7）を定義します。
デフォルトデバイスIDの選択ロジックで使用されます。

#### NO_SHA2_CRYPTO_CB

SHA-384およびSHA-512処理に対する暗号コールバックサポートを無効にします。
定義した場合、これらのハッシュ処理には常にソフトウェア実装が使用されます。

#### WOLF_CRYPTO_CB_ONLY_RSA

RSA処理で暗号コールバックのみを使用するように制限し、ソフトウェアのRSA実装をすべて無効にします。
RSAを完全にハードウェアに委ねる場合に役立ちます。

#### WOLF_CRYPTO_CB_ONLY_ED25519, WOLF_CRYPTO_CB_ONLY_CURVE25519, WOLF_CRYPTO_CB_ONLY_CURVE448, WOLF_CRYPTO_CB_ONLY_SLHDSA

wolfSSL 5.9.4で追加された、Ed25519、Curve25519（`make_pub`と汎用スカラー乗算を含み、約6 KB削減）、Curve448、SLH-DSA（約16 KB削減）向けの暗号コールバック専用モードです。
各マクロはソフトウェア実装をコンパイル対象から除外するため、該当するアルゴリズムは登録済みの暗号コールバックデバイスで処理する必要があります。
[`--enable-cryptocb=only`](#--enable-cryptocb)を指定すると、すべての`WOLF_CRYPTO_CB_ONLY_*`フラグが一度に設定されます。

#### WOLF_CRYPTO_CB_ASYNC_POLL

TLSレコードの暗号処理を実行する暗号コールバックデバイスが、完了までポーリングするモデルを使用できるようにします。
コールバックはバルク暗号処理に対して`WC_PENDING_E`を返すことができ、TLS層は処理が完了するまでポーリングを続けます。
このマクロがない場合、保留中のバルク暗号処理は、破損したレコードを残す代わりに`ASYNC_OP_E`を返します。
バルク暗号の非同期サポートが必要です。

#### WOLF_CRYPTO_CB_KEYSTORE

ハードウェアキーストアに格納された鍵を扱うための暗号コールバックアルゴリズム種別`WC_ALGO_TYPE_KEYSTORE`を追加します。
公開APIは`wolfssl/wolfcrypt/wc_keystore.h`にあります。
操作は7種類あり、平文形式およびラップ形式でのインポートとエクスポート、導出、削除、情報取得です。
鍵はデバイスが定義する不透明な参照で指定されるため、デバイスはメモリ上に一切現れない鍵を作成、ラップ、導出、破棄できます。
`--enable-cryptocbutils=keystore`で有効にします。

#### WOLFSSL_ASYNC_CERT_YIELD

TLS証明書チェーンの処理をオプションで非同期化します。
[`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt)が必要です。
ピアのチェーン内の各証明書を検証するたびに呼び出しが`WC_PENDING_E`を返し、その合間に協調型スケジューラが他の処理を実行できるようにします。
これらのyieldは非同期デバイスイベントをキューに入れないため、`wolfSSL_connect()` / `wolfSSL_accept()`を再度呼び出す協調型スケジューラにのみ適しています。
fd/イベント駆動型の非同期処理で使用する場合は、このマクロを定義しないでください。
`README-async.md`をご参照ください。

#### WOLFSSL_DYN_CERT

`WOLFSSL_NO_MALLOC`が設定されていても、証明書を解析するときに `subjectCN` および `publicKey` フィールドの割り当てを許可します。
RSA証明書で`WOLFSSL_NO_MALLOC`オプションを使用する場合、ピアの証明書で証明書を検証するために、CAの公開鍵を保持する必要があります。
`ca->publicKey`がNULL であるため、これはConfirmSignatureエラー -173 BAD_FUNC_ARG として表示されます。

#### WOLFSSL_USER_IO

ユーザーがデフォルトのI/O関数[`EmbedSend()`](wolfio_8h.md#function-embedsend)および[`EmbedReceive()`](wolfio_8h.md#function-embedreceive)の自動設定を削除できます。
カスタムI/O抽象化レイヤに使用されます(詳細については[第5章](chapter05.md)「抽象化レイヤー」節を参照)。

#### NO_FILESYSTEM

stdio(標準入出力関数)が使用できないために、証明書とキーファイルをロードできない場合に使用されます。
これにより、ファイルの代わりにバッファを使用できます。

#### NO_INLINE

頻繁に使用されるライン数の少ない関数の自動インライン化を無効にします。
これを有効にするとwolfSSLは遅くなり、実際にはサイズも大きくなります。
これらは小さな関数であり、通常は関数呼び出しのセットアップ/リターンよりもはるかに小さいためです。
autoconfを使用していない場合は、コンパイル対象ファイルのリストに`wolfcrypt/src/misc.c`を追加する必要があります。

#### NO_DEV_RANDOM

デフォルトの`/dev/random`乱数ジェネレーターの使用を無効にします。
定義されている場合、ユーザーはOS固有の`wc_GenerateSeed()`関数を用意する(`wolfcrypt/src/random.c`を参照)か、[`CUSTOM_RAND_GENERATE_SEED`](#custom_rand_generate_seed) / [`CUSTOM_RAND_GENERATE_BLOCK`](#custom_rand_generate_block)を使用する必要があります。
[`WOLF_CRYPTO_CB`](#wolf_crypto_cb)を使用する場合は、シードを暗号コールバックデバイスから取得することもできます。

#### NO_MAIN_DRIVER

通常のビルド環境で、テストアプリケーションが単独で呼び出されるのか、テストスイートドライバーアプリケーションを介して呼び出されるのかを判断するために使用されます。
このマクロが必要になるのは、テストファイル(`test.c`、`client.c`、`server.c`、`echoclient.c`、`echoserver.c`、`testsuite.c`)を使用する場合のみです。

#### NO_WRITEV

`writev()`セマンティクスのシミュレーションを無効にします。

#### SINGLE_THREADED

ミューテックスの使用をオフにするスイッチです。
wolfSSLは、セッションキャッシュ、CA・CRL・OCSPの各テーブル、グローバルRNG、参照カウントなどにミューテックスを使用しています。
wolfSSLの使用が常に単一スレッドからに限定されている場合は、この機能をオンにすることができます。

#### WOLFSSL_CLEANUP_THREADSAFE_BY_ATOMIC_OPS

アトミック操作を使用して、ミューテックスを必要とせずに`wolfSSL_Cleanup()`をスレッドセーフにします。

#### USER_TICKS

time(0)を使用したくない場合に、ユーザーが独自のクロックティック関数を定義できるようにします。
カスタム関数には秒単位の正確さが必要ですが、エポックと相関がある必要はありません。
`src/internal.c`の`LowResTimer()`を参照してください。

#### USER_TIME

ユーザーが独自の構造体を使用したい(または使用する必要がある)場合に、time.h構造体の使用を無効にします。
`USER_TIME`を使用する場合、ユーザーが用意するのは`XTIME()`(エポックからの秒数)のみです。
wolfSSLは独自の`gmtime()`([`WOLFSSL_GMTIME`](#wolfssl_gmtime))と、独自の`time_t` / `struct tm`型(`HAVE_TIME_T_TYPE` / `HAVE_TM_TYPE`が定義されている場合を除く)を提供します。
`XGMTIME()`もオーバーライドするには、[`TIME_OVERRIDES`](#time_overrides)を使用してください。
`XVALIDATE_DATE()`は個別にオーバーライドできます。
`wolfssl/wolfcrypt/wc_port.h`を参照してください。

#### USE_CERT_BUFFERS_256

`<wolfssl_root>/wolfssl/certs_test.h`にある256ビットのテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_1024

`<wolfssl_root>/wolfssl/certs_test.h`にある1024ビットのテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_2048

`<wolfssl_root>/wolfssl/certs_test.h`にある2048ビットのテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_3072

`<wolfssl_root>/wolfssl/certs_test.h`にある3072ビットのテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_4096

`<wolfssl_root>/wolfssl/certs_test.h`にある4096ビットのテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_CERT_BUFFERS_25519

`<wolfssl_root>/wolfssl/certs_test.h`にあるEd25519のテスト用証明書と鍵バッファを有効にします。
ファイルシステムのないエンベデッドシステムに移植するときあるいはテストに役立ちます。

#### USE_WOLFSSL_IO

wolfSSLのデフォルトのソケットI/Oコールバック([`EmbedSend()`](wolfio_8h.md#function-embedsend)および[`EmbedReceive()`](wolfio_8h.md#function-embedreceive))をビルドします。
[`WOLFSSL_USER_IO`](#wolfssl_user_io)(または[`WOLFSSL_NO_SOCK`](#wolfssl_no_sock)、[`MICRIUM`](#micrium)、[`WOLFSSL_CONTIKI`](#wolfssl_contiki))が定義されていない限り、自動的に定義されます。
デフォルトのコールバックを独自のコールバックに置き換える例は[こちら](https://github.com/wolfSSL/wolfssl-examples/blob/master/tls/client-tls-callback.c#L6)で見ることができます。

#### CUSTOM_RAND_GENERATE_SEED

ユーザーが`wc_GenerateSeed(byte* output, word32 sz)`に相当するカスタム機能を定義できるようにします。

#### CUSTOM_RAND_GENERATE_BLOCK

ユーザーがカスタム乱数生成関数を定義できるようにします。
`random.c`はこの関数を直接呼び出すため、wolfSSLのコンパイル時にそのプロトタイプが参照可能であり、かつ関数がリンクされている必要があります。
使用例は以下の通りです。

configureを使用する場合は、プロトタイプをヘッダーに記述し、そのヘッダーを`-include`(GCCおよびClang)で`CFLAGS`に追加します。
スタティックライブラリの場合、この関数はアプリケーションをリンクするまで必要ありません。

```sh
./configure --disable-hashdrbg --enable-static --disable-shared \
    CFLAGS="-DCUSTOM_RAND_GENERATE_BLOCK=custom_rand_generate_block -include /path/to/custom_rand.h"
```

または、`user_settings.h`で次のように指定します。

```c
/* RNG */
/* #define HAVE_HASHDRBG */
#define CUSTOM_RAND_GENERATE_BLOCK custom_rand_generate_block
extern int custom_rand_generate_block(unsigned char* output, unsigned int sz);
```

#### WC_NO_RNG

すべてのRNG(乱数生成器)サポートを無効にします。
アプリケーションが独自に乱数データを用意する場合や、乱数が不要な場合(決定的な処理のみを行う場合など)に使用します。

#### HAVE_HASHDRBG

NIST SP 800-90Aに準拠した、ハッシュベースの決定論的乱数ビット生成器(DRBG)を有効にします。
これはwolfSSLのデフォルトのRNG実装であり、基盤となるハッシュとしてSHA-256を使用します。

#### WC_RNG_BLOCKING

RNG処理をブロッキングにし、一時的な失敗が発生した場合はエラーを返さずに再試行します。
エントロピーソースが一時的に利用できなくなる可能性があるプラットフォームで役立ちます。

#### WC_VERBOSE_RNG

RNG処理の詳細なデバッグ出力を有効にします。
シード生成、DRBGの状態、ヘルステストの結果に関する詳細な情報を出力します。

#### WC_X25519_NONBLOCK

ノンブロッキングのX25519鍵合意処理を有効にします。
X25519の計算を中断して再開できるようになり、協調型マルチタスク環境で役立ちます。

#### WC_RNG_SEED_CB

DRBG用のカスタムシードコールバック関数を有効にします。
アプリケーションが`wc_SetSeed_Cb()`を介して独自のエントロピーソースを提供できるようになります。

#### WC_RNG_SEED_DEVICE

通常のシードソースを試す前に、DRBGがシードを取得するデバイスノード(例えば`/dev/hwrng`)を指定します。
文字列として定義します(例：`-DWC_RNG_SEED_DEVICE='"/dev/hwrng"'`)。

#### HAVE_WC_RNG_BANK

RNGバンク機能(`rng_bank`)を有効にします。
この機能は乱数データを事前に生成しておき、以降の要求にはバッファから応答します。
このマクロは以前は`WC_RNG_BANK_SUPPORT`という名前でした。
wolfSSL 5.9.4で名前が変更され、機能もカーネルで用いられるSP 800-90のセマンティクスに対応しました。
具体的には、シードプール、次のシードの生成、RBG-C構成に加えて、ロックおよびデバッグ統計のオプションを備えています。

#### WC_RNG_WANT_BANKREF_SUPPORT

RNGバンクのバンク参照メカニズムを有効にします。
`HAVE_WC_RNG_BANK`が必要で、FIPSビルドでは有効になりません。

#### WC_RNG_NO_AUTO_LOCK

wolfSSL 5.9.4では、各`WC_RNG`が専用のロックを持つようになり、1つのRNGを複数のスレッドで共有できるようになりました。
このロックは、ビルドがサポートしている場合はデフォルトで有効です。
無効にするには、このマクロを定義するか、[`--disable-rng-autolock`](#--disable-rng-autolock)を指定します。
各`WOLFSSL`オブジェクトは独自のRNGを持つため、いずれの場合もTLSの性能は変わりません。

#### WC_RNG_AUTOFORK

wolfSSL 5.9.4では、wolfCryptがPOSIX準拠の`pthread_atfork()`ハンドラをインストールするようになり、fork後の子プロセスが親プロセスのDRBG状態を流用することなく、自身の`WC_RNG`を使い続けられるようになりました。
configureおよびCMakeは、これをサポートするプラットフォームでこのマクロを定義します(Appleプラットフォームでは使用しません)。
このハンドラには、インスタンスごとのRNGロックが必要です。
[`--disable-rng-autofork`](#--disable-rng-autofork)を指定すると、このマクロは定義されません。

#### WC_PUF_BCH_T

SRAM PUFの誤り訂正強度です。
BCH(127,k,t)プロファイルとして、t=7(k=78)、t=10(k=64、デフォルトであり、以前のリリースと互換)、t=13(k=50)、t=15(k=36)のいずれかを選択します。
tを大きくすると、127ビットのコードワードあたりで訂正できるビット反転の数が増えますが、その分エントロピーが減少します。
登録(エンロール)と再構成では同じ`WC_PUF_BCH_T`と`WC_PUF_NUM_CODEWORDS`を使用する必要があるため、`WC_PUF_PROFILE_ID`をヘルパーデータと一緒に保存してください。
wolfSSL 5.9.4で追加されました。

#### WC_PUF_NUM_CODEWORDS

SRAM PUFが使用するBCHコードワードの数です(デフォルトは16)。
コードワードを増やすと、必要な生のSRAMの量とヘルパーデータのサイズが大きくなる代わりに、導出される鍵のエントロピーの総量が増えます。
デフォルト値では、以前のリリースとバイト単位で同一の結果になります。

#### WC_PUF_HW_MIN_PCT and WC_PUF_HW_MAX_PCT

SRAM PUFの生の読み出しデータが収まる必要があるハミング重みの範囲を、パーセントで指定します(デフォルトは35%から65%)。
wolfSSL 5.9.4では、`wc_PufReadSram()`が読み出しデータのヘルステストを行うようになりました。
すべて0またはすべて1の128ビットブロック、直前のブロックと同じブロック、範囲外のハミング重みなどの縮退した読み出しデータは`PUF_READ_E`で拒否され、`wc_PufEnroll()`と`wc_PufReconstruct()`はそのデータを基に実行されません。
候補となる領域を確認するには`wc_PufCheckSram()`を使用し、使用するシリコンで必要な場合は範囲を広げてください。
5.9.2で登録されたヘルパーデータは引き続き有効です。

#### WOLFSSL_RNG_USE_FULL_SEED

非FIPSビルドのみが対象です。
`SEED_BLOCK_SZ`バイトを追加で収集してその先頭ブロックをシードのヘルステスト用に確保する代わりに、収集したシードバッファ全体をDRBGに渡します。
シードのサイズは固定ではなく、`RNG_SECURITY_STRENGTH * ENTROPY_SCALE_FACTOR / 8`バイトです(非FIPSビルドではデフォルトで256ビット)。

#### WOLFSSL_GENSEED_FORTEST

テスト用に決定論的なシードソースを使用します。
警告：予測可能な乱数が出力されるため、本番環境では決して使用しないでください。

#### WOLFSSL_KEEP_RNG_SEED_FD_OPEN

シード処理のたびに`/dev/random`または`/dev/urandom`のファイルディスクリプタを開閉するのではなく、シード処理の間も開いたままにします。
再シードが頻繁に行われるシステムでのオーバーヘッドを削減します。

#### CUSTOM_RAND_GENERATE

ユーザーがカスタムのランダムワード生成関数を定義できるようにします。
この関数は、ランダムな値を1ワード(`unsigned int`)返す必要があります。

#### CUSTOM_RAND_GENERATE_SEED_OS

ユーザーがOSレベルのカスタムシード生成関数を定義できるようにします。
デフォルトのプラットフォーム固有の`GenerateSeed()`を置き換えつつ、その上で引き続きwolfSSLのDRBGを使用します。

#### HAVE_ENTROPY_MEMUSE

メモリ使用に基づくエントロピーソースを有効にします。
このエントロピーソースは、メモリアクセスパターン(キャッシュヒット/ミス)のタイミングのばらつきを測定して、DRBGのシード用のエントロピーを生成します。

#### ENTROPY_MEMUSE_FORCE_FAILURE

メモリ使用エントロピーソースを強制的に失敗させます。
エントロピー収集コードのエラー処理パスのテストに使用されます。

#### HAVE_GETRANDOM

エントロピー収集にLinuxの`getrandom()`システムコールが利用可能であることを示します。
サポートされているプラットフォームでは自動的に検出されます。

#### WOLFSSL_GETRANDOM

Linuxシステムで、DRBGのシード用のエントロピーソースとして`getrandom()`システムコールを使用できるようにします。
十分なエントロピーが得られるまでブロックするため、`/dev/urandom`から読み取るよりも信頼性が高くなります。

#### FORCE_FAILURE_GETRANDOM

`getrandom()`システムコールを強制的に失敗させます。
フォールバック用のエントロピーソースのパスのテストに使用されます。

#### NO_DEV_URANDOM

乱数のシードに`/dev/urandom`を使用することを無効にします。
[`NO_DEV_RANDOM`](#no_dev_random)と併せて定義した場合は、代替のシードソースを用意する必要があります。

#### HAVE_AMD_RDSEED

ハードウェアから直接エントロピーを得るために、AMDのRDSEED命令を使用できるようにします。
[`HAVE_INTEL_RDSEED`](#have_intel_rdseed)と同様ですが、AMDプロセッサ向けです。

#### IDIRECT_DEV_RANDOM

iDirectプラットフォームで、`/dev/random`の代わりにプラットフォームの`getRandom()`関数からDRBGのシードを取得します。

#### WIN_REUSE_CRYPT_HANDLE

乱数生成の呼び出しのたびにWindowsの`CryptContext`ハンドルを取得、解放するのではなく、呼び出し間で再利用します。
Windowsでの性能が向上します。

#### WC_RNG_SEED_APT_CUTOFF

DRBGの適応比率テスト(APT: Adaptive Proportion Test)のカットオフ値を設定します。
APTは、ウィンドウ内で単一の値が過度に頻繁に出現していないかを確認することで、エントロピーソースの劣化を検出します。

#### WC_RNG_SEED_APT_WINDOW

DRBGの適応比率テスト(APT)のウィンドウサイズを設定します。
各テストウィンドウで調べるサンプル数を定義します。

#### WC_RNG_SEED_RCT_CUTOFF

DRBGの反復回数テスト(RCT: Repetition Count Test)のカットオフ値を設定します。
RCTは、同一の出力が連続していないかを確認することで、エントロピーソースの致命的な障害を検出します。

#### STM32_RNG

エントロピー収集用に、STM32のハードウェア乱数生成器(RNG)ペリフェラルを有効にします。

#### STM32_NUTTX_RNG

NuttX RTOSの`/dev/random`インターフェースを介したSTM32ハードウェアRNGへのアクセスを有効にします。

#### WOLFSSL_STM32F427_RNG

STM32F427マイクロコントローラ固有のハードウェアRNGサポートを有効にします。

#### WOLFSSL_STM32_RNG_NOLIB

STM32 HALライブラリを使用せずに、STM32 RNGペリフェラルのレジスタに直接アクセスできるようにします。
ベアメタル環境での利用に役立ちます。

#### WOLFSSL_PIC32MZ_RNG

エントロピー収集用に、Microchip PIC32MZのハードウェア乱数生成器を有効にします。

#### FREESCALE_RNGA

Freescale/NXPのRNGA(Random Number Generator Accelerator)ハードウェアペリフェラルを有効にします。

#### FREESCALE_K70_RNGA

Freescale/NXP Kinetis K70マイクロコントローラファミリー固有のRNGAサポートを有効にします。

#### FREESCALE_RNGB

Freescale/NXPのRNGB(Random Number Generator version B)ハードウェアペリフェラルを有効にします。

#### FREESCALE_KSDK_2_0_RNGA

KSDK 2.0 SDKのドライバーインターフェースを介して、Freescale/NXPのRNGAを有効にします。

#### FREESCALE_KSDK_2_0_TRNG

KSDK 2.0 SDKのドライバーインターフェースを介して、Freescale/NXPのTRNG(True Random Number Generator)を有効にします。

#### MAX3266X_RNG

Maxim MAX3266Xのハードウェア乱数生成器を有効にします。

#### QAT_ENABLE_RNG

Intel QuickAssist Technology(QAT)アクセラレータによるハードウェアRNGを有効にします。

#### WOLFSSL_ATECC_RNG

Microchip ATECC508A/ATECC608AセキュアエレメントによるハードウェアRNGを有効にします。

#### WOLFSSL_SILABS_TRNG

エントロピー収集用に、Silicon LabsのTRNG(True Random Number Generator)を有効にします。

#### WOLFSSL_SCE_NO_TRNG

Renesas Secure Crypto Engine(SCE)のTRNGを無効にします。
AESなどのSCE機能は引き続き利用できますが、RNGにはソフトウェア実装が使用されます。

#### WOLFSSL_SCE_TRNG_HANDLE

乱数生成に使用するRenesas SCE TRNGのハンドルを指定します。

#### WOLFSSL_SE050_NO_TRNG

NXP SE050セキュアエレメントのTRNGを無効にします。
SE050のその他の暗号処理は引き続き利用できます。

#### WOLFSSL_PSA_NO_RNG

Platform Security Architecture(PSA)暗号APIによるRNGを無効にします。
PSAは有効にしつつ、RNGには別のソースを使用したい場合に使用します。

#### HAVE_IOTSAFE_HWRNG

IoT-Safeに準拠したSIMカードまたはセキュアエレメントによるハードウェアRNGを有効にします。

#### WOLFSSL_XILINX_CRYPT_VERSAL

Xilinx Versalプラットフォームでの暗号ハードウェアサポートを有効にします。
エントロピー収集用のハードウェアTRNGもこれに含まれます。

#### NO_PUBLIC_GCM_SET_IV

独自のカスタムハードウェアポートを作成していて、`wc_AesGcmSetIV()`の公開実装が提供されていない場合は、これを使用してください。

#### NO_PUBLIC_CCM_SET_NONCE

独自のカスタムハードウェアポートを作成していて、`wc_AesCcmSetNonce()`の公開実装が提供されていない場合は、これを使用してください。

#### NO_GCM_ENCRYPT_EXTRA

独自のカスタムハードウェアポートを行っていて、`wc_AesGcmEncrypt_ex()`の実装が提供されていない場合は、これを使用してください。

#### WOLFSSL_STM32[F1 | F2 | F3 | F4 | F7 | L4 | L5 | WB | WBA | WL | G0 | G4 | H5 | H7 | H7S | U0 | U3 | U5 | MP13 | N6 | C5 | V8]

適切なSTM32デバイスファミリー(<https://www.st.com/>)用にビルドするときに、これらの定義のいずれかを使用します。
いずれの定義も、対応する[`NO_STM32_CRYPTO`](#no_stm32_crypto)、[`NO_STM32_HASH`](#no_stm32_hash)、`NO_STM32_HMAC`、[`NO_STM32_RNG`](#no_stm32_rng)が定義されていない限り、wolfSSLでSTM32のハードウェア暗号(`STM32_CRYPTO`)、ハッシュ(`STM32_HASH`、`STM32_HMAC`)、RNG(`STM32_RNG`)のサポートも有効にします。
必要に応じて、[wolfSSLポーティングガイド](https://www.wolfssl.com/documentation/manuals/jp/wolfssl-porting-guide/)を確認し`wolfssl-root/wolfssl/wolfcrypt/settings.h`の該当セクションを更新します。

#### WOLFSSL_STM32_CUBEMX

CubeMXツールを使用してハードウェア抽象化レイヤー(HAL)APIを生成する場合、この設定を使用してwolfSSLに適切なサポートを追加します。

#### WOLFSSL_MX2_CONF_INCLUDE

wolfSSL 5.9.4で追加された、STM32CubeMX2(MX2)のサポートです。
定義されている場合、wolfSSLはMX2が生成した設定ヘッダーを自動的に取り込みます。

#### WOLFSSL_STM32V8

STM32V8ファミリー(Cortex-M85、Armv8.1-M)のハードウェア暗号サポートを有効にします。
NUCLEO-V873XJで検証済みで、wolfSSL 5.9.4で追加されました。

#### WOLFSSL_CUBEMX_USE_LL

CubeMXツールを使用してAPIを生成する場合、HAL(ハードウェア抽象化層)または低層(LL)の2つのオプションがあります。
この定義を使用して、`wolfssl-root/wolfssl/wolfcrypt/settings.h`の`WOLFSSL_STM32`ファミリーのセクションでインクルードされるヘッダーを制御します。
現在は、STM32L4向けにLL RNGヘッダー(`stm32l4xx_ll_rng.h`)を選択する用途にのみ使用されます。

#### NO_STM32_CRYPTO

STM32のハードウェア暗号サポートを提供しない場合に定義します。

#### NO_STM32_HASH

STM32のハードウェアハッシュサポートを提供しない場合に定義します。

#### NO_STM32_RNG

STM32のハードウェアRNGサポートを提供しない場合に定義します。

#### XTIME_MS

TLS 1.3を使用する際に、ミリ秒単位の時刻を取得するための関数をマッピングするマクロです。
使用例は以下の通りです。

```c
extern time_t m2mb_xtime_ms(time_t * timer);
#define XTIME_MS(tl) m2mb_xtime_ms((tl))
```

#### WOLFSSL_CIPHER_TEXT_CHECK

TLS接続中のAES暗号化操作に対する可能なグリッチ攻撃をチェックするためにこれを定義します。

#### RTTHREAD

RT-THREADマクロは、rtthread IoTをwolfSSLにポーティングする際に使用されます。

#### INTIME_RTOS

INtime RTOS用のポート設定です。

#### WOLFSSL_SGX

SGXへのポーティング時に使用します。

#### WOLFSSL_HEAP_TEST

静的メモリのヒープヒントコード用の内部テストマクロです。
ヒープヒントに`(void*)WOLFSSL_HEAP_TEST`を指定すると、メモリ割り当てはネイティブの`malloc()`にフォールバックします。
本番環境での使用は想定していません。

#### WOLFSSL_NO_REALLOC

`realloc()`の使用を無効にします(`XREALLOC`は未定義になります)。
バッファのサイズを変更するコードでは、代わりに`XMALLOC()`、コピー、`XFREE()`を使用します。

### メモリまたはコードの使用量の削減

#### TFM_TIMING_RESISTANT

Fast Math（[`USE_FAST_MATH`](#use_fast_math)、`tfm.c`）の演算を定数時間で実行する（タイミング耐性を持たせる）ようにします。
`USE_FAST_MATH`を使用する場合は、このマクロの定義を強く推奨します。
また、大きなべき乗ウィンドウを使用しないことでスタック使用量も削減されるため、スタックサイズが小さいシステムでも役立ちます。

#### ECC_TIMING_RESISTANT

サイドチャネルと差分電力分析（DPA）攻撃を防ぐために`ecc.c`でコードを有効にするタイミング耐性機能として使用されます。

#### WOLFSSL_WIDE_BYTE

`CHAR_BIT`が8ではないターゲット（1バイトが16ビットであるTI C2000 C28x DSPファミリなど）をサポートします。
`<limits.h>`が利用可能な場合は、`CHAR_BIT`から自動的に検出されます。
wolfSSL 5.9.4で追加され、LAUNCHXL-F28P55Xで検証されています。

#### WOLFSSL_NO_CONST_CMP

wolfSSL 5.9.4で追加された、定数時間比較を行う公開ラッパー関数`wc_ConstantCompare()`を削除します。

#### WC_FIPS_AESGCM_ALLOW_SHORT_NONCES

wolfSSL 5.9.4以降、FIPSビルドでは、AES-GCM暗号化に12バイト未満のIVが渡されると`FIPS_BAD_VALUE_E`を返します。
短いノンスを許可するには、このマクロを定義してください。

#### WOLFSSL_NO_SIGNER_DER_CERT

`OPENSSL_ALL`を使用する場合、`X509_STORE_get0_objects()`が追加済みの証明書を返せるように、`WOLFSSL_SIGNER_DER_CERT`が定義されるようになりました。
各署名者のDERコピーを保持したくない場合は、このマクロを定義してください。

#### WOLFSSL_SMALL_STACK

スタックサイズが小さいデバイスに使用できます。
wolfSSLおよびwolfCrypt全体（数学演算、暗号、ASN、TLS）の大きなローカル変数をスタックからヒープに移動します。
その分、パフォーマンスは多少低下します。

#### WOLFSSL_PTHREADS

pthreadベースのミューテックスおよびスレッド実装を使用します。
ほとんどのPOSIXシステムでは自動検出されます。

#### WOLFSSL_MUTEX_INITIALIZER

動的な`pthread_mutex_init`の代わりに、静的なミューテックス初期化（`PTHREAD_MUTEX_INITIALIZER`など）を使用します。
初期化のオーバーヘッドを削減するのに役立ちます。

#### WC_MUTEX_OPS_INLINE

関数呼び出しの代わりに、インライン化されたミューテックス操作を使用します。
ミューテックス操作が頻繁に行われるプラットフォームでは、パフォーマンスが向上する可能性があります。

#### WOLFSSL_USE_RWLOCK

リーダー/ライターロックのサポートを有効にし、読み取りが多いワークロードでの並行性を向上させます。

#### WOLFSSL_THREAD_NO_JOIN

join機能を持たないスレッド（デタッチされたスレッド）を作成します。
スレッドのjoinをサポートしていないプラットフォームで役立ちます。


#### WOLFSSL_THREADED_CRYPT

`wolfSSL_AsyncEncrypt()`、`wolfSSL_AsyncEncryptReady()`、`wolfSSL_AsyncEncryptStop()`、`wolfSSL_AsyncEncryptSetSignal()`を使用して、接続のTLSレコード暗号化（AES-GCMのみ）をアプリケーション独自のワーカースレッドで実行できるようにします。
pthreadsを使用します。
`WOLFSSL_THREADED_CRYPT_CNT`（デフォルトは16）で暗号化スロットの数を設定します。
復号は対象外です。

#### WOLFSSL_ALGO_HW_MUTEX

AES、ハッシュ、公開鍵、乱数生成の各操作に対して、アルゴリズムごとのハードウェアミューテックスロックを有効にします。
ハードウェア暗号エンジンへのアクセスを直列化する必要がある場合に役立ちます。

#### WOLFSSL_CRYPT_HW_MUTEX

ハードウェア暗号ミューテックスの初期化を制御するマスタースイッチです。
有効にすると、`wolfSSL_CryptHwMutexInit`、`wolfSSL_CryptHwMutexLock`、`wolfSSL_CryptHwMutexUnLock`の各関数が提供されます。

#### USE_WOLFSSL_MEMORY

カスタムメモリ割り当てフック（`wolfSSL_SetAllocators`）を有効にします。
デフォルトで有効です。
malloc/realloc/freeを独自の実装に置き換えることができます。

#### WOLFSSL_TRACK_MEMORY

メモリ割り当ての追跡と統計を有効にします。
wolfSSL/wolfCryptのメモリ使用量をプロファイリングするのに役立ちます。

#### WOLFSSL_TRACK_MEMORY_VERBOSE

割り当てごとの詳細を含む、詳細なメモリ追跡出力を有効にします。
[`WOLFSSL_TRACK_MEMORY`](#wolfssl_track_memory)を拡張するものです。

#### WOLFSSL_MEM_FAIL_COUNT

テスト用にmallocの失敗をカウントします。
指定した回数の割り当て後に失敗させることで、エラー処理パスをテストできます。

#### WOLFSSL_CHECK_MEM_ZERO

機密性の高いメモリ（鍵マテリアルなど）が解放時に適切にゼロクリアされていることを検証します。
鍵マテリアルが漏洩する可能性を検出するためのデバッグツールです。

#### WOLFSSL_GMTIME

標準Cライブラリの時刻関数を持たないプラットフォーム向けに、独自のgmtime実装を提供します。

#### STRING_USER

すべての文字列関数の実装をユーザーが提供します。
組み込みの文字列関数ラッパーを無効にします。

#### USE_WOLF_STRTOK

strtok_rを持たないプラットフォームでの移植性のために、wolfSSL組み込みのstrtok実装を使用します。

#### USE_WOLF_STRSEP

移植性のために、wolfSSL組み込みのstrsep実装を使用します。

#### USE_WOLF_STRLCPY

BSDのstrlcpyを持たないプラットフォームでの移植性のために、wolfSSL組み込みのstrlcpy実装を使用します。

#### USE_WOLF_STRLCAT

移植性のために、wolfSSL組み込みのstrlcat実装を使用します。

#### USE_WOLF_STRCASECMP

移植性のために、wolfSSL組み込みの、大文字と小文字を区別しない文字列比較を使用します。

#### USE_WOLF_STRNCASECMP

移植性のために、wolfSSL組み込みの、長さを制限し大文字と小文字を区別しない文字列比較を使用します。

#### USE_WOLF_STRDUP

移植性のために、wolfSSL組み込みのstrdup実装を使用します。

#### WOLFSSL_ATOMIC_OPS

アトミック操作を有効にし、完全なミューテックスを必要とせずに、スレッドセーフな参照カウントなどの操作を行えるようにします。


#### WOLFSSL_ATOMIC_INITIALIZER

スレッドセーフなクリーンアップ処理で使用されるアトミック変数の静的初期化子を提供します。

#### WOLFSSL_USER_DEFINED_ATOMICS

ユーザーが提供するアトミック操作の実装を使用します。
プラットフォームが独自のアトミックプリミティブを必要とする場合に定義してください。

#### WOLFSSL_LEANPSK

最小限の機能で構成されたLean PSK（事前共有鍵）ビルドです。
必須ではない機能を無効にすることで、コードサイズを削減します。

#### WOLF_C89

C89互換モードを有効にします。
厳密なC89/ANSI Cコンパイラでコードベースをコンパイルできるようにします。

#### ALT_ECC_SIZE

Fast MathとRSA/DHを使用する場合は、ECCメモリ消費量を削減するためにこれを定義できます。
ECCポイントにスタックを使用する代わりに、ヒープから割り当てます。

#### ECC_SHAMIR

ECC Mathのバリエーションは、わずかに高速ですが、ヒープの使用量を2倍にします。
configureではデフォルトで有効です（[`--enable-eccshamir`](#--disable-eccshamir)）。
メモリを削減するには、`--disable-eccshamir`で無効にするか、`user_settings.h`でこのマクロを定義しないでください。

#### RSA_LOW_MEM

定義された場合、CRTは使用されないため、一部のメモリを節約できますが、RSA操作が遅くなります。
デフォルトではオフになっています。

#### WOLFSSL_SHA3_SMALL

SHA3が有効な場合、このマクロはビルドサイズを縮小します。


#### WOLFSSL_SHUTDOWNONCE

`wolfSSL_shutdown()`が複数回呼び出された場合でも、`close_notify`アラートが1回だけ送信されるようにします。
シャットダウンメッセージの重複送信を防ぎます。

#### WOLFSSL_SHAKE128

SHA-3をベースとした拡張可能出力関数（XOF）であるSHAKE128を有効にします。
可変長の出力を提供します。

#### WOLFSSL_SHAKE256

SHA-3をベースとした拡張可能出力関数（XOF）であるSHAKE256を有効にします。
可変長の出力を提供します。

#### SHA3_BY_SPEC

KeccakのChiステップについて、FIPS 202に記載されているとおりの形式（`a ^ (~b & c)`）を使用します。
デフォルトでは、wolfSSLは代数的に等価な書き換え形式を使用します。

#### WC_SHA3_NO_ASM

アセンブリで最適化されたSHA-3実装を無効にします。
移植性のあるC実装を強制的に使用します。

#### WC_SHA3_FAULT_HARDEN

冗長な計算を実行して一貫性を検証することにより、SHA-3をフォールトインジェクション攻撃に対して強化します。

#### WC_ASYNC_ENABLE_SHA3

wolfSSLの非同期暗号フレームワークを介した、非同期SHA-3操作を有効にします。

#### STM32_HASH_SHA3

STM32のハードウェアによるSHA-3アクセラレーションを有効にします。

#### PSOC6_HASH_SHA3

Cypress/Infineon PSoC6のハードウェアによるSHA-3アクセラレーションを有効にします。

#### WOLFSSL_SMALL_CERT_VERIFY

DecodedCertを使用せずに証明書署名を確認します。
一部のコードでは2倍になりますが、ピークヒープメモリの使用が小さくなります。
[`WOLFSSL_NONBLOCK_OCSP`](#wolfssl_nonblock_ocsp)では使用できません。
`--enable-lowresource`、`--enable-leantls`、および`--enable-tinytls13`の`cert`/`mutualauth`項目によって選択されます。
wolfSSL 5.9.4では、後続の解析エラーよりも先に署名の検証失敗を報告します（CVE-2026-94418）。

#### WOLFSSL_X509_TINY

最小限の拡張のみを扱うX.509パーサープロファイルです。
パーサーは、証明書チェーンの検証に必要な拡張のみを参照します。
`WOLFSSL_X509_TINY_SAN_EMAIL`、`WOLFSSL_X509_TINY_SAN_IP`、`WOLFSSL_X509_TINY_NAME_CONSTRAINTS`（チェック対象となるSAN形式も強制的に有効にします）などの機能ごとのマクロを使用すると、個々の機能を再度有効にできます。
証明書パーサーのサイズを約6%から18%削減します。
[`WOLFSSL_ASN_TEMPLATE`](#wolfssl_asn_template)が必要です。

#### WOLFSSL_X509_VERIFY_ONLY

X.509の検証専用プロファイルです。
証明書と鍵の生成（`WOLFSSL_X509_CERT_GEN`/`WOLFSSL_X509_KEY_GEN`も定義されている場合を除く）と、PEMの解析（PEM形式のトラストアンカーを残すには`WOLFSSL_X509_PEM`を定義します）を除外します。

#### WOLFSSL_NO_ASN_STRICT

証明書パーサーにおけるRFC 5280への厳密な準拠を緩和します。
wolfSSL 5.9.4では、このマクロが定義されていない限り、DER構造の後に余分なバイトが続く証明書を拒否します。
また、`WOLFSSL_X509`には証明書本体のみがコピーされます。
このマクロを定義した場合でも、未知のクリティカル拡張、重複した拡張、およびSANに対するdirectoryName制約のチェックは引き続き適用されます。
`--enable-wolfclu`は、FIPSビルドではこのマクロを定義しなくなりました。

#### GCM_SMALL

テーブルを使用する代わりに実行時に計算することで、AES GCMコードサイズを減らすオプションです。
可能なオプションは、`GCM_SMALL`、`GCM_WORD32`、`GCM_TABLE`、`GCM_TABLE_4BIT`です。

#### CURVED25519_SMALL

[`CURVE25519_SMALL`](#curve25519_small)および[`ED25519_SMALL`](#ed25519_small)を定義します。

#### CURVE25519_SMALL

CURVE25519のスモールメモリオプションです。
これはより少ないメモリを使用しますが、遅いです。

#### ED25519_SMALL

ED25519のスモールメモリオプションです。
これはより少ないメモリを使用しますが、遅いです。

#### USE_SLOW_SHA

ループを展開しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。

#### WC_HASH_DATA_ALIGNMENT

ハッシュ入力に必要なデータアライメントを指定します。
一部のハードウェアバックエンドでは、アライメントされた入力バッファが必要です。

#### WC_ASYNC_ENABLE_SHA

wolfSSLの非同期暗号フレームワークを介した、非同期SHA-1操作を有効にします。

#### WOLFSSL_PIC32MZ_HASH

SHA-1およびSHA-256について、Microchip PIC32MZのハードウェアによるハッシュアクセラレーションを有効にします。

#### WOLFSSL_TI_HASH

Texas Instrumentsのハードウェアによるハッシュアクセラレーションを有効にします。

#### WOLFSSL_RENESAS_RX64_HASH

Renesas RX64のハードウェアによるハッシュアクセラレーションを有効にします。

#### FREESCALE_LTC_SHA

Freescale/NXP LTC（Low Power Trusted Cryptography）によるSHAアクセラレーションを有効にします。

#### FREESCALE_MMCAU_SHA

Freescale/NXP MMCAU（Memory-Mapped Cryptographic Acceleration Unit）によるSHAアクセラレーションを有効にします。

#### PSOC6_HASH_SHA1

Cypress/Infineon PSoC6のハードウェアによるSHA-1アクセラレーションを有効にします。

#### USE_SLOW_SHA256

ループを展開しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。
約2k小さくできますが、約25%遅くなります。

#### USE_SLOW_SHA512

ループを展開しないことでコードサイズを縮小します。
これにより、SHAのパフォーマンスが低下します。
2倍以上小さくできますが、50%遅くなります。

#### WOLFSSL_NOSHA512_224

SHA-512/224バリアントを無効にします。
SHA-512/224が不要な場合にコードサイズを削減します。

#### WOLFSSL_NOSHA512_256

SHA-512/256バリアントを無効にします。
SHA-512/256が不要な場合にコードサイズを削減します。

#### USE_SLOW_SHA2

[`USE_SLOW_SHA512`](#use_slow_sha512)の非推奨のエイリアスで、SHA-512とSHA-384にのみ影響します。
SHA-256とSHA-224には[`USE_SLOW_SHA256`](#use_slow_sha256)を使用してください。

#### WOLFSSL_HASH_FLAGS

ハッシュの状態（ハッシュがファイナライズ済みかどうかなど）を追跡するためのハッシュフラグを有効にします。
一部のハードウェアバックエンドで使用されます。

#### WOLFSSL_HASH_KEEP

再利用に備えて、ハッシュの入力データをメモリ上に保持します。
データを再投入することなく、再度ハッシュを計算できます。

#### WC_ASYNC_ENABLE_SHA512

wolfSSLの非同期暗号フレームワークを介した、非同期SHA-512操作を有効にします。

#### WC_ASYNC_ENABLE_SHA384

wolfSSLの非同期暗号フレームワークを介した、非同期SHA-384操作を有効にします。

#### WOLFSSL_KCAPI_HASH

Linuxカーネルの暗号API（AF_ALG）を介したハッシュ操作を有効にします。
SHAなどのハッシュ処理をカーネルにオフロードします。

#### WOLFSSL_SE050_HASH

NXP SE050セキュアエレメントでのハッシュアクセラレーションを有効にします。

#### WOLFSSL_SILABS_SHA384

SHA-384について、Silicon Labsのハードウェアアクセラレーションを有効にします。

#### WOLFSSL_SILABS_SHA512

SHA-512について、Silicon Labsのハードウェアアクセラレーションを有効にします。

#### WOLFSSL_ARMASM_CRYPTO_SHA512

SHA-512を高速化するために、ARMの暗号拡張命令を有効にします。

#### WOLFSSL_RENESAS_RSIP

ハッシュおよび暗号操作について、Renesas RSIP（Renesas Security IP）のハードウェアアクセラレーションを有効にします。

#### ECC_USER_CURVES

ユーザーが有効になっているECCカーブサイズを選択できるようにします。
デフォルトでは256ビットカーブのみが有効になっています。
他の曲線を使用できるようにするには、`HAVE_ECC192`、`HAVE_ECC224`などを使用します。

#### WOLFSSL_SP_NO_MALLOC

SPコードでは常にスタックを使用し、ヒープの`XMALLOC()`/`XREALLOC()`/`XFREE()`呼び出しは行われません。

#### WOLFSSL_SP_NO_DYN_STACK

動的スタックアイテムの使用を無効にします。
小さなスタックではなく、小さなコードサイズを優先する場合に使用されます。

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

#### OPENSSL_EXTRA_NO_ASN1

OpenSSL追加互換APIを有効にしますが、ASN1オブジェクト関数は除外します。
ASN1の互換性が不要な場合に、コードサイズを削減するのに役立ちます。

### パフォーマンスを向上させる

#### USE_INTEL_SPEEDUP

AES、ChaCha20、Poly1305、SHA256、SHA512、SHA-3/SHAKE、Ed25519、Curve25519、ML-KEM、ML-DSA、SLH-DSA、LMS、XMSS、およびFrodoKEMの加速にIntelのAVX/AVX2命令を使用できます。

#### WOLFSSL_AESNI

一部のIntelおよびAMDチップセットに組み込まれているAESアクセラレーション操作を使用できます。
この定義を使用する場合、`aes_asm.S`（GCC/Clang、AT&T構文）または`aes_asm.asm`（MASM、Intel構文、Windows用）ファイルが、Intel AESの新しい命令セット（AESNI）を介して最適化するために使用されます。
AES-GCM、AES-XTS、およびAVXのコードパスでは、`aes_gcm_asm`、`aes_xts_asm`、`aes_x86_64_asm`（`.S`または`.asm`）も必要です。

#### WOLFSSL_AESNI_BY4

4ブロック並列のAES-NI処理を有効にします。
AES-NIのパイプライン処理を利用して4つのAESブロックを同時に処理し、スループットを向上させます。
[`WOLFSSL_AESNI`](#wolfssl_aesni)が必要です。

#### WOLFSSL_AESNI_BY6

6ブロック並列のAES-NI処理を有効にします。
AES-NIのパイプライン処理を利用して6つのAESブロックを同時に処理し、スループットを最大化します。
[`WOLFSSL_AESNI`](#wolfssl_aesni)が必要です。

#### WOLFSSL_AES_SMALL_TABLES

より小さなAES S-boxルックアップテーブルを使用します。
AES操作がわずかに遅くなる代わりに、コード/データサイズを削減します。
メモリに制約のある組み込みターゲットで役立ちます。

#### WOLFSSL_AES_NO_UNROLL

AESラウンド関数のループ展開を無効にします。
パフォーマンスを犠牲にしてコードサイズを削減します。
速度よりもコードサイズが重要な、制約のある環境で役立ちます。

#### WOLFSSL_AES_TOUCH_LINES

サイドチャネル耐性を持たせるため、テーブル参照の前にAESテーブルのすべてのキャッシュラインにアクセスします。
使用前にすべてのテーブルエントリがキャッシュ上にあるようにすることで、キャッシュタイミング攻撃を緩和します。

#### WC_AES_BITSLICED

ビットスライスAES実装を有効にします。
複数のブロックを同時に処理するビット単位の並列化手法を使用し、定数時間で実行されるためサイドチャネル耐性があります。

#### AES_GCM_GMULT_NCT

定数時間ではないGCM GMULT実装を有効にします。
高速ですが、キャッシュタイミングによるサイドチャネル攻撃から保護されません。
サイドチャネル耐性が不要な場合にのみ使用してください。

#### NO_WOLFSSL_ALLOC_ALIGN

デフォルトでは、AES-NI、AF_ALG、またはXilinx AESにアライメントされていない入力バッファまたは出力バッファが渡されると、wolfSSLはアライメントされた一時的なコピーを割り当てます。
このマクロを定義するとその割り当てを行わなくなり、アライメントされていないバッファに対しては`BAD_ALIGN_E`を返します。

#### WC_ASYNC_ENABLE_AES

非同期AES操作を有効にします。
wolfSSLの非同期暗号フレームワークを使用して、AESの暗号化/復号をハードウェアアクセラレータにオフロードできます。

#### WOLFSSL_DEVCRYPTO

`wolfcrypt/src/port/devcrypto/`にあるLinux `/dev/crypto`（cryptodev-linux）インターフェースを有効にします。
オフロードするアルゴリズムは、`WOLFSSL_DEVCRYPTO_AES`、`WOLFSSL_DEVCRYPTO_CBC`、`WOLFSSL_DEVCRYPTO_HASH`および関連するマクロで選択します。
[`--enable-devcrypto`](#--enable-devcrypto)によって設定され、このオプションには`all`、`aes`、`cbc`、`hash`のいずれかを指定します。

#### WOLFSSL_DEVCRYPTO_AES

Linux `/dev/crypto`インターフェースを介したAESアクセラレーションを有効にします。
[`WOLFSSL_DEVCRYPTO`](#wolfssl_devcrypto)が必要です。

#### WOLFSSL_DEVCRYPTO_CBC

Linux `/dev/crypto`インターフェースを介したAES-CBCアクセラレーションを有効にします。
[`WOLFSSL_DEVCRYPTO`](#wolfssl_devcrypto)が必要です。

#### WOLFSSL_KCAPI_AES

Linuxカーネルの暗号API（AF_ALG）を介したAES操作を有効にします。
AESをカーネルの暗号サブシステムにオフロードします。

#### WOLFSSL_NO_KCAPI_AES_CBC

[`WOLFSSL_KCAPI_AES`](#wolfssl_kcapi_aes)が有効な場合に、KCAPIを介したAES-CBCを無効にします。
カーネルの暗号APIを介して、CBC以外のAESモードのみが必要な場合に役立ちます。

#### WOLFSSL_PSA_NO_AES

Platform Security Architecture（PSA）暗号APIを介したAESを無効にします。
PSAは有効にしつつ、AESにはソフトウェア実装を使用したい場合に使用します。

#### WOLFSSL_SCE_NO_AES

Renesas Secure Crypto Engine（SCE）を介したAESを無効にします。
SCEは有効にしつつ、AESにはソフトウェア実装を使用したい場合に使用します。

#### NO_IMX6_CAAM_AES

NXP i.MX6 CAAM（Cryptographic Acceleration and Assurance Module）でのAESアクセラレーションを無効にします。
CAAMは有効にしつつ、AESにはソフトウェア実装を使用したい場合に使用します。

#### WOLFSSL_AFALG_XILINX_AES

XilinxプラットフォームでAF_ALGを介したAESアクセラレーションを有効にします。
Linux AF_ALGインターフェースを介してXilinxの暗号ハードウェアを使用します。

#### NO_WOLFSSL_ESP32_CRYPT_AES

ESP32のハードウェアによるAESアクセラレーションを無効にします。
ESP32向けにビルドする際に、AESにはソフトウェア実装を使用したい場合に使用します。

#### STM32_CRYPTO_AES_ONLY

STM32のハードウェア暗号をAES操作のみに制限します。
STM32の暗号ハードウェアが利用可能な場合でも、その他のアルゴリズムはソフトウェア実装を使用します。

#### WC_DEBUG_CIPHER_LIFECYCLE

AESコンテキストにライフサイクルタグを追加して使用時にチェックし、初期化前の使用や解放後の使用を検出します（`BAD_STATE_E`を返し、オプションでアボートさせることもできます）。
FIPSビルドでは、FIPS v6以降が必要です。

#### WOLFSSL_HW_METRICS

Espressif ESP32専用です。
SHA、AES、RSA演算について、ハードウェアでの操作回数とソフトウェアへのフォールバック回数をカウントします。
カウンターは`esp_hw_show_metrics()`で出力できます。

#### HAVE_INTEL_RDSEED

DRBGシードソース用のIntelのRDSEEDを有効にします。

#### HAVE_INTEL_RDRAND

wolfSSLのランダムソースのIntelのRDRAND命令を有効にします。

#### FP_ECC

ECC固定点キャッシュを有効にします。
これにより、同じ秘密鍵に対する繰り返し操作が高速化されます。
`FP_ENTRIES`および`FP_LUT`を使用してエントリとLUTビットの数を定義して、デフォルトの静的メモリ使用量を削減することもできます。

#### FP_ENTRIES

ECC固定点乗算のルックアップテーブルのキャッシュエントリ数（デフォルトは15）を定義します。
[`FP_ECC`](#fp_ecc)が必要です。
メモリ使用量とパフォーマンスのバランスを取るように調整してください。

#### FP_LUT

ECC固定点の事前計算に使用するルックアップテーブルのビットサイズ（2-12、デフォルトは8）を設定します。
値を大きくするとメモリ使用量は増えますが、検証が高速になります。
[`FP_ECC`](#fp_ecc)が必要です。

#### FP_ECC_CONTROL

デフォルトでは定義されていません。
定義すると、SP数学ライブラリ（[`WOLFSSL_HAVE_SP_ECC`](#wolfssl_have_sp_ecc)および[`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2)）を使用したSM2署名検証で、キャッシュを利用した固定点の処理パス（`sp_ecc_cache_verify_sm2_256()`）が使用されます。

#### HAVE_ECC_CHECK_PUBKEY_ORDER

無効な鍵を検出するため、インポート時のECC公開鍵の位数検証を有効にします。
[`NO_ECC_CHECK_PUBKEY_ORDER`](#no_ecc_check_pubkey_order)が定義されている場合、またはハードウェアアクセラレータを使用している場合を除き、自動的に有効になります。

#### HAVE_ECC_MAKE_PUB

秘密鍵から公開鍵を計算する`wc_ecc_make_pub`関数を有効にします。
デフォルトで有効です。

#### HAVE_ECC_VERIFY_HELPER

ECC署名検証のヘルパー関数を有効にします。
ハードウェアアクセラレータを使用している場合を除き、自動的に有効になります。

#### NO_ECC_CHECK_PUBKEY_ORDER

鍵のインポート時に行うECC公開鍵の位数検証チェックを無効にします。
重要なセキュリティ検証をスキップするため、本番環境での使用は推奨されません。

#### WC_NO_CACHE_RESISTANT

オーバーヘッドを削減するため、ECCスカラー倍算におけるキャッシュ耐性のある操作（条件付きスワップ）を無効にします。
キャッシュベースのサイドチャネル攻撃に対して操作が無防備になる可能性があるため、推奨されません。

#### WOLFSSL_ECC_NO_SMALL_STACK

ECC操作における`WOLFSSL_SMALL_STACK`の最適化を無効にし、ヒープではなくスタックへの割り当てを強制します。
スタック領域に余裕があり、ヒープ割り当てのオーバーヘッドを避けたい場合に役立ちます。

#### WOLFSSL_PUBLIC_ECC_ADD_DBL

`ecc_projective_add_point`と`ecc_projective_dbl_point`を、内部専用の関数ではなく公開APIにします。
ECCの点演算に直接アクセスする必要があるアプリケーションで役立ちます。


#### WOLFSSL_PYTHON

Python wolfSSLモジュールとの互換性に必要なAPIと動作を有効にします。

#### SQRTMOD_USE_MOD_EXP

圧縮された鍵を展開する際の、素数を法とする平方根の計算を、Tonelli-Shanks法の代わりに1回のべき乗剰余演算で行います。
これにより、スタックを節約できます。
8を法として1となる素数（P-224）はサポートされず、8を法として5となる素数（secp224k1）は`HAVE_ECC_KOBLITZ`または[`WOLFSSL_CUSTOM_CURVES`](#wolfssl_custom_curves)を使用した場合にのみサポートされます。
デフォルトでは無効です。

#### WOLFSSL_ECIES_OLD

公開鍵を共有秘密の材料に含めない、従来のwolfSSL ECIES形式を使用します。
デフォルトでは無効です。


#### WOLFSSL_ECDSA_MATCH_HASH

ECDSA署名のハッシュアルゴリズムが、曲線の推奨ハッシュ（例えば、P-256ではSHA-256、P-384ではSHA-384）と一致することを必須にします。

#### WOLFSSL_ECIES_ISO18033

共有秘密の導出に公開鍵を含める、ISO 18033のECIES標準を使用します。
デフォルトでは無効です。

#### WOLFSSL_ECIES_GEN_IV

ECIES暗号化のIVを、KDFの出力から導出する代わりにランダムに生成します。
デフォルトでは無効です。

#### WOLFSSL_ECIES_STATIC_GCM_NONCE

wolfSSL 5.9.4では、HMACを併用するAES-CBC/CTRに加えて、AES-GCMがECIESのデータカプセル化メカニズム（DEM）として追加されました。
この追加には、ECIESの暗号コールバックと`devId`の受け渡しも含まれます。
このマクロは、GCMノンスが固定のオールゼロ値となるデフォルトのIVモードで、AES-GCM DEMの使用を許可します。
これが安全なのは、ECIESがメッセージごとに新しいエフェメラル鍵から新しい鍵を導出するからに他なりません。
このマクロを定義しない場合、デフォルトのIVモードでのAES-GCMは`NOT_COMPILED_IN`を返します。
[`WOLFSSL_ECIES_GEN_IV`](#wolfssl_ecies_gen_iv)（ランダムなノンス）または[`WOLFSSL_ECIES_OLD`](#wolfssl_ecies_old)（KDFから導出されたノンス）を使用する場合は、このマクロは不要です。

#### WOLFSSL_SP_521

P-521 ECC曲線向けに最適化された単精度（SP）数学ライブラリ実装を有効にします。
デフォルトでは無効です。
64ビットのIntel/ARMターゲットにおける`--enable-sp`およびそのバリエーション（例えば`--enable-sp=521`、`ec521`、`p521`）、CMakeの同等のオプション、または`user_settings.h`での手動定義によって有効になります。
[`WOLFSSL_SP_MATH`](#wolfssl_sp_math)/[`WOLFSSL_SP_MATH_ALL`](#wolfssl_sp_math_all)と`HAVE_ECC521`を組み合わせても、ヘッダーによって自動的に有効になることは**ありません**。
逆に`WOLFSSL_SP_521`を定義すると`HAVE_ECC521`が強制的に有効になりますが、これは[`WOLFSSL_SP_MATH`](#wolfssl_sp_math)を使用し、かつ`ECC_USER_CURVES`が定義されていない場合に限ります（configureは`-DHAVE_ECC521`を自ら追加します）。
なお、`WOLFSSL_SP_MATH_ALL`のみでも、（最適化されていない汎用の）P-521サポートは動作します。
`WOLFSSL_SP_521`は、この曲線専用の最適化された処理パスを追加します。

#### WOLFSSL_SP_SM2

SM2曲線（中国の暗号標準）向けに最適化された単精度（SP）数学ライブラリ実装を有効にします。
configureでは、SP ECCとともに`--enable-sm2`を使用した場合に定義されます。
`user_settings.h`を使用する場合は、[`WOLFSSL_SM2`](#wolfssl_sm2)と一緒に明示的に定義する必要があります。

#### WOLF_CRYPTO_CB_ONLY_ECC

ECC操作で暗号コールバックのみを使用するよう制限し、ソフトウェアによるECC実装をすべて無効にします。
すべてのECC操作をハードウェアまたは外部モジュールに委任する場合に役立ちます。
デフォルトでは無効です。

#### WC_ASYNC_ENABLE_ECC

暗号コールバックを使用した非同期（ノンブロッキング）ECC操作を有効にします。
[`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt)が必要です。
デフォルトでは無効です。

#### WC_ASYNC_ENABLE_ECC_KEYGEN

非同期のECC鍵生成を有効にし、鍵生成をハードウェアアクセラレータにオフロードできるようにします。
[`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt)が必要です。
デフォルトでは無効です。

#### PLUTON_CRYPTO_ECC

ECC操作にMicrosoft Plutonセキュリティプロセッサを使用できるようにします。
デフォルトでは無効です。

#### WOLFSSL_CAAM_BLACK_KEY_SM

ECC操作において、暗号化されたブラックキーの保存にNXP CAAMのセキュアメモリを使用します。
デフォルトでは無効です。

#### WOLFSSL_KCAPI_ECC

ハードウェアアクセラレーションのため、ECC操作をLinuxカーネルの暗号API（kcAPI）にオフロードします。
デフォルトでは無効です。

#### WOLFSSL_ASYNC_CRYPT

これにより、Intel QuickAssistやMarvell(Cavium)Nitrox Vなどのハードウェアベースのアダプターを使用した非同期暗号化のサポートが可能になります。
非同期フレームワークはv5.8.4以降wolfSSLに含まれており（`wolfcrypt/src/async.c`）、[`--enable-asynccrypt`](#--enable-asynccrypt)で有効にできます。
ハードウェアバックエンドがない場合は、wolfCryptを使用するソフトウェアバックエンド（[`WOLFSSL_ASYNC_CRYPT_SW`](#wolfssl_async_crypt_sw)）が使用されます。
ハードウェアバックエンドは、Intel QuickAssist（QAT 1.6および1.7ドライバー）とCavium Nitrox IIIおよびVです。
`README-async.md`をご参照ください。

#### WOLFSSL_NO_ASYNC_IO

これは非同期I/Oネットワーキングを無効にします。
非同期I/Oはデフォルトでオンになっており、ハンドシェイキングプロセス中に最大約140バイトを占めることがあります。
ネットワークインターフェースが書き込み時に`SOCKET_EWOULDBLOCK`または`SOCKET_EAGAIN`（またはカスタムI/Oコールバックの場合は`WOLFSSL_CBIO_ERR_WANT_WRITE`）を返さない場合、`WOLFSSL_NO_ASYNC_IO`を定義して、wolfSSLがハンドシェイクメッセージを構築している間に状態を保存しないようにできます。

### GCMパフォーマンスチューニング

GCMパフォーマンスには4つのバリエーションがあります。

* `GCM_SMALL` - 最小のフットプリント、最も遅い(FIPS検証済み)
* `GCM_WORD32` - 中程度(FIPS検証済み)
* `GCM_TABLE` - 高速(FIPS検証済み)
* `GCM_TABLE_4BIT` - 最速(FIPS検証済み)

configureでは、`--enable-aesgcm=small`、`--enable-aesgcm=word32`、`--enable-aesgcm=table`、`--enable-aesgcm=4bit`のいずれかで選択します（[`--enable-aesgcm`](#--enable-aesgcm)を参照）。
`--enable-lowresource`では`GCM_SMALL`が選択されます。
`user_settings.h`を使用する場合は、マクロを直接定義してください。

### wolfSSLの数学ライブラリオプション

wolfSSLには次の多倍長整数演算のオプションがあります。

* Single Precision (SP) Math All（[`WOLFSSL_SP_MATH_ALL`](#wolfssl_sp_math_all)、`sp_int.c`）: デフォルト
* 鍵サイズと曲線を限定したSingle Precision (SP) Math（[`WOLFSSL_SP_MATH`](#wolfssl_sp_math)）
* Fast Math（[`USE_FAST_MATH`](#use_fast_math)、`tfm.c`）: レガシー、デフォルトで無効
* Big Integer (ヒープ) Math（[`USE_INTEGER_HEAP_MATH`](#use_integer_heap_math)、`integer.c`）: デフォルトで無効
* 多倍長整数演算ライブラリなし（[`NO_BIG_INT`](#no_big_int)）

ビルドではこれらのうち1つだけを使用できます。
いずれも選択されていない場合は`settings.h`が`WOLFSSL_SP_MATH_ALL`を定義し、configureもデフォルトでSP Math Allを使用します。
ただし、FIPS 140-2ビルドではデフォルトでFast Mathを使用します。

Single Precision (SP) Math Libraryは推奨ライブラリであり、デフォルトです。
Cとアセンブリの両方を使用して実装されています。
そのため、特定のアーキテクチャに最適化されています。
すべての数学変数はスタック上でインスタンス化されるため、ヒープ使用量が少なくなります。
常にタイミング耐性があります。
一般的にはコードサイズを犠牲にして速度が最適化されていますが、不要なコードをコンパイルしないように高度に構成可能です。
このライブラリはDO-178C認証を取得しています。

Fast Math Libraryはレガシーなバックエンドです。
デフォルトで無効になっており、[`--enable-fastmath`](#--enable-fastmath)または`USE_FAST_MATH`で選択する必要があります。
また、カーネルのスタック制限を超えるため、`--enable-linuxkm`とは併用できません。
Cとアセンブリの両方を使用して実装されています。
そのため、特定のアーキテクチャに最適化されています。
すべての数学変数はスタック上でインスタンス化されるため、ヒープ使用量が少なくなります。
`TFM_TIMING_RESISTANT`マクロが定義されている場合、タイミング耐性を持たせることができます。
このライブラリはFIPS 140-2および140-3認証を取得しています。

Big Integer Libraryは最も移植性の高いオプションで、アセンブリなしでC言語で書かれています。
そのため、特定のアーキテクチャに最適化されていません。
すべての数学変数はヒープ上でインスタンス化され、スタック使用量は最小限です。
残念ながら、Big Integer Libraryはタイミング耐性がありません。

#### Big Integer数学ライブラリ

##### USE_INTEGER_HEAP_MATH

ヒープベースのBig Integer数学ライブラリ（`integer.c`）を選択します。
デフォルトでは有効になっておらず、タイミング耐性もありません。
`--enable-heapmath`または`CFLAGS=-DUSE_INTEGER_HEAP_MATH`で有効にできます。
[`WOLFSSL_STATIC_MEMORY`](#wolfssl_static_memory)とは併用できません。

パブリックドメインのLibTomMathライブラリからフォークされました。
LibTomMathの詳細については、<https://www.libtom.net/LibTomMath/>を参照してください。
私たちのフォークは元のパブリックドメインコードよりもかなり活発でセキュアであることに注意してください。

これは一般的に最も移植性が高く、使い始めるのが最も簡単です。
通常のbig integerライブラリのマイナス点は、より遅く、すべてのメモリがヒープから割り当てられるため多くのヒープメモリを使用し、`XREALLOC()`実装を必要とし、タイミング耐性がないことです。
実装は`integer.c`にあります。

#### NO_BIG_INT

多倍長整数演算ライブラリを一切使用せずにビルドします。
RSA、DH、DSA、ECCには多倍長整数演算ライブラリが必要なため、これらも無効にする必要があります。
configureは、SP Math、SP Math All、Fast Math、ヒープMathがすべて無効になっている場合に`NO_BIG_INT`を定義します。

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
「アーキテクチャ固有の最適化」を参照してください。

FastMathでは、すべてのメモリはスタック上に割り当てられます。
FastMathを使用する場合、スタックメモリの使用量が大きくなる可能性があるため、このオプションを使用する場合は[`TFM_TIMING_RESISTANT`](#tfm_timing_resistant)も定義することをお勧めします。
TFM_TIMING_RESISTANTが定義されている場合、FastMathコードはタイミング耐性があります。
これにより、一定時間のための大きな数学ウィンドウが減少し、メモリ使用量が少なくなります。
秘密鍵操作中にショートカットが少なく、したがって分岐が少ないため、スタックの使用量が少なくなります。
これにより、タイミング攻撃が実際の脅威であり、悪意のある第三者に秘密鍵を複製するのに十分な情報を与える可能性があるため、実装がより安全になります。

デバッグなしのGCCビルドでは、configureはFast Math、および小型の`--enable-sp`バリアント（`--enable-sp=small`など）を使用しないSPビルドに対して`-O2`を追加し、それ以外の場合は`-Os`を追加します。
`--enable-fasthugemath`では、さらに`-funroll-loops -DTFM_SMALL_SET -DTFM_HUGE_SET`が追加されます。
異なるコンパイラを使用している場合は、configure実行時に最適化フラグを手動で`CFLAGS`に追加する必要があるかもしれません。

FastMathは動的メモリとスタックメモリの使用方法も変更します。
Big Integer（ヒープ）数学ライブラリ（`integer.c`）は大きな整数に動的メモリを使用します。
FastMathはデフォルトで4096ビットの整数を保持する固定サイズのバッファを使用し（`tfm.h`のデフォルト）、2048ビットと2048ビットの乗算を可能にします。
`settings.h`は、x86_64およびAArch64ビルドと`OPENSSL_EXTRA`ビルドではこのデフォルトを8192ビットに引き上げます。
FIPS 140-2ビルドでもデフォルトは8192ビットです。
4096ビットと4096ビットの乗算が必要な場合は、`wolfssl/wolfcrypt/tfm.h`の`FP_MAX_BITS`を変更してください。
`FP_MAX_BITS`が増加すると、公開鍵操作で使用されるバッファがより大きくなるため、実行時のスタック使用量も増加します。
`FP_MAX_BITS`は最大鍵サイズの2倍である必要があります。
例えば、最大の鍵が2048ビットの場合、`FP_MAX_BITS`は4096であるべきで、4096ビットの場合は`FP_MAX_BITS`は8192であるべきです。
ECCのみを使用する場合、これは最大ECC鍵サイズの2倍に減らすことができます。
ライブラリのいくつかの関数は複数の一時的な大きな整数を使用するため、スタックは比較的大きくなる可能性があります。
これは、スタックサイズが低い値に設定されている組み込みシステムやスレッド環境でのみ問題になるはずです。
そのような環境で、FastMathを使用した公開鍵操作中にスタック破壊が発生した場合は、スタック使用量に対応するためにスタックサイズを増やしてください。

autoconfシステムを使用せずにFastMathを有効にする場合は、`USE_FAST_MATH`を定義し、`tfm.c`がコンパイルされるようにする必要があります。
`integer.c`と`sp_int.c`は自身をガードしており、何も含まない状態でコンパイルされるため、ビルドから削除する必要はありません。
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

`TFM_NO_ASM`が定義されていない限り、`TFM_X86_64`と`TFM_X86`はコンパイラのターゲットから自動的に検出されます。
`TFM_AARCH_64`もApple AArch64ビルドで自動的に定義されますが、これは64ビットのディジット（digit）を選択するだけで、Fast Math用のAArch64アセンブリはありません。
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
ビットサイズが許す範囲で、20、24、28、32、48、64ワードのコンバ(Comba)乗算と二乗の実装が含まれています。
RSA/DH/DSA操作のパフォーマンスの向上に役立ちます。

##### TFM_SMALL_MONT_SET

Intelアーキテクチャ上の小さな数値のモンゴメリーリダクションのための速度最適化を行います。
1-16ワードのモンゴメリーリダクションの実装が含まれています。
ECC操作の性能を向上させるのに役立ちます。

#### 独自の単精度(SP)数学ライブラリのサポート

SP数学ライブラリは推奨されるデフォルトのオプションであり、DO-178C認定を受けています。
`sp_int.c`は汎用の多倍長整数演算コード（SP Math All）です。
その他のファイルは固定サイズの実装で、一般的な特定の鍵サイズと曲線に対する公開鍵操作を高速化します。
これらは[`--enable-sp`](#--enable-spopt)、または[`WOLFSSL_HAVE_SP_RSA`](#wolfssl_have_sp_rsa)、[`WOLFSSL_HAVE_SP_DH`](#wolfssl_have_sp_dh)、[`WOLFSSL_HAVE_SP_ECC`](#wolfssl_have_sp_ecc)で有効になります。
次のような正しいコードファイルが含まれていることをご確認ください。

* `sp_c32.c`
* `sp_c64.c`
* `sp_arm32.c`
* `sp_arm64.c`
* `sp_armthumb.c`
* `sp_cortexm.c`
* `sp_dsp32.c`（Qualcomm Hexagon DSP）
* `sp_int.c`
* `sp_riscv64.c`
* `sp_x86_64.c`
* `sp_x86_64_asm.S`
* `sp_x86_64_asm.asm`
* `sp_sm2_*.c`と`sp_sm2_x86_64_asm.S`（SM2曲線、[`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2)を参照）

##### WOLFSSL_SP_MATH

SP数学とアルゴリズムのみを有効にします。
通常(`integer.c`)またはFAST(`tfm.c`)などの大きな整数演算コードを排除します。
鍵サイズと曲線をSPでサポートされているものだけに制限します。

##### WOLFSSL_SP_MATH_ALL

デフォルトの数学ライブラリです。
`sp_int.c`は、すべてのアルゴリズムと鍵サイズに対応する汎用の多倍長整数演算を提供し、`integer.c`と`tfm.c`を置き換えます。
最適化されたSP実装がある鍵サイズと曲線ではその実装を使用し、それ以外のサイズでは汎用コードを使用します。
常に定数時間で動作します。
[`WOLFSSL_SP_MATH`](#wolfssl_sp_math)とは併用できません。

##### WOLFSSL_SP_SMALL

SP Mathを使用する場合、これはコードの小さなバージョンを使用し、大きなスタック変数を回避します。

##### SP_WORD_SIZE

数値の1ディジット（digit）を格納するために使用するワードサイズ（8、16、32、または64ビット）を強制的に指定します。

##### WOLFSSL_SP_NONBLOCK

単精度演算の「非ブロッキング」モードを有効にします。
これにより、時間のかかる操作では`MP_WOULDBLOCK`（`FP_WOULDBLOCK`はその別名です）が返され、完了するまで関数を再度呼び出す必要があります。
ECC（`WC_ECC_NONBLOCK`）、RSA（[`WC_RSA_NONBLOCK`](#wc_rsa_nonblock)）、DH（`WC_DH_NONBLOCK`）でサポートされています。
RSAとDHの非ブロッキングには[`WOLFSSL_SP_SMALL`](#wolfssl_sp_small)と[`WOLFSSL_SP_NO_MALLOC`](#wolfssl_sp_no_malloc)も必要で、[`WOLFSSL_SP_FAST_MODEXP`](#wolfssl_sp_fast_modexp)とは併用できません。

##### WOLFSSL_SP_FAST_NCT_EXPTMOD

より高速な非定数時間のべき乗剰余の実装を有効にします。
公開鍵操作にのみ使用され、秘密鍵操作には使用されません。

##### WOLFSSL_SP_INT_NEGATIVE

マルチプレシジョン数値を負にすることができます。
(暗号化操作には必要ありません。)

##### WOLFSSL_SP_INT_DIGIT_ALIGN

`sp_int_digit`ポインタの非整列アクセスが許可されていない場合に有効にします。

##### WOLFSSL_HAVE_SP_RSA

RSA操作に対する単精度(SP)数学の最適化を有効にし、一般的な鍵サイズで大幅なパフォーマンス向上をもたらします。
2048ビットと3072ビットはデフォルトで含まれ（`WOLFSSL_SP_NO_2048` / `WOLFSSL_SP_NO_3072`で無効化できます）、4096ビットには`WOLFSSL_SP_4096`が必要です。

##### WOLFSSL_HAVE_SP_DH

2048、3072、4096ビットの単精度DH。
同じ`WOLFSSL_SP_NO_2048`、`WOLFSSL_SP_NO_3072`、`WOLFSSL_SP_4096`の設定が適用されます。

##### WOLFSSL_HAVE_SP_ECC

単精度ECCです。
デフォルトでP-256が含まれ（`WOLFSSL_SP_NO_256`で無効化できます）、`WOLFSSL_SP_384`でP-384、[`WOLFSSL_SP_521`](#wolfssl_sp_521)でP-521、[`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2)でSM2、`WOLFSSL_SP_1024`で1024ビットのSAKKE曲線が有効になります。

##### WOLFSSL_SP_LARGE_CODE

大きなバイナリーサイズとなりますが、単精度(SP)スピードアップを許可します。
一部の組み込みプラットフォームには適していない可能性があります。

##### WOLFSSL_SP_DIV_WORD_HALF

2倍の長さのワードを使用して除算が利用できないことを示します。
たとえば、32ビットCPUで、ライブラリから64ビット除算でコンパイルしたくない場合は、このマクロを定義すると、半分のワードサイズを使用して除算が行われる実装を有効化します。

##### WOLFSSL_SP_DIV_32

64ビット除算を回避します。
これを定義すると、[`WOLFSSL_SP_DIV_WORD_HALF`](#wolfssl_sp_div_word_half)も定義されます（`sp_int.h`内）。
また、Hexagon DSPコード（`sp_dsp32.c`）では、64ビット除算を使用しないワード除算を選択するためにこのマクロを使用します。

##### WOLFSSL_SP_DIV_64

効果はありません。
`settings.h`は一部のプラットフォームでこのマクロを定義しますが、これを参照するコードはありません。
2倍幅の除算がないターゲットでは[`WOLFSSL_SP_DIV_WORD_HALF`](#wolfssl_sp_div_word_half)を使用してください。

##### WOLFSSL_SP_ASM

サポートされているプラットフォーム（x86_64、ARM、RISC-V）でRSA、ECC、DH操作のパフォーマンスを最大化するために、より高速な単精度(SP)のプラットフォーム固有アセンブリコード実装を有効にします。
[`--enable-sp-asm`](#--enable-sp-asm)を使用すると、configureがプラットフォームを検出します。
また、以下のプラットフォーム固有の`WOLFSSL_SP_*_ASM`マクロのいずれかが定義されている場合にも自動的に定義されます。

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

##### WOLFSSL_SP_RISCV64_ASM

単精度(SP) RISC-V 64ビットアセンブリの実装（`sp_riscv64.c`）を有効にします。
configureは、riscv64ターゲットで`--enable-sp-asm`が指定された場合にこれを設定します。

##### WOLFSSL_SP_X86_64

単精度(SP) Intel x86 64ビットアセンブリスピードアップマクロを有効にします。
`WOLFSSL_SP_MATH_ALL`が定義されている場合にのみ適用されます。
`sp_int.c`を参照してください。

##### WOLFSSL_SP_X86

単精度(SP) Intel x86アセンブリスピードアップマクロを有効にします。
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

##### SP_INT_BITS

sp_intのビット数で、ライブラリが扱える最大の数値を決定します。
設定されていない場合、x86_64、AArch64、`OPENSSL_EXTRA`の各ビルドのSP Math Allでは、`settings.h`が4096を使用します（`WOLFSSL_MYSQL_COMPATIBLE`では8192、組み込まれているFFDHEグループが必要とする場合はそれ以上）。
それ以外の場合は、`sp_int.h`が有効なアルゴリズムからこの値を導出します。
例えば、RSA/DHでは3072（`WOLFSSL_SP_4096`では4096）、ECCのみのビルドでは最大の曲線サイズになります。
configureで設定することもでき、例えば`--with-max-rsa-bits`の値から設定されます。


### スタックまたはチップ固有の定義

wolfSSLは、さまざまなプラットフォームとTCP/IPスタック用にビルドできます。
次の定義のほとんどは`./wolfssl/wolfcrypt/settings.h`にあり、デフォルトでコメントアウトされています。
それぞれのコメントを解除することで、以下に示す特定のチップまたはスタックのサポートを有効にできます。

#### IPHONE

iOSで使用するためにビルドする場合に定義します。

#### THREADX

ThreadX RTOS(<https://www.rtos.com>)で使用するためにビルドするときに定義します。

#### MICRIUM

MicriumのuC/OS-III RTOS(<https://www.micrium.com>)のサポートを有効にするために、wolfSSLのビルド時に定義します。

#### MBED

mbedプロトタイピングプラットフォーム(<https://www.mbed.org>)で使用するためにビルドするときに定義します。

#### MICROCHIP_PIC32

マイクロチップのPIC32プラットフォーム(<https://www.microchip.com>)で使用するためにビルドするときに定義します。

#### MICROCHIP_TCPIP_V5

マイクロチップTCP/IPスタックのバージョン5を定義できます。

#### MICROCHIP_TCPIP

マイクロチップTCP/IPスタックバージョン6以降に定義できます。

#### MICROCHIP_TCPIP_BSD_API

Microchip TCP/IPスタックをBSDソケットAPI経由で使用する場合に、[`MICROCHIP_PIC32`](#microchip_pic32)と一緒に定義できます。
この場合、`MICROCHIP_PIC32`は`WOLFSSL_USER_IO`を定義しないため、wolfSSLは独自のI/Oコールバックを必要とせず、組み込みのソケットI/Oコールバックを使用します。

#### WOLFSSL_MICROCHIP_PIC32MZ

PIC32MZハードウェア暗号化エンジン用に定義できます。

#### FREERTOS

FreeRTOS(<https://www.freertos.org>)で使用するためにビルドするときに定義できます。
LwIPを使用している場合は、[`WOLFSSL_LWIP`](#wolfssl_lwip)も定義します。

#### FREERTOS_WINSIM

FreeRTOS Windowsシミュレータ(<https://www.freertos.org>)で使用するためにビルドするときに定義できます。

#### WOLFSSL_CHIBIOS

ChibiOS RTOSで使用するためにビルドする場合に定義します。

#### WOLFSSL_CMSIS_RTOS

Arm CMSIS-RTOSで使用するためにビルドする場合に定義します。

#### WOLFSSL_CMSIS_RTOSv2

Arm CMSIS-RTOS v2で使用するためにビルドする場合に定義します。

#### WOLFSSL_LWIP_NATIVE

LWIPネイティブのプラットフォームで使用します。

#### WOLFSSL_DEOS

この定義を使用して、[ここ](https://www.ddci.com/products_deos_do_178c_arinc_653/)で利用可能なDeos RTOSのwolfSSLサポートを有効にできます。

#### WOLFSSL_ESPIDF

ESP-IDFでビルドする場合に使用します。

#### WOLFSSL_ESP32

Espressif ESP32ファミリーのチップ向けにビルドする場合に、[`WOLFSSL_ESPIDF`](#wolfssl_espidf)と一緒に定義できます（`IDE/Espressif`以下のESP-IDFサンプルプロジェクトでは、ESP32、ESP32-S3、ESP32-C3など、すべてのESP32ファミリーのターゲットに対してこのマクロを定義しています）。
`NO_ESP32_CRYPT`が定義されていない限り、AESとSHA、および`ESP32_USE_RSA_PRIMITIVE`も定義されている場合はRSA演算に対して、ESP32のハードウェアアクセラレーション（`WOLFSSL_ESP32_CRYPT`）を有効にします。
個々のアルゴリズムは、例えば[`NO_WOLFSSL_ESP32_CRYPT_AES`](#no_wolfssl_esp32_crypt_aes)を使用してソフトウェア実装のままにすることができます。
乱数生成のシードは`esp_random()`から取得されます。
旧名の`WOLFSSL_ESPWROOM32`を定義した場合も、このマクロが定義されます。

#### WOLFSSL_ESPWROOM32SE

Microchip ATECC608Aセキュアエレメントを搭載したESP32-WROOM-32SEモジュール向けにビルドする場合に、[`WOLFSSL_ESPIDF`](#wolfssl_espidf)と一緒に定義できます。
`settings.h`と乱数生成のシードでは、このマクロを[`WOLFSSL_ESP32`](#wolfssl_esp32)と同様に扱います。
また、新しいESP-IDFサンプルの`user_settings.h`ファイルでは、このモジュール向けに`WOLFSSL_ESP32`も定義しています。
ATECC608Aを使用するには、サンプルの`IDE/Espressif/ESP-IDF/user_settings.h`と同様に`WOLFSSL_ATECC508A`と`HAVE_PK_CALLBACKS`も定義し、Microchip CryptoAuthLibをリンクしてください（`IDE/Espressif/ESP-IDF/README_32se.md`を参照）。

#### WOLFSSL_LINUXKM

Linuxカーネルモジュール用にビルドする場合に使用します。

#### WORD64_AVAILABLE

64ビット型がサポートされていることを示す移植用マクロです。
通常は`SIZEOF_LONG_LONG`を8として定義する方が良いです。

#### WOLFSSL_NUCLEUS_1_2

Nucleus 1.2でビルドする場合に使用します。

#### NUCLEUS_PLUS_2_3

Nucleus PLUS 2.3でビルドする場合に使用します。
`WOLFSSL_USER_SETTINGS`が定義されていない限り、`settings.h`は`nucleus.h`と、`user_settings.h`の役割を果たすNucleusの設定ヘッダー`os/networking/ssl/lite/cyassl_nucleus_defs.h`をインクルードします。
組み込みのソケットI/Oは、DTLSのタイムアウト用の`select`を含むNucleusネットワーキングAPIを使用します。

#### WOLFSSL_RENESAS_RA6M3G

RENESAS RA6M3Gでビルドする場合に使用します。

#### WOLFSSL_RENESAS_RA6M4

RENESAS RA6M4でビルドする場合に使用します。

#### WOLFSSL_RENESAS_TSIP

Trusted Secure IP（TSIP）ドライバ（`r_tsip_rx` FITモジュール）を使用してルネサスRXデバイス向けにビルドする場合に使用します。
`wolfCrypt_Init()`がTSIPをオープンし、乱数生成のシードはTSIPから取得され、`wolfcrypt/src/port/Renesas/renesas_tsip_*.c`のポートがAES、SHA、RSAにTSIPを使用します。
暗号コールバックを使用する場合は`WOLF_CRYPTO_CB_RSA_PAD`も定義されます。
TLSレイヤーでのTSIPの使用については[`WOLFSSL_RENESAS_TSIP_TLS`](#wolfssl_renesas_tsip_tls)を参照してください。
`NO_WOLFSSL_RENESAS_TSIP_CRYPT_HASH`と[`NO_WOLFSSL_RENESAS_TSIP_TLS_SESSION`](#no_wolfssl_renesas_tsip_tls_session)で、アクセラレーションの一部を無効にできます。
詳細はwolfSSLソースの`wolfcrypt/src/port/Renesas/README.md`を参照してください。

#### WOLFSSL_RENESAS_SCEPROTECT

FSP Security Module（FSPSM）ドライバ（`r_sce.h`）を介して、Secure Crypto Engine（SCE）を保護モードで使用するルネサスRAデバイス向けにビルドする場合に使用します。
ECCオフロードのために`WOLFSSL_RENESAS_FSPSM_ECC`と[`HAVE_PK_CALLBACKS`](#have_pk_callbacks)を定義します。
サンプルの`IDE/Renesas/e2studio/RA6M4/common/user_settings.h`では、これと併せて`WOLFSSL_RENESAS_FSPSM`と[`WOLFSSL_RENESAS_FSPSM_TLS`](#wolfssl_renesas_fspsm_tls)も定義しています。
wolfCryptのみを使用する場合、このファイルでは代わりに`WOLFSSL_RENESAS_SCEPROTECT_CRYPTONLY`を定義しています。

#### WOLFSSL_RIOT_OS

RIOT-OSでビルドする場合に使用します。

#### WOLFSSL_uITRON4

uITRON4用にビルドする場合に使用します。

#### WOLFSSL_uTKERNEL2

uT-Kernelでビルドする場合に使用します。

#### WOLFSSL_UTASKER

uTasker用にビルドする場合に使用します。
`SINGLE_THREADED`、`NO_FILESYSTEM`、`NO_WOLFSSL_DIR`、`NO_WRITEV`、および`ALT_ECC_SIZE`とタイミング耐性オプションを伴う`HAVE_ECC`を定義します。
また、uTaskerポートはrawソケットを使用するため、`WOLFSSL_USER_IO`も定義します。
独自のI/Oコールバックを用意してください（wolfSSLのuTaskerサンプルを参照）。
乱数生成にはuTaskerの`fnRandom()`（`CUSTOM_RAND_GENERATE`）を使用し、文字列関数にはuTaskerライブラリの代替関数を使用し、デバッグメッセージは`fnDebugMsg()`に出力され、TLSタイマーには`uTaskerSystemTick`を使用します。
`user_settings.h`で`XTIME`を、Unixエポックからの経過秒数を返す関数として定義する必要があります。
定義しない場合、ビルドは失敗します。

#### WOLFSSL_VXWORKS

VxWorksでビルドする場合に使用します。

#### DEVKITPRO

devkitPro用にビルドする場合に使用します。

#### DOLPHIN_EMULATOR

GameCubeおよびWiiのエミュレータであるDolphin向けにビルドする場合に使用します。
この場合、`wc_GenerateSeed()`は、`time()`でシードされたCライブラリの`rand()`から乱数生成のシードを取得します。
これは安全なエントロピー源ではないため、テスト目的でのみ使用してください。
wolfCryptテストプログラムは、終了時に`main()`から戻るとエミュレータがパニックを起こすため、代わりにループで待機します。

#### WOLFSSL_NDS

devkitProとlibndsを使用してNintendo DS向けにビルドする場合に使用します。
wolfSSLソースの`IDE/NDS/README.md`を参照してください（同ファイルのconfigureの例では`WOLFSSL_USER_IO`も定義しています）。
`SIZEOF_LONG_LONG`を8として定義し、`NO_WRITEV`と、不足しているソケットの型および定数を定義します。
[`DOLPHIN_EMULATOR`](#dolphin_emulator)と同様に、乱数生成のシードは`time()`でシードされた`rand()`から取得されますが、これは安全なエントロピー源ではありません。

#### WOLFSSL_VXWORKS_6_x

VxWorks 6.x専用の実装でのみ使用されます。

#### WOLFSSL_WICED

WICED Studio用にビルドする場合に使用されます。

#### FREESCALE_KSDK_FREERTOS

このマクロの古い名前は`FREESCALE_FREE_RTOS`です。
Freescale KSDK FreeRTOS用にビルドする場合に使用されます。

#### FREESCALE_KSDK_MQX

Freescale KSDK MQX/RTCS/MFS用にビルドする場合に使用されます。

#### FREESCALE_KSDK_BM

RTOSを使用しないFreescale（NXP）Kinetis KSDKベアメタル向けにビルドする場合に使用されます。
`WOLFSSL_USER_IO`（独自のI/Oコールバックを用意してください）、`SINGLE_THREADED`、`NO_FILESYSTEM`を定義します。
また、[`TIME_OVERRIDES`](#time_overrides)が定義されていない限り[`USER_TICKS`](#user_ticks)も定義するため、アプリケーション側で`LowResTimer()`を提供します。
共通のFreescale設定も適用され、SoCの機能マクロに基づいてTRNGまたはRNGA、およびmmCAUまたはLTCのハードウェア暗号が選択されます。
TRNGもRNGAも搭載していないSoCでは、乱数生成は安全でないテスト用シード（`USE_TEST_GENSEED`、ビルド時に警告が表示されます）にフォールバックするため、例えば[`CUSTOM_RAND_GENERATE_SEED`](#custom_rand_generate_seed)を使用して実際のシードソースを用意してください。

#### FREESCALE_MQX_5_0

Freescale Classic MQXバージョン5.0用にビルドする場合に使用されます。

#### FREESCALE_MQX_4_0

Freescale Classic MQXバージョン4.0用にビルドする場合に使用されます。
[`FREESCALE_MQX`](#freescale_mqx)を定義し、4.0向けに小さな変更を加えます。
時刻は`<time.h>`で宣言された`mqx_time()`から取得され、`HAVE_GMTIME_R`は定義されません。

#### WOLFSSL_KEIL_TCP_NET

wolfSSLのソケットI/OにKeil MDK TCPnet/Networkスタックを使用します。
MDK5パックの`user_settings.h`（`IDE/MDK5-ARM`）では、`MDK_CONF_NETWORK`が1（デフォルト）の場合にこれが選択されます。
なしの場合は0、ユーザーI/Oコールバックの場合は2を使用します。

#### HAVE_KEIL_RTX

MDK-RTX-TCP-FS構成用のwolfSSL。

#### EBSNET

EBSnet製品とRTIPを使用するときに定義できます。

#### WOLFSSL_EMBOS

SEGGER embOS (<https://www.segger.com/products/rtos/embos/>) のビルド時に定義できます。
emNETを使用する場合は、[`WOLFSSL_EMNET`](#wolfssl_emnet) も定義します。

#### WOLFSSL_EMNET

SEGGER emNET TCP/IPスタック (<https://www.segger.com/products/connectivity/emnet/>) のビルド時に定義できます。

#### WOLFSSL_LWIP

LwIP TCP/IPスタック(<https://savannah.nongnu.org/projects/lwip/>)でwolfSSLを使用するときに定義できます。

#### WOLFSSL_ISOTP

通常、CANバスに使用されるISO-TPトランスポートプロトコルでwolfSSLを使用する場合、定義できます。
使用例は[wolfssl-examplesリポジトリ](https://github.com/wolfssl/wolfssl-examples)にあります。


#### WOLFSSL_IOTSAFE

セキュアエレメント操作のためのIoTSAFE（GSMA）アプレットのサポートを有効にします。
TLSの鍵と暗号処理を、IoTSAFE準拠のSIMで扱えるようにします。

#### WOLFSSL_MAXQ1065

Analog Devices（Maxim）MAXQ1065セキュアオーセンティケータと一緒に使用します。
configureは`--with-maxq10xx=MAXQ1065`の場合にこれを定義します。
`WOLFSSL_MAXQ10XX_CRYPTO`、`WOLFSSL_MAXQ10XX_TLS`、[`HAVE_PK_CALLBACKS`](#have_pk_callbacks)、`WOLFSSL_STATIC_PSK`、`WOLFSSL_PUBLIC_ASN`を定義します。
また、クライアント側のみがサポートされているため、`NO_WOLFSSL_SERVER`も定義します。
暗号コールバックを使用する場合、AES-GCM、SHA-256、ECC、乱数生成はデバイスを使用し、`wc_GenerateSeed()`はデバイスからシードを読み取ります。
`WOLFSSL_TICKET_NONCE_MALLOC`とは併用できません。
詳細はwolfSSLソースの`wolfcrypt/src/port/maxim/README.md`を参照してください。

#### WOLFSSL_MAXQ108X

Analog Devices（Maxim）MAXQ1080セキュアオーセンティケータと一緒に使用します。
configureは`--with-maxq10xx=MAXQ108x`の場合にこれを定義します。
[`WOLFSSL_MAXQ1065`](#wolfssl_maxq1065)と同じ設定を持ち、暗号コールバックを使用する場合はデバイスがRSAも処理します。

#### FREESCALE_MQX

Freescale MQX/RTCS/MFS(<https://www.freescale.com>)用にビルドするときに定義できます。
これにより、`FREESCALE_K70_RNGA`が定義され、Kinetis H/W乱数ジェネレーターアクセラレータのサポートが可能になります。

#### WOLFSSL_IAR_ARM

IAR EWARM用にビルドする場合は定義できます。

#### WOLFSSL_TIRTOS

TI-RTOS用のビルド時に定義できます。

#### WOLFSSL_ROWLEY_ARM

Rowley CrossWorksでビルドするときに定義できます。

#### WOLFSSL_NRF5x

Nordic nRF5xに移植するときに定義できます。
内部で`WOLFSSL_NRF51`を定義し、併せて`NO_FILESYSTEM`、`SINGLE_THREADED`、`WOLFSSL_USER_IO`、`NO_DEV_RANDOM`、`NO_WRITEV`、`NO_MAIN_DRIVER`、`NO_SESSION_CACHE`、`TFM_TIMING_RESISTANT`も定義します。
ポート（`wolfcrypt/src/port/nrf51.c`）は、nRF RNGドライバから乱数生成のシードを取得し、ベンチマーク用にRTCベースのタイマーを提供します。

#### WOLFSSL_CONTIKI

Contikiオペレーティングシステムのサポートを有効にするために定義できます。

#### WOLFSSL_APACHE_HTTPD

Apache HTTPD Webサーバーのサポートを有効にするために定義できます。

#### ASIO_USE_WOLFSSL

`ASIO_USE_WOLFSSL`と`BOOST_ASIO_USE_WOLFSSL`は、wolfSSLではなく(Boost.)Asioが参照するマクロです。
wolfSSLは[`--enable-asio`](#--enable-asio)（またはCMakeオプション`WOLFSSL_ASIO`）でビルドしてください。
これにより、[`WOLFSSL_ASIO`](#wolfssl_asio)（wolfSSL自体が参照するマクロ）が定義され、`OPENSSL_EXTRA`と`OPENSSL_ALL`が有効になり、両方のAsio用定義が追加されます。

#### WOLFSSL_SIFIVE_RISC_V

wolfSSLライブラリはこのマクロを参照しません。
これはSiFive HiFive1ボード用のサンプルプロジェクト（`IDE/RISCV/SIFIVE-HIFIVE1/user_settings.h`）内の設定です。

#### WOLFSSL_MDK_ARM

MDK ARMのサポートを追加します。

#### WOLFSSL_MDK5

MDK5 ARMのサポートを追加します。

#### FUSION_RTOS

Fusion RTOS用にビルドする場合に定義できます。
この場合、wolfSSLはI/O、ファイルアクセス、時刻のために、Fusion RTOSのソケット（FNS）およびCライブラリ/ファイルシステム（FCL）インターフェースを使用します。

#### WOLFSSL_ZEPHYR

Zephyr RTOS用にビルドする場合に定義できます。
wolfSSLはZephyrモジュールとして使用でき、そのビルドでこのマクロが定義されます。
詳細はwolfSSLソースの`zephyr/README.md`を参照してください。

#### WOLFSSL_BSDKM

FreeBSDカーネルモジュールとしてwolfSSLをビルドする場合に定義できます。
configureは`--enable-freebsdkm`の場合にこれを定義します。
詳細はwolfSSLソースの`bsdkm/README.md`を参照してください。

#### WOLFSSL_XILINX

Xilinxベアメタルターゲット向けにビルドする場合に定義できます。
ファイルシステムにはFatFs（`ff.h`）を使用し、時刻にはPS RTC（`XRtcPsu`）を使用します。
Xilinxハードウェア暗号エンジンについては[`WOLFSSL_XILINX_CRYPT`](#wolfssl_xilinx_crypt)を参照してください。

#### WOLFSSL_TELIT_M2MB

m2mb SDKを使用してTelitモジュール向けにビルドする場合に定義できます。
m2mbのファイルシステム、ミューテックス、乱数生成のシード、時刻のポートを提供します。
これには、`XTIME()`用の`m2mb_xtime()`と、TLS 1.3で使用する[`XTIME_MS`](#xtime_ms)用の`m2mb_xtime_ms()`が含まれます。

#### WOLFSSL_OPTEE

wolfSSLをOP-TEEのトラステッドアプリケーション（TA）に組み込んでビルドする場合に定義できます。
`NO_FILESYSTEM`、`NO_WOLFSSL_DIR`、`NO_WRITEV`、`NO_MAIN_DRIVER`、`SINGLE_THREADED`を定義し、メモリ、乱数生成のシード（`TEE_GenerateRandom()`）、タイマーにはTEE内部APIを使用します。
TAが参照できる唯一の実時間クロックはノーマルワールドのものであるため、`WOLFSSL_OPTEE_ASN_TIME`が定義されていない限り`NO_ASN_TIME`が定義されます。

#### HAVE_NETX

NetXまたはNetX Duo TCP/IPスタックを使用する場合に定義できます。
この場合、wolfSSLはNetX用のI/Oコールバックを使用します。
セッションのソケットは[`wolfSSL_SetIO_NetX()`](group__IO.md#function-wolfssl_setio_netx)で設定してください。
NetX Duo上でDTLSを使用するには`WOLFSSL_NETX_DUO`も必要です（[`wolfSSL_SetIO_NetX_Dtls()`](group__IO.md#function-wolfssl_setio_netx_dtls)を参照）。

#### WOLFSSL_ARDUINO

Arduino用にビルドする場合に定義できます。
`WOLFSSL_USER_IO`、`SINGLE_THREADED`、`NO_DEV_RANDOM`、`NO_WRITEV`、`NO_WOLFSSL_DIR`、`NO_SESSION_CACHE`、`HAVE_ECC`、`NO_DH`を定義します。
ESP32ボードでは通常の時刻関数を使用し、ARMボードでは`NO_ASN_TIME`が定義されます。
その他のボードでは[`TIME_OVERRIDES`](#time_overrides)を使用するため、`XTIME`と`XGMTIME`を定義する必要があります。
詳細はwolfSSLソースの`IDE/ARDUINO`を参照してください。

#### WOLFSSL_RPIPICO

Pico SDKを使用してRaspberry Pi RP2040またはRP2350向けにビルドする場合に定義できます。
`wc_pico_rng_gen_block()`を提供します。
PicoのRNGを使用するには、`WC_NO_HASHDRBG`を定義し、`CUSTOM_RAND_GENERATE_BLOCK`を`wc_pico_rng_gen_block`として定義してください。
詳細はwolfSSLソースの`wolfcrypt/src/port/rpi_pico/README.md`を参照してください。

### OS特有の定義

#### USE_WINDOWS_API

UNIX/Linux APIに対して、WindowsライブラリAPIの使用を指定します。

#### WIN32_LEAN_AND_MEAN

Microsoft Win32 LeanとMean Buildのサポートを追加します。

#### FREERTOS_TCP

FreeRTOS TCPスタックのサポートを追加します。

#### WOLFSSL_SAFERTOS

SafeRTOSのサポートを追加します。

#### WOLFSSL_SOLARIS

Solaris用にビルドする場合に使用します。
コンパイラが`sun`または`__sun`と、`__SVR4`または`__svr4__`を定義している場合、`settings.h`がこのマクロを自動的に定義します。
システムの`math.h`ヘッダーにある`fp_zero`との衝突を避けるため、[`WOLFSSL_DH_CONST`](#wolfssl_dh_const)を定義します。

## ビルドオプション

以下は、wolfSSLライブラリのビルド方法をカスタマイズするために`./configure`スクリプトに追加される可能性のあるオプションです。

デフォルトでは共有ライブラリとしてのみビルドされ、スタティックライブラリとしてのビルドが無効になっています。
これによりビルド時間が半分に短縮されます。
必要に応じて、どちらのモードも明示的に無効化または有効化できます。

### `--enable-debug`

wolfSSLデバッグサポートを有効にします。
デバッグサポートを有効にすると、デバッグ情報を含めてコンパイルされ、メッセージを`stderr`に出力する定数[`DEBUG_WOLFSSL`](#debug_wolfssl)が定義されるため、デバッグが容易になります。
実行時にデバッグログ出力を有効にするには、[`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on)を呼び出します。
同様に[`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off)を呼び出すことで、実行時にデバッグログ出力を停止できます。
詳細は[第8章 デバッグ](chapter08.md)を参照してください。

### `--enable-debug-trace-errcodes`

ライブラリがエラーコードを発生させるたびに、トレースメッセージを出力します（`WOLFSSL_DEBUG_TRACE_ERROR_CODES`を定義します）。
`--enable-debug-trace-errcodes=backtrace`を指定すると、バックトレースも出力し、`libbacktrace`とリンクします。
デフォルトで無効です。

### `--enable-debug-code-points`

[`--enable-debug`](#--enable-debug)のメッセージに、ソースファイル名と行番号を含めます（`WOLFSSL_DEBUG_CODEPOINTS`を定義します）。
デフォルトで無効です。

### `--enable-distro`

ディストリビューションパッケージ向けのビルドを有効にします。
共有ライブラリとスタティックライブラリの両方をビルドし、[`--enable-all`](#--enable-all)を有効にし、デフォルトで[`--enable-reproducible-build`](#--enable-reproducible-build)を有効にし、Early Dataを無効にします。
`--enable-experimental`とは併用できません。

### `--enable-singlethreaded`

シングルスレッドモードを有効にし、マルチスレッド保護を無効にします（`SINGLE_THREADED`を定義します）。
configureがPOSIXスレッドライブラリを見つけられない場合も、シングルスレッドモードが自動的に選択されます。

シングルスレッドモードを有効にすると、セッションキャッシュのマルチスレッド保護がオフになります。
アプリケーションがシングルスレッドであること、またはアプリケーションがマルチスレッドであっても一度に1つのスレッドだけがライブラリにアクセスする場合にのみ、シングルスレッドモードを有効にしてください。

### `--disable-threadlocal`

コンパイラがサポートしている場合、デフォルトでスレッドローカルストレージを使用します（`HAVE_THREAD_LS`を定義します）。
`--disable-threadlocal`を指定すると、スレッドローカルストレージを使用しなくなります。
スレッドごとのエラーキューなど、一部の機能はスレッドローカルストレージを必要とします。

### `--enable-rwlock`

セッションキャッシュなどに読み書きロック（reader-writer lock）を使用し、読み取り側同士が互いをブロックしないようにします（[`WOLFSSL_USE_RWLOCK`](#wolfssl_use_rwlock)を定義します）。
POSIXスレッドでは、このロックは`pthread_rwlock_t`です。
デフォルトで無効です。

### `--enable-dtls`

wolfSSL DTLSのサポートを有効にします。

DTLSサポートを有効にすると、ライブラリのユーザーはTLSおよびSSLに加えてDTLSプロトコルも使用できるようになります。
詳細については、第4章の[DTLS](chapter04.md#dtls)節を参照してください。

### `--enable-dtls13`

DTLS 1.3を有効にします（`WOLFSSL_DTLS13`を定義します）。
デフォルトで無効です。
DTLSとTLS 1.3も自動的に有効になり、`--disable-hrrcookie`を指定しない限り、サーバーのHelloRetryRequest Cookie（[`--enable-hrrcookie`](#--enable-hrrcookie)）も有効になります。
ML-KEMが有効な場合（デフォルト）は、DTLS 1.3 ClientHelloのフラグメント化も有効になります。

### `--enable-dtlscid`

DTLS Connection ID拡張を有効にします（`WOLFSSL_DTLS_CID`を定義します）。
デフォルトで無効です。

### `--enable-dtls-frag-ch`

1つのデータグラムに収まらないClientHelloメッセージ（ポスト量子の鍵共有を含む場合など）に対応するため、DTLS 1.3 ClientHelloのフラグメント化を有効にします。
`--enable-dtls13`が必要です。
デフォルトで無効ですが、ML-KEMとDTLS 1.3の両方が有効な場合は自動的に有効になります。

### `--enable-dtls-mtu`

アプリケーションがDTLSのMTUサイズを設定できるようにします。
デフォルトで無効です。

### `--enable-srtp`

DTLS-SRTP（RFC 5764）を有効にします。
デフォルトで無効です。
DTLS、SRTP KDF、キーイングマテリアルエクスポーターも有効になります。

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
これを指定しないベーシックビルドで、ほとんどのTLS/SSLニーズに対応できる関数を使用できます。
しかし数十から数百のOpenSSL関数呼び出しを使用するアプリケーションを移植する場合には、これを有効にすることでよりスムーズに移植できるようになります。
wolfSSL OpenSSL互換レイヤーは現在も継続して開発しています。
必要な関数が欠落している場合はお問い合わせください。
OpenSSL互換レイヤーの詳細については、[第13章 OpenSSL互換性](chapter13.md)を参照してください。

`--enable-opensslextra=noinstall`を指定すると、`wolfssl/openssl/`互換ヘッダーのインストールを行いません。
この値だけでは`OPENSSL_EXTRA`は定義されないため、[`--enable-opensslall`](#--enable-opensslall)など、互換レイヤーを有効にするオプションと組み合わせて使用してください。

### `--enable-opensslall`

wolfSSLがサポートするOpenSSL互換レイヤーのOpenSSL APIをすべて有効にします。

### `--enable-opensslcoexist`

OpenSSLのlibcryptoと一緒にリンクできるようにwolfSSLをビルドします（`OPENSSL_COEXIST`を定義し、wolfSSLとwolfCryptの古い互換名を削除します）。
デフォルトで無効です。
`--enable-opensslall`とは併用できません。

### `--disable-openssl-compatible-defaults`

`--enable-enterprise`、`--enable-nginx`、`--enable-haproxy`、`--enable-apachehttpd`、`--enable-stunnel`など一部のアプリケーション向けビルドは、wolfSSLの実行時の動作をOpenSSLに近づけるために`OPENSSL_COMPATIBLE_DEFAULTS`を定義します。
configureは、`CFLAGS`または`CPPFLAGS`に指定されたこのマクロも認識します。
このマクロが設定されている場合、configureは`WOLFSSL_TRUST_PEER_CERT`、`NO_SESSION_CACHE_REF`、`WOLFSSL_TLS13_NO_PEEK_HANDSHAKE_DONE`、`WOLFSSL_ALT_CERT_CHAINS`、`WOLFSSL_PRIORITIZE_PSK`、`WOLFSSL_CHECK_ALERT_ON_ERR`、`WOLFSSL_TICKET_HAVE_ID`を追加します。
`--disable-openssl-compatible-defaults`を指定すると、フラグから`OPENSSL_COMPATIBLE_DEFAULTS`を削除し、これらを追加しません。
アプリケーション向けビルドのその他の設定はそのまま維持されます。

### `--disable-oldnames`

名前が変更されたwolfSSLおよびwolfCryptの型、関数、マクロの古い名前は、後方互換性のためにデフォルトで残されています。
`--disable-oldnames`を指定すると、これらを削除します（`NO_OLD_RNGNAME`、[`NO_OLD_WC_NAMES`](#no_old_wc_names)、[`NO_OLD_SSL_NAMES`](#no_old_ssl_names)、`NO_OLD_SHA_NAMES`、`NO_OLD_MD5_NAME`を定義します）。
[`--enable-opensslcoexist`](#--enable-opensslcoexist)を指定した場合は効果がありません。
`--enable-opensslcoexist`は、古いRNG名を除いて、これらをすべて既に削除しているためです。

### `--enable-old-extdata-fmt`

`wolfSSL_X509_EXTENSION_get_data()`が、拡張のOCTET STRING全体ではなく、古いバージョンのwolfSSLと同様に拡張の種類ごとに固有の形式でデータを返すようにします（`WOLFSSL_OLD_EXTDATA_FMT`を定義します）。
古い形式を必要とするアプリケーションとの互換性のためにのみ使用してください。
デフォルトで無効です。

### `--enable-maxstrength`

最大強度ビルドを有効にし、TLSv1.2-AEAD-PFS暗号のみを許可します。
相互運用性の問題が発生する可能性があるため、これはデフォルトで無効になっています。
また、グリッチ検出も有効になります。
`WOLFSSL_MAX_STRENGTH`と`WOLFSSL_CIPHER_TEXT_CHECK`を定義し、古いTLSを強制的に無効にします（`NO_OLD_TLS`）。
`--enable-leanpsk`または`--enable-sslv3`とは併用できません。

### `--disable-harden`

ハードニング、タイミング耐性とRSAブラインドを無効にします。
この機能を無効にするとパフォーマンスが向上する可能性があります。

**注意** ハードニングはサイドチャネル攻撃に対する緩和策を提供します。
慎重に検討した後にのみ、この機能を無効にしてください。

user_settings.hで無効にするには、以下のようにします。

* `#define WC_NO_CACHE_RESISTANT`
* `#define WC_NO_HARDEN`
* `WC_RSA_BLINDING`が定義されている場合、削除する
* `ECC_TIMING_RESISTANT`が定義されている場合、削除する
* `TFM_TIMING_RESISTANT`が定義されている場合、削除する

### `--enable-harden-tls`

RFC 9325のTLS要件を有効にします（`WOLFSSL_HARDEN_TLS`を定義します）。
デフォルトで無効です。
値として、最小セキュリティ強度をビット数で表す`yes`、`112`、`128`を指定できます。
`yes`は`112`と同じです。
古いTLSを強制的に無効にし、`--enable-legacy-server-connect`とは併用できません。

### `--enable-faultharden`

フォールトインジェクション攻撃に対するハードニングを有効にします。
たとえば、TLSのECC署名を作成した後にその署名を検査したり、署名検証に冗長なチェックを追加したりします（`WOLFSSL_CHECK_SIG_FAULTS`、`WOLFSSL_CHECK_VER_FAULTS`、`WC_SHA3_FAULT_HARDEN`、`WC_MLKEM_FAULT_HARDEN`、`WC_MLDSA_FAULT_HARDEN`を定義します）。
デフォルトで無効です。

### `--enable-compileharden`

ハードニング用の追加のコンパイラフラグ（`-Wa,-mbranches-within-32B-boundaries -falign-loops=64`）を追加します。
デフォルトで無効です。
アセンブラオプション`-mbranches-within-32B-boundaries`はx86固有であり、ツールチェーンがこのオプションを受け付けない場合、configureは失敗します。

### `--enable-aes-touch-lines`

キャッシュタイミング攻撃への耐性のため、AESのテーブルを参照するたびに、テーブルのすべてのキャッシュラインにアクセスします（`WOLFSSL_AES_TOUCH_LINES`を定義し、`--disable-aes-touch-lines`は`WOLFSSL_AES_NO_TOUCH_LINES`を定義します）。
RISC-Vではデフォルトで有効、その他のターゲットではデフォルトで無効です。

### `--enable-aes-bitsliced`

キャッシュタイミング攻撃への耐性のため、テーブルを使用しないビットスライス方式のAES実装を使用します（[`WC_AES_BITSLICED`](#wc_aes_bitsliced)を定義します）。
AES-ECB（`HAVE_AES_ECB`）とAESダイレクト（`WOLFSSL_AES_DIRECT`）も有効になります。
デフォルトで無効です。

### `--enable-ipv6`

IPv6のテストを有効にします。
wolfSSL自体はIP中立です。

IPv6を有効にすると、テストアプリケーションがIPv4の代わりにIPv6を使用するように変更されます。
wolfSSL自体はIP中立で、どちらのバージョンも使用できますが、現在のテストアプリケーションはIP依存です。

### `--enable-bump`

SSLバンプビルドを有効にします。

### `--enable-leanpsk`

LEAN PSKビルドを有効にします。

PSKを使用し、ライブラリから多くの機能を削除して非常に小さなビルドを構成します。
これを有効にすると、組み込みシステムでのwolfSSLのビルドサイズは約21kBになります。

### `--enable-leantls`

LEAN TLS 1.2クライアントのみ（クライアント認証なし）、ECC256、AES128およびSHA256（Shamirなし）をサポートするよう構成します。
現時点では、他のビルドオプションと組み合わせて使用することを想定していません。

このオプションは`WOLFSSL_LEANTLS`、`NO_WOLFSSL_SERVER`、`NO_RSA`、`NO_DH`、`NO_OLD_TLS`などを定義し、[`--enable-lowresource`](#--enable-lowresource)も有効にします。
TLS 1.3は無効になりません。
TLS 1.3は有効なまま（デフォルト）であり、TLS 1.3が有効な間はAES-GCMも維持されます。
ここで説明しているTLS 1.2のみのクライアントを構成するには、[`--disable-tls13`](#--disable-tls13)を追加してください。

### `--enable-lowresource`

メモリとフラッシュの使用量を抑える設定を有効にします。
デフォルトで無効です。
セッションキャッシュを無効にし、RSA、Curve25519、Ed25519、SHA-1、SHA-256、SHA-512、AES、AES-GCMについて小型で低速な実装（`RSA_LOW_MEM`、`CURVE25519_SMALL`、`ED25519_SMALL`、`USE_SLOW_SHA256`、`GCM_SMALL`など）を選択し、ECC Shamirを除外します。

### `--enable-tinytls13`

TLS 1.3の小型フットプリントプロファイル（tiny TLS 1.3）を有効にします。
これはTLS 1.3専用のビルドで、組み込み機器やリソースが限られたターゲット向けに、wolfSSLを最小限のハンドシェイク機能に絞り込みます。
このプロファイルは標準のwolfSSLマクロに対する変換レイヤー（`settings.h`内の`WOLFSSL_TINY_TLS13`アンブレラ）として実装されているため、コアライブラリに新しい機能フラグは追加されません。

プロファイルはカンマ区切りのリストで選択します。

```sh
./configure --enable-tinytls13=LIST
```

値を指定しない`--enable-tinytls13`は、`--enable-tinytls13=psk`と同じです。
このプロファイルは非FIPSであり、FIPSビルドとは併用できません。

#### ベースプロファイル

* `psk`（デフォルト）: X.509を使用しない、事前共有鍵とECDHEによるビルドです。
  最小構成は、X25519鍵交換、AES-128-GCM、SHA-256、HKDFです。
  これが最も小さい構成です。
* `cert`: 最小構成に加えて、最小限のX.509証明書チェーン検証を追加します。
  デフォルトではECDSA P-256を使用します。

証明書プロファイルは、セキュリティを抑えた検証を行います。
コードサイズを削減するため、X.509の名前制約の適用を無効にし、ASN.1の厳密性を緩和し、CRLによる失効確認を削除します。
既知の認証局、またはピン留めされた認証局での使用を想定しており、一般的なパブリックインターネットのPKI向けではありません。
証明書プロファイルが選択されると、configureは通知を表示します。

#### 追加項目

以下の項目は、カンマ区切りのリスト内でベースプロファイルと組み合わせて指定できます。

* `server`: TLS 1.3のサーバー機能を追加します。
  デフォルトはクライアントのみです。
* `mutualauth`: X.509クライアント認証による相互TLS認証です。
  `cert`も有効になります。
* `staticmem`: 呼び出し側が提供する静的メモリプールからTLSのメモリ割り当てを行います。
  ヒープを一切使用しないビルドにするには、別途`WOLFSSL_NO_MALLOC`を追加してください。
* `asm`: 小型のCバックエンドの代わりに、アセンブリによる暗号実装を使用します。
  サイズは大きくなりますが高速です。
* `p256`: PSKの最小構成で、X25519の代わりにP-256 ECDHEを使用します。
* `sha384`: SHA-384を追加します（AES-256-GCM-SHA384向けなど）。
* `mldsa`: ML-DSA-65による証明書検証を追加します（検証のみ）。
* `rsaverify`: RSA-PSSによる証明書検証を追加します。
  証明書プロファイルは、デフォルトではECDSAのみに対応します。

例として、ECDSA証明書を検証し、SHA-384もサポートするTLS 1.3サーバーは次のように構成します。

```sh
./configure --enable-tinytls13=cert,server,sha384
```

#### フットプリント

以下の数値は、SHA-256のみの最小構成において、`-Os`、リンク時最適化、デッドコード削除（`-flto -ffunction-sections -fdata-sections -Wl,--gc-sections`）を用いてビルドし、リンクしたクライアントバイナリのフラッシュ使用量（textとdataの合計）です。
これはアプリケーションに実際にリンクされるサイズであり、`libwolfssl.a`のサイズよりもはるかに小さくなります。
使用したツールチェーンは、arm-none-eabi-gcc 14.2とnewlib-nano（Cortex-M33）、clang `-Os`（Intel x86_64）、aarch64-none-elf-gcc 14.2とnewlib（ARM aarch64）です。

| 構成 | Cortex-M33 | Intel x86_64 | ARM aarch64 |
| --- | --: | --: | --: |
| PSK、X25519（最小構成） | 30,836 | 56,092 | 50,700 |
| PSK、P-256 | 37,347 | 66,068 | 59,292 |
| 証明書、ECDSA P-256 | 62,765 | 110,817 | 95,404 |
| 相互TLS認証 | 66,554 | 116,789 | 99,836 |

Cortex-M33における主な追加項目のコストを、PSKの最小構成と比較して以下に示します。

| ビルド | フラッシュ（バイト） | 最小構成との差 |
| --- | --: | --: |
| PSK最小構成（X25519） | 30,836 | 0 |
| 静的メモリを追加（ヒープ不使用） | 32,169 | +1,333 |
| P-256を追加 | 37,347 | +6,511 |
| ML-DSA-65検証を追加 | 43,780 | +12,944 |

Cortex-M33上のPSK P-256クライアント（37,347バイト）について、フラッシュ使用量の内訳を以下に示します。

| コンポーネント | バイト |
| --- | --: |
| TLS 1.3ハンドシェイク | 7,766 |
| TLS拡張 | 5,678 |
| ECC P-256（SP演算） | 5,962 |
| CTX、SSLオブジェクトおよびAPI | 4,050 |
| レコードレイヤー | 3,564 |
| AES-128-GCM | 2,650 |
| HMAC、HKDF、DRBG、RNG | 2,110 |
| SHA-256 | 1,370 |
| 鍵スケジュール | 1,120 |
| メモリ管理とクリーンアップ | 630 |
| Cライブラリ（newlib） | 952 |
| その他（インライン展開分を含む） | 1,486 |

#### アプリケーションに合わせたカスタマイズ

1. 最も近いベースプロファイルから始めます。
   エンドポイント間で事前共有鍵を共有しており、証明書が不要な場合は`psk`を使用します。
   既知の認証局が発行したX.509証明書を検証する必要がある場合は`cert`を使用します。
2. 必要な追加項目のみを追加します。
   上の表に示すとおり、各追加項目によるサイズの増加は意図的なものであり、その増加量は計測されています。
   サーバーとしてビルドする場合は`server`から始め、曲線や署名の追加項目は通信相手が必要とする場合にのみ追加してください。
3. 鍵交換に使用する曲線を選択します。
   PSKの最小構成はX25519を、証明書プロファイルはP-256を使用します。
   PSKの最小構成でP-256を使用したい場合（ECDSA証明書のために既に取り込まれているP-256のコードを再利用する場合など）は、`p256`を追加します。
   代わりにP-384やポスト量子ハイブリッドなど独自のグループを使用する場合は、その曲線を自分で選択し、プロファイルがデフォルトのX25519やP-256を強制しないように`WOLFSSL_TINY_TLS13_NO_DEFAULT_CURVE`を定義してください。
4. メモリモデルを選択します。
   デフォルトではシステムのアロケーターを使用します。
   `wolfSSL_CTX_load_static_memory()`で渡した固定のプールからTLSのメモリ割り当てを行うには、`staticmem`を追加します。
   ヒープを一切持たないターゲットでは、`WOLFSSL_NO_MALLOC`も定義してください。
5. ベアメタル向けのプラットフォーム依存部分を用意します。
   サンプルのテンプレートは`WOLFSSL_USER_IO`（送受信コールバックを自分で用意します）、`NO_FILESYSTEM`、`WOLFSSL_NO_SOCK`を有効にし、`CUSTOM_RAND_GENERATE_SEED`を通じてハードウェアのエントロピー源が提供されることを前提としています。
6. サイズを優先してビルドします。
   未使用のコードが削除されるように、アプリケーションを`-Os -flto -ffunction-sections -fdata-sections -Wl,--gc-sections`でリンクしてください。

同じプロファイルは、autotoolsを使用せずに`settings.h`の`WOLFSSL_TINY_TLS13`アンブレラからも利用できます。
テンプレート`examples/configs/user_settings_tinytls13.h`では、`#if 0`と`#if 1`のブロックでプロファイルと追加項目を選択します。
最も小さいサイズは、デッドコード削除とリンク時最適化を行ったビルドで得られます。

```sh
cp ./examples/configs/user_settings_tinytls13.h user_settings.h
./configure --enable-usersettings --enable-static --disable-shared \
            --disable-examples --disable-crypttests
make
# link your application with:
#   -Os -flto -ffunction-sections -fdata-sections -Wl,--gc-sections
```

このプロファイルは、すべて`WOLFSSL_TINY_TLS13`系のマクロによって制御されます。
各マクロはconfigureのリスト項目に対応しているため、`settings.h`によるビルドと`--enable-tinytls13`によるビルドでは同じ機能が選択されます。

| マクロ | configureの項目 | 効果 |
| --- | --- | --- |
| `WOLFSSL_TINY_TLS13` | `psk` | ベースプロファイルです。TLS 1.3のみ、PSKとECDHE、X.509なし。X25519、AES-128-GCM、SHA-256、HKDF。他のすべてのマクロは、このマクロも有効にします。 |
| `WOLFSSL_TINY_TLS13_CERT` | `cert` | 最小限のX.509証明書チェーン検証（ECDSA P-256）を追加し、デフォルトの曲線をP-256に切り替えます。ベースプロファイルも有効になります。 |
| `WOLFSSL_TINY_TLS13_MUTUAL_AUTH` | `mutualauth` | X.509クライアント認証による相互TLS認証です。`WOLFSSL_TINY_TLS13_CERT`も有効になります。 |
| `WOLFSSL_TINY_TLS13_SERVER` | `server` | TLS 1.3のサーバー機能を追加します。デフォルトはクライアントのみです。 |
| `WOLFSSL_TINY_TLS13_STATIC_MEM` | `staticmem` | 呼び出し側が提供する静的メモリプールからTLSのメモリ割り当てを行います。 |
| `WOLFSSL_TINY_TLS13_ASM` | `asm` | 小型のCバックエンドの代わりに、アセンブリによる暗号実装を使用します。サイズは大きくなりますが高速です。 |
| `WOLFSSL_TINY_TLS13_RSA_VERIFY` | `rsaverify` | RSA-PSSによる証明書検証を追加します。証明書プロファイルと組み合わせて使用します。 |
| `WOLFSSL_TINY_TLS13_NO_DEFAULT_CURVE` | （なし） | デフォルト曲線の自動選択を抑止します。この場合、プロファイルはX25519もP-256も有効にしないため、独自のグループ（P-384やポスト量子ハイブリッドなど）を選択できます。 |

configureの項目`p256`、`sha384`、`mldsa`には専用のtinyマクロはなく、標準のwolfSSLマクロ（`ECC_USER_CURVES`と組み合わせた`HAVE_ECC`、`WOLFSSL_SHA384`、`WOLFSSL_MLDSA_VERIFY_ONLY`と組み合わせた`WOLFSSL_HAVE_MLDSA`）で選択します。
具体的なブロックについては、`examples/configs/user_settings_tinytls13.h`を参照してください。

このプロファイル向けに、単一プロセスで完結するTLS 1.3ハンドシェイクのスモークテストが`examples/tls13/tls13_memio.c`に用意されています。
このテストはソケットやスレッドを使用せずにメモリ上でクライアントとサーバーを接続するため、サンプルプログラムやテストハーネスを利用できない小型ビルドの検証にも使用できます。

#### 推奨事項と禁止事項

* `cert`プロファイルは、既知の認証局、またはピン留めされた認証局でのみ使用してください。
  その検証は意図的に簡略化されています（名前制約なし、ASN.1の緩和、CRLなし）。
* 一般的なパブリックインターネットのPKIでは、`cert`プロファイルを使用しないでください。
* `mldsa`と`rsaverify`は、`cert`プロファイルと組み合わせて使用してください。
  これらは証明書検証用のアルゴリズムであるため、PSKの最小構成ではビルドがリンクできることを確認するだけになります。
* ベアメタル環境では、`CUSTOM_RAND_GENERATE_SEED`を通じて実際のハードウェアのエントロピー源を提供してください。
  `NO_FILESYSTEM`などを設定すると、デフォルトのシード源は存在しなくなります。
* このプロファイルをFIPSビルドと組み合わせないでください。
  これは非FIPSのフットプリントプロファイルです。
* `WOLFSSL_NO_MALLOC`を定義した状態で、標準の`make check`テストスイートが動作することを期待しないでください。
  このテストスイートはアロケーターを必要とします。
  ヒープを使用しないビルドは、リンクした上で`examples/tls13/tls13_memio.c`を実行して検証してください。
* AES-256-GCM-SHA384はSHA-384のトランスクリプトを使用することに注意してください。
  外部の事前共有鍵を使用する場合は、暗号スイート固有のPSKコールバックを通じてSHA-384用の鍵を提供するか、この暗号スイートを証明書プロファイルで使用してください。
  そうしないと、PSKバインダーが一致しません。

### `--enable-bigcache`

ビッグセッションキャッシュを有効にします。

ビッグセッションキャッシュを有効にすると、セッションキャッシュが33セッションから20,027セッションまで増加します。
デフォルトのセッションキャッシュサイズ33は、一般的なTLSクライアントと組み込みサーバーに適しています。

### `--enable-hugecache`

巨大なセッションキャッシュを有効にします。

巨大なセッションキャッシュを有効にすると、セッションキャッシュサイズが65,791セッションに増加します。
このオプションは、1分あたり13,000(1秒あたり200)を越える新規セッションを処理するような、重い負荷のかかるサーバー向けです。

### `--enable-titancache`

タイタンセッションキャッシュを有効にします（`TITAN_SESSION_CACHE`を定義します）。
デフォルトで無効です。

タイタンセッションキャッシュは200万をわずかに超えるセッションを保持でき、キャッシュの行単位のロックも有効になります。
大容量のメモリを持ち、セッションIDのタイムアウトが長く、トラフィックが多いサーバー向けです。

### `--enable-smallcache`

小さなセッションキャッシュを有効にします。

小さなセッションキャッシュを有効にすると、wolfSSLは6セッションのみを保存します。
これは、デフォルトのRAM使用量が大きすぎる組み込みクライアントやシステムに適しています。
デフォルトのキャッシュ（33セッション）は、セッションキャッシュに約13KB、クライアントキャッシュに約17KBを使用しますが、小さなキャッシュではそれぞれ約2KBと約3KBです。

### `--enable-session-cache-ref`

クライアント側における[`wolfSSL_get_session()`](group__IO.md#function-wolfssl_get_session)の非推奨の動作を復元します（`WOLFSSL_SESSION_CACHE_REF`を定義します）。
この動作では、クライアントセッションキャッシュ内のエントリへの参照が返され、その参照は`WOLFSSL`オブジェクトを解放した後も有効です。
デフォルトで無効です。
この場合、configureは`NO_SESSION_CACHE_REF`を定義し、`wolfSSL_get_session()`は`WOLFSSL`オブジェクトが所有するセッションを返します。
このセッションは、そのオブジェクトが存在する間のみ有効です。
オブジェクトの解放後も使用できるコピーを取得するには、[`wolfSSL_get1_session()`](group__Setup.md#function-wolfssl_get1_session)を使用してください。
別のオプションが既に`NO_SESSION_CACHE_REF`を定義している場合（`--enable-curl`、`--enable-wpas`、`OPENSSL_COMPATIBLE_DEFAULTS`を定義するビルドなど）、このオプションは無視され、configureが警告を表示します。
非推奨の参照を使用するコードをコンパイルすると、`WOLFSSL_SESSION_CACHE_REF_WARNED`が定義されていない限り警告が表示されます。

### `--enable-savesession`

永続的なセッションキャッシュを有効にします。

このオプションを有効にすることで、アプリケーションがwolfSSLセッションキャッシュをメモリバッファに保持(保存)して復元できるようになります。

### `--enable-savecert`

永続的な証明書キャッシュを有効にします。

このオプションを有効にすることで、アプリケーションがwolfSSL証明書キャッシュをメモリバッファに保持(保存)して復元できるようになります。

### `--enable-atomicuser`

アトミックユーザーレコードレイヤを有効にします。

このオプションを有効にすると、ユーザーアトミックレコードレイヤの処理コールバックがオンになります。
これにより、アプリケーションは独自のMAC/暗号化および復号/検証コールバックを登録することができます。

### `--enable-context-extra-user-data`

`WOLFSSL_CTX`、`WOLFSSL`、その他のオブジェクトにアプリケーションデータを格納するための「ex_data」APIを有効にします（[`HAVE_EX_DATA`](#have_ex_data)を定義します）。
デフォルトで無効ですが、多くのアプリケーション向けビルドは`HAVE_EX_DATA`を独自に有効にします。
1から9999までの数値を指定すると、オブジェクトあたりのスロット数（[`MAX_EX_DATA`](#max_ex_data)）も設定されます。
各スロットは、すべてのオブジェクトにおいてポインター1つ分の領域を確保します。

### `--enable-pkcallbacks`

公開鍵コールバックを有効にします。

このオプションを有効にすると公開鍵コールバックが有効になり、アプリケーションが独自のECC署名/検証・RSA署名/検証・暗号化/復号コールバックを登録できるようになります。

### `--enable-cert-setup-cb`

ハンドシェイク中にTLS証明書と鍵を動的にロードするコールバックを有効にします（`WOLFSSL_CERT_SETUP_CB`を定義します）。
デフォルトで無効です。

### `--enable-chain-verify-cb`

アプリケーションが、ピアの証明書チェーンの検証を独自のコールバックで置き換えられるようにします（`WOLFSSL_CHAIN_VERIFY_CB`を定義します）。
デフォルトで無効です。

### `--enable-writedup`

`WOLFSSL`オブジェクトの書き込み複製（write duplication）を有効にし、同じ接続上で1つのスレッドが読み取りを、別のスレッドが書き込みを行えるようにします（`HAVE_WRITE_DUP`を定義します）。
デフォルトで無効です。

### `--enable-sniffer`

wolfSSL Snifferのサポートを有効にします。

スニファー（SSL検査）サポートを有効にすると、SSLトラフィックパケットの収集と、正しいキーファイルを使用したそれらのパケットの復号が可能になります。

このオプションは`WOLFSSL_SNIFFER`と`WOLFSSL_STATIC_EPHEMERAL`を定義します。
ECC、RSA、Curve25519のいずれかが必要であり、スニファーのテストプログラムはlibpcapが利用可能な場合にのみビルドされます。
スニファーは、AES-GCM、AES-CCM、ChaCha20-Poly1305、AES-CBC、Camellia-CBC（および、有効にした場合は3DESとRC4、ただしどちらもデフォルトで無効です）を使用するTLS 1.2およびTLS 1.3のセッションを復号できます。
TLS 1.3のセッションのように一時的な(EC)DHE鍵交換を使用するセッションは、サーバーが静的な一時鍵（static ephemeral key）を使用している場合、またはwolfSSLを`WOLFSSL_SNIFFER_KEYLOGFILE`付きでビルドしてNSSキーログファイルを使用する場合にのみ復号できます。
詳細については、wolfSSLソースの`sslSniffer/README.md`を参照してください。

### `--enable-keylog-export`

TLSのシークレットをNSSキーログファイルにエクスポートする機能を有効にします（`WOLFSSL_SSLKEYLOGFILE`、`HAVE_SECRET_CALLBACK`、`SHOW_SECRETS`を定義します）。
デフォルトで無効です。
これは安全ではないため、本番環境では使用しないでください。
有効にすると、configureは警告を表示します。

### `--enable-aesgcm`

AES-GCMサポートを有効にします。
デフォルトで有効です。
`--disable-aesgcm`を指定すると無効になります。

AES-GCMを有効にすると、これらの暗号スイートがwolfSSLに追加されます。
wolfSSLは、速度とメモリ消費のバランスを考慮した4つの異なるAES-GCM実装を提供しています。
利用可能な場合、wolfSSLは64ビットまたは32ビット演算を使用します。
組み込みアプリケーション向けには、RAMベースのルックアップテーブル（セッションごとに8KB）を使用する高速な8ビット版があり、これは64ビット版と同等の速度を持ちます。
また、追加のRAMを消費しない低速な8ビット版もあります。
`--enable-aesgcm`のconfigureオプションは、`=4bit`、`=word32`、`=table`、`=small`のオプションで変更できます。
例: `--enable-aesgcm=table`。
デフォルトの実装は`4bit`（`GCM_TABLE_4BIT`）で、`=word`は`=yes`と同じです。

### `--enable-aesgcm-stream`

複数回の更新呼び出しで暗号化または復号を行うAES-GCMストリーミングAPIを有効にします（`WOLFSSL_AESGCM_STREAM`を定義します）。
デフォルトで無効です。

### `--enable-aesccm`

AES-CCMサポート（`HAVE_AESCCM`）を有効にします。
AESの8バイト認証を備えたCounter with CBC-MACモード（CCM-8）も含まれます。

### `--disable-aescbc`

AES-CBCはデフォルトで有効です。
`--disable-aescbc`を指定すると、AES-CBCをコンパイルアウトします（`NO_AES_CBC`を定義します）。
[`--enable-she`](#--enable-she)と`--enable-aescts`にはAES-CBCが必要です。

### `--enable-aescbc-length-checks`

入力長がAESのブロックサイズの倍数でない場合に、AES-CBCの暗号化と復号がエラーを返すようにします（[`WOLFSSL_AES_CBC_LENGTH_CHECKS`](#wolfssl_aes_cbc_length_checks)を定義します）。
デフォルトで無効です。
configureは`--enable-aescbc_length_checks`という表記も受け付けます。

### `--enable-aesecb`

AES-ECBサポートを有効にします（`HAVE_AES_ECB`を定義します）。
configureのヘルプテキストには有効と記載されていますが、デフォルトで無効です。

### `--enable-aesofb`

AES-OFBモードのサポートを有効にします。
デフォルトで無効です。

### `--enable-aescts`

AES-CTS（Ciphertext Stealing）モードのサポートを有効にします（`WOLFSSL_AES_CTS`を定義します）。
デフォルトで無効です。
AES-CBCが必要です。

### `--enable-aeseax`

AES-EAXモードのサポートを有効にします。
デフォルトで無効です。

### `--enable-aessiv`

AES-SIV（RFC 5297）のサポートを有効にします（`WOLFSSL_AES_SIV`を定義します）。
デフォルトで無効です。

### `--enable-aesxts`

AES-XTSモードを有効にします（`WOLFSSL_AES_XTS`を定義します）。
デフォルトで無効です。
旧名の`--enable-xts`も引き続き使用できます。

### `--enable-aesxts-stream`

AES-XTSストリーミングAPIを有効にします。
`--enable-aesxts`を指定した場合、`--enable-armasm`も併用しない限り、デフォルトで有効になります。

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

### `--enable-aesni-with-avx`

AES-NIに加えて、AESに追加のAVXアクセラレーションを有効にします。
デフォルトで無効です。
x86またはx86_64のホストが必要です。

### `--enable-intelasm`

IntelおよびAMDプロセッサ向けのASM高速化を有効にします。

wolfSSL用にintelasmオプションを有効にすると、プロセッサの拡張機能を活用してAESのパフォーマンスを劇的に向上させます。
この設定オプションが有効な場合に活用される命令セットには、AVX1、AVX2、BMI2、RDRAND、RDSEED、AESNI、およびADXが含まれます。
これらはIntelプロセッサに最初に導入され、AMDプロセッサも近年採用し始めています。
有効にすると、wolfSSLはプロセッサをチェックし、プロセッサがサポートする命令セットを活用します。

### `--enable-intelrand`, `--enable-intelrdseed` and `--enable-amdrdseed`

ハードウェアの乱数命令を優先的な乱数源として使用します。
`--enable-intelrand`は乱数の生成にIntel RDRANDを使用し（`HAVE_INTEL_RDRAND`）、`--enable-intelrdseed`はRNGのシードにIntel RDSEEDを使用し（`HAVE_INTEL_RDSEED`）、`--enable-amdrdseed`（別名`--enable-amdrand`）はRNGのシードにAMD RDSEEDを使用します（`HAVE_AMD_RDSEED`）。
いずれもデフォルトで無効です。

### `--disable-asm`

アセンブリコードはデフォルトで有効です。
`--disable-asm`を指定すると、すべてのアセンブリを無効にし（`TFM_NO_ASM`と`WOLFSSL_NO_ASM`を定義します）、C実装のみをビルドします。

### `--enable-all-asm`

ホストに適用可能なすべてのアセンブリによる高速化を有効にします。
たとえば、x86_64では`--enable-intelasm`、AArch64では`--enable-armasm`が有効になり、SP演算のアセンブリも有効になります。
デフォルトで無効ですが、カーネルモジュール以外をGCC互換コンパイラでビルドする場合は、[`--enable-all-crypto`](#--enable-all-crypto)によって有効になります。
`--disable-asm`、`--disable-intelasm`、`--disable-armasm`など、アセンブリを無効にするオプションとは併用できません。

### `--enable-32bit`

CPUを32ビットとして扱い（`WC_32BIT_CPU`を定義します）、コンパイラが64ビットCPUを対象としている場合でも、wolfSSLが32ビットのマシンワードを使用するようにします。
SPコードをCでビルドする場合（`--enable-sp-asm`なしの[`--enable-sp`](#--enable-spopt)）、32ビット版（`sp_c32.c`）のみがビルドされます。
デフォルトで無効です。
また、[`--enable-all-crypto`](#--enable-all-crypto)が[`--enable-all-asm`](#--enable-all-asm)を有効にしないようにし、x86_64ではconfigureが`WOLFSSL_X86_64_BUILD`を定義しないようにします。
このオプションはコンパイラフラグを追加しません。
32ビットのコードを生成するには、`./configure --enable-32bit CFLAGS="-m32" LDFLAGS="-m32"`のように、フラグもconfigureに渡してください。
`--enable-64bit`または`--enable-16bit`とは併用できません。

### `--enable-64bit`

SPコードをCでビルドする場合（`--enable-sp-asm`なしの[`--enable-sp`](#--enable-spopt)）、64ビット版（`sp_c64.c`）のみをビルドし、32ビット版（`sp_c32.c`）を除外します。
デフォルトで無効です。
configureのヘルプテキストには64ビットサポートを有効にすると記載されていますが、このオプションはマクロを定義せず、64ビットターゲットはこのオプションなしでビルドできます。
`--enable-32bit`または`--enable-16bit`とは併用できません。

### `--enable-camellia`

Camelliaサポートを有効にします。

### `--enable-aria`

ARIA暗号のサポートを有効にします（`HAVE_ARIA`を定義します）。
デフォルトで無効です。
ARIAは外部のMagicCryptoライブラリによって提供され、configureはビルドディレクトリ内の`MagicCrypto`ディレクトリにこのライブラリがあることを前提としています。

### `--enable-sm2`, `--enable-sm3` and `--enable-sm4-ecb`, `--enable-sm4-cbc`, `--enable-sm4-ctr`, `--enable-sm4-gcm`, `--enable-sm4-ccm`

中国のShangMiアルゴリズムを有効にします。
対象は、SM2楕円曲線署名と鍵交換（`WOLFSSL_SM2`、ECCが必要）、SM3ハッシュ（`WOLFSSL_SM3`）、および選択したモードのSM4ブロック暗号です。
いずれもデフォルトで無効です。
実装はwolfSSLのソースツリーには含まれておらず、別の[wolfsm](https://github.com/wolfSSL/wolfsm)リポジトリから追加します。

### `--enable-md2`

MD2サポートを有効にします。

### `--enable-nullcipher`

wolfSSL NULL暗号サポート（暗号化なし）を有効にします。

### `--enable-ripemd`

wolfSSL RIPEMD-160サポートを有効にします。

### `--enable-blake2b`

wolfSSL BLAKE2bサポートを有効にします（`HAVE_BLAKE2B`を定義します）。
後方互換性のための別名として、`--enable-blake2`も使用できます。

### `--enable-blake2s`

wolfSSL BLAKE2sサポートを有効にします。

### `--enable-sha3`

x86\_64、amd64、AArch64ではデフォルトで有効です。
その他のターゲットでも、ML-KEM（デフォルトで有効）、ML-DSA、FrodoKEM、Falconのいずれかが有効な場合は、これらがSHA-3とSHAKEを有効にするため、デフォルトで有効になります。

wolfSSL SHA3のサポートを有効にします（小型ビルドには`=small`、SHA-3のアセンブリを無効にするには`=noasm`を指定します）。

### `--enable-shake128` and `--enable-shake256`

SHAKE128およびSHAKE256の拡張可能出力関数（XOF）を有効にします。
SHA-3が有効な場合はデフォルトで有効です（FIPSビルドでは、FIPS v6以降のみ）。
ML-KEMは両方を必要とするため、これらが無効にされていても再度有効にします。

### `--disable-sha256`

SHA-256サポートを無効にします。
SHA-256はデフォルトで有効です。

### `--disable-sha384`

SHA-384サポートを無効にします。
SHA-384はデフォルトで有効です。

### `--disable-sha512`

wolfSSL SHA-512サポートを無効にします。
SHA-512はすべてのターゲットでデフォルトで有効であり、[`--enable-leanpsk`](#--enable-leanpsk)、[`--enable-leantls`](#--enable-leantls)、`--enable-16bit`によって無効になります。

### `--disable-hmac`

HMACはデフォルトで有効です。
`--disable-hmac`を指定すると、HMACをコンパイルアウトします（[`NO_HMAC`](#no_hmac)を定義します）。
TLSにはHMACが必要なため、このオプションは[`--enable-cryptonly`](#--enable-cryptonly)などのwolfCryptのみのビルドでのみ有用です。
選択したオプションがHMACを必要とする場合（wolfSSH、wolfGuard、SLH-DSAのSHA-2バリアントなど）、configureは失敗します。

### `--enable-hmac-copy`

新しいメッセージごとにパディングされた鍵を再度ハッシュする代わりに、パディングされたHMAC鍵の内側と外側のハッシュ状態を保持し、メッセージごとにそれをコピーします（[`WOLFSSL_HMAC_COPY_HASH`](#wolfssl_hmac_copy_hash)を定義します）。
同じ鍵で多数のメッセージを認証する場合に高速になりますが、`Hmac`構造体のサイズは大きくなります。
デフォルトで無効です。

### `--enable-hashflags`

SHA3-256の代わりにKeccak-256を選択するなど、実行時のオプションに使用するハッシュフラグを有効にします（[`WOLFSSL_HASH_FLAGS`](#wolfssl_hash_flags)を定義します）。
デフォルトで無効ですが、暗号コールバックを使用するビルドでは自動的に有効になります。

### `--enable-she`

SHE（Secure Hardware Extension）の鍵更新メッセージ生成のサポートを有効にします。
SHEは、ECUにおける安全な鍵管理のための車載セキュリティ規格です。
このモジュールは、SHE鍵更新メッセージ（M1-M5）をソフトウェアで生成および検証する機能を提供し、オプションで暗号コールバックを介したハードウェアへのオフロードにも対応します。

2つのモードを使用できます。

- `--enable-she=standard` - 標準のSHEサポート（`WOLFSSL_SHE`を定義します）
- `--enable-she=extended` - 標準のサポートに加えて、独自のKDF定数とメッセージヘッダーを指定するための拡張オーバーライド（`WOLFSSL_SHE`と`WOLFSSL_SHE_EXTENDED`を定義します）

モードの指定は必須です。
値を指定しない`--enable-she`（値は`yes`）では、`WOLFSSL_SHE`は定義されず、SHEのソースもビルドされません。

SHEは、依存する機能であるAES、AES-CBC、AESダイレクト、CMACを自動的に有効にします。
`--disable-aescbc`も指定した場合、configureは失敗します。

以下の定義を使用して、オプション機能をコンパイルアウトできます。

- `NO_WC_SHE_GETUID` - `wc_SHE_GetUID`コールバックをコンパイルアウトします
- `NO_WC_SHE_GETCOUNTER` - `wc_SHE_GetCounter`コールバックをコンパイルアウトします
- `NO_WC_SHE_IMPORT_M123` - `wc_SHE_ImportM1M2M3`をコンパイルアウトします
- `NO_WC_SHE_EXPORTKEY` - `wc_SHE_ExportKey`コールバックをコンパイルアウトします
- `NO_WC_SHE_LOADKEY` - `wc_SHE_LoadKey` / `wc_SHE_LoadKey_Verify`の簡易ラッパーをすべてコンパイルアウトします
- `WC_SHE_SW_DEFAULT` - ハードウェアなしでテストするための、ソフトウェアのみによるデフォルトのUIDとカウンターを有効にします

### `--enable-sessioncerts`

セッション証明書保存を有効にします。

### `--enable-keygen`

鍵生成機能を有効にします（`WOLFSSL_KEY_GEN`）。
対象は、RSA鍵生成、DSA鍵生成、DHパラメーター生成、および`wc_RsaKeyToDer()`などの鍵をDERにエクスポートする関数です。
カンマ区切りのリストも指定できます。
`all`、またはDH鍵生成を維持したままDHドメインパラメーターの生成を除外する`no-dh-params`（`WOLFSSL_NO_DH_GEN_PARAMS`を定義します）を指定できます。

### `--enable-certgen`

証明書生成機能を有効にします。

### `--enable-certgencache`

`wc_SetIssuerBuffer()`、`wc_SetSubjectBuffer()`などの関数でデコードした証明書を、呼び出しのたびにデコードし直すのではなく、呼び出し間で`Cert`構造体にキャッシュしておきます（[`WOLFSSL_CERT_GEN_CACHE`](#wolfssl_cert_gen_cache)を定義します）。
キャッシュは[`wc_SetCert_Free()`](group__ASN.md#function-wc_setcert_free)で解放します。
デフォルトで無効です。

### `--enable-certsigncb`

秘密鍵を保持するTPMやHSMで証明書に署名できるように、証明書署名コールバックAPIを有効にします（`WOLFSSL_CERT_SIGN_CB`を定義します）。
デフォルトで無効です。

### `--enable-certext`

証明書の拡張機能を有効にします。
サポートしている拡張機能については、第7章を参照してください。

### `--enable-certreq`

証明書リクエスト生成を有効にします。

### `--enable-sep`

SEP拡張機能を有効にします。

### `--enable-hkdf`

HKDF（HMAC-KDF）を有効にします。
TLS 1.3が有効な場合（デフォルト）は、自動的に有効になります。

### `--enable-hpke`

ハイブリッド公開鍵暗号（HPKE、RFC 9180）を有効にします（`HAVE_HPKE`を定義します）。
デフォルトで無効です。
HKDFも同時に有効になります。
[`--enable-ech`](#--enable-ech)はHPKEを使用します。

### `--enable-x963kdf`

X9.63 KDFサポートを有効にします。

### `--enable-srtp-kdf`

SRTPおよびSRTCPの鍵導出関数を有効にします（`WC_SRTP_KDF`を定義します）。
デフォルトで無効です。
[`--enable-srtp`](#--enable-srtp)によって有効になります。

### `--enable-cmac`

AES-CMACを有効にします（`WOLFSSL_CMAC`を定義します）。
デフォルトで無効です。
`--enable-aessiv`、`--enable-aeseax`、`--enable-cmac-kdf`、`--enable-she`など、AES-CMACを必要とするオプションによって自動的に有効になります。

### `--enable-cmac-kdf`

NIST SP 800-56Cで規定されている、AES-CMACを使用した2ステップKDFである`wc_KDA_KDF_twostep_cmac()`を有効にします（`HAVE_CMAC_KDF`を定義します）。
デフォルトで無効です。
KDFコード（`--enable-kdf`、デフォルトで有効）が必要です。

### `--enable-dsa`

デジタル署名アルゴリズム(DSA)を有効にします。

DSAはレガシーなアルゴリズムです。
FIPS 186-4ではRSAおよびECDSAと共に承認されていましたが、FIPS 186-4に代わるFIPS 186-5では、署名の生成にDSAを使用することは承認されなくなりました（署名の検証には引き続き使用できます）。
wolfSSLでは、DSAを[`--enable-all-legacy-crypto`](#--enable-all-legacy-crypto)が有効にする廃止されたFIPSアルゴリズムのグループに含めています。

### `--disable-eccshamir`

すべてのターゲットでデフォルトで有効です。
`--disable-eccshamir`を指定すると、ECC Shamir（`ECC_SHAMIR`）を無効にします。
ECC Shamirは[`--enable-lowresource`](#--enable-lowresource)によっても除外されます。

### `--disable-ecc`

ECCサポートとECC暗号スイートは、すべてのターゲットでデフォルトでwolfSSLに組み込まれます。
`--disable-ecc`を指定すると、これらを除外してビルドします。

### `--enable-ecccustcurves`

ECCカスタムカーブを有効にします。
すべてのカーブタイプを有効にするには、`=all`を指定します。

### `--enable-brainpool`

Brainpool ECC曲線を有効にします（`HAVE_ECC_BRAINPOOL`を定義します）。
`--enable-ecccustcurves`が有効な場合はデフォルトで有効であり、`--enable-ecccustcurves`が必要です。

### `--with-eccminsz=BITS`

受け入れるECC鍵の最小サイズを設定します（`ECC_MIN_KEY_SZ`）。
デフォルトは224ビット、FIPSビルドでは192ビットです。

### `--with-max-ecc-bits=BITS`

ビルドがサポートするECC鍵の最大サイズをビット単位で設定します。
112から1024の範囲で指定する必要があります。

### `--enable-compkey`

圧縮鍵のサポートを有効にします。

### `--enable-curve25519`

Curve25519を有効にします。
CURVE25519\_SMALLの場合は`--enable-curve25519=small`と指定します。

楕円曲線Curve25519は128ビットのセキュリティを提供し、ECDH鍵合意と共に使用されます。
Curve25519を有効にすると、Curve25519アルゴリズムを使用できます。
デフォルトのCurve25519は、より多くのメモリを使用し実行時間が速くなるように設計されています。
オプション`--enable-curve25519=small`を使用することで、速度は低下しますがメモリの使用量を抑えることができます。

`--enable-curve25519=nonblock`を指定すると、ノンブロッキングの鍵生成と共有秘密の計算（`WC_X25519_NONBLOCK`、小型の実装も選択されます）が追加され、`--enable-asynccrypt`と`--enable-asynccrypt-sw`が有効になります。
`--enable-curve25519=noasm`を指定すると、Curve25519とEd25519のx86\_64アセンブリを無効にします。

### `--enable-ed25519`

Ed25519を有効にします。
ED25519\_SMALLの場合は`--enable-ed25519=small`と指定します。

Ed25519オプションを有効にすると、Ed25519アルゴリズムを使用できます。
デフォルトのEd25519は、より多くのメモリを使用し実行時間が速くなるように設計されています。
オプション`--enable-ed25519=small`を使用することで、メモリの使用量を抑えることができます。
Curve25519と同様に、`small`オプションではメモリ使用量の削減と引き換えに速度が低下します。

`--enable-ed25519-stream`を指定すると、複数回の更新で検証するメッセージ向けのストリーミング検証APIが追加されます。
デフォルトで無効です。

### `--enable-curve448`

Curve448（X448）鍵合意を有効にします。
デフォルトで無効です。
`--enable-curve448=small`を指定すると、小型の実装が選択されます。

### `--enable-ed448`

Ed448署名を有効にします。
デフォルトで無効です。
`--enable-ed448=small`を指定すると小型の実装が選択され、`--enable-ed448-stream`を指定するとストリーミング検証APIが追加されます。
Ed448はSHAKE256を必要とするため、SHA-3も同時に有効になります。

### `--enable-fpecc`

固定点キャッシュECCを有効にします。

### `--enable-eccencrypt`

ECC暗号化（ECIES）を有効にします。
値として、`yes`（SEC1標準）、`geniv`（IVを生成）、`iso18033`（ISO 18033標準）、`old`（wolfSSLの当初のアルゴリズム）を指定できます。
ECCとHKDFが必要です。

### `--enable-eccsi`

ECCSI（Elliptic Curve-Based Certificateless Signatures for Identity-Based Encryption、RFC 6507）を有効にします。
デフォルトで無効です。
ECCが必要です。

### `--enable-sakke`

ペアリングベースのIDベース鍵交換であるSAKKE（Sakai-Kasahara Key Encryption、RFC 6508）を有効にします。
デフォルトで無効です。
ECCが必要です。
`--enable-sakke=small`を指定すると、より小型の実装が選択されます。

### `--enable-psk`

PSK（事前共有鍵）を有効にします。

### `--enable-cert-with-extern-psk`

TLS 1.3において、外部PSKと組み合わせた証明書認証（RFC 9973）を有効にします（`WOLFSSL_CERT_WITH_EXTERN_PSK`を定義します）。
デフォルトで無効です。
TLS 1.3と`--enable-psk`が必要であり、これらがない場合は無効になります。

### `--disable-errorstrings`

エラー文字列テーブルを無効にします。

### `--disable-errorqueue`

OpenSSL互換レイヤーをビルドする場合、OpenSSL互換のエラーキューはデフォルトで有効です。
`--disable-errorqueue`を指定すると、エラーがキューに追加されなくなります（`NO_ERROR_QUEUE`を定義します）。

### `--enable-error-queue-per-thread`

スレッドごとに1つのエラーキューを保持します（`ERROR_QUEUE_PER_THREAD`を定義します）。
スレッドローカルストレージが必要です。
configureのヘルプテキストには無効と記載されていますが、スレッドローカルストレージが利用可能で、シングルスレッドビルドでない場合はデフォルトで有効になります。

### `--enable-oldtls`

古いTLSバージョン（1.2未満）を有効にします。
デフォルトで無効です（`NO_OLD_TLS`が定義されます）。
`--enable-oldtls`を指定すると、`NO_OLD_TLS`は未定義のままになります。
`--enable-harden-tls`、`--enable-leanpsk`、`--enable-leantls`、`--enable-cryptonly`、`--enable-maxstrength`は古いTLSを無効にします。

**警告**：`--enable-oldtls`を指定したビルドは、RFC 9846、RFC 8996、RFC 9325に**準拠していません**。
RFC 8996はTLS 1.0とTLS 1.1を非推奨としており、RFC 9846はSSL 2.0、SSL 3.0、TLS 1.0、TLS 1.1について「MUST NOT be negotiated for any reason」（いかなる理由があってもネゴシエートしてはならない）と規定しています。

### `--enable-tlsv10`

TLSバージョン1.0を有効にします（`WOLFSSL_ALLOW_TLSV10`を定義し、古いTLSを有効にします）。

**警告**：`--enable-tlsv10`を指定したビルドは、RFC 9846、RFC 8996、RFC 9325に**準拠していません**。
上記の[`--enable-oldtls`](#--enable-oldtls)を参照してください。

### `--enable-sslv3`

SSLバージョン3.0を有効にします（`WOLFSSL_ALLOW_SSLV3`を定義し、古いTLSを有効にします）。

**警告**：`--enable-sslv3`を指定したビルドはRFC 7568に違反します。
SSL 3.0はRFC 7568で非推奨とされており、同RFCは「SSLv3 MUST NOT be used.」（SSLv3を使用してはならない）と規定しています。

### `--enable-stacksize`

サンプルプログラムでのスタックサイズ情報を有効にします。

### `--disable-memory`

メモリコールバックを無効にします。

### `--enable-trackmemory`

wolfCryptとwolfSSLのクリーンアップ時に、メモリ使用状況を出力します（`WOLFSSL_TRACK_MEMORY`を定義し、`=verbose`を指定すると`WOLFSSL_TRACK_MEMORY_VERBOSE`も定義します）。
デフォルトで無効です。
wolfSSLのメモリコールバックが必要です（`--disable-memory`を使用しないでください）。

### `--enable-memorylog`

動的メモリ割り当てをログに記録します（`WOLFSSL_MEMORY_LOG`を定義します）。
デフォルトで無効です。

### `--enable-stacklog`

コンパイラの関数インストルメンテーションを使用して、スタック使用量をログに記録します（`WOLFSSL_STACK_LOG`を定義し、`-finstrument-functions`を追加します）。
デフォルトで無効です。

### `--disable-rsa`

RSAを無効にします。

### `--enable-rsapss`

RSA-PSSを有効にします。
RSAとTLS 1.3が有効な場合（デフォルト）は自動的に有効になり、`WC_RSA_PSS`と`WOLFSSL_PSS_LONG_SALT`を定義します。

### `--disable-oaep`

RSA OAEPパディングを無効にします。
OAEPはデフォルトで有効です。

### `--with-max-rsa-bits=BITS`

ビルドがサポートするRSA、DH、DSA鍵の最大サイズをビット単位で設定します。
1024から16384の間で指定する必要があります。

### `--disable-dh`

DHを無効にします。

### `--enable-ffdhe-only`

TLSクライアントが、サーバーのDHパラメータとして名前付きFFDHEグループ（RFC 7919）のみを受け入れるようにします。
サーバーがそれ以外のDHパラメータを送信した場合、クライアントは致命的な`handshake_failure`アラートを送信し、接続は`DH_PARAMS_NOT_FFDHE_E`で失敗します（`WOLFSSL_REQUIRE_FFDHE`を定義します）。
デフォルトでは無効です。
DHとSupported Curves拡張機能が必要です。

### `--enable-anon`

匿名認証を有効にします。

### `--disable-asn`

ASNを無効にします。

ASN.1サポートはデフォルトで有効で、テンプレートベースの実装を使用します。
このオプションにはカンマ区切りのリストも指定できます。
指定できる値は、`template`（または`yes`、デフォルト）、`original`（テンプレートを使用しない旧来のコードで、`WOLFSSL_ASN_ORIGINAL`を定義します）、`nocrypt`（`NO_ASN_CRYPT`を定義し、パスワードベースの暗号を無効にします）、`all`（すべてのASN.1機能を有効にし、`WOLFSSL_ASN_ALL`を定義します）、`no`です。
`--disable-asn`は、`--disable-rsa`と`--enable-psk`を併せて指定した場合にのみconfigureで受け付けられます。

### `--enable-asn-print`

DERエンコードされたデータの構造を出力するASN.1プリントAPIを有効にします（[`WOLFSSL_ASN_PRINT`](#wolfssl_asn_print)を定義します）。
サンプルプログラムが有効な場合は、`examples/asn1`および`examples/pem`ツールもビルドされます。
ホストがLinux、macOS、FreeBSDの場合はデフォルトで有効で、その他のホストでは無効です。
ただし、configureのヘルプテキストには常にデフォルトで有効と記載されています。

### `--enable-acert`

属性証明書のサポートを有効にします（`WOLFSSL_ACERT`を定義します）。
デフォルトでは無効です。

### `--disable-pkcs8`

PKCS #8鍵パッケージを無効にします（`NO_PKCS8`を定義します）。
PKCS #8はデフォルトで有効です。

### `--enable-enckeys`

PEM形式の暗号化された秘密鍵のサポートを有効にします（`WOLFSSL_ENCRYPTED_KEYS`を定義します）。
デフォルトでは無効です。

### `--enable-ip-alt-name`

IPアドレスのサブジェクト代替名（Subject Alternative Name）を有効にします（`WOLFSSL_IP_ALT_NAME`を定義します）。
デフォルトでは無効です。

### `--enable-indef`

不定長エンコーディングを使用したBERメッセージの解析を有効にします（`ASN_BER_TO_DER`を定義します）。
デフォルトでは無効です。

### `--disable-aes`

AESを無効にします。

### `--disable-coding`

Base16/64コーディングを無効にします。

### `--enable-base64encode`

x86\_64ではデフォルトで有効になっています。

Base64エンコーディングを有効にします。

### `--enable-base16`

Base16（16進数）のエンコードとデコード、[`Base16_Encode()`](group__Base__Encoding.md#function-base16_encode)と[`Base16_Decode()`](group__Base__Encoding.md#function-base16_decode)を有効にします（`WOLFSSL_BASE16`を定義します）。
デフォルトでは無効ですが、`settings.h`は`OPENSSL_EXTRA`、Webサーバー、FIPS、暗号化鍵、その他いくつかの機能が有効な場合にこれを有効にします。
また、configureは`--enable-openssh`およびSM2の場合にこれを有効にします。

### `--enable-des3`

DES3を有効にします。
デフォルトでは無効です。
FIPS 140-3を使用する場合を除き、一部のアプリケーション向けビルド（例えば`--enable-openssh`、`--enable-openvpn`、`--enable-wpas`）では自動的に有効になります。
3DESのTLS暗号スイートには、`--enable-des3-tls-suites`も必要です。

### `--enable-arc4`

ARC4を有効にします。

### `--enable-rc2`

RC2暗号を有効にします（[`WC_RC2`](#wc_rc2)を定義します）。
主に、RC2を使用するレガシーなPKCS#12ファイルを読み込むために使用します。
デフォルトでは無効です。

### `--enable-md5`

MD5を有効にします。
デフォルトでは無効です。
`--enable-opensslextra`、`--enable-opensslall`、`--enable-oldtls`、`--enable-des3`、およびいくつかのアプリケーション向けビルドによって自動的に有効になります。
MD5が無効な場合、`NO_MD5`と`NO_OLD_TLS`が定義されます。

### `--disable-sha`

SHAを無効にします。

### `--enable-webserver`

Webサーバーを有効にします。

これにより、yaSSL Embedded Web Serverでビルドする際に完全な機能を利用できるよう、標準ビルドに加えて必要な機能がオンになります。

### `--enable-webclient`

`wolfio.c`の小規模なHTTPクライアントAPI（例えば`wolfIO_DecodeUrl()`、`wolfIO_HttpBuildRequest()`、`wolfIO_HttpProcessResponse()`）を有効にします（`HAVE_HTTP_CLIENT`を定義します）。
デフォルトでは無効です。
OCSPとCRLのI/O（[`--enable-ocsp`](#--enable-ocsp)、`--enable-crl=io`）は、`WOLFSSL_USER_IO`が定義されていない限り、これを有効にします。

### `--enable-fips`

FIPS 140-2 / 140-3を有効にします（別途、ライセンス契約が必要です）。
`v7`、`ready`、`dev`などのモジュールバージョンを値として指定します。
立ち上げやデバッグ向けには`--enable-fips=dev-no-post`（wolfSSL 5.9.4で追加）があり、電源投入時セルフテスト（POST）を行わない開発用FIPSモジュールをビルドします。

wolfSSL 5.9.4では、FIPSの動作にいくつかの変更が加わりました。
HMAC-MD5は拒否されます。
IVが12バイトより短いAES-GCM暗号化は`FIPS_BAD_VALUE_E`を返します（`WC_FIPS_AESGCM_ALLOW_SHORT_NONCES`で上書きできます）。
CMACタグには少なくとも64ビットが必要です。
また、ハッシュより長いRSA-PSSソルトは拒否されます（FIPS 186-5）。
さらに、FIPS 140-3（v5以降）のビルドでは`--enable-wolfclu`がMD5やDES3を有効にしなくなり、FIPSビルドではASN.1チェックを緩和（`WOLFSSL_NO_ASN_STRICT`）しなくなりました。
`--enable-wolfclu`は、非FIPSビルドとFIPS v6以降ではEd25519を有効にします。

### `--enable-sha224`

x86\_64、amd64、AArch64ではデフォルトで有効になっています。
ただし、AF\_ALGまたは`/dev/crypto`を使用する場合、およびFIPS v2以外のFIPSビルドでは有効になりません。

wolfSSL SHA-224サポートを有効にします。

### `--disable-poly1305`

wolfSSL Poly1305サポートを無効にします。

### `--disable-chacha`

ChaChaを無効にします。

### `--enable-xchacha`

ChaChaの拡張ノンス版であるXChaChaを有効にします（`HAVE_XCHACHA`を定義します）。
デフォルトでは無効です。
ChaChaが必要です。

### `--enable-ascon`

Ascon軽量暗号（Ascon-Hash256およびAscon-AEAD128）を有効にします（`HAVE_ASCON`を定義します）。
デフォルトでは無効です。

### `--enable-siphash`

SipHashを有効にします（`WOLFSSL_SIPHASH`を定義します）。
デフォルトでは無効です。

### `--disable-hashdrbg`

ハッシュDRBGサポートを無効にします。

### `--disable-sha256-drbg`

SHA-256ハッシュDRBG（NIST SP 800-90A）はデフォルトでビルドされます。
`--disable-sha256-drbg`を指定するとこれを除外し（`WOLFSSL_NO_SHA256_DRBG`を定義します）、SHA-512ハッシュDRBGのみが利用可能になります。
両方のハッシュDRBGを無効にした場合、[`--disable-hashdrbg`](#--disable-hashdrbg)と同様にハッシュDRBGは無効になります。
FIPSビルドではビルド時に無効にすることはできません。
SHA-512ハッシュDRBGも備えるFIPS v7では、代わりに実行時関数`wc_Sha256Drbg_Disable()`を使用してください。

### `--disable-sha512-drbg`

SHA-512ハッシュDRBG（NIST SP 800-90A、`WOLFSSL_DRBG_SHA512`を定義します）は、SHA-512が有効な場合にデフォルトでビルドされます。
この場合、新しい`WC_RNG`オブジェクトは、実行時に`wc_Sha512Drbg_Disable()`で無効にされない限り、SHA-256ハッシュDRBGではなくSHA-512ハッシュDRBGを使用します。
`--disable-sha512-drbg`を指定するとこれを除外し、RNGはSHA-256ハッシュDRBGを使用します。
SHA-512が無効な場合、`--enable-selftest`を指定した場合、およびv7より前のFIPSモジュールバージョンでは常に無効です。
FIPS v7ビルドではビルド時に無効にすることはできません。
代わりに実行時に`wc_Sha512Drbg_Disable()`を使用してください。

### `--disable-filesystem`

ファイルシステムのサポートを無効にします。

これにより、ファイルシステムの使用を無効にできます。
このオプションは[`NO_FILESYSTEM`](#no_filesystem)を定義します。

### `--disable-inline`

インライン関数を無効にします。

このオプションを無効にすると、wolfSSLの関数インライン化が無効になります。
インライン関数は、呼び出されるのではなく呼び出し箇所で展開されます。
このオプションは`NO_INLINE`を定義してインライン化を無効にし、これによりコードサイズを削減できる場合があります。
`--enable-c89`を使用した場合はこれがデフォルトです。

### `--disable-optflags`

GCC互換コンパイラを使用し、かつ[`--enable-debug`](#--enable-debug)と[`--enable-distro`](#--enable-distro)のいずれも使用しない場合、configureはデフォルトの最適化フラグを追加します。
fast mathビルドおよびsmallではないSP mathビルドでは`-O2`、それ以外では`-Os`です。
`--disable-optflags`を指定するとこれらのフラグを追加しないため、最適化レベルはユーザー自身が指定した`CFLAGS`のみによって決まります。

### `--disable-aligndata`

暗号のデータアライメントはデフォルトで有効で（`WOLFSSL_USE_ALIGN`を定義します）、AES鍵スケジュールやGCMテーブルなどのバッファがアラインされます。
`--disable-aligndata`でこれを無効にできますが、AES-NI、ARMおよびIntelのアセンブリコード、Xilinx、アラインされていないアクセスをサポートしないARMターゲットについては、`wolfssl/wolfcrypt/types.h`が引き続きこれを定義します。

### `--enable-ocsp`

オンライン証明書ステータスプロトコル(OCSP)を有効にします。

このオプションを有効にすると、OCSP(Online Certificate Status Protocol)サポートがwolfSSLに追加されます。
[RFC 6960](https://tex2e.github.io/rfc-translater/html/rfc6960)に記載されているように、X.509証明書の失効状態を取得するために使用されます。

### `--enable-ocsp-responder`

OCSP応答を作成するためのOCSPレスポンダーAPIを有効にします（`HAVE_OCSP_RESPONDER`を定義します）。
デフォルトでは無効です。

### `--enable-ocspstapling`

OCSPステープリングを有効にします。
TLS1.3使用時、Certificateメッセージへの複数OCSP Staplingを無効にするには`=no-multi`を指定します。

### `--enable-ocspstapling2`

OCSPステープリングバージョン2を有効にします。

### `--enable-crl`

CRL(証明書失効リスト)を有効にします。
`--enable-crl=io`を指定すると、HTTP GETによるインラインのCRL取得（`HAVE_CRL_IO`）も有効になります。

### `--enable-crl-monitor`

CRLモニターを有効にします。

このオプションを有効にすると、特定のCRL(証明書の失効リスト)ディレクトリを積極的に監視する機能が追加されます。

### `--enable-altcertchains`

代替証明書チェーンを有効にします（`WOLFSSL_ALT_CERT_CHAINS`を定義します）。
ピア（リーフ）証明書のみが信頼済みCAまで検証できればよく、ピアのチェーン内に既知の署名者がいないCA証明書があってもエラーとして扱いません。
デフォルトでは無効です。

### `--enable-sni`

サーバー名表示を有効にします(SNI)。

このオプションを有効にすると、TLSサーバー名表示(SNI)拡張機能がオンになります。
x86\_64、x86、aarch64、amd64ではデフォルトで有効です（無効にするには`--disable-sni`を使用します）。
`--enable-qt`と`--enable-quic`では強制的に有効になります。

### `--enable-maxfragment`

最大フラグメント長を有効にします。

このオプションを有効にすると、TLSの最大フラグメント長拡張機能がオンになります。

### `--enable-alpn`

アプリケーションレイヤープロトコルネゴシエーション(ALPN)を有効にします。

### `--enable-truncatedhmac`

切り詰められたキー付きハッシュMAC（HMAC）を有効にします。

このオプションを有効にすると、TLS切り詰めHMAC拡張機能がオンになります。

### `--enable-trustedca`

TLS Trusted CA Indication拡張機能を有効にします（`HAVE_TRUSTED_CA`を定義します）。
デフォルトでは無効です。
[`--enable-tlsx`](#--enable-tlsx)によって有効になります。

### `--enable-renegotiation-indication`

再ネゴシエーションの表示を有効にします。

これはクライアント専用の「疑似的な」安全な再ネゴシエーションです（`HAVE_RENEGOTIATION_INDICATION`を定義します）。
クライアントはシグナリング用の暗号スイート`TLS_EMPTY_RENEGOTIATION_INFO_SCSV`を送信しますが、再ネゴシエーションは行いません。
`--enable-secure-renegotiation`と組み合わせることはできず、`--enable-secure-renegotiation-info`を無効にします。
再ネゴシエーションを実行するTLS接続に結び付けることで再ネゴシエーションスプライシング攻撃を防ぐ、[RFC 5746](https://tex2e.github.io/rfc-translater/html/rfc5746)の`renegotiation_info`拡張の処理は、`--enable-secure-renegotiation-info`（デフォルトで有効）によって提供されます。

### `--enable-secure-renegotiation`

安全な再ネゴシエーションを有効にします。

### `--disable-secure-renegotiation-info`

TLS 1.2では、RFC 5746の`renegotiation_info`拡張がデフォルトで有効です（`HAVE_SERVER_RENEGOTIATION_INFO`を定義します）。
`--disable-secure-renegotiation-info`でこれを無効にします。
TLS 1.2またはASN.1が無効な場合、および`--enable-renegotiation-indication`を指定した場合も無効になります。

### `--enable-legacy-server-connect`

デフォルトでは、TLS 1.2クライアントは、最初のハンドシェイクでサーバーが`renegotiation_info`拡張に応答することを要求します（RFC 5746、RFC 9325）。
このオプションを指定すると、安全な再ネゴシエーションをサポートしないレガシーサーバーへの接続も許可します（`WOLFSSL_ALLOW_LEGACY_SERVER_CONNECT`を定義します）。
デフォルトでは無効で、推奨されません。
`--enable-harden-tls`と組み合わせることはできません。

### `--disable-supportedcurves`

TLSサポート楕円曲線（Supported Elliptic Curves）拡張機能はデフォルトで有効です。
`--disable-supportedcurves`でこれを無効にします。
ECC、Curve25519、Curve448がすべて無効な場合も自動的に無効になります。

### `--enable-session-ticket`

セッションチケットを有効にします。

### `--enable-ticket-nonce-malloc`

TLS 1.3のセッションチケットのノンスを動的に割り当て、組み込みのバッファより長いノンスを保存できるようにします（[`WOLFSSL_TICKET_NONCE_MALLOC`](#wolfssl_ticket_nonce_malloc)を定義します）。
デフォルトでは無効ですが、`--disable-ticket-nonce-malloc`が指定されていない限り、`--enable-curl`によって有効になります。

### `--disable-extended-master`

拡張マスターシークレットはデフォルトで有効です（`--enable-cryptonly`では無効です）。
`--disable-extended-master`でこれを無効にします。

### `--disable-enc-then-mac`

TLS Encrypt-then-MAC拡張機能はデフォルトで有効です（`HAVE_ENCRYPT_THEN_MAC`を定義します）。
`--disable-enc-then-mac`でこれを無効にします。

### `--enable-keying-material`

RFC 5705のTLS鍵マテリアルエクスポーター（keying material exporter）を有効にします（`HAVE_KEYING_MATERIAL`を定義します）。
デフォルトでは無効です。
`--enable-srtp`、`--enable-chrony`、`--enable-wpas`、`--enable-openvpn`など、これを必要とするオプションによって有効になります。

### `--enable-ech`

TLS 1.3 Encrypted Client Hello（ECH）を有効にします（`HAVE_ECH`を定義します）。
デフォルトでは無効です。
明示的に無効にされていない限り、HPKE、ECC、Curve25519、SHA-256、SNI、TLS 1.3も有効にします。

### `--enable-rpk`

TLSでの生の公開鍵（Raw Public Keys、RFC 7250）を有効にします（`HAVE_RPK`を定義します）。
デフォルトでは無効です。

### `--enable-tlsx`

すべてのTLS拡張機能を有効にします。

SNI、最大フラグメント長、切り詰めHMAC、ALPN、Trusted CA Indication、Encrypt-then-MAC、Supported Curvesを有効にします。
セッションチケット、OCSPステープリング、ECH、早期データ、およびその他の拡張機能には、それぞれ個別のオプションがあります。

### `--enable-pkcs7`

PKCS#7サポートを有効にします。

### `--enable-smime`

S/MIMEサポートを有効にします（[`HAVE_SMIME`](#have_smime)を定義します）。
デフォルトでは無効ですが、[`--enable-enterprise`](#--enable-enterprise)と`--enable-all-osp`によって有効になります。
また、PKCS#7と完全なOpenSSL互換レイヤー（[`--enable-opensslall`](#--enable-opensslall)）も有効にし、ASN.1サポートを必要とします。

### `--enable-pkcs11`

PKCS#11アクセスを有効にします。

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

### `--enable-smallstackcache`

[`--enable-smallstack`](#--enable-smallstack)と併用すると、small stackのコードが呼び出しごとに割り当てる作業用バッファ（例えばSHA-256、RSA、RNGで使用するもの）を、オブジェクトの存続期間中、オブジェクト内に割り当てたままにします（`WOLFSSL_SMALL_STACK_CACHE`を定義します）。
メモリを多く使用する代わりに、割り当て回数を減らします。
`--enable-smallstack`なしでは効果はありません。
デフォルトでは無効ですが、カーネルモジュールビルドではデフォルトで有効です。

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

証明書サービス（Windows Server）を有効にします。

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

サンプルプログラムのビルドを有効にすると、wolfSSLのサンプルアプリケーション（クライアント、サーバー、エコークライアント、エコーサーバー）がビルドされます。
詳細は、[第3章 入門](chapter03.md)の「クライアントサンプルプログラム」、「サーバーサンプルプログラム」、「エコークライアントのサンプルプログラム」、「エコーサーバーのサンプルプログラム」節をご参照ください。

### `--disable-crypttests`

暗号ベンチマーク/テストを無効にします。

### `--disable-benchmark`

wolfCryptベンチマークプログラム（`wolfcrypt/benchmark/benchmark`）は、デフォルトでwolfCryptテストと共にビルドされます。
`--disable-benchmark`を指定すると、ベンチマークプログラムを除いてテストをビルドします。
カーネルモジュールビルドでは無効になります。

### `--enable-staticmemory`

静的メモリ使用を有効にします。

### `--enable-mcapi`

マイクロチップAPIを有効にします。

### `--enable-asynccrypt`

非同期暗号を有効にします。

ハードウェアバックエンド（Cavium、Intel QuickAssist、暗号コールバック、PKコールバック）が有効になっていない場合は、ソフトウェアシミュレータ（`WOLFSSL_ASYNC_CRYPT_SW`、[`--enable-asynccrypt-sw`](#--enable-asynccrypt-sw)を参照）も有効になります。

### `--disable-asyncthreads`

[`--enable-asynccrypt`](#--enable-asynccrypt)と併用すると、非同期暗号レイヤーのPOSIXスレッドヘルパー（`wc_AsyncThreadCreate()`および関連関数で、例えばIntel QuickAssistポートで使用されます）をビルドし、`-lpthread`とリンクします。
POSIXスレッドライブラリが見つかった場合はデフォルトで有効です。
`--disable-asyncthreads`を指定すると、非同期暗号を使用しないビルドと同様に、代わりに`WC_NO_ASYNC_THREADING`を定義します。

### `--enable-sessionexport`

セッションのエクスポートとインポートを有効にします。

### `--enable-aeskeywrap`

AESキーラップサポート（RFC 3394）を有効にします。
パディング付きAESキーラップ（RFC 5649）もビルドするには、`--enable-aeskeywrap=padding`を指定します。
これは`wc_AesKeyWrap_Pad()`と`wc_AesKeyWrap_Pad_ex()`によって提供され、暗号コールバックをサポートします。
パディング付きAESキーラップはwolfSSL 5.9.4で追加されました。

### `--enable-jobserver`

値：`yes`(デフォルト)/ `no`/`#`

`make`を使用する場合、マルチスレッドビルドを使用してwolfSSLをビルドします。
`yes`（デフォルト）はCPUコアの数を検出し、そのカウントに対して推奨されるジョブ数を使用してビルドします。
これは`make -j`オプションと同様に機能します。
手動で固定値を指定したい場合には、その値を使用します。

### `--enable-shared[=PKGS]`

wolfSSLライブラリを共有ライブラリとしてビルドします。
デフォルトで有効です。

共有ライブラリビルドを無効にすると、wolfSSL共有ライブラリがビルドされるのを除外します。
デフォルトでは、時間とスペースを節約するために共有ライブラリのみがビルドされています。

### `--enable-static[=PKGS]`

wolfSSLライブラリをスタティックライブラリとしてビルドします。
デフォルトでは無効です。
使用する場合はこのオプションを指定してください。

### `--with-libsuffix=SUFFIX`

ライブラリ名に`SUFFIX`を追加します。
例えば、`--with-libsuffix=custom`を指定すると、`libwolfssl.so`の代わりに`libwolfsslcustom.so`がビルドされます（スタティックライブラリも同様です）。
デフォルトでは設定されていません。

### `--with-liboqs=PATH`

wolfSSL 5.9.4以降、このオプションは非推奨となり、無視されます。
liboqsのサポートは削除されました。
liboqsを使用していた最後のアルゴリズムであるFalconには、wolfCryptのネイティブ実装があり、[`--enable-falcon`](#--enable-falcon)で有効にできます。
このオプションを指定しても、configureの警告が表示されるだけです。
詳細については、本ドキュメントの[付録I ポスト量子暗号の実験](appendix09.md)をご参照ください。

### `--with-wnr=PATH`

Whitewood netRandomのサポートは削除されました。
configureは引き続きこのオプションを受け付けますが、指定すると「Whitewood netRandom support has been removed」というエラーで停止します（`--without-wnr`はエラーなく受け付けられます）。

### `--with-libz=PATH`

オプションで圧縮用にlibzを含めます。

libzを有効にすると、libzライブラリからの圧縮サポートがwolfSSLで可能になります。
このオプションを含めて[`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression)を呼び出すことについては、よくご検討ください。
送信前にデータを圧縮すると、送受信されるメッセージの実際のサイズが減少します。
しかし、圧縮されたデータはほとんどのネットワークにおいて、そのまま送信するよりも分析に時間がかかります。

### `--with-cavium`

cavium/softwareディレクトリへのパス。

### `--with-cavium-v`, `--with-octeon-sync` and `--with-intelqa`

その他の非同期暗号ハードウェアのバックエンドで、それぞれベンダーソフトウェアへのパスを指定します。
`--with-cavium-v=PATH`はCavium Nitrox V用、`--with-octeon-sync=PATH`はCavium Octeon SDK（同期的な使用）用、`--with-intelqa=PATH`はIntel QuickAssist（QAT）ドライバー用です。

### `--with-intelqa-sync=PATH`

`PATH`にあるIntel QuickAssist（QAT）ドライバーを、非同期暗号レイヤーではなく暗号コールバックを通じて同期的に使用します（`HAVE_INTEL_QA_SYNC`を定義し、`wolfcrypt/src/port/intel/quickassist_sync.c`をビルドします）。
デフォルトでは設定されていません。
[`--enable-cryptocb`](#--enable-cryptocb)が必要で、`--with-intelqa`と組み合わせることはできません。

### `--enable-rsavfy`

RSA検証のみのサポートを有効にします。

**注意**:  [`--enable-cryptonly`](#--enable-cryptonly)が必要です。

### `--enable-rsapub`

RSA公開鍵のみのサポートを有効にします。

**注意**:  [`--enable-cryptonly`](#--enable-cryptonly)が必要です。

### `--enable-armasm`

ARMv8 ASMサポートを有効にします。
ARMv7-MなどのThumb2ターゲットを含む、32ビットARMにも対応しています。

デフォルトの構成は、64か32ビットシステムに基づいてmcpuまたはmfpuを設定します。
CPPFLAGSを使用して渡されたmcpuまたはmfpu設定を上書きしません。
一部のコンパイラでは、制約のために`-mstrict-align`が必要になる場合があり、`CPPFLAGS`でユーザーがmcpu/mfpuフラグを渡さない限り、`-mstrict-align`もデフォルトで設定されます。

このオプションには、以下のサブオプションをカンマ区切りのリストで指定できます。

* `inline`: インラインアセンブリ版を使用します。
* `no-crypto`: ARMv8暗号拡張命令を使用しません。
* `sha512-crypto` / `sha3-crypto`（AArch64のみ）: SHA-512およびSHA-3命令（ARMv8.2-A）を使用します。`no-sha512-crypto` / `no-sha3-crypto`で無効にします。
* `sm3`、`sm4`（AArch64のみ）: SM3およびSM4命令を使用します。
* `barrier-sb`、`barrier-detect`（AArch64のみ）: SB投機バリア命令（ARMv8.5-A以降）を、常に使用するか、実行時に検出された場合に使用します。
* `sha256-small`、`aes-block-dup`（32ビットARMのみ）: より小さいSHA-256コード、および複製（インライン化）したAESブロックコードを使用します。
* `no-base`、`no-neon-impl`（32ビットARMのみ）: 暗号拡張が常に存在する場合に、ベースおよびNEONの実行時フォールバックを除外します。

### `--with-arm-target=TARGET`

32ビットARMホスト向けに、SP数学コードのARMバリアントを選択します。
`thumb`はThumbコード（`WOLFSSL_SP_ARM_THUMB`、または[`--enable-sp-asm`](#--enable-sp-asm)と併用した場合は`WOLFSSL_SP_ARM_THUMB_ASM`）を使用し、`-mthumb -march=armv6`を追加します。
`cortex`はCortex-MのCコード（`WOLFSSL_SP_ARM_CORTEX_M`）を使用し、`-mcpu=cortex-r5`を追加します。
デフォルトでは設定されていません。
他のホストでは、このオプションは何もしません。

### `--enable-riscv-asm`

RISC-Vアセンブリを有効にします。
デフォルトで無効です。
使用する命令セット拡張をカンマ区切りのリストで指定します。
例えば、`zbb`、`zbc`、`zbkb`、`zkned`、`zv`、およびベクトル暗号拡張の`zvbb`、`zvbc`、`zvkg`、`zvkned`などを指定できます。

### `--enable-ppc32-asm` and `--enable-ppc64-asm`

PowerPC 32ビットまたは64ビットのアセンブリを有効にします。
デフォルトで無効です。
どちらも`inline`、`inline-reg`、`small`を指定できます。
さらに、`--enable-ppc32-asm`では`spe`を、`--enable-ppc64-asm`では`crypto`と`power8`を指定できます。

### `--disable-tlsv12`

TLS 1.2のサポートを無効にします。
wolfSSL 5.9.4以降では、このオプションによって[`WOLFSSL_NO_TLS12`](#wolfssl_no_tls12)が定義され、TLS 1.2の実装がコンパイルから除外されます。
それ以前のバージョンでは、このオプションはconfigureのサマリー表示を変更するだけで、ピアは引き続きTLS 1.2をネゴシエートできました。

### `--disable-tls13`

TLS 1.3のサポートはデフォルトで有効です。
`--disable-tls13`を指定すると、TLS 1.3なしでビルドします。

使用可能な鍵交換が存在しない場合（ECC、RSAとDH、Curve25519とEd25519、Curve448とEd448、PSK、ML-KEMのいずれもない場合）も、TLS 1.3は自動的に無効になります。
TLS 1.3のみのwolfSSLビルドを生成するには、[`--disable-tlsv12`](#--disable-tlsv12)を使用してください。
古いバージョンのTLSは、すでにデフォルトで無効になっています。

### `--enable-tls13-draft18`

古いビルドスクリプトが引き続き動作するように受け付けられますが、何も行いません。
wolfSSLは最終版のTLS 1.3（RFC 8446）のみを実装しています。
configureのヘルプテキストでは、現在もTLS 1.3ドラフト18を有効にするオプションとして説明されています。

### `--enable-earlydata`

TLS 1.3の早期データ（0-RTT）を有効にし、`WOLFSSL_EARLY_DATA`を定義します。
デフォルトで無効です。
TLS 1.3と、セッションチケットまたはPSKが必要です。
`--enable-earlydata=group`を指定すると、早期データをClientHelloと一緒に送信します（`WOLFSSL_EARLY_DATA_GROUP`）。

### `--enable-postauth`

TLS 1.3のポストハンドシェイク認証を有効にします（`WOLFSSL_POST_HANDSHAKE_AUTH`を定義します）。
デフォルトで無効です。

### `--enable-hrrcookie`

TLS 1.3のHelloRetryRequestで、サーバーが自身の状態を保持するCookie拡張を送信できるようにします（`WOLFSSL_SEND_HRR_COOKIE`を定義します）。
クライアントは、受信したCookieを常にエコーバックします。
TLSではデフォルトで無効ですが、[`--enable-dtls13`](#--enable-dtls13)によって有効になります。

### `--enable-tls13-middlebox-compat`

クライアント側のTLS 1.3ミドルボックス互換モード（RFC 8446 Appendix D.4）を有効にします。
このモードでは、クライアントはダミーのセッションIDとChangeCipherSpecメッセージを送信します。
サーバー側は常に有効です。
デフォルトで無効で、ECHとは併用できません。

### `--enable-quic`

TLS 1.3上のQUIC APIを有効にします（`WOLFSSL_QUIC`を定義します）。
デフォルトで無効です。
TLS 1.3とAES-GCMが必要で、OpenSSL互換レイヤー、AES-CTR、ALPN、SNI、および（FIPSビルド以外では）Curve25519を有効にします。

### `--disable-tls`

TLSのサポートはデフォルトで有効です。
`--disable-tls`を指定するとTLSレイヤーなしでビルドし（`NO_TLS`を定義します）、DTLSもデフォルトで無効になります。
[`--enable-cryptonly`](#--enable-cryptonly)もTLSを無効にします。

### `--enable-all`

SSL v3を除くすべてのwolfSSL機能を有効にします。

### `--enable-enterprise`

デフォルトのOpenSSLビルドに匹敵する、相互運用性を最大限に高めた機能セットを有効にします。
デフォルトで無効です。
[`--enable-all`](#--enable-all)と[`--enable-all-quantum-crypto`](#--enable-all-quantum-crypto)を有効にしますが、RC2とDES3は明示的に指定しない限り無効のままです。

### `--enable-all-crypto`

耐量子非対称アルゴリズムを除く、すべてのwolfCryptアルゴリズムを有効にします（耐量子非対称アルゴリズムには[`--enable-all-quantum-crypto`](#--enable-all-quantum-crypto)を使用してください）。
wolfSSL 5.9.4から、このオプションはFIPSビルドに非FIPSアルゴリズムやレガシーアルゴリズムを取り込まなくなりました。
それらのアルゴリズムは、以下の2つのバンドルに移されました。
`--enable-all-crypto`と併せてこれらを明示的に有効または無効にすることで、差し引きによる選択ができます。

### `--enable-all-nonfips-crypto`

FIPS承認されていないすべてのwolfCryptアルゴリズムを有効にします。
デフォルトで無効です。

### `--enable-all-legacy-crypto`

すべてのレガシーwolfCryptアルゴリズムを有効にします。
デフォルトで無効です。

### `--enable-all-quantum-crypto`

耐量子非対称アルゴリズム（ML-KEM、ML-DSA、SLH-DSA、LMS、XMSS）をすべて有効にします。
デフォルトで無効です。
`--enable-experimental`と併用すると、FrodoKEM、Falcon、および追加のPQ/Tハイブリッドグループも有効にします（追加のハイブリッドグループは、非FIPSビルドまたはv7より前のFIPSビルドでのみ有効になります）。

### `--enable-asio`

ASIOを有効にします。

一緒に[`--enable-opensslextra`](#--enable-opensslextra)と[`--enable-opensslall`](#--enable-opensslall)を有効にする必要があります。
これら2つのオプションが有効になっていない場合、autoconfツールは自動的にこれらのオプションを有効にします。

### `--enable-qt`

Qt 5.12以降のサポートを有効にします。

wolfSSL Qtポートと互換性のあるwolfSSLビルド設定を有効にします。
Qtソースファイルにパッチを当てるには、wolfSSLが提供するパッチファイルが必要です。

### `--enable-qt-test`

Qtテスト互換ビルドを有効にします。

組み込みのQtテストの実行との互換性のために、wolfSSLをビルドするためのサポートを有効にします。

### `--enable-afalg`

ハードウェアアクセラレーション用のLinuxモジュールAF\_ALGの使用を有効にします。
Xilinxでの追加使用は`=xilinx`、`=xilinx-rsa`、`=xilinx-aes`、`=xilinx-sha3`で可能です。

[`--enable-devcrypto`](#--enable-devcrypto)と同様に、暗号操作のオフロードのためにLinuxカーネルモジュール（AF\_ALG）を活用します。
一部のハードウェアでは、Linuxの暗号ドライバを通じてパフォーマンス加速が可能です。
PetalinuxとXilinxの場合、フラグ`--enable-afalg=xilinx`を使用して、AF\_ALGのXilinxインターフェースを使用するようにwolfSSLに指示できます。

### `--enable-devcrypto`

ハードウェアアクセラレーション用のLinux `/dev/crypto`の使用を有効にします。

引数として、`aes`（すべてのaesサポート）、`hash`（すべてのハッシュアルゴリズム）、`hmac`（HMACのみ、`WOLFSSL_DEVCRYPTO_HMAC`）、`rsa`（RSAのみ）、`cbc`（aes-cbcのみ）のいずれかを指定できます。
各値は個別に照合されるため、1つの引数で複数の値を組み合わせることはできません。
オプションが指定されていない場合、デフォルトで`all`を使用します。

### `--enable-mcast`

wolfSSL DTLSマルチキャストサポートを有効にします。

### `--disable-pkcs12`

PKCS12コードを無効にします。

### `--enable-psk-one-id`

TLS 1.3を使用した単一のPSK IDのサポートを有効にします。

### `--enable-cryptocb`

暗号コールバックを有効にします。
`wc_CryptoCb_RegisterDevice`を使用して暗号コールバックを登録し、`wolfSSL_CTX_SetDevId`を使用して関連付けられているdevIdを設定します。
wolfSSL 5.9.4では、同じデバイスIDを2回登録しようとすると`ALREADY_E`で拒否されます。
また、`wc_CryptoCb_IsDeviceRegistered()`で、デバイスIDが登録済みかどうかを確認できます。
旧名称の`--enable-cryptodev`は、非推奨のエイリアスです。

`--enable-cryptocb`で次の定義を使用して、アルゴリズムのソフトウェアフォールバックをコンパイルアウトし、ソフトウェア実装が不要な場合のフットプリント削減のために最適化できます。

* `WOLF_CRYPTO_CB_ONLY_RSA` - RSAソフトウェア暗号フォールバックをコンパイルアウトします。
* `WOLF_CRYPTO_CB_ONLY_ECC` - ECCソフトウェア暗号フォールバックをコンパイルアウトします。
* `WOLF_CRYPTO_CB_ONLY_ED25519`、`WOLF_CRYPTO_CB_ONLY_CURVE25519`、`WOLF_CRYPTO_CB_ONLY_CURVE448` - Ed25519 / Curve25519 / Curve448のソフトウェア実装をコンパイルアウトします。
* `WOLF_CRYPTO_CB_ONLY_SHA256`、`WOLF_CRYPTO_CB_ONLY_SHA512`、`WOLF_CRYPTO_CB_ONLY_AES` - SHA-256 / SHA-512 / AESのソフトウェア実装をコンパイルアウトします。
* `WOLF_CRYPTO_CB_ONLY_SLHDSA` - SLH-DSAのソフトウェア実装をコンパイルアウトします。
* `WOLF_CRYPTO_CB_ONLY_MLKEM`、`WOLF_CRYPTO_CB_ONLY_MLDSA`、`WOLF_CRYPTO_CB_ONLY_FALCON`、`WOLF_CRYPTO_CB_ONLY_FRODOKEM`、`WOLF_CRYPTO_CB_ONLY_LMS`、`WOLF_CRYPTO_CB_ONLY_XMSS` - ML-KEM / ML-DSA / Falcon / FrodoKEM / LMS / XMSSのソフトウェア実装をコンパイルアウトします。

`--enable-cryptocb=only`を指定すると、上記のうち有効になっているすべてのアルゴリズムの`WOLF_CRYPTO_CB_ONLY_*`フラグが有効になり、すべての暗号操作がオフロードされます。
`--enable-cryptocb=no-default-devid`は、プラットフォーム固有のデフォルトデバイスIDなしでコールバックを有効にします。

`WOLF_CRYPTO_CB_ONLY_*`オプションを使用するには、サンプルプログラムのビルドを無効にする必要があります。
[`--disable-examples`](#--disable-examples)を参照してください。

関連オプションとして、`--enable-cryptocb-rsa-pad`（`WOLF_CRYPTO_CB_RSA_PAD`を定義します）はRSAパディングのパラメータをコールバックに渡し、コールバック自身がパディングを行えるようにします。
また、`--disable-cryptocb-sw-test`（`WC_TEST_NO_CRYPTOCB_SW_TEST`を定義します）は、wolfCryptテストでソフトウェア暗号を用いた暗号コールバックのテストを行わないようにします。
どちらも`--enable-cryptocb`が必要です。

### `--enable-cryptocbutils`

暗号コールバックユーティリティを有効にします（リストを指定せずにこのオプションを指定した場合は、すべてのユーティリティを有効にします）。
`--enable-cryptocb`が必要です。
`copy`、`free`、`setkey`、`export`、`keystore`からカンマ区切りのリストで指定します。
`keystore`を指定すると、ハードウェアキーストアに格納された鍵のために、`WC_ALGO_TYPE_KEYSTORE`と`wolfssl/wolfcrypt/wc_keystore.h`の`wc_KeyStore_*` APIが追加されます。
[`WOLF_CRYPTO_CB_KEYSTORE`](#wolf_crypto_cb_keystore)を参照してください。

### `--enable-reproducible-build`

バイナリジッター(タイムスタンプやその他の非機能メタデータ)を抑制し、同一のハッシュを持つビット単位で同一のバイナリパッケージを生成できるようにします。

### `--disable-sys-ca-certs`

デフォルトで有効です（`WOLFSSL_SYS_CA_CERTS`を定義します）。
`--disable-sys-ca-certs`で無効にします。
証明書のサポートがビルドされていない場合、またはmacOSとWindows以外の環境でファイルシステムが無効になっている場合は、自動的に無効になります。

[`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs)が呼び出されたときに、wolfSSLが検証のために信頼されたシステムCA証明書を使用できるようにします。
これは、wolfSSL証明書マネージャーにそれらをロードするか、システム認証APIを呼び出すことによって行われます。
詳細については、[`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs)を参照してください。

### `--with-sys-crypto-policy=PATH`

Fedora crypto-policiesのwolfSSLバックエンドなど、システム全体の暗号ポリシーファイルのサポートを組み込みます（[`WOLFSSL_SYS_CRYPTO_POLICY`](#wolfssl_sys_crypto_policy)と`WOLFSSL_CRYPTO_POLICY_FILE`を定義します）。
`PATH`を指定しない場合、デフォルトのファイルは`/etc/crypto-policies/back-ends/wolfssl.config`です。
ビルド時には何も読み込まれません。
アプリケーションが`wolfSSL_crypto_policy_enable()`でポリシーをロードします。
この関数に`NULL`を渡すと、設定されたファイルが使用されます。
デフォルトでは設定されていませんが、[`--enable-enterprise`](#--enable-enterprise)を指定するとデフォルトのパスで有効になります。

### `--enable-argon2`

Argon2パスワードハッシュ（RFC 9106）を、Argon2d、Argon2i、Argon2idの3つのバリアントすべてとともに有効にします。
デフォルトで無効です。
バージョン0x13のみが実装されています。
Argon2はBLAKE2bを用いて定義されているため、BLAKE2bが自動的に組み込まれます。
このオプションは`--disable-blake2b`と組み合わせることはできません。
`HAVE_ARGON2`を定義します。

ワンショット関数`wc_Argon2()` / `wc_Argon2_ex()`は、1つのタグを導出します。
多数のタグを導出するアプリケーション向けに、再利用可能なコンテキストAPI（`wc_Argon2Init()`、`wc_Argon2SetParams()`、`wc_Argon2DeriveTag()`、`wc_Argon2Free()`、および`WC_NO_CONSTRUCTORS`が定義されていない場合は`wc_Argon2New()` / `wc_Argon2Delete()`）が用意されており、メモリブロック配列を一度だけ確保して再利用します。
コンテキストAPIはwolfSSL 5.9.4で追加されました。

### `--enable-argon2-threads`

Argon2スライスのセグメントを、スレッドを使用して並列に埋めます。
デフォルトで無効です。
導出されるタグは変わりません。
ワンショット関数はレーンごとに1つのスレッドを使用します。
コンテキストAPIでは、スレッド数を`wc_Argon2SetThreads()`で指定します。
`--enable-argon2`が必要です。
`WOLFSSL_ARGON2_THREADS`を定義します。

### `--enable-aesgcm-siv`

ノンスの誤用に耐性を持つAEADであるAES-GCM-SIV（RFC 8452）を有効にします。
Cで記述されており、Intel x64、ARM64、ARM32、Thumb2向けのアセンブリも備えています。
デフォルトで無効です。
AES-GCM（`--enable-aesgcm`）が必要です。
`WOLFSSL_AESGCM_SIV`を定義します。
wolfSSL 5.9.4で追加されました。

### `--enable-cshake`

カスタマイズ可能なSHAKE拡張可能出力関数であるcSHAKE（SP 800-185）を有効にします。
デフォルトで無効です。
SHA-3とSHAKEは自動的に有効になります。
wolfSSL 5.9.4で追加されました。

### `--enable-kmac`

Keccakベースのメッセージ認証コードであるKMAC（SP 800-185）を有効にします。
デフォルトで無効です。
KMACはcSHAKEを基にしているため、`--enable-cshake`も有効になります。
APIは`wolfssl/wolfcrypt/sha3.h`にあります（`wc_InitKmac128()`、`wc_Kmac128_Update()`、`wc_Kmac128_Final()`、`wc_Kmac128_FinalXof()`、およびそれらに対応するKMAC256の関数）。
wolfSSL 5.9.4で追加されました。

### `--enable-tsp`

wolfCryptでRFC 3161タイムスタンププロトコルを有効にします。
デフォルトで無効です。
OpenSSL互換レイヤー、テスト、証明書、サンプルプログラムが付属しています。
APIは`wolfssl/wolfcrypt/tsp.h`にあります（`wc_TspRequest_*`、`wc_TspResponse_*`）。
`wc_TspResponse_Verify()`には、信頼されたTSA証明書が必要です。
また、リクエストおよびTstInfoのメッセージインプリントを設定する関数は、ダイジェスト長をハッシュアルゴリズムと照合します。
`--enable-asn=original`ではサポートされていません。
`WOLFSSL_TSP`を定義します。
wolfSSL 5.9.4で追加されました。

### `--enable-readahead`

TLS受信の先読みを有効にします。
デフォルトで無効です。
`recv()`の各呼び出しで受信バッファに収まるだけのデータを読み込むため、レコードあたりの`recv()`呼び出し回数が減ります。
この機能はこのオプションによってコンパイル時に組み込まれ、実行時に`wolfSSL_set_read_ahead()` / `wolfSSL_CTX_set_read_ahead()`でオブジェクトまたはコンテキストごとに有効にします。
[`WOLFSSL_TLS_READ_AHEAD`](#wolfssl_tls_read_ahead)を定義します。
wolfSSL 5.9.4で追加されました。

### `--enable-tls13-sha512`

TLS 1.3のみのビルドで、SHA-512のトランスクリプトハッシュを保持します。
デフォルトで無効です。
このオプションを指定しない場合、TLS 1.3のみのビルドでは、メモリを節約するためにTLS 1.2のトランスクリプト状態とSHA-512のトランスクリプトが除外されます。
[`WOLFSSL_TLS13_SHA512`](#wolfssl_tls13_sha512)を定義します。
CMakeで同等のオプションは`WOLFSSL_TLS13_SHA512`です。

### `--disable-rng-autolock`

1つの`WC_RNG`をスレッド間で共有できるようにする、インスタンスごとのロックを無効にします。
ビルドがサポートしている場合、このロックはデフォルトで有効です。
[`WC_RNG_NO_AUTO_LOCK`](#wc_rng_no_auto_lock)を参照してください。

### `--disable-rng-autofork`

フォークされた子プロセスが引き続き`WC_RNG`を使用できるようにする、`pthread_atfork()`ハンドラーを無効にします。
サポートされている環境では、デフォルトで有効です。
[`WC_RNG_AUTOFORK`](#wc_rng_autofork)を参照してください。

### `--disable-rng-autolock-default`

デフォルトでは、呼び出し側が特に指定しない限り、すべての`WC_RNG`に共有使用のためのロックが付与されます。
`--disable-rng-autolock-default`を指定すると、ロックはビルドに組み込まれたままですが、`wc_InitRng_ex2()`でロックを要求したインスタンスに対してのみ使用されます（`WC_RNG_AUTO_LOCK_DEFAULT_OFF`を定義します）。
`--disable-rng-autolock`と組み合わせることはできません。

### `--enable-rng-bank` and `--enable-rng-extras`

`--enable-rng-bank`はRNGバンクをビルドし（`HAVE_WC_RNG_BANK`を定義します）、RNGが必要です。
`--enable-rng-extras`は、RNGのロック、プール、RBGC、デーモンのサポートを追加します（`WC_RNG_EXTRAS`を定義します）。
どちらもデフォルトで無効ですが、カーネルモジュールのビルドではデフォルトで有効になります。

### `--with-rng-seed-device=PATH`

デフォルトのシードソースより先に、デバイス`PATH`からRNGにシードを供給します（`WC_RNG_SEED_DEVICE`を定義します）。
パスを指定しない場合は、`/dev/hwrng`が使用されます。
デフォルトで無効です。

### `--enable-wolfEntropy`

SP 800-90B認証を取得できるように設計された、ソフトウェアジッター（メモリ使用）エントロピー源であるwolfEntropyを有効にします。
`--enable-wolfentropy`と`--enable-entropy-memuse`はエイリアスです。
デフォルトで無効ですが、RDRANDやRDSEEDを使用しないカーネルモジュールのビルドでは有効になります。

### `--enable-noisesrc`

未加工の物理ノイズ源を持つポート向けに、汎用的なSP 800-90Bノイズ源レイヤー（`wc_NoiseSrc_*`）を有効にします。
デフォルトで無効です。

### `--enable-puf`

SRAM PUF（物理的複製困難関数）のサポートを有効にします（`WOLFSSL_PUF`と`WOLFSSL_PUF_SRAM`を定義します）。
デフォルトで無効です。
値によって、エラー訂正のプロファイルを選択します。
`small`、`balanced`（`yes`を指定した場合のデフォルト）、`strong`、`strongest`のいずれかを指定します。
HKDFも併せて有効になります。

### `--enable-asynccrypt-sw`

非同期のソフトウェアベース暗号シミュレーションを有効にします。
デフォルトで無効です。
wolfSSL 5.9.4で、`--enable-all`と組み合わせたエンドツーエンドのサポートが追加されました。
[`WOLFSSL_ASYNC_CRYPT_SW`](#wolfssl_async_crypt_sw)を定義します。

### `--disable-mlkem`

ML-KEM（FIPS 203）/ Kyberはデフォルトで有効です。
ただし、FIPS v7より前のFIPSビルドの場合と、SHA-3、SHAKE128、SHAKE256のいずれかが明示的に無効化されている場合は除きます。
`--disable-mlkem`を指定すると、ML-KEMなしでビルドします。
`--enable-kyber`は`--enable-mlkem`のエイリアスです。
`WOLFSSL_HAVE_MLKEM`を定義します。
このオプションはカンマ区切りのリストも受け付けます。
例えば、パラメータセットを選択する`512`、`768`、`1024`、操作を選択する`make`、`encapsulate`、`decapsulate`、`small`、`noasm`、およびML-KEMの代わりにオリジナルのKyberアルゴリズムをビルドする`original`（または`kyber`）などを指定できます（両方を保持するには`ml-kem`を追加します）。
PQ/TハイブリッドグループはML-KEM-768またはML-KEM-1024を使用するため、`512`のみを選択するリストを指定する場合は、`--enable-tls-mlkem-standalone`も必要です。

### `--enable-tls-mlkem-standalone`

ML-KEMを、ハイブリッドではない単独のTLS 1.3鍵交換として使用できるようにします。
デフォルトで無効です。
ML-KEMとTLS 1.3が有効で、ECC、Curve25519、Curve448がすべて無効になっている場合は、ハイブリッドグループの古典暗号の部分が存在しなくなるため、自動的に有効になります。

### `--disable-pqc-hybrids`

PQ/Tハイブリッド鍵交換グループ（ML-KEMとECDHEまたはX25519/X448の組み合わせ）は、ML-KEMとともにデフォルトで有効になります（`WOLFSSL_PQC_HYBRIDS`を定義します）。
`--disable-pqc-hybrids`で無効にします。
その場合、`--enable-tls-mlkem-standalone`も指定するか、ML-KEMを無効にしない限り、configureは失敗します。

### `--enable-extra-pqc-hybrids`

追加のPQ/Tハイブリッドグループの組み合わせを有効にします（`WOLFSSL_EXTRA_PQC_HYBRIDS`を定義します）。
デフォルトで無効です。
ML-KEMと`--enable-experimental`が必要で、FIPS v7ビルドでは使用できません。

### `--enable-mldsa`

ML-DSA（FIPS 204）/ Dilithiumを有効にします。
デフォルトで無効です。
`all`、`make`、`sign`、`verify`、`verify-only`、`small`、`44`、`65`、`87`、`draft`（または、FIPS 204のドラフト版を示す`fips204-draft`）、`no-ctx`からカンマ区切りのリストで指定します。
`verify-only`は署名検証のみを残します（[`WOLFSSL_MLDSA_VERIFY_ONLY`](#wolfssl_mldsa_verify_only)）。
`WOLFSSL_HAVE_MLDSA`を定義します（互換性のため、`settings.h`はレガシーの[`HAVE_DILITHIUM`](#have_dilithium)も定義します）。
`--enable-dilithium`はエイリアスです。

### `--enable-slhdsa`

SLH-DSA（FIPS 205）ステートレスハッシュベース署名を有効にします。
`--enable-slhdsa`のみを指定すると、6つのSHAKEパラメータセットが有効になります。
`--enable-slhdsa=sha2,yes`を指定すると、12個すべてが有効になります。
その他に指定可能な値は、`small`、`small-mem`、`128s`、`128f`、`192s`、`192f`、`256s`、`256f`、`no-s`、`no-f`、`sha2-128s`から`sha2-256f`まで、`no-sha2-s`、`no-sha2-f`です。
デフォルトで無効です。
検証のみを残すには、`--enable-slhdsa=sha2,yes,verify-only`を指定します。
TLS 1.3 / DTLS 1.3では、draft-reddy-tls-slhdsaの署名スキームを使用してハンドシェイクを認証できます。
[`WOLFSSL_HAVE_SLHDSA`](#wolfssl_have_slhdsa)を定義します。
wolfSSL 5.9.4で追加されました。

### `--enable-falcon`

wolfCryptネイティブのFalconポスト量子署名スキームを有効にします。
デフォルトで無効で、`--enable-experimental`が必要です。
wolfSSL 5.9.4で、liboqsのラッパーはネイティブ実装に置き換えられました。
Falconは外部ライブラリを必要としなくなり、暗号コールバック、ARM DSPおよびAArch64 NEONによる高速化をサポートし、Linuxカーネル内でも動作します。
[`HAVE_FALCON`](#have_falcon)を定義します。

以下のオプションをカンマ区切りのリストで指定できます。

* `asm`、`double`、`avx2`、`neon`: 浮動小数点 / FFTのバックエンドを選択します。デフォルトは整数演算の`fpr`バックエンドです。`double`（`avx2`と`neon`を指定した場合も暗黙的に指定されます）と`asm`は同時に指定できません。
* `small-mem`、`smallest-mem`: メモリ使用量を削減した署名者プロファイルです。`smallest-mem`は20*nバイトで動作します（ヒープのピークはFalcon-512で12 KB、Falcon-1024で22 KB）。
* `cache-key`、`cache-basis`: オプトインの鍵ごとの署名キャッシュです。デフォルトの整数演算バックエンドでは、署名が約2倍高速になります。
* `level1`、`level5`: Falconのレベルを1つだけビルドします。ビルドされていないレベルを指定すると、`wc_falcon_set_level()`は`BAD_FUNC_ARG`を返します。
* `dynamic-keys`: レベルごとの鍵バッファをヒープ上に保持します。この場合、`wc_falcon_set_level()`が`MEMORY_E`を返すことがあります。
* `verify-no-malloc`: 呼び出しごとにバッファを確保する代わりに、鍵の中に保持した4*nバイトのバッファで検証を行います。この場合、1つの鍵で一度に検証できる署名は1つだけです。

### `--enable-frodokem`

FrodoKEMのリファレンス実装を有効にします。
デフォルトで無効で、`--enable-experimental`が必要です。
高速版、小型版、スモールスタック版のCコードと、x86_64、AArch64、AArch32、Thumb2向けのアセンブリ、さらにASN.1形式の鍵とX.509証明書のサポートが含まれています。
オプションでカンマ区切りのリストを指定できます。
`aes` / `no-aes`と`shake` / `no-shake`は行列Aの生成方法を選択します（デフォルトはSHAKE-128です）。
`sve` / `no-sve`と`sme` / `no-sme`は、AArch64のSVEおよびSMEによる行列演算の高速化を選択します。
`small` / `no-small`は小型コードのバリアントを選択します。
`ephemeral` / `no-ephemeral`はeFrodoKEMのバリアントを追加します。
`no-640`、`no-976`、`no-1344`はパラメータセットを除外し、`no-make-key`、`no-encapsulate`、`no-decapsulate`は操作を除外します。
リストの各項目には、単独で指定できる形式もあります（`--enable-frodokem-shake`、`--enable-frodokem-aes`、`--enable-frodokem-sve`、`--enable-frodokem-sme`、`--enable-frodokem-ephemeral`、`--enable-frodokem-small`、`--enable-frodokem-640`、`--enable-frodokem-976`、`--enable-frodokem-1344`、`--enable-frodokem-make-key`、`--enable-frodokem-encapsulate`、`--enable-frodokem-decapsulate`）。
`WOLFSSL_HAVE_FRODOKEM`を定義します。
wolfSSL 5.9.4で追加されました。

### `--enable-lms`

ステートフルなLMS/HSSハッシュベース署名を有効にします（`WOLFSSL_HAVE_LMS`を定義します）。
デフォルトで無効です。
カンマ区切りのリストで、`verify-only`、`small`、`sha256-192`と`shake256`（パラメータセットを追加します）、`no-sha256-256`（SHA-256/256のパラメータセットを除外します）を指定できます。

### `--enable-xmss`

ステートフルなXMSS/XMSS^MTハッシュベース署名を有効にします。
デフォルトで無効です。
`verify-only`と`small`を指定できます。

### `--enable-dual-alg-certs`

TLS 1.3で、X9.146のデュアル鍵 / デュアル署名証明書を有効にします（`WOLFSSL_DUAL_ALG_CERTS`を定義します）。
デフォルトで無効です。
`--enable-experimental`が必要です。

### `--enable-experimental`

configureで実験的な設定を許可します（`WOLFSSL_EXPERIMENTAL_SETTINGS`を定義します）。
デフォルトで無効です。
[`--enable-falcon`](#--enable-falcon)、[`--enable-frodokem`](#--enable-frodokem)、[`--enable-extra-pqc-hybrids`](#--enable-extra-pqc-hybrids)、[`--enable-dual-alg-certs`](#--enable-dual-alg-certs)に必要です。
[`--enable-distro`](#--enable-distro)と組み合わせることはできません。

### `--enable-usersettings`

configureが通常コンパイラのコマンドラインに追加する機能フラグの代わりに、独自の`user_settings.h`を使用します。
この場合、configureは`WOLFSSL_USER_SETTINGS`（および`WOLFSSL_USER_SETTINGS_ASM`）のみを定義し、すべてのソースファイルをビルドします。
そのため、有効になる機能は`user_settings.h`によって決まります。
`user_settings.h`は、configureが見つけられる場所（例えば、ソースツリーの最上位ディレクトリ）に配置する必要があります。
デフォルトで無効です。
「非標準環境でのビルド」節を参照してください。

### `--enable-heapmath`

デフォルトのSP数学ライブラリの代わりに、レガシーのヒープベースの`integer.c`数学ライブラリを使用します（`USE_INTEGER_HEAP_MATH`を定義します）。
デフォルトで無効です。
SP数学は無効になります。
「特別な数学最適化フラグ」節を参照してください。

### カーネルモジュールのオプション

以下のオプションは、wolfSSLをオペレーティングシステムのカーネルモジュールとしてビルドします。

* `--enable-linuxkm`: Linuxカーネルモジュール（`libwolfssl.ko`）をビルドします。デフォルトで無効です。
* `--enable-freebsdkm`: FreeBSDカーネルモジュールをビルドします。デフォルトで無効です。
* `--with-kernel-source=PATH`（または`--with-linux-source=PATH`）: カーネルビルドツリーのルートです。
* `--with-linux-arch=ARCH`: Linuxカーネルビルドツリーのアーキテクチャ（`SRCARCH`）です。
* `--enable-kernel-settings`（エイリアス: `--enable-linuxkm-defaults`）: カーネルモジュールに適したデフォルト設定です。`--enable-linuxkm`と`--enable-freebsdkm`によって暗黙的に有効になります。
* `--enable-linuxkm-lkcapi-register=LIST`: wolfCryptの実装をLinuxカーネル暗号APIに登録します。`none`（デフォルト）、または`all`、`all-kconfig`、`all-aes`、`cbc(aes)`、`gcm(aes)`、`all-sha`、`all-hmac`、`stdrng`、`ecdsa`、`ecdh`、`rsa`、`dh`、`mldsa`、`mlkem`などのカンマ区切りのリストを指定します。項目の前に`-`を付けると、その項目を除外します。
* `--enable-freebsdkm-crypto-register`: wolfCryptの実装をFreeBSDカーネルのopencryptoフレームワークに登録します。デフォルトで無効です。
* `--with-bsd-export-syms=LIST`: FreeBSDカーネルモジュールの`EXPORT_SYMS`です。`YES`、`NO`（デフォルト）、またはシンボルのリストを指定します。
* `--enable-kernel-reloc-tables`（エイリアス: `--enable-linuxkm-pie`）: wolfCryptモジュールのコンテナ化されたオブジェクトビルドです。デフォルトで無効です。
* `--enable-kernel-benchmarks`（エイリアス: `--enable-linuxkm-benchmarks`）: モジュールのロード時に暗号ベンチマークを実行します。デフォルトで無効です。
* `--enable-kernel-verbose-debug`、`--enable-kernel-stack-debug`: それぞれ、カーネルモジュールにおける実行時の追加デバッグメッセージと、実行時のスタック使用量のレポートを有効にします。デフォルトで無効です。

### ハードウェアおよびセキュアエレメントのオプション

以下のオプションは、ハードウェア暗号エンジンおよびセキュアエレメント向けのポートを有効にします。
すべてデフォルトで無効です。

* `--enable-caam`: NXP CAAM。「NXP CAAM向けのビルド」節を参照してください。
* `--enable-sec-qoriq`: NXP QorIQ SECエンジン（T1040/T2080）。
* `--enable-ele`: NXP EdgeLock Secure Enclave。
* `--with-se050=PATH`: NXP SE050セキュアエレメント（デフォルトのパスは`/usr/local`）。
* `--with-els-pkc=PATH`: NXP EdgeLock ELS/PKC暗号コールバックポート。`PATH`にある`els_pkc`のチェックアウトを使用してビルドします。
* `--with-mcux-sdk=PATH`と`--with-els-pkc-platform=SOC`: `--with-els-pkc`用の設定です。`--with-mcux-sdk`（`--with-els-pkc`を使用する場合は必須）には、`els_pkc`のプラットフォームレイヤーがインクルードするSoCデバイスヘッダーを提供する、MCUXpresso SDKのチェックアウト（mcux-sdk-ng）を指定します。`--with-els-pkc-platform`は`els_pkc`のプラットフォームレイヤーを選択し、デフォルトは`rw61x`です。ヘッダー構成が判明しているプラットフォームはこれだけなので、その他のプラットフォームでは、SoCのインクルードパスを`CPPFLAGS`で、品番を`CFLAGS`で渡してください。`--with-els-pkc`を指定しない場合、どちらのオプションもconfigureの警告を表示するだけです。
* `--enable-stsafe`: STMicroelectronics STSAFEセキュアエレメント。`=a100`（デフォルト）はレガシーのSTSAFE-A1xx SDKを使用し、`=a120`はSTSELibを使用します。
* `--enable-microchip`: Microchip/AtmelのATECC508A、ATECC608A、TA100デバイス。
* `--with-cryptoauthlib[=PATH]`: Microchip CryptoAuthLib（`pkg-config`、`PATH`、または`/usr`と`/usr/local`から検索します）にリンクし、wolfSSLのMicrochip/Atmelポート（`wolfcrypt/src/port/atmel/atmel.c`）をライブラリに組み込みます。`--enable-microchip`が必要です。`--enable-microchip`には、デバイスを`508`、`608`、`100`のカンマ区切りのリストで指定します（例: `--enable-microchip=608`）。
* `--with-mpfs-athena=PATH`: Microchip PolarFire SoC Athena F5200暗号コールバックポート。`PATH`にあるuser-crypto（CAL）ディレクトリを使用します。
* `--with-maxq10xx=PART`: Analog Devices（Maxim）のMAXQ1065またはMAXQ1080セキュアオーセンティケーター。`PART`には`MAXQ1065`または`MAXQ108x`を指定します。configureは[`WOLFSSL_MAXQ1065`](#wolfssl_maxq1065)または[`WOLFSSL_MAXQ108X`](#wolfssl_maxq108x)を定義し、MAXQ SDKの`lib/libmaxq1065_api.a`または`lib/libmaxq108x_api.a`をリンクします。wolfSSLソースの`wolfcrypt/src/port/maxim/README.md`を参照してください。
* `--with-tropic01=PATH`: Tropic SquareのTROPIC01セキュアエレメント。`PATH`にある`libtropic`のチェックアウトを使用してビルドし、その`build/libtropic.a`をリンクします（`WOLFSSL_TROPIC01`を定義します）。静的ライブラリのみがビルドされます。
* `--enable-rtl8735b`: Realtek AmebaPro2（RTL8735B）のハードウェア固有鍵（HUK）暗号コールバックポートを、ベンダーHALヘッダーの代わりにシムを使用してビルドホスト上でコンパイルテストします（`WOLFSSL_RTL8735B_HOST_TEST`）。ターゲット上では、アプリケーションがAmebaPro2 HALのインクルードパスを指定します。暗号コールバックと、ビルド全体でAES-ECB（`HAVE_AES_ECB`）を有効にします。
* `--enable-silabs-cryptocb`: Silicon Labs EFR32 Secure Element暗号コールバックポート（`WOLFSSL_SILABS_CRYPTOCB`を定義します）。デフォルトの`=host-test`は、ベンダーSDKを必要とせず暗号処理も行わないシムに対してポートをビルドします（`WOLFSSL_SILABS_HOST_TEST`）。`=target`はEFR32向けの実際のポートをビルドし、Simplicity SDKのSE Managerのインクルードパスを`CFLAGS`で渡します。暗号コールバックを有効にします。
* `--enable-iotsafe`: IoT-Safeセキュアアプレット。
* `--enable-iotsafe-hwrng`: `--enable-iotsafe`と併用し、IoT-SafeアプレットをRNGのシードソースとして使用します。Hash DRBGが無効な場合は、RNG全体として使用します（[`HAVE_IOTSAFE_HWRNG`](#have_iotsafe_hwrng)を定義します）。
* `--enable-xilinx`: Xilinxのハードウェア暗号（hardened crypto）。
* `--enable-kcapi`: 暗号処理に`libkcapi`を使用します。`--enable-kcapi-hash`、`--enable-kcapi-hmac`、`--enable-kcapi-aes`、`--enable-kcapi-rsa`、`--enable-kcapi-dh`、`--enable-kcapi-ecc`で個別のアルゴリズムを選択します。
* `--enable-alterafcs`: `libfcs`を介したAltera Agilex 5 SDMへの暗号オフロード。`=rng`はRNGのみをオフロードします。
* `--enable-vaultic`: WISeKey/SealSQ VaultICセキュアエレメント。
* `--enable-cuda`: CUDAを使用したNVIDIA GPU上のAES（`wolfcrypt/src/port/cuda/aes-cuda.cu`）。コンパイラを`nvcc`に設定し、`WC_CUDA`と`HAVE_CUDA`を定義します。
* `--enable-psa`: Platform Security Architecture（PSA）の暗号インターフェースを使用します（`WOLFSSL_HAVE_PSA`を定義します）。`--with-psa-include=PATH`と`--with-psa-lib=PATH`はPSAのヘッダーとライブラリのディレクトリを追加し、`--with-psa-lib-name=NAME`はライブラリを`-lNAME`でリンクします。`--enable-psa-lib-static`を指定すると、代わりにファイル`PATH/NAME`（`PATH`は`--with-psa-lib`で指定したもの）を静的にリンクします。これらのオプションには`--enable-psa`が必要です。

### アプリケーションおよび統合のオプション

以下のオプションは、特定のアプリケーションやwolfSSL製品向けにwolfSSLを設定します。
通常は、OpenSSL互換レイヤーと、そのプロジェクトが必要とする機能を有効にします。
すべてデフォルトで無効です。

* `--enable-all-osp`: これらのビルドのうち、Tailscale、wolfGuard、Webサーバー、S/MIME、OpenSSH、lighttpd、nginx、OpenVPN、ASIO、libwebsockets、stunnel、curl、tcpdumpをまとめて有効にします（FIPSビルドや`--enable-sp-math`ビルドでは、一部が除外されます）。カーネルモジュールの設定とは併用できません。
* サーバー、プロキシ、ネットワーク: `--enable-nginx`（nginx）、`--enable-openresty`（OpenResty。`--enable-nginx`も有効にします）、`--enable-haproxy`（HAProxy）、`--enable-hitch`（Hitch）、`--enable-memcached`（memcached）、`--enable-curl`（curl）、`--enable-libwebsockets`（libwebsockets）、`--enable-tcpdump`（tcpdump）、`--enable-rsyslog`（rsyslog）、`--enable-mosquitto`（Mosquitto）、`--enable-openldap`（OpenLDAP）。
* セキュリティとVPN: `--enable-wpas`（wpa_supplicant）、`--enable-wpas-dpp`（DPP（Wi-Fi Device Provisioning Protocol）対応のwpa_supplicant。`--enable-wpas`を有効にし、PKCS#7、証明書要求、すべてのカスタムECC曲線を追加します）、`--enable-strongswan`（strongSwan）、`--enable-krb`（Kerberos 5）、`--enable-libssh2`（libssh2）、`--enable-libest`（libest）、`--enable-tailscale`（Tailscaleのビルド依存関係）、`--enable-wolfguard`（wolfGuardの依存関係）。
* 時刻、DNS、管理: `--enable-chrony`（chrony）、`--enable-ntp`（NTP）、`--enable-bind`（BIND DNS）、`--enable-net-snmp`（Net-SNMP）、`--enable-sblim-sfcb`（SBLIM SFCB（Small Footprint CIM Broker））。
* その他のプロジェクト: `--enable-signal`（Signal）、`--enable-ffmpeg`（FFmpeg）、`--enable-wolfzfs`（wolfZFS。カーネルビルドには`=kernel`を指定します）。
* AUTOSAR: `--enable-autosar`は、AES-CBCと乱数サービスを備えたAUTOSAR暗号スタックのシム（Csm、CryIf、Cryptoドライバー）をビルドします（`WOLFSSL_AUTOSAR`を定義します）。`--enable-autosar-cmac`は、AES-CMACのMAC生成および検証サービスを追加し、CMACを有効にします（`WOLFSSL_AUTOSAR_CMAC`を定義します）。`--enable-autosar`が必要です。wolfSSLソースの`wolfcrypt/src/port/autosar/README.md`を参照してください。
* wolfSentry: `--enable-wolfsentry`はwolfSentryのフックとプラグインを有効にします（[`WOLFSSL_WOLFSENTRY_HOOKS`](#wolfssl_wolfsentry_hooks)、`HAVE_EX_DATA`、`HAVE_EX_DATA_CLEANUP_HOOKS`を定義し、`OPENSSL_EXTRA`を有効にします）。`--with-wolfsentry=PATH`はwolfSentryのインストール先を指定し、このオプションも有効にします。`--with-wolfsentry-lib=PATH`と`--with-wolfsentry-include=PATH`は、ライブラリとヘッダーのディレクトリを個別に指定します（デフォルトは`PATH/lib`と`PATH/include`）。テストプログラムとサンプルプログラムは`-lwolfsentry`でリンクされます。
* wolfSSL製品: `--enable-wolfprovider`（wolfProvider。`--enable-opensslcoexist`を有効にするため、`--enable-opensslall`を必要とするビルドとは組み合わせられません）、`--enable-engine`（wolfEngine。`--enable-engine`のみを指定するとFIPS v2ビルドが選択されます。FIPSなしの場合は`--enable-engine=no-fips`を使用してください）、`--enable-wolftpm`（wolfTPM）、`--enable-wolfssh`（wolfSSH。[`--enable-ssh`](#--enable-ssh)と同じです）、`--enable-wolfclu`（wolfCLU）。

### 内部用、テスト用、および別途ライセンスが必要なコード用のオプション

以下のオプションは、wolfSSL自身のテストやビルドツール用のもの、または別途ライセンスの下でのみ入手可能なソースコードを必要とするものです。
ほとんどのビルドでは不要です。
`--enable-makeclean`を除き、すべてデフォルトで無効です。

* `--enable-selftest`: wolfCrypt CAVPセルフテストをビルドします（`HAVE_SELFTEST`を定義します。`=v2`はwolfCrypt 4.1.0版を、その他の値は3.14.2版を選択します）。ライセンス契約の下で提供される`wolfcrypt/src/selftest.c`が必要で、これがない場合、configureはエラーで停止します。
* `--enable-do178`: DO-178コードをビルドします（`HAVE_DO178`を定義します。指定しない場合、configureは`NO_DO178`を定義します）。別途ライセンス契約の下で提供されるDO-178のソースコードが必要です。公開されているソースでは、これらのマクロはチェックされません。
* `--enable-fortress`: 「SSL fortress」ビルドプロファイル。`FORTRESS`、[`WOLFSSL_ALWAYS_VERIFY_CB`](#wolfssl_always_verify_cb)、[`WOLFSSL_AES_COUNTER`](#wolfssl_aes_counter)、[`WOLFSSL_AES_DIRECT`](#wolfssl_aes_direct)、[`WOLFSSL_DER_LOAD`](#wolfssl_der_load)、[`WOLFSSL_KEY_GEN`](#wolfssl_key_gen)を定義し、OpenSSL互換レイヤー、MD5、SHA-384、SHA-512を有効にします。AESが必要で、[`--enable-openssh`](#--enable-openssh)によって有効になります。
* `--enable-memtest`: テストのためにメモリ割り当てを追跡します（[`WOLFSSL_TRACK_MEMORY`](#wolfssl_track_memory)と[`WOLFSSL_DEBUG_MEMORY`](#wolfssl_debug_memory)を定義します）。`=fail`を指定すると、メモリ割り当てをランダムに失敗させます（[`WOLFSSL_FORCE_MALLOC_FAIL_TEST`](#wolfssl_force_malloc_fail_test)）。
* `--enable-puf-test`: [`--enable-puf`](#--enable-puf)のテストモード。実際のSRAMの読み出しの代わりに、`wc_PufSetTestData()`で合成したSRAMデータを与えます（`WOLFSSL_PUF_TEST`を定義します）。本番環境では使用しないでください。
* `--enable-swdev`: テストプログラムとサンプルプログラムにのみリンクされるソフトウェア暗号コールバックデバイス`wc_swdev`をビルドします。`WOLF_CRYPTO_CB_ONLY_*`オプションでソフトウェアアルゴリズムを除外したビルドをテストするためのものです（`WOLFSSL_SWDEV`と`WOLF_CRYPTO_CB_FIND`を定義します）。[`--enable-cryptocb`](#--enable-cryptocb)が必要です。wolfSSLソースの`tests/swdev/README.md`を参照してください。
* `--enable-crypttests-libs`: wolfCryptのテストおよびベンチマークのコードを、ライブラリ`libwolfcrypttest`と`libwolfcryptbench`としてもビルドします。これらのAPIは安定していません。
* `--disable-makeclean`: デフォルトでは、configureは終了時に`make clean`を実行します。このオプションを指定すると、`make clean`を実行しません。

### `make sbom` and `make bomsh`

これらはconfigureオプションではなく、EUサイバーレジリエンス法（Cyber Resilience Act）への準拠のためにwolfSSL 5.9.4で追加されたMakefileターゲットです。
`make sbom`は、SPDX 2.3およびCycloneDX 1.6形式のソフトウェア部品表（SBOM）を生成します。
`make bomsh`は、OmniBORのビルド来歴（provenance）を生成します。

## 特別な数学最適化フラグ

### `--enable-fastmath`

レガシーなTom's Fast Mathバックエンド(`tfm.c`)を有効にします。
デフォルトで無効です。
`--enable-fastmath`を指定すると、デフォルトの`--enable-sp-math-all`が無効になります。
`--enable-sp-math-all`または`--enable-sp-math`も明示的に指定した場合はSP数学が優先され、fastmathは使用されません。

「Fast Math」節および「Big Integer数学ライブラリ」節を参照してください。

### `--enable-fasthugemath`

レガシーなTom's Fast Mathバックエンド + 巨大なコードを有効にします。
`--enable-fastmath`も有効になります。
SP数学で同等の設定は`--enable-sp-math-all=huge`で、巨大なコード向けの最適化CFLAGSを追加し、`WOLFSSL_SP_INT_LARGE_COMBA`を定義します。

FastHugeMathの有効化にはFastMathライブラリのサポートが含まれます。
公開鍵に関する実装に一般的な鍵サイズのループを展開することで、コードサイズが大幅に増加します。
fasthugemathを使用する前後でベンチマークユーティリティを実行して、わずかな速度向上がコードサイズの増加に見合うかどうかをご確認ください。

### `--enable-sp-math`

制限されたアルゴリズムスイートを使用した単精度(SP)数学実装を有効にします。
サポートされていないアルゴリズムは無効になります。
デフォルトの`--enable-sp-math-all`とfastmathを無効にします。
明示的に指定した`--enable-sp-math-all`とは組み合わせることができず（configureがエラーを報告します）、RSA、DH、ECCには`--enable-sp`が必要です。
x86_64およびaarch64では、`--enable-sp-math`はデフォルトで`--enable-sp-asm`を有効にし、それにより`--enable-sp`も有効になります。

- 整数ライブラリーの実装を `sp_int.c` の実装に置き換えます。
- 最小限の実装で、`sp_int.c` の一部を有効にしますが、すべてではありません。
- RSA/ECC/DH操作を実行できるようにするには、`--enable-sp`と組み合わせて、`sp_x86_64.c`、`sp_arm32.c`、`sp_arm64.c`などのソリューション（ターゲットシステムに応じた以下のファイルリスト）をオンにする必要があります。
- `--enable-sp-math-all` (下記) と組み合わせてはいけません

ファイルリスト (プラットフォームに依存します。システムの仕様に基づいてconfigureによって選択されるか、Makefile/IDE ソリューションを使用する場合は手動で制御できます):

* sp_c32.c、sp_c64.c (移植可能なC実装、32ビットおよび64ビット)
* sp_arm32.c
* sp_arm64.c
* sp_armthumb.c
* sp_cortexm.c
* sp_dsp32.c
* sp_riscv64.c
* sp_x86_64.c
* sp_x86_64_asm.S
* sp_x86_64_asm.asm
* sp_sm2_*.cおよびsp_sm2_x86_64_asm.S (上記のSM2版)

### `--enable-sp-math-all`

デフォルトで有効です。
完全なアルゴリズムスイートを持つ単精度（SP）数学実装を有効にします。
サポートされていないアルゴリズムも有効になりますが、最適化されていません。
明示的に指定した場合は、`--enable-fastmath`および`--enable-fasthugemath`よりも優先されます。
`--enable-sp`と組み合わせることができます。

- 数学の実装を `sp_int.c` の実装に置き換えます。
- 完全な実装であり、 `--enable-sp` の動作に依存しません
- `--enable-sp` と組み合わせて、可能であれば、32 ビットの `sp_c32.c` または 64 ビットの `sp_c64.c` で移植可能な C アセンブリ (ハードウェア固有でないアセンブリ) で記述された実装を使用できるようにすることができます。 それ以外(不可能な場合) には、`sp_int.c` の実装が使用されます。 移植可能な C アセンブリは、ハードウェアの最適化が利用できないターゲットでパフォーマンスを大幅に向上させます。
- `--enable-sp-math` (上記) と組み合わせてはいけません

オプションとして、以下のオプションをカンマ区切りのリストで指定できます。

* `small`: より小さなコード（`WOLFSSL_SP_SMALL`を定義します）。
* `huge`: より大きく高速なコード（巨大なコード向けの最適化CFLAGSと`WOLFSSL_SP_INT_LARGE_COMBA`）。
* `256`、`384`、`521`、`1024`、`2048`、`3072`または`4096`: サポートする最大鍵サイズ（ビット単位）。
* `nomalloc`: `WOLFSSL_SP_NO_MALLOC`を定義します。
* `neg`: 負の数をサポートします（`WOLFSSL_SP_INT_NEGATIVE`を定義します）。

例えば、`--enable-sp-math-all=small,2048`のようにします。

**注**: 鍵の長さがビット [256, 384, 521, 1024, 2048, 3072, 4096] の非対称暗号を使用している場合は、最大のパフォーマンスを得るために `--enable-sp`（利用可能な場合は `--enable-sp-asm` も併用）の使用をご検討ください。
ただしフットプリントサイズは大きくなります。
それらの鍵サイズのみが必要な場合は、`--enable-sp-math` を追加することで汎用の sp_int コードを除外できます。

### `--enable-sp-asm`

単精度(SP)アセンブリの実装を有効にします。

x86\_64、ARM（32ビット、Thumb、Cortex-M、AArch64）およびRISC-V 64アーキテクチャでのアセンブリを通して、単精度性能の向上を可能にするために使用できます。
SPが必要です（`--enable-sp`は自動的に有効になります）。
x86\_64のWindowsホスト（MinGW/Cygwin）ではサポートされていません。

### `--enable-sp=OPT`

RSA、DH、およびECCの単精度(SP)数学を有効にして、パフォーマンスを改善します。

OPTには多くの値を設定できます。
以下は、enable-sp を呼び出す方法と、結果として定義される結果のマクロのリストです。
これらはすべて、カンマ区切りのリストで組み合わせることができます。
例えば、`--enable-sp=ec256,ec384`のようにします。
定義されるマクロの意味は、上記の「独自の単精度(SP)数学ライブラリのサポート」節に記載しています。

**注**:
1) `--enable-sp=small --enable-sp-math`は、
2) `--enable-sp-math-all=small`よりも小さくなる可能性があります。
これは、(1)が特定の鍵サイズの実装のみを持つのに対し、(2)はすべての鍵サイズをサポートする実装を持つためです。

**注**：これはx86_64で、他の構成フラグを指定しない場合のものです。
結果は、指定するアーキテクチャやその他の構成フラグによって異なる場合があります。
たとえば、`yes`、`small`、`smallfast`のリストにあるWOLFSSL_SP_384、WOLFSSL_SP_521、WOLFSSL_SP_4096は、64ビットのIntel/ARMターゲット（x86_64、amd64、aarch64）でのみ有効になります。
WOLFSSL_SP_LARGE_CODEも同様にこれらのターゲットでのみ定義され、さらに`small`を使用しない場合に限られます。
これは、以下の各項目のうちWOLFSSL_SP_LARGE_CODEを記載しているものすべてに当てはまります。
HAVE_ECC384とHAVE_ECC521は、WOLFSSL_SP_384およびWOLFSSL_SP_521と一緒に定義されます。

#### `--enable-sp=no` or `--disable-sp`

新しいマクロは定義されません。
`--enable-sp`を使用しないのと同等です。

#### `--enable-sp` or `--enable-sp=yes`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_SP_384およびHAVE_ECC384
* WOLFSSL_SP_521およびHAVE_ECC521
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE

（`WOLFSSL_SP_384`、`WOLFSSL_SP_521`、`WOLFSSL_SP_4096`および`WOLFSSL_SP_LARGE_CODE`は、64ビットIntel/ARMターゲットではデフォルトで追加されます。
上記の注をご参照ください。
その他のターゲットでは、必要に応じて最初の3つを手動で追加してください。）

#### `--enable-sp=small`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_384およびHAVE_ECC384 (64ビットIntel/ARM)
* WOLFSSL_SP_521およびHAVE_ECC521 (64ビットIntel/ARM)
* WOLFSSL_SP_4096 (64ビットIntel/ARM)

#### `--enable-sp=smallfast`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_FAST_MODEXP
* WOLFSSL_SP_384およびHAVE_ECC384 (64ビットIntel/ARM)
* WOLFSSL_SP_521およびHAVE_ECC521 (64ビットIntel/ARM)
* WOLFSSL_SP_4096 (64ビットIntel/ARM)

#### `--enable-sp=ec256` or `--enable-sp=p256` or `--enable-sp=256`

* WOLFSSL_HAVE_SP_ECC

#### `--enable-sp=smallec256` or `--enable-sp=smallp256` or `--enable-sp=small256`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec384` or `--enable-sp=p384` or `--enable-sp=384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384およびHAVE_ECC384
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec384` or `--enable-sp=smallp384` or `--enable-sp=small384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384およびHAVE_ECC384
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec521` or `--enable-sp=p521` or `--enable-sp=521`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_521およびHAVE_ECC521
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec521` or `--enable-sp=smallp521` or `--enable-sp=small521`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_521およびHAVE_ECC521
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec1024` or `--enable-sp=p1024` or `--enable-sp=1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec1024` or `--enable-sp=smallp1024` or `--enable-sp=small1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=sm2`

`--enable-sm2`と組み合わせて使用します。

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SM2
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallsm2`

`--enable-sm2`と組み合わせて使用します。

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SM2
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
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa2048`

* WOLFSSL_HAVE_SP_RSA
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
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa3072`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=smallrsa3072`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=4096` or `--enable-sp=+4096`

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
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=nomalloc`

* WOLFSSL_SP_NO_MALLOC

#### `--enable-sp=nonblock`

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK
* WOLFSSL_SP_SMALL

#### `--enable-sp=nonblocklarge`

より大きな（smallではない）実装を使用したノンブロッキングECCです。

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK

#### `--enable-sp=smallstack`

* WOLFSSL_SP_SMALL_STACK

#### `--enable-sp=transposedtable` and `--enable-sp=notransposedtable`

`transposedtable`がデフォルトです。
ベースポイントテーブルの参照時に、すべてのエントリを走査する代わりにブロックごとに1バイトを読み取ります。
`notransposedtable`は代わりにテーブルのすべてのエントリを走査し、どのメモリアドレスもインデックスに依存しないようにします。
また、以下を定義します。

* WOLFSSL_SP_NO_TRANSPOSED_TABLE

#### `asm`

他のアルゴリズムオプションと組み合わせて、それらのオプションに対してアセンブリコードがオンになっていることを示します。
例えば、`--enable-sp=rsa2048,asm`のように設定します。

#### `noasm`

SPアセンブリコードを無効にします。
例えば、x86_64またはaarch64では`--enable-sp-math --enable-sp=yes,noasm`のように指定します。
これらのターゲットでは、指定しない場合`--enable-sp-math`がデフォルトで`--enable-sp-asm`を有効にします。

## クロスコンパイル

組み込み機器プラットフォーム上の多くのユーザーは、自身の環境向けにwolfSSLをクロスコンパイルしています。
ライブラリをクロスコンパイルさせる最も簡単な方法は、`./configure`システムを使用することです。
Makefileが生成され、それを使用してwolfSSLをビルドできます。

クロスコンパイルを行う場合、次のように`./configure`にホストを指定する必要があります。

```sh
./configure --host=arm-linux
```

また、使用するコンパイラ、リンカーなどを指定する必要がある場合があります。

```sh
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux-ranlib
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

#### PowerPc64le-Power8-Glibc

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
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
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
これらのポートの一部とそれらのマニュアルはディレクトリ`wolfssl-X.X.X/IDE`にあります。
ここで、X.X.Xは現在のwolfSSLバージョン番号です。
このディレクトリには、環境用のwolfSSLをビルドするために使用されているIDEの有用な情報とコードも含まれています。

ポートリスト：

* Arduino
* Wiced Studio
* CSBench
* SGX WindowsとLinux
    * これらのディレクトリ(`wolfssl/IDE/WIN-SGX`および`wolfssl/IDE/LINUX-SGX`)には、Intel SGXプロジェクトで使用されるライブラリとしてwolfSSLをビルドするためのMakefileおよびVisual Studioソリューションが含まれています。
* Hexagon
    * このディレクトリ(`wolfssl/IDE/HEXAGON`)には、Hexagonツールチェーンを使用してビルドするためのMakefileが含まれています。ECC検証操作をDSPプロセッサにオフロードするためのwolfSSLをビルドするために使用できます。ディレクトリには、ビルドに必要な手順を支援するREADMEファイルが含まれています。
* Hexiwear
* NetBurner M68K
    * ディレクトリ(`wolfssl/IDE/M68K`)には、NetBurner RTOSを使用してMCF5441Xデバイス用のwolfSSLをビルドするためのMakefileがあります。
* Renesas
    * このディレクトリ(`wolfssl/IDE/Renesas`)は、ルネサスデバイスの異なる複数のビルドを含みます。ハードウェアアクセラレーションを使用して実証するビルド例もあります。
* XCODE (Xcode)
* Eclipse
* Espressif
* IAR-EWARM
* Rowley Crossworks ARM
* RISCV
* Zephyr（Zephyrモジュール自体はトップレベルの`zephyr`ディレクトリにあります）
* INTIME-RTOS
* Android
* apple-universal（configureでビルドするAppleプラットフォーム向けxcframework）
* AURIX (Infineon AURIX Development Studio)
* C2000 (TI C2000 C28x)
* Gaisler-BCC (Gaisler LEON)
* GCC-ARM
* IAR-MSP430
* Infineon (ModusToolbox)
* iotsafe (IoT-SAFE)
* MCUEXPRESSO（NXP MCUXpresso、RT1170およびRW612を含む）
* MDK5-ARM (Keil MDK 5)
* MPLABX16（Microchip MPLAB XとXC16）
* MQX
* MYSQL（wolfSSLをMySQLに組み込んでビルドするためのCMakeファイル）
* NETOS
* PlatformIO
* QNX（CAAMドライバーを含む）
* SimplicityStudio (Silicon Labs)
* STARCORE
* STM32Cube（STM32CubeIDEおよびSTM32CubeMX）
* VisualDSP
* VS-AZURE-SPHEREおよびMSVS-2019-AZSPHERE（Microsoft Azure Sphere）
* WINCE
* WORKBENCH（VxWorks向けのWind River Workbench）
* XilinxSDK（Xilinx SDKおよびAMD Vitis）

## NXP CAAM向けのビルド

### i.MX8 (Linux)

#### 既知の問題

- HSMセッション(wc_SECO_CloseHSMおよびwolfSSL_CleanupまたはwolfCrypt_Cleanup)を閉じる前に、開いているHSMキーストアセッションを終了すると、次回NVMを起動したときにセグメンテーションフォールトが発生します。これを回避するには、電源を入れ直す必要があります。

#### 制限事項

- 大きな入力（例えば1メガバイト）を扱うAES操作は、SECOが「Not enough space in shared memory」（共有メモリに十分なスペースがありません）となり失敗します。
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
- NXP「repo」ツールとYoctoビルド。Yoctoのセットアップに関するドキュメントは、NXPのimx-manifestリポジトリのREADMEにあります：<https://github.com/nxp-imx/imx-manifest>
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

```
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib
sudo apt-get install build-essential chrpath socat cpio python python3 python3-pip
sudo apt-get install python3-pexpect xz-utils debianutils iputils-ping python3-git
sudo apt-get install python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm curl
sudo apt-get install ca-certificates
```

```
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

git config --global user.name "Your Git Name"
git config --global user.email "Your Email"
```

2022年1月11日現在、GitHubは認証されていないGit接続を許可しなくなりました。
このドキュメントが作成された時点 (2022年3月) では、NXPのrepoツールはこれをまだ考慮していません。
この問題を回避するには、次のコマンドを使用してgit://github.com/ を https://github.com/ にリダイレクトしてください。

```
git config --global url."https://github.com/".insteadOf git://github.com/
```

ビルド用のディレクトリを作成します。
例えば次のようにします。

```
mkdir imx-yocto-bsp
cd imx-yocto-bsp/
```

NXPの「repo」コマンドツールを設定した後、目的のLinuxバージョンでディレクトリを初期化して同期します。
この場合は5.4.24_2.1.0です。
NXPのi.MXリポジトリはCodeAurora（source.codeaurora.org、現在は廃止）からGitHubに移行したため、マニフェストは<https://github.com/nxp-imx/imx-manifest>から取得します。

```
repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-zeus -m imx-5.4.24-2.1.0.xml
repo sync

DISTRO=fsl-imx-wayland MACHINE=imx8qxpc0mek source imx-setup-release.sh -b build-xwayland
```

##### 追加のYocto CAAM レイヤー

次に、cryptodev-module、cryptodev-linux、および`linux-imx/drivers/crypto/caam/*`のファイルにパッチを適用するCAAMドライバー拡張レイヤーをダウンロードします。
ベースblobとECDSA（署名/検証/鍵生成）はこちら（<https://github.com/nxp-imx-support/imx_sec_apps>、以前はsource.codeaurora.orgにありました）にあります。
それをさらに拡張してRSAブラックキー、ECDH、およびCurve25519をサポートするレイヤーは`meta-imx-expand-caam`です。
これらのディレクトリを両方とも、他の既存の`meta-*`ディレクトリの横にある`sources`ディレクトリに配置します。

```sh
#<直前のコマンドのbuild-xwaylandディレクトリに居る想定>

#<現在の作業内容をクローンするか、提供されたzipファイルを展開>
git clone -b caam_expansion https://github.com/JacobBarthelmeh/imx_sec_apps
cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
cp -r imx_sec_apps/meta-imx-expand-caam ../sources/


# あるいは

git clone https://github.com/nxp-imx-support/imx_sec_apps.git
#(meta-imx-expand-caamはwolfSSLが提供します)
unzip meta-imx-expand-caam.zip

cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
mv meta-imx-expand-caam ../sources/
```

これらのレイヤーをビルドに追加します。
最初にecdsaを、次にCAAM拡張を追加します。

```
vim conf/bblayers.conf
BBLAYERS += "${BSPDIR}/sources/meta-imx-ecdsa-sec"
BBLAYERS += "${BSPDIR}/sources/meta-imx-expand-caam"
```

必要なモジュールとライブラリを`local.conf`ファイルに追加します。

```sh
vim conf/local.conf
EXTRA_IMAGE_FEATURES_append = " dev-pkgs tools-sdk tools-debug ssh-server-openssh "
IMAGE_INSTALL_append = " cryptodev-module cryptodev-linux eckey "
```

このビルドではデバッグツールとSSHサーバーを追加しましたが、サイズを削減したい場合には必要ありません。
追加する重要な項目は`cryptodev-module`と`cryptodev-linux`です。
`eckey`は、BLOBのカプセル化とカプセル化解除を行うためのNXPのデモツールです。

**オプション**: cryptodevモジュールの自動ロードを追加するには、次の行を`conf/local.conf`に追加します。

```
KERNEL_MODULE_AUTOLOAD += "cryptodev"
```

それ以外の場合は、電源を入れ直すたびに`modprobe cryptodev`を使用してモジュールをロードする必要があります。

##### ビルドとデプロイ

イメージのビルドの開始には次のコマンドを使います。
そのあとで、もしSDカードを使っているならばカードに書き込みます。

```
bitbake core-image-base

cd tmp/deploy/images/imx8qxpc0mek/
bzcat core-image-base-imx8qxpc0mek.sdcard.bz2 | sudo dd of=/dev/diskX bs=5m
```

注: `5m`はmacOSの場合に使用し、Linuxの場合は`5M`を使用します。
`diskX`はSDカードの場所、つまりMacであれば`disk2`、Linuxであれば`sdbX`に置き換える必要があります。
実行する前に、SDカードのディスク番号を確認してください。
後ほど`wolfssl/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```
export CRYPTODEV_DIR=`pwd`/tmp/sysroots-components/aarch64/cryptodev-linux/usr/include/
```

クロスコンパイルのためにツールチェーンをインストールするには、次のYoctoコマンドを使用します。

```
bitbake meta-toolchain
sudo ./tmp/deploy/sdk/<version>.sh
```

#### NXP HSMのビルド

##### zlibのビルド

これを行うには複数の方法があり、その一つは次のようにbitbakeでビルドする方法です。

```
cd build-xwayland
bitbake zlib
```

このコマンドは実行結果を`tmp/sysroots-components/aarch64/zlib/usr/`ディレクトリに配置します。

後ほど`wolfssl/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```
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

```
make
make install
```

後ほど`wolfssl/examples`のビルドに使用するために、次のコマンドを使用してインストールディレクトリをエクスポートします。

```sh
export HSM_DIR=`pwd`/export/usr/
```

`make install` を行うとデフォルトで結果を`export`サブディレクトリに配置します。

#### wolfSSLのビルド

##### Autoconfを使用したビルド

開発ツールを使用してYoctoイメージをセットアップすると、wolfSSLをシステム上で直接ビルドできます。
より最小限のアプローチとして、クロスコンパイルを使用できます。
デバッグメッセージは `--enable-debug` で有効にできます。
SECO作業に固有の追加のデバッグメッセージは、マクロ`DEBUG_SECO`を定義し、`/dev/crypto`呼び出しの`DEBUG_DEVCRYPTO`を定義することで有効にできます。
どちらの追加のデバッグメッセージもprintfを使用し、stdoutパイプに出力します。
SECOで使用するための重要な有効化オプションがいくつかあります：`--enable-caam=seco`、`--enable-devcrypto=seco`、`--with-seco=$HSM_DIR`（`HSM_DIR`は、前の手順でビルドしたimx-seco-libsのインストールディレクトリ`export/usr/`です）。
configureは`$HSM_DIR/include`からヘッダーを読み込み、`$HSM_DIR/lib/hsm_lib.a`と`$HSM_DIR/lib/seco_nvm_manager.a`をリンクします。
`--enable-caam`は暗号コールバック（`WOLF_CRYPTO_CB`）も自動的に有効にします。

HSM SECO のみを使用したビルド例 (追加アルゴリズムのdevcryptoサポートなし)

```sh
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

# wolfSSLのビルドで依存しているコンポーネントをインストール
sudo apt-get install autoconf automake libtool

./autogen.sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB"
make
```

HSM SECOと追加のdevcryptoサポートを使ってのビルド例。
インクルードパスとして`crypto/cryptodev.h`の場所を指定する必要があります。

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

- `WOLFSSL_SECO_CAAM` - CAAMでのSECO HSM使用を有効にします（AES-GCMが必要で、平文鍵をHSMにインポートするためのアルゴリズムとして使用されます）。このマクロを定義すると、`WOLFSSL_CAAM`、`WOLFSSL_HASH_KEEP`、`WOLFSSL_NO_CAAM_BLOB`も定義されます。
- `WOLFSSL_CAAM` - CAAMサポートを有効にするメインマクロスイッチ。
- `WOLF_CRYPTO_CB` - CAAMサポートは暗号コールバックを利用します。user_settings.hではこのマクロを定義する必要があります。configureは`--enable-caam`の指定時に自動的に追加します。
- `WOLFSSL_HASH_KEEP` - SHA256などのアルゴリズムでハッシュする場合、メッセージを構築し、Final呼び出し時にのみハッシュするために送信します。

`WOLFSSL_CAAM`は、CAAMのアルゴリズムサポートを（`wolfssl/wolfcrypt/settings.h`で）自動的に有効にします。
有効になるのは、`WOLFSSL_CAAM_CIPHER`（AES。CMACは`WOLFSSL_CAAM_CMAC`として含まれます）、`WOLFSSL_CAAM_HASH`、`WOLFSSL_CAAM_ECC`、`WOLFSSL_DEVCRYPTO_HMAC`が定義されている場合の`WOLFSSL_CAAM_HMAC`、および`WOLFSSL_SECO_CAAM`が定義されている場合の`WOLFSSL_CAAM_CURVE25519`です。
これらは通常、手動で設定するものではありません。
個別の機能を無効にするには、以下を使用します。

- `WOLFSSL_NO_CAAM_HASH` - ハッシュにCAAMを使用しません。
- `WOLFSSL_NO_CAAM_ECC` - ECCにCAAMを使用しません。
- `WOLFSSL_NO_CAAM_CMAC` - AES-CMACにCAAMを使用しません。
- `WOLFSSL_NO_CAAM_AESCCM` - AES-CCMにCAAMを使用しません。
- `WOLFSSL_NO_CAAM_BLOB` - CAAMのblobサポートを無効にします。
- `WOLFSSL_LP_ONLY_CAAM_AES` - CAAMが低消費電力AESモジュールのみを備えているため、AES-GCMとAES-XTSはCAAMでは実行されません。

***cryptodev-linux***

- `WOLFSSL_DEVCRYPTO` - `cryptodev-linux`使用を有効にするメインマクロスイッチ。
- `WOLFSSL_DEVCRYPTO_HMAC` - `cryptodev-linux`でのHMACサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_RSA` - `cryptodev-linux`でのRSAサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_CURVE25519` - `cryptodev-linux`でのCurve25519サポートを有効にします。
- `WOLFSSL_DEVCRYPTO_ECDSA` - `cryptodev-linux`でのECDSAサポートを有効にします。
- `WOLFSSL_DEVCRYPTO_HASH_KEEP` - `cryptodev-linux`でのハッシュ蓄積サポートを有効にします。

***CAAMサポートのためにコンパイルする必要がある追加ファイル***

- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_aes.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_cmac.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_rsa.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_ecdsa.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_x25519.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_hash.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_hmac.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_init.c`
- `wolfssl/wolfcrypt/src/port/caam/wolfcaam_seco.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_ecdsa.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_x25519.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_rsa.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_hmac.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_hash.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_aes.c`
- `wolfssl/wolfcrypt/src/port/devcrypto/wc_devcrypto.c`
- `wolfssl/wolfcrypt/src/cryptocb.c`

#### サンプルプログラム

##### Testwolfcryptの実行

wolfSSLにバンドルされている単体テストは、`wolfcrypt/test/test.c`にあります。
デバイス上でテストをビルドして実行する例は次のとおりです。
これは`WOLFSSL_CAAM_DEVID`を使用するため、NXP HSMライブラリではなくcryptodevモジュールを使用していることにご注意ください。

```
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

そのほかのサンプルプログラムを、wolfssl-examplesリポジトリの`caam/seco`ディレクトリ配下に用意しています。

```sh
git clone https://github.com/wolfssl/wolfssl-examples
cd wolfssl-examples/caam/seco
make
```

##### ソースコードをコンパイル[user_settings.hを使用]

wolfSSLにリンクする単一のソースファイルをビルドするには、次のコマンドを使用します。
前のステップの環境変数がまだ設定されていると仮定します。

```
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

$CC -DWOLFSSL_USER_SETTINGS -I /path/to/dir/containing/user_settings.h \
-I $CRYPTODEV_DIR -I $HSM_DIR/include -I ./wolfssl server-dtls.c \
libwolfssl.a $HSM_DIR/lib/hsm_lib.a $HSM_DIR/lib/seco_nvm_manager.a \
$ZLIB_DIR/lib/libz.a -lpthread -lm
```

#### API

##### 追加されたAPI

***追加されたAPIの一覧***

- `void wc_SECO_AesSetKeyID(Aes* aes, int keyId);`
この関数はSECOキーIDを`Aes`構造体にセットする際に使用します。
`Aes`構造体が初期化された後で、暗号化/復号操作に使用される前に呼び出される必要があります。
- `int wc_SECO_AesGetKeyID(Aes* aes);`
`Aes`構造体にセットされているSECOキーIDのゲッター関数です。
- `void wc_SECO_CMACSetKeyID(Cmac* cmac, int keyId);`
`wc_SECO_AesSetKeyID`関数と似ていますが、対象が`Cmac`構造体になっています。
- `int wc_SECO_CMACGetKeyID(Cmac* cmac);`
`Cmac`構造体にセットされているSECOキーIDのゲッター関数です。
- `int wc_SECO_OpenHSM(word32 keyStoreId, word32 nonce, word16 maxUpdates, byte flag);`
この関数は、キーストアが必要となる操作（ECCやAESの操作など）の前に呼び出される必要があります。
最初の引数はキーストアID、`nonce`はキーストアを新規に作成する場合や、既存のキーストアをアンロックするのに使用される特定の32ビット値です。
`maxUpdates`はキーストアが更新できる最大回数を指定します。
`flag`はオプショナルフラグで、キーストアを作成するかどうかを示すために使用されます。
HSMキーストアを作成するためには`flag`は`CAAM_KEYSTORE_CREATE`でなければならず、既存のキーストアをオープンまたは更新するには`CAAM_KEYSTORE_UPDATE`にする必要があります。
- `int wc_SECO_CloseHSM(void);`
この関数は、キーストアの使用が完了したとき、`wolfCrypt_Cleanup`/`wolfSSL_Cleanup`を呼び出す前に呼び出す必要があります。
現在オープンしているキーストアを閉じます。
- `int wc_SECO_GenerateKey(int flags, int group, byte* out, int outSz, int keyType, int keyInfo, unsigned int* keyIdOut);`
この関数は、SECOで新しいキーを生成するために使用できます。
キー生成の場合、`flags`は`CAAM_GENERATE_KEY`である必要があります。
キーを更新する場合、`flags`は`CAAM_UPDATE_KEY`である必要があります。
`keyIdOut`引数は、キーの作成時に設定される入出力引数であり、キーの更新時に入力として設定する必要があります。
キーを更新する場合は、一時的なタイプである必要があり、更新のために`group`を0に設定する必要があります。
一時的なタイプは`keyInfo`引数として設定されます。
`keyInfo`と`keyType`の可能なオプションは以下のとおりです。
    - `CAAM_KEY_TRANSIENT` (`keyInfo`)
    - `CAAM_KEY_PERSISTENT` (`keyInfo`)
    - `CAAM_KEY_KEK` (`keyInfo`、鍵を鍵暗号化鍵として使用します)
    - `CAAM_KEYTYPE_ECDSA_P256` (`keyType`)
    - `CAAM_KEYTYPE_ECDSA_P384` (`keyType`)
    - `CAAM_KEYTYPE_ECDSA_P521` (`keyType`)
    - `CAAM_KEYTYPE_AES128` (`keyType`)
    - `CAAM_KEYTYPE_AES192` (`keyType`)
    - `CAAM_KEYTYPE_AES256` (`keyType`)
    - `CAAM_KEYTYPE_HMAC224`、`CAAM_KEYTYPE_HMAC256`、`CAAM_KEYTYPE_HMAC384`、`CAAM_KEYTYPE_HMAC512` (`keyType`、NXP HSMライブラリがサポートしている場合)
- `int wc_SECO_DeleteKey(unsigned int keyId, int group, int keyTypeIn);`
キーストアから鍵を削除するのに使用されます。
- `word32 wc_SECO_WrapKey(word32 keyID, byte* in, word32 inSz, byte* iv, word32 ivSz, int keyType, int keyInfo, int group);`
平文の鍵`in`を鍵暗号化鍵（KEK）でAES-GCM暗号化し、キーストアにインポートします。
`keyID`が0の場合はデバイス固有のルートKEKが使用され、それ以外の場合`keyID`はキーストアに既に存在するKEKのIDです。
IVは12バイトである必要があります。
`keyType`、`keyInfo`、`group`は`wc_SECO_GenerateKey`と同じです。
成功時は新しい鍵IDを返し、失敗時は0を返します。

##### CAAMをサポートするネイティブwolfSSL API

これは、このドキュメントで概説されているSECOビルドでCAAMサポートを備えたネイティブwolfSSL APIのリストです。

AES暗号化と復号化操作の生成には、次のプロセスで鍵を生成できます。
`wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTYPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut);`を使用します。
ここで`groupID`は指定されたグループ番号、`pubOut`は32バイトのバッファ、変数`keyIdOut`は生成された新しい鍵IDに設定されます。
この生成された新しい鍵IDは、`wc_SECO_AesSetKeyID(Aes, keyIdOut);`を使用して`Aes`構造体に設定できます。
鍵IDが構造体に設定され、`Aes`構造体が`WOLFSSL_SECO_DEVID`タイプとして初期化されると、すべての暗号化および復号化操作にその鍵IDが使用されます。

###### ***AES (ECB/CBC)***

AES ECB/CBC鍵を生成する代わりに、`Aes`構造体が`WOLFSSL_SECO_DEVID`で初期化されている場合は、プレーンテキストキーを渡して関数`wc_AesSetKey`を呼び出すことができます。
API `wc_AesSetKey`は、一意の`KEK`を使用して鍵を暗号化し、`SECO HSM`にインポートしようとします。
インポートが成功すると、値`0`が返され、鍵IDが`Aes`構造体に設定されます。

- CBC暗号化は`wc_AesCbcEncrypt`で行われ、復号は`wc_AesCbcDecrypt`で行われます。
- ECB暗号化は`wc_AesEcbEncrypt`で行われ、復号は`wc_AesEcbDecrypt`で行われます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes);`を使用して解放する必要があります。

###### ***AES-GCM***

- GCM暗号化は`wc_AesGcmEncrypt`で行われ、復号は`wc_AesGcmDecrypt`で行われます。

AES-GCM暗号化関数は、`Aes`構造体、出力バッファ、入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト必要)、MACまたはタグとして知られる、タグサイズ(`16`バイトが必要)、追加データ、追加データサイズ（4バイト）を引数として取ります。
暗号化の場合、入力バッファは暗号化され、タグバッファは作成された`MAC`で埋められます。

AES-GCM復号の場合、関数は`Aes`構造体、プレーンテキスト出力バッファ、暗号テキスト入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト)、暗号化呼び出しで以前に作成されたタグ、タグバッファサイズ、追加データ、追加のデータサイズを引数として取ります。
復号化時にタグバッファがチェックされ、メッセージの整合性が検証されます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes);`を使用して解放する必要があります。

###### ***AES-CCM***

- CCM暗号化は`wc_AesCcmEncrypt`、復号は`wc_AesCcmDecrypt`で行われます。

AES-CCM暗号化関数は、`Aes`構造体、出力バッファ、入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ (12 バイトが必要)、MACまたはタグとして知られる、タグサイズ(16バイト必要)、 追加データ、追加データサイズ（0バイト）を引数として取ります。
追加のデータバッファは `NULL`にする必要があり、NXP HSMライブラリではサイズ 0 が必要です。
暗号化の場合、入力バッファは暗号化され、タグバッファは作成されたMACで埋められます。

AES-CCM復号の場合、関数は`Aes`構造体、プレーンテキスト出力バッファ、暗号テキスト入力バッファ、入力バッファサイズ、ノンス、ノンスサイズ(12バイト)、暗号化呼び出しで以前に作成されたタグ、タグバッファサイズ、追加データ、 追加のデータサイズを引数に取ります。
暗号化関数と同様に、追加のデータバッファーは`NULL`である必要があります。
復号時にタグバッファがチェックされ、メッセージの整合性が検証されます。

`Aes`構造体の使用が完了したら、`wc_AesFree(Aes);`を使用して解放する必要があります。

###### ***AES CMAC***

AES CMAC操作の場合、`wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTYPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut);` を使用してAES鍵を生成できます。
ここで、`groupID`は指定されたグループ番号、`pubOut`は32バイトのバッファーであり、変数`keyIdOut`は生成された新しいキーIDに設定されます。
生成されたこの新しいキーID は、`wc_SECO_CMACSetKeyID(cmac, keyIdOut)`を使用して`Cmac`構造体に設定できます。
キーIDが構造体に設定され、`Cmac`構造体が`WOLFSSL_SECO_DEVID`で初期化されると、すべてのCMAC操作にそのキーIDが使用されます。

HSMライブラリはシングルショットタイプであるため、`wc_CmacUpdate`を呼び出すたびに入力が内部バッファに保存されます。
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

SECOで使用する場合 (NXP HSMライブラリを使用)、`ecc_key`構造体を初期化するときに `WOLFSSL_SECO_DEVID`のdev IDフラグを使用する必要があります。
cryptodev-linuxモジュールで使用するには、dev IDフラグ `WOLFSSL_CAAM_DEVID`を使用する必要があります。
関数 `wc_ecc_init_ex(key, heap-hint (can be NULL), devId);` による初期化後は、どちらのユースケースも署名と検証に同じネイティブwolfSSL関数呼び出しを使用します。

`ecc_key`構造体の初期化後の関数呼び出しの例は次のようになります。

```lang-c
wc_ecc_make_key(&rng, 32, key); /* 32バイトの鍵サイズ: P-256 */
wc_ecc_sign_hash(hash, hashSz, sigOut, &sigOutSz, &rng, key);
wc_ecc_verify_hash(sig, sigSz, hash, hashSz, &result, key);
```

また、cryptodev-linuxモジュール(`WOLFSSL_CAAM_DEVID`)を使用すると、ECDH関数を使用できます。

```lang-c
wc_ecc_shared_secret(keyA, keyB, sharedSecret, &sharedSecretSz);
```

###### ***ハッシュ (Sha256, Sha384, HMAC)***

SHA256およびSHA384の操作では、NXP HSMライブラリを使用します。
HMAC操作では、cryptodev-linuxモジュールが使用されます。

デフォルトでは、SHA操作はNXP HSMライブラリを利用しようとしますが、dev IDを明示的に`WOLFSSL_SECO_DEVID`に設定することもできます。

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
wc_curve25519_shared_secret(key, keyB, sharedSecretOut, &sharedSecretOutSz);
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

QNXでは、CAAMはwolfCryptリソースマネージャーを介して使用します。
まず、QNXツールチェーンを使用し、configureオプション`--enable-caam=qnx`を指定してwolfSSLをビルドします。
例えば次のようにします（`--host`はターゲットに合わせて設定してください）。

```sh
source ~/qnx700/qnxsdp-env.sh
./configure --host=arm-unknown-nto-qnx7.0.0eabi --enable-caam=qnx
make
```

次に、`IDE/QNX/CAAM-DRIVER`で`make`を実行してリソースマネージャーをビルドし、デバイス上でroot権限で起動します。
これにより、`/dev/wolfCrypt`にアクセスできるユーザーであれば誰でもドライバーを利用できます。
AArch64では、ドライバーはi.MX8 QXPを想定しており、ジョブリング2用に確保されたメモリブロックを使用します。

`IDE/QNX`には、wolfSSLライブラリと、wolfCryptテスト、TLSクライアントとサーバー、CMACのサンプル用のMakefile、およびMomentics IDE用のプロジェクトも含まれています。
Momenticsへのインポート手順と、ドライバーがサポートする操作（ECCブラックキー、blob、カバーキー、CMAC、AES-CTR、TRNG）の一覧については、`IDE/QNX/README.md`をご参照ください。

### i.MX6 (QNX)

手順はi.MX8 (QNX)と同じです。
i.MX6Qデバイスの場合は`--enable-caam=qnx,imx6q`を指定してビルドします。
これにより`WOLFSSL_IMX6Q_CAAM`が定義されます。
このデバイスは低消費電力AESモジュールのみを備えており（AES-GCMなし）、CAAMのECCもありません。
configureは`imx6ul`も受け付けます。
リソースマネージャーが使用するCAAMのベースアドレスは`IDE/QNX/CAAM-DRIVER/Makefile`で設定します。
`-DWOLFSSL_CAAM_IMX6Q`（デフォルトで設定されています）はi.MX6Qのアドレスを選択し、これがない場合はi.MX6ULのアドレスが使用されます。

### その他のCAAMターゲット

- `--enable-caam=linux`は、LinuxのユーザースペースプロセスからCAAMのジョブリングを直接操作します（QorIQ T1040上で開発され、AES-CBC、AES-CTR、AES-ECB、TRNGを高速化します）。
  必要なカーネルとメモリの設定については、`wolfcrypt/src/port/caam/README.md`をご参照ください。
- INTEGRITY上のi.MXについては、`wolfcrypt/src/port/caam/caam_doc.pdf`をご参照ください。

### IMXRT1170 (FreeRTOS)

IMXRT1170で使用するIDEセットアップの例は、`IDE/MCUEXPRESSO/RT1170` ディレクトリにあります。

#### ビルド手順

- MCUEXPRESSOを開き、ワークスペースを`wolfssl/IDE/MCUEXPRESSO/RT1170`に設定します。
- ファイル -> ファイル システムからプロジェクトを開く... -> ディレクトリ : 参照先を `wolfssl/IDE/MCUEXPRESSO/RT1170` ディレクトリに設定し、「ディレクトリの選択」をクリックします。
- `wolfssl_cm7`と`wolfcrypt_test_cm7`を選択します。
- プロジェクトを右クリック -> SDK 管理 -> SDK コンポーネントを更新し、「はい」をクリックします。
- `FreeRTOSConfig.h`の`configTOTAL_HEAP_SIZE`のサイズを増やします（`IDE/MCUEXPRESSO/README.md`では、wolfCryptテストおよびベンチマークプロジェクトに200000を使用しています）。
- （注：ボードファイルを再作成する必要があります。これは、同じ設定を持つ新しいプロジェクトを作成し、生成された`board/*`ファイルをコピーすることで実行できます）
- プロジェクトをビルドします。

CSRのサンプルはwolfssl-examplesリポジトリ（<https://github.com/wolfssl/wolfssl-examples>）のcertgenディレクトリに、PKCS7のサンプルはpkcs7ディレクトリに、CMakeを使用したビルドのサンプルはcmakeディレクトリにあります。

#### RT1170 CAAM ドライバーの拡張

ファイル`RT1170/fsl_caam_h.patch`および`RT1170/fsl_caam_c.patch`には、Blobの作成/オープン、および ECC ブラックキーの生成と使用のための既存のNXP CAAMドライバーへの変更が含まれています。

パッチを適用するには、まずcaamドライバーを含むプロジェクトを作成します。
これにより、ドライバーディレクトリにベースとなる`fsl_caam.c`と`fsl_caam.h`が生成されます（例：`wolfcrypt_test_cm7/drivers/fsl_caam.{c,h}`）。
基本ファイルが生成されたら、ドライバーディレクトリに"cd"してパッチを適用します（`cd wolfcrypt_test_cm7/drivers/ && patch < ../../fsl_caam_c.patch && patch < ../../fsl_caam_h.patch`）。

`fsl_caam.h`のパッチには、ECCとBlobの拡張（`CAAM_ECC_EXPANSION`および`CAAM_BLOB_EXPANSION`）の両方に対するマクロが定義されています。
wolfSSLコードはこれらのマクロが定義されている（パッチが適用されている）ことを検出すると、拡張ドライバーの使用をコンパイルしようとします。
