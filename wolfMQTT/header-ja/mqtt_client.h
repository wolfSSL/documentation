/* mqtt_client.h
 *
 * Copyright (C) 2006-2022 wolfSSL Inc.
 *
 * This file is part of wolfMQTT.
 *
 * wolfMQTT is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfMQTT is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */

/* Implementation by: David Garske
 * Based on specification for MQTT v3.1.1
 * See http://mqtt.org/documentation for additional MQTT documentation.
 */

#ifndef WOLFMQTT_CLIENT_H
#define WOLFMQTT_CLIENT_H

#ifdef __cplusplus
    extern "C" {
#endif

/* Windows uses the vs_settings.h file included vis mqtt_types.h */
#if !defined(WOLFMQTT_USER_SETTINGS) && \
    !defined(_WIN32) && !defined(USE_WINDOWS_API)
    /* If options.h is missing use the "./configure" script. Otherwise, copy
     * the template "wolfmqtt/options.h.in" into "wolfmqtt/options.h" */
    #include <wolfmqtt/options.h>
#endif
#include "wolfmqtt/mqtt_types.h"
#include "wolfmqtt/mqtt_packet.h"
#include "wolfmqtt/mqtt_socket.h"

/* This macro allows the disconnect callback to be triggered when
 * MqttClient_Disconnect_ex is called. Normally the CB is only used to handle
 * errors from MqttPacket_HandleNetError.
 */
#ifndef WOLFMQTT_USE_CB_ON_DISCONNECT
    #undef WOLFMQTT_USE_CB_ON_DISCONNECT
    /* #define WOLFMQTT_USE_CB_ON_DISCONNECT */
#endif

#if defined(WOLFMQTT_PROPERTY_CB) && !defined(WOLFMQTT_V5)
    #error "WOLFMQTT_V5 must be defined to use WOLFMQTT_PROPERTY_CB"
#endif

struct _MqttClient;

/*! \brief      Mqttメッセージ受信コールバック関数。
 *  メッセージ本文が最大受信バッファ（RX）サイズ以上の場合には、このコールバック関数が複数回呼び出されます。
    もし、msg_new が 1 の場合には新しいメッセージを意味します。
    topic_name と topic_name length　はmsg_new が 1の場合にのみ意味があります。
    msg_new が 0 の場合には追加のペイロードを受信中であることを意味します。
    コールバックの都度、MqttMessage.bufferにペイロードが格納されます。
    MqttMessage.buffer_lenはペイロード用のバッファーのサイズです。
    MqttMessage.buffer_posは受信したのペイロードの位置を表します。
    MqttMessage.total_lenは受信が完了したペイロードの長さを表します。
    msg_doneが１の場合には、パブリッシュされたペイロード全体が受信済みであることを表します。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      message     ペイロードの属性が設定済みのMqttMessage構造体へのポインター
 *  \param      msg_new     非ゼロ値の場合、メッセージが新規でトピック名とトピック長は有効な値を保持しています。
 *  \param      msg_done    非ゼロ値の場合、メッセージ全体とトピック全体を受信済です。
 *  \return     MQTT_CODE_SUCCESS：接続を継続します。他の値の場合には接続は切られます。MqttPacketResponseCodesを参照のこと）
 */
typedef int (*MqttMsgCb)(struct _MqttClient *client, MqttMessage *message,
    byte msg_new, byte msg_done);

/*! \brief      Mqttパブリッシュコールバック関数。
 *  パブリッシュするペイロードが最大送信バッファ（TX)サイズ以上の場合にはこのコールバック関数が複数回呼び出されます。
    このコールバック関数ではMqttPublishを呼び出した際にその内部から呼び出されます。
    このコールバック関数はバッファーを提供し、そのサイズを成功時の戻り値（0以上）として返却することが求められます。
    コールバック関数の呼び出しの都度、ペーロードがMqttPublish.bufferにコピーされます。
    MqttPublish.buffer_lenはバッファー内のペイロードのサイズを表します。
    MqttPublish.total_lenは完全なペイロードメッセージの長さを表します。
 *  \param      publish     MqttPublish構造体へのポインター
 *  \return     >= 0        成功
 */
typedef int (*MqttPublishCb)(MqttPublish* publish);

/* Client flags */
enum MqttClientFlags {
    MQTT_CLIENT_FLAG_IS_CONNECTED = 0x01,
    MQTT_CLIENT_FLAG_IS_TLS = 0x02,
};

typedef enum _MqttPkStat {
    MQTT_PK_BEGIN,
    MQTT_PK_READ_HEAD,
    MQTT_PK_READ,
} MqttPkStat;

typedef struct _MqttPkRead {
    MqttPkStat stat;
    int header_len;
    int remain_len;
    int buf_len;
} MqttPkRead;

typedef struct _MqttSk {
    int pos;
    int len;
} MqttSk;

#ifdef WOLFMQTT_DISCONNECT_CB
    typedef int (*MqttDisconnectCb)(struct _MqttClient* client, int error_code, void* ctx);
#endif
#ifdef WOLFMQTT_PROPERTY_CB
    typedef int (*MqttPropertyCb)(struct _MqttClient* client, MqttProp* head, void* ctx);
#endif
#ifdef WOLFMQTT_SN
    /*! \brief      Mqtt-SN　レジスターコールバック関数。
     *  ゲートウェイはクライアントに対してトピック名とPUBLISHメッセージ送信時に使用するために割り当てられたトピックid をクライアントに通知する目的でREGISTERメッセージを送信します。
　　　　 このコールバック関数はクライアントにトピックIDを受け入れて保存するか、そのIDが未知の場合には拒否できます。拒否する場合には、regackは”unsupported"
         戻り値を伴います。
     *  \param      topicId     新トピックID
     *  \param      topicName   トピック名へのポインター
     *  \param      reg_ctx     ユーザーコンテキストへのポインター
     *  \return     >= 0        受け入れることを表します
     */
    typedef int (*SN_ClientRegisterCb)(word16 topicId, const char* topicName, void *reg_ctx);
#endif

/* Client structure */
typedef struct _MqttClient {
    word32       flags; /* MqttClientFlags */
    int          cmd_timeout_ms;

    byte        *tx_buf;
    int          tx_buf_len;
    byte        *rx_buf;
    int          rx_buf_len;

    MqttNet     *net;   /* Pointer to network callbacks and context */
#ifdef ENABLE_MQTT_TLS
    MqttTls      tls;   /* WolfSSL context for TLS */
#endif

    MqttPkRead   packet; /* publish packet state - protected by read lock */
    MqttPublishResp packetAck; /* publish ACK - protected by write lock */
    MqttSk       read;   /* read socket state - protected by read lock */
    MqttSk       write;  /* write socket state - protected by write lock */

    MqttMsgCb    msg_cb;
    MqttObject   msg;   /* generic incoming message used by MqttClient_WaitType */
#ifdef WOLFMQTT_SN
    SN_Object    msgSN;
    SN_ClientRegisterCb reg_cb;
    void               *reg_ctx;
#endif
    void*        ctx;   /* user supplied context for publish callbacks */

#ifdef WOLFMQTT_V5
    word32 packet_sz_max; /* Server property */
    byte   max_qos;       /* Server property */
    byte   retain_avail;  /* Server property */
    byte   enable_eauth;  /* Enhanced authentication */
    byte   protocol_level;
#endif

#ifdef WOLFMQTT_DISCONNECT_CB
    MqttDisconnectCb disconnect_cb;
    void            *disconnect_ctx;
#endif
#ifdef WOLFMQTT_PROPERTY_CB
    MqttPropertyCb property_cb;
    void          *property_ctx;
#endif
#ifdef WOLFMQTT_MULTITHREAD
    wm_Sem lockSend;
    wm_Sem lockRecv;
    wm_Sem lockClient;
    struct _MqttPendResp* firstPendResp; /* protected with client lock */
    struct _MqttPendResp* lastPendResp;  /* protected with client lock */
#endif
#if defined(WOLFMQTT_NONBLOCK) && defined(WOLFMQTT_DEBUG_CLIENT)
    int lastRc;
#endif
} MqttClient;


/* Application Interfaces */

/*! \brief      MqttClient構造体を初期化します。
 *  \param      client      MqttClient構造体へのポインター（未初期化で可）
 *  \param      net         コールバック関数とコンテキストへのポインターが格納されたMqttNet構造体へのポインター
 *  \param      msg_cb      メッセージ受信コールバック関数へのポインター
 *  \param      tx_buf      エンコード用送信バッファーへのポインター
 *  \param      tx_buf_len  エンコード用送信バッファーの最大サイズ
 *  \param      rx_buf      デコード用受信バッファーへのポインター
 *  \param      rx_buf_len  デコード用受信バッファーの最大サイズ
 *  \param      cmd_timeout_ms 最大コマンド待ち時間（ミリ秒）
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_BAD_ARG
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Init(
    MqttClient *client,
    MqttNet *net,
    MqttMsgCb msg_cb,
    byte *tx_buf, int tx_buf_len,
    byte *rx_buf, int rx_buf_len,
    int cmd_timeout_ms);

/*! \brief      MqttClient構造体にアロケートされたリソースをクリーンアップします。
 *  \param      client      MqttClient構造体へのポインター
 */
WOLFMQTT_API void MqttClient_DeInit(MqttClient *client);

#ifdef WOLFMQTT_DISCONNECT_CB
/*! \brief      disconnectコールバック関数とユーザーコンテキストをセットします。
 *  \param      client      MqttClient構造体へのポインター（未初期化で可）
 *  \param      discb       disconnectコールバック関数へのポインター
 *  \param      ctx         ユーザーコンテキストへのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_BAD_ARG
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_SetDisconnectCallback(
    MqttClient *client,
    MqttDisconnectCb discb,
    void* ctx);
#endif

#ifdef WOLFMQTT_PROPERTY_CB
/*! \brief      propertyコールバック関数とユーザーコンテキストをセットします。
 *  \param      client      MqttClient構造体へのポインター（未初期化で可）
 *  \param      propCb      propertyコールバック関数へのポインター
 *  \param      ctx         ユーザーコンテキストへのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_BAD_ARG
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_SetPropertyCallback(
    MqttClient *client,
    MqttPropertyCb propCb,
    void* ctx);
#endif

/*! \brief      MQTT Connectパケットをエンコードして送信し、Connect Acknowledgmentパケットを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      connect     connectパラメータを与えられたMqttConnect構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Connect(
    MqttClient *client,
    MqttConnect *connect);

/*! \brief      MQTT Publish パケットをエンコードして送信し、Publish response を待ちます(QoS > 0の場合)。
 *              ペイロードのサイズがバッファーサイズより大きい場合には、ペイロード全体を送信するまでこの関数を連続して複数回呼び出すことができます(QoS > 0の場合)。
 *  \note       この関数はMqttNet.readで待ってブロッキングしますが、ノンブロッキングの場合にはタイムアウトするかMQTT_CODE_CONTINUEを返します。
                QoS levelが1の場合にはPUBLISH_ACKを待ちます。QoS levelが2の場合にはPUBLISH_RECを待ちその後、PUBLISH_RELとを送信し、PUBLISH_COMPを待ちます。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      publish     メッセージデータがセットされたMqttPublish構造体へのポインター
 *                          \n注: MqttPublishとMqttMessageは同じ構造体です。
 *  \return     MQTT_CODE_SUCCESS, MQTT_CODE_CONTINUE (for non-blocking) または 
                MQTT_CODE_ERROR_* 
                \n(enum MqttPacketResponseCodes　を参照)
    \sa         MqttClient_Publish_WriteOnly
    \sa         MqttClient_Publish_ex
 */
WOLFMQTT_API int MqttClient_Publish(
    MqttClient *client,
    MqttPublish *publish);

/*! \brief      MQTT Publishパケットをエンコードして送信し、Publish response を待ちます(QoS > 0の場合)。
                コールバック関数は送信バッファーより大きなサイズのペイロードデータを送信バッファーにコピーすることに使用されます。
 *  \note       この関数はMqttNet.readで待ってブロッキングしますが、ノンブロッキングの場合にはタイムアウトするかMQTT_CODE_CONTINUEを返します。
                QoS levelが1の場合にはPUBLISH_ACKを待ちます。QoS levelが2の場合にはPUBLISH_RECを待ちその後、PUBLISH_RELとを送信し、PUBLISH_COMPを待ちます。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      publish     メッセージデータがセットされたMqttPublish構造体へのポインター。
 *                          注: MqttPublishとMqttMessageは同じ構造体です。
*   \param      pubCb       コールバック関数へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Publish_ex(
    MqttClient *client,
    MqttPublish *publish,
    MqttPublishCb pubCb);


#ifdef WOLFMQTT_MULTITHREAD
/*! \brief      MqttClient_Publish_exと同様の機能ですが,本関数はデータの書き込みだけを行い、他のスレッドでMqttClient_WaitMessage_exを呼び出してread　ACKのハンドリングを行うことを必要としてます。
 *  \note       この関数はMqttNet.readで待ってブロッキングしますが、ノンブロッキングの場合にはタイムアウトするかMQTT_CODE_CONTINUEを返します。
                QoS levelが1の場合にはPUBLISH_ACKを待ちます。QoS levelが2の場合にはPUBLISH_RECを待ちその後、PUBLISH_RELとを送信し、PUBLISH_COMPを待ちます。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      publish     メッセージデータがセットされたMqttPublish構造体へのポインター
 *                          \n注: MqttPublishとMqttMessageは同じ構造体です。
 *  \param      pubCb       コールバック関数へのポインター
 *  \return     MQTT_CODE_SUCCESS, MQTT_CODE_CONTINUE (for non-blocking) または 
                MQTT_CODE_ERROR_* \n(enum MqttPacketResponseCodes　を参照)
    \sa         MqttClient_Publish
    \sa         MqttClient_Publish_ex
    \sa         MqttClient_WaitMessage_ex
 */
WOLFMQTT_API int MqttClient_Publish_WriteOnly(
    MqttClient *client,
    MqttPublish *publish,
    MqttPublishCb pubCb);
#endif

/*! \brief      MQTT Subscribeパケットをエンコードして送信し、Subscribe Acknowledgmentパケットを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      subscribe   トピックリストとQoSを与えられたMqttSubscribe構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Subscribe(
    MqttClient *client,
    MqttSubscribe *subscribe);

/*! \brief      MQTT Unsubscribeパケットをエンコードして送信し、Unsubscribe Acknowledgmentパケットを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      unsubscribe トピックリストを与えられたMqttUnsubscribe構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Unsubscribe(
    MqttClient *client,
    MqttUnsubscribe *unsubscribe);

/*! \brief      MQTT Ping Requestパケットをエンコードして送信し、Ping Responseパケットを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Ping(
    MqttClient *client);

/*! \brief      MQTT Ping Requestパケットをエンコードして送信し、Ping Responseパケットを待ちます。
                このexバージョンでは、MqttPing構造体を引数にとり、ノンブロッキングアプリケーションで使用できます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      ping        MqttPing構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Ping_ex(MqttClient *client, MqttPing* ping);

#ifdef WOLFMQTT_V5
/*! \brief      MQTT Authentication Requestパケットをエンコードして送信し、Ping Responseパケットを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      auth        MqttAuth構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Auth(
    MqttClient *client,
    MqttAuth *auth);


/*! \brief      新しいプロパティを追加します。プロパティ構造体をアロケートし、headで指すリストヘッドに追加します。パケットコマンドに先だって呼び出す必要があります。
 *  \param      head        プロパティ構造体へのポインターのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_BAD_ARG
 */
WOLFMQTT_API MqttProp* MqttClient_PropsAdd(
    MqttProp **head);

/*! \brief      プロパティリストを解放します。
 *  headで指すリストを解放します。MqttClient_Prop_Addを使ったパケットコマンドの使用後に呼び出さなければなりません。
 *  \param      head        プロパティ構造体へのポインターのポインター
 *  \return     MQTT_CODE_SUCCESS または -1 （エラー発生時。errnoにもセットされます）
 */
WOLFMQTT_API int MqttClient_PropsFree(
    MqttProp *head);
#endif


/*! \brief      MQTT Disconnectパケットをエンコードして送信します(responseはありません)。
 *  \note       この関数はMqttNet.writeを使って送信を試みるノンブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Disconnect(
    MqttClient *client);


/*! \brief      MQTT Disconnectパケットをエンコードして送信します(responseはありません)。
 *  \note       この関数はMqttNet.writeを使って送信を試みるノンブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      disconnect  MqttDisconnect構造体へのポインター。NULLを指定しても可。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_Disconnect_ex(
    MqttClient *client,
    MqttDisconnect *disconnect);


/*! \brief      パケット受信を待ちます。受信するpublishメッセージはMqttClient_Initに渡したコールバック関数を介して受信します。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      timeout_ms  受信タイムアウト時間（ミリ秒）
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_WaitMessage(
    MqttClient *client,
    int timeout_ms);

/*! \brief      パケット受信を待ちます。 受信するpublishメッセージはMqttClient_Initに渡したコールバック関数を介して受信します。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      msg         MqttObject構造体へのポインター
 *  \param      timeout_ms  受信タイムアウト時間（ミリ秒）
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_WaitMessage_ex(
    MqttClient *client,
    MqttObject* msg,
    int timeout_ms);

/*! \brief      マルチスレッド環境でノンブロッキングモード時に、msg で指定したMQTTオブジェクトをキャンセルします。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です
 *  \param      client      MqttClient構造体へのポインター
 *  \param      msg         MqttObject構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_CancelMessage(
    MqttClient *client,
    MqttObject* msg);

/*! \brief      TLS接続を実行し、MqttTlsCbコールバック関数を呼び出します(use_tlsが非ゼロの場合）。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      host        ブローカーアドレス
 *  \param      port        ポート番号（オプション）。ゼロが指定された場合はデフォルトのポート番号（8883）を使用。
 *  \param      use_tls     非ゼロの値が指定された場合にはTLS接続を行う。
 *  \param      cb          TLS接続コールバック関数。コールバック関数はSSLコンテキストこコンフィグレーションや証明書チェックの為に呼び出します。
 *  \param      timeout_ms  受信タイムアウト時間（ミリ秒）
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_NetConnect(
    MqttClient *client,
    const char *host,
    word16 port,
    int timeout_ms,
    int use_tls,
    MqttTlsCb cb);

/*! \brief      TLS接続を切断します。
 *  \param      client      MqttClient構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                (enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int MqttClient_NetDisconnect(
    MqttClient *client);

/*! \brief      プロトコルバージョン番号を取得します。
 *  \param      client      MqttClient構造体へのポインター
 *  \return     4 (v3.1.1) or 5 (v5)
 */
WOLFMQTT_API int MqttClient_GetProtocolVersion(MqttClient *client);

/*! \brief      プロトコルバージョン文字列を取得します。
 *  \param      client      MqttClient構造体へのポインター
 *  \return     String v3.1.1 or v5
 */
WOLFMQTT_API const char* MqttClient_GetProtocolVersionString(MqttClient *client);

#ifndef WOLFMQTT_NO_ERROR_STRINGS
/*! \brief      WOLFMQTT_APIからの戻り値を文字列に変換します。
 *  \param      return_code WOLFMQTT_APIからの戻り値
 *  \return     String 戻り値の文字列表現
 */
WOLFMQTT_API const char* MqttClient_ReturnCodeToString(
    int return_code);
#else
    #define MqttClient_ReturnCodeToString(x) \
                                        "not compiled in"
#endif /* WOLFMQTT_NO_ERROR_STRINGS */

#ifdef WOLFMQTT_SN
/*! \brief      ゲートウェイを検索するメッセージをエンコードして送信し、ゲートウェイ情報応答メッセージを待ちます。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      search      hop radiusが与えられたSN_SearchGW構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_SearchGW(
        MqttClient *client,
        SN_SearchGw *search);

/*! \brief      Connect パケットをエンコードして送信し、Connect Acknowledgeパケットを待ちます。
                もし、Will（遺言）がイネーブルとなっている場合には、ゲートウェイはLWTトピックとメッセージを送信するように別パケットで促してきます。
                空のwillトピックを指定するとwillトピックとwillメッセージをサーバーから削除するものとみなします。
                the Will message stored in the server.
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      connect     接続パラメータが与えられたSN_Connect構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Connect(
    MqttClient *client,
    SN_Connect *connect);

/*! \brief      MQTT-SN Will Topic Updateパケットをエンコードして送信します。
                will引数としてNULLを渡すと、Willトピックとサーバーに保持されているWillメッセージを削除することを意味します。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      will        トピックとメッセージパラメータが与えられたSN_Will構造体へのポインター。NULL指定も可。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_WillTopicUpdate(MqttClient *client, SN_Will *will);

/*! \brief      MQTT-SN Will Message Update パケットをエンコードして送信します。
 *  \note       この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      will        トピックとメッセージパラメータが与えられたSN_Will構造体へのポインター。NULL指定でも可。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_WillMsgUpdate(MqttClient *client, SN_Will *will);

/*! \brief      MQTT-SN Register パケットをエンコードして送信し、Register Acknowledgeパケットを待ちます。
                クライアントがゲートウェイに送信するRegisterパケットは、含まれているトピック名に対してトピックIDを割り当てるように要求する目的で送信されます。
                また、ゲートウェイからクライアントに送信されるRegisterパケットはトピック名に対してトピックIDが割り当てられたことを通知する目的で送信されます。
 *  \note この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      regist      SN_Register構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_* 
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Register(
    MqttClient *client,
    SN_Register *regist);


/*! \brief      カスタム（ユーザー）コンテキストと共にレジスターコールバック関数をセットします。
 *  \param      client      MqttClient構造体へのポインター（未初期化で可）
 *  \param      regCb       レジスターコールバック関数へのポインター
 *  \param      ctx         ユーザーコンテキストへのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_BAD_ARG
 */
WOLFMQTT_API int SN_Client_SetRegisterCallback(
    MqttClient *client,
    SN_ClientRegisterCb regCb,
    void* ctx);


/*! \brief      MQTT-SN Publishパケットをエンコードして送信しPublish responseを待ちます (QoS > 0の場合)。
 *  \note　　　　この関数はMqttNet.readで待つブロッキング関数です。
              　QoS levelが1の場合にはPUBLISH_ACKを待ちます。
              　QoS levelが2の場合にはPUBLISH_RECを待ちその後、PUBLISH_RELを送信し、PUBLISH_COMPを待ちます。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      publish     メッセージデータを与えられたSN_Publish構造体へのポインター。
 *                          注: SN_PublishとMqttMessageは同じ構造体です。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Publish(
    MqttClient *client,
    SN_Publish *publish);

/*! \brief      MQTT-SN Subscribeパケットをエンコードして送信し、割り当てられたトピックIDを含むSubscribe Acknowledgmentパケットを待ちます。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      subscribe   トピックリストとQoSレベルを与えられたSN_Subscribe構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Subscribe(
    MqttClient *client,
    SN_Subscribe *subscribe);

/*! \brief      MQTT-SN Unsubscribeパケットをエンコードして送信し、Unsubscribe Acknowledgmentパケットを待ちます。
 *  \note 　　　 この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      unsubscribe トピックIDが与えられたSN_Unsubscribe構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Unsubscribe(
    MqttClient *client,
    SN_Unsubscribe *unsubscribe);

/*! \brief      MQTT-SN Disconnectパケットをエンコードして送信します。 その際に、クライアントはスリープ状態に入るまでの時間を送信できます。
 *  \note 　　　この関数はMqttNet.writeを呼び出して待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Disconnect(
    MqttClient *client);

/*! \brief      MQTT-SN Disconnectパケットをエンコードして送信します。その際に、クライアントはスリープ状態に入るまでの時間を送信できます。
 *  \note 　　　この関数はMqttNet.writeを呼び出して待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      disconnect  SN_Disconnect構造体へのポインター。 NULL指定も可。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Disconnect_ex(
    MqttClient *client,
    SN_Disconnect *disconnect);


/*! \brief      MQTT-SN Ping Requestパケットをエンコードして送信し、Ping Responseパケットを待ちます。
                クライアントがスリープ状態の場合でゲートウェイに起床状態に遷移したことを通知したい場合にはクライアントIDをping requestに追加する必要があります。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      ping        SN_PingReq構造体へのポインター。NULL指定も可。
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_Ping(
    MqttClient *client,
    SN_PingReq *ping);

/*! \brief      パケット受信を待ちます。受信したPublishメッセーはMqttClient_Initで与えられたコールバック関数を介して通知されます。
 *  \note 　　　この関数はMqttNet.readで待つブロッキング関数です。
 *  \param      client      MqttClient構造体へのポインター
 *  \param      timeout_ms  ミリ秒の受信タイムアウト時間
 *  \return     MQTT_CODE_SUCCESS または MQTT_CODE_ERROR_*
                \n(enum MqttPacketResponseCodes　を参照)
 */
WOLFMQTT_API int SN_Client_WaitMessage(
    MqttClient *client,
    int timeout_ms);

WOLFMQTT_API int SN_Client_WaitMessage_ex(MqttClient *client, SN_Object* packet_obj,
    int timeout_ms);

#endif /* WOLFMQTT_SN */

#ifdef __cplusplus
    } /* extern "C" */
#endif

#endif /* WOLFMQTT_CLIENT_H */
