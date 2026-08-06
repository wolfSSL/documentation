#  wolfSSH ユーザ認証コールバック

wolfSSH はライブラリがどのような環境に組み込まれていようが、サーバに接続しようとするユーザ
を認証できなければなりません。テキストファイル、データベース、またはアプリケーシ
ョンにハードコードされているパスワードまたは RSA 公開鍵を使用してユーザーを検索/認証する必要があります。

wolfSSH は、ユーザ認証メッセージで提供されたユーザ名、パスワードまたは公開鍵、
および要求された認証タイプを受け取るコールバックフックを提供します。その後、コー
ルバック関数は適切な検索を実行して応答を返します。ユーザはそのためのコールバック
を提供する必要があります。

コールバック関数は失敗を示すエラーコードあるいは成功のいずれかを返さなければなりません。ライブラリは全ての失敗をロギング目的を除いて同一に扱います。すなわち、ユーザー認証失敗メッセージを再試行するクライアントに返信します。

パスワード検索を行う場合には平文のパスワードがコールバック関数に渡されます。ユーザー名とパスワードは一致するか検査され成功を返します。成功時にはSSHハンドシェークはただちに続行されます。現時点ではパスワードの変更はサポートされません。

公開鍵検索では、クライアントからの公開鍵blob(バイナリデータ) がコールバック関数に渡されます。
公開鍵はサーバーの有効なクライアント公開鍵のリストと照合されます。提供された公開
鍵がそのユーザーの既知の公開鍵と一致する場合。 wolfSSH ライブラリは
RFC4252§7 に記述されたプロセスに従ってユーザー認証署名の実際の検証を実行しま
す。

一般に公開鍵の場合、サーバーは ssh-keygen ユーティリティによって生成されたユーザ
ーの公開鍵を保存するか、または公開鍵のフィンガープリントを保存します。ユーザーに
とってのこの値は比較の対象になるものです。クライアントはその秘密鍵を使用してセッション
ID の署名とユーザー認証要求メッセージを提供します。サーバーは公開鍵を使用してこの
署名を検証します。

##  コールバック関数プロトタイプ

ユーザ認証コールバック関数プロトタイプは次の通りです：
```
int UserAuthCb(byte authType , const WS_UserAuthData*
authData , void* ctx );
```
この関数プロトタイプのタイプは：

```
WS_CallbackUserAuth
```
パラメータ `authType` は:

```
WOLFSSH_USERAUTH_PASSWORD
```

か、あるいは

```
WOLFSSH_USERAUTH_PUBLICKEY
```

です。

パラメータ authData　は認証データへのポインタです。

WS_UserAuthData　の詳細は5.4を参照してください。

パラメータ **ctx** はアプリケーション定義のコンテキストです。 wolfSSH はコンテキスト
内のデータについては何の知識も持たず何も操作しません。コールバック関数へのコンテキストポイ
ンタを提供するだけです。

##  コールバック関数の認証タイプ定数

以下はユーザー認証コールバック関数に渡される`authType`パラメータの値です。この値によってコールバック関数に認証データのタイプを伝えます。システムはユーザー毎にパスワードか公開鍵かの利用を指定することができます。

```
WOLFSSH_USERAUTH_PASSWORD
WOLFSSH_USERAUTH_KEYBOARD
WOLFSSH_USERAUTH_PUBLICKEY
```

##  コールバック関数の戻り値定数

以下は、コールバック関数がライブラリに返すリターンコードです。 失敗コードはコー
ルバックはチェックを行うことができず、何もしなかったことを示します。

以下のコードはユーザー認証が拒否された理由を示しています：

```
invalid username
invalid password
invalid public key
```
サーバーはクライアントに _成功_ または _失敗_ を示し、特定の失敗タイプはロギングに
のみ使用されます。コールバックがライブラリに返せる特別な成功と失敗の応答として
_partial-success_（部分的成功）があります。これは、その認証タイプは成功したが、完
全に認証するには別の認証タイプがまだ必要であることを意味します。サーバーは partial-success
フラグをセットしたユーザー認証失敗メッセージをクライアントに送信します。

```
WOLFSSH_USERAUTH_SUCCESS
WOLFSSH_USERAUTH_FAILURE
WOLFSSH_USERAUTH_INVALID_USER
WOLFSSH_USERAUTH_INVALID_PASSWORD
WOLFSSH_USERAUTH_INVALID_PUBLICKEY
WOLFSSH_USERAUTH_PARTIAL_SUCCESS
WOLFSSH_USERAUTH_SUCCESS_ANOTHER
```

##  コールバック関数のデータタイプ

クライアントデータは、`WS_UserAuthData` という構造体でコールバック関数に渡され
ます。 メッセージ内のデータへのポインタが含まれています。 この構造体には共通フィールドを持ちます。メソッド固有のフィールドは、ユーザー認証データ内の構造体の union にあります。

```
typedef struct WS_UserAuthData {
    byte authType ;
    byte* username ;
    word32 usernameSz ;
    byte* serviceName ;
    word32 serviceNameSz ;
    union {
        WS_UserAuthData_Password password ;
        WS_UserAuthData_PublicKey publicKey ;
        WS_UserAuthData_Keyboard keyboard ;
    } sf;
} WS_UserAuthData;
```

### パスワード

username および usernameSz パラメータは、クライアントによって提供されるユーザ名とオクテット単位のサイズです。

password フィールドと passwordSz フィールドは、クライアントのパスワードとそのオクテット単位のサイズです。

クライアントから提供された場合は設定されますが、パラメータ hasNewPassword、newPassword、および newPasswordSz は使用されません。 現時点でクライアントにパスワードを変更するように指示するメカニズムはありません。

```
typedef struct WS_UserAuthData_Password {
    uint8_t* password ;
    uint32_t passwordSz ;
    uint8_t hasNewPasword ;
    uint8_t* newPassword ;
    uint32_t newPasswordSz ;
} WS_UserAuthData_Password;
```

### Keyboard-Interactive

Keyboard-Interactive モードでは、サーバーからクライアントへ任意の数のプロンプトと
レスポンスをやり取りできます。情報を格納する構造体は次の通りです：

```c
typedef struct WS_UserAuthData_Keyboard {
    word32 promptCount;
    word32 responseCount;
    word32 promptNameSz;
    word32 promptInstructionSz;
    word32 promptLanguageSz;
    byte* promptName;
    byte* promptInstruction;
    byte* promptLanguage;
    word32* promptLengths;
    word32* responseLengths;
    byte* promptEcho;
    byte** responses;
    byte** prompts;
} WS_UserAuthData_Keyboard;
```

クライアント側では、認証中に `promptName` と `promptInstruction` が認証に関する情
報をユーザーに示します。 `promptLanguage` フィールドは API の非推奨部分であり、無
視されます。

`promptCount` はプロンプトがいくつあるかを示します。 `prompts` はプロンプトの配列
を保持し、`promptLengths` は `prompts` 内の各プロンプトの長さを保持する配列です。
`promptEcho` は、各プロンプトのレスポンスをユーザーが入力する際にエコー表示するか
どうかを示すブール値の配列です。

逆に、`responseCount` は与えられるレスポンスの数を設定します。 `responses` と
`responseLengths` はプロンプトに対するレスポンスデータを保持します。

サーバーは `wolfSSH_SetKeyboardAuthPrompts()` コールバックを使用してプロンプトを設
定できます。 `WS_CallbackKeyboardAuthPrompts` コールバックは `promptCount`、
`prompts`、`promptLengths`、`promptEcho` を設定する必要があります。 その他の
`prompt*` 項目はオプションです。

サーバーは、後続のリクエスト/レスポンスのラウンドを実行するために、
`WS_CallbackUserAuth` コールバックから `WOLFSSH_USERAUTH_SUCCESS_ANOTHER` を返す必
要があります。

###  公開鍵

wolfSSH は複数の公開鍵アルゴリズムをサポートします。 publicKeyType メンバは、使用されているアルゴリズム名を指します。

publicKey フィールドは、クライアントから提供された公開鍵blob を指します。

公開鍵の確認には 1 つまたは 2 つのステップがあります。 hasSignature フィー
ルドが設定されていない場合、署名はありません。 ユーザー名と publicKey が正しいこ
とを確認してください。 この手順は、クライアントの設定によってはオプションであ
り、無効なユーザーによる高価な公開鍵操作の実行を防ぐことができます。 次に、
hasSignature フィールドが設定され、signature フィールドがクライアントの署名を指
します。 また、ユーザー名と publicKey も確認する必要があります。 wolfSSH は自動
的に署名を確認します。

各フィールドはオクテットのサイズ値を持ちます。

```
typedef struct WS_UserAuthData_PublicKey {
    byte* publicKeyType;
    word32 publicKeyTypeSz;
    byte* publicKey;
    word32 publicKeySz;
    byte hasSignature;
    byte* signature;
    word32 signatureSz;
} WS_UserAuthData_PublicKey;
```
