#  使用方法

使用方法については、前の章で指定されたクラスの Oracle/OpenJDK Javadoc に従ってください。"wolfJSSE" プロバイダーが、`java.security` ファイルで同じアルゴリズムを提供している他のプロバイダーよりも優先順位が低く設定されている場合は、明示的に"wolfJSSE" プロバイダーを使用することを要求する必要あります。

たとえば、TLS 1.2 の SSLContext クラスで wolfJSSE プロバイダーを使用するには
アプリケーションは次のように SSLContext オブジェクトを作成します：


```
SSLContext ctx = SSLContext.getInstance("TLSv1.2", "wolfJSSE");
```

## セキュリティプロパティ

wolfJSSEは`java.security`ファイルによるJava標準/wolfJSSE固有のプロパティ構成に対応しています。

### Java標準のセキュリティプロパティ

wolfJSSEは以下のプロパティに対応しています。

| プロパティ | デフォルト値 | 説明 |
| --- | --- | --- |
| `keystore.type` | JKS | 標準のキーストアタイプ |
| `jdk.tls.disabledAlgorithms` | | アルゴリズム、プロトコル、鍵長の無効化 (一部のみ対応) |

`jdk.tls.disabledAlgorithms`は以下のように使用できます。

```
jdk.tls.disabledAlgorithms=SSLv3, TLSv1.1, DH keySize < 1024, EC keySize < 224, RSA keySize < 1024
```

### wolfJSSE固有のセキュリティプロパティ

wolfJSSEは以下のプロパティに対応しています。

| プロパティ | デフォルト値 | 説明 |
| --- | --- | --- |
| `wolfjsse.enabledCipherSuites` | | 使用できる暗号スイートを制限 |
| `wolfjsse.enabledSupportedCurves` | | 使用できるECC曲線を制限 |
| `wolfjsse.enabledSignatureAlgorithms` | | 使用できる署名アルゴリズムを制限 |
| `wolfjsse.keystore.type.required` | | 特定の鍵ストアタイプを要求 |
| `wolfjsse.clientSessionCache.disabled` | "false" | クライアントセッションキャッシュを無効化 |
| `wolfjsse.X509KeyManager.disableCache` | "false" | X509KeyManagerのキャッシュを無効化 |
| `wolfssl.readWriteByteBufferPool.disabled` | "false" | ByteBufferプールへの直接の読み書きを無効化 |
| `wolfssl.readWriteByteBufferPool.size` | | スレッドごとのプールにおけるByteBuffersの最大値を設定 |
| `wolfssl.readWriteByteBufferPool.bufferSize` | | プール内のそれぞれのByteBuffersのサイズを設定 |

使用可能な暗号スイートを制限する例：

```
wolfjsse.enabledCipherSuites=TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

使用可能なECC曲線を制限する例：

```
wolfjsse.enabledSupportedCurves=secp256r1, secp521r1
```

使用可能な署名アルゴリズムを制限する例：

```
wolfjsse.enabledSignatureAlgorithms=RSA+SHA256:ECDSA+SHA256
```

## システムプロパティ

wolfJSSEはJava標準/wolfJSSE固有のシステムプロパティ構成に対応しています。

### Java標準のシステムプロパティ

wolfJSSEは以下のプロパティに対応しています。

| プロパティ | 説明 |
| --- | --- |
| `javax.net.ssl.keyStore` | KeyStoreファイル (for KeyManager) |
| `javax.net.ssl.keyStoreType` | KeyStoreタイプ (for KeyManager) |
| `javax.net.ssl.keyStorePassword` | KeyStoreパスワード (for KeyManager) |
| `javax.net.ssl.trustStore` | KeyStoreファイル (for TrustManager) |
| `javax.net.ssl.trustStoreType` | KeyStoreタイプ (for TrustManager) |
| `javax.net.ssl.trustStorePassword` | KeyStoreパスワード (for TrustManager) |
| `jdk.tls.client.SignatureSchemes` | クライアント署名アルゴリズム(一部のみ対応) |
| `jdk.tls.client.enableSessionTicketExtension` | クライアントセッションチケットの有効化 (Java 13以降) |
| `jdk.tls.server.enableSessionTicketExtension` | サーバセッションチケットの有効化 (Java 13以降、現時点ではクライアントサイドのみ対応) |
| `jdk.tls.server.SignatureSchemes` | サーバ署名アルゴリズム(一部のみ対応) |
| `jdk.tls.useExtendedMasterSecret` | Extended Master Secretの有効/無効 |
| `jdk.tls.ephemeralDHKeySize` | ephemeral DH鍵サイズを制御 |
| `jdk.tls.trustNameService` | ホスト名検証のためのreverse DNS lookupを有効化 |
| `jsse.enableSNIExtension` | SNI拡張の有効/無効 (デフォルト値：true) |

### wolfJSSE固有のシステムプロパティ

wolfJSSEは以下のプロパティに対応しています。

| プロパティ | デフォルト値 | 設定可能値 | 説明 |
| --- | --- | --- | --- |
| `wolfssl.debug` | "false" | "true" | wolfSSLのネイティブデバッグログ |
| `wolfssljni.debug` | "false" | "true" | wolfJNIのデバッグログ |
| `wolfjsse.debug` | "false" | "true" | wolfJSSEのデバッグログ |
| `wolfjsse.debugFormat` | | "JSON" | デバッグログをJSONフォーマットで出力 |
| `wolfsslengine.debug` | "false" | "true" | SSLEngineのデバッグログ |
| `wolfsslengine.io.debug` | "false" | "true" | SSLEngineのI/Oバイトログ |
| `wolfjsse.autoSNI` | "false" | "true" | ホスト名によるSNI自動設定 |

## デバッグ

ネイティブwolfSSLデバッグログ(`wolfssl.debug`)は、wolfSSLが`--enable-debug`を有効にしてコンパイルされているときのみ有効です。

前節でご紹介したプロパティは、実行時に以下のように

```sh
java -Dwolfjsse.debug=true App
```

あるいはプログラム内で以下のように

```java
System.setProperty("wolfjsse.debug", "true");
```

記載することで設定できます。

もし`WolfSSLDebug`が初期化される前にプロパティを変更したときは、`WolfSSLDebug.refreshDebugFlags()`を実行することで値を更新できます。

また、JDKデバッグログは`-Djavax.net.debug=all`により有効化できます。

### JSONログフォーマット

DataDogのようなツールで使用しやすくするために、ログメッセージはJSONフォーマットでも出力できます。
以下のように設定します。

```
java -Dwolfjsse.debug=true -Dwolfjsse.debugFormat=JSON App
```

## ネイティブファイルディスクリプタイベント

wolfJSSEは`poll()`や`select()`を使用してネイティブファイルディスクリプタへのread/writeを監視します。

デフォルトの状態では`poll()`が使用されます。
ただし、以下の場合には`select()`が使用されます。

- ネイティブJNIソースをコンパイルする際、`WOLFJNI_USE_IO_SELECT`を定義したとき。
- Windows環境では、`select()`がデフォルトとして使用されます。

特段の事情が無ければ、`poll()`関数を選択することを推奨します。
`select()`では、ファイルディスクリプタ番号が`FD_SETSIZE`(一般的には1024)に達したときの動作が定義されていません。

## ALPNサポート

Application-Layer Protocol Negotiation (ALPN)は`SSLSocket`および`SSLEngine`の両方によってサポートしています。

ネゴシエートされたプロトコルを参照するには、ハンドシェイクの後に以下を実行します。

```java
String protocol = sslSocket.getApplicationProtocol();
```

wolfJSSEはALPNに非ASCII文字が使用されている場合にも対応します。

## SNIサポート

Server Name Indication (SNI) はクライアントサイド・サーバサイドの両方で対応しています。

クライアントサイドでは、`SSLParameters`を使用してSNIを設定できます。

```java
SSLParameters params = sslSocket.getSSLParameters();
params.setServerNames(Arrays.asList(new SNIHostName("example.com")));
sslSocket.setSSLParameters(params);
```

システムプロパティ`wolfjsse.autoSNI`によって、ホスト名に基づくSNIの自動設定を有効化できます。`HttpsURLConnection`に適用されます。

サーバサイドでは、`SSLSession.getRequestedServerNames()`を実行することでクライアントがSNIを求めているか確認できます。
このとき、`WolfSSLSocket`によるSNI一致ロジックが実行されます。

## DTLS 1.3の使い方

DTLS 1.3は`SSLEngine`インタフェースを介してのみ使用できます。

```java
SSLContext ctx = SSLContext.getInstance("DTLSv1.3", "wolfJSSE");
SSLEngine engine = ctx.createSSLEngine();
```

DTLSコネクションID (CID) についての処理は、JNIレベルでラップされたwolfSSLのネイティブAPIからも実行できます。

## Androidでの使い方

### アプリケーションレベル

以下のようにして、wolfJSSEをアプリケーション内で登録します。

```java
import com.wolfssl.provider.jsse.WolfSSLProvider;

// Add as lowest priority
Security.addProvider(new WolfSSLProvider());

// Or insert as highest priority
Security.insertProviderAt(new WolfSSLProvider(), 1);
```

Android環境では、キーストア`AndroidCAStore`を使用してシステムの証明書を読み込むことができます。

### システムレベル (AOSP)

wolfJSSEはシステムプロバイダーとしてもインストールできます。
詳細はディレクトリ`platform/android_aosp`と、ドキュメント"Installing a JSSE Provider in Android OSP"をご参照ください。
