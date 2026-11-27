#  コールバック関数設定API

以下の関数を使って、ユーザー認証コールバック関数の設定を行います。

##  ユーザ認証コールバック関数の設定
```
void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx , WS_CallbackUserAuth
cb );
```
コールバック関数は、wolfSSH セッションオブジェクトを作成するために使用される WOLFSSH_CTX オブジェクトに設定されます。この CTX を使用するすべてのセッションは同じコールバック関数を使用します。このコンテキストは、コールバック関数のコンテキストと混同しないでください。

##  ユーザ認証コールバックコンテキストデータの設定
```
void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh , void* ctx );
```
それぞれの wolfSSH セッションはそれ自身のユーザ認証コンテキストデータを持っているか、あるいはいくつかを共有することもできます。wolfSSH ライブラリはこのコンテキストデータの内容について何も感知しません。データの作成、解放、および必要に応じた排他制御の提供は、アプリケーションの責任です。コールバックはライブラリからこのコンテキストデータを受け取ります。

##  ユーザ認証コールバックコンテキストデータの取得
```
void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh );
```
提供された wolfSSH セッションに保存されたユーザ認証コンテキストデータへのポインターを返します。これはセッションを作成するために使用される wolfSSH のコンテキストデータと混同しないよう注意してください。

## Keyboard-Interactive プロンプトの設定

Keyboard-Interactive のプロンプト専用のコールバックはありません。前章で説明したとおり、サーバーは `authType` に `WOLFSSH_USERAUTH_KEYBOARD_SETUP` を指定してユーザ認証コールバックを呼び出し、クライアントに送信するプロンプトを取得します。Keyboard-Interactive 認証には `--enable-keyboard-interactive`（`WOLFSSH_KEYBOARD_INTERACTIVE`）を指定したビルドが必要です。

## 許可する認証タイプのコールバック関数の設定
```
void wolfSSH_SetUserAuthTypes(WOLFSSH_CTX* ctx, WS_CallbackUserAuthTypes cb);
```

このオプションのコールバックは、サーバーが継続可能な認証タイプとしてクライアントに提示する認証タイプのセットを、`WOLFSSH_USERAUTH_*` タイプ定数のビットマスクとして返します。このコールバックがない場合、サーバーはパスワード、公開鍵、および組み込まれている場合は keyboard-interactive を提示します。

## ユーザ認証結果コールバック関数の設定
```
void wolfSSH_SetUserAuthResult(WOLFSSH_CTX* ctx, WS_CallbackUserAuthResult cb);
void wolfSSH_SetUserAuthResultCtx(WOLFSSH* ssh, void* userAuthResultCtx);
```

このオプションのコールバックには、ライブラリによる公開鍵ユーザ認証署名のチェック結果が通知されます。成功が通知された際に `WS_SUCCESS` 以外の値を返すと、その認証試行は失敗になります。

## 最大認証試行回数の設定
```
int wolfSSH_CTX_SetMaxAuthAttempts(WOLFSSH_CTX* ctx, int value);
int wolfSSH_SetMaxAuthAttempts(WOLFSSH* ssh, int value);
```

サーバーは、ユーザ認証にこの回数失敗したクライアントを切断します。デフォルトは `DEFAULT_MAX_AUTH_ATTEMPTS`（6）です。0 以下の値を指定するとデフォルトに戻ります。

##  Echoserver サンプルプログラムのユーザ認証

サンプルの echoserver は、パスワードと公開鍵を使用してサンプルユーザーとの認証コールバックを実装しています。コールバックの例である wsUserAuth は、wolfSSH コンテキストに設定されています:
```
wolfSSH_SetUserAuth(ctx, wsUserAuth);
```
パスワードファイルの例（passwd.txt）は、それぞれコロンで区切られたユーザー名とパスワードの単純なリストです。このファイル内に存在するデフォルトは次のとおりです。

```   
jill:upthehill
jack:fetchapail
```
公開鍵ファイルは、ssh-keygen を 2 回実行して得た公開鍵出力を連結したものです。

```
ssh-rsa AAAAB3NzaC1yc...d+JI8wrAhfE4x hansel
ssh-rsa AAAAB3NzaC1yc...UoGCPIKuqcFMf gretel
```
すべてのユーザー認証データは、ユーザー名と、パスワードまたは公開鍵 blob の SHA-256 ハッシュのペアをリンクリスト形式で格納されています。

設定ファイル内の公開鍵 blob は Base64 エンコードされており、ハッシュ前にデコードされます。ユーザ名 - ハッシュペアのリストへのポインターは新しい wolfSSH セッションに保存されます:
```
wolfSSH_SetUserAuthCtx(ssh, &pwMapList);
```
コールバック関数は、最初に authType が公開鍵かパスワードかを調べ、そうでない場合は一般ユーザー認証失敗エラーコードを返します。次に、authData を介して渡された公開鍵またはパスワードをハッシュします。ユーザー名をリスト中から検索し、見つけられない場合は無効ユーザーエラーコードを返します。ユーザー名が見つかった場合には、渡された公開鍵またはパスワードの計算ハッシュとペアに格納されているハッシュを比較します。一致した場合、関数は成功を返します。それ以外の場合、無効なパスワードまたは公開鍵のエラーコードを返します。
