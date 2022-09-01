

# 入門




## 概要



以前のCyasslであったwolfSSLは、[第2章](chapter02.md#building-wolfssl)で説明されているコンパイルオプションを使用する場合、Yasslの約10倍小さく、OpenSSLの20倍小さくなります。オペレーション。


ビルドプロセスの指示については、[第2章](chapter02.md#building-wolfssl)を参照してください。



## TestSuite



TestSuiteプログラムは、wolfSSLとその暗号化ライブラリであるwolfCryptがシステムで実行する能力をテストするように設計されています。


wolfSSLのすべてのサンプルプログラムとテストを実行する際には、wolfSSLホームディレクトリから実行することが必要です。これは、./certsから証明書と鍵を見つけるために必要です。TestSuiteを実行するには次のように実行してください:



```sh
./testsuite/testsuite.test
```



またはautoconfを使用する場合：



```sh
make test
```



\*nixまたはWindowsでは、例とTestSuiteが現在のディレクトリがソースディレクトリであるかどうかを確認し、もしそうなら、wolfSSL Home Directoryに変更しようとします。これは、ほとんどのセットアップケースで動作するはずです。そうでない場合は、上記の最初の方法を使用して、フルパスを指定するだけです。


テストに成功した場合、このような出力が表示されるはずです。ユニットテストと暗号スイートテストのための追加の出力があります。



```text
------------------------------------------------------------------------------
 wolfSSL version 4.8.1
------------------------------------------------------------------------------
error    test passed!
MEMORY   test passed!
base64   test passed!
base16   test passed!
asn      test passed!
RANDOM   test passed!
MD5      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-3    test passed!
Hash     test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
HMAC-SHA3   test passed!
HMAC-KDF    test passed!
GMAC     test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES      test passed!
AES192   test passed!
AES256   test passed!
AES-GCM  test passed!
RSA      test passed!
DH       test passed!
PWDBASED test passed!
OPENSSL  test passed!
OPENSSL (EVP MD) passed!
OPENSSL (PKEY0) passed!
OPENSSL (PKEY1) passed!
OPENSSL (EVP Sign/Verify) passed!
ECC      test passed!
logging  test passed!
mutex    test passed!
memcb    test passed!
Test complete
Alternate cert chain used
 issuer:/C=US/ST=Montana/L=Bozeman/O=Sawtooth/OU=Consulting/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 subject: /C=US/ST=Montana/L=Bozeman/O=wolfSSL/OU=Support/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 altname=example.com
Alternate cert chain used
 issuer:/C=US/ST=Montana/L=Bozeman/O=wolfSSL_2048/OU=Programming-2048/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 subject: /C=US/ST=Montana/L=Bozeman/O=wolfSSL_2048/OU=Programming-2048/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 altname=example.com
 serial number:01
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL signature algorithm is RSA-SHA256
SSL curve name is SECP256R1
Session timeout set to 500 seconds
Client Random: serial number:f1:5c:99:43:66:3d:96:04
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL signature algorithm is RSA-SHA256
SSL curve name is SECP256R1
1DC16A2C0D3AC49FC221DD5B8346B7B38CB9899B7A402341482183Server Random:1679E50DBBBB3DB88C90F600C4C578F4F5D3CEAEC9B16BCCA215C276B448
765A1385611D6A
Client message: hello wolfssl!
I hear you fa shizzle!
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers=TLS13-AES128-GCM-SHA256:TLS13-AES256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /tmp/output-gNQWZL

All tests passed!
```



これは、すべてが設定され正しくビルドされていることを示しています。いずれかのテストが失敗した場合は、ビルドシステムが正しく設定されていることを確認してください。おそらく、誤ったエンディアンを持つこと、または64ビットタイプを正しく設定しないことが含まれます。デフォルト以外の設定に設定した場合は、それらを削除して、wolfSSLを再ビルドしてから再テストしてください。



## Clientサンプルプログラム



examples/clientフォルダにあるクライアントのサンプルプログラムを使用して、任意のSSLサーバーに対してwolfSSLをテストできます。利用可能なコマンドラインランタイムオプションのリストを表示するには、`--help`引数でクライアントを実行します：



```sh
./examples/client/client --help
```



出力表示：



```text
wolfSSL client 4.8.1 NOTE: All files relative to wolfSSL home dir
Max RSA key size in bits for build is set at:4096
-? <num>    Help, print this usage
            0: English, 1: Japanese
--help      Help, in English
-h <host>   Host to connect to, default 127.0.0.1
-p <num>    Port to connect on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-V          Prints valid ssl version numbers, SSLv3(0) - TLS1.3(4)
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/client-cert.pem
-k <file>   Key file,                   default ./certs/client-key.pem
-A <file>   Certificate Authority file, default ./certs/ca-cert.pem
-Z <num>    Minimum DH key bits,        default 1024
-b <num>    Benchmark <num> connections and print stats
-B <num>    Benchmark throughput using <num> bytes and print stats
-d          Disable peer checks
-D          Override Date Errors example
-e          List Every cipher suite available,
-g          Send server HTTP GET
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-m          Match domain name in cert
-N          Use Non-blocking sockets
-r          Resume session
-w          Wait for bidirectional shutdown
-M <prot>   Use STARTTLS, using <prot> protocol (smtp)
-f          Fewer packet/group messages
-x          Disable client cert/key loading
-X          Driven by eXternal test case
-j          Use verify callback override
-n          Disable Extended Master Secret
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-J          Use HelloRetryRequest to choose group for KE
-K          Key Exchange for PSK not using (EC)DHE
-I          Update keys and IVs before sending data
-y          Key Share with FFDHE named groups only
-Y          Key Share with ECC named groups only
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-2          Disable DH Prime check
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```



example.com:443に対してテストするには、次のことを試してください。これは、`--enable-opensslextra`および`--enable-supportedcurves`ビルドオプションでコンパイルされたwolfSSLを使用しています。



```sh
./examples/client/client -h example.com -p 443 -d -g
```



出力表示：



```text
Alternate cert chain used
 issuer:/C=US/O=DigiCert Inc/CN=DigiCert TLS RSA SHA256 2020 CA1
 subject: /C=US/ST=California/L=Los Angeles/O=Internet Corporation for Assigned Names and Numbers/CN=www.example.org
 altname=www.example.net
 altname=www.example.edu
 altname=www.example.com
 altname=example.org
 altname=example.net
 altname=example.edu
 altname=example.com
 altname=www.example.org
 serial number:0f:be:08:b0:85:4d:05:73:8a:b0:cc:e1:c9:af:ee:c9
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
SSL curve name is SECP256R1
Session timeout set to 500 seconds
Client Random:20640B8131D8E542646D395B362354F9308057B1624C2442C0B5FCDD064BFE29
SSL connect ok, sending GET...
HTTP/1.0 200 OK
Accept-Ranges: bytes
Content-Type: text/html
Date: Thu, 14 Oct 2021 16:50:28 GMT
Last-Modified: Thu, 14 Oct 2021 16:45:10 GMT
Server: ECS (nyb/1D10)
Content-Length: 94
Connection: close
```



これにより、クライアントは443のHTTPSポート(`-p`)の(`-h`)Example.comに接続し、Generic(`-g`)GETリクエストを送信するように指示します。(`-d`)オプションは、クライアントにサーバー証明書の認証をしないように指示します。残りは、読み取りバッファーに収まるサーバーからの初期出力です。


コマンドライン引数が指定されていない場合、クライアントは11111のwolfSSLデフォルトポートのLOCALHOSTへの接続を試みます。サーバーがクライアント認証を実行したい場合には、クライアント証明書もロードします。


クライアントは、`-b <num>`引数を使用するときに接続をベンチマークすることができます。使用されると、クライアントは引数回数を指定したサーバー/ポートへの接続を試み、その平均時間をミリ秒単位で`SSL_connect()`で実行します。例：



```sh
/examples/client/client -b 100 -h example.com -p 443 -d
```



出力表示：



```text
wolfSSL_connect avg took:  296.417 milliseconds
```



LocalHostからデフォルトのホスト、または11111からデフォルトポートを変更する場合は、これらの設定を`/wolfssl/test.h`で変更できます。これらの設定を変更する際のテストスイートを含むすべての例を再ビルドします。そうしないと、テストプログラムが互いに接続できません。


デフォルトでは、wolfSSLの例クライアントは、TLS 1.2を使用して指定されたサーバーに接続しようとします。ユーザーは、`-v`コマンドラインオプションを使用してクライアントが使用するSSL/TLSバージョンを変更できます。このオプションでは、次の値が利用できます。



* `-v 0`  -  SSL 3.0(デフォルトでは無効)


* `-v 1`  -  TLS 1.0


* `-v 2` -TLS 1.1


* `-v 3` -TLS 1.2(デフォルトで選択)


* `-v 4` -TLS 1.3



一般的なエラーユーザーは、クライアントのサンプルを使用するときに-188です。



```text
wolfSSL_connect error -188, ASN no signer error to confirm failure
wolfSSL error: wolfSSL_connect failed
```



これは通常、wolfSSLクライアントが接続しているサーバーの証明書を確認できないことによって引き起こされます。デフォルトでは、wolfSSLクライアントは、Yassl Test CA証明書を信頼できるルート証明書としてロードします。このテストCA証明書は、別のCAによって署名された外部サーバー証明書を確認することができません。そのため、この問題を解決するには、ユーザーは`-d`オプションを使用して、ピア(サーバー)の検証をオフにする必要があります。



```sh
./examples/client/client -h myhost.com -p 443 -d
```



または、`-A`コマンドラインオプションを使用して、正しいCA証明書をwolfSSLクライアントにロードします。



```sh
./examples/client/client -h myhost.com -p 443 -A serverCA.pem
```




## Serverサンプルプログラム



サーバーの例は、クライアント認証をオプションで実行する単純なSSLサーバーを示しています。1つのクライアント接続のみが受け入れられ、サーバーが終了します。通常モードのクライアントの例(コマンドライン引数なし)は、サンプルサーバーに対して正常に動作しますが、クライアントの例にコマンドライン引数を指定すると、クライアント証明書が読み込まれず、[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)が失敗します(クライアント証明書がない限り`-d`オプションを使用してチェックが無効になります)。サーバーはエラー「-245、PeerはCERTを送信しませんでした」を報告します。例のクライアントと同様に、サーバーはいくつかで使用できます
コマンドラインの引数も同様です。



```sh
./examples/server/server --help
```



出力表示：



```text
server 4.8.1 NOTE: All files relative to wolfSSL home dir
-? <num>    Help, print this usage
            0: English, 1: Japanese
--help      Help, in English
-p <num>    Port to listen on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/server-cert.pem
-k <file>   Key file,                   default ./certs/server-key.pem
-A <file>   Certificate Authority file, default ./certs/client-cert.pem
-R <file>   Create Ready file for external monitor default none
-D <file>   Diffie-Hellman Params file, default ./certs/dh2048.pem
-Z <num>    Minimum DH key bits,        default 1024
-d          Disable client cert check
-b          Bind to any interface instead of localhost only
-s          Use pre Shared keys
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-f          Fewer packet/group messages
-r          Allow one client Resumption
-N          Use Non-blocking sockets
-S <str>    Use Host Name Indication
-w          Wait for bidirectional shutdown
-x          Print server errors but do not close connection
-i          Loop indefinitely (allow repeated connections)
-e          Echo data mode (return raw bytes received)
-B <num>    Benchmark throughput using <num> bytes and print stats
-g          Return basic HTML web page
-C <num>    The number of connections to accept, default: 1
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-U          Update keys and IVs before sending
-K          Key Exchange for PSK not using (EC)DHE
-y          Pre-generate Key Share using FFDHE_2048 only
-Y          Pre-generate Key Share using P-256 only
-F          Send alert if no mutual authentication
-2          Disable DH Prime check
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```




## EchoServerサンプルプログラム



エコーサーバのサンプルプログラムは、無制限の数のクライアント接続を待っている無限ループに収まります。クライアントがEchoServer Echoesを返送します。クライアント認証は実行されませんので、サンプルクライアントをすべてのモードでエコーサーバーに対して使用できます。4つの特別なコマンドは反響しないで、エコーサーバーに別の行動をとるように指示します。



1. `quit`  - エコーサーバーが文字列 "Quit"を受信した場合は、シャットダウンします。


2. `break`エコーサーバーが文字列 "break"を受信した場合、現在のセッションは停止しますが、要求を処理し続けます。これはDTLSテストに特に便利です。


3.  - エコーサーバーが文字列 "PrintStats"を受信した場合は、セッションキャッシュの統計を印刷します。


4. `GET` -ECHOSERVERが文字列を「取得」すると、HTTPを取得して処理し、「wolfSSLからのグリーティング」というメッセージで簡単なページを送り返します。これにより、Safari、IE、Firefox、GnutlsなどのさまざまなTLS/SSLクライアントのテストが可能になります。



`NO_MAIN_DRIVER`が定義されていない限り、エコーサーバーの出力はSTDOUTにエコーされます。シェルを介して、または最初のコマンドライン引数を介して出力をリダイレクトできます。EchoServer Runからの出力を指定してoutput.txtという名前のファイルを作成するには：



```sh
./examples/echoserver/echoserver output.txt
```




## EchoClientサンプルプログラム



EchoClientの例は、Interactive ModeまたはBatch Modeで実行できます。インタラクティブモードで実行して3つの文字列 "HELLO"、 "WOLFSSL"、および "QUIT"の結果を書き込んでください。



```text
./examples/echoclient/echoclient
hello
hello
wolfssl
wolfssl
quit
sending server shutdown command: quit!
```



入力ファイルを使用するには、最初の引数としてコマンドラインのファイル名を指定します。ファイルの内容をエコーするには`input.txt`問題：



```sh
./examples/echoclient/echoclient input.txt
```



結果をファイルに書き出す場合は、追加のコマンドライン引数として出力ファイル名を指定できます。次のコマンドはファイル`input.txt`の内容をエコーし、その結果をサーバーから`output.txt`に書きます。



```sh
./examples/echoclient/echoclient input.txt output.txt
```



TestSuiteプログラムはそれを行いますが、クライアントとサーバーが正しい結果と期待された結果を取得/送信していることを確認するために、入力ファイルと出力ファイルをハッシュします。



## Benchmark



多くのユーザーは、組み込み機器向けwolfSSLLライブラリが特定のハードウェアデバイスまたは特定の環境でどのように機能するかに興味があります。現在、組み込み、企業、クラウドベースの環境で使用されているさまざまなプラットフォームとコンパイラがあるため、全面的に一般的なパフォーマンス計算を提供することは困難です。


wolfSSL/WolfCryptのSSLパフォーマンスを決定する際のwolfSSLユーザーと顧客を支援するために、wolfSSLにバンドルされているベンチマークアプリケーションが提供されています。wolfSSLは、デフォルトですべての暗号操作に対してwolfCrypt暗号化ライブラリを使用します。基礎となる暗号はSSL/TLSの非常にパフォーマンスが重要な側面であるため、ベンチマークアプリケーションはwolfCryptのアルゴリズムでパフォーマンステストを実行します。


wolfCrypt/Benchmark(`./wolfcrypt/benchmark/benchmark`)にあるベンチマークユーティリティは、WolfCryptの暗号化機能をベンチマークするために使用できます。典型的な出力は次のように見えるかもしれません(この出力では、ECC、SHA-256、SHA-512、AES-GCM、AES-CCM、およびCAMELLIAなど、いくつかのオプションのアルゴリズム/暗号が有効になりました)：



```sh
./wolfcrypt/benchmark/benchmark
```


出力結果:


```text
------------------------------------------------------------------------------
 wolfSSL version 4.8.1
------------------------------------------------------------------------------
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
RNG                105 MB took 1.004 seconds,  104.576 MB/s Cycles per byte= 20.94
AES-128-CBC-enc    310 MB took 1.008 seconds,  307.434 MB/s Cycles per byte=  7.12
AES-128-CBC-dec    290 MB took 1.002 seconds,  289.461 MB/s Cycles per byte=  7.56
AES-192-CBC-enc    265 MB took 1.010 seconds,  262.272 MB/s Cycles per byte=  8.35
AES-192-CBC-dec    240 MB took 1.013 seconds,  236.844 MB/s Cycles per byte=  9.24
AES-256-CBC-enc    240 MB took 1.011 seconds,  237.340 MB/s Cycles per byte=  9.22
AES-256-CBC-dec    235 MB took 1.018 seconds,  230.864 MB/s Cycles per byte=  9.48
AES-128-GCM-enc    160 MB took 1.011 seconds,  158.253 MB/s Cycles per byte= 13.83
AES-128-GCM-dec    160 MB took 1.016 seconds,  157.508 MB/s Cycles per byte= 13.90
AES-192-GCM-enc    150 MB took 1.022 seconds,  146.815 MB/s Cycles per byte= 14.91
AES-192-GCM-dec    150 MB took 1.039 seconds,  144.419 MB/s Cycles per byte= 15.16
AES-256-GCM-enc    130 MB took 1.017 seconds,  127.889 MB/s Cycles per byte= 17.12
AES-256-GCM-dec    140 MB took 1.030 seconds,  135.943 MB/s Cycles per byte= 16.10
GMAC Table 4-bit   321 MB took 1.002 seconds,  320.457 MB/s Cycles per byte=  6.83
CHACHA             420 MB took 1.002 seconds,  419.252 MB/s Cycles per byte=  5.22
CHA-POLY           330 MB took 1.013 seconds,  325.735 MB/s Cycles per byte=  6.72
MD5                655 MB took 1.007 seconds,  650.701 MB/s Cycles per byte=  3.36
POLY1305          1490 MB took 1.002 seconds, 1486.840 MB/s Cycles per byte=  1.47
SHA                560 MB took 1.004 seconds,  557.620 MB/s Cycles per byte=  3.93
SHA-224            240 MB took 1.011 seconds,  237.474 MB/s Cycles per byte=  9.22
SHA-256            250 MB took 1.020 seconds,  245.081 MB/s Cycles per byte=  8.93
SHA-384            380 MB took 1.005 seconds,  377.963 MB/s Cycles per byte=  5.79
SHA-512            380 MB took 1.007 seconds,  377.260 MB/s Cycles per byte=  5.80
SHA3-224           385 MB took 1.009 seconds,  381.679 MB/s Cycles per byte=  5.74
SHA3-256           360 MB took 1.004 seconds,  358.583 MB/s Cycles per byte=  6.11
SHA3-384           270 MB took 1.020 seconds,  264.606 MB/s Cycles per byte=  8.27
SHA3-512           185 MB took 1.019 seconds,  181.573 MB/s Cycles per byte= 12.06
HMAC-MD5           665 MB took 1.004 seconds,  662.154 MB/s Cycles per byte=  3.31
HMAC-SHA           590 MB took 1.004 seconds,  587.535 MB/s Cycles per byte=  3.73
HMAC-SHA224        240 MB took 1.018 seconds,  235.850 MB/s Cycles per byte=  9.28
HMAC-SHA256        245 MB took 1.013 seconds,  241.805 MB/s Cycles per byte=  9.05
HMAC-SHA384        365 MB took 1.006 seconds,  362.678 MB/s Cycles per byte=  6.04
HMAC-SHA512        365 MB took 1.009 seconds,  361.674 MB/s Cycles per byte=  6.05
PBKDF2              30 KB took 1.000 seconds,   29.956 KB/s Cycles per byte=74838.56
RSA     2048 public      18400 ops took 1.004 sec, avg 0.055 ms, 18335.019 ops/sec
RSA     2048 private       300 ops took 1.215 sec, avg 4.050 ms, 246.891 ops/sec
DH      2048 key gen      1746 ops took 1.000 sec, avg 0.573 ms, 1745.991 ops/sec
DH      2048 agree         900 ops took 1.060 sec, avg 1.178 ms, 849.210 ops/sec
ECC   [      SECP256R1]   256 key gen       901 ops took 1.000 sec, avg 1.110 ms, 900.779 ops/sec
ECDHE [      SECP256R1]   256 agree        1000 ops took 1.105 sec, avg 1.105 ms, 904.767 ops/sec
ECDSA [      SECP256R1]   256 sign          900 ops took 1.022 sec, avg 1.135 ms, 880.674 ops/sec
ECDSA [      SECP256R1]   256 verify       1300 ops took 1.012 sec, avg 0.779 ms, 1284.509 ops/sec
Benchmark complete
```



これは、数学ライブラリを変更する前後に公開キーの速度を比較するのに特に役立ちます。通常の数学ライブラリ(`./configure`)、Fastmath Library(`./configure --enable-fastmath`)、およびFasthugemath Library(`./configure --enable-fasthugemath`)を使用して結果をテストできます。


詳細やベンチマークの結果については、wolfSSLベンチマークページを参照してください。<https：//www.wolfssl.com/docs/benchmarks>



### 相対パフォーマンス



個々の暗号とアルゴリズムの性能はホストプラットフォームによって異なりますが、次のグラフはwolfCryptの暗号の間の相対性能を示しています。これらのテストは、2.2 GHz Intel Core I7を実行しているMacBook Pro(OS X 10.6.8)で行われました。

![Benchmark](benchmark.png)



暗号のサブセットのみを使用する場合は、SSL/TLS接続を作成するときにwolfSSLが使用する特定の暗号スイートおよび/またはCiphersをカスタマイズできます。たとえば、128ビットAESを強制するには、コールの後に[`wolfSSL_CTX_new(SSL_CTX_new)`](group__Setup.md#function-wolfssl_ctx_new)に次の行を追加します。



```c
wolfSSL_CTX_set_cipher_list(ctx, “AES128-SHA”);
```




### Benchmarkにノート




1. プロセッサネイティブレジスタサイズ(32対64ビット)は、1000ビット以上の公開キー操作を実行する場合、大きな違いを生可能性があります。


2. ** keygen **(`--enable-keygen`)では、ベンチマークユーティリティを実行するときに鍵生成速度をベンチマークすることもできます。


3. ** FastMath **(`--enable-fastmath`)は動的メモリ使用量を減らし、公開鍵操作を高速化します。FastMathを使用して32ビットプラットフォームでビルドするのに問題がある場合は、PICがレジスタを占有しないように共有ライブラリビルドを無効にしてみてください。(ReadMeのノートも参照)。




    ```sh
    ./configure --enable-fastmath --disable-shared
    make clean
    make
    ```



**注**：wolfSSLで設定オプションを切り替える際に、`make clean`をすることは良い習慣です。

4. デフォルトでは、FastMathは可能であればアセンブリ最適化を使用しようとします。アセンブリの最適化が機能しない場合は、wolfSSLをビルドするときに`TFM_NO_ASM`から`CFLAGS`を追加することで、FastMathを使用することができます。




    ```sh
    ./configure --enable-fastmath C_EXTRA_FLAGS=”-DTFM_NO_ASM”
    ```




5. fasthugemathを使用すると、組み込みプラットフォームで実行されていないユーザーのために、Fastmathをさらにプッシュしようとすることができます。




    ```sh
    ./configure --enable-fasthugemath
    ```




6. デフォルトのwolfSSLビルドを使用すると、メモリ使用量とパフォーマンスのバランスが良好になりました。2つのうちの1つについてもっと心配している場合は、追加のwolfSSL設定オプションについては[オプションをビルドします](chapter02.md#build-options)を参照してください。


7. **バルク転送**：wolfSSLはデフォルトで128バイトI/Oバッファーを使用します。SSLトラフィックの約80％はこのサイズ内で、動的メモリの使用を制限します。バルク転送が必要な場合は、16Kバッファー(最大SSLサイズ)を使用するように構成できます。




### 組み込みシステムのベンチマーク



組み込みシステムにベンチマークアプリケーションをビルドするために、いくつかのビルドオプションがあります。これらには以下が含まれます：



#### BENCH_EMBEDDED




この定義を有効にすると、ベンチマークアプリケーションがメモリ使用量をメガバイトの使用からキロバイトの使用へ切り替えるため使用量が削減されます。デフォルトでは、この定義を使用する場合、暗号とアルゴリズムは25KBでベンチマークを実行します。公開鍵アルゴリズムは、1回以上の反復を超えてのみベンチマークされます(一部の組み込みプロセッサの公開鍵操作がかなり遅くなる可能性がある)。`numBlocks`と`times`を変更することで、`numBlocks`と`times`を変更することで`benchmark.c`で調整できます。



#### USE_CERT_BUFFERS_1024




この定義を有効にすると、ベンチマークアプリケーションがファイルシステムからのテスト用鍵と証明書のロードから切り替えられ、代わりに`<wolfssl_root>/wolfssl/certs_test.h`にある1024ビット鍵と証明書バッファを使用します。組み込みプラットフォームにファイルシステムがない場合([`NO_FILESYSTEM`](chapter02.md#no_filesystem))で2048ビットの公開鍵操作が合理的でない程遅いプロセッサにこの定義を使用するのは便利です。



#### USE_CERT_BUFFERS_2048




この定義を有効にすることは、[`USE_CERT_BUFFERS_1024`](#use_cert_buffers_1024)と同様に2048ビット公開鍵と証明書を受け入れます。この定義は、プロセッサが十分な速さでできる場合に役立ちます
2048ビット公開キー操作ですが、ファイルからキーと証明書をロードできるファイルシステムがない場合。



## クライアントアプリケーションを変更してwolfSSLを使用します



このセクションでは、wolfSSLネイティブAPIを使用して、クライアントアプリケーションにwolfSSLを追加するために必要な基本的な手順について説明します。サーバーの説明については、[wolfSSLを使用するためにサーバーアプリケーションを変更します](#changing-a-server-application-to-use-wolfssl)を参照してください。11章のSSLチュートリアルに例を挙げたより完全なウォークスルーがあります。OpenSSL互換性レイヤーの詳細については、[OpenSSL互換性](chapter13.md#openssl-compatibility)を参照してください。



1. wolfSSLヘッダーを含める：




    ```c
    #include <wolfssl/ssl.h>
    ```




2. wolfSSLと`WOLFSSL_CTX`を初期化します。1つの`WOLFSSL_CTX`を使用しても、作成することになっても、1つの`WOLFSSL_CTX`を使用できます。基本的に、接続しているサーバーを確認するためにCA証明書を読み込む必要があります。基本的な初期化は次のように見えます：




    ```c
    wolfSSL_Init();
    WOLFSSL_CTX* ctx;
    if ((ctx=wolfSSL_CTX_new(wolfTLSv1_client_method())) == NULL)
    {
        fprintf(stderr, "wolfSSL_CTX_new error.\n");
        exit(EXIT_FAILURE);
    }
    if (wolfSSL_CTX_load_verify_locations(ctx,"./ca-cert.pem",0) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./ca-cert.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    ```




3. 各TCP接続後にwolfSSLオブジェクトを作成し、ファイル記述子をセッションに関連付けます。




    ```c
    /*after connecting to socket fd*/
    WOLF SSL* ssl;
    if ((ssl=wolfSSL_new(ctx)) == NULL) {
        fprintf(stderr, "wolfSSL_new error.\n");
        exit(EXIT_FAILURE);
    }
    wolfSSL_set_fd(ssl, fd);
    ```




4. すべての呼び出しを`read()`(または`recv()`)から[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)に変更します。




    ```c
    result=read(fd, buffer, bytes);
    ```



    次のようになります



    ```c
    result=wolfSSL_read(ssl, buffer, bytes);
    ```




5. すべての呼び出しを`write()`(または`send()`)から[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)に変更します。




    ```c
        result=write(fd, buffer, bytes);
    ```



    becomes



    ```c
    result=wolfSSL_write(ssl, buffer, bytes);
    ```




6. [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)を手動で呼び出すことはできますが、それは必要ありません。[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)または[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)の最初の呼び出しは、まだ行われていない場合は[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)を開始します。


7. エラーチェック各[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)および[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)呼び出しは、`read()`と`write()`と同じように、成功時に0、接続クロージャーの場合は0、およびエラーの間のバイト数を返します。エラーが発生した場合は、2つの通話を使用して、以下の情報を入手できます。エラー：




    ```c
    char errorString[80];
    int err=wolfSSL_get_error(ssl, 0);
    wolfSSL_ERR_error_string(err, errorString);
    ```



    非ブロッキングソケットを使用している場合は、Errno `EAGAIN`/`EWOULDBLOCK`以上をテストできます。

8. 掃除。各wolfSSLオブジェクトが使用された後、あなたはそれによってそれを解放することができます

    呼び出し：



    ```c
    wolfSSL_free(ssl);
    ```



    SSL/TLSを使用して完全に完全に行われたら、`WOLFSSL_CTX`オブジェクトを呼び出して無料で行うことができます。



    ```c
    wolfSSL_CTX_free(ctx);
    wolfSSL_Cleanup();
    ```



wolfSSLを使用したクライアントアプリケーションの例については、`<wolfssl_root>/examples/client.c`ファイルにあるクライアントの例を参照してください。



## wolfSSLを使用するためにサーバーアプリケーションを変更します



このセクションでは、wolfSSLネイティブAPIを使用してwolfSSLをサーバーアプリケーションに追加するために必要な基本的な手順について説明します。クライアントの説明については、[クライアントアプリケーションを変更してwolfSSLを使用します](#changing-a-client-application-to-use-wolfssl)をご覧ください。



1. ステップ5でクライアントメソッド呼び出しをサーバーに変更する以外のクライアントの手順に従ってください。




    ```c
    wolfSSL_CTX_new(wolfTLSv1_client_method());
    ```



    次のようになります



    ```c
    wolfSSL_CTX_new(wolfTLSv1_server_method());
    ```



    あるいは：



    ```c
    wolfSSL_CTX_new(wolfSSLv23_server_method());
    ```



    SSLV3およびTLSV1+クライアントがサーバーに接続できるようにします。

2. 上記のステップ5の初期化にサーバーの証明書とキーファイルを追加します。




    ```c
    if (wolfSSL_CTX_use_certificate_file(ctx,"./server-cert.pem", SSL_FILETYPE_PEM) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./server-cert.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    if (wolfSSL_CTX_use_PrivateKey_file(ctx,"./server-key.pem", SSL_FILETYPE_PEM) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./server-key.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    ```



使用可能なファイルシステムがない場合は、バッファーから証明書とキーをロードすることもできます。この場合、詳細については、ここにリンクされている[`wolfSSL_CTX_use_certificate_buffer()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_buffer)および[`wolfSSL_CTX_use_PrivateKey_buffer()`](group__CertsKeys.md#function-wolfssl_ctx_use_privatekey_buffer) APIドキュメントを参照してください。

wolfSSLを使用したサーバーアプリケーションの例については、`<wolfssl_root>/examples/server.c`ファイルにあるサーバーの例を参照してください。
