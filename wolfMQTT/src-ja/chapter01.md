#  イントロダクション

このライブラリはMQTT (Message Queuing Telemetry Transport)クライアントのC言語実装です。マルチプラットフォーム対応、省コード量、拡張性を重視してゼロから記述しました。すべてのパケットタイプ、すべてのQoSレベル（０～２）に対応しさらにwolfSSLライブラリを使用してSSL/TLSをサポートしています。また、本実装はMQTT v3.1.1仕様に基づいています。


##  プロトコル概要

MQTTは軽量なオープンメッセージ送信プロトコルでM2M（機器対機器）、IoT（モノのインターネット）などのコードサイズに制限のある環境向けに開発されました。MQTTはトピックの購読と発行というPublish/Subscribeメッセージ配信モデルに基づいています。このプロトコルは効率的にメッセージをパッケージングしオーバーヘッドを非常に少なく保つことができます。MQTT仕様ではトランスポートの選択子としてTLSを使用し、8883番（セキュアMQTT)ポートを使ってこのプロトコルをセキュアにすることを推奨しています。制限の多い機器でのTLS使用にはセッション再開を活用して再接続のコストを低減できるかもしれません。


MQTT では以下に要求される配信整合性をQoSレベル0-2 として定義しています： <br>
０ = たかだか一回の配信を保障：受け取り確認はしない <br>
１ = 少なくとも一回の配信を保障：受け取り確認(PUBLISH_ACK)を送信する <br>
２ = 正確に一回の配信を保証：受信済み(PUBLISH_REC)を送信、解放(PUBLISH_REL)を受信、完了(PUBLISH_COMP)を送信 <br>

**特筆すべき特徴** : <br>

* パブリッシュメッセージは256MB (28 bits)までのペイロードを含むことが可能 <br>

* パケットヘッダーのremaining length は最上位ビット(7)が追加長バイトの存在を意味するようにエンコードされます。 <br>

* レスポンスを必要とするパケットは16bitのpacket Idを含めなければなりません。このIdは未応答のトランザクションの識別に必要なのでユニークでなければなりません。通常、連番が使われます <br>

* クライアントはlast will(遺言)を接続時に提示することができます。last willはブローカーがこのクライアントは切断してしまったかネットワークのkeep-alive時間を超過したと判断した際に配信されます。 <br>

* パケットタイプには、CONNECT, CONNECT_ACK, PUBLISH, PUBLISH_ACK, PUBLISH_REC, PUBLISH_REL, PUBLISH_COMP, SUBSCRIBE, SUBSCRIBE_ACK, UNSUBSCRIBE, UNSUBSCRIBE_ACK, PING_REQ, PING_RESP と DISCONNECT　があります。 <br>

* CONNECTパケットはASCII文字列の"MQTT"を含んでいて、プロトコル名として定義するために使っています。Wireshark等を使ったパケット解析時に役に立ちます。 <br>

* 複数のトピックを単一のパケットで購読依頼、購読解除することができます。 <br>

* 購読されている各トピックはQoSレベルを指定しなければなりません。確定したレベルは購読確認応答パケットで確認できます。 <br>

* PUBLISHメッセージはクライアントかブローカーのいずれかによって送信/受信できます。 <br>

* QoSレベル２は配信確認を完了するために2往復の通信を必要とします。 <br>

* 文字列はUTF-8でエンコードされます。 <br>

さらなるドキュメントが必要な場合には https://mqtt.org/documentation を参照してください。

## ブローカー互換性
wolfMQTTライブラリは下記のブローカーとの動作確認を行っています: <br>

* Adafruit IO （Adafruit提供） <br>

* AWS  （Amazon提供） <br>

* Azure （Microsoft提供） <br>

* flespi （Gurtam提供） <br>

* HiveMQ と HiveMQ Cloud （HiveMQ GmbH提供） <br>

* IBM WIoTP Message Gateway （IBM提供） <br>

* Mosquitto （Eclipse提供） <br>

* Paho MQTT-SN Gateway （Eclipse提供） <br>

* VerneMQ  （VerneMQ/Erlio提供） <br>

## サポート仕様

### MQTT v3.1.1

以下の様なフル機能と全パケットタイプをサポートした最初にサポートしたバージョンです： <br>

* QoS 0-2 <br>

* Last Will and Testament (LWT) <br>

* 次のブローカ対応したクライアントサンプル（AWS, Azure IoT, IBM Watson） <br>

* ファームウエア更新、ノンブロッキング とジェネリックに対応 <br>

### MQTT v5.0

wolfMQTTクライアントはv5.0仕様が有効になっているブローカーへの接続をサポートしています（`--enable-mqtt5`オプションを指定してビルドした場合)。ブローカーからのプロパティはコールバックを使ってのハンドリングされます（`--enable-propcb`オプションを指定してビルドした場合)。以下のv5.0仕様の機能がwolfMQTTクライアントによってサポートされています： <br>


* AUTH パケット <br>

* User プロパティ <br>

* Server connect ACK プロパティ <br>

* Formatタイプ と　contentタイプ （publish時） <br>

* Server disconnect <br>

* Reasonコードと文字列 <br>

* 最大パケットサイズ <br>

* サーバー側付与のクライアントID <br>

* 購読ID <br>

* トピックエイリアス <br>

v5.0仕様が有効化されているwolfMQTTクライアントは次のv5.0ブローカーとの接続がテストされています： <br>

* Mosquitto <br>

ローカルPCで実行:

```
./examples/mqttclient/mqttclient -h localhost
```

* Flespi <br>

毎時生成されるトークンと結びつけられたアカウントが必要です:

```
./examples/mqttclient/mqttclient -h "mqtt.flespi.io" -u "<your-flespi-token>"
```

* VerneMQ MQTTv5 preview <br>

ローカルPCで実行:

```
./examples/mqttclient/mqttclient -h localhost
```

* HiveMQ 4.0.0 EAP <br>

ローカルPCで実行:

```
./examples/mqttclient/mqttclient -h localhost
```

* HiveMQ Cloud <br>

```
./examples/mqttclient/mqttclient -h 833f87e253304692bd2b911f0c18dba1.s1.eu.hivemq.cloud -t -S -u wolf1 -w NEZjcm7i8eRjFKF -p 8883
```

* Watson IoT Quickserver <br>

```
./examples/wiot/wiot
```

### MQTT センサーネットワーク(MQTT-SN)

wolfMQTTクライアント実装はOASIS MQTT-SN v1.2仕様に基づいています。このSN API は`--enable-sn`オプションと共にビルドすると実行可能に構成されます。センサーネットワーク用APIは”SN_"がプレフィクスとして付加されている別のAPIです。wolfMQTT SNクライアントはUDP上で動作しますが、TCP上で動作するwolfMQTTとは区別されています。以下の機能がwolfMQTT SNクライアントとしてサポートされています： <br>


* Register <br>

* Will topic とメッセージセットアップ <br>

* Will topic と メッセージ更新 <br>

* 全QoSレベル <br>

* 可変サイズのパケット長フィールド <br>

サポートしていない機能： <br>

* 自動ゲートウェイ検索 <br>

* 複数ゲートウェイハンドリング <br>

SNクライアントはEclipse Paho MQTT-SN Gateway (https://github.com/eclipse/paho.mqtt-sn.embedded-c)を分離したネットワークノード上でローカルに動作させた環境でテストしました。ゲートウェイのビルドと実行に関してはプロジェクトに含まれているREADMEに記載しています。

