#  パッケージ構成

wolfJCE は、"wolfcrypt-jni" JNI ラッパー ライブラリにバンドルされています。 wolfJCE は wolfCrypt の基礎となる JNI バインディングに依存するため、wolfcrypt-jni と同じネイティブ ライブラリ ファイルと JAR ファイルにコンパイルされます。

JNI ラッパーのみを使用したいユーザーの場合、JCE プロバイダー クラスを含まないバージョンの "wolfcrypt-jni.jar" をコンパイルすることができます。

**wolfJCE / wolfCrypt JNI パッケージ構造:**


```
wolfcrypt-jni /
   .github                        GitHub Actionsワークフロー
   AUTHORS
   COPYING
   ChangeLog.md                   更新履歴
   IDE/                           IDEプロジェクトファイル
       WIN/                       Visual Studioプロジェクトファイル
   LICENSING
   README.md                      メインREADME
   README_JCE.md                  wolfJCE README
   build.xml                      antビルドスクリプト
   docs /                         Javadocs
   examples/                      サンプルアプリケーションと証明書/鍵
       certs/                     サンプル証明書/鍵/KeyStores
       provider/                  JCEサンプルアプリ
   jni/                           ネイティブC JNIバインディングソースファイル
   lib/                           コンパイル成果物（ライブラリ）の出力先
   makefile.linux                 Linux用のMakefile
   makefile.osx                   OSX用のMakefile
   pom.xml                        Mavenビルドファイル
   rpm/                           Linux rpmファイル
   scripts/                       テストスクリプト（Facebook Infer等）
   src/                           ソースコード
       main/java                  Javaソースファイル
```

wolfJCEプロバイダーのソースコードは `src/main/java/com/wolfssl/provider/jce` ディレクトリにあり、「**com.wolfssl.provider.jce**」Javaパッケージの一部です。

wolfCrypt JNIラッパーは `src/main/java/com/wolfssl/wolfcrypt` ディレクトリにあり、「**com.wolfssl.wolfcrypt**」Javaパッケージの一部です。このパッケージはwolfJCEクラスによって使用されるため、JCEのユーザーはこのパッケージを直接使用する必要はありません。

wolfCrypt JNIとwolfJCEがコンパイルされると、出力JARとネイティブ共有ライブラリは `./lib` ディレクトリに配置されます。JCEビルドがコンパイルされる際、これらにはwolfCrypt JNIラッパーとwolfJCEプロバイダーの両方が含まれることにご注意ください。

```
lib/
    libwolfcryptjni.so (libwolfcryptjni.dylib)
    wolfcrypt-jni.jar
```
