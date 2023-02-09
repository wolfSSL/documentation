#  パッケージ構成

wolfJCE は、"wolfcrypt-jni" JNI ラッパー ライブラリにバンドルされています。 wolfJCE は wolfCrypt の基礎となる JNI バインディングに依存するため、wolfcrypt-jni と同じネイティブ ライブラリ ファイルと JAR ファイルにコンパイルされます。

JNI ラッパーのみを使用したいユーザーの場合、JCE プロバイダー クラスを含まないバージョンの "wolfcrypt-jni.jar" をコンパイルすることができます。

wolfJCE / wolfCrypt JNI パッケージ構造:


```
wolfcrypt-jni /
AUTHORS
build.xml                          ant ビルドスクリプト
COPYING
docs /                             Javadoc
jni /                              ネイティブC JNI バインディングソースファイル
lib /                              コンパイル成果物（ライブラリ）の出力先
LICENSING
Makefile generic                   Makefile
Makefile.linux                     Linux用　Makefile
Makefile.osx                       OSX用 Makefile
README_JCE.md
README.md
src /
    main/java/                     Java ソースファイル
    test/java/                     テストソースファイル
```

wolfJCE プロバイダーのソース コードは "src/main/java/com/wolfssl/provider/jce" ディレクトリにあり、"**com.wolfssl.provider.jce**" Java パッケージの一部です。
 
wolfCrypt JNI ラッパーは "src/main/java/com/wolfssl/wolfcrypt" ディレクトリにあり、"**com.wolfssl.wolfcrypt**" Java パッケージの一部です。 このパッケージは wolfJCE クラスによって使用されるため、JCE のユーザーはこのパッケージを直接使用する必要はありません。

wolfCrypt-JNI と wolfJCE がコンパイルされると、出力 JAR とネイティブ共有ライブラリが "./lib" ディレクトリに配置されます。 これらには、JCE ビルドがコンパイルされると、wolfCrypt JNI ラッパーと wolfJCE プロバイダーの両方が含まれることに注意してください。


```
lib/
    libwolfcryptjni.so
    wolfcrypt-jni.jar
```
