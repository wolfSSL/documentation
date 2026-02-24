#  パッケージ構成

wolfJSSE は、wolfSSL JNI ラッパーと一緒に"**wolfssljni**"パッケージにバンドルされています。wolfJSSE は wolfSSL の基礎となる JNI バインディングに依存するため、JNI ラッパーと同じネイティブ ライブラリファイルにコンパイルされます。



wolfJSSE / wolfSSL JNI パッケージ構成は以下の通りです:

```
wolfssljni/
    build.xml       antビルドスクリプト
    pom.xml         Mavenビルド構成
    COPYING
    docs/           Javadocs
    examples/       アプリケーションの実装例
    IDE/            IDEプロジェクト
        Android/    Android Studio
        WIN/        Windows Visual Studio
    java.sh         ネイティブC JNIソースをビルドするスクリプト
    LICENSING
    Makefile
    lib/            コンパイルされたライブラリの出力先
    native/         ネイティブC JNIバインディングソースファイル
    platform/       Android AOSPビルドファイル
    README.md
    rpm/            rpmスペックファイル
    src/
        java/       Javaソースファイル
        test/       テストソースファイル
```

**wolfJSSE** プロバイダーのソース コードは、
`src/java/com/wolfssl/provider/jsse` ディレクトリにあり、"**com.wolfssl.provider.jsse**" Java パッケージの一部です。

**wolfSSL JNI** ラッパーは `src/java/com/wolfssl` ディレクトリにあり、"**com.wolfssl**" Java パッケージの一部です。 このパッケージは wolfJSSE クラスによって利用されるため、JSSE のユーザーはこのパッケージを直接使用する必要はありません。

wolfSSL JNI と wolfJSSE がコンパイルされると、2 つの JAR ファイルと 1 つのネイティブ共有ライブラリが`./lib` ディレクトリに生成されます。オペレーティングシステムに応じて異なりますが、ネイティブ共有ライブラリには`libwolfssljni.dylib`と名前をつけることもできます。


```
lib/
    libwolfssljni.so  (Native C JNI wrapper shared library)
    wolfssl.jar       (JAR with ONLY wolfSSL JNI Java classes)
    wolfssl-jsse.jar  (JAR with BOTH wolfSSL JNI and wolfJSSE classes)
```
