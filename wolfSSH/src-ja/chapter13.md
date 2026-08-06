#  API リファレンス

このセクションでは、wolfSSH ライブラリの公開アプリケーションプログラムインターフェイスについて説明します。

##  エラーコード



###  WS_ErrorCodes (enum)



以下の API 応答コードは wolfssh/error.h で定義されており、発生し得るさまざまな種類のエラーを表す。`WS_SUCCESS` は 0 であり、すべてのエラーコードは負の値である。`WS_FATAL_ERROR` は `WS_ERROR` の非推奨エイリアスであり、`WS_LAST_E` は常に最後に定義されたエラーコードを指す。

- WS_SUCCESS (0): 関数成功
- WS_ERROR (-1001): 一般的な関数失敗
- WS_FATAL_ERROR (-1001): WS_ERROR の非推奨エイリアス
- WS_BAD_ARGUMENT (-1002): 不正な関数引数
- WS_MEMORY_E (-1003): メモリ割り当て失敗
- WS_BUFFER_E (-1004): 入出力バッファサイズエラー
- WS_PARSE_E (-1005): 一般的な解析エラー
- WS_NOT_COMPILED (-1006): 機能がコンパイルに含まれていない
- WS_OVERFLOW_E (-1007): 続行するとオーバーフローする
- WS_BAD_USAGE (-1008): 不正な使用例
- WS_SOCKET_ERROR_E (-1009): ソケットエラー
- WS_WANT_READ (-1010): ノンブロッキング読み込みがブロックする、再度呼び出すこと
- WS_WANT_WRITE (-1011): ノンブロッキング書き込みがブロックする、再度呼び出すこと
- WS_RECV_OVERFLOW_E (-1012): 受信バッファオーバーフロー
- WS_VERSION_E (-1013): ピアが誤ったバージョンの SSH を使用している
- WS_SEND_OOB_READ_E (-1014): バッファの範囲外読み込みを試みた
- WS_INPUT_CASE_E (-1015): 不正な処理入力状態、プログラミングエラー
- WS_BAD_FILETYPE_E (-1016): 不正なファイルタイプ
- WS_UNIMPLEMENTED_E (-1017): 機能が実装されていない
- WS_RSA_E (-1018): RSA バッファエラー
- WS_BAD_FILE_E (-1019): 不正なファイル
- WS_INVALID_ALGO_ID (-1020): 無効なアルゴリズム ID
- WS_DECRYPT_E (-1021): 復号エラー
- WS_ENCRYPT_E (-1022): 暗号化エラー
- WS_VERIFY_MAC_E (-1023): MAC 検証エラー
- WS_CREATE_MAC_E (-1024): MAC 生成エラー
- WS_RESOURCE_E (-1025): 新しいチャネルのためのリソース不足
- WS_INVALID_CHANTYPE (-1026): 無効なチャネルタイプ
- WS_INVALID_CHANID (-1027): ピアが無効なチャネル ID を要求した
- WS_INVALID_USERNAME (-1028): 無効なユーザー名
- WS_CRYPTO_FAILED (-1029): 暗号処理が失敗した
- WS_INVALID_STATE_E (-1030): 無効な状態
- WS_EOF (-1031): ファイルの終端
- WS_INVALID_PRIME_CURVE (-1032): ECC における無効な素数曲線
- WS_ECC_E (-1033): ECDSA バッファエラー
- WS_CHANOPEN_FAILED (-1034): ピアがチャネルオープン失敗を返した
- WS_REKEYING (-1035): ステータス: 再鍵交換が進行中
- WS_CHANNEL_CLOSED (-1036): ステータス: チャネルがクローズされた
- WS_INVALID_PATH_E (-1037): 無効なパス
- WS_SCP_CMD_E (-1038): SCP コマンドエラー
- WS_SCP_BAD_MSG_E (-1039): SCP 不正メッセージ
- WS_SCP_PATH_LEN_E (-1040): SCP パスが長すぎる
- WS_SCP_TIMESTAMP_E (-1041): SCP タイムスタンプエラー
- WS_SCP_DIR_STACK_EMPTY_E (-1042): SCP ディレクトリスタックが空
- WS_SCP_CONTINUE (-1043): ステータス: SCP 継続
- WS_SCP_ABORT (-1044): ステータス: SCP 中断
- WS_SCP_ENTER_DIR (-1045): ステータス: SCP ディレクトリに入る
- WS_SCP_EXIT_DIR (-1046): ステータス: SCP ディレクトリから出る
- WS_SCP_EXIT_DIR_FINAL (-1047): ステータス: SCP 最終ディレクトリから出る
- WS_SCP_COMPLETE (-1048): ステータス: SCP 転送完了
- WS_SCP_INIT (-1049): ステータス: SCP 転送が検証された
- WS_MATCH_KEX_ALGO_E (-1050): ピアと KEX アルゴリズムが一致しない
- WS_MATCH_KEY_ALGO_E (-1051): ピアと鍵アルゴリズムが一致しない
- WS_MATCH_ENC_ALGO_E (-1052): ピアと暗号化アルゴリズムが一致しない
- WS_MATCH_MAC_ALGO_E (-1053): ピアと MAC アルゴリズムが一致しない
- WS_PERMISSIONS (-1054): 権限エラー
- WS_SFTP_COMPLETE (-1055): ステータス: SFTP 接続確立
- WS_NEXT_ERROR (-1056): 次の値/状態の取得がエラー
- WS_CHAN_RXD (-1057): ステータス: チャネルデータを受信した
- WS_INVALID_EXTDATA (-1058): 無効なチャネル拡張データタイプ
- WS_SFTP_BAD_REQ_ID (-1060): SFTP 不正リクエスト ID
- WS_SFTP_BAD_REQ_TYPE (-1061): SFTP 不正リクエストタイプ
- WS_SFTP_STATUS_NOT_OK (-1062): SFTP ステータスが OK ではない
- WS_SFTP_FILE_DNE (-1063): SFTP ファイルが存在しない
- WS_SIZE_ONLY (-1064): 必要なバッファのサイズのみ取得している
- WS_CLOSE_FILE_E (-1065): ローカルファイルをクローズできない
- WS_PUBKEY_REJECTED_E (-1066): サーバーの公開鍵が拒否された
- WS_EXTDATA (-1067): 読み取り可能な拡張データがある
- WS_USER_AUTH_E (-1068): ユーザー認証エラー
- WS_SSH_NULL_E (-1069): SSH オブジェクトが NULL だった
- WS_SSH_CTX_NULL_E (-1070): SSH_CTX オブジェクトが NULL だった
- WS_CHANNEL_NOT_CONF (-1071): チャネルオープンが確認されていない
- WS_CHANGE_AUTH_E (-1072): 認証タイプの変更が試みられた
- WS_WINDOW_FULL (-1073): チャネルウィンドウが満杯
- WS_MISSING_CALLBACK (-1074): コールバックが不足している
- WS_DH_SIZE_E (-1075): DH 素数が想定より大きい
- WS_PUBKEY_SIG_MIN_E (-1076): 署名が小さすぎる
- WS_AGENT_NULL_E (-1077): エージェントオブジェクトが NULL だった
- WS_AGENT_NO_KEY_E (-1078): エージェントが要求された鍵を保持していない
- WS_AGENT_CXN_FAIL (-1079): エージェントに接続できなかった
- WS_SFTP_BAD_HEADER (-1080): SFTP 不正ヘッダー
- WS_CERT_NO_SIGNER_E (-1081): 署名者証明書が利用できない
- WS_CERT_EXPIRED_E (-1082): 証明書が期限切れ
- WS_CERT_REVOKED_E (-1083): ユーザー証明書が失効していると報告された
- WS_CERT_SIG_CONFIRM_E (-1084): ルート証明書の署名検証失敗
- WS_CERT_OTHER_E (-1085): その他の証明書に関する問題
- WS_CERT_PROFILE_E (-1086): 証明書がプロファイル要件を満たしていない
- WS_CERT_KEY_SIZE_E (-1087): 鍵サイズエラー
- WS_CTX_KEY_COUNT_E (-1088): 秘密鍵の追加が多すぎる
- WS_MATCH_UA_KEY_ID_E (-1089): ユーザー認証鍵の照合失敗
- WS_KEY_AUTH_MAGIC_E (-1090): OpenSSH 鍵の認証マジックチェック失敗
- WS_KEY_CHECK_VAL_E (-1091): OpenSSH 鍵のチェック値失敗
- WS_KEY_FORMAT_E (-1092): OpenSSH 鍵形式失敗
- WS_SFTP_NOT_FILE_E (-1093): 通常のファイルではない
- WS_MSGID_NOT_ALLOWED_E (-1094): ユーザー認証前は許可されないメッセージ
- WS_ED25519_E (-1095): Ed25519 失敗
- WS_AUTH_PENDING (-1096): ユーザー認証がまだ保留中
- WS_KDF_E (-1097): KDF エラー
- WS_DISCONNECT (-1098): ピアが切断を送信した

###  WS_IOerrors (enum)



これらは、ユーザー提供の I/O コールバックからライブラリが受け取ることを想定している戻りコードである。それ以外の場合、ライブラリは I/O 動作によって読み書きされたバイト数を期待する。

- WS_CBIO_ERR_GENERAL (-1): 一般的な予期しないエラー 
- WS_CBIO_ERR_WANT_READ (-2): ソケットの読み込みがブロックする、再度呼び出すこと 
- WS_CBIO_ERR_WANT_WRITE (-2): ソケットの書き込みがブロックする、再度呼び出すこと 
- WS_CBIO_ERR_CONN_RST (-3): 接続がリセットされた
- WS_CBIO_ERR_ISR (-4): 割り込み
- WS_CBIO_ERR_CONN_CLOSE (-5): 接続がクローズされた、または EPIPE
- WS_CBIO_ERR_TIMEOUT (-6): ソケットタイムアウト

##  初期化 / シャットダウン



### wolfSSH_Init()

```c
#include <wolfssh/ssh.h>

int wolfSSH_Init(void);
```

**説明**

使用に先立って wolfSSH ライブラリを初期化する。ライブラリへの他のいかなる呼び出しよりも前に、アプリケーションごとに一度だけ呼び出す必要がある。

**引数**

なし

**戻り値**

- `WS_SUCCESS`
- `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_Cleanup()`

### wolfSSH_Cleanup()

```c
#include <wolfssh/ssh.h>

int wolfSSH_Cleanup(void);
```

**説明**

使用を終えた際に wolfSSH ライブラリをクリーンアップする。アプリケーションの終了前に呼び出すべきである。呼び出した後は、それ以上ライブラリを呼び出してはならない。

**引数**

なし

**戻り値**

- `WS_SUCCESS`
- `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_Init()`

##  デバッグ出力関数



### wolfSSH_Debugging_ON()

```c
#include <wolfssh/ssh.h>

void wolfSSH_Debugging_ON(void);
```

**説明**

実行時のデバッグログ出力を有効にする。ビルド時にデバッグが無効化されている場合は何も行わない。

**引数**

なし

**戻り値**

なし

**関連項目**

- `wolfSSH_Debugging_OFF()`

### wolfSSH_Debugging_OFF()

```c
#include <wolfssh/ssh.h>

void wolfSSH_Debugging_OFF(void);
```

**説明**

実行時のデバッグログ出力を無効にする。ビルド時にデバッグが無効化されている場合は何も行わない。

**引数**

なし

**戻り値**

なし

**関連項目**

- `wolfSSH_Debugging_ON()`

##  コンテキスト関数



### wolfSSH_CTX_new()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CTX* wolfSSH_CTX_new(byte side, void* heap);
```

**説明**

wolfSSH コンテキストオブジェクトを作成する。このオブジェクトは設定した上で、wolfSSH セッションオブジェクトのファクトリとして使用できる。

**引数**

- `side` - エンドポイントの役割: `WOLFSSH_ENDPOINT_SERVER` または `WOLFSSH_ENDPOINT_CLIENT`
- `heap` - メモリ割り当てに使用するヒープへのポインター、または `NULL`

**戻り値**

- `WOLFSSH_CTX*` - 新しく割り当てられたコンテキストオブジェクトへのポインター
- `NULL` - 失敗時

**関連項目**

- `wolfSSH_CTX_free()`

### wolfSSH_CTX_free()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_free(WOLFSSH_CTX* ctx);
```

**説明**

wolfSSH コンテキストオブジェクトを解放する。

**引数**

- `ctx` - 解放する wolfSSH コンテキスト

**戻り値**

なし

**関連項目**

- `wolfSSH_CTX_new()`

### wolfSSH_CTX_SetBanner()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetBanner(WOLFSSH_CTX* ctx, const char* newBanner);
```

**説明**

認証前にピアへ提示されるバナーメッセージを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `newBanner` - バナーメッセージのテキスト

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_CTX_UsePrivateKey_buffer()`

### wolfSSH_CTX_UsePrivateKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UsePrivateKey_buffer(WOLFSSH_CTX* ctx,
        const byte* in, word32 inSz, int format);
```

**説明**

ファイルではなくバッファから秘密鍵を SSH コンテキストに読み込む。鍵は `in` 引数によって渡され、サイズは `inSz` である。`format` 引数はバッファのエンコーディングを指定する: `WOLFSSH_FORMAT_ASN1` または `WOLFSSH_FORMAT_PEM`（PEM は現時点では未実装）。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `in` - 読み込む秘密鍵を含むバッファ
- `inSz` - 入力バッファのサイズ
- `format` - 入力バッファ内の秘密鍵の形式

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_BAD_FILETYPE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_MEMORY_E`
- `WS_RSA_E`
- `WS_BAD_FILE_E`

**関連項目**

- `wolfSSH_CTX_UseCert_buffer()`

### wolfSSH_CTX_UseCert_buffer()

**利用可能性**

`WOLFSSH_CERTS` が必要。

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UseCert_buffer(WOLFSSH_CTX* ctx,
        const byte* cert, word32 certSz, int format);
```

**説明**

証明書ベースのホスト認証のために、サーバーの X.509 証明書をバッファからコンテキストに読み込む。`format` は `WOLFSSH_FORMAT_ASN1` または `WOLFSSH_FORMAT_PEM` である。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cert` - 証明書を含むバッファ
- `certSz` - 証明書バッファのサイズ
- `format` - 証明書のエンコーディング

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**関連項目**

- `wolfSSH_CTX_AddRootCert_buffer()`

### wolfSSH_CTX_AddRootCert_buffer()

**利用可能性**

`WOLFSSH_CERTS` が必要。

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_AddRootCert_buffer(WOLFSSH_CTX* ctx,
        const byte* cert, word32 certSz, int format);
```

**説明**

ピアから提示された証明書を検証するために使用する、信頼されたルート CA 証明書をコンテキストに追加する。`format` は `WOLFSSH_FORMAT_ASN1` または `WOLFSSH_FORMAT_PEM` である。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cert` - ルート証明書を含むバッファ
- `certSz` - 証明書バッファのサイズ
- `format` - 証明書のエンコーディング

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**関連項目**

- `wolfSSH_CTX_UseCert_buffer()`

##  SSH セッション関数



### wolfSSH_new()

```c
#include <wolfssh/ssh.h>

WOLFSSH* wolfSSH_new(WOLFSSH_CTX* ctx);
```

**説明**

提供された wolfSSH コンテキストで初期化された wolfSSH セッションオブジェクトを作成する。

**引数**

- `ctx` - セッションの初期化に使用する wolfSSH コンテキスト

**戻り値**

- `WOLFSSH*` - 新しく割り当てられたセッションオブジェクトへのポインター
- `NULL` - 失敗時

**関連項目**

- `wolfSSH_free()`

### wolfSSH_free()

```c
#include <wolfssh/ssh.h>

void wolfSSH_free(WOLFSSH* ssh);
```

**説明**

wolfSSH セッションオブジェクトを解放する。

**引数**

- `ssh` - 解放するセッション

**戻り値**

なし

**関連項目**

- `wolfSSH_new()`

### wolfSSH_worker()

```c
#include <wolfssh/ssh.h>

int wolfSSH_worker(WOLFSSH* ssh, word32* channelId);
```

**説明**

SSH 接続を処理する。保留中の受信データを受け取り、保留中の送信パケットをフラッシュする。これは実行中のセッションに対する主要なドライバー呼び出しである。成功時、`channelId` が NULL でなければ、最も直近にデータを受信したチャネルの ID がそこに書き込まれる。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channelId` - 最後にデータを受信したチャネル ID の出力先（任意、NULL でもよい）

**戻り値**

- `WS_SUCCESS`
- `WS_CHAN_RXD`
- `WS_REKEYING`
- `WS_WANT_READ`
- `WS_WANT_WRITE`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_GetLastRxId()`

### wolfSSH_GetLastRxId()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetLastRxId(WOLFSSH* ssh, word32* channelId);
```

**説明**

最も直近にデータを受信したチャネルの ID を `channelId` に書き込む。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channelId` - 最後に受信したチャネル ID の出力先

**戻り値**

- `WS_SUCCESS`
- `WS_ERROR`

**関連項目**

- `wolfSSH_worker()`

### wolfSSH_set_fd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_set_fd(WOLFSSH* ssh, WS_SOCKET_T fd);
```

**説明**

指定されたファイルディスクリプタをセッションに割り当てる。セッションは、デフォルトの I/O コールバックにおいて、このディスクリプタをネットワーク I/O に使用する。

**引数**

- `ssh` - ディスクリプタを設定するセッション
- `fd` - セッションが使用するソケットのファイルディスクリプタ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_get_fd()`

### wolfSSH_get_fd()

```c
#include <wolfssh/ssh.h>

WS_SOCKET_T wolfSSH_get_fd(const WOLFSSH* ssh);
```

**説明**

SSH 接続の入出力に使用されているファイルディスクリプタを返す。通常はソケットのファイルディスクリプタである。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 成功時はセッションのソケットファイルディスクリプタ
- `ssh` が NULL の場合は `WS_BAD_ARGUMENT`（Windows では `INVALID_SOCKET`）

**関連項目**

- `wolfSSH_set_fd()`

### wolfSSH_SetFilesystemHandle()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetFilesystemHandle(WOLFSSH* ssh, void* handle);
```

**説明**

ユーザーが提供するファイルシステムハンドルをセッションに関連付ける。独自のファイルシステム層を提供する移植環境では、セッションに対するファイル操作を行う際にこのハンドルを使用する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `handle` - セッションに関連付ける不透明なファイルシステムハンドル

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_GetFilesystemHandle()`

### wolfSSH_GetFilesystemHandle()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetFilesystemHandle(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetFilesystemHandle() によって以前にセッションへ関連付けられたファイルシステムハンドルを返す。設定されていない場合は NULL を返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- セッションに関連付けられたファイルシステムハンドル
- `NULL` - `ssh` が NULL の場合、またはハンドルが設定されていない場合

**関連項目**

- `wolfSSH_SetFilesystemHandle()`

##  データ最高水位関数



### wolfSSH_SetHighwater()


```c
#include <wolfssh/ssh.h>

int wolfSSH_SetHighwater(WOLFSSH* ssh, word32 level);
```

**説明**

セッションのデータハイウォーターマークをバイト単位で設定する。転送されたデータ量がこのレベルに達すると、ハイウォーターコールバックが呼び出される（通常はリキーをトリガーするため）。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `level` - ハイウォーターマーク（バイト単位）

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_GetHighwater()`

### wolfSSH_GetHighwater()


```c
#include <wolfssh/ssh.h>

word32 wolfSSH_GetHighwater(WOLFSSH* ssh);
```

**説明**

セッションの現在のデータハイウォーターマークをバイト単位で返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- データハイウォーターマーク（バイト単位）

**関連項目**

- `wolfSSH_SetHighwater()`

### wolfSSH_SetHighwaterCb()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetHighwaterCb(WOLFSSH_CTX* ctx, word32 level,
        WS_CallbackHighwater cb);
```

**説明**

コンテキストレベルで、デフォルトのデータハイウォーターマークと、セッションがそれに到達したときに呼び出されるコールバックを設定する。このコンテキストから作成されたセッションは、これらのデフォルト値を継承する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `level` - デフォルトのデータハイウォーターマーク（バイト単位）
- `cb` - ハイウォーターコールバック関数

**戻り値**

なし

**関連項目**

- `wolfSSH_SetHighwaterCtx()`

### wolfSSH_SetHighwaterCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetHighwaterCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

セッションのハイウォーターコールバックが呼び出される際に渡される、ユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - ハイウォーターコールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetHighwaterCtx()`

### wolfSSH_GetHighwaterCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetHighwaterCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetHighwaterCtx() によって以前に設定された、ハイウォーターコールバックに渡されるユーザーコンテキストポインターを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- ハイウォーターのユーザーコンテキストポインター
- `NULL` - `ssh` が無効な場合、またはコンテキストが設定されていない場合

**関連項目**

- `wolfSSH_SetHighwaterCtx()`

### wolfSSH_CTX_SetMsgHighwater()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_SetMsgHighwater(WOLFSSH_CTX* ctx, word32 level);
```

**説明**

コンテキストレベルで、デフォルトのパケット数ハイウォーターマーク（RFC 4344, Section 3.1）を設定する。セッションで送受信されたパケット数がこのレベルに達すると、リキーがトリガーされる。このコンテキストから作成されたセッションは、このデフォルト値を継承する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `level` - パケット数ハイウォーターマーク

**戻り値**

なし

**関連項目**

- `wolfSSH_SetMsgHighwater()`

### wolfSSH_SetMsgHighwater()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetMsgHighwater(WOLFSSH* ssh, word32 level);
```

**説明**

単一のセッションに対して、パケット数ハイウォーターマーク（RFC 4344, Section 3.1）を設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `level` - パケット数ハイウォーターマーク

**戻り値**

なし

**関連項目**

- `wolfSSH_GetMsgHighwater()`

### wolfSSH_GetMsgHighwater()

```c
#include <wolfssh/ssh.h>

word32 wolfSSH_GetMsgHighwater(WOLFSSH* ssh);
```

**説明**

セッションの現在のパケット数ハイウォーターマークを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- パケット数ハイウォーターマーク

**関連項目**

- `wolfSSH_SetMsgHighwater()`

##  エラーチェック



### wolfSSH_get_error()



```c
#include <wolfssh/ssh.h>

int wolfSSH_get_error(const WOLFSSH* ssh);
```

**説明**

wolfSSH セッションオブジェクトに設定された最後のエラーを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_ErrorCodes` の値（エラーコードを参照）

**関連項目**

- `wolfSSH_get_error_name()`

### wolfSSH_get_error_name()



```c
#include <wolfssh/ssh.h>

const char* wolfSSH_get_error_name(const WOLFSSH* ssh);
```

**説明**

wolfSSH セッションオブジェクトに設定された最後のエラーの名前文字列を返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- エラー名文字列へのポインター

**関連項目**

- `wolfSSH_get_error()`

### wolfSSH_ErrorToName()


```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ErrorToName(int err);
```

**説明**

指定した wolfSSH エラーコードの名前文字列を返します。

**引数**

- `err` - エラーコードの値（`WS_ErrorCodes` の値）

**戻り値**

- エラー名文字列へのポインター

**関連項目**

- `wolfSSH_get_error_name()`

##  I/O コールバック



### wolfSSH_SetIORecv()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIORecv(WOLFSSH_CTX* ctx, WS_CallbackIORecv cb);
```

**説明**

wolfSSH が入力データを読み取る際に使用する受信コールバックを登録します。コールバックのシグネチャは `WS_CallbackIORecv` 型で示されます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - コンテキストの受信コールバックとして登録する関数

**戻り値**

なし

**関連項目**

- `wolfSSH_SetIOSend()`

### wolfSSH_SetIOSend()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOSend(WOLFSSH_CTX* ctx, WS_CallbackIOSend cb);
```

**説明**

wolfSSH が出力データを書き込む際に使用する送信コールバックを登録します。コールバックのシグネチャは `WS_CallbackIOSend` 型で示されます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - コンテキストの送信コールバックとして登録する関数

**戻り値**

なし

**関連項目**

- `wolfSSH_SetIORecv()`

### wolfSSH_SetIOReadCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOReadCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

セッションの受信（I/O 読み取り）コールバックに渡されるコンテキストを登録します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - セッションの受信コールバックに登録するコンテキスト

**戻り値**

なし

**関連項目**

- `wolfSSH_GetIOReadCtx()`

### wolfSSH_SetIOWriteCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOWriteCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

セッションの送信（I/O 書き込み）コールバックに渡されるコンテキストを登録します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - セッションの送信コールバックに登録するコンテキスト

**戻り値**

なし

**関連項目**

- `wolfSSH_GetIOWriteCtx()`

### wolfSSH_GetIOReadCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetIOReadCtx(WOLFSSH* ssh);
```

**説明**

セッションの受信（I/O 読み取り）コールバックに以前登録されたコンテキストを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 登録された読み取りコンテキストへのポインター。登録されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetIOReadCtx()`

### wolfSSH_GetIOWriteCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetIOWriteCtx(WOLFSSH* ssh);
```

**説明**

セッションの送信（I/O 書き込み）コールバックに以前登録されたコンテキストを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 登録された書き込みコンテキストへのポインター。登録されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetIOWriteCtx()`

##  ユーザー認証



### wolfSSH_SetUserAuth()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx, WS_CallbackUserAuth cb);
```

**説明**

wolfSSH コンテキストにユーザー認証コールバックを登録します。このコールバックはハンドシェイク中にピアを認証するために呼び出されます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - ユーザー認証コールバック関数

**戻り値**

なし

**関連項目**

- `wolfSSH_SetUserAuthCtx()`

### wolfSSH_SetUserAuthCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh, void* userAuthCtx);
```

**説明**

ユーザー認証コールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `userAuthCtx` - 認証コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetUserAuthCtx()`

### wolfSSH_GetUserAuthCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetUserAuthCtx() によって以前設定されたユーザーコンテキストポインターを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- ユーザー認証コンテキストポインター
- `NULL` - `ssh` が NULL の場合

**関連項目**

- `wolfSSH_SetUserAuthCtx()`

### wolfSSH_SetUserAuthTypes()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthTypes(WOLFSSH_CTX* ctx, WS_CallbackUserAuthTypes cb);
```

**説明**

サーバーが提供するユーザー認証タイプを報告するコールバックを登録します。このコールバックは `WOLFSSH_USERAUTH_*` の値（例えば `WOLFSSH_USERAUTH_PASSWORD` や `WOLFSSH_USERAUTH_PUBLICKEY`）のビットマスクを返します。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - ユーザー認証タイプコールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetUserAuth()`

### wolfSSH_SetUserAuthResult()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthResult(WOLFSSH_CTX* ctx, WS_CallbackUserAuthResult cb);
```

**説明**

ユーザー認証試行の結果とともに呼び出されるコールバックを登録します。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - ユーザー認証結果コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetUserAuthResultCtx()`

### wolfSSH_SetUserAuthResultCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthResultCtx(WOLFSSH* ssh, void* userAuthResultCtx);
```

**説明**

ユーザー認証結果コールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `userAuthResultCtx` - 結果コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetUserAuthResultCtx()`

### wolfSSH_GetUserAuthResultCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetUserAuthResultCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetUserAuthResultCtx() によって以前設定されたユーザーコンテキストポインターを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- ユーザー認証結果コンテキストポインター
- `NULL` - `ssh` が NULL の場合

**関連項目**

- `wolfSSH_SetUserAuthResultCtx()`

### wolfSSH_CTX_SetPublicKeyCheck()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_SetPublicKeyCheck(WOLFSSH_CTX* ctx,
        WS_CallbackPublicKeyCheck cb);
```

**説明**

クライアント側で、ハンドシェイクを続行する前にサーバーの公開鍵（ホスト鍵）を確認するために使用されるコールバックを登録します。アプリケーションはこのコールバックから鍵を受け入れるか拒否するかを判断できます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - 公開鍵確認コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetPublicKeyCheckCtx()`

### wolfSSH_SetPublicKeyCheckCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetPublicKeyCheckCtx(WOLFSSH* ssh, void* publicKeyCheckCtx);
```

**説明**

公開鍵確認コールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `publicKeyCheckCtx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetPublicKeyCheckCtx()`

### wolfSSH_GetPublicKeyCheckCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetPublicKeyCheckCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetPublicKeyCheckCtx() によって以前設定されたユーザーコンテキストポインターを返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 公開鍵確認コンテキストポインター
- `NULL` - `ssh` が NULL の場合

**関連項目**

- `wolfSSH_SetPublicKeyCheckCtx()`

##  ユーザー名の設定



### wolfSSH_SetUsername()


```c
#include <wolfssh/ssh.h>

int wolfSSH_SetUsername(WOLFSSH* ssh, const char* username);
```

**説明**

SSH 接続に使用するユーザー名を NULL 終端の文字列として設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `username` - SSH 接続に使用するユーザー名

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**関連項目**

- `wolfSSH_GetUsername()`

### wolfSSH_SetUsernameRaw()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetUsernameRaw(WOLFSSH* ssh, const byte* username,
        word32 usernameSz);
```

**説明**

SSH 接続に使用するユーザー名を、NULL 終端の文字列ではなくバッファと長さから設定します。ユーザー名が NULL 終端でない場合や任意のバイト列を含む場合に有用です。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `username` - ユーザー名を含むバッファ
- `usernameSz` - ユーザー名バッファの長さ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**関連項目**

- `wolfSSH_SetUsername()`

### wolfSSH_GetUsername()

```c
#include <wolfssh/ssh.h>

char* wolfSSH_GetUsername(WOLFSSH* ssh);
```

**説明**

セッションに関連付けられたユーザー名を返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- セッションのユーザー名文字列へのポインター
- `NULL` - `ssh` が NULL の場合、またはユーザー名が設定されていない場合

**関連項目**

- `wolfSSH_SetUsername()`

##  接続関数

### wolfSSH_accept()



```c
#include <wolfssh/ssh.h>

int wolfSSH_accept(WOLFSSH* ssh);
```

**説明**

サーバー側で呼び出す。SSH クライアントが SSH ハンドシェイクを開始するのを待ち、それを完了させる。

wolfSSH_accept() はブロッキング I/O・ノンブロッキング I/O のいずれとも併用できる。基盤となる I/O がノンブロッキングの場合、wolfSSH_accept() はハンドシェイクをまだ満たせない時点で戻り、続けて wolfSSH_get_error() を呼び出すと `WS_WANT_READ` または `WS_WANT_WRITE` が得られる。呼び出し側はデータが利用可能になった時点で再度呼び出すことで、wolfSSH は中断した箇所から処理を再開する。

基盤となる I/O がブロッキングの場合、wolfSSH_accept() はハンドシェイクが完了するかエラーが発生するまで戻らない。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_connect()`
- `wolfSSH_stream_read()`

### wolfSSH_connect()


```c
#include <wolfssh/ssh.h>

int wolfSSH_connect(WOLFSSH* ssh);
```

**説明**

クライアント側で呼び出す。サーバーとの SSH ハンドシェイクを開始する。この呼び出しの前に、基盤となる通信チャネルがセットアップ済みである必要がある。

wolfSSH_connect() はブロッキング I/O・ノンブロッキング I/O のいずれとも併用できる。基盤となる I/O がノンブロッキングの場合、wolfSSH_connect() はハンドシェイクをまだ満たせない時点で戻り、続けて wolfSSH_get_error() を呼び出すと `WS_WANT_READ` または `WS_WANT_WRITE` が得られる。呼び出し側は I/O が準備できた時点で再度呼び出すことで、wolfSSH は中断した箇所から処理を再開する。

基盤となる I/O がブロッキングの場合、wolfSSH_connect() はハンドシェイクが完了するかエラーが発生するまで戻らない。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_accept()`

### wolfSSH_shutdown()


```c
#include <wolfssh/ssh.h>

int wolfSSH_shutdown(WOLFSSH* ssh);
```

**説明**

SSH セッションを閉じて切断し、ピアに切断メッセージを送信する。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_connect()`
- `wolfSSH_accept()`

### wolfSSH_stream_read()



```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_read(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**説明**

内部の復号化済みデータストリームバッファから最大 `bufSz` バイトを読み取る。読み取られたバイトは内部バッファから取り除かれる。

wolfSSH_stream_read() はブロッキング I/O・ノンブロッキング I/O のいずれとも併用できる。基盤となる I/O がノンブロッキングで読み取りを満たせない場合、wolfSSH_get_error() を呼び出すと `WS_WANT_READ` または `WS_WANT_WRITE` が得られ、呼び出し側はデータが利用可能になった時点で再度呼び出す。基盤となる I/O がブロッキングの場合、データが利用可能になるかエラーが発生するまで戻らない。リキー（`WS_REKEYING`）が進行中の場合は、wolfSSH_worker() を呼び出してそれを完了させる。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `buf` - データを格納するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 より大きい値 - 成功時に読み取ったバイト数
- 0 - 接続がシャットダウンされた
- `WS_BAD_ARGUMENT`
- `WS_EOF`
- `WS_FATAL_ERROR`
- `WS_REKEYING`

**関連項目**

- `wolfSSH_stream_send()`
- `wolfSSH_accept()`


### wolfSSH_stream_send()



```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_send(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**説明**

`buf` から `bufSz` バイトを SSH ストリームデータバッファに書き込む。

wolfSSH_stream_send() はブロッキング I/O・ノンブロッキング I/O のいずれとも併用できる。基盤となる I/O がノンブロッキングで保留中のデータすべてを送信できない場合、wolfSSH_get_error() を呼び出すと `WS_WANT_READ` または `WS_WANT_WRITE` が得られ、呼び出し側はソケットが送信可能になった時点で再度呼び出す。基盤となる I/O がブロッキングの場合、データの送信が完了するかエラーが発生するまで戻らない。エラーが want-read/want-write でない場合（例えば `WS_REKEYING`）は、内部の SSH 処理が完了するまで wolfSSH_worker() を呼び出す。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `buf` - 送信するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 より大きい値 - 成功時に書き込んだバイト数
- 0 - 接続がシャットダウンされた
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`
- `WS_REKEYING`

**関連項目**

- `wolfSSH_stream_read()`
- `wolfSSH_accept()`


### wolfSSH_stream_exit()


```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_exit(WOLFSSH* ssh, int status);
```

**説明**

SSH ストリームを終了し、指定した終了ステータスをピアに送信してチャネルを閉じる。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `status` - ピアに報告する終了ステータス

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_stream_send()`

### wolfSSH_TriggerKeyExchange()


```c
#include <wolfssh/ssh.h>

int wolfSSH_TriggerKeyExchange(WOLFSSH* ssh);
```

**説明**

初期ハンドシェイクパケットを準備・送信することで、鍵交換（リキー）プロセスを開始する。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_worker()`

### wolfSSH_stream_peek()

```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_peek(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**説明**

内部バッファから取り除くことなく、保留中の復号化済みストリームデータを最大 `bufSz` バイトまで `buf` にコピーする。その後 wolfSSH_stream_read() を呼び出すと同じデータが返される。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `buf` - 覗き見したデータを格納するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 以上の値 - コピーされたバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_stream_read()`

### wolfSSH_extended_data_send()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_send(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**説明**

`bufSz` バイトを拡張チャネルデータ（通常は stderr データ型）として送信する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `buf` - 送信するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 より大きい値 - 成功時に送信したバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_extended_data_read()`

### wolfSSH_extended_data_read()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_read(WOLFSSH* ssh, byte* out, word32 outSz);
```

**説明**

受信した拡張チャネルデータ（通常は stderr）を最大 `outSz` バイトまで `out` に読み取る。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `out` - データを格納するバッファ
- `outSz` - バッファのサイズ

**戻り値**

- 0 以上の値 - 読み取ったバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_extended_data_send()`

### wolfSSH_SendIgnore()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendIgnore(WOLFSSH* ssh, const byte* buf, word32 bufSz);
```

**説明**

指定したペイロードを含む SSH_MSG_IGNORE メッセージを送信する。ピアはその内容を破棄する。キープアライブやトラフィック解析対策として使用できる。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `buf` - メッセージに含めるペイロード
- `bufSz` - ペイロードのサイズ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_SendDisconnect()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendDisconnect(WOLFSSH* ssh, word32 reason);
```

**説明**

指定した理由コード（`WS_DisconnectReasonCodes` の値を参照）を伴う SSH_MSG_DISCONNECT メッセージをピアに送信する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `reason` - 切断理由コード

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_shutdown()`

### wolfSSH_global_request()

```c
#include <wolfssh/ssh.h>

int wolfSSH_global_request(WOLFSSH* ssh, const unsigned char* data,
        word32 dataSz, int reply);
```

**説明**

指定したデータを含むグローバルリクエストをピアに送信する。`reply` が非ゼロの場合、ピアに成功または失敗の応答を要求する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `data` - リクエストのペイロード
- `dataSz` - ペイロードのサイズ
- `reply` - ピアからの応答を要求する場合は非ゼロ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

### wolfSSH_ChannelIdRead()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdRead(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**説明**

`channelId` で識別されるチャネルから受信したデータを最大 `bufSz` バイトまで読み取る。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channelId` - 読み取り対象のチャネル
- `buf` - データを格納するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 以上の値 - 読み取ったバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_ChannelIdSend()`

### wolfSSH_ChannelIdSend()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdSend(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**説明**

`channelId` で識別されるチャネル上で `bufSz` バイトを送信する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channelId` - 送信対象のチャネル
- `buf` - 送信するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 より大きい値 - 成功時に送信したバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_ChannelIdRead()`

### wolfSSH_CTX_SetSshProtoIdStr()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetSshProtoIdStr(WOLFSSH_CTX* ctx, const char* protoIdStr);
```

**説明**

接続開始時のバージョン交換でピアに送信される SSH プロトコル識別文字列を上書きする。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `protoIdStr` - 送信するプロトコル識別文字列

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_CTX_SetWindowPacketSize()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetWindowPacketSize(WOLFSSH_CTX* ctx,
        word32 windowSz, word32 maxPacketSz);
```

**説明**

このコンテキストから作成されるセッションに対する、デフォルトのチャネルウィンドウサイズと最大パケットサイズを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `windowSz` - チャネルウィンドウサイズ（バイト単位）
- `maxPacketSz` - 最大パケットサイズ（バイト単位）

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

## チャネルコールバック

wolfSSH ライブラリへのインターフェースは単一の int 値を返す。ピアがチャネルを開くといった非同期な情報の状態を伝えるには、このインターフェースでは不十分である。wolfSSH は、チャネルの状態変化を呼び出し元アプリケーションに通知するためにコールバック関数を使用する。

以下の SSHv2 プロトコルメッセージの受信に対応するコールバック関数が存在する。

* SSH_MSG_CHANNEL_OPEN
* SSH_MSG_CHANNEL_OPEN_CONFIRMATION
* SSH_MSG_CHANNEL_OPEN_FAILURE
* SSH_MSG_CHANNEL_REQUEST
  - "shell"
  - "subsystem"
  - "exec"
* SSH_MSG_CHANNEL_EOF
* SSH_MSG_CHANNEL_CLOSE

### コールバック関数のプロトタイプ

チャネルコールバック関数はいずれも、**WOLFSSH_CHANNEL** オブジェクトへのポインター _channel_ と、アプリケーションが定義したデータ構造へのポインター _ctx_ を引数に取る。チャネルに関するプロパティは API 関数を使って取得できる。

```
typedef int (*WS_CallbackChannelOpen)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelReq)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelEof)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelClose)(WOLFSSH_CHANNEL* channel, void* ctx);
```

### wolfSSH_CTX_SetChannelOpenCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelOpenCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen cb);
```

**説明**

ピアからチャネルオープン（SSH_MSG_CHANNEL_OPEN）メッセージを受信した際に呼び出されるコールバックを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネルオープンコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_SetChannelOpenCtx()`


### wolfSSH_CTX_SetChannelOpenRespCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelOpenRespCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen confCb, WS_CallbackChannelOpen failCb);
```

**説明**

ピアからチャネルオープン確認（SSH_MSG_CHANNEL_OPEN_CONFIRMATION）またはチャネルオープン失敗（SSH_MSG_CHANNEL_OPEN_FAILURE）メッセージを受信した際に呼び出されるコールバックを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `confCb` - チャネルオープン確認のコールバック
- `failCb` - チャネルオープン失敗のコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelOpenCb()`


### wolfSSH_CTX_SetChannelReqShellCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqShellCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**説明**

ピアから _shell_ に対するチャネルリクエスト（SSH_MSG_CHANNEL_REQUEST）メッセージを受信した際に呼び出されるコールバックを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネルリクエストコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelReqExecCb()`


### wolfSSH_CTX_SetChannelReqSubsysCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqSubsysCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**説明**

ピアから _subsystem_ に対するチャネルリクエスト（SSH_MSG_CHANNEL_REQUEST）メッセージを受信した際に呼び出されるコールバックを設定する。サブシステムの一般的な例としては SFTP がある。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネルリクエストコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelReqShellCb()`


### wolfSSH_CTX_SetChannelReqExecCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqExecCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**説明**

ピアから _exec_ するコマンドに対するチャネルリクエスト（SSH_MSG_CHANNEL_REQUEST）メッセージを受信した際に呼び出されるコールバックを設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネルリクエストコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelReqShellCb()`


### wolfSSH_CTX_SetChannelEofCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelEofCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelEof cb);
```

**説明**

ピアからチャネル EOF（SSH_MSG_CHANNEL_EOF）メッセージを受信した際に呼び出されるコールバックを設定する。これはピアがこのチャネル上でこれ以上データを送信しないことを示す。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネル EOF コールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelCloseCb()`


### wolfSSH_CTX_SetChannelCloseCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelCloseCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelClose cb);
```

**説明**

ピアからチャネルクローズ（SSH_MSG_CHANNEL_CLOSE）メッセージを受信した際に呼び出されるコールバックを設定する。これはピアがこのチャネルを終了させたいことを示す。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - チャネルクローズコールバック

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**関連項目**

- `wolfSSH_CTX_SetChannelEofCb()`


### wolfSSH_SetChannelOpenCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelOpenCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

チャネルオープン、チャネルオープン確認、およびチャネルオープン失敗の各コールバックに渡されるユーザーコンテキストを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - チャネルオープンコールバックに渡すユーザーコンテキスト

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**関連項目**

- `wolfSSH_GetChannelOpenCtx()`


### wolfSSH_SetChannelReqCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelReqCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

チャネルリクエスト（shell/exec/subsystem）コールバックに渡されるユーザーコンテキストを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - チャネルリクエストコールバックに渡すユーザーコンテキスト

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**関連項目**

- `wolfSSH_GetChannelReqCtx()`


### wolfSSH_SetChannelEofCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelEofCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

チャネル EOF コールバックに渡されるユーザーコンテキストを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - チャネル EOF コールバックに渡すユーザーコンテキスト

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**関連項目**

- `wolfSSH_GetChannelEofCtx()`


### wolfSSH_SetChannelCloseCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelCloseCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

チャネルクローズコールバックに渡されるユーザーコンテキストを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - チャネルクローズコールバックに渡すユーザーコンテキスト

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**関連項目**

- `wolfSSH_GetChannelCloseCtx()`


### wolfSSH_GetChannelOpenCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelOpenCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetChannelOpenCtx() によって以前に設定された、チャネルオープンコールバック用のユーザーコンテキストを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- チャネルオープンコンテキストへのポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetChannelOpenCtx()`


### wolfSSH_GetChannelReqCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelReqCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetChannelReqCtx() によって以前に設定された、チャネルリクエストコールバック用のユーザーコンテキストを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- チャネルリクエストコンテキストへのポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetChannelReqCtx()`


### wolfSSH_GetChannelEofCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelEofCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetChannelEofCtx() によって以前に設定された、チャネル EOF コールバック用のユーザーコンテキストを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- チャネル EOF コンテキストへのポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetChannelEofCtx()`


### wolfSSH_GetChannelCloseCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelCloseCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetChannelCloseCtx() によって以前に設定された、チャネルクローズコールバック用のユーザーコンテキストを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- チャネルクローズコンテキストへのポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetChannelCloseCtx()`


## チャネル関数

これらの関数は、SSH セッション上で多重化される個々のチャネルを表す `WOLFSSH_CHANNEL` オブジェクトに対して直接操作を行う。

### wolfSSH_ChannelGetSessionType()

```c
#include <wolfssh/ssh.h>

WS_SessionType wolfSSH_ChannelGetSessionType(const WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネルの `WS_SessionType`（shell、exec、subsystem、terminal、または unknown）を返す。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- チャネルの `WS_SessionType`

**関連項目**

- `wolfSSH_ChannelGetSessionCommand()`


### wolfSSH_ChannelGetSessionCommand()

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ChannelGetSessionCommand(const WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネル上でピアが実行を要求したコマンド（"exec" リクエストの場合）を返す。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- コマンド文字列へのポインター。存在しない場合は `NULL`

**関連項目**

- `wolfSSH_ChannelGetSessionType()`

### wolfSSH_ChannelFree()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelFree(WOLFSSH_CHANNEL* channel);
```

**説明**

チャネルオブジェクトを解放し、そのセッションから削除する。

**引数**

- `channel` - 解放するチャネルへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetId()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetId(WOLFSSH_CHANNEL* channel, word32* id, byte peer);
```

**説明**

指定したチャネルの数値チャネル ID を取得する。`peer` に `WS_CHANNEL_ID_SELF` を指定すると自分側の ID、`WS_CHANNEL_ID_PEER` を指定するとピア側の ID が取得される。

**引数**

- `channel` - チャネルへのポインター
- `id` - チャネル ID の出力先
- `peer` - `WS_CHANNEL_ID_SELF` または `WS_CHANNEL_ID_PEER`

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_ChannelFind()`

### wolfSSH_ChannelFind()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFind(WOLFSSH* ssh, word32 id, byte peer);
```

**説明**

指定した ID に一致するセッション上のチャネルを検索する。`peer` に `WS_CHANNEL_ID_SELF` を指定すると自分側の ID に、`WS_CHANNEL_ID_PEER` を指定するとピア側の ID に一致するものが検索される。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `id` - 検索するチャネル ID
- `peer` - `WS_CHANNEL_ID_SELF` または `WS_CHANNEL_ID_PEER`

**戻り値**

- 一致したチャネルへのポインター。見つからない場合は `NULL`

**関連項目**

- `wolfSSH_ChannelNext()`

### wolfSSH_ChannelNext()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelNext(WOLFSSH* ssh, WOLFSSH_CHANNEL* channel);
```

**説明**

セッション上のチャネルを反復処理する。`channel` に `NULL` を渡すと最初のチャネルが取得され、あるチャネルを渡すとその次のチャネルが取得される。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channel` - 現在のチャネル。反復を開始する場合は `NULL`

**戻り値**

- 次のチャネルへのポインター。リストの末尾に達した場合は `NULL`

**関連項目**

- `wolfSSH_ChannelFind()`

### wolfSSH_ChannelRead()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelRead(WOLFSSH_CHANNEL* channel, byte* buf, word32 bufSz);
```

**説明**

指定したチャネルから受信済みデータを最大 `bufSz` バイト読み込む。

**引数**

- `channel` - チャネルへのポインター
- `buf` - データを格納するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 以上 - 読み込まれたバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_ChannelSend()`

### wolfSSH_ChannelSend()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSend(WOLFSSH_CHANNEL* channel, const byte* buf,
        word32 bufSz);
```

**説明**

指定したチャネル上で `bufSz` バイトを送信する。

**引数**

- `channel` - チャネルへのポインター
- `buf` - 送信するバッファ
- `bufSz` - バッファのサイズ

**戻り値**

- 0 より大きい値 - 成功時に送信されたバイト数
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_ChannelRead()`

### wolfSSH_ChannelExit()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelExit(WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネルを閉じ、EOF メッセージとクローズメッセージをピアへ送信する。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetEof()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetEof(WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネル上でピアが EOF を送信済みかどうかを報告する。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- 1 - チャネルが EOF を受信済み
- 0 - チャネルが EOF を受信していない

### wolfSSH_ChannelGetType()

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ChannelGetType(const WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネルのチャネルタイプ文字列（例: "session"）を返す。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- チャネルタイプ文字列へのポインター。存在しない場合は `NULL`

### wolfSSH_ChannelIsPty()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIsPty(const WOLFSSH_CHANNEL* channel);
```

**説明**

指定したチャネルに疑似端末（PTY）が関連付けられているかどうかを報告する。

**引数**

- `channel` - チャネルへのポインター

**戻り値**

- 1 - チャネルに PTY がある
- 0 - チャネルに PTY がない


##  テスト関数


### wolfSSH_GetStats()


```c
#include <wolfssh/ssh.h>

void wolfSSH_GetStats(WOLFSSH* ssh, word32* txCount, word32* rxCount,
        word32* seq, word32* peerSeq);
```

**説明**

セッションの転送統計情報を、指定した出力先ポインターに書き込む。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `txCount` - セッションで送信された総バイト数の出力先
- `rxCount` - セッションで受信された総バイト数の出力先
- `seq` - 送信パケットのシーケンス番号の出力先
- `peerSeq` - ピアのパケットシーケンス番号の出力先

**戻り値**

なし

### wolfSSH_KDF()


```c
#include <wolfssh/ssh.h>

int wolfSSH_KDF(byte hashId, byte keyId, byte* key, word32 keySz,
        const byte* k, word32 kSz, const byte* h, word32 hSz,
        const byte* sessionId, word32 sessionIdSz);
```

**説明**

SSH 鍵導出関数を実行する。この関数は、鍵材料の元となる `k`（ディフィー・ヘルマン共有秘密）と `h`（鍵交換時に生成される交換ハッシュ）から対称鍵を導出する。生成される鍵の種類は `keyId` によって選択される。この関数は主に、テストスイートが鍵導出に対して既知の解答によるテストを実行できるように公開されている。

`keyId` の値は以下の通り。

```
A - initial IV, client to server
B - initial IV, server to client
C - encryption key, client to server
D - encryption key, server to client
E - integrity key, client to server
F - integrity key, server to client
```

**引数**

- `hashId` - 鍵材料の導出に使用するハッシュタイプ（例: `WC_HASH_TYPE_SHA` や `WC_HASH_TYPE_SHA256`）
- `keyId` - どの鍵を導出するか（上記の A〜F）
- `key` - 導出された鍵の出力バッファ
- `keySz` - 出力鍵バッファのサイズ
- `k` - ディフィー・ヘルマン共有秘密
- `kSz` - `k` のサイズ
- `h` - 交換ハッシュ
- `hSz` - `h` のサイズ
- `sessionId` - セッション識別子
- `sessionIdSz` - セッション識別子のサイズ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_CRYPTO_FAILED`

### wolfSSH_ShowSizes()

```c
#include <wolfssh/ssh.h>

void wolfSSH_ShowSizes(void);
```

**説明**

wolfSSH の内部データ構造体のサイズを表示する。これは診断用の補助機能であり、リソースに制約のあるターゲットでのメモリ使用量の調整に役立つ。

**引数**

なし

**戻り値**

なし


##  セッション関数



### wolfSSH_GetSessionType()


```c
#include <wolfssh/ssh.h>

WS_SessionType wolfSSH_GetSessionType(const WOLFSSH* ssh);
```

**説明**

セッションのチャネルにおけるセッションタイプを返す。`WOLFSSH_SESSION_UNKNOWN`、`WOLFSSH_SESSION_SHELL`、`WOLFSSH_SESSION_EXEC`、`WOLFSSH_SESSION_SUBSYSTEM`、`WOLFSSH_SESSION_TERMINAL` のいずれか。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- セッションの `WS_SessionType`

**関連項目**

- `wolfSSH_GetSessionCommand()`

### wolfSSH_GetSessionCommand()


```c
#include <wolfssh/ssh.h>

const char* wolfSSH_GetSessionCommand(const WOLFSSH* ssh);
```

**説明**

このセッションについてピアが実行を要求したコマンド（"exec" リクエストの場合）を返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- コマンド文字列へのポインター、存在しない場合は `NULL`

**関連項目**

- `wolfSSH_GetSessionType()`

### wolfSSH_SetChannelType()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelType(WOLFSSH* ssh, byte type, byte* name,
        word32 nameSz);
```

**説明**

セッションのチャネルに対して、チャネルリクエストタイプ（shell、exec、subsystem など）と、それに関連付ける任意の名前を設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `type` - チャネルリクエストタイプ
- `name` - タイプに関連付ける任意の名前（例えば subsystem 名）
- `nameSz` - `name` の長さ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChangeTerminalSize()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChangeTerminalSize(WOLFSSH* ssh, word32 columns,
        word32 rows, word32 widthPixels, word32 heightPixels);
```

**説明**

ターミナル（ウィンドウ）サイズが変更されたことをピアに通知し、新しい寸法を送信する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `columns` - 新しい幅（文字カラム数）
- `rows` - 新しい高さ（文字行数）
- `widthPixels` - 新しい幅（ピクセル数）
- `heightPixels` - 新しい高さ（ピクセル数）

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_SetTerminalResizeCb()`

### wolfSSH_SetTerminalResizeCb()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTerminalResizeCb(WOLFSSH* ssh, WS_CallbackTerminalSize cb);
```

**説明**

ピアがターミナルサイズの変更を報告した際に呼び出されるコールバックを登録する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `cb` - ターミナルリサイズコールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetTerminalResizeCtx()`

### wolfSSH_SetTerminalResizeCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTerminalResizeCtx(WOLFSSH* ssh, void* usrCtx);
```

**説明**

ターミナルリサイズコールバックに渡すユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `usrCtx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

### wolfSSH_GetExitStatus()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetExitStatus(WOLFSSH* ssh);
```

**説明**

セッションのコマンドについてピアが報告した終了ステータスを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- ピアが報告した終了ステータス

**関連項目**

- `wolfSSH_SetExitStatus()`

### wolfSSH_SetExitStatus()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetExitStatus(WOLFSSH* ssh, word32 exitStatus);
```

**説明**

セッションのコマンドについてピアに報告する終了ステータスを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `exitStatus` - 報告する終了ステータス

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_GetExitStatus()`

### wolfSSH_DoModes()

```c
#include <wolfssh/ssh.h>

int wolfSSH_DoModes(const byte* modes, word32 modesSz, int fd);
```

**説明**

`modes` に含まれる SSH エンコード済みのターミナルモードを、ファイルディスクリプタ `fd` が参照するターミナルに適用する。

**引数**

- `modes` - SSH エンコード済みターミナルモードのバッファ
- `modesSz` - modes バッファの長さ
- `fd` - 設定対象ターミナルのファイルディスクリプタ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ConvertConsole()

**利用可能性**

Windows ビルド（`USE_WINDOWS_API`）でのみ利用可能。

```c
#include <wolfssh/ssh.h>

int wolfSSH_ConvertConsole(WOLFSSH* ssh, WOLFSSH_HANDLE handle,
        byte* buf, word32 bufSz);
```

**説明**

Windows コンソールハンドルから読み取ったコンソールデータを処理し、SSH ストリーム用に変換する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `handle` - Windows コンソールハンドル
- `buf` - 変換対象のコンソールデータバッファ
- `bufSz` - バッファの長さ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_SetKeyingCompletionCb()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetKeyingCompletionCb(WOLFSSH_CTX* ctx,
        WS_CallbackKeyingCompletion cb);
```

**説明**

鍵交換（初回またはリキー）が完了した際に呼び出されるコールバックを登録する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - キーイング完了コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetKeyingCompletionCbCtx()`

### wolfSSH_SetKeyingCompletionCbCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetKeyingCompletionCbCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

キーイング完了コールバックに渡すユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

### wolfSSH_RealPath()

```c
#include <wolfssh/ssh.h>

int wolfSSH_RealPath(const char* defaultPath, char* in,
        char* out, word32 outSz);
```

**説明**

`defaultPath` を基準として、パス `in` を解決し、正規化された絶対パスを `out` に書き込む。

**引数**

- `defaultPath` - 相対パスの `in` を解決する際の基準パス
- `in` - 解決対象のパス
- `out` - 解決されたパスを書き込むバッファ
- `outSz` - 出力バッファのサイズ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  ポートフォワーディング関数



本セクションのすべての関数は、wolfSSH がポートフォワーディングサポート（`WOLFSSH_FWD`、`./configure --enable-fwd`）付きでビルドされていることを必要とする。

### wolfSSH_ChannelFwdNewLocal()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNewLocal(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**説明**

セッション上にローカル TCP/IP フォワーディングチャネルを設定する。セッションが接続および認証されると、接続は `hostPort` ポートの `host` へフォワードされ、送信元アドレス `origin` とポート `originPort` がタグ付けされる。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `host` - 転送先ホストアドレス
- `hostPort` - 転送先ポート
- `origin` - 送信元接続アドレス
- `originPort` - 送信元接続ポート

**戻り値**

- 新しいチャネルへのポインター、エラー時は `NULL`

**関連項目**

- `wolfSSH_ChannelFwdNewRemote()`

### wolfSSH_ChannelFwdNewRemote()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNewRemote(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**説明**

セッション上にリモート TCP/IP フォワーディングチャネルを設定し、ピアに対して `hostPort` ポートの `host` へ接続をフォワードするよう要求する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `host` - 転送先ホストアドレス
- `hostPort` - 転送先ポート
- `origin` - 送信元接続アドレス
- `originPort` - 送信元接続ポート

**戻り値**

- 新しいチャネルへのポインター、エラー時は `NULL`

**関連項目**

- `wolfSSH_ChannelFwdNewLocal()`

### wolfSSH_CTX_SetFwdCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetFwdCb(WOLFSSH_CTX* ctx,
        WS_CallbackFwd fwdCb, WS_CallbackFwdIO fwdIoCb);
```

**説明**

コンテキストに対して、ポートフォワーディングのセットアップ／クリーンアップコールバック（`fwdCb`）とフォワーディング I/O コールバック（`fwdIoCb`）を登録する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `fwdCb` - フォワーディングのセットアップ／クリーンアップコールバック
- `fwdIoCb` - フォワーディング I/O コールバック

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_SetFwdCbCtx()`

### wolfSSH_SetFwdCbCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetFwdCbCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

ポートフォワーディングコールバックに渡すユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - フォワーディングコールバックに渡すユーザーコンテキストポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelFwdNew()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**説明**

非推奨。`wolfSSH_ChannelFwdNewLocal()` を使用すること。この関数は後方互換性のために維持されており、内部でそちらへ処理を転送する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `host` - 転送先ホストアドレス
- `hostPort` - 転送先ポート
- `origin` - 送信元接続アドレス
- `originPort` - 送信元接続ポート

**戻り値**

- 新しいチャネルへのポインター、エラー時は `NULL`

**関連項目**

- `wolfSSH_ChannelFwdNewLocal()`

### wolfSSH_ChannelSetFwdFd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSetFwdFd(WOLFSSH_CHANNEL* channel, int fwdFd);
```

**説明**

非推奨。フォワーディングチャネルにフォワーディング用ファイルディスクリプタを関連付ける。

**引数**

- `channel` - フォワーディングチャネルへのポインター
- `fwdFd` - フォワーディング用ファイルディスクリプタ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetFwdFd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetFwdFd(const WOLFSSH_CHANNEL* channel);
```

**説明**

非推奨。フォワーディングチャネルに関連付けられたフォワーディング用ファイルディスクリプタを返す。

**引数**

- `channel` - フォワーディングチャネルへのポインター

**戻り値**

- フォワーディング用ファイルディスクリプタ、または負のエラーコード


##  鍵ロード関数


### wolfSSH_ReadKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_buffer(const byte* in, word32 inSz,
        int format, byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        void* heap);
```

**説明**

サイズ `inSz` のバッファ `in` から鍵を読み込み、`format` 型の鍵としてデコードする。`format` には `WOLFSSH_FORMAT_ASN1`、`WOLFSSH_FORMAT_PEM`、`WOLFSSH_FORMAT_SSH`、または `WOLFSSH_FORMAT_OPENSSH` を指定できる。デコードされた鍵は、`wolfSSH_CTX_UsePrivateKey_buffer()` で利用できる形式で、`out` が指すバッファに格納され、そのサイズが `outSz` に格納される。`out` が NULL の場合、`heap` を使って鍵用のバッファが確保される。鍵種別文字列は `outType` に格納され、その長さが `outTypeSz` に格納される。

**引数**

- `in` - エンコードされた鍵を含むバッファ
- `inSz` - 入力バッファのサイズ
- `format` - 入力鍵のエンコーディング
- `out` - デコードされた鍵の出力バッファ（NULL の場合は `heap` から確保）
- `outSz` - デコードされた鍵サイズの出力先
- `outType` - 鍵種別文字列の出力先
- `outTypeSz` - 鍵種別文字列の長さの出力先
- `heap` - `out` が NULL の場合に確保で使用されるヒープ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_RSA_E`
- `WS_ECC_E`
- `WS_KEY_AUTH_MAGIC_E`
- `WS_KEY_FORMAT_E`
- `WS_KEY_CHECK_VAL_E`

**関連項目**

- `wolfSSH_ReadKey_file()`

### wolfSSH_ReadKey_buffer_ex()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_buffer_ex(const byte* in, word32 inSz, int format,
        byte** out, word32* outSz, const byte** outType, word32* outTypeSz,
        int isPrivate, void* heap);
```

**説明**

wolfSSH_ReadKey_buffer() と同様だが、バッファが秘密鍵か公開鍵かを推測するのではなく、明示的な `isPrivate` フラグで指定する。

**引数**

- `in` - エンコードされた鍵を含むバッファ
- `inSz` - 入力バッファのサイズ
- `format` - 入力鍵のエンコーディング
- `out` - デコードされた鍵の出力バッファ（NULL の場合は `heap` から確保）
- `outSz` - デコードされた鍵サイズの出力先
- `outType` - 鍵種別文字列の出力先
- `outTypeSz` - 鍵種別文字列の長さの出力先
- `isPrivate` - 鍵が秘密鍵の場合は非ゼロ、公開鍵の場合は 0
- `heap` - `out` が NULL の場合に確保で使用されるヒープ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`

**関連項目**

- `wolfSSH_ReadKey_buffer()`

### wolfSSH_ReadPublicKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadPublicKey_buffer(const byte* in, word32 inSz, int format,
        byte** out, word32* outSz, const byte** outType, word32* outTypeSz,
        void* heap);
```

**説明**

バッファ `in` から公開鍵を読み込みデコードする。wolfSSH_ReadKey_buffer() と同様に動作するが、公開鍵専用である。

**引数**

- `in` - エンコードされた公開鍵を含むバッファ
- `inSz` - 入力バッファのサイズ
- `format` - 入力鍵のエンコーディング
- `out` - デコードされた鍵の出力バッファ（NULL の場合は `heap` から確保）
- `outSz` - デコードされた鍵サイズの出力先
- `outType` - 鍵種別文字列の出力先
- `outTypeSz` - 鍵種別文字列の長さの出力先
- `heap` - `out` が NULL の場合に確保で使用されるヒープ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`

**関連項目**

- `wolfSSH_ReadKey_buffer()`


### wolfSSH_ReadKey_file()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_file(const char* name,
        byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        byte* isPrivate, void* heap);
```

**説明**

ファイル `name` から鍵を読み込む。フォーマットはファイル内容から推測される。鍵バッファ `out`、鍵種別 `outType`、およびそれぞれのサイズは wolfSSH_ReadKey_buffer() と同様に生成される。`isPrivate` フラグは、鍵が秘密鍵であるかどうかを示すよう設定される。確保処理には指定された `heap` が使用される。

**引数**

- `name` - 鍵ファイルへのパス
- `out` - デコードされた鍵の出力バッファ（NULL の場合は `heap` から確保）
- `outSz` - デコードされた鍵サイズの出力先
- `outType` - 鍵種別文字列の出力先
- `outTypeSz` - 鍵種別文字列の長さの出力先
- `isPrivate` - 鍵が秘密鍵の場合に非ゼロが設定される出力
- `heap` - `out` が NULL の場合に確保で使用されるヒープ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_BAD_FILE_E`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_RSA_E`
- `WS_ECC_E`
- `WS_KEY_AUTH_MAGIC_E`
- `WS_KEY_FORMAT_E`
- `WS_KEY_CHECK_VAL_E`

**関連項目**

- `wolfSSH_ReadKey_buffer()`


## 鍵交換アルゴリズムの設定

wolfSSH は、使用している wolfCrypt ライブラリでのアルゴリズムの利用可否に基づいて、
鍵交換 (KEX) 時に使用するアルゴリズムリストの集合をセットアップする。

利用可能なアルゴリズムを確認するためのアクセサ関数と、KEX で使用されるアルゴリズムリストを
確認するためのアクセサ関数が用意されている。アクセサ関数は 4 つ 1 組で提供される。すなわち、
CTX オブジェクトからの設定・取得、および SSH オブジェクトからの設定・取得である。CTX を使って
作成された SSH オブジェクトはすべて CTX のアルゴリズムリストを継承するが、独自のリストを
与えることもできる。

デフォルトでは、SHA-1 を使用するアルゴリズムはすべて無効化されているが、以下のいずれかの
関数を使って再度有効化できる。wolfCrypt 側で SHA-1 が無効化されている場合、SHA-1 は使用できない。


### wolfSSH アルゴリズムリストの設定

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetAlgoListKex(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListKey(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListCipher(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListMac(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListKeyAccepted(WOLFSSH_CTX* ctx, const char* list);

int wolfSSH_SetAlgoListKex(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListKey(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListCipher(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListMac(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListKeyAccepted(WOLFSSH* ssh, const char* list);
```

**説明**

これらの関数は、wolfSSH の _ctx_ または _ssh_ オブジェクトに設定される各種アルゴリズムリストの
セッターとして機能する。これらの文字列は KEX 初期化時にピアへ送信され、ピアが KEX 初期化
メッセージを送ってきた際の比較に使用される。KeyAccepted リストはユーザー認証に使用される。

CTX 版の関数は、指定された WOLFSSH_CTX オブジェクト _ctx_ に対してアルゴリズムリストを設定する。
これらはコンパイル時にデフォルト値が設定されている。指定した値がその代わりに使用される。
なお、このライブラリは文字列をコピーしないため、その所有権はアプリケーション側にあり、
アプリケーションが CTX を解放する際に文字列を解放するのはアプリケーションの責任である。
CTX を使って SSH オブジェクトを作成すると、SSH オブジェクトは CTX の文字列を継承する。
SSH オブジェクトのアルゴリズムリストは上書きすることができる。

`Kex` は鍵交換アルゴリズムリストを指定する。`Key` はサーバー公開鍵アルゴリズムリストを指定する。
`Cipher` はバルク暗号化アルゴリズムリストを指定する。`Mac` はメッセージ認証コードアルゴリズム
リストを指定する。`KeyAccepted` はユーザー認証で許可される公開鍵アルゴリズムを指定する。

**戻り値**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`
- `WS_SSH_NULL_E`


### wolfSSH アルゴリズムリストの取得

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_CTX_GetAlgoListKex(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListKey(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListCipher(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListMac(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListKeyAccepted(WOLFSSH_CTX* ctx);

const char* wolfSSH_GetAlgoListKex(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListKey(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListCipher(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListMac(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListKeyAccepted(WOLFSSH* ssh);
```

**説明**

これらの関数は、wolfSSH の _ctx_ または _ssh_ オブジェクトに設定される各種アルゴリズムリストの
ゲッターとして機能する。

`Kex` は鍵交換アルゴリズムリストを指定する。`Key` はサーバー公開鍵アルゴリズムリストを指定する。
`Cipher` はバルク暗号化アルゴリズムリストを指定する。`Mac` はメッセージ認証コードアルゴリズム
リストを指定する。`KeyAccepted` はユーザー認証で許可される公開鍵アルゴリズムを指定する。

**戻り値**

これらの関数は、コンパイル時に設定されたデフォルト値、またはセッター関数で実行時に設定された
値へのポインターを返す。`ctx` または `ssh` パラメーターが NULL の場合、関数は NULL を返す。


### wolfSSH_CheckAlgoName()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CheckAlgoName(const char* name);
```

**説明**

指定した単一のアルゴリズム名 `name` が有効かつサポートされているかどうかを確認する。

**引数**

- `name` - 確認するアルゴリズム名

**戻り値**

- `WS_SUCCESS`
- `WS_INVALID_ALGO_ID`


### wolfSSH アルゴリズムの照会

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_QueryKex(word32* index);
const char* wolfSSH_QueryKey(word32* index);
const char* wolfSSH_QueryCipher(word32* index);
const char* wolfSSH_QueryMac(word32* index);
```

**説明**

指定された種別（Kex、Key、Cipher、または Mac）の有効なアルゴリズムの名前文字列を返す。Key
種別は、ユーザー認証で受理される鍵種別としても使用される。`index` を 0 に初期化し、呼び出す
たびに同じポインターを渡すことで反復処理を行う。関数はこのポインターを進める。戻り値が NULL
の場合、リストの末尾に達したことを意味する。

**引数**

- `index` - イテレーター。0 に初期化し、呼び出しごとに渡す

**戻り値**

- アルゴリズム名文字列へのポインター、またはリストの末尾に達した場合は `NULL`

### wolfSSH_GetText()

```c
#include <wolfssh/ssh.h>

size_t wolfSSH_GetText(WOLFSSH* ssh, WS_Text id, char* str, size_t strSz);
```

**説明**

`id`（KEX アルゴリズム、KEX 曲線、KEX ハッシュ、入出力暗号、入出力 MAC などの `WS_Text` 値）
で識別されるネゴシエーション済み項目のテキスト表現を `str` に書き込む。終端 NULL を含めて
`strSz` バイトを超えて書き込むことはない。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `id` - 取得する `WS_Text` 項目
- `str` - テキストの出力バッファ
- `strSz` - 出力バッファのサイズ

**戻り値**

- 書き込まれた文字数（終端 NULL を除く）。値が `strSz` 以上の場合、出力が切り詰められたことを
  意味する

## グローバルリクエストコールバック

これらのコールバックは、SSH グローバルリクエストメッセージおよびその成功/失敗応答を処理する。

### wolfSSH_SetGlobalReq()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetGlobalReq(WOLFSSH_CTX* ctx, WS_CallbackGlobalReq cb);
```

**説明**

ピアからグローバルリクエストメッセージを受信した際に呼び出されるコールバックを登録する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - グローバルリクエストコールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetGlobalReqCtx()`

### wolfSSH_SetGlobalReqCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetGlobalReqCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

グローバルリクエストコールバックに渡されるユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

### wolfSSH_GetGlobalReqCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetGlobalReqCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetGlobalReqCtx() で以前に設定されたユーザーコンテキストポインターを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- グローバルリクエストコンテキストポインター。存在しない場合は `NULL`

### wolfSSH_SetReqSuccess()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqSuccess(WOLFSSH_CTX* ctx, WS_CallbackReqSuccess cb);
```

**説明**

ピアからリクエスト成功応答を受信した際に呼び出されるコールバックを登録する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - リクエスト成功コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetReqSuccessCtx()`

### wolfSSH_SetReqSuccessCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqSuccessCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

リクエスト成功コールバックに渡されるユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

### wolfSSH_GetReqSuccessCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetReqSuccessCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetReqSuccessCtx() で以前に設定されたユーザーコンテキストポインターを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- リクエスト成功コンテキストポインター。存在しない場合は `NULL`

### wolfSSH_SetReqFailure()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqFailure(WOLFSSH_CTX* ctx, WS_CallbackReqSuccess cb);
```

**説明**

ピアからリクエスト失敗応答を受信した際に呼び出されるコールバックを登録する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - リクエスト失敗コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetReqFailureCtx()`

### wolfSSH_SetReqFailureCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqFailureCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

リクエスト失敗コールバックに渡されるユーザーコンテキストポインターを設定する。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

### wolfSSH_GetReqFailureCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetReqFailureCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetReqFailureCtx() で以前に設定されたユーザーコンテキストポインターを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- リクエスト失敗コンテキストポインター。存在しない場合は `NULL`

## TPM 2.0 連携

これらの関数は、ホスト鍵操作のために wolfTPM 2.0 デバイスおよび鍵を統合する。使用するには、
wolfSSH を `WOLFSSH_TPM` を有効にしてビルドし、wolfTPM がインストールされている必要がある。

### wolfSSH_SetTpmDev()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTpmDev(WOLFSSH* ssh, WOLFTPM2_DEV* dev);
```

**説明**

TPM を利用したホスト鍵操作のために、wolfTPM 2.0 デバイスをセッションに関連付ける。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dev` - wolfTPM 2.0 デバイスへのポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_SetTpmKey()`

### wolfSSH_SetTpmKey()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTpmKey(WOLFSSH* ssh, WOLFTPM2_KEY* key);
```

**説明**

TPM を利用したホスト鍵操作のために、wolfTPM 2.0 鍵をセッションに関連付ける。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `key` - wolfTPM 2.0 鍵へのポインター

**戻り値**

なし

### wolfSSH_GetTpmDev()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetTpmDev(WOLFSSH* ssh);
```

**説明**

以前にセッションに関連付けられた wolfTPM 2.0 デバイスを返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- wolfTPM 2.0 デバイスへのポインター。存在しない場合は `NULL`

### wolfSSH_GetTpmKey()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetTpmKey(WOLFSSH* ssh);
```

**説明**

以前にセッションに関連付けられた wolfTPM 2.0 鍵を返す。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- wolfTPM 2.0 鍵へのポインター。存在しない場合は `NULL`

### wolfSSH_CTX_UseTpmHostKey()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UseTpmHostKey(WOLFSSH_CTX* ctx,
        WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key);
```

**説明**

指定された wolfTPM 2.0 デバイスおよび鍵をサーバーホスト鍵として使用するようコンテキストを
設定する。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `dev` - wolfTPM 2.0 デバイスへのポインター
- `key` - wolfTPM 2.0 鍵へのポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

