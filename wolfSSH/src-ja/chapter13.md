#  APIリファレンス

このセクションでは、wolfSSH Libraryの公開APIについて説明します。

##  エラーコード


###  WS_ErrorCodes (enum)


以下の戻り値は、wolfssh/wolfssh/error.hで定義されていて、発生する可能性のあるさまざまなタイプのエラーを表します。

- WS_SUCCESS (0): 関数は成功
- WS_FATAL_ERROR (-1): 一般的な失敗
- WS_BAD_ARGUMENT (-2): 引数が範囲外
- WS_MEMORY_E (-3): メモリ確保に失敗
- WS_BUFFER_E (-4): 入/出力バッファのサイズエラー
- WS_PARSE_E (-5): 一般的な解析エラー
- WS_NOT_COMPILED (-6): 機能が組み込まれていない
- WS_OVERFLOW_E (-7): 継続するとオーバーフローする可能性あり
- WS_BAD_USAGE (-8): 使用方法が間違っている
- WS_SOCKET_ERROR_E (-9): ソケットで発生したエラー
- WS_WANT_READ (-10): IOコールバックで読み込みがブロック（再度リードせよ）
- WS_WANT_WRITE (-11): IOコールバックで書き込みがブロック（再度ライトせよ）
- WS_RECV_OVERFLOW_E (-12): 受信バッファがオーバーフローした
- WS_VERSION_E (-13): 相手が異なるSSHバージョンを使っている
- WS_SEND_OOB_READ_E (-14): 帯域外データを読み出そうとした
- WS_INPUT_CASE_E (-15): プロセス入力状態不正あるいはプログラミングエラー
- WS_BAD_FILETYPE_E (-16): ファイルタイプ不正
- WS_UNIMPLEMENTED_E (-17): 機能が未実装
- WS_RSA_E (-18): RSAバッファーエラー
- WS_BAD_FILE_E (-19): ファイル不正
- WS_INVALID_ALGO_ID (-20): 無効なアルゴリズムID
- WS_DECRYPT_E (-21): 復号エラー
- WS_ENCRYPT_E (-22): 暗号化エラー
- WS_VERIFY_MAC_E (-23): mac検証エラー
- WS_CREATE_MAC_E (-24): mac作成エラー
- WS_RESOURCE_E (-25): 新たなチャネル作成にリソース不足
- WS_INVALID_CHANTYPE (-26): 無効なチャネルタイプ
- WS_INVALID_CHANID(-27): ピアが無効なチャネルIDを要求した
- WS_INVALID_USERNAME(-28): 無効なユーザー名
- WS_CRYPTO_FAILED(-29): 暗号アクションが失敗
- WS_INVALID_STATE_E(-30): 無効な状態
- WC_EOF(-31): ファイルの終了
- WS_INVALID_PRIME_CURVE(-32): 無効なECCプライムカーブ
- WS_ECC_E(-33): ECDSAバッファーエラー
- WS_CHANOPEN_FAILED(-34): ピアがチャネルオープン失敗を返した
- WS_REKEYING(-35): ピアとリキーイング
- WS_CHANNEL_CLOSED(-36): チャネルがクローンした

###  WS_IOerrors (enum)

以下は、ライブラリがユーザー提供のI/Oコールバックから受け取ることを期待しているリターンコードです。それ以外の場合、ライブラリは、I/Oアクションから読み取られたバイト数を期待しています。


- WS_CBIO_ERR_GENERAL (-1): 一般的な予期しないエラー 
- WS_CBIO_ERR_WANT_READ (-2): ソケットの読み取りブロック（再度リードせよ）
- WS_CBIO_ERR_WANT_WRITE (-2): ソケットの書き込みブロック（再度ライトせよ）
- WS_CBIO_ERR_CONN_RST (-3): コネクションがリセットされた
- WS_CBIO_ERR_ISR (-4): 割り込み発生
- WS_CBIO_ERR_CONN_CLOSE (-5): コネクションがクローンした
- WS_CBIO_ERR_TIMEOUT (-6): ソケットタイムアウト

##  初期化 /シャットダウン



### wolfSSH_Init()



**用法**

**説明**

wolfSSHライブラリを初期化します。アプリケーションごとに1回、ライブラリへの他の呼び出しの前に呼び出される必要があります。

**戻り値**

WS_SUCCESS<br>

WS_CRYPTO_FAILED

**引数**

なし

```
#include <wolfssh/ssh.h>
int wolfSSH_Init(void);
```
**関連項目**

wolfSSH_Cleanup()


### wolfSSH_Cleanup()



**用法**

**説明**

wolfSSHライブラリをクリーンアップします。アプリケーションの終了前に呼び出す必要があります。本関数呼び出し後は、ライブラリAPIの呼び出しはできません。

**戻り値**

**WS_SUCCESS**

**WS_CRYPTO_FAILED**

**引数**

なし


```
#include <wolfssh/ssh.h>
int wolfSSH_Cleanup(void);
```

**関連項目**

wolfSSH_Init()

##  デバッグ出力関数



### wolfSSH_Debugging_ON()



**用法**

**説明**

実行中にデバッグロギングを有効にします。ビルド時にデバッグが無効になっている場合、何もしません。


**戻り値**

なし

**引数**

なし

```
#include <wolfssh/ssh.h>
void wolfSSH_Debugging_ON(void);
```

**関連項目**

wolfSSH_Debugging_OFF()


### wolfSSH_Debugging_OFF()



**用法**

**説明**

実行時にデバッグロギングを無効にします。ビルド時にデバッグが無効になっている場合、何もしません。


**戻り値**

なし

**引数**

なし


```
#include <wolfssh/ssh.h>
void wolfSSH_Debugging_OFF(void);
```

**関連項目**

wolfSSH_Debugging_ON()

##  コンテキスト関数



### wolfSSH_CTX_new()



**用法**

**説明**

wolfSSHコンテキストオブジェクトを作成します。このオブジェクトはwolfSSHセッションオブジェクトのファクトリとして使用されます。

**戻り値**

**WOLFSSH_CTX** – 割り当てられたWOLFSSH_CTXオブジェクトへのポインターあるいはNULL

**引数**

**side** – クライアントサイド(実装なし)またはサーバーサイドを示します<br>

**heap** – メモリ割り当てに使用するヒープへのポインター

```
#include <wolfssh/ssh.h>
WOLFSSH_CTX* wolfSSH_CTX_new(byte side , void* heap );
```

**関連項目**

wolfSSH_CTX_free()


### wolfSSH_CTX_free()



**用法**

**説明**

WOLFSSH_CTXオブジェクトを解放します

**戻り値**

なし

**引数**

**ctx** – WOLFSSH_CTXオブジェクト

```
#include <wolfssh/ssh.h>
void wolfSSH_CTX_free(WOLFSSH_CTX* ctx );
```

**関連項目**

wolfSSH_CTX_new()

### wolfSSH_CTX_SetBanner()


**用法**

**説明**

バナーメッセージをセットします

**戻り値**

WS_BAD_ARGUMENT <br>

WS_SUCCESS

**引数**

**ssh** - wolfSSHオブジェクト<br>

**newBanner** - バナーメッセージ文字列

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetBanner(WOLFSSH_CTX* ctx , const char* newBanner );
```

### wolfSSH_CTX_UsePrivateKey_buffer()


**用法**

**説明** <br>
この関数は、秘密鍵バッファをSSHコンテキストにロードします。ファイルの代わりにバッファーを入力として呼び出されます。バッファは、**insz** の **in** 引数によって提供されます。<br>

**引数** 

**format** バッファのタイプを指定します：**wolfssh_format_asn1** または **wolfssl_format_pem** (現時点では未実装)。


**戻り値**

**WS_SUCCESS** <br>

**WS_BAD_ARGUMENT** – 少なくとも一つの引数が不正<br>

**WS_BAD_FILETYPE_E** – フォーマットが不正<br>

**WS_UNIMPLEMENTED_E** – PEMフォーマットは未対応<br>

**WS_MEMORY_E** – メモリ確保エラー<br>

**WS_RSA_E** – RSA鍵をデコードできない<br>

**WS_BAD_FILE_E** – バッファを解析できない<br>

**引数**

**ctx** – wolfSSH_CTXオブジェクトへのポインター<br>

**in** – 秘密鍵を含むバッファへのポインター<br>

**inSz** – 入力バッファのサイズ<br>

**format** – 秘密鍵のフォーマット<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_UsePrivateKey_buffer(WOLFSSH_CTX* ctx , const byte* in , word32 inSz , int format);
```

**関連項目**

wolfSSH_UseCert_buffer()<br>

wolfSSH_UseCaCert_buffer()<br>


##  SSH セッション関数


### wolfSSH_new()



**用法**

**説明**

wolfSSHセッションオブジェクトを確保し、与えられたwolfSSH_CTXオブジェクトを使って初期化します。

**戻り値**

**WOLFSSH*** – WOLFSSHオブジェクトへのポインターあるいはNULL

**引数**

**ctx** – wolfSSHセッションの初期化に使用されるwolfSSHコンテキスト


```
#include <wolfssh/ssh.h>
WOLFSSH* wolfSSH_new(WOLFSSH_CTX* ctx );
```

**関連項目**

wolfSSH_free()

### wolfSSH_free()



**用法**

**説明**

wolfSSHオブジェクトを解放します

**戻り値**

なし

**引数**

**ssh** – 解放するWOLFSSHオブジェクトへのポインター

```
#include <wolfssh/ssh.h>
void wolfSSH_free(WOLFSSH* ssh );
```

**関連項目**

wolfSSH_new()


### wolfSSH_set_fd()



**用法**

**説明**

与えられたファイルディスクリプタをsshオブジェクトに関連付けます。ファイルディスクリプタはネットワークI/Oに使用され、I/Oコールバック関数に渡されます。

**戻り値**

WS_SUCCESS <br>

WS_BAD_ARGUMENT – 引数の少なくともひとつが不正

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**fd** – セッションで使用されるソケットディスクリプター

```
#include <wolfssh/ssh.h>
int wolfSSH_set_fd(WOLFSSH* ssh , int fd );
```

**関連項目**

wolfSSH_get_fd()

### wolfSSH_get_fd()



**用法**

**説明**

SSHコネクションの入出力機能で使用されるファイルディスクリプタ( **fd** )を返します。一般的にはソケットファイルディスクリプタを返します。


**戻り値**

**int** – ファイルディスクリプタ<br>

**WS_BAD_ARGUEMENT**

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/ssh.h>
int wolfSSH_get_fd(const WOLFSSH* ssh );
```

**関連項目**

wolfSSH_set_fd()

##  ハイウォーターマーク機能



### wolfSSH_SetHighwater()


**用法**

**説明**

SSHセッションで使用するハイウォーターマークをセットします。

**戻り値**

WS_SUCCESS <br>

WS_BAD_ARGUMENT

**引数**

**ssh**  - WOLFSSHオブジェクトへのポインター<br>

**highwater** - ハイウォーターマークを示すデータ

```
#include <wolfssh/ssh.h>
int wolfSSH_SetHighwater(WOLFSSH* ssh , word32 highwater );
```

### wolfSSH_GetHighwater()


**用法**

**説明**

ハイウォーターマークを返します。

**戻り値**

**word32** - ハイウォーターマーク

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
word32 wolfSSH_GetHighwater(WOLFSSH* ssh );
```

### wolfSSH_SetHighwaterCb()


**用法**

**説明**

SSHセッションにハイウォーターマークとハイウォーターコールバック関数を設定します。


**戻り値**

なし

**引数**

**ctx** – wolfSSHコンテキスト<br>

**highwater** - ハイウォーターマーク<br>

**cb** - ハイウォーターコールバック関数<br>


```
#include <wolfssh/ssh.h>
void wolfSSH_SetHighwaterCb(WOLFSSH_CTX* ctx , word32 highwater ,
WS_CallbackHighwater cb );
```

### wolfSSH_SetHighwaterCtx()


**用法**

**説明**

ハイウォーターコールバック関数に渡されるコンテキストを設定します。


**戻り値**

なし

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**ctx** - ハイウォーターコールバック関数に渡されるコンテキスト

```
#include <wolfssh/ssh.h>
void wolfSSH_SetHighwaterCtx(WOLFSSH* ssh, void* ctx);
```

### wolfSSH_GetHighwaterCtx()


**用法**

**説明**

SSHセッションにセットされたハイウォーターマークを返します。

**戻り値**

**void*** - ハイウォーターマーク<br>

**NULL** - WOLFSSHオブジェクトにハイウォーターマークがセットされていない場合

**引数**

**ssh**　- WOLFSSHオブジェクトへのポインター

```
#include <wolfssh/ssh.h>
void wolfSSH_GetHighwaterCtx(WOLFSSH* ssh );
```

##  エラーチェック



### wolfSSH_get_error()



**用法**

**説明**

wolfSSHセッションオブジェクトにセットされたエラーコードを返します。

**戻り値**

WS_ErrorCodes (enum)

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター

```
#include <wolfssh/ssh.h>
int wolfSSH_get_error(const WOLFSSH* ssh );
```

**関連項目**

wolfSSH_get_error_name()


### wolfSSH_get_error_name()



**用法**

**説明**

wolfSSHセッションオブジェクトにセットされたエラーの名前を返します。

**戻り値**

**const char*** – エラー名文字列<br>

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター


```
#include <wolfssh/ssh.h>
const char* wolfSSH_get_error_name(const WOLFSSH* ssh );
```

**関連項目**

wolfSSH_get_error()

### wolfSSH_ErrorToName()


**用法**

**説明**

引数で指定されたエラーコードに対応するエラーの名前を返します。


**戻り値**

**const char*** – エラー名文字列<br>

**引数**

**err** - エラーコード

```
#include <wolfssh/ssh.h>
const char* wolfSSH_ErrorToName(int err );
```

##  I/O コールバック関数



### wolfSSH_SetIORecv()


**用法**

**説明**

入力データを受信する為の受信コールバック関数を登録します。


**戻り値**

なし

**引数**

**ctx** – wolfSSHコンテキスト<br>

**cb** – wolfSSHコンテキストに関連つけられる、受信コールバック関数

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIORecv(WOLFSSH_CTX* ctx , WS_CallbackIORecv cb );
```

### wolfSSH_SetIOSend()


**用法**

**説明**

送信データを送信するための送信コールバック関数を登録します。

**戻り値**

なし

**引数**

**ctx** – wolfSSHコンテキスト<br>

**cb** – wolfSSHコンテキストに関連つけられる、送信コールバック関数。

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOSend(WOLFSSH_CTX* ctx , WS_CallbackIOSend cb );
```

### wolfSSH_SetIOReadCtx()


**用法**

**説明**

受信コールバック関数に渡されるコンテキストを設定します


**戻り値**

なし

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**ctx** – コンテキストへのポインター。受信コールバック関数に渡される

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOReadCtx(WOLFSSH* ssh , void* ctx );
```

### wolfSSH_SetIOWriteCtx()


**用法**

**説明**

送信コールバック関数に渡されるコンテキストを設定します

**戻り値**

なし

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**ctx** – コンテキストへのポインター。送信コールバック関数に渡される

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOWriteCtx(WOLFSSH* ssh , void* ctx );
```

### wolfSSH_GetIOReadCtx()


**用法**

**説明**

WOLFSSHオブジェクトのioReadCtxメンバーを返します。


**戻り値**

**void*** - WOLFSSHオブジェクトのioReadCtxメンバーへのポインター

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetIOReadCtx(WOLFSSH* ssh );
```

### wolfSSH_GetIOWriteCtx()


**用法**

**説明**

WOLFSSHオブジェクトのioWriteCtxメンバーを返します。


**戻り値**

**void*** – WOLFSSHオブジェクトのioWriteCtxメンバーへのポインター

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetIOWriteCtx(WOLFSSH* ssh);
```

##  ユーザー認証



### wolfSSH_SetUserAuth()


**用法**

**説明**


現在のWOLFSSL_CTXオブジェクトに対してユーザー認証コールバック関数を登録します。


**戻り値**

なし

**引数**

**ctx** – WOLFSSH_CTXオブジェクトへのポインター<br>

**cb** – ユーザー認証コールバック関数

```
#include <wolfssh/ssh.h>
void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx, WS_CallbackUserAuth cb)
```

### wolfSSH_SetUserAuthCtx()


**用法**

**説明**

ユーザー認証コールバック関数に渡されるコンテキストを登録します。

**戻り値**

なし

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**userAuthCtx** – ユーザー認証コールバック関数へ渡すコンテキスト

```
#include <wolfssh/ssh.h>
void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh , void* userAuthCtx)
```

### wolfSSH_GetUserAuthCtx()


**用法**

**説明**

ユーザー認証コールバック関数に渡されるコンテキストを返します。

**戻り値**

**void*** – ユーザー認証コールバック関数へ渡すコンテキスト<br>

**NULL** – ssh引数がNULLの場合

**引数**

**ssh** – pointer to WOLFSSH object

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh )
```

##  ユーザー名設定機能



### wolfSSH_SetUsername()


**用法**

**説明**

SSHコネクションに必要なユーザー名を設定します。

**戻り値**

WS_BAD_ARGUMENT<br>

WS_SUCCESS<br>

WS_MEMORY_E<br>

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**username** - ユーザー名文字列

```
#include <wolfssh/ssh.h>
int wolfSSH_setUsername(WOLFSSH* ssh , const char* username);
```

##  接続機能

### wolfSSH_accept()



**用法**

**説明**

wolfssh_acceptはサーバー側で呼び出され、SSHクライアントがSSHハンドシェイクを開始するのを待ちます。

wolfssl_accept()は、ブロッキングI/OノンブロッキングI/Oの両方で機能します。使用しているI/Oが非ブロッキングである場合、wolfSSH_accept()は、ハンドシェークが完了できなかった場合は即戻ります。この場合、wolfssh_get_error()を呼び出すと、**WS_WANT_READ** または**WS_WANT_WRITE**のいずれかが返されます。


この場合呼び出し元は、読み取るべきデータを受信してwolfSSHが中断されたところからピックアップできるように、wolfSSH_acceptへの呼び出しを繰り返す必要があります。非ブロッキングソケットを使用する場合、何も実行する必要はありませんが、select()を使用して必要な条件を確認できます。


使用しているI/Oがブロッキングの場合、wolfSSH_accept()は、ハンドシェークが終了したか、エラーが発生した場合にのみ戻ります。


**戻り値**

**WS_SUCCESS** - 成功<br>

**WS_BAD_ARGUMENT** - 引数がNULL<br>

**WS_FATAL_ERROR** – エラーが発生した。wolfSSH_get_error()を呼び出して詳細を取得すべき

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_accept(WOLFSSH* ssh);
```

**関連項目**

wolfSSH_stream_read()


### wolfSSH_connect()


**用法**

**説明**

この関数はクライアント側で呼び出されSSHハンドシェークをサーバーに対して開始します。
この関数が呼び出される時点では下層の通信チャネルは接続が完了している必要があります。

wolfSSH_connect()関数はブロッキングとノンブロッキングI/Oの両方で動作できます。ノンブロッキングI/Oの場合にはハンドシェークが完了できなかった場合は即戻ります。この場合、wolfssh_get_error()を呼び出すと、**WS_WANT_READ** または**WS_WANT_WRITE**のいずれかが返されます。

この場合呼び出し元は、読み取るべきデータを受信してwolfSSHが中断されたところからピックアップできるように、wolfSSH_connectへの呼び出しを繰り返す必要があります。非ブロッキングソケットを使用する場合、何も実行する必要はありませんが、select()を使用して必要な条件を確認できます。


使用しているI/Oがブロッキングの場合、wolfSSH_accept()は、ハンドシェークが終了したか、エラーが発生した場合にのみ戻ります。


**戻り値**
**WS_SUCCESS** - 接続に成功<br>

**WS_BAD_ARGUMENT** - 引数がNULL<br>

**WS_FATAL_ERROR** - エラーが発生した。wolfSSH_get_error()を呼び出して詳細を取得すべき


**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_connect(WOLFSSH* ssh);
```

### wolfSSH_shutdown()


**用法**

**説明**

SSHチャネルの接続を終了してクローズします

**戻り値**

**WS_BAD_ARGUMENT** - 引数がNULL<br>

**WS_SUCCES** - 正常にシャットダウンが成功した

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_shutdown(WOLFSSH* ssh);
```

### wolfSSH_stream_read()



**用法**

**説明**

wolfSSH_stream_read()は内部のバッファから復号済みデータを**bufSz**で指定されたバイト数まで読みだします。読み込まれたデータはバッファから取り除かれます。

wolfSSH_stream_read()はブロッキングとノンブロッキングI/Oの両方で動作できます。ノンブロッキングI/Oの場合にはハンドシェークが完了できなかった場合は即戻ります。この場合、wolfssh_get_error()を呼び出すと、**WS_WANT_READ** または**WS_WANT_WRITE**のいずれかが返されます。

この場合呼び出し元は、読み取るべきデータを受信してwolfSSHが中断されたところからピックアップできるように、wolfSSH_stream_read()の呼び出しを繰り返す必要があります。非ブロッキングI/Oが使用されている場合、何も実行する必要はありませんが、select()を使用して必要な条件を確認できます。

ブロッキングI/Oが使用されている場合は、wolfSSH_stream_read()は、データがIsAbaibleまたはエラーが発生した場合にのみ戻ります。

**戻り値**

**>0** – 読み取りに成功したバイト数<br>

**0** – クリーンコネクションシャットダウンかソケットエラー<br>

**WS_BAD_ARGUMENT** – 引数の一つがNULL<br>

**WS_EOF** – ストリームの終端に到達<br>

**WS_FATAL_ERROR** – エラーが発生。**wolfSSH_get_error()** を呼び出して詳細を取得すべき<br>

**WS_REKEYING** - リキーイング処理中。 wolfSSH_worker()を呼び出して完了させること

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**buf** – wolfSSH_stream_read()が読みだしたデータを格納するバッファへのポインター<br>

**bufSz** – バッファサイズ


```
#include <wolfssh/ssh.h>
int wolfSSH_stream_read(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**関連項目**

wolfSSH_accept()<br>

wolfSSH_stream_send()


### wolfSSH_stream_send()



**用法**

**説明**

wolfSSH_stream_send()はバッファで与えたデータを**bufSz**で指定されたバイト数までSSHストリームデータバッファに書き込みます。

wolfSSH_stream_send()はブロッキングとノンブロッキングI/Oの両方で動作できます。ノンブロッキングI/Oの場合にはハンドシェークが完了できなかった場合は即戻ります。この場合、wolfssh_get_error()を呼び出すと、**WS_WANT_READ** または**WS_WANT_WRITE**のいずれかが返されます。

この場合呼び出し元は、データの書き込みがペンディングされ、wolfSSHが中断されたところから書き込みを再開できるように、wolfSSH_stream_send()の呼び出しを繰り返す必要があります。非ブロッキングソケットを使用する場合、何も実行する必要はありませんが、select()を使用して必要な条件を確認できます。

ブロッキングI/Oが使用されている場合は、wolfSSH_stream_send()は、データが送信されたときかエラーが発生した時のみ戻ります。

WS_WANT_READ またはWS_WANT_WRITEのいずれもかえされていない場合(すなわち**WS_REKEYING**が返された場合）は、内部処理が終了するまでwolfSSH_worker()を呼び出し続ける必要があります。


**戻り値**

**>0** – SSHストリームバッファに書き込んだバイト数<br>

**0** – クリーンコネクションシャットダウンかソケットエラー。 **wolfSSH_get_error()** を呼び出して詳細を取得すること<br>

**WS_FATAL_ERROR** – エラーが発生。**wolfSSH_get_error()** を呼び出して詳細を取得すること<br>

**WS_BAD_ARGUMENT** - 引数の一つがNULL<br>

**WS_REKEYING** - リキーイング処理中。 wolfSSH_worker()を呼び出して完了させること

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**buf** – wolfSSH_stream_send()が送信するデータを格納するバッファへのポインター<br>

**bufSz** – size of the buffer<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_stream_send(WOLFSSH* ssh , byte* buf , word32　bufSz);
```



**関連項目**

wolfSSH_accept()<br>

wolfSSH_stream_read()


### wolfSSH_stream_exit()


**用法**

**説明**

SSHストリームを終了させます。


**戻り値**

**WS_BAD_ARGUMENT** - 引数の一つがNULL<br>

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**status** – SSHコネクションの状態

```
#include <wolfssh/ssh.h>
int wolfSSH_stream_exit(WOLFSSH* ssh, int status);
```

### wolfSSH_TriggerKeyExchange()


**用法**

**説明**

鍵交換処理を開始します。ハンドシェークに必要なパケットを用意して送信します。


**戻り値**

**WS_BAD_ARGUEMENT** – 引数がNULL<br>

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_TriggerKeyExchange(WOLFSSH* ssh );
```

##  テスト機能



### wolfSSH_GetStats()


**用法**

**説明**

**ssh**セッションに関連した、**txCount** , **rxCount** , **seq** , と **peerSeq** を更新します。


**戻り値**

なし

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**txCount** – 総送信済みデータ数を返却する為の変数のアドレス<br>

**rxCount** – 総受信済みデータ数を返却する為の変数のアドレス<br>

**seq** – パケットシーケンス番号を返却する為の変数のアドレス。パケットシーケンス番号は0から始まりパケット毎にインクリメントされる<br>

**peerSeq** – 相手パケットシーケンス番号を返却する為の変数のアドレス。パケットシーケンス番号は0から始まりパケット毎にインクリメントされる<br>


```
#include <wolfssh/ssh.h>
void wolfSSH_GetStats(WOLFSSH* ssh , word32* txCount , word32* rxCount ,
word32* seq , word32* peerSeq )
```

### wolfSSH_KDF()


**用法**

**説明**

APIテストが鍵派生の既知の回答テストを行うことができるように使用されます。
鍵派生関数は鍵マテリアル**k** と **h**を元に対称鍵を生成します。ここで、**k**はデフィーヘルマンのシェアードシークレットであり、**h**は初期の鍵交換中に生成されたハンドシェークのハッシュ値です。**keyid**および**hashid**によって指定される複数のタイプの鍵が導出される可能性があります。


```
Initial IV client to server: keyId = A
Initial IV server to client: keyId = B
Encryption key client to server: keyId = C
Encryption key server to client: keyId = D
Integrity key client to server: keyId = E
Integrity key server to client : keyId = F
```
**戻り値**

**WS_SUCCESS**<br>

**WS_CRYPTO_FAILED**

**引数**

**hashId** – キーイングマテリアルを生成させる為のハッシュのタイプ(WC_HASH_TYPE_SHA あるいは WC_HASH_TYPE_SHA256)<br>

**keyId** – 生成する鍵を示す文字A から F<br>

**key** – 期待されている鍵との比較に使用される生成済みの鍵<br>

**keySz** – 鍵**key**の生成に必要なサイズ<br>

**k** – デフィーヘルマン鍵交換で得たシェアードシークレット<br>

**kSz** – シェアードシークレット**k**のサイズ<br>

**h** – 鍵交換中に生成されたハンドシェークのハッシュ値<br>

**hSz** – ハッシュ**h**のサイズ<br>

**sessionId** – 最初のハッシュ**h**のユニークなID<br>

**sessionIdSz** – **sessionId**のサイズ


```
#include <wolfssh/ssh.h>
int wolfSSH_KDF(byte hashId , byte keyId , byte* key , word32　keySz ,
const byte* k , word32 kSz , const byte* h , word32　hSz ,
const byte* sessionId , word32 sessionIdSz );
```



##  セッション機能



### wolfSSH_GetSessionType()


**用法**

**説明**

wolfSSH_GetSessionType()はセッションの種類を返します。

**戻り値**

WOLFSSH_SESSION_UNKNOWN<br>

WOLFSSH_SESSION_SHELL<br>

WOLFSSH_SESSION_EXEC<br>

WOLFSSH_SESSION_SUBSYSTEM<br>

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
WS_SessionType wolfSSH_GetSessionType(const WOLFSSH* ssh );
```

### wolfSSH_GetSessionCommand()


**用法**

**説明**

セッションの現在のコマンドを返します

**戻り値**

**const char*** - コマンドへのポインター

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

```
#include <wolfssh/ssh.h>
const char* wolfSSH_GetSessionCommand(const WOLFSSH* ssh );
```

##  ポートフォワーディング関数



### wolfSSH_ChannelFwdNew()


**用法**

**説明**

wolfSSHセッションにTCP/IP転送チャネルを設定します。SSHセッションが接続され、認証された場合、ポート_hostport_のaddress_host_のインターフェイスにローカルリスナーが作成されます。そのリスナーの新しい接続があれば、SSHサーバーへの新しいChannelRequestをトリガーして、ポート_hostport_で_host_への接続を確立します。


**戻り値**

**WOLFSSH_CHAN*** – エラーの場合はNULL、成功の場合は新たな新しいチャンネルレコード

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**host** – バインドリスナーのホストアドレス<br>

**hostPort** – バインドリスナーのポート<br>

**origin** – 接続元のIPアドレス<br>

**originPort** – 接続元のポート<br>

```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh ,
const char* host , word32 hostPort ,
const char* origin , word32 originPort );
```

### wolfSSH_ChannelFree()


**用法**

**説明**

チャネル _channel_のメモリを解放します。チャネルはセッションのチャネルリストから削除されます。


**戻り値**

**int** – エラーコード

**引数**

**channel** – 解放されるwolfSSHチャネル

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelFree(WOLFSSH_CHANNEL* channel );
```

### wolfSSH_worker()


**用法**

**説明**

wolfSSH Worker機能は接続を見守り、データが受信されると処理します。SSHセッションにはセッションの多くの管理すべきメッセージがあり、これにより自動的にケアがあります。特定のチャネルのデータが受信されると、ワーカーはデータをチャネルに配置します。(function wolfssh_stream_read()dosmuchも同じですが、単一のチャネルの受信データも返します。）wolfssh_worker()は次のアクションを実行します：

1. _outputbuffer_　内に保留中のデータを送信しようとします。
2. セッションのソケットに対して _DoReceive()_ を呼び出します。
3. 特定のチャネルのデータが受信された場合、データを返して通知を受け取り、チャネルIDを指定して通知します。


**戻り値**

**int** – エラーコードあるいはステータス<br>

**WS_CHANNEL_RXD** – チャネルに受信済みのデータとチャネルIDがセットされている

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**id** – IDを格納する変数へのポインター


```
#include <wolfssh/ssh.h>
int wolfSSH_worker(WOLFSSH* ssh , word32* channelId );
```

### wolfSSH_ChannelGetId()


**用法**

**説明**

引数で与えられたチャネルに対してIDあるいは相手のIDを返します。

**戻り値**

**int** – エラーコード<br>

**引数**

**channel** – チャネルへのポインター<br>

**id** – IDを格納する変数へのポインター<br>

**peer** – 自チャネルIDか相手チャネルID

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelGetId(WOLFSSH_CHANNEL* channel ,　word32* id , byte peer);
```

### wolfSSH_ChannelFind()


**用法**

**説明**

Given a session _ssh_ , find the channel associated with _id_.

**戻り値**

**WOLFSSH_CHANNEL*** – チャネルへのポインター,IDがリストになければNULL

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**id** – 検索したいチャネルID<br>

**peer** – どちらの側(自channel ID か相手channel ID)


```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFind(WOLFSSH* ssh ,
word32 id , byte peer );
```

### wolfSSH_ChannelRead()


**用法**

**説明**

チャネルオブジェクトからデータをコピーします


**戻り値**

**int** – 読みだしたバイト数<br>

**>0** – 成功時には読みだしたバイト数を返します

**0** – クリーンコネクションシャットダウンかソケットエラーが発生している。 エラー詳細を取得するためにwolfSSH_get_error()を呼び出すこと。<br>

**WS_FATAL_ERROR** – そのほかのエラーが発生。エラー詳細を取得するためにwolfSSH_get_error()を呼び出すこと。<br>

**引数**

**channel** – wolfSSH channelへのポインター<br>

**buf** – wolfSSH_ChannelReadが読みだしたデータを格納するバッファアドレス<br>

**bufSz** – バッファのサイズ<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelRead(WOLFSSH_CHANNEL* channel, byte* buf, word32 bufSz );
```

### wolfSSH_ChannelSend()


**用法**

**説明**

指定したチャネル経由でデータを相手に送信します。データはチャネルデータメッセージにパッキングされて送られます。さらに送信すべきデータがある場合には、 _wolfSSH_worker()_ を呼び出すと相手へのデータ送信を継続します。

**戻り値**

**int** – 送信したバイト数<br>

**>0** – 成功時には送信したバイト数を返す<br>

**0** – クリーンコネクションシャットダウンかソケットエラーが発生している。 エラー詳細を取得するためにwolfSSH_get_error()を呼び出すこと。<br>

**WS_FATAL_ERROR** – そのほかのエラーが発生。エラー詳細を取得するためにwolfSSH_get_error()を呼び出すこと。<br>


**引数**

**channel** – wolfSSH channelへのポインター<br>

**buf** – wolfSSH_ChannelSend()が送信のために読みだすバッファへのポインター<br>

**bufSz** – バッファのサイズ<br>


```
#include <wolfssh/ssh.h>
int* wolfSSH_ChannelSend(WOLFSSH_CHANNEL* channel, const byte* buf, word32 bufSz);
```

### wolfSSH_ChannelExit()


**用法**

**説明**

チャネルを終了し、相手へのメッセージ送信を停止し、チャネルがクローズしたとマークします。この関数はチャネルと残ったデータを解放しませんし、チャネルはリストに残ります。クローズ後は未送信データはそのままですが、受信は可能です。（現時点ではEOFとcloseを送りチャネルを削除します）

**戻り値**

**int** – エラーコード

**引数**

**channel** – wolfSSH channelへのポインター<br>

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelExit(WOLFSSH_CHANNEL* channel );
```

### wolfSSH_ChannelNext()


**用法**

**説明**

_ssh_ の _channel_ の次のチャネルを返します。_channel_ がNULLの場合には、チャネルリスト内の最初のチャネルを返します。


**戻り値**

**WOLFSSH_CHANNEL** – 最初のチャネルあるいは次のチャネルへのポインターあるいはNULL

**引数**

**ssh** - WOLFSSHオブジェクトへのポインター<br>

**channel** – wolfSSH channelへのポインター<br>

```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh , WOLFSSH_CHANNEL* channel );
```


