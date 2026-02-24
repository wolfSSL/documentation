#  コンパイル

このセクションの手順を実行する前に、上記の [第 2 章](chapter02.md#requirements) の依存モジュールがインストールされていることを確認してください。

最初に、Linux または OSX のどちらを使用しているかに応じて、システムに適切な "makefile" をコピーします。

Linux を使用している場合:

```
$ cd wolfcrypt-jni
$ cp makefile.linux makefile
```

Mac OSXにインストールする場合:

```
$ cd wolfcrypt-jni
$ cp makefile.macosx makefile
```

次に、 "make" を使用してネイティブ (C ソース) コードをコンパイルします。
これにより、ネイティブJNI共有ライブラリ（`libwolfcryptjni.so/dylib`）が生成されます：

```
$ cd wolfcrypt-jni
$ make
```

Java ソースのコンパイルには "ant" を使用します。 JNI または JCE (JNI を含む) パッケージをデバッグ モードまたはリリース モードでコンパイルするための ant ターゲットがいくつかあります。 ターゲットを指定せずに "ant" を実行すると、使用オプションが表示されます：


```
$ ant
...
build:
[echo] wolfCrypt JNI and JCE
[echo] ----------------------------------------------------------------------------
[echo] USAGE:
[echo] Run one of the following targets with ant:
[echo] build-jni-debug | builds debug JAR with only wolfCrypt JNI classes
[echo] build-jni-release | builds release JAR with only wolfCrypt JNI classes
[echo] build-jce-debug | builds debug JAR with JNI and JCE classes
[echo] build-jce-release | builds release JAR with JNI and JCE classes
[echo] ----------------------------------------------------------------------------
```

必要に応じてビルドターゲットを指定してください。 たとえば、リリース モードで wolfJCE プロバイダーをビルドする場合は、次を実行します：

```
$ ant build-jce-release
```

JUnitテストを実行するには、`ant test` を実行してください。これにより、実行されたビルド（JNIとJCE）に一致するテストのみがコンパイル、実行されます。

```
$ ant test
```

Java JAR とネイティブ ライブラリの両方を消去するには、次のようにします:

```
$ ant clean
$ make clean
```

## Mavenによるコンパイル

wolfCrypt JNI/JCEはMavenによるビルドにも対応しています。
まずは前セクションに示したように`make`を使用してJNI共有ライブラリをコンパイルします。

次に、Mavenを用いてJavaソースをコンパイルします。

```
$ mvn compile
```

JUnitテストをコンパイル、実行するには次のようにします。

```
$ mvn test
```

JARファイルにパッケージングするには、次のようにします。

```
$ mvn package
```

JARファイルをローカルのMavenリポジトリにインストールするには、次のようにします。

```
$ mvn install
```

インストール後は、ユーザのMavenプロジェクトにおいて次のようにして使用できるようになります。

```xml
<dependency>
    <groupId>com.wolfssl</groupId>
    <artifactId>wolfcrypt-jni</artifactId>
    <version>1.9.0-SNAPSHOT</version>
</dependency>
```

## APIマニュアル（Javadoc）

`ant` を実行すると、`wolfcrypt-jni/docs/javadoc` ディレクトリの下に一連の Javadoc が生成されます。 Javadocインデックスを表示するには、Web ブラウザで次のファイルを開きます：

`wolfcrypt-jni/docs/javadoc/index.html`

Mavenを使用している場合、Javadocは次のようにして生成できます。

```
$ mvn javadoc:javadoc
```

成果物は`./docs/apidocs`リポジトリに保存されます。
