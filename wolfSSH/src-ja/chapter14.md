# wolfSSH SFTP API リファレンス

##  接続関数



### wolfSSH_SFTP_accept()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_accept(WOLFSSH* ssh);
```

**説明**

クライアントからの受信 SFTP 接続要求を処理します。SSH セッションが確立された後、
サーバー側で呼び出します。

**引数**

- `ssh` - 接続に使用する wolfSSH セッションへのポインター

**戻り値**

- 成功時は `WS_SFTP_COMPLETE`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_connect()`
- `wolfSSH_SFTP_negotiate()`

### wolfSSH_SFTP_connect()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_connect(WOLFSSH* ssh);
```

**説明**

サーバーへの SFTP 接続を開始します。SSH セッションが確立された後、クライアント側で
呼び出します。

**引数**

- `ssh` - 接続に使用する wolfSSH セッションへのポインター

**戻り値**

- 成功時は `WS_SFTP_COMPLETE`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_negotiate()`

### wolfSSH_SFTP_negotiate()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_negotiate(WOLFSSH* ssh);
```

**説明**

SFTP プロトコルのネゴシエーションを実行します。セッションがどちら側のために作成
されたかに応じて、クライアントからの受信接続を処理するか、サーバーへ接続要求を
送信します。

**引数**

- `ssh` - 接続に使用する wolfSSH セッションへのポインター

**戻り値**

- 成功時は `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_connect()`


### wolfSSH_SFTP_SetDefaultPath()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SetDefaultPath(WOLFSSH* ssh, const char* path);
```

**説明**

SFTP セッションのデフォルト（開始）ディレクトリを設定します。サーバー側では、これは
相対パスを解決する際の基準となるベースディレクトリです。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `path` - 設定するデフォルトパス

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  プロトコルレベル関数



### wolfSSH_SFTP_RealPath()



```c
#include <wolfssh/wolfsftp.h>

WS_SFTPNAME* wolfSSH_SFTP_RealPath(WOLFSSH* ssh, char* dir);
```

**説明**

ピアに REALPATH 要求を送信し、ファイルまたはディレクトリの正規名を返します。返された
`WS_SFTPNAME` は wolfSSH_SFTPNAME_free() で解放する必要があります。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - 解決するファイル名またはディレクトリ名

**戻り値**

- 成功時は `WS_SFTPNAME` 構造体へのポインター
- エラー時は `NULL`

**関連項目**

- `wolfSSH_SFTPNAME_free()`

### wolfSSH_SFTP_Close()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Close(WOLFSSH* ssh, byte* handle, word32 handleSz);
```

**説明**

指定されたファイルハンドルについて、ピアにクローズ要求を送信します。このハンドルは、
以前の wolfSSH_SFTP_Open() の呼び出しから取得したものです。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `handle` - クローズするファイルハンドル
- `handleSz` - ハンドルバッファのサイズ

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_Open()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Open(WOLFSSH* ssh, char* dir, word32 reason,
        WS_SFTP_FILEATRB* atr, byte* handle, word32* handleSz);
```

**説明**

`dir` で指定された名前のファイルについて、ピアにオープン要求を送信します。成功時、
得られたファイルハンドルが `handle` に格納され、そのサイズが `handleSz` に書き込ま
れます。`reason` 引数はオープンフラグのビットマスクで、`WOLFSSH_FXF_READ`、
`WOLFSSH_FXF_WRITE`、`WOLFSSH_FXF_APPEND`、`WOLFSSH_FXF_CREAT`、`WOLFSSH_FXF_TRUNC`、
`WOLFSSH_FXF_EXCL` のいずれかです。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - オープンするファイルの名前
- `reason` - オープンフラグのビットマスク（上記を参照）
- `atr` - 初期ファイル属性
- `handle` - 得られたファイルハンドルの出力バッファ
- `handleSz` - 入力時はバッファのサイズ、出力時はハンドルのサイズが設定される

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_Close()`
- `wolfSSH_SFTP_SendReadPacket()`
- `wolfSSH_SFTP_SendWritePacket()`

### wolfSSH_SFTP_SendReadPacket()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SendReadPacket(WOLFSSH* ssh, byte* handle,
        word32 handleSz, const word32* ofst, byte* out, word32 outSz);
```

**説明**

`handle`（wolfSSH_SFTP_Open() から取得）が参照するファイルについて、ピアに読み取り
要求を送信します。読み取られたバイトは `out` バッファに格納されます。`ofst` 引数は、
読み取りを開始するファイルオフセットを指します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `handle` - 読み取り元のファイルハンドル
- `handleSz` - ハンドルバッファのサイズ
- `ofst` - 読み取りを開始するファイルオフセットへのポインター
- `out` - 読み取ったデータを保持するバッファ
- `outSz` - 出力バッファのサイズ

**戻り値**

- 0 以上 - 成功時に読み取ったバイト数
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_SendWritePacket()`
- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_SendWritePacket()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SendWritePacket(WOLFSSH* ssh, byte* handle,
        word32 handleSz, const word32* ofst, byte* out, word32 outSz);
```

**説明**

`handle`（wolfSSH_SFTP_Open() から取得）が参照するファイルについて、ピアに書き込み
要求を送信し、`out` バッファの内容を書き込みます。`ofst` 引数は、書き込みを行う
ファイルオフセットを指します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `handle` - 書き込み先のファイルハンドル
- `handleSz` - ハンドルバッファのサイズ
- `ofst` - 書き込みを開始するファイルオフセットへのポインター
- `out` - ピアに送信するデータのバッファ
- `outSz` - バッファのサイズ

**戻り値**

- 0 以上 - 成功時に書き込んだバイト数
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_SendReadPacket()`
- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_STAT()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_STAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**説明**

ファイルまたはディレクトリの属性を取得するために、ピアに STAT 要求を送信します。
シンボリックリンクをたどります。対象が存在しない場合、ピアはエラーを返し、この関数は
エラー値を返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - ファイルまたはディレクトリの NULL 終端の名前
- `atr` - 得られた属性を受け取る構造体

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_LSTAT()`
- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_LSTAT()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_LSTAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**説明**

ファイルまたはディレクトリの属性を取得するために、ピアに LSTAT 要求を送信します。
wolfSSH_SFTP_STAT() とは異なり、LSTAT はシンボリックリンクをたどらず、リンク自体の
属性を返します。対象が存在しない場合、ピアはエラーを返し、この関数はエラー値を
返します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - ファイルまたはディレクトリの NULL 終端の名前
- `atr` - 得られた属性を受け取る構造体

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_STAT()`
- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_SetSTAT()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SetSTAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**説明**

`atr` の属性（例えばパーミッション、サイズ、タイムスタンプ）を指定されたファイル
またはディレクトリに適用するために、ピアに SETSTAT 要求を送信します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - ファイルまたはディレクトリの NULL 終端の名前
- `atr` - 適用する属性

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_STAT()`

### wolfSSH_SFTPNAME_free()

```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTPNAME_free(WS_SFTPNAME* n);
```

**説明**

単一の `WS_SFTPNAME` ノードを解放します。ノードがリストの途中にある場合、それを解放
するとリストが壊れます。リスト全体を解放するには wolfSSH_SFTPNAME_list_free() を使用
してください。

**引数**

- `n` - 解放する `WS_SFTPNAME` ノード

**戻り値**

なし

**関連項目**

- `wolfSSH_SFTPNAME_list_free()`

### wolfSSH_SFTPNAME_list_free()

```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTPNAME_list_free(WS_SFTPNAME* n);
```

**説明**

wolfSSH_SFTP_LS() が返すリストのような、`WS_SFTPNAME` ノードのリスト全体を解放し
ます。

**引数**

- `n` - 解放する `WS_SFTPNAME` リストの先頭

**戻り値**

なし

**関連項目**

- `wolfSSH_SFTPNAME_free()`

##  Reget / Reput 関数

### wolfSSH_SFTP_SaveOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SaveOfst(WOLFSSH* ssh, char* frm, char* to,
        const word32* ofst);
```

**説明**

中断された get または put の転送オフセットを、ソース（`frm`）と宛先（`to`）のパスを
キーとして保存します。保存されたオフセットは、後で wolfSSH_SFTP_GetOfst() により
取得できます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `frm` - NULL 終端のソースパス
- `to` - NULL 終端の宛先パス
- `ofst` - 保存するオフセットへのポインター

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_GetOfst()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_GetOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_GetOfst(WOLFSSH* ssh, char* frm, char* to,
        word32* ofst);
```

**説明**

中断された get または put について、ソース（`frm`）と宛先（`to`）のパスをキーとして
保存された転送オフセットを取得し、`ofst` に書き込みます。保存されたオフセットが
見つからない場合、`ofst` は 0 に設定されます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `frm` - NULL 終端のソースパス
- `to` - NULL 終端の宛先パス
- `ofst` - 保存されたオフセットの出力

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_ClearOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_ClearOfst(WOLFSSH* ssh);
```

**説明**

セッションについて保存されているすべての転送オフセットをクリアします。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_GetOfst()`

### wolfSSH_SFTP_Interrupt()



```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTP_Interrupt(WOLFSSH* ssh);
```

**説明**

進行中の get または put の転送を停止するために、セッションに割り込みフラグを設定
します。転送を後で再開できるように、現在のオフセットを wolfSSH_SFTP_SaveOfst() で
保存できます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

なし

**関連項目**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_GetOfst()`

##  コマンド関数



### wolfSSH_SFTP_Remove()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Remove(WOLFSSH* ssh, char* f);
```

**説明**

`f` で指定された名前のファイルを削除するために、ピアに remove 要求を送信します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `f` - 削除するファイルの NULL 終端の名前

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_RMDIR()`

### wolfSSH_SFTP_MKDIR()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_MKDIR(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**説明**

`dir` で指定された名前のディレクトリを作成するために、ピアに mkdir 要求を送信します。
`atr` 属性は現在使用されておらず、代わりにデフォルトの属性が適用されます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - 作成するディレクトリの NULL 終端の名前
- `atr` - 新しいディレクトリの属性（現在は未使用）

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_RMDIR()`

### wolfSSH_SFTP_RMDIR()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_RMDIR(WOLFSSH* ssh, char* dir);
```

**説明**

`dir` で指定された名前のディレクトリを削除するために、ピアに rmdir 要求を送信します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - 削除するディレクトリの NULL 終端の名前

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_MKDIR()`

### wolfSSH_SFTP_Rename()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Rename(WOLFSSH* ssh, const char* old, const char* nw);
```

**説明**

ピアに rename 要求を送信し、ファイル `old` を `nw` に名前変更します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `old` - 現在のファイル名
- `nw` - 新しいファイル名

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_Remove()`

### wolfSSH_SFTP_LS()



```c
#include <wolfssh/wolfsftp.h>

WS_SFTPNAME* wolfSSH_SFTP_LS(WOLFSSH* ssh, char* dir);
```

**説明**

`dir` 内のファイルとディレクトリを一覧表示します。これは REALPATH、OPENDIR、READDIR、
CLOSE の各操作を実行する高レベルのヘルパーです。返されたリストは
wolfSSH_SFTPNAME_list_free() で解放する必要があります。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `dir` - 一覧表示するディレクトリ

**戻り値**

- 成功時は `WS_SFTPNAME` 構造体のリストへのポインター
- 失敗時は `NULL`

**関連項目**

- `wolfSSH_SFTPNAME_list_free()`
- `wolfSSH_SFTP_RealPath()`

### wolfSSH_SFTP_CHMOD()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_CHMOD(WOLFSSH* ssh, char* n, char* oct);
```

**説明**

ファイルまたはディレクトリ `n` のパーミッションビットを、8 進文字列 `oct`（例えば
"644"）で指定されたモードに変更します。新しいパーミッションを含む SETSTAT 要求を送信
することで実装されています。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `n` - ファイルまたはディレクトリの NULL 終端の名前
- `oct` - 8 進のパーミッション文字列（例えば "755"）

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_Get()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Get(WOLFSSH* ssh, char* from, char* to,
        byte resume, WS_STATUS_CB* statusCb);
```

**説明**

ピアからローカルパスへファイルをダウンロードします。これは LSTAT、OPEN、READ、CLOSE
の各操作を実行する高レベルのヘルパーです。進行中の転送は wolfSSH_SFTP_Interrupt() で
中断できます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `from` - 取得するリモートファイルの名前
- `to` - ファイルを書き込むローカルパス
- `resume` - 以前に中断した転送を再開するには非ゼロ、それ以外は 0
- `statusCb` - 転送の進捗とともに呼び出されるコールバック。または `NULL`

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_Put()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_Put()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Put(WOLFSSH* ssh, char* from, char* to,
        byte resume, WS_STATUS_CB* statusCb);
```

**説明**

ローカルファイルをピアへアップロードします。これは OPEN、WRITE、CLOSE の各操作を
実行する高レベルのヘルパーです。進行中の転送は wolfSSH_SFTP_Interrupt() で中断でき
ます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `from` - 送信するローカルファイルの名前
- `to` - ファイルを書き込むリモートパス
- `resume` - 以前に中断した転送を再開するには非ゼロ、それ以外は 0
- `statusCb` - 転送の進捗とともに呼び出されるコールバック。または `NULL`

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_Get()`
- `wolfSSH_SFTP_Interrupt()`

##  SFTP サーバー関数



### wolfSSH_SFTP_read()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_read(WOLFSSH* ssh);
```

**説明**

サーバー側 SFTP のメインエントリポイントです。I/O バッファから読み取り、受信した
SFTP パケットの種類に基づいて適切な内部ハンドラーへディスパッチします。SFTP 要求を
処理するために、サーバーループからこれを呼び出します。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_PendingSend()`

### wolfSSH_SFTP_PendingSend()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_PendingSend(WOLFSSH* ssh);
```

**説明**

SFTP レイヤーに、送信待ちのバッファされた送出データがあるかどうかを報告します。これ
は、非ブロッキング I/O を駆動する際に、もう一度送信を試みる必要があることを知るのに
役立ちます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- 送信待ちのデータがある場合は非ゼロ
- 送信待ちのデータがない場合は 0

**関連項目**

- `wolfSSH_SFTP_read()`
