# wolfSSH SCP API リファレンス

この章では、wolfSSH における SCP（Secure Copy）ファイル転送のパブリック
アプリケーションプログラミングインターフェイスについて説明します。

この章のすべての関数を使用するには、wolfSSH を SCP サポート付き
（`WOLFSSH_SCP`、`./configure --enable-scp` により有効化）でビルドする必要が
あります。クライアント側の転送関数 wolfSSH_SCP_connect()、wolfSSH_SCP_to()、
wolfSSH_SCP_from() は、クライアントがコンパイル対象から除外されている場合
（`NO_WOLFSSH_CLIENT`）には利用できません。SCP はクライアントのみのビルドでも
利用できます。

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

### wolfSSH_SCP_accept()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_accept(WOLFSSH* ssh);
```

**説明**

サーバー側の関数です。"exec scp ..." コマンドがすでにバインドされたチャネルを持つ
セッション上で SCP 転送を実行します。これは、wolfSSH_accept() が `WS_SCP_INIT` を
返した後に再度呼び出されたときに行う処理と同じです。この関数は、アプリケーション駆動
チャネルを使用するアプリケーションなど、`scp` コマンドを自身でチャネルにバインドする
アプリケーションが転送を開始できるように公開されています。1 つの転送に対しては、
この関数か wolfSSH_accept() の経路のどちらか一方のみを使用し、両方を使用しないで
ください。

wolfSSH_accept() が戻り、exec チャネル要求コールバックが SCP コマンドを報告した後に
呼び出してください。そのコールバックの内部からは呼び出さないでください。
wolfSSH_SFTP_accept() と同様に、セッションのチャネルリストの最初のチャネルに対して
動作します。SCP 受信コールバックが設定されている必要があります。
`WOLFSSH_SCP_USER_CALLBACKS` が定義されていない限り、新しいコンテキストには
デフォルトのコールバックがインストールされます。

ノンブロッキングソケットでは、転送が途中の状態で `WS_WANT_READ` または
`WS_WANT_WRITE` を返します。`WS_SCP_COMPLETE` を返すまで、同じセッションに対して
再度呼び出してください。セッションに記録された保留中の `WS_WANT_READ` または
`WS_WANT_WRITE` は、各呼び出しの開始時にクリアされます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 転送が完了した場合は `WS_SCP_COMPLETE`
- 転送を再開する必要がある場合は `WS_WANT_READ` または `WS_WANT_WRITE`
- `ssh` が `NULL` の場合、または SCP 受信コールバックが設定されていない場合は
  `WS_BAD_ARGUMENT`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_ChannelCommandIsScp()`
- `wolfSSH_SetScpRecv()`
- `wolfSSH_SetScpSend()`

### wolfSSH_ChannelCommandIsScp()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_ChannelCommandIsScp(const WOLFSSH_CHANNEL* channel);
```

**説明**

`channel` に記録されたセッションコマンドが SCP 転送を開始するものかどうかを報告
します。exec チャネル要求コールバックから使用することを想定しています。
wolfSSH_accept() も同じ判定を使用するため、何が転送を開始するかについて
アプリケーションとライブラリの判断が食い違うことはありません。

コマンドは、独立したトークンとしての "scp" で始まる必要があります。つまり、コマンド
全体が "scp" であるか、"scp" の後に空白が続く必要があります。"scpbackup" のような
単純なプレフィックス一致は SCP コマンドではありません。判定は文字列長ではなく記録
されたコマンドサイズを対象とし、そのサイズ内のどこかに NUL バイトを含むコマンドは
SCP コマンドとして扱われません。転送を処理するパーサーは C 文字列を読み取るため、
残りの部分を黙って切り捨ててしまうからです。

**引数**

- `channel` - セッションコマンドを判定するチャネル

**戻り値**

- コマンドが SCP 転送を開始する場合は 1
- 開始しない場合は 0（チャネルにコマンドがない場合を含む）
- `channel` が `NULL` の場合は `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_SCP_accept()`

### wolfSSH_SetScpErrorMsg()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SetScpErrorMsg(WOLFSSH* ssh, const char* message);
```

**説明**

セッションにカスタムのエラーメッセージ文字列を設定します。この文字列は、SCP 転送
が失敗したときにピアへ報告されます。SCP コールバックの内部から呼び出すことを想定
しています。メッセージはコピーされるため、`message` の所有権は呼び出し元が保持します。
後の呼び出しは以前のメッセージを置き換えます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `message` - 報告する NULL 終端のエラーメッセージ

**戻り値**

- `WS_SUCCESS`
- `ssh` または `message` が `NULL` の場合は `WS_BAD_ARGUMENT`
- コピーのためのメモリを確保できない場合は `WS_MEMORY_E`

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

コールバックは、`buf` に格納したバイト数、`WS_SCP_*` ステータスコードのいずれか、
または転送を中止するための負のエラーを返します。引数 `fileNameSz` は `fileName`
バッファの容量であり、すでに格納されている名前の長さではありません。0 を返すことが
有効なのは、データの準備が整う前にファイルのメタデータ（名前、モード、時刻、
`totalFileSz`）を設定する呼び出しの場合のみです。その場合、ライブラリはファイル
ヘッダーを送信し、`WOLFSSH_SCP_CONTINUE_FILE_TRANSFER` を指定してコールバックを再度
呼び出します。`fileOffset` が `totalFileSz` に達していない状態で 2 回続けて 0 が
返されると、コールバックが停止したものとみなされ、転送は中止されます。API には
"現時点ではデータなし" を表すステータスがないためです。データを待つ必要がある
コールバックは、0 を返すのではなくブロックしてください。

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
