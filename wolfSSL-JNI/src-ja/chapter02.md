#  システム要件

##  Java / JDK

wolfJSSE では、ホスト システムに Java をインストールする必要があります。 ユーザーと開発者が利用できる JDK バリアントがいくつかあります。 wolfSSL JNI/JSSE では以下についてテスト済みです：

- Unix/Linux:
    + Oracle JDK
    + OpenJDK
    + Zulu JDK
    + Amazon Coretto
- Mac OSX
- Windows (Visual Studio)
- Android Studio
- Android AOSP

##  JUnit

ユニットテストを実行するには、開発システムに JUnit4 がインストールされている必要があります。JUnit4 は、プロジェクトの Web サイト[www.junit.org](http://www.junit.org)
からダウンロードできます。

Unix/Linux/OSX システムに JUnit4 をインストールするには:

1) [junit.org/junit4/]() から "**junit-4.13.2.jar**" と " **hamcrest-all-1.3.jar**" をダウンロードします。 執筆時点では、上記の .jar ファイルは次のリンクからダウンロードできます。

    [junit-4.13.2.jar](https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar) <br/>
    [hamcrest-all-1.3.jar](https://repo1.maven.org/maven2/org/hamcrest/hamcrest-all/1.3/hamcrest-all-1.3.jar)



2) ダウンロードしたJarファイルをシステムに配置したらそのパスを **JUNIT_HOME** にセットします。例えば：


```
$ export JUNIT_HOME=/path/to/jar/files
```

##  システム要件 (gcc、ant)

**gcc** と **ant** は、それぞれネイティブCコードとJavaコードのコンパイルに使用されます。これらが開発マシンにインストールされていることを確認してください。**ant** の代わりに **maven** でコンパイルすることもできます。


##  wolfSSL SSL/TLS ライブラリ

wolfSSL JNI/JSSEのコンパイルに先立ち、ネイティブ wolfSSL ライブラリのラッパーとして、[wolfSSL](https://wolfssl.jp/products/wolfssl/) C ライブラリをホスト プラットフォームにインストールし、インクルードおよびライブラリ検索パスに配置する必要があります。


###  wolfSSL と wolfCrypt C ライブラリのコンパイル

wolfJSSE で使用するために Unix/Linux 環境で wolfSSL をコンパイルしてインストールするには、[wolfSSL マニュアル](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/)のビルド手順に従ってください。 wolfSSL をコンパイルする最も一般的な方法は、Autoconf を使用することです。

Autoconf を使用して wolfSSL を設定する場合、`--enable-jni` オプションを使用する必要があります:


```
$ cd wolfssl-X.X.X
$ ./configure --enable-jni
$ make
```
"make check" が正常にパスすることを確認してから、ライブラリをインストールします:


```
$ make check
$ sudo make install
```
これにより、システムのデフォルトのインストールフォルダに wolfSSL ライブラリがインストールされます。 多くのプラットフォームでは、次のフォルダです:


```
/usr/local/lib
/usr/local/include
```
wolfSSL が非標準のライブラリ インストールフォルダにインストールされている場合、`LD_LIBRARY_PATH` (Unix/Linux) または `DYLD_LIBRARY_PATH` (OSX) を更新する必要がある場合があります：


```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/wolfssl/install
```
