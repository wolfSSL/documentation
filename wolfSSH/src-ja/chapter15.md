# wolfSSH SCP API リファレンス

この章では、wolfSSH における SCP（Secure Copy）ファイル転送のパブリック
アプリケーションプログラミングインターフェイスについて説明します。

この章のすべての関数を使用するには、wolfSSH を SCP サポート付き
（`WOLFSSH_SCP`、`./configure --enable-scp` により有効化）でビルドする必要が
あります。

##  SCP 転送関数

### wolfSSH_SCP_connect()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_connect(WOLFSSH* ssh, byte* cmd);
```

**説明**

確立済みの SSH 接続上で、SCP コマンド `cmd` をサーバーに送信して SCP セッション
を開始します。ファイルを転送する前に、クライアント側で呼び出します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `cmd` - サーバーに送信する SCP コマンド

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SCP_to()`
- `wolfSSH_SCP_from()`

### wolfSSH_SCP_to()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_to(WOLFSSH* ssh, const char* src, const char* dst);
```

**説明**

ローカルのファイルまたはディレクトリ `src` を、SSH 接続を通じてリモートの宛先
`dst` に送信（アップロード）します。クライアント側で呼び出します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `src` - ローカルのソースファイルまたはディレクトリのパス
- `dst` - リモートピア上の宛先パス

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SCP_from()`
- `wolfSSH_SCP_connect()`

### wolfSSH_SCP_from()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_from(WOLFSSH* ssh, const char* src, const char* dst);
```

**説明**

リモートのファイルまたはディレクトリ `src` をピアから取得（ダウンロード）し、
SSH 接続を通じてローカルの宛先 `dst` に書き込みます。クライアント側で呼び出し
ます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `src` - リモートピア上のソースファイルまたはディレクトリのパス
- `dst` - ローカルシステム上の宛先パス

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SCP_to()`
- `wolfSSH_SCP_connect()`

### wolfSSH_SetScpErrorMsg()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SetScpErrorMsg(WOLFSSH* ssh, const char* message);
```

**説明**

セッションにカスタムのエラーメッセージ文字列を設定します。この文字列は、SCP 転送
が失敗したときにピアへ報告されます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `message` - 報告する NULL 終端のエラーメッセージ

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  SCP コールバック

アプリケーションが管理するストレージで SCP を使用する場合（例えばファイルシステム
のないシステム上や、転送をフィルタリングする場合）、アプリケーションは送信および
受信のコールバックを登録します。各コールバックにはユーザーコンテキストポインター
を渡すことができます。

### wolfSSH_SetScpRecv()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpRecv(WOLFSSH_CTX* ctx, WS_CallbackScpRecv cb);
```

**説明**

コンテキストに SCP 受信コールバックを登録します。このコールバックは受信ファイル
が受け取られる際に呼び出され、アプリケーション自身がデータを保存できるようにし
ます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - SCP 受信コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetScpRecvCtx()`
- `wolfSSH_SetScpSend()`

### wolfSSH_SetScpSend()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpSend(WOLFSSH_CTX* ctx, WS_CallbackScpSend cb);
```

**説明**

コンテキストに SCP 送信コールバックを登録します。このコールバックはピアがファイル
を要求した際に呼び出され、アプリケーション自身がデータを供給できるようにします。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cb` - SCP 送信コールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_SetScpSendCtx()`
- `wolfSSH_SetScpRecv()`

### wolfSSH_SetScpRecvCtx()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpRecvCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

SCP 受信コールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - 受信コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetScpRecvCtx()`

### wolfSSH_SetScpSendCtx()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpSendCtx(WOLFSSH* ssh, void* ctx);
```

**説明**

SCP 送信コールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - 送信コールバックに渡すユーザーコンテキストポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_GetScpSendCtx()`

### wolfSSH_GetScpRecvCtx()

```c
#include <wolfssh/wolfscp.h>

void* wolfSSH_GetScpRecvCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetScpRecvCtx() で以前に設定されたユーザーコンテキストポインターを返し
ます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- SCP 受信コンテキストポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetScpRecvCtx()`

### wolfSSH_GetScpSendCtx()

```c
#include <wolfssh/wolfscp.h>

void* wolfSSH_GetScpSendCtx(WOLFSSH* ssh);
```

**説明**

wolfSSH_SetScpSendCtx() で以前に設定されたユーザーコンテキストポインターを返し
ます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- SCP 送信コンテキストポインター。設定されていない場合は `NULL`

**関連項目**

- `wolfSSH_SetScpSendCtx()`
