# Getting Started

Here are the steps for creating your own implementation:

1. Create network callback functions for Connect, Read, Write and Disconnect. See examples/mqttnet.c and examples/mqttnet.h for reference implementation.
2. Define the network callback functions and context in a MqttNet structure.
3. Call MqttClient_Init passing in a MqttClient structure pointer, MqttNet structure pointer, MqttMsgCb function callback pointer, TX/RX buffers with maximum length and command timeout.
4. Call MqttClient_NetConnect to connect to broker over network. If use_tls is non-zero value then it will perform a TLS connection. The TLS callback MqttTlsCb should be defined for WolfSSL certificate configuration.
5. Call MqttClient_Connect passing pointer to MqttConnect structure to send MQTT connect command and wait for Connect Ack.
6. Call MqttClient_Subscribe passing pointer to MqttSubscribe structure to send MQTT Subscribe command and wait for Subscribe Ack (depending on QoS level).
7. Call MqttClient_WaitMessage passing pointer to MqttMessage to wait for incoming MQTT Publish message.

##  Examples

### Client Example
The example MQTT client is located in `/examples/mqttclient/`. This example exercises many of the exposed API’s and prints any incoming publish messages for subscription topic “wolfMQTT/example/testTopic”. This client contains examples of many MQTTv5 features, including the property callback and server assignment of client ID. The mqqtclient example is a good starting template for your MQTT application.

### Simple Standalone Client Example
The example MQTT client is located in `/examples/mqttsimple/`. This example demonstrates a standalone client using standard BSD sockets. This requires `HAVE_SOCKET` to be defined, which comes from the ./configure generated `wolfmqtt/config.h` file. All parameters are build-time macros defined at the top of `/examples/mqttsimple/mqttsimple.c`.

### Non-Blocking Client Example
The example MQTT client is located in `/examples/nbclient/`. This example uses non-blocking I/O for message exchange. The wolfMQTT library must be configured with the `--enable-nonblock` option (or built with `WOLFMQTT_NONBLOCK`).

### Firmware Example
The MQTT firmware update is located in `/examples/firmware/`. This example has two parts. The first is called “fwpush”, which signs and publishes a firmware image. The second is called “fwclient”, which receives the firmware image and verifies the signature. This example publishes message on the topic “wolfMQTT/example/firmware”. The "fwpush" application is an example of using a publish callback to send the payload data.

### Azure IoT Hub Example
We setup a wolfMQTT IoT Hub on the Azure server for testing. We added a device called `demoDevice`, which you can connect and publish to. The example demonstrates creation of a SasToken, which is used as the password for the MQTT connect packet. It also shows the topic names for publishing events and listening to `devicebound` messages. This example only works with `ENABLE_MQTT_TLS` set and the wolfSSL library present because it requires Base64 Encode/Decode and HMAC-SHA256. Note: The wolfSSL library must be built with `./configure --enable-base64encode` or `#define WOLFSSL_BASE64_ENCODE`. The `wc_GetTime` API was added in 3.9.1 and if not present you'll need to implement your own version of this to get current UTC seconds or update your wolfSSL library.
**NOTE** The Azure broker only supports MQTT v3.1.1

### AWS IoT Example
We setup an AWS IoT endpoint and testing device certificate for testing. The AWS server uses TLS client certificate for authentication. The example is located in `/examples/aws/`. The example subscribes to `$aws/things/"AWSIOT_DEVICE_ID"/shadow/update/delta` and publishes to `$aws/things/"AWSIOT_DEVICE_ID"/shadow/update`.
**NOTE** The AWS broker only supports MQTT v3.1.1

### Watson IoT Example
This example enables the wolfMQTT client to connect to the IBM Watson Internet of Things (WIOT) Platform. The WIOT Platform has a limited test broker called "Quickstart" that allows non-secure connections to exercise the component. The example is located in `/examples/wiot/`. Works with MQTT v5 support enabled.

### MQTT-SN Example
The Sensor Network client implements the MQTT-SN protocol for low-bandwidth networks. There are several differences from MQTT, including the ability to use a two byte Topic ID instead the full topic during subscribe and publish. The SN client requires an MQTT-SN gateway. The gateway acts as an intermediary between the SN clients and the broker. This client was tested with the Eclipse Paho MQTT-SN Gateway, which connects by default to the public Eclipse broker, much like our wolfMQTT Client example. The address of the gateway must be configured as the host. The example is located in `/examples/sn-client/`.

A special feature of MQTT-SN is the ability to use QoS level -1 (negative one) to publish to a predefined topic without first connecting to the gateway. There is no feedback in the application if there was an error, so confirmation of the test would involve running the `sn-client` first and watching for the publish from the `sn-client_qos-1`. There is an example provided in `/examples/sn-client/sn-client_qos-1`. It requires some configuration changes of the gateway.

* Enable the QoS-1 feature, predefined topics, and change the gateway name in `gateway.conf`:

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

* Comment out all entries and add a new topic in `predefinedTopic.conf`:

```
WolfGatewayQoS-1,wolfMQTT/example/testTopic, 1
```

### Multithread Example
This example exercises the multithreading capabilities of the client library. The client implements two tasks: one that publishes to the broker; and another that waits for messages from the broker. The publish thread is created `NUM_PUB_TASKS` times (10 by default) and sends unique messages to the broker. This feature is enabled using the `--enable-mt` configuration option. The example is located in `/examples/multithread/`.

## Example Options
The command line examples can be executed with optional parameters. To see a list of the available parameters, add the `-?`

```
 ./examples/mqttclient/mqttclient -?
mqttclient:
-?          Help, print this usage
-h <host>   Host to connect to, default: test.mosquitto.org
-p <num>    Port to connect on, default: Normal 1883, TLS 8883
-t          Enable TLS
-A <file>   Load CA (validate peer)
-K <key>    Use private key (for TLS mutual auth)
-c <cert>   Use certificate (for TLS mutual auth)
-S <str>    Use Host Name Indication, blank defaults to host
-q <num>    Qos Level 0-2, default: 0
-s          Disable clean session connect flag
-k <num>    Keep alive seconds, default: 60
-i <id>     Client Id, default: WolfMQTTClient
-l          Enable LWT (Last Will and Testament)
-u <str>    Username
-w <str>    Password
-m <str>    Message, default: test
-n <str>    Topic name, default: wolfMQTT/example/testTopic
-r          Set Retain flag on publish message
-C <num>    Command Timeout, default: 30000ms
-P <num>    Max packet size the client will accept, default: 1048576
-T          Test mode
-f <file>   Use file contents for publish
```
The available options vary depending on the library configuration.
