#  ライブラリデザイン

ライブラリのヘッダーファイル群は`/wolfmqtt`ディレクトリに格納してあります。`/wolfmqtt/mqtt_client.h`ファイルだけがプロジェクトでインクルードすべきヘッダーファイルです:


```
#include <wolfmqtt/mqtt_client.h>
```

ライブラリは３つのコンポーネントから構成されています：

### mqtt_client

MQTT クライアント向けの最上位アプリケーションインターフェースが位置する場所です。


* `int MqttClient_Init(MqttClient *client, MqttNet *net, MqttMsgCb msg_cb, byte *tx_buf, int tx_buf_len, byte *rx_buf, int rx_buf_len, int cmd_timeout_ms);`

次のAPIはエラーかタイムアウト(`cmd_timeout_ms`)が発生するまで、`MqttNet.read`でブロックするAPI群です：


* `int MqttClient_Connect(MqttClient *client, MqttConnect *connect);`
* `int MqttClient_Publish(MqttClient *client, MqttPublish *publish);`
* `int MqttClient_Subscribe(MqttClient *client, MqttSubscribe *subscribe);`
* `int MqttClient_Unsubscribe(MqttClient *client, MqttUnsubscribe *unsubscribe);`
* `int MqttClient_Ping(MqttClient *client);`
* `int MqttClient_Disconnect(MqttClient *client);`

この関数は新しいパブリッシュメッセージの到着を待って最大`timeout_ms`時間だけブロックします：


* `int MqttClient_WaitMessage(MqttClient *client, MqttMessage *message, int timeout_ms);`

ネットワークの接続/切断　用インターフェースでMqttNetコールバック関数をラップしwolfSSL TLSをハンドリングするAPI：


* `int MqttClient_NetConnect(MqttClient *client, const char* host, word16 port, int timeout_ms, int use_tls, MqttTlsCb cb);`
* `int MqttClient_NetDisconnect(MqttClient *client);`

ヘルパー関数:

* `const char* MqttClient_ReturnCodeToString(int return_code);`

###  mqtt_packet

ここでは全パケットのエンコード/デコードをハンドリングするコードが含まれています。ヘッダーはMQTT構造体を含んでいます：


* 接続: `MqttConnect`
* パブリッシュ / メッセージ: `MqttPublish` / `MqttMessage` (これらは同一)
* サブスクライブ: `MqttSubscribe`
* サブスクライブ解除: `MqttUnsubscribe`


###  mqtt_socket
これこには、トランスポート ソケットがオプションで TLS をラップし、プラットフォーム固有のネットワーク処理のために `MqttNet` コールバックを使用するコードが含まれています。

ヘッダーはMQTTネットワーク構造体`MqttNet`、コールバック関数、コンテキスト定義を含んでいます。


###  サンプルプログラムのデザイン

サンプルプログラムでは、共通の examples/mqttnet.c を使用して、クライアントでネットワーク コールバックを処理します。 このプログラムは、Linux (BSD ソケット)、FreeRTOS/LWIP、MQX RTCS、Harmony、および Windows をサポートしています。