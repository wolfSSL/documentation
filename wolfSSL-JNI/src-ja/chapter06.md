#  サポートしているアルゴリズムとクラス


wolfJSSE は、次の JSSE クラスを拡張または実装しています：

   javax.net.ssl.SSLContextSpi
       SSL, TLS, DEFAULT, TLSv1, TLSv1.1, TLSv1.2, TLSv1.3, DTLSv1.3
   javax.net.ssl.KeyManagerFactorySpi
       PKIX, X509, SunX509
   javax.net.ssl.TrustManagerFactorySpi
       PKIX, X509, SunX509
   javax.net.ssl.SSLEngine
   javax.net.ssl.SSLSession / ExtendedSSLSession
   javax.net.ssl.X509KeyManager / X509ExtendedKeyManager
   javax.net.ssl.X509TrustManager / X509ExtendedTrustManager
   javax.net.ssl.SSLServerSocket
   javax.net.ssl.SSLServerSocketFactory
   javax.net.ssl.SSLSocket
   javax.net.ssl.SSLSocketFactory
   javax.net.ssl.SSLSessionContext
   java.security.cert.X509Certificate
   javax.security.cert.X509Certificate

**注意：** DTLSv1.3は`SSLEngine`インタフェースを介した操作にのみ対応しています。
DTLS 1.0および1.2では、より低いwolfSSL JNIレベルでの操作が可能です。
ただし、現時点ではJSSE SSLContextタイプとして登録されていません。

## 安全な再ネゴシエーション

wolfSSLが以下のようにして安全な再ネゴシエーションに対応するよう構成されていれば、wolfJSSEも透過的にその機能を使用できます。

```
$ ./configure --enable-secure-renegotiation
```
あるいは、`HAVE_SECRE_RENEGOTIATION`を定義します。
