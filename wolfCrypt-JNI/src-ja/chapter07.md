#  JAR コードの署名

Oracle JDK/JVM では、Oracleが発行したコード署名証明書によってJCEプロバイダーが署名されている必要があります。 wolfcrypt-jniパッケージのantビルドスクリプトは、コンパイル前にパッケージディレクトリのルートにカスタムプロパティファイルを配置することにより、生成された`wolfcrypt-jni.jar` ファイルのコード署名をサポートします。

自動コード署名を有効にするには、`codeSigning.properties` というファイルを作成し、`wolfcrypt-jni` パッケージのルートに配置します。これは、以下を含むプロパティファイルです:

```
sign.alias=<signing alias in keystore>
sign.keystore=<path to signing keystore>
sign.storepass=<keystore password>
sign.tsaurl=<timestamp server url>
```
`ant` または `ant test` の実行時にこのファイルが存在する場合、提供されたキーストアとエイリアスを使用して `wolfcrypt-jni.jar` に署名します。

## 事前署名JARファイルの利用

wolfSSL社は、Oracle JDKでwolfJCEを認証できるようにする、Oracleからの独自のコード署名証明書のセットを持っています。 wolfJCEのリリースごとに、wolfSSLは、次の場所にある`wolfcrypt-jni.jar`の署名済みバージョンをいくつかリリースしています：

```
wolfcrypt-jni-X.X.X/lib/signed/debug/wolfcrypt-jni.jar
wolfcrypt-jni-X.X.X/lib/signed/release/wolfcrypt-jni.jar
```

この事前に署名された JAR は、Java ソース ファイルを再コンパイルすることなく、JUnit テストで使用できます。 この JAR ファイルに対して JUnit テストを実行するには:

```
$ cd wolfcrypt-jni-X.X.X
$ cp ./lib/signed/release/wolfcrypt-jni.jar ./lib
$ ant test
```
