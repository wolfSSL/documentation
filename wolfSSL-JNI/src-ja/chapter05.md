#  パッケージ構成

wolfJSSE は、wolfSSL JNI ラッパーと一緒に"**wolfssljni**"パッケージにバンドルされています。wolfJSSE は wolfSSL の基礎となる JNI バインディングに依存するため、JNI ラッパーと同じネイティブ ライブラリファイルにコンパイルされます。



wolfJSSE / wolfSSL JNI パッケージ構成は以下の通りです:

```
wolfssljni/
    build.xml  ant build script
    COPYING
    docs/      Javadocs
    examples/  Example apps
    IDE/       Example IDE project, Android Studio
    java.sh    Script to build native C JNI sources
    LICENSING
    Makefile
    lib/       Output directory for compiled library
    native/    Native C JNI binding source files
    platform/  Android AOSP build files
    README.md
    rpm/       rpm spec files
    src/
        java/  Java source files
        test/  Test source files
```
**wolfJSSE** プロバイダーのソース コードは、
`src/java/com/wolfssl/provider/jsse` ディレクトリにあり、"**com.wolfssl.provider.jsse**" Java パッケージの一部です。

**wolfSSL JNI** ラッパーは `src/java/com/wolfssl` ディレクトリにあり、"**com.wolfssl**" Java パッケージの一部です。 このパッケージは wolfJSSE クラスによって利用されるため、JSSE のユーザーはこのパッケージを直接使用する必要はありません。

wolfSSL JNI と wolfJSSE がコンパイルされると、2 つの JAR ファイルと 1 つのネイティブ共有ライブラリが`./lib` ディレクトリに生成されます。


```
lib/
    libwolfSSL.so     (Native C JNI wrapper shared library)
    wolfssl.jar       (JAR with ONLY wolfSSL JNI Java classes)
    wolfssl-jsse.jar  (JAR with BOTH wolfSSL JNI and wolfJSSE classes)
```
