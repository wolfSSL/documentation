# wolfSSH 追加 API リファレンス

この章では、wolfSSH の残りのパブリックインターフェイス、すなわち ssh-agent
フォワーディング、鍵生成、ロギング、証明書マネージャー、およびプラットフォーム
移植レイヤーについて説明します。

##  SSH エージェント関数

これらの関数は ssh-agent フォワーディングをサポートします。使用するには、wolfSSH
をエージェントサポート付き（`WOLFSSH_AGENT`、`./configure --enable-agent` により
有効化）でビルドする必要があります。

### wolfSSH_AGENT_new()

```c
#include <wolfssh/agent.h>

WOLFSSH_AGENT_CTX* wolfSSH_AGENT_new(void* heap);
```

**説明**

新しい ssh-agent コンテキストを割り当てて初期化します。

**引数**

- `heap` - メモリ割り当てに使用するヒープへのポインター。または `NULL`

**戻り値**

- 新しいエージェントコンテキストへのポインター。失敗時は `NULL`

**関連項目**

- `wolfSSH_AGENT_free()`

### wolfSSH_AGENT_free()

```c
#include <wolfssh/agent.h>

void wolfSSH_AGENT_free(WOLFSSH_AGENT_CTX* agent);
```

**説明**

wolfSSH_AGENT_new() で以前に割り当てられた ssh-agent コンテキストを解放します。

**引数**

- `agent` - 解放するエージェントコンテキスト

**戻り値**

なし

**関連項目**

- `wolfSSH_AGENT_new()`

### wolfSSH_CTX_set_agent_cb()

```c
#include <wolfssh/agent.h>

int wolfSSH_CTX_set_agent_cb(WOLFSSH_CTX* ctx,
        WS_CallbackAgent agentCb, WS_CallbackAgentIO agentIoCb);
```

**説明**

コンテキストにエージェントコールバックとエージェント I/O コールバックを登録し
ます。これらのコールバックにより、アプリケーションはエージェント要求を処理し、
エージェント I/O を実行できます。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `agentCb` - エージェントコールバック
- `agentIoCb` - エージェント I/O コールバック

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_set_agent_cb_ctx()`

### wolfSSH_set_agent_cb_ctx()

```c
#include <wolfssh/agent.h>

int wolfSSH_set_agent_cb_ctx(WOLFSSH* ssh, void* ctx);
```

**説明**

エージェントコールバックに渡されるユーザーコンテキストポインターを設定します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `ctx` - エージェントコールバックに渡すユーザーコンテキストポインター

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_CTX_AGENT_enable()

```c
#include <wolfssh/agent.h>

int wolfSSH_CTX_AGENT_enable(WOLFSSH_CTX* ctx, byte isEnabled);
```

**説明**

コンテキストから作成されるセッションについて、ssh-agent フォワーディングを有効
または無効にします。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `isEnabled` - エージェントフォワーディングを有効にするには非ゼロ、無効にする
  には 0

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_AGENT_enable()`

### wolfSSH_AGENT_enable()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_enable(WOLFSSH* ssh, byte isEnabled);
```

**説明**

単一のセッションについて、ssh-agent フォワーディングを有効または無効にします。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `isEnabled` - エージェントフォワーディングを有効にするには非ゼロ、無効にする
  には 0

**戻り値**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_CTX_AGENT_enable()`

### wolfSSH_AGENT_Relay()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_Relay(WOLFSSH* ssh,
        const byte* msg, word32* msgSz, byte* rsp, word32* rspSz);
```

**説明**

エージェントプロトコルメッセージをエージェントへ中継し、エージェントの応答を返し
ます。入力時 `rspSz` は `rsp` バッファのサイズを保持し、出力時には書き込まれた
応答のサイズを保持します。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `msg` - 中継するエージェントメッセージ
- `msgSz` - メッセージのサイズへのポインター
- `rsp` - エージェントの応答を受け取るバッファ
- `rspSz` - 入力時は応答バッファのサイズ、出力時は応答のサイズが設定される

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

### wolfSSH_AGENT_SignRequest()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_SignRequest(WOLFSSH* ssh,
        const byte* digest, word32 digestSz,
        byte* sig, word32* sigSz,
        const byte* keyBlob, word32 keyBlobSz, word32 flags);
```

**説明**

`keyBlob` で識別される鍵を使用して、指定された `digest` に署名するようエージェント
に要求します。生成された署名は `sig` に書き込まれます。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `digest` - 署名するダイジェスト
- `digestSz` - ダイジェストのサイズ
- `sig` - 署名を受け取るバッファ
- `sigSz` - 入力時は署名バッファのサイズ、出力時は署名のサイズが設定される
- `keyBlob` - どの鍵で署名するかを識別する公開鍵ブロブ
- `keyBlobSz` - 鍵ブロブのサイズ
- `flags` - 署名要求のフラグ

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

##  鍵生成関数

これらの関数は SSH 鍵ペアを生成します。使用するには、wolfSSH を鍵生成サポート付き
（`WOLFSSH_KEYGEN`、`./configure --enable-keygen` により有効化）でビルドし、対応
するアルゴリズムが wolfCrypt で有効になっている必要があります。

### wolfSSH_MakeRsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeRsaKey(byte* out, word32 outSz, word32 size, word32 e);
```

**説明**

公開指数 `e` を使用して `size` ビットの RSA 鍵ペアを生成し、エンコードされた鍵を
`out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - RSA 鍵のサイズ（ビット単位、例えば 2048）
- `e` - RSA 公開指数（例えば 65537）

**戻り値**

- 成功時は書き込まれたバイト数
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeEcdsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEcdsaKey(byte* out, word32 outSz, word32 size);
```

**説明**

指定された `size`（ビット単位、例えば NIST P-256 の場合 256）の曲線に対する ECDSA
鍵ペアを生成し、エンコードされた鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - ECC 曲線のサイズ（ビット単位、例えば 256、384、または 521）

**戻り値**

- 成功時は書き込まれたバイト数
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_MakeRsaKey()`
- `wolfSSH_MakeEd25519Key()`

### wolfSSH_MakeEd25519Key()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEd25519Key(byte* out, word32 outSz, word32 size);
```

**説明**

Ed25519 鍵ペアを生成し、エンコードされた鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - 鍵のサイズ（ビット単位、Ed25519 の場合 256）

**戻り値**

- 成功時は書き込まれたバイト数
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_MakeEcdsaKey()`

##  ロギング関数

これらの関数は wolfSSH のデバッグロギングを制御します。ロギングのコードは、wolfSSH
を `DEBUG_WOLFSSH`（`./configure --enable-debug` により有効化）または `WOLFSSH_SSHD`
付きでビルドした場合にコンパイルされます。

### wolfSSH_SetLoggingCb()

```c
#include <wolfssh/log.h>

void wolfSSH_SetLoggingCb(wolfSSH_LoggingCb logF);
```

**説明**

デフォルトのロギング出力の代わりに、ログメッセージをそのログレベルおよびメッセージ
テキストとともに受け取るコールバックを登録します。

**引数**

- `logF` - ロギングコールバック

**戻り値**

なし

**関連項目**

- `wolfSSH_LogEnabled()`

### wolfSSH_LogEnabled()

```c
#include <wolfssh/log.h>

int wolfSSH_LogEnabled(void);
```

**説明**

現在ロギングが有効かどうかを報告します。

**引数**

なし

**戻り値**

- ロギングが有効な場合は非ゼロ
- ロギングが無効な場合は 0

### wolfSSH_Log()

```c
#include <wolfssh/log.h>

void wolfSSH_Log(enum wolfSSH_LogLevel level, const char* const fmt, ...);
```

**説明**

指定されたレベルで printf 形式のフォーマット済みログメッセージを書き込みます。
ログレベルは、低いものから高いものへ順に `WS_LOG_DEBUG`、`WS_LOG_INFO`、
`WS_LOG_WARN`、`WS_LOG_ERROR`、`WS_LOG_USER`、およびサブシステムごとのレベル
`WS_LOG_SFTP`、`WS_LOG_SCP`、`WS_LOG_AGENT`、`WS_LOG_CERTMAN` です。

**引数**

- `level` - メッセージの `wolfSSH_LogLevel`
- `fmt` - printf 形式のフォーマット文字列
- `...` - フォーマット文字列に対する引数

**戻り値**

なし

**関連項目**

- `wolfSSH_SetLoggingCb()`

##  証明書マネージャー関数

証明書マネージャーは、証明書ベースの認証のために X.509 証明書を検証します。これ
らの関数を使用するには、wolfSSH を証明書サポート付き（`WOLFSSH_CERTS`、
`./configure --enable-certs` により有効化）でビルドする必要があります。

### wolfSSH_CERTMAN_new()

```c
#include <wolfssh/certman.h>

WOLFSSH_CERTMAN* wolfSSH_CERTMAN_new(void* heap);
```

**説明**

新しい証明書マネージャーを割り当てて初期化します。

**引数**

- `heap` - メモリ割り当てに使用するヒープへのポインター。または `NULL`

**戻り値**

- 新しい証明書マネージャーへのポインター。失敗時は `NULL`

**関連項目**

- `wolfSSH_CERTMAN_free()`

### wolfSSH_CERTMAN_free()

```c
#include <wolfssh/certman.h>

void wolfSSH_CERTMAN_free(WOLFSSH_CERTMAN* cm);
```

**説明**

wolfSSH_CERTMAN_new() で以前に割り当てられた証明書マネージャーを解放します。

**引数**

- `cm` - 解放する証明書マネージャー

**戻り値**

なし

**関連項目**

- `wolfSSH_CERTMAN_new()`

### wolfSSH_CERTMAN_LoadRootCA_buffer()

```c
#include <wolfssh/certman.h>

int wolfSSH_CERTMAN_LoadRootCA_buffer(WOLFSSH_CERTMAN* cm,
        const unsigned char* rootCa, word32 rootCaSz);
```

**説明**

信頼されたルート CA 証明書をバッファから証明書マネージャーに読み込みます。読み込ま
れたルートは、ピアから提示された証明書を検証するために使用されます。

**引数**

- `cm` - 証明書マネージャー
- `rootCa` - ルート CA 証明書を含むバッファ
- `rootCaSz` - ルート CA バッファのサイズ

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_CERTMAN_VerifyCerts_buffer()`

### wolfSSH_CERTMAN_VerifyCerts_buffer()

```c
#include <wolfssh/certman.h>

int wolfSSH_CERTMAN_VerifyCerts_buffer(WOLFSSH_CERTMAN* cm,
        const unsigned char* cert, word32 certSz, word32 certCount);
```

**説明**

バッファに含まれる `certCount` 個の証明書のチェーンを、証明書マネージャーに読み
込まれたルート CA に対して検証します。

**引数**

- `cm` - 証明書マネージャー
- `cert` - 証明書チェーンを含むバッファ
- `certSz` - 証明書バッファのサイズ
- `certCount` - チェーン内の証明書の数

**戻り値**

- `WS_SUCCESS`
- 失敗時は負のエラーコード

**関連項目**

- `wolfSSH_CERTMAN_LoadRootCA_buffer()`

##  移植性関数

これらの関数は wolfSSH のプラットフォーム移植レイヤーの一部を構成し、サポートされる
ターゲット間でファイルシステム操作および文字列操作を抽象化します。主に内部的に、
また wolfSSH を新しいプラットフォームに移植する際に使用されます。利用可能な関数の
正確なセットは、ターゲットのビルド構成によって異なります。

### wfopen()

```c
#include <wolfssh/port.h>

int wfopen(WFILE** f, const char* filename, const char* mode);
```

**説明**

移植可能なファイルオープンラッパーです。アクセスモード `mode` を使用して
`filename` を開き、得られたファイルハンドルを `f` に格納します。

**引数**

- `f` - 開かれたファイルハンドルを受け取る
- `filename` - 開くファイルのパス
- `mode` - アクセスモード文字列（C ライブラリの `fopen` と同様）

**戻り値**

- 成功時は 0
- 失敗時は非ゼロ

### wstrnstr()

```c
#include <wolfssh/port.h>

char* wstrnstr(const char* s1, const char* s2, unsigned int n);
```

**説明**

`s1` の先頭 `n` バイト以内で、部分文字列 `s2` が最初に出現する位置を見つけます。

**引数**

- `s1` - 検索対象の文字列
- `s2` - 見つける部分文字列
- `n` - `s1` を検索する最大バイト数

**戻り値**

- `s1` 内で `s2` が最初に出現する位置へのポインター。見つからない場合は `NULL`

### wstrncat()

```c
#include <wolfssh/port.h>

char* wstrncat(char* s1, const char* s2, size_t n);
```

**説明**

文字列 `s2` の最大 `n` バイトを `s1` の末尾に追加します。

**引数**

- `s1` - 追加先の文字列。その場で追加される
- `s2` - 追加するソース文字列
- `n` - 追加する最大バイト数

**戻り値**

- 追加先の文字列 `s1` へのポインター

### wstrdup()

```c
#include <wolfssh/port.h>

char* wstrdup(const char* s1, void* heap, int type);
```

**説明**

文字列 `s1` を複製します。複製は指定された `heap` から割り当てられます。

**引数**

- `s1` - 複製する文字列
- `heap` - 割り当てに使用するヒープ
- `type` - 割り当てタイプのヒント

**戻り値**

- 複製された文字列へのポインター。失敗時は `NULL`

### WS_FindFirstFileA()

**利用可能性**

Windows ビルド（`USE_WINDOWS_API`）で利用可能です。

```c
#include <wolfssh/port.h>

void* WS_FindFirstFileA(const char* fileName,
        char* realFileName, size_t realFileNameSz, int* isDir, void* heap);
```

**説明**

`fileName` に対するディレクトリ列挙を開始し、検索ハンドルと最初に一致したエントリ
を返します。`isDir` には、そのエントリがディレクトリかどうかを示す値が設定され
ます。

**引数**

- `fileName` - 列挙するディレクトリまたは検索パターン
- `realFileName` - 一致したファイル名を受け取るバッファ
- `realFileNameSz` - `realFileName` バッファのサイズ
- `isDir` - エントリがディレクトリの場合に非ゼロが設定される出力
- `heap` - 割り当てに使用するヒープ

**戻り値**

- 成功時は不透明な検索ハンドル、失敗時は `NULL`

**関連項目**

- `WS_FindNextFileA()`

### WS_FindNextFileA()

**利用可能性**

Windows ビルド（`USE_WINDOWS_API`）で利用可能です。

```c
#include <wolfssh/port.h>

int WS_FindNextFileA(void* findHandle,
        char* realFileName, size_t realFileNameSz);
```

**説明**

WS_FindFirstFileA() で開始したディレクトリ列挙を継続し、次に一致したエントリを
返します。

**引数**

- `findHandle` - WS_FindFirstFileA() が返した検索ハンドル
- `realFileName` - 一致したファイル名を受け取るバッファ
- `realFileNameSz` - `realFileName` バッファのサイズ

**戻り値**

- 別のエントリが返された場合は非ゼロ
- これ以上エントリがない場合は 0

**関連項目**

- `WS_FindFirstFileA()`
