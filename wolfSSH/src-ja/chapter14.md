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

アプリケーション駆動チャネルが有効な場合（wolfSSH_CTX_SetAppChannels() または
wolfSSH_SetAppChannels()）、この関数は、アプリケーションのサブシステムコールバックが
"sftp" サブシステムを許可したセッションチャネルのみを処理します。サブシステム名は
"sftp" と完全に一致する必要があります。その許可より前に呼び出された場合は、セッションに
エラーを記録せずに `WS_INVALID_STATE_E` を返します。

**引数**

- `ssh` - 接続に使用する wolfSSH セッションへのポインター

**戻り値**

- 成功時は `WS_SFTP_COMPLETE`
- `ssh` が `NULL` の場合は `WS_BAD_ARGUMENT`
- アプリケーション駆動チャネルモードで sftp サブシステムが許可されていない場合は
  `WS_INVALID_STATE_E`
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

SFTP セッションの開始パスを設定します。開始パスは、セッションが開始するディレクトリ
であり、サーバーが相対的な要求パスを解決する際の基準となります。開始パスはセッションが
どこで開始するかを設定するだけで、アクセスの許可や拒否は一切行いません。セッションが
到達できるパスを制限するには wolfSSH_SFTP_SetConfinePath() を使用します。これは
この設定とは独立しています。

パスは保存される前に正規化されます。相対的な `path` は、プロセスの現在の作業
ディレクトリを基準に解決されます。この関数を再度呼び出すと、以前の開始パスが置き換え
られます。置き換え用のメモリを確保できない場合、既存の開始パスはそのまま残ります。
`NULL` のパスを渡すと現在の設定は変更されず、`WS_SUCCESS` を返します。

クライアントから最初の REALPATH 要求を受信した時点で開始パスが設定されていない場合、
サーバーは開始パスを自身の現在の作業ディレクトリに設定します。これによってセッションが
制限されることはありません。

**注意：** wolfSSH v1.6.0 以降、開始パスはセッションを制限しなくなりました。以前の
リリースでは、デフォルトパスの外側に解決される要求は拒否されていました。その動作に
依存していたアプリケーションは、wolfSSH_SFTP_SetConfinePath() も呼び出す必要が
あります。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `path` - NULL 終端の開始パス。または現在の設定を変更しない場合は `NULL`

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` が `NULL`
- `WS_BUFFER_E` - パス、またはその解決の基準となる作業ディレクトリが
  `WOLFSSH_MAX_FILENAME` に収まらない
- `WS_INVALID_PATH_E` - 現在の作業ディレクトリを読み取れなかった、またはパスを正規化
  できなかった
- `WS_FATAL_ERROR` - メモリ確保に失敗した（`ssh->error` は `WS_MEMORY_E` に設定
  されます）

**関連項目**

- `wolfSSH_SFTP_SetConfinePath()`

### wolfSSH_SFTP_SetConfinePath()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SetConfinePath(WOLFSSH* ssh, const char* path);
```

**説明**

SFTP セッションのサーバー側を、`path` をルートとするディレクトリツリーに制限します。
各要求パスは開始パス（wolfSSH_SFTP_SetDefaultPath() を参照）を基準に解決され、
正規化されます。その結果がルート自体でもルート配下のパスでもない場合、要求は
`WS_PERMISSIONS` で拒否されます。制限ルートが設定されていない場合、またはルートが "/"
の場合、セッションは制限されません。ルートが "/" の場合は、解決結果が絶対パスである
要求のみが受け付けられます。Windows では、プレフィックスの比較は大文字と小文字を区別
しません。

制限と開始パスは互いに独立しています。サーバーは、ジェイルの深い位置でセッションを
開始する（例えば /srv/data/user7 で開始し、/srv/data に制限する）ことも、セッションが
開始する場所を変えずに制限することも、どちらも行わずにオペレーティングシステムの
パーミッションに任せることもできます。wolfSSHd は最後の方法を採用しており、制限ルートを
設定せず、認証されたユーザーに権限を降格します。開始パスは制限ルートの内側に設定して
ください。開始パスがルートの外側にあると、相対的な要求がルートの外側に解決され、
それらの要求は拒否されます。

パスは保存される前に正規化されます。相対的な `path` は、プロセスの現在の作業
ディレクトリを基準に解決されます。この関数を再度呼び出すと、以前のルートが置き換え
られます。`NULL` のパスを渡すと現在の設定は変更されず、`WS_SUCCESS` を返します。

パスは字句的に解決されるため、ジェイル内のシンボリックリンクがジェイル内にとどまる
ことを保証できません。そのため、シンボリックリンクをサポートするビルド
（`WOLFSSH_HAVE_SYMLINK`）では、制限されたセッションは、ルート配下のパスに既存の
シンボリックリンクの構成要素を含むすべての要求を拒否します。リンク先がジェイル内に
とどまるリンクも例外ではありません。まだ存在しない末端要素は許可されるため、作成操作は
引き続き機能します。`WOLFSSH_NO_SYMLINK_CHECK` を定義するとこのチェックが削除され、
それによる脱出防止も失われます。ルート自体は信頼され、チェックされることはないため、
シンボリックリンクを経由して到達するルートは、そのリンク先と同じ範囲になります。
サーバーが管理し、シンボリックリンクの構成要素を含まないルートを使用してください。

シンボリックリンクのチェックは多層防御の一つであり、セキュリティ境界ではありません。
これはチェック時と使用時の間の競合（TOCTOU）の影響を受けるチェックです。ジェイル内で
並行して書き込みを行う者が、操作の実行前にチェック済みの構成要素をリンクに置き換える
可能性があります。悪意のあるテナントが混在するデプロイメントでは、OS レベルのジェイル
（chroot と権限の降格）を使用してください。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `path` - NULL 終端の制限ルート。または現在の設定を変更しない場合は `NULL`

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` が `NULL`
- `WS_BUFFER_E` - パス、またはその解決の基準となる作業ディレクトリが
  `WOLFSSH_MAX_FILENAME` に収まらない
- `WS_INVALID_PATH_E` - 現在の作業ディレクトリを読み取れなかった、またはパスを正規化
  できなかった
- `WS_FATAL_ERROR` - メモリ確保に失敗した（`ssh->error` は `WS_MEMORY_E` に設定
  されます）

**関連項目**

- `wolfSSH_SFTP_SetDefaultPath()`

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
またはディレクトリに適用するために、ピアに SETSTAT 要求を送信します。`atr->flags` で
フラグが設定されている属性のみが送信されます。wolfSSH v1.6.0 以降のサーバーは属性を
適用するか、`SSH_FX_OP_UNSUPPORTED` で応答します。それより前のサーバーは常に
`SSH_FX_OK` で応答していました。

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
取得できます。各パスは `WOLFSSH_MAX_FILENAME` バイトより短くなければなりません。
そうでない場合は `WS_BUFFER_E` を返します。

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
"644"）で指定されたモードに変更します。STAT 要求に続いて、新しいパーミッション
（`WOLFSSH_FILEATRB_PERM`）のみを含む SETSTAT 要求を送信することで実装されています。
ファイルのその他の属性は再送信されません。

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

ピアからローカルパスへファイルをダウンロードします。これは STAT、OPEN、READ、CLOSE
の各操作を実行する高レベルのヘルパーです。進行中の転送は wolfSSH_SFTP_Interrupt() で
中断できます。

`resume` が非ゼロの場合、`from` と `to` の組に対して保存されたオフセット
（wolfSSH_SFTP_SaveOfst() を参照）は、リモートファイルにそのオフセットより先の
バイトがまだあり、かつローカルファイルの長さがちょうどそのバイト数である場合にのみ
使用されます。それ以外の場合、転送は最初からやり直されます。

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

`resume` が非ゼロで、`from` と `to` の組に対してオフセットが保存されている場合、この
関数はまずリモートファイルに対して STAT 要求を送信します。保存されたオフセットは、
ローカルファイルにそのオフセットより先のバイトがまだあり、かつリモートファイルの長さが
ちょうどそのバイト数である場合にのみ使用されます。それ以外の場合、転送は最初から
やり直されます。リモートファイルは、転送がオフセット 0 から開始する場合にのみ
`WOLFSSH_FXF_TRUNC` 付きでオープンされるため、再開された put が宛先を切り詰めることは
ありません。書き込みが拒否された場合、転送は成功を報告せずにエラーで終了します。

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
