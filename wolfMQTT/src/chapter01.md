#  Introduction

This is an implementation of the MQTT (Message Queuing Telemetry Transport) Client written in C. This library was built from the ground up to be multi-platform, space conscience and extensible. It supports all Packet Types, all Quality of Service (QoS) levels 0-2 and supports SSL/TLS using the wolfSSL library. This implementation is based on the MQTT v3.1.1 specification.

##  Protocol Overview

MQTT is a lightweight open messaging protocol that was developed for constrained environments such as M2M (Machine to Machine) and IoT (Internet of Things), where a small code footprint is required. MQTT is based on the Pub/Sub messaging principle of publishing messages and subscribing to topics. The protocol efficiently packs messages to keep the overhead very low. The MQTT specification recommends TLS as a transport option to secure the protocol using port 8883 (secure-mqtt). Constrained devices can benefit from using TLS session resumption to reduce the reconnection cost.

MQTT defines QoS levels 0-2 to specify the delivery integrity required:
0 = At most once delivery: No acknowledgment.
1 = At least once delivery: Sends acknowledgment (PUBLISH_ACK).
2 = Exactly once delivery: Sends received (PUBLISH_REC), gets back released
(PUBLISH_REL) and then sends complete (PUBLISH_COMP).

**Highlights** :

- A publish message payload can be up to 256MB (28 bits).
- Packet header remaining length is encoded using a scheme where the most significant bit (7) indicates an additional length byte.
- Packets which require a response must include a 16-bit packet Id. This needs to be unique for any outstanding transactions. Typically an incremented value.
- A client can provide a last will and testament upon connect, which will be delivered when the broker sees the client has disconnected or network keep-alive has expired.
- The packet types are: CONNECT, CONNECT_ACK, PUBLISH, PUBLISH_ACK, PUBLISH_REC, PUBLISH_REL, PUBLISH_COMP, SUBSCRIBE, SUBSCRIBE_ACK, UNSUBSCRIBE, UNSUBSCRIBE_ACK, PING_REQ, PING_RESP and DISCONNECT.
- The connect packet contains the ASCII string “MQTT” to define the protocol name. This can be useful for wireshark/sniffing.
- Multiple topics can be subscribed or unsubscribed in the same packet request.
- Each subscription topic must define a QoS level. The QoS level is confirmed in the subscription acknowledgment.
- A publish message can be sent or received by either the client or the broker.
- Publish messages can be flagged for retention on the broker.
- A QoS level 2 requires two round-trips to complete the delivery exchange confirmation.
- Strings are UTF-8 encoded.

See https://mqtt.org/documentation for additional MQTT documentation.

## Broker compatibility
wolfMQTT client library has been tested with the following brokers:

* Adafruit IO by Adafruit

* AWS by Amazon

* Azure by Microsoft

* flespi by Gurtam

* HiveMQ and HiveMQ Cloud by HiveMQ GmbH

* IBM WIoTP Message Gateway by IBM

* Mosquitto by Eclipse

* Paho MQTT-SN Gateway by Eclipse

* VerneMQ by VerneMQ/Erlio

## Specification Support

### MQTT v3.1.1 Specification Support

The initially supported version with full specification support for all features and packets type such as:

* QoS 0-2

* Last Will and Testament (LWT)

* Client examples for: AWS, Azure IoT, IBM Watson, Firmware update, non-blocking and generic.

### MQTT v5.0 Specification Support

The wolfMQTT client supports connecting to v5 enabled brokers when configured with the `--enable-mqtt5` option. Handling properties received from the server is accomplished via a callback when the `--enable-propcb` option is set. The following v5.0 specification features are supported by the wolfMQTT client:

* AUTH packet

* User properties

* Server connect ACK properties

* Format and content type for publish

* Server disconnect

* Reason codes and strings

* Maximum packet size

* Server assigned client identifier

* Subscription ID

* Topic Alias

The v5 enabled wolfMQTT client was tested with the following MQTT v5 brokers:

* Mosquitto

** Runs locally.

** `./examples/mqttclient/mqttclient -h localhost`

* Flespi

** Requires an account tied token that is regenerated hourly.

** `./examples/mqttclient/mqttclient -h "mqtt.flespi.io" -u "<your-flespi-token>"`

* VerneMQ MQTTv5 preview

** Runs locally.

** `./examples/mqttclient/mqttclient -h localhost`

* HiveMQ 4.0.0 EAP

** Runs locally.

** `./examples/mqttclient/mqttclient -h localhost`

* HiveMQ Cloud

** `./examples/mqttclient/mqttclient -h 833f87e253304692bd2b911f0c18dba1.s1.eu.hivemq.cloud -t -S -u wolf1 -w NEZjcm7i8eRjFKF -p 8883`

* Watson IoT Quickserver

** `./examples/wiot/wiot`

### MQTT Sensor Network (MQTT-SN) Specification Support

The wolfMQTT SN Client implementation is based on the OASIS MQTT-SN v1.2 specification. The SN API is configured with the `--enable-sn` option. There is a separate API for the sensor network API, which all begin with the "SN_" prefix. The wolfMQTT SN Client operates over UDP, which is distinct from the wolfMQTT clients that use TCP. The following features are supported by the wolfMQTT SN Client:

* Register

* Will topic and message set up

* Will topic and message update

* All QoS levels

* Variable-sized packet length field

Unsupported features:

* Automatic gateway discovery is not implemented

* Multiple gateway handling

The SN client was tested using the Eclipse Paho MQTT-SN Gateway (https://github.com/eclipse/paho.mqtt-sn.embedded-c) running locally and on a separate network node. Instructions for building and running the gateway are in the project README.
