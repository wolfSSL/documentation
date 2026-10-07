# wolfSSH 追加 API リファレンス

この章では、wolfSSH の残りのパブリックインターフェイス、すなわち ssh-agent
フォワーディング、鍵生成、ロギング、証明書マネージャー（Windows 証明書ストアの
ヘルパーを含む）、およびプラットフォーム移植レイヤーについて説明します。

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

新しい ssh-agent コンテキストを割り当て、その乱数生成器を含めて初期化します。

**引数**

- `heap` - メモリ割り当てに使用するヒープへのポインター。または `NULL`

**戻り値**

- 新しいエージェントコンテキストへのポインター。割り当てまたは乱数生成器の初期化に
  失敗した場合は `NULL`

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
または無効にします。各セッションは、作成時にこの設定をコピーします。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `isEnabled` - エージェントフォワーディングを有効にするには非ゼロ、無効にする
  には 0

**戻り値**

- `WS_SUCCESS`
- `ctx` が `NULL` の場合は `WS_SSH_CTX_NULL_E`

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
- `ssh` が `NULL` の場合は `WS_SSH_NULL_E`

**関連項目**

- `wolfSSH_CTX_AGENT_enable()`

### wolfSSH_AGENT_ChannelOpen()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_ChannelOpen(WOLFSSH* ssh);
```

**説明**

サーバー側の関数です。クライアントの "auth-agent-req@openssh.com" チャネル要求で
エージェントフォワーディングが要求された後、クライアントへの
"auth-agent@openssh.com" チャネルをオープンします。サーバーがその要求を受け付けるのは、
wolfSSH_CTX_set_agent_cb() でエージェントコールバックが設定されている場合のみです。
デフォルトの経路では、wolfSSH_accept() 自身がチャネルをオープンします。自身でチャネルを
駆動するアプリケーション（wolfSSH_CTX_SetAppChannels() を参照）は、代わりにこの関数を
ポーリングします。

この関数はセッションごとに最大 1 つのチャネルをオープンします。チャネルがオープンされた
後の呼び出しは、キューに残っている出力をフラッシュするだけです。成功時には、
`WOLFSSH_AGENT_LOCAL_SETUP` を指定してエージェントコールバックを呼び出します。
`WS_SUCCESS` はオープン要求が送信されたことを意味し、ピアがそれを受け入れたことを
意味するものではありません。拒否はチャネルオープン失敗コールバックに報告されます。
オープン要求の送信後に（例えばハイウォーターコールバックの失敗によって）エラーが発生
した場合でも、チャネルはオープンされたままとなり、次の呼び出しは `WS_SUCCESS` を
返します。

結果を `ssh->error` に記録するのは送信経路のみです。ピアがフォワーディングを要求する
前に呼び出された場合は、エラーを記録せずに `WS_BAD_ARGUMENT` を返すため、そのセッション
を引き続き wolfSSH_accept() に渡すことができます。

**引数**

- `ssh` - wolfSSH セッションへのポインター

**戻り値**

- チャネルオープンが送信された場合は `WS_SUCCESS`
- 出力がまだキューに残っている間は `WS_WANT_READ` または `WS_WANT_WRITE`。再度
  呼び出してください
- クライアントセッションの場合、またはピアがエージェントフォワーディングを要求する
  前の場合は `WS_BAD_ARGUMENT`
- セッションが切断された後は `WS_FATAL_ERROR`（`ssh->error` は `WS_DISCONNECT` を
  保持します）
- `ssh` が `NULL` の場合は `WS_SSH_NULL_E`
- エージェントコンテキストまたはチャネルを割り当てられない場合は `WS_MEMORY_E`
- 送信によって報告されたその他の負のエラーコード

**関連項目**

- `wolfSSH_AGENT_RelayChannel()`
- `wolfSSH_CTX_set_agent_cb()`

### wolfSSH_AGENT_Relay()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_Relay(WOLFSSH* ssh,
        const byte* msg, word32* msgSz, byte* rsp, word32* rspSz);
```

**説明**

1 つのエージェントプロトコルメッセージをローカルエージェントへ中継し、エージェントの
応答を返します。`msg` 内のメッセージは、エージェント I/O コールバックを通じてそのまま
エージェントに書き込まれるため、4 バイトの長さプレフィックスを含む完全なエージェント
メッセージである必要があります。何も書き込めなかった場合、この関数は再接続のために
`WOLFSSH_AGENT_LOCAL_SETUP` を指定してエージェントコールバックを呼び出し、もう一度だけ
試みます。その後、4 バイトの長さプレフィックスを含むエージェントの応答全体を 1 つ
読み取り、`rsp` にコピーします。入力時 `rspSz` は `rsp` バッファのサイズを保持し、
出力時には書き込まれた応答のサイズを保持します。長さが 0、または
`WOLFSSH_AGENT_MAX_MSG_SZ`（デフォルトでは 262144 バイト）を超えると宣言された応答は
拒否されます。

セッションはエージェントコンテキストを持っている必要があります。クライアント側では、
エージェントフォワーディングが有効な場合に wolfSSH_connect() がこれを作成します。
データが分割されて到着するエージェントチャネルには、代わりに
wolfSSH_AGENT_RelayChannel() を使用してください。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `msg` - 中継するエージェントメッセージ
- `msgSz` - メッセージのサイズへのポインター
- `rsp` - エージェントの応答を受け取るバッファ
- `rspSz` - 入力時は応答バッファのサイズ、出力時は応答のサイズが設定される

**戻り値**

- `WS_SUCCESS`
- 何らかの失敗時は `WS_ERROR`。`ssh` が `NULL` でない場合、具体的なエラーはセッション
  に保存され、wolfSSH_get_error() で取得できます。考えられるエラーには
  `WS_AGENT_NULL_E`（エージェントコンテキストがない）、`WS_BAD_ARGUMENT`、
  `WS_AGENT_CXN_FAIL`（エージェント I/O が失敗した）、`WS_BUFFER_E`（応答が範囲外、
  または `rsp` に収まらない）があります。

**関連項目**

- `wolfSSH_AGENT_RelayChannel()`

### wolfSSH_AGENT_RelayChannel()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_RelayChannel(WOLFSSH* ssh, word32 channelId);
```

**説明**

フォワードされたエージェントチャネル `channelId` とローカルエージェントとの間で、
完全なエージェントメッセージを受け渡します。各呼び出しでは、すでにバッファリング
されているチャネルデータを読み取り、それを完全なエージェントメッセージに区切り、各
メッセージをエージェント I/O コールバックを通じてエージェントに書き込み、各応答を
チャネル上で送り返します。不完全な要求や未完了の応答は呼び出し間で保持されるため、
いずれかを完了するには同じ `channelId` を再度渡す必要があります。異なる `channelId`
が渡された場合、以前のチャネル用に保持されていたバイトは破棄されます。エージェント
コンテキストがまだ初期状態の場合、この関数はまず `WOLFSSH_AGENT_LOCAL_SETUP` を指定
してエージェントコールバックを呼び出します。

一般的なクライアントは、読み取りがエージェントチャネルについて `WS_CHAN_RXD` を報告
したとき（チャネル ID は wolfSSH_GetLastRxId() から取得できます）にこの関数を呼び
出し、応答がまだ未送信である間は再度呼び出します。

応答が未送信の間、戻り値はそれを妨げているものを示します。`WS_WANT_WRITE` は
トランスポートを、`WS_WINDOW_FULL` または `WS_REKEYING` はピアを意味します。
`WS_SUCCESS` を返すまで、この関数を再度呼び出してください。それ以外の成功以外の
コードが返された場合、チャネルは使用できなくなります。

**引数**

- `ssh` - wolfSSH セッションへのポインター
- `channelId` - エージェントチャネルのローカル ID

**戻り値**

- バッファリングされたすべての要求が中継され、その応答が送信された場合は
  `WS_SUCCESS`
- 応答がまだ未送信である間は `WS_WANT_WRITE`、`WS_WINDOW_FULL`、または
  `WS_REKEYING`。再度呼び出してください
- `ssh` が `NULL` の場合は `WS_SSH_NULL_E`
- セッションにエージェントコンテキストがない場合は `WS_AGENT_NULL_E`
- エージェントへの接続またはエージェント I/O が失敗した場合は `WS_AGENT_CXN_FAIL`
- メッセージが宣言する長さが 0、または `WOLFSSH_AGENT_MAX_MSG_SZ` を超える場合は
  `WS_BUFFER_E`
- 指定された ID のチャネルがない場合は `WS_INVALID_CHANID`
- 失敗時はその他の負のエラーコード

**関連項目**

- `wolfSSH_AGENT_Relay()`
- `wolfSSH_AGENT_ChannelOpen()`

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
に要求します。生成された署名は `sig` に書き込まれます。この関数は、要求の前に
`WOLFSSH_AGENT_LOCAL_SETUP` を、要求の後に `WOLFSSH_AGENT_LOCAL_CLEANUP` を指定して
エージェントコールバックを呼び出し、エージェント I/O コールバックを使用して要求と
応答をやり取りします。失敗時には `*sigSz` は 0 に設定されます。

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
- `ssh` が `NULL` の場合は `WS_SSH_NULL_E`
- セッションにエージェントコンテキストがない場合は `WS_AGENT_NULL_E`
- `sigSz` が `NULL` の場合は `WS_BAD_ARGUMENT`
- 応答バッファを割り当てられない場合は `WS_MEMORY_E`
- 要求をエージェントに書き込めなかった場合は `WS_AGENT_CXN_FAIL`
- エージェントが応答を返さない場合、署名ではない応答を返した場合、または失敗を
  返した場合は `WS_AGENT_NO_KEY_E`
- 署名が `sig` に収まらない場合は `WS_BUFFER_E`
- 失敗時はその他の負のエラーコード

##  鍵生成関数

これらの関数は SSH 鍵ペアを生成します。使用するには、wolfSSH を鍵生成サポート付き
（`WOLFSSH_KEYGEN`、`./configure --enable-keygen` により有効化）でビルドし、
wolfSSL を鍵生成付き（`WOLFSSL_KEY_GEN`）でビルドする必要があります。対応する
アルゴリズムも有効になっている必要があり、有効でない場合、関数は `WS_NOT_COMPILED`
を返します。wolfCrypt 内部での失敗は `WS_CRYPTO_FAILED` として報告されます。

ML-DSA 関数を使用するには、ML-DSA サポート付きでビルドされた wolfSSL 5.9.2 以降が
必要です。

### wolfSSH_MakeRsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeRsaKey(byte* out, word32 outSz, word32 size, word32 e);
```

**説明**

公開指数 `e` を使用して `size` ビットの RSA 鍵ペアを生成し、DER エンコードされた
秘密鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - RSA 鍵のサイズ（ビット単位、例えば 2048）
- `e` - RSA 公開指数（例えば 65537）

**戻り値**

- 成功時は書き込まれたバイト数
- RSA が無効な場合は `WS_NOT_COMPILED`
- 鍵の生成またはエンコードに失敗した場合は `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeEcdsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEcdsaKey(byte* out, word32 outSz, word32 size);
```

**説明**

指定された `size`（ビット単位、例えば NIST P-256 の場合 256）の曲線に対する ECDSA
鍵ペアを生成し、DER エンコードされた秘密鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - ECC 曲線のサイズ（ビット単位、例えば 256、384、または 521）

**戻り値**

- 成功時は書き込まれたバイト数
- ECDSA が無効な場合は `WS_NOT_COMPILED`
- 鍵の生成またはエンコードに失敗した場合は `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_MakeRsaKey()`
- `wolfSSH_MakeEd25519Key()`

### wolfSSH_MakeEd25519Key()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEd25519Key(byte* out, word32 outSz, word32 size);
```

**説明**

Ed25519 鍵ペアを生成し、DER エンコードされた秘密鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `size` - 鍵のサイズ（ビット単位、Ed25519 の場合 256）

**戻り値**

- 成功時は書き込まれたバイト数
- Ed25519 の鍵生成が利用できない場合は `WS_NOT_COMPILED`
- 鍵の生成またはエンコードに失敗した場合は `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeMlDsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeMlDsaKey(byte* out, word32 outSz, word32 level);
```

**説明**

指定されたセキュリティレベルで ML-DSA（FIPS 204）鍵ペアを生成し、DER エンコード
された秘密鍵を `out` に書き込みます。

**引数**

- `out` - 生成された鍵を受け取るバッファ
- `outSz` - 出力バッファのサイズ
- `level` - ML-DSA パラメーターセット: `WOLFSSH_MLDSAKEY_44`、
  `WOLFSSH_MLDSAKEY_65`、または `WOLFSSH_MLDSAKEY_87`

**戻り値**

- 成功時は書き込まれたバイト数
- `level` が上記の値のいずれでもない場合は `WS_BAD_ARGUMENT`
- ML-DSA が利用できない場合は `WS_NOT_COMPILED`
- スモールスタック用のメモリ割り当てに失敗した場合は `WS_MEMORY_E`
- 鍵の生成またはエンコードに失敗した場合は `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_MakeMlDsaCompositeKey()`

### wolfSSH_MakeMlDsaCompositeKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeMlDsaCompositeKey(byte* out, word32 outSz,
        word32 level, word32 tradType);
```

**説明**

ML-DSA 鍵と従来型の署名鍵を組み合わせたコンポジット鍵ペアを生成します。結果は、
NUL 終端された暗号化なしの PEM 形式の OpenSSH 秘密鍵
（"-----BEGIN OPENSSH PRIVATE KEY-----"）として、空のコメント付きで `out` に書き込ま
れます。ML-DSA 側はシードとして格納されます。

`level` と `tradType` の組み合わせとして受け付けられるのは、次のもののみです。

- `WOLFSSH_MLDSAKEY_44` と `WOLFSSH_COMPOSITE_TRAD_ED25519` または
  `WOLFSSH_COMPOSITE_TRAD_ECDSA`（NIST P-256）
- `WOLFSSH_MLDSAKEY_65` と `WOLFSSH_COMPOSITE_TRAD_ED25519` または
  `WOLFSSH_COMPOSITE_TRAD_ECDSA`（NIST P-256）
- `WOLFSSH_MLDSAKEY_87` と `WOLFSSH_COMPOSITE_TRAD_ED448` または
  `WOLFSSH_COMPOSITE_TRAD_ECDSA`（NIST P-384）

必要なバッファサイズを問い合わせるには、`out` に `NULL` を渡します。

**引数**

- `out` - PEM エンコードされた鍵を受け取るバッファ。またはサイズを問い合わせる場合は
  `NULL`
- `outSz` - 出力バッファのサイズ
- `level` - ML-DSA パラメーターセット: `WOLFSSH_MLDSAKEY_44`、
  `WOLFSSH_MLDSAKEY_65`、または `WOLFSSH_MLDSAKEY_87`
- `tradType` - 従来型アルゴリズム: `WOLFSSH_COMPOSITE_TRAD_ECDSA`、
  `WOLFSSH_COMPOSITE_TRAD_ED25519`、または `WOLFSSH_COMPOSITE_TRAD_ED448`

**戻り値**

- 成功時は、終端の NUL を含む書き込まれたバイト数
- `out` が `NULL` の場合は、終端の NUL を含む必要なバッファサイズ
- `level` と `tradType` の組み合わせがサポートされていない場合は `WS_BAD_ARGUMENT`
- ML-DSA または要求されたコンポジットアルゴリズムがコンパイルされていない場合は
  `WS_NOT_COMPILED`
- `outSz` が小さすぎる場合は `WS_BUFFER_E`
- メモリ割り当てに失敗した場合は `WS_MEMORY_E`
- 鍵の生成またはエンコードに失敗した場合は `WS_CRYPTO_FAILED`

**関連項目**

- `wolfSSH_MakeMlDsaKey()`

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
テキストとともに受け取るコールバックを登録します。`NULL` を渡すと、現在の
コールバックがそのまま維持されます。`WOLFSSH_NO_DEFAULT_LOGGING_CB` 付きのビルドには
デフォルトのコールバックがないため、コールバックが登録されるまで何も出力されません。

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

現在ロギングが有効かどうかを報告します。ロギングはデフォルトでは無効であり、
wolfSSH_Debugging_ON() で有効になります。ロギングサポートなしのビルドでは常に 0 を
返します。

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

フォーマットされたメッセージは `WOLFSSH_DEFAULT_LOG_WIDTH` バイト（デフォルトでは
終端の NUL を含めて 120）に切り詰められます。メッセージがロギングコールバックに渡さ
れる前に、タブ以外の制御文字および DEL は `?` に置き換えられます。そのため、`%s` で
ログに出力される信頼できない文字列によって、ログに改行や端末エスケープシーケンスが
挿入されることはありません。

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

### wolfSSH_SetCertManager()

```c
#include <wolfssh/certman.h>

int wolfSSH_SetCertManager(WOLFSSH_CTX* ctx, struct WOLFSSL_CERT_MANAGER* cm);
```

**説明**

コンテキストが使用する wolfSSL 証明書マネージャーを `cm` に置き換えます。この関数は
`cm` への参照を取得し、以前のマネージャーへの参照を解放します。呼び出し元は自身の
参照を保持し、引き続きその解放に責任を持ちます。

wolfSSH は共有されたマネージャーを変更します。OCSP サポート付き（`HAVE_OCSP`）の
ビルドでは、`cm` に対して `WOLFSSL_OCSP_CHECKALL` を有効にするため、そのマネージャーを
TLS にも使用する呼び出し元では、すべてのチェーンで OCSP 応答が必要になります。証明書
認証の際、wolfSSH は検証済みのピアの中間 CA を、信頼されたルートとしてマネージャーに
永続的に追加します。稼働中の TLS スタックと共有するマネージャーではなく、wolfSSH 専用
のマネージャーを使用してください。

すでに使用中のマネージャーを渡すと、OCSP ポリシーが再度適用されるだけで、それ以外は
何も変わりません。`WS_FATAL_ERROR` の場合は何も変更されていません。コンテキストは
以前のマネージャーを保持し、`cm` にはポリシーが適用されていません。

**利用可能性**

wolfSSH を証明書サポート付き（`WOLFSSH_CERTS`）でビルドする必要があります。
wolfSSL 4.6.0 以降が必要です。それより古いバージョンでは、この関数は引数にかかわらず
`WS_NOT_COMPILED` を返します。

**引数**

- `ctx` - wolfSSH コンテキストへのポインター
- `cm` - 使用する wolfSSL 証明書マネージャー

**戻り値**

- `WS_SUCCESS`
- `ctx` または `cm` が `NULL` の場合、あるいはコンテキストが証明書マネージャーを
  持たない場合は `WS_BAD_ARGUMENT`
- 参照を取得できない場合、または `cm` で OCSP を有効にできない場合は
  `WS_FATAL_ERROR`
- wolfSSL が 4.6.0 より古い場合は `WS_NOT_COMPILED`

**関連項目**

- `wolfSSH_CERTMAN_VerifyCerts_buffer()`

### wolfSSH_CERTMAN_new()

```c
#include <wolfssh/certman.h>

WOLFSSH_CERTMAN* wolfSSH_CERTMAN_new(void* heap);
```

**説明**

新しい wolfSSL 証明書マネージャーを基盤とする、新しい証明書マネージャーを割り当てて
初期化します。OCSP サポート付き（`HAVE_OCSP`）のビルドでは、チェーン内のすべての
証明書に対する OCSP チェック（`WOLFSSL_OCSP_CHECKALL`）がそのマネージャーで有効に
なります。

**引数**

- `heap` - メモリ割り当てに使用するヒープへのポインター。または `NULL`

**戻り値**

- 新しい証明書マネージャーへのポインター。OCSP を有効にできない場合を含め、失敗時は
  `NULL`

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
れたルートは、ピアから提示された証明書を検証するために使用されます。証明書は DER
エンコードされている必要があります。

**引数**

- `cm` - 証明書マネージャー
- `rootCa` - DER エンコードされたルート CA 証明書を含むバッファ
- `rootCaSz` - ルート CA バッファのサイズ

**戻り値**

- `WS_SUCCESS`
- `cm` または `rootCa` が `NULL` の場合、あるいは `rootCaSz` が 0 の場合は
  `WS_BAD_ARGUMENT`
- 証明書を読み込めない場合は wolfSSL のエラーコード

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
込まれたルート CA に対して検証します。バッファには、4 バイトのビッグエンディアンの
長さが前置された DER エンコードの各証明書が、リーフを先頭に、続いて中間証明書の順で
格納されます。ルート CA は省略できます。チェーンに含めることができる証明書は最大
`MAX_CHAIN_DEPTH` 個（wolfSSL が定義していない場合は 9）です。

証明書はチェーンの末尾からリーフに向かって検証されます。OCSP サポート付きのビルドでは、
各証明書は OCSP でもチェックされます。デフォルトのレスポンダーが設定されていない場合、
OCSP レスポンダーの URL を持たない証明書は失効していないものとして扱われます。検証
された中間証明書のうち CA であるものは、次の証明書が署名者を持てるように、信頼された
ルートとして証明書マネージャーに追加されます。この追加は永続的です。CA ではない中間
証明書があると、チェーンの検証は失敗します。

リーフは CA ではなく、エンドエンティティ証明書である必要があります。その後、この関数は
すべてのビルドで RFC 6187 セクション 2.2 のリーフチェックを適用します。KeyUsage 拡張
が存在する場合は digitalSignature を表明している必要があり、ExtendedKeyUsage 拡張が
存在する場合は anyExtendedKeyUsage、または検証対象の SSH の役割に使用できる用途を
含んでいる必要があります。ユーザー証明書（サーバーが検証）の場合、その用途は
id-kp-secureShellClient または TLS clientAuth であり、ホスト証明書（クライアントが
検証）の場合は id-kp-secureShellServer または TLS serverAuth です。役割は証明書
マネージャーを所有するコンテキストから決まり、wolfSSH_CERTMAN_new() で作成された
単独のマネージャーはどちらも受け付けます。FPKI プロファイル照合付きのビルド（つまり
`WOLFSSH_NO_FPKI` なしのビルド）では、リーフがサポートされている FPKI プロファイルの
いずれかに一致することも必要です。

**引数**

- `cm` - 証明書マネージャー
- `cert` - 長さが前置された証明書チェーンを含むバッファ
- `certSz` - 証明書バッファのサイズ
- `certCount` - チェーン内の証明書の数

**戻り値**

- `WS_SUCCESS`
- `cm` または `cert` が `NULL` の場合、`certCount` が 0 の場合、または `certCount`
  が `MAX_CHAIN_DEPTH` を超える場合は `WS_BAD_ARGUMENT`
- メモリ割り当てに失敗した場合は `WS_MEMORY_E`
- 証明書の長さがバッファの末尾を超える場合は `ASN_PARSE_E`
- 証明書に信頼された署名者がない場合、または中間証明書が CA ではない場合は
  `WS_CERT_NO_SIGNER_E`
- 証明書の有効期限が切れている場合は `WS_CERT_EXPIRED_E`
- 証明書の署名を検証できない場合は `WS_CERT_SIG_CONFIRM_E`
- OCSP が証明書を失効済みと報告した場合は `WS_CERT_REVOKED_E`
- リーフの KeyUsage または ExtendedKeyUsage がその役割での SSH 使用を許可しない場合
  は `WS_CERT_KEY_USAGE_E`
- リーフが CA である場合、または FPKI プロファイルに一致しない場合は
  `WS_CERT_PROFILE_E`
- その他の検証または OCSP の失敗の場合は `WS_CERT_OTHER_E`

**関連項目**

- `wolfSSH_CERTMAN_LoadRootCA_buffer()`

### wolfSSH_CertStoreLocationFromName()

**利用可能性**

wolfSSH を証明書サポートおよび Windows 証明書ストアサポート付き（`WOLFSSH_CERTS`
および `WOLFSSH_WINDOWS_CERT_STORE`、
`./configure --enable-certs --enable-windows-cert-store` により有効化）でビルドした
場合に利用可能です。

```c
#include <wolfssh/certman.h>

int wolfSSH_CertStoreLocationFromName(const char* in, word32* out);
```

**説明**

Windows システム証明書ストアの場所の名前を解析し、対応する `CERT_SYSTEM_STORE_*` の
値に変換します。受け付けられる名前は `CURRENT_USER`、`LOCAL_MACHINE`、`USERS`、
`CURRENT_SERVICE`、`SERVICES`、`CURRENT_USER_GROUP_POLICY`、
`LOCAL_MACHINE_GROUP_POLICY`、`LOCAL_MACHINE_ENTERPRISE`、およびこれらに
`CERT_SYSTEM_STORE_` プレフィックスを付けた名前です。場所は 10 進数、または 0x
プレフィックス付きの 16 進数で指定することもできます。数値は数字で始まり、全体が
数値として解釈される必要があります。先頭の符号や空白は拒否され、先頭の 0 は 8 進数
ではなく 10 進数として読み取られます。受け付けられるのは割り当て済みのストアの場所
のみであり、制御フラグは受け付けられません。

**引数**

- `in` - NUL 終端の場所の名前または数値
- `out` - `CERT_SYSTEM_STORE_*` の値を受け取る

**戻り値**

- `WS_SUCCESS`
- `in` または `out` が `NULL` の場合、`in` が空の場合、または `in` が有効な場所で
  ない場合は `WS_BAD_ARGUMENT`

**関連項目**

- `wolfSSH_ParseCertStoreSpec()`

### wolfSSH_ParseCertStoreSpec()

**利用可能性**

wolfSSH を証明書サポートおよび Windows 証明書ストアサポート付き（`WOLFSSH_CERTS`
および `WOLFSSH_WINDOWS_CERT_STORE`）でビルドした場合に利用可能です。

```c
#include <wolfssh/certman.h>

int wolfSSH_ParseCertStoreSpec(const char* spec,
        wchar_t** wStoreName, wchar_t** wSubjectName,
        word32* dwFlags, void* heap);
```

**説明**

`store:subject[:flags]` 形式の証明書ストア指定を、ストア名、サブジェクト名、ストアの
場所に分割します。指定は最初の 2 つのコロンで分割されるため、ストア名とサブジェクトの
どちらにもコロンを含めることはできず、3 つ目のコロンは拒否されます。例えば
"My:CN=host:65536" は、ストア "My"、サブジェクト "CN=host"、フラグ 65536 となります。
省略可能な `flags` フィールドには、wolfSSH_CertStoreLocationFromName() が受け付ける
任意の表記を指定でき、デフォルトは `CURRENT_USER` です。ストア名とサブジェクトは
UTF-8 から、新たに割り当てられたワイド文字列に変換されます。不正な UTF-8 は拒否され
ます。

成功時には、呼び出し元が 2 つのワイド文字列を所有し、同じ `heap` を指定して
wolfSSH_FreeCertStoreSpec() で解放する必要があります。失敗時には、`NULL` でない
`wStoreName` および `wSubjectName` の出力ポインターは `NULL` に設定され、`dwFlags`
は変更されません。

**引数**

- `spec` - NUL 終端の指定文字列
- `wStoreName` - 割り当てられたストア名を受け取る
- `wSubjectName` - 割り当てられたサブジェクト名を受け取る
- `dwFlags` - ストアの場所の値を受け取る
- `heap` - 割り当てに使用するヒープ

**戻り値**

- `WS_SUCCESS`
- 引数が `NULL` の場合、または指定の形式が不正な場合は `WS_BAD_ARGUMENT`
- メモリ割り当てに失敗した場合は `WS_MEMORY_E`
- UTF-8 からワイド文字列への変換に失敗した場合は `WS_FATAL_ERROR`

**関連項目**

- `wolfSSH_FreeCertStoreSpec()`
- `wolfSSH_CertStoreLocationFromName()`

### wolfSSH_FreeCertStoreSpec()

**利用可能性**

wolfSSH を証明書サポートおよび Windows 証明書ストアサポート付き（`WOLFSSH_CERTS`
および `WOLFSSH_WINDOWS_CERT_STORE`）でビルドした場合に利用可能です。

```c
#include <wolfssh/certman.h>

void wolfSSH_FreeCertStoreSpec(wchar_t* wStoreName, wchar_t* wSubjectName,
        void* heap);
```

**説明**

wolfSSH_ParseCertStoreSpec() が返した文字列を解放します。どちらのポインターも `NULL`
で構いません。`heap` は wolfSSH_ParseCertStoreSpec() に渡したものと同じである必要が
あります。

**引数**

- `wStoreName` - 解放するストア名。または `NULL`
- `wSubjectName` - 解放するサブジェクト名。または `NULL`
- `heap` - 割り当てに使用したヒープ

**戻り値**

なし

**関連項目**

- `wolfSSH_ParseCertStoreSpec()`

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

文字列 `s2` を `s1` 内の文字列の末尾に追加します。`n` は `s1` を保持するバッファ全体
のサイズです。追加は全部行われるか、まったく行われないかのどちらかです。`s2` が終端の
NUL を含めて残りの領域に収まらない場合、何も追加されません。`s1` の先頭 `n` バイト
以内に NUL 終端が見つからない場合、この関数は何も書き込まずに失敗します。

**引数**

- `s1` - 追加先の文字列。その場で追加される
- `s2` - 追加するソース文字列
- `n` - `s1` バッファ全体のサイズ（バイト単位）

**戻り値**

- 成功時は追加先の文字列 `s1` へのポインター
- `s2` が収まらない場合、または `s1` が `n` バイト以内で終端されていない場合は
  `NULL`

### wstrdup()

```c
#include <wolfssh/port.h>

char* wstrdup(const char* s1, void* heap, int type);
```

**説明**

文字列 `s1` を複製します。複製は指定された `heap` から割り当てられます。`s1` が
`NULL` の場合は `NULL` を返します。

**引数**

- `s1` - 複製する文字列
- `heap` - 割り当てに使用するヒープ
- `type` - 割り当てタイプのヒント

**戻り値**

- 複製された文字列へのポインター。失敗時は `NULL`

### WS_FindFirstFileA()

**利用可能性**

SCP または SFTP サポート付きの Windows ビルド（`USE_WINDOWS_API`）で利用可能です。
ただし、`WOLFSSH_SCP_USER_CALLBACKS` が定義されている場合を除きます。

```c
#include <wolfssh/port.h>

void* WS_FindFirstFileA(const char* fileName,
        char* realFileName, size_t realFileNameSz, int* isDir, void* heap);
```

**説明**

`fileName` に対するディレクトリ列挙を開始し、検索ハンドルと最初に一致したエントリ
を返します。`isDir` には、そのエントリがディレクトリかどうかを示す値が設定され
ます。ドライブ文字の前にある先頭のパス区切り文字（"/C:/dir" のような SFTP パスの
場合）は、検索の前に取り除かれます。ハンドルは Windows の検索ハンドルです。

**引数**

- `fileName` - 列挙するディレクトリまたは検索パターン
- `realFileName` - 一致したファイル名を受け取るバッファ
- `realFileNameSz` - `realFileName` バッファのサイズ
- `isDir` - エントリがディレクトリの場合に非ゼロが設定される出力。または `NULL`
- `heap` - 割り当てに使用するヒープ

**戻り値**

- 成功時は不透明な検索ハンドル
- 失敗時は `INVALID_HANDLE_VALUE`

**関連項目**

- `WS_FindNextFileA()`

### WS_FindNextFileA()

**利用可能性**

SCP または SFTP サポート付きの Windows ビルド（`USE_WINDOWS_API`）で利用可能です。
ただし、`WOLFSSH_SCP_USER_CALLBACKS` が定義されている場合を除きます。

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
- これ以上エントリがない場合、またはエントリ名を `realFileName` に収まるマルチバイト
  文字列に変換できなかった場合は 0

**関連項目**

- `WS_FindFirstFileA()`

### wstrsep()

**利用可能性**

Windows ビルド（`USE_WINDOWS_API`）で利用可能です。その他のプラットフォームでは、
`WSTRSEP()` マクロを通じて C ライブラリの `strsep()` を使用します。

```c
#include <wolfssh/port.h>

char* wstrsep(char** s1, const char* delim);
```

**説明**

Microsoft C ランタイムおよび MinGW が提供していない BSD の `strsep()` 関数の代替
です。`*s1` 内で `delim` に含まれる最初の文字を見つけ、それを NUL に置き換えてその場
でトークンを終端し、`*s1` をその次の位置に進めます。区切り文字が残っていない場合、
`*s1` は `NULL` に設定されます。移植性のあるコードでは `WSTRSEP()` マクロを呼び出す
べきです。このマクロは、必要に応じて `strsep()` またはこの関数に対応付けられます。

**引数**

- `s1` - 分割する文字列ポインターへのポインター。トークンの次の位置を指すように
  更新される
- `delim` - NUL 終端の区切り文字の集合

**戻り値**

- トークンの先頭へのポインター
- `*s1` がすでに `NULL` だった場合は `NULL`
