# FreeRTOS/lwIPアプリケーション用のwolfSentryの構築と初期化

FreeRTOSでlwIPとnewlib-nanoを使用するwolfSentryライブラリの構築は、トップレベルの`Makefile`によって直接サポートされています。
例えば、ARM Cortex M7の場合、`libwolfsentry.a`は以下のようにビルドできます。

```sh
make HOST=arm-none-eabi EXTRA_CFLAGS='-mcpu=cortex-m7' RUNTIME=FreeRTOS-lwIP FREERTOS_TOP="$FREERTOS_TOP" LWIP_TOP="$LWIP_TOP"
```

`FREERTOS_TOP`は、その直下に`FreeRTOS/Source`があるFreeRTOSディストリビューションのトップへのパスです。
同様に`LWIP_TOP`は、その直下に`src`があるlwIPディストリビューションのトップへのパスです。

以下のコードフラグメントをFreeRTOSアプリケーションに追加して、動的にロードされるポリシー（JSON）でwolfSentryを有効化できます。
実証されているコードパターンの多くはオプションです。
必要不可欠な呼び出しは`wolfsentry_init()`、`wolfsentry_config_json_oneshot()`、`wolfsentry_install_lwip_filter_callbacks()`のみです。
これらにはそれぞれ、ユーザーにより多くの制御を与えるAPIバリアントもあります。

```c
#define WOLFSENTRY_SOURCE_ID WOLFSENTRY_SOURCE_ID_USER_BASE
#define WOLFSENTRY_ERROR_ID_USER_APP_ERR0 (WOLFSENTRY_ERROR_ID_USER_BASE-1)
 /* ユーザー定義エラーIDは WOLFSENTRY_ERROR_ID_USER_BASE（負の値）から開始してカウントダウンする */

#include <wolfsentry/wolfsentry_json.h>
#include <wolfsentry/wolfsentry_lwip.h>

static struct wolfsentry_context *wolfsentry_lwip_ctx = NULL;

static const struct wolfsentry_eventconfig demo_config = {
#ifdef WOLFSENTRY_HAVE_DESIGNATED_INITIALIZERS
        .route_private_data_size = 64,
        .route_private_data_alignment = 0,         /* デフォルトアライメント -- sizeof(void *) と同じ */
        .max_connection_count = 10,                /* デフォルトでは、同じルートにマッチする
                                                    * 同時接続を10以下に制限する
                                                    */
        .derogatory_threshold_for_penaltybox = 4,  /* 同じルートにマッチする軽蔑的イベントが4回発生したら、
                                                    * そのルートをペナルティボックス状態に移行する
                                                    */
        .penaltybox_duration = 300,                /* ルートをペナルティボックス状態で5分間保持する
                                                    * wolfsentry_init() に渡すときは秒単位で指定
                                                    */
        .route_idle_time_for_purge = 0,            /* 0で無効化 -- 自動パージは通常
                                                    * デフォルト設定としてはあまり意味がない
                                                    */
        .flags = WOLFSENTRY_EVENTCONFIG_FLAG_COMMENDABLE_CLEARS_DEROGATORY, /* 称賛すべきイベントが
                                                    * ルートにマッチしたときに、そのルートの
                                                    * 軽蔑的カウントを自動的にクリアする
                                                    */
        .route_flags_to_add_on_insert = 0,
        .route_flags_to_clear_on_insert = 0,
        .action_res_filter_bits_set = 0,
        .action_res_filter_bits_unset = 0,
        .action_res_bits_to_add = 0,
        .action_res_bits_to_clear = 0
#else
        64,
        0,
        10,
        4,
        300,
        0,
        WOLFSENTRY_EVENTCONFIG_FLAG_COMMENDABLE_CLEARS_DEROGATORY,
        0,
        0,
        0,
        0,
        0,
        0
#endif
    };

/* このルーチンは、lwIPへの直接呼び出しの前に、つまり
 * lwip_init() や tcpip_init() の前に、アプリケーションによって一度呼び出される必要がある
 */
wolfsentry_errcode_t activate_wolfsentry_lwip(const char *json_config, int json_config_len)
{
    wolfsentry_errcode_t ret;
    char err_buf[512]; /* wolfsentry_config_json_oneshot() からの
                        * 詳細なエラーメッセージ用バッファ
                        */

    /* スタック上にスレッド状態構造体を割り当てる。
     * 最後のセミコロンはマクロ定義によって提供されるため、
     * シングルスレッドアプリケーションビルドでは何も展開されない
     */
    WOLFSENTRY_THREAD_HEADER_DECLS

    if (wolfsentry_lwip_ctx != NULL) {
        printf("activate_wolfsentry_lwip() called multiple times.\n");
        WOLFSENTRY_ERROR_RETURN(ALREADY);
    }

#ifdef WOLFSENTRY_ERROR_STRINGS
    /* WOLFSENTRY_ERROR_FMT/WOLFSENTRY_ERROR_FMT_ARGS() 用の
     * アプリソースコードファイル名のプリティプリントを有効化
     */
    ret = WOLFSENTRY_REGISTER_SOURCE();
    WOLFSENTRY_RERETURN_IF_ERROR(ret);

    /* アプリ固有のエラーコードのプリティプリントを有効化 */
    ret = WOLFSENTRY_REGISTER_ERROR(USER_APP_ERR0, "failure in application code");
    WOLFSENTRY_RERETURN_IF_ERROR(ret);
#endif

    /* スレッド状態構造体を初期化 -- これによりスレッドIDが設定される */
    WOLFSENTRY_THREAD_HEADER_INIT_CHECKED(WOLFSENTRY_THREAD_FLAG_NONE);

    /* メインのwolfSentry初期化ルーチンを呼び出す
     *
     * WOLFSENTRY_CONTEXT_ARGS_OUT() は、それを必要とするAPIに
     * スレッド構造体ポインタを条件付きで渡すことを抽象化するマクロ。
     * これがシングルスレッドビルド（!defined(WOLFSENTRY_THREADSAFE)）の場合、
     * スレッド引数は完全に省略される。
     *
     * WOLFSENTRY_CONTEXT_ARGS_OUT_EX() は、"wolfsentry" が渡すべき
     * 正しい引数でない場合に、呼び出し元が最初の引数を明示的に指定できる変種。
     * ここでは、ホストプラットフォームインターフェース（"hpi"）用にnullポインタを
     * 渡すために使用される。
     */
    ret = wolfsentry_init(
        wolfsentry_build_settings,
        WOLFSENTRY_CONTEXT_ARGS_OUT_EX(NULL /* hpi */),
        &demo_config,
        &wolfsentry_lwip_ctx);
    if (ret < 0) {
        printf("wolfsentry_init() failed: " WOLFSENTRY_ERROR_FMT "\n",
               WOLFSENTRY_ERROR_FMT_ARGS(ret));
        goto out;
    }

    /* ユーザー定義アクションがあれば、ここに挿入する */
    ret = wolfsentry_action_insert(
        WOLFSENTRY_CONTEXT_ARGS_OUT_EX(wolfsentry_lwip_ctx),
        "my-action",
        WOLFSENTRY_LENGTH_NULL_TERMINATED,
        WOLFSENTRY_ACTION_FLAG_NONE,
        my_action_handler,
        NULL,
        NULL);
    if (ret < 0) {
        printf("wolfsentry_action_insert() failed: " WOLFSENTRY_ERROR_FMT "\n",
               WOLFSENTRY_ERROR_FMT_ARGS(ret));
        goto out;
    }

    if (json_config) {
        if (json_config_len < 0)
            json_config_len = (int)strlen(json_config);

        /* ポリシーの初期読み込みを実行 */
        ret = wolfsentry_config_json_oneshot(
            WOLFSENTRY_CONTEXT_ARGS_OUT_EX(wolfsentry_lwip_ctx),
            (unsigned char *)json_config,
            (size_t)json_config_len,
            WOLFSENTRY_CONFIG_LOAD_FLAG_NONE,
            err_buf,
            sizeof err_buf);
        if (ret < 0) {
            printf("wolfsentry_config_json_oneshot() failed: %s\n", err_buf);
            goto out;
        }
    } /* そうでなければ、アプリケーションがプログラム的にポリシーを設定するか、
       * 自身で wolfsentry_config_json_oneshot() または関連APIを呼び出す必要がある。
       */

    /* lwIPコールバックをインストール。この呼び出しが成功を返すと、
     * 以下に示すマスク引数によってフィルタリング対象として指定された
     * すべてのlwIPトラフィックが、上記で読み込まれたポリシーに従って
     * フィルタリング（またはその他の補完的処理）の対象となる。
     *
     * 特定のプロトコルがLWIPから除外されている場合、そのマスク引数は
     * ここで0として渡さなければならない。そうしないと、
     * IMPLEMENTATION_MISSING エラーが発生する。
     *
     * コールバックのインストールでは、wolfsentry_shutdown() によって
     * 自動的に呼び出されるクリーンアップルーチンも登録される。
     */

#define LWIP_ALL_EVENTS (                       \
        (1U << FILT_BINDING) |                  \
        (1U << FILT_DISSOCIATE) |               \
        (1U << FILT_LISTENING) |                \
        (1U << FILT_STOP_LISTENING) |           \
        (1U << FILT_CONNECTING) |               \
        (1U << FILT_ACCEPTING) |                \
        (1U << FILT_CLOSED) |                   \
        (1U << FILT_REMOTE_RESET) |             \
        (1U << FILT_RECEIVING) |                \
        (1U << FILT_SENDING) |                  \
        (1U << FILT_ADDR_UNREACHABLE) |         \
        (1U << FILT_PORT_UNREACHABLE) |         \
        (1U << FILT_INBOUND_ERR) |              \
        (1U << FILT_OUTBOUND_ERR))

    ret = wolfsentry_install_lwip_filter_callbacks(
        WOLFSENTRY_CONTEXT_ARGS_OUT_EX(wolfsentry_lwip_ctx),

#if LWIP_ARP || LWIP_ETHERNET
        LWIP_ALL_EVENTS, /* ethernet_mask */
#else
        0,
#endif
#if LWIP_IPV4 || LWIP_IPV6
        LWIP_ALL_EVENTS, /* ip_mask */
#else
        0,
#endif
#if LWIP_ICMP || LWIP_ICMP6
        LWIP_ALL_EVENTS, /* icmp_mask */
#else
        0,
#endif
#if LWIP_TCP
        LWIP_ALL_EVENTS, /* tcp_mask */
#else
        0,
#endif
#if LWIP_UDP
        LWIP_ALL_EVENTS /* udp_mask */
#else
        0
#endif
        );
    if (ret < 0) {
        printf("wolfsentry_install_lwip_filter_callbacks: "
               WOLFSENTRY_ERROR_FMT "\n", WOLFSENTRY_ERROR_FMT_ARGS(ret));
    }

out:
    if (ret < 0) {
        /* 初期化が失敗した場合のクリーンアップ */
        wolfsentry_errcode_t shutdown_ret =
            wolfsentry_shutdown(WOLFSENTRY_CONTEXT_ARGS_OUT_EX(&wolfsentry_lwip_ctx));
        if (shutdown_ret < 0)
            printf("wolfsentry_shutdown: "
                   WOLFSENTRY_ERROR_FMT "\n", WOLFSENTRY_ERROR_FMT_ARGS(shutdown_ret));
    }

    WOLFSENTRY_THREAD_TAILER_CHECKED(WOLFSENTRY_THREAD_FLAG_NONE);

    WOLFSENTRY_ERROR_RERETURN(ret);
}

/* lwIPへの最終呼び出し後に、アプリケーションによって一度呼び出される */
wolfsentry_errcode_t shutdown_wolfsentry_lwip(void)
{
    wolfsentry_errcode_t ret;
    if (wolfsentry_lwip_ctx == NULL) {
        printf("shutdown_wolfsentry_lwip() called before successful activation.\n");
        return -1;
    }

    /* シャットダウン成功後、wolfsentry_lwip_ctx は初期化前と同様に再びnullポインタになる
     */
    ret = wolfsentry_shutdown(WOLFSENTRY_CONTEXT_ARGS_OUT_EX4(&wolfsentry_lwip_ctx, NULL));
    if (ret < 0) {
        printf("wolfsentry_shutdown: "
               WOLFSENTRY_ERROR_FMT "\n", WOLFSENTRY_ERROR_FMT_ARGS(ret));
    }

    return ret;
}
```
