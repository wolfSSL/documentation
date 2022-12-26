#  wolfMQTTのビルド
wolfMQTT は移植性を念頭に置いて作成されており、通常、ほとんどのシステムで簡単に構築できるはずです。 ビルドに問題がある場合は、**サポート フォーラム** https://www.wolfssl.com/forums からサポートを求めるか、 **support@wolfssl.com** まで直接お問い合わせください。 この章では、Unix および Windows で wolfMQTT を構築する方法を説明し、非標準環境で構築するためのガイダンスを提供します。

autoconf / automake システムを使用してビルドする場合、wolfMQTT は単一の Makefile を使用してライブラリのすべてのパーツとサンプルをビルドします。これは、Makefile を再帰的に使用するよりも簡単で高速です。 TLS 機能またはファームウェア/Azure IoT Hub の例を使用する場合は、wolfSSL をインストールする必要があります。 wolfSSL と wolfMQTT については、以下の設定オプションを使用することをお勧めします


```
./configure  --enable-ecc  --enable-supportedcurves  --enable-base64encode. 
```

wolfSSL の場合は、`make && sudo make install` を使用します。 libwolfssl.so の検索でエラーが発生した場合は、wolfSSL ディレクトリから`sudo ldconfig`を実行します。


##  ソースコードの取得

wolfMQTT の最新バージョンは、wolfSSL [ダウンロード ページ](https://www.wolfssl.jp/download/)からダウンロードできます。 <br>
あるいはGithubから次のコマンドで取得できます: <br>
```
git clone https://github.com/wolfSSL/wolfMQTT.git
```

##  *nix/Mac上でのビルド

Linux, *BSD, OS X, Solaris, あるいは他の *nix-ライクなシステムでのビルドはautoconf システムを使ってください。 githubからクローンした場合には, 次のコマンドを実行してください:
```
./autogen.sh
./configure
make
```
そのほかの場合には次の2行のコマンドを実行してください:
```
./configure
make
```

`./configure` にはビルド オプションをいくつでも追加できます。 利用可能なビルド オプションのリストについては、以下のコマンドを実行してください：


```
./configure --help
```

wolfMQTTのビルドには次のmakeコマンドを実行:
```
make
```
wolfMQTTをインストールする為に:
```
make install
```

インストールの実行の為にはスーパーユーザー権限が必要かもしれません。その場合にはコマンドの前にsudoをつけてください：

```
sudo make install
```

ノート：
* `wolfssl` が最近インストールされた場合は、`sudo ldconfig` を実行してリンカ キャッシュを更新します。
* デバッグ メッセージは、`--enable-debug` または `--enable-debug=verbose` を使用して有効にできます (追加のロギング用)。
* ビルド オプションのリストについては、`./configure --help` を実行してください。
* ビルド オプションは、`wolfmqtt/options.h` のファイルに生成されます。

ビルドをテストするには、ルート wolfMQTT ソース ディレクトリから _mqttclient_ プログラムを実行します:


```
./examples/mqttclient/mqttclient
```
 wolfMQTT ライブラリのみをビルドし、追加のアイテム (サンプルプログラム等) はビルドしないようにする場合は、wolfMQTT ルート ディレクトリから次のコマンドを実行できます:



```
make src/libwolfmqtt.la
```


##  Windows上でのビルド

**Visual Studio** :

Visual Studio で TLS をサポートする wolfMQTT を構築する場合:

1. `<wolfssl-root>/wolfssl64.sln`を開きます。
2. Visual Studio のバージョンを再ターゲットします (ソリューションを右クリックし、`ソリューションの再ターゲット` を選択します)。
3. `DLL のデバッグ`または`DLL のリリース`構成が選択されていることを確認します。 32 ビットの `x86` または 64 ビットの `x64` をビルドしている場合は注意してください。
4. wolfSSL ソリューションを構築します。
5. `wolfssl.lib` および `wolfssl.dll` ファイルを `<wolfmqtt-root>` にコピーします。
    * `x86` を使用した `DLL Debug` の場合、ファイルは `DLL Debug` にあります。
    * `x86` の `DLL Release` の場合、ファイルは `DLL Release` にあります。
    * `x64` を使用した `DLL Debug` の場合、ファイルは `x64/DLL Debug` にあります。
    * `x64` の `DLL Release` の場合、ファイルは `x64/DLL Release` にあります。
6. `<wolfmqtt-root>/wolfmqtt.sln` ソリューションを開きます。
7. 上記の wolfSSL で使用されているのと同じアーキテクチャ (`x86` または `x64` が選択されている) であることを確認してください。
8. デフォルトでは、wolfSSL ヘッダーのインクルード パスは `./../wolfssl/` です。 wolfSSL ルートの場所が異なる場合は、プロジェクト設定に移動し、`C/C++` -> `一般` -> `追加のインクルード ディレクトリ` でこれを調整できます。
9. `wolfmqtt/vs_settings.h` を使用して Visual Studio のビルド設定を構成します。
10. wolfMQTT ソリューションをビルドします。

Visual Studio 2015 の wolfmqtt.sln ソリューションは、インストールのルート ディレクトリに含まれています。 各ビルドをテストするには、Visual Studio メニューから "Build All" を選択し、mqttclient プログラムを実行します。 Visual Studio プロジェクトでビルド オプションを編集するには、目的のプロジェクト (wolfmqtt、mqttclient) を選択し、"プロパティ"パネルを参照します。

必要な wolfssl.dll のビルド手順については、[こちら](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio) を参照してください。 完了したら、wolfssl.dll と wolfssl.lib を wolfMQTT ルートにコピーします。 プロジェクトは、wolfSSL ヘッダーが `../wolfssl/` にあることも前提としています。

**Cygwin** : Cygwin、または *nix のようなコマンドと機能を提供する Windows 用のその他のツールセットを使用している場合は、上記のセクション 2.2 の「*nix でのビルド」の手順に従ってください。 Windows 開発マシンで Windows 用の wolfMQTT をビルドする場合、付属の Visual Studio プロジェクト ファイルを使用して wolfMQTT をビルドすることをお勧めします。



##  Arduino上でのビルド 

### wolfMQTTをArduinoライブラリとコンパチブルに再構成 

wolfmqtt-arduino.sh は、Arduino プロジェクトと互換性があるように wolfMQTT ライブラリを再編成するシェル スクリプトです。 Arduino IDE では、ライブラリのソース ファイルがライブラリのルート ディレクトリにあり、ライブラリの名前にヘッダーファイルが含まれている必要があります。 このスクリプトは、すべてのソース ファイルを`IDE/ARDUINO/wolfMQTT`ディレクトリにコピーし、`wolfMQTT.h`という名前のスタブヘッダー ファイルを作成します。

Arduino で wolfMQTT を設定するには、IDE/ARDUINO ディレクトリ内から次のように入力します:


```
    ./wolfmqtt-arduino.sh
```
### wolfMQTTをArduinoライブラリ群に含める(for Arduino version 1.8.2)

1. Arduino IDE で:
     - `Sketch -> Include Library -> Add .ZIP Library...` で、
         「IDE/ARDUNIO/wolfMQTT」フォルダー。
     - `Sketch -> Include Library` で wolfMQTT を選択します。

TLS サポートを有効にするには、`#define ENABLE_MQTT_TLS` を追加します
     `IDE/ARDUNIO/wolfMQTT/wolfmqtt/options.h`.
注: wolfSSL TLS を使用している場合は、wolfSSL に対してもこれを行う必要があります。
手順については、`<wolfssl-root>/IDE/ARDUINO/README.md` を参照してください。


サンプルの wolfMQTT クライアント INO スケッチは次の場所にあります。
`wolfmqtt_client/wolfmqtt_client.ino` を参照して、wolfMQTT ライブラリの使用方法を示します。



##  MinGWを使ってビルド

wolfSSL と wolfMQTT の両方をダウンロードしたら、以下のスクリプトを実行してビルドし、両方をインストールします:


```sh
export PATH="/opt/mingw-w32-bin_i686-darwin/bin:$PATH"
export PREFIX=$PWD/build

# wolfSSL
cd wolfssl
./configure --host=i686 CC=i686-w64-mingw32-gcc LD=i686-w64-mingw32-ld CFLAGS="-DWIN32 -DMINGW -D_WIN32_WINNT=0x0600" LIBS="-lws2_32 -L$PREFIX/lib -lwolfssl" --prefix=$PREFIX
make
make install

# wolfMQTT
cd ../wolfmqtt
./configure --host=i686 CC=i686-w64-mingw32-gcc LD=i686-w64-mingw32-ld CFLAGS="-DWIN32 -DMINGW -D_WIN32_WINNT=0x0600 -DBUILDING_WOLFMQTT -I$PREFIX/include" LDFLAGS="-lws2_32 -L$PREFIX/lib -lwolfssl" --prefix=$PREFIX --disable-examples
make
```

##  非標準環境でのビルド
公式にはサポートされていませんが、特に組み込みシステムやクロスコンパイルシステムを使用して、非標準環境で wolfMQTT を構築したいユーザーを支援しようとしています。 以下は、これを開始する際の注意事項です。

1. ソース ファイルとヘッダー ファイルは、wolfMQTT ダウンロード パッケージと同じディレクトリ構造にある必要があります。
2. 一部のビルド システムでは、wolfMQTT ヘッダー ファイルの場所を明示的に知りたい場合があるため、それを指定する必要がある場合があります。 これらは、`<wolfmqtt_root>/wolfmqtt` ディレクトリにあります。 通常、<wolfmqtt_root> ディレクトリをインクルード パスに追加して、ヘッダーの問題を解決できます。
3. 構成プロセスがビッグ エンディアンを検出しない限り、wolfMQTT はリトルエンディアン システムにデフォルト設定されます。 非標準環境でビルドするユーザーは構成プロセスを使用しないため、ビッグ エンディアン システムを使用する場合は BIG_ENDIAN_ORDER を定義する必要があります。
4. ライブラリの構築を試み、問題が発生した場合はお知らせください。 サポートが必要な場合は、_support@wolfssl.com_ までご連絡ください。



##  クロスコンパイル

組み込みプラットフォームの多くのユーザーは、環境に合わせてクロス コンパイルします。 ライブラリをクロスコンパイルする最も簡単な方法は、./configure システムを使用することです。 これにより、wolfMQTT のビルドに使用できる Makefile が生成されます。 クロス コンパイルするときは、次のように `./configure` にホストを指定する必要があります:


```
./configure --host=arm-linux
```
使用するコンパイラ、リンカーなどを指定する必要がある場合もあります:

```
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```
クロスコンパイル用に wolfMQTT を正しく設定した後は、ライブラリのビルドとインストールのための標準的な autoconf プラクティスに従うことができるはずです:

```
make
sudo make install
```
wolfMQTT のクロス コンパイルに関する追加のヒントやフィードバックがある場合は、_info@wolfssl.com_ までお知らせください。


### 特定のディレクトリへのインストール

wolfSSL のカスタムインストール ディレクトリをセットアップし、wolfMQTT のカスタム wolfSSL lib/include ディレクトリを指定するには、以下を使用します:

wolfSSLディレクトリで:
```
./configure  --prefix=~/wolfssl
make
make install
```
これにより、ライブラリが `~/wolfssl/lib` に配置され、`~/wolfssl/include` にインクルードされます。


wolfMQTTディレクトリで:

```
./configure --prefix=~/wolfmqtt  --libdir=~/wolfssl/lib  --includedir=~/wolfssl/include
make
make install
```

上記のパスが実際の場所と一致していることを確認してください。