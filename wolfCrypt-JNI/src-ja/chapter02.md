#  システム要件

##  Java / JDK

wolfJCE では、ホストシステムに Java をインストールする必要があります。 Oracle JDK や OpenJDK など、ユーザーや開発者が利用できる JDK バリアントがいくつかあります。 wolfJCEは現在、OpenJDK、Oracle JDK、Amazon Coretto、Zulu、Temurin、Microsoft JDK、およびAndroidでテストされています。OpenJDK と Android では、JCE プロバイダーがコード署名されている必要はありませんが、Oracle JDK では必要です。 コード署名の詳細については、[第 7 章](chapter07.md#jar-code-signing)を参照してください。


##  JUnit

単体テストを実行するには、JUnit4 が開発システムにインストールされている必要があります。 JUnit4 は、プロジェクトの Web サイト (www.junit.org) からダウンロードできます

Unix/Linux/OSX システムに JUnit4 をインストールするには:
1) [junit.org/junit4/]() から "**junit-4.13.jar**" と "**hamcrest-all-1.3.jar**" をダウンロードします。 執筆時点では、前述の .jar ファイルは次のリンクからダウンロードできます:

Junit: [junit-4.13.jar](https://search.maven.org/search?q=g:junit%20AND%20a:junit)

Hamcrest: [hamcrest-all-1.3.jar](https://search.maven.org/artifact/org.hamcrest/hamcrest-all/1.3/jar)

2) これらの JAR ファイルをシステムに配置し、その場所を指すように `JUNIT_HOME` を設定します：

```
$ export JUNIT_HOME=/path/to/jar/files
```

## make と ant

"make" と "ant" は、それぞれネイティブ C コードと Java コードのコンパイルに使用されます。
これらが開発マシンにインストールされていることを確認してください。


## wolfSSL / wolfCrypt ライブラリ

ネイティブ wolfCrypt ライブラリのラッパーとして、[wolfSSL](https://wolfssl.jp/products/wolfssl/) をインストールし、インクルードおよびライブラリ検索パスに配置する必要があります。 wolfJCE は、wolfSSL/wolfCrypt ネイティブ ライブラリの FIPS 140-2/3 または非 FIPS バージョンに対してコンパイルできます。


###  wolfSSL / wolfCrypt のコンパイル 

Unix/Linux 環境で wolfSSL をコンパイルおよびインストールするには、[wolfSSL マニュアル](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/)のビルド手順に従ってください。 wolfSSL をコンパイルする最も一般的な方法は、Autoconf システムを使用することです。

wolfSSL (wolfssl-x.x.x)、wolfSSL FIPS リリース (wolfssl-x.x.x-commercial-fips)、または wolfSSL FIPS Ready リリースをビルドし、インストールできます。いずれの場合も、 ./configure　スクリプト実行時にパッケージ固有のconfigureオプション要件（例：`--enable-fips`）に加えて、`--enable-jni` を使用する必要があります。


**wolfSSL 標準ビルド**:
```
$ cd wolfssl-x.x.x
$ ./configure --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPSv1 ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPSv2 ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v2 --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPSv5 ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v5 --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPS Ready ビルド**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=ready --enable-jni
$ make check
$ sudo make install
```

これにより、システムのデフォルトのインストールロケーションに wolfSSL ライブラリがインストールされます。 多くのプラットフォームでは、これは次の場所になっています：

```
/usr/local/lib
/usr/local/include
```
