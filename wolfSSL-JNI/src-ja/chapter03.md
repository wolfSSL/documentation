# wolfSSL JNI と wolfJSSE のコンパイル

wolfJSSE をコンパイルする方法を3つ、ここで紹介します。
Unix コマンドライン、Android Studio ビルド、汎用 IDE ビルドを使用します。


## Unix コマンドライン

このセクションの手順を実行する前に、第2章に記載のシステム要件とされているものがインストールされていることを確認してください。

パッケージのルートフォルダの `java.sh` スクリプトは、ネイティブのJNI C ソース ファイルをコンパイルしてUnix/Linux または Mac OSX 用の共有ライブラリとするために使用されます。

このスクリプトは、OSX (Darwin) から Linux までのOSを自動検出してインクルード パスと共有ライブラリ拡張タイプをセットアップしようとします。さらに、このスクリプトはJNI C ソース ファイルに対して gcc を直接呼び出して、`./lib/libwolfssljni.so` または`./lib/libwolfssljni.dylib`を生成します。


```
$ ./java.sh

Compiling Native JNI library:
    WOLFSSL_INSTALL_DIR = /usr/local
    Detected Linux host OS
        Linux x86_64
    Java Home = /usr/lib/jvm/java-8-openjdk-amd64
    Generated ./lib/libwolfssljni.so
```
`/usr/local` にインストールされていないネイティブ wolfSSL ライブラリに対してリンクする場合には、 wolfSSL インストールフォルダを表す引数を `java.sh` に渡す必要があります。

例えば：


```
$ ./java.sh /path/to/wolfssl/install
```

Javaソースファイルのビルドには`ant`を使います:

```
$ ant
```
`ant` に対して指定可能なビルドターゲット：


- `ant` (アプリケーションに必要なjarのみビルド）
- `ant test` (jarとテスト実行に必要なテストをビルド。要JUNITのセットアップ）
- `ant examples` (jarとサンプルプログラムをビルド)
- `ant clean` (Javaアーティファクトをクリーンアップ)
- `ant cleanjni` (ネイティブアーティファクトをクリーンアップ)

次のコマンドは、プロジェクトで wolfJSSE を使用するために必要な wolfJSSE jar とネイティブ コードをビルドします。 JUnit テストをコンパイルして実行するには、コマンド `ant test` を使用します：

```
$ ant test
```

コマンドを実行すると、テストがコンパイルされ、主な wolfJSSE コードとテスト結果の出力が、wolfJSSE テストスイートと wolfSSL JNI テストスイートの最後に合格した全テストの要約とともに表示されます。 ビルドが成功すると、最後に "BUILD SUCCESSFUL" というメッセージが表示されます。



```
[junit] WolfSSLTrustX509 Class
[junit] Testing parse all_mixed.jks ... passed
[junit] Testing loading default certs ... passed
[junit] Testing parse all.jks ... passed
[junit] Testing verify ... passed
...

build:

BUILD SUCCESSFUL
Total time: 18 seconds
```
wolfJSSEにバンドルされているサンプルプログラムをビルドして実行するためには`ant examples`を使います：

```
$ ant examples
```

## Android Studio を使ってのビルド

Android Studio プロジェクトが、ディレクトリ `IDE/Android` に用意してあります。これは、wolfssljni / wolfJSSE の Android Studio プロジェクト ファイルのサンプルプログラムです。このプロジェクトは参照用としてのみ使用してください。

テスト時に使用されるツールとバージョン情報の詳細については、`wolfssljni/IDE/Android/README.md` を参照してください。 次の手順は、Android デバイスまたはエミュレーターでこのサンプルプログラムを実行するために必要です。


### 1. ネイティブ wolfSSL ライブラリのソースをプロジェクトに追加

このサンプルプロジェクトは、ネイティブwolfSSL ライブラリのソースファイルをコンパイルしてビルドするように既に設定されています。ただし、wolfSSL ファイル自体はパッケージに含まれていないので、適切なバージョンをダウンロードしてリンクする必要があります。以下のオプションのいずれかを使用して、このプロジェクトに wolfSSL を追加します。

プロジェクトはwolfSSL ソースコードのディレクトリを `wolfssljni/IDE/Android/app/src/main/cpp/wolfssl`から探します。

これは複数の方法で追加できます：

- オプション A: www.wolfssl.com から最新の wolfSSL ライブラリ リリースをダウンロードします。解凍し、名前を"wolfssl"に変更して、ディレクトリ`wolfssljni/IDE/Android/app/src/main/cpp/` に配置します。


```
$ unzip wolfssl-X.X.X.zip
$ mv wolfssl-X.X.X wolfssljni/IDE/Android/app/src/main/cpp/wolfssl
```
- オプション B: GitHub を使用してwolfSSL をクローンすることもできます：

```
$ cd /IDE/Android/app/src/main/cpp/
$ git clone https://github.com/wolfssl/wolfssl
$ cp wolfssl/options.h.in wolfssl/options.h
```
- オプション C: システム上の wolfSSL ディレクトリへのシンボリック リンクを作成:


```
$ cd /IDE/Android/app/src/main/cpp/
$ ln -s /path/to/local/wolfssl ./wolfssl
```

### 2. Java シンボリックリンクを更新 (Windowsユーザーのみ必要)

次の Java ソース ディレクトリは、Unix/Linux の　symlinkです：


```
wolfssljni/IDE/Android/app/src/main/java/com/wolfssl
```
これは Windows では正しく機能しないので、新しい Windows シンボリック リンクを作成する必要があります：

1) Windows コマンド プロンプトを開きます (右クリックし、`管理者として実行`)。
2) `wolfssljni\IDE\Android\app\src\main\java\com`に移動。
3) 既存のシンボリックリンクファイルを削除します ("wolfssl"という名前のファイルとして表示されます)。


```
del wolfssl
```

4) `mklink` で新しい相対シンボリック リンクを作成します:

```
mklink /D wolfssl ..\..\..\..\..\..\..\src\java\com\wolfssl\
```

### 3. サンプルプログラムのJKSファイルをAndroid用のBKSに変換

Android デバイスでは、BKS 形式のキーストアが想定されています。 JKS サンプルバンドルを BKS に変換するには、次のコマンドを使用します(注: Bouncy Castle の Web サイトから bcprov JAR のバージョンをダウンロードする必要があります):


```
cd examples/provider
./convert-to-bks.sh <path/to/provider>
```
例えば、bcprov-ext-jdk15on-169.jar を使用する場合:


```
cd examples/provider
./convert-to-bks.sh ~/Downloads/bcprov-ext-jdk15on-169.jar
```

### 4. BKSファイルをAndroidデバイス/エミュレータにプッシュ

BKS バンドルを証明書とともにデバイスにプッシュします。 エミュレーター/デバイスを起動し、"adb push"を使用します。 例として、wolfssljniのルートディレクトリからの以下の様なコマンドを実行します。 この手順は、Android Studio を起動してプロジェクトをコンパイルした後に行うことができますが、アプリまたはテスト ケースを実行する前に行う必要があります。


```
adb shell
cd sdcard
mkdir examples
mkdir examples/provider
mkdir examples/certs
exit
adb push ./examples/provider/*.bks /sdcard/examples/provider/
adb push ./examples/certs/ /sdcard/examples/
adb push ./examples/certs/intermediate/* /sdcard/examples/certs/intermediate/
```

### 5. サンプルプログラムプロジェクトをAndroid Studioにインポートしてビルド
1) wolfssljni/IDE/ の"Android"フォルダをダブルクリックして、Android Studio プロジェクトを開きます。 または、Android Studio 内から、wolfssljni/IDE ディレクトリにある"Android"プロジェクトを開きます。

2) プロジェクトをビルドし、アプリ -> java/com/example.wolfssl から MainActivity を実行します。 これにより、/sdcard/ ディレクトリ内の証明書にアクセスする許可が求められ、成功するとサーバー証明書情報が出力されます。

3) オプション: androidTests は、許可が与えられた後に実行できます。 app->java->com.wolfssl->provider.jsse.test->WolfSSLJSSETestSuite
 および app->java->com.wolfssl->test->WolfSSLTestSuite


## 汎用 IDE でビルド

一般的な IDE ビルドの場合、IDE で新しいプロジェクトを作成し、`src/java` からソース ファイルを追加します。 以下のパッケージになります：


```
com.wolfssl
com.wolfssl.provider.jsse
com.wolfssl.wolfcrypt
```
コマンド ラインから java.sh を実行するか、IDE で `java.sh` を実行して、wolfSSL にリンクするネイティブ シム レイヤーを生成します。

プロジェクトにネイティブ ライブラリ参照を追加します。 それはlibにあるはずです
libwolfssl.jnilib のディレクトリ (例: wolfssljni/lib/)。
 
テストケースをコンパイルするには、ディレクトリ`src/test`からパッケージ`com.wolfssl.provider.jsse.test`と`com.wolfssl.test`を追加します。 プロジェクトには、テストを実行するための Junit も必要です。

サンプルプログラムをさらに追加することもできます。その場合は、`examples/provider/` のソース コードをプロジェクトに追加します。 オプションで、IDE は "examples/provider/ClientJSSE.sh" を実行できます。 サンプルに追加するのが難しい部分の 1 つは、デフォルトのキーストアを使用しようとする場合に、サンプルを実行するときにキーストアへのパスが IDE に認識されるようにすることです。

