#  システム要件

##  Java / JDK
wolfJCE では、ホストシステムに Java をインストールする必要があります。 Oracle JDK や OpenJDK など、ユーザーや開発者が利用できる JDK バリアントがいくつかあります。 wolfJCE は現在、OpenJDK、Oracle JDK、および Android でテストされています。 OpenJDK と Android では、JCE プロバイダーがコード署名されている必要はありませんが、Oracle JDK では必要です。 コード署名の詳細については、[第 7 章](chapter07.md#jar-code-signing)を参照してください。

参考までに、wolfJCE がテストされた OpenJDK の特定のバージョンは次のとおりです：


```
$ java -version
Openjdk version “1.8.0_91”
OpenJDK Runtime Environment (build 1.8.0_91-8u91-b14-3ubuntu1~15.10.1~b14)
OpenJDK 64-Bit Server VM (build 25.91-b14, mixed mode)
```
また、Oracle JDK 1.8.0_121 および Android 24 でもテストされています。

##  JUnit
単体テストを実行するには、JUnit が開発システムにインストールされている必要があります。 JUnit は、プロジェクトの Web サイト (www.junit.org) からダウンロードできます

Unix/Linux/OSX システムに JUnit をインストールするには:
1. [junit.org/junit4/]() から "**junit-4.13.jar**" と "**hamcrest-all-1.3.jar**" をダウンロードします。 執筆時点では、前述の .jar ファイルは次のリンクからダウンロードできます:

リンク: [junit-4.13.jar](https://search.maven.org/search?q=g:junit%20AND%20a:junit)<br>
リンク: [hamcrest-all-1.3.jar](https://search.maven.org/artifact/org.hamcrest/hamcrest-all/1.3/jar)

2. これらの JAR ファイルをシステムに配置し、その場所を指すように `JUNIT_HOME` を設定します：

```
    $ export JUNIT_HOME=/path/to/jar/files
```

## make と ant

"make" と "ant" は、それぞれネイティブ C コードと Java コードのコンパイルに使用されます。

これらが開発マシンにインストールされていることを確認してください。


## wolfSSL / wolfCrypt ライブラリ

ネイティブ wolfCrypt ライブラリのラッパーとして、wolfSSL をホスト プラットフォームにインストールし、インクルードおよびライブラリ検索パスに配置する必要があります。 wolfJCE は、wolfSSL/wolfCrypt ネイティブ ライブラリの FIPS または非 FIPS バージョンに対してコンパイルできます。


###  wolfSSL / wolfCrypt のコンパイル 

wolfJCE で使用するために Unix/Linux 環境で wolfSSL をコンパイルおよびインストールするには、wolfSSL マニュアルのビルド手順に従ってください。 wolfSSL をコンパイルする最も一般的な方法は、Autoconf システムを使用することです。

wolfSSL (wolfssl-x.x.x)、wolfSSL FIPS リリース (wolfssl-x.x.x-commercial-fips)、または wolfSSL FIPS Ready リリースをインストールできます。いずれの場合も、 ./configure　スクリプト実行時に`--enable-keygen` オプションが必要です。


**wolfSSL 標準ビルド**:
```
$ cd wolfssl-x.x.x
$ ./configure --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPSv1 ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPSv2 ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v2 --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPS Ready ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=ready --enable-keygen
$ make check
$ sudo make install
```

これにより、システムのデフォルトのインストールロケーションに wolfSSL ライブラリがインストールされます。 多くのプラットフォームでは、これは次の場所になっています：

```
/usr/local/lib
/usr/local/include
```
