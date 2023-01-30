# 始めましょう

皆さんが実装を開始するためのステップを説明します：

1. Connect、Read、Write、および Disconnect のネットワーク コールバック関数を作成します。 参考にする実装は、examples/mqttnet.c および examples/mqttnet.h です。
2. MqttNet 構造でネットワーク コールバック関数とコンテキストを定義します。
3. MqttClient_Init を呼び出して、MqttClient 構造ポインター、MqttNet 構造ポインター、MqttMsgCb 関数コールバック ポインター、最大長の TX/RX バッファー、およびコマンド タイムアウトを渡します。
4. MqttClient_NetConnect を呼び出して、ネットワーク経由でブローカーに接続します。 use_tls がゼロ以外の値の場合、TLS 接続を実行します。 wolfSSL 証明書の構成には、TLS コールバック MqttTlsCb を定義する必要があります。
5. MqttConnect 構造体へのポインターを渡す MqttClient_Connect を呼び出して、MQTT 接続コマンドを送信し、Connect Ack を待ちます。
6. MqttSubscribe 構造体へのポインターを渡す MqttClient_Subscribe を呼び出して、MQTT Subscribe コマンドを送信し、Subscribe Ack を待機します (QoS レベルによって異なります)。
7. MqttClient_WaitMessage を呼び出して、MqttMessage へのポインターを渡して、着信 MQTT Publish メッセージを待機します。


## サンプルプログラム

### クライアント　サンプルプログラム

MQTT クライアントのサンプルプログラムは、`/examples/mqttclient/` にあります。 このサンプルプログラムでは、公開API の多くを実行し、サブスクライブしたトピック「wolfMQTT/example/testTopic」に対してパブリッシュされたメッセージを受信して内容を出力します。 このクライアントには、プロパティ コールバックやクライアント ID のサーバー割り当てなど、多くの MQTTv5 機能の例が含まれています。 mqqtclient の例は、MQTT アプリケーションの足がかりのテンプレートとして適しています。



### シンプルスタンドアロンクライアント　サンプルプログラム

このサンプルプログラムは、`/examples/mqttsimple/` にあります。 このサンプルプログラムは、標準の BSD ソケットを使用するスタンドアロン クライアントを示しています。 これには、./configure によって生成された `wolfmqtt/config.h` ファイルに `HAVE_SOCKET` の定義を追加する必要があります。 すべてのパラメーターは、`/examples/mqttsimple/mqttsimple.c` の上部で定義されたビルド時マクロです。



### ノンブロッキングクライアント　サンプルプログラム
このサンプルプログラムは、`/examples/nbclient/` にあります。 このサンプルプログラムは、メッセージ交換にノンブロッキング I/O を使用しています。 wolfMQTT ライブラリは、`--enable-nonblock` オプションを指定する必要があります (または `WOLFMQTT_NONBLOCK` を定義してビルドします)。


### ファームウエア サンプルプログラム
このサンプルプログラムは `/examples/firmware/`にあります。このサンプルプログラムは２つの実行プログラムから成っています。 1 つ目は”fwpush”と呼ばれ、ファームウェア イメージに署名してパブリッシュします。 2 つ目は”fwclient”と呼ばれ、ファームウェア イメージを受信して署名を検証します。"fwpush"はトピック「wolfMQTT/example/firmware」にメッセージをパブリッシュし、パブリッシュコールバックを使用してペイロード データを送信します。



### Azure IoT Hub サンプルプログラム

テスト用に Azure サーバーに wolfMQTT IoT Hub をセットアップします。 弊社では既に皆さんが接続してパブリッシュすることができる「demoDevice」というデバイスを追加してあります。 このサンプルプログラムは、MQTT 接続パケットのパスワードとして使用される SasToken の作成を示しています。 また、イベントを発行し、「devicebound」メッセージをリッスンするためのトピック名も示しています。 このサンプルプログラムは、Base64 エンコード/デコードと HMAC-SHA256 を必要とするため、「ENABLE_MQTT_TLS」が設定され、wolfSSL ライブラリが存在する場合にのみ機能します。（注： wolfSSL ライブラリは、`./configure --enable-base64encode` または `#define WOLFSSL_BASE64_ENCODE` でビルドする必要があります）。 `wc_GetTime` API は 3.9.1 で追加されました。存在しない場合は、独自のバージョンを実装して現在の UTC 秒を取得するか、wolfSSL ライブラリを更新する必要があります。
**注** Azure ブローカーは MQTT v3.1.1 のみをサポートします

### AWS IoT サンプルプログラム
テスト用に AWS IoT エンドポイントとテスト デバイス証明書をセットアップします。 AWS サーバーは、認証に TLS クライアント証明書を使用します。 サンプルプログラムは「/examples/aws/」にあります。 このサンプルプログラムでは、`$aws/things/"AWSIOT_DEVICE_ID"/shadow/update/delta` にサブスクライブし、`$aws/things/"AWSIOT_DEVICE_ID"/shadow/update` に発行します。
**注** AWS ブローカーは MQTT v3.1.1 のみをサポートします

### Watson IoT サンプルプログラム

このサンプルプログラムでは、wolfMQTT クライアントが IBM Watson Internet of Things (WIOT) Platform に接続できるようにします。 WIOT プラットフォームには、「クイックスタート」と呼ばれる限定的なテスト ブローカーがあり、安全でない接続でコンポーネントを実行できます。 サンプルプログラムは `/examples/wiot/` にあります。 MQTT v5 サポートを有効にして動作します。


### MQTT-SN サンプルプログラム

Sensor Network クライアントは、低帯域幅ネットワーク用に MQTT-SN プロトコルを実装します。 サブスクライブおよびパブリッシュ時に完全なトピックの代わりに 2 バイトのトピック ID を使用できるなど、MQTT とはいくつかの違いがあります。 SN クライアントには MQTT-SN ゲートウェイが必要です。 ゲートウェイは、SN クライアントとブローカーの間の仲介者として機能します。 このクライアントは、Eclipse Paho MQTT-SN ゲートウェイでテストしました。これは、wolfMQTT クライアントの例と同様に、デフォルトでパブリック Eclipse ブローカーに接続します。 ゲートウェイのアドレスは、ホストとして構成する必要があります。 サンプルは `/examples/sn-client/` にあります。

MQTT-SN の特別な機能は、最初にゲートウェイに接続することなく、QoS レベル -1 (負のレベル) を使用して定義済みのトピックに発行できることです。 エラーが発生した場合、アプリケーションにはフィードバックがないため、テストの確認には、最初に「sn-client」を実行し、「sn-client_qos-1」からの発行を監視する必要があります。 `/examples/sn-client/sn-client_qos-1` で提供されるサンプルプログラムがありますが、利用にはゲートウェイの構成をいくつか変更する必要があります。

* QoS-1 機能と定義済みのトピックを有効にし、`gateway.conf`でゲートウェイ名を変更します:


```
QoS-1=YES
PredefinedTopic=YES
PredefinedTopicList=./predefinedTopic.conf
.
.
.
#GatewayName=PahoGateway-01
GatewayName=WolfGateway
```
* すべてのエントリをコメントアウトし、`predefinedTopic.conf` に新しいトピックを追加します:

```
WolfGatewayQoS-1,wolfMQTT/example/testTopic, 1
```

### マルチスレッド サンプルプログラム

このサンプルプログラムでは、クライアントライブラリのマルチスレッド機能を実行します。 クライアントは 2 つのタスクを実装します。1 つはブローカーにパブリッシュするタスクです。 もう 1 つはブローカーからのメッセージを待ちます。 パブリッシュ スレッドは「NUM_PUB_TASKS」回 (デフォルトでは 10 回) 作成され、一意のメッセージをブローカーに送信します。 この機能は、`--enable-mt` 構成オプションを使用して有効にします。 サンプルは `/examples/multithread/` にあります。


## サンプルプログラムのオプション
コマンド ラインの例は、オプションのパラメーターを使用して実行できます。 使用可能なパラメーターのリストを表示するには、`-?`を追加します。

```
 ./examples/mqttclient/mqttclient -?
mqttclient:
-?          ヘルプ, この使用法ページをプリント
-h <host>   接続先ホスト, デフォルトでは: test.mosquitto.org
-p <num>    接続先ポート番号, デフォルトでは: Normal 1883, TLS 8883
-t          TLSを有効にする
-A <file>   CA 証明書をロード(相手の認証に必要)
-K <key>    秘密鍵(TLS の相互認証に必要)
-c <cert>   自分の証明書(TLS の相互認証に必要)
-S <str>    ホスト名インジケーションを使用、空白のデフォルトはhost
-q <num>    Qos Level 0-2, default: 0
-s          クリーンセッションコネクトフラグをDisableにする
-k <num>    Keep alive seconds, default: 60
-i <id>     Client Id, default: WolfMQTTClient
-l          Enable LWT (Last Will and Testament)
-u <str>    Username
-w <str>    Password
-m <str>    Message, default: test
-n <str>    Topic name, default: wolfMQTT/example/testTopic
-r          メッセージのパブリッシュ時に保持フラグをセット
-C <num>    Command Timeout, default: 30000ms
-P <num>    受け付ける最大パケットサイズ, default: 1048576
-T          テストモード
-f <file>   パブリッシュにファイルの内容を使う
```
使用できるオプションはライブラリのコンフィグレーションによって変わります。
