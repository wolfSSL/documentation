# 始めよう

wolfSSHのダウンロードとビルドが終わったら、ライブラリの使い方を示す自動テストプログラムとサンプルプログラムが用意されています。

## テスト

###  wolfSSHユニットテスト

wolfSSHのユニットテストはAPIの動作を確認するためのものです。ポジティブ/ネガティブの両テストケースが実行されます。テストはマニュアルで実行することができますが、makeやmake checkコマンドなど他の自動化された処理の一部として実行される場合もあります。`make check`コマンドは、APIテスト（`tests/api.test`）、リグレッションテスト（`tests/regress.test`）、クライアント/サーバーテストスイート（`tests/testsuite.test`）、鍵交換テスト（`tests/kex.test`）も実行します。

全てのサンプルプログラムとテストはwolfSSHのホームディレクトリから実行されなければなりません。実行時に必要な各種証明書と鍵をテストツールが見つけることができるようにするためです。

ユニットテストをマニュアルで実行するには次のようにします:
```
$ ./tests/unit.test
```
あるいは
```
$ make check (autoconfが使われている場合)
```

### テストに関する注記事項

レポジトリをクローンした後、テスト用の秘密鍵はユーザーにとってリードオンリーになっていることを確認してください。そうなっていない場合はsshクライアントがそうするように警告します。
```
$ chmod 0600 ./keys/gretel-key-rsa.pem ./keys/hansel-key-rsa.pem \
             ./keys/gretel-key-ecc.pem ./keys/hansel-key-ecc.pem
```

サンプルプログラムechoserverに対しての認証はパスワードあるいは公開鍵を使って行うことができます。パスワードを使う場合は次のコマンドを使ってください:
```
$ ssh -p 22222 USER@localhost
```

ここで_USER_としてのユーザーとそのパスワードとして次の２つのペアが使えます:
```
jill:upthehill
jack:fetchapail
```

公開鍵を使った認証を行う場合には次のコマンドを使います:
```
$ ssh -i ./keys/USER-key-TYPE.pem -p 22222 USER@localhost
```

ここで、_USER_の部分にはgretelかhanselが指定でき、TYPEにはrsaかeccを指定します。echoserverはデフォルトではRSA鍵を受け付けます。代わりにECC鍵を受け付けるには、オプション`-e`を指定してください。

echoserverはそのwsUserAuthコールバック関数に複数の偽のアカウント(jack, jill, hansel, とgretel）を用意してあります。後述するシェルサポートが有効になっている場合には、これらの偽アカウントは機能しません。これらのアカウントはシステムのパスワードファイルに存在しないためです。ユーザー認証は成功しますが、システム上にこれらのアカウントが存在しないためサーバー側でエラーになります。echoserverのパスワードリストあるいは公開鍵リストに自分自身のユーザー名を追加することができます。追加されたアカウントでは、echoserverによって起動されたシェルにechoserverを起動したユーザーの権限でログインすることができます。

## サンプルプログラム

###  wolfSSH echoserver

echoserverサンプルプログラムはwolfSSHのサンプルプログラム中で最も多くの処理をこなすプログラムです。もともとは用意されたアカウントのいずれかで認証を行い、入力された文字を繰り返し出力するだけのものでした。後のセクションで説明するシェルサポートを有効にすると、ユーザーシェルを起動することができます。その場合、マシン上の実際のユーザー名と、そのクレデンシャルを検証するために更新されたユーザー認証コールバック関数が必要になります。echoserverはSCPおよびSFTP接続も扱うことができます。ターミナルから次を実行してください:
```
    $ ./examples/echoserver/echoserver -f
```

`-f` オプションはエコーバックだけを行うモードを有効にします。別のターミナルから次を実行してください:
```
    $ ssh jill@localhost -p 22222
```

パスワードの入力を求められたら"upthehill"と入力してください。サーバーは次のバナーをクライアントに送信します:
```
    wolfSSH Example Echo Server
```

クライアントにタイプした文字はサーバーからスクリーンにエコーバックされます。文字が２度エコーバックされたとしたら、それはクライアントのローカルエコーが有効になっているからです。echoserverは正規のターミナルとして振る舞ってはいないので、CR/LFの変換が期待通りに機能しないことがあります。

以下の制御文字はechoserverで特別な動作を引き起こします:

- CTRL-C: コネクションを切断します。
- CTRL-E: いくつかのセッション統計をプリントアウトします。
- CTRL-F: 新たな鍵交換をトリガーします。

echoserverサンプルプログラムには以下のコマンドラインオプションが指定できます。一部のオプションは、対応する機能が組み込まれている場合にのみ使用できます。
```
    -?             ヘルプを表示して終了する
    -1             一回の接続後に終了する
    -e             クライアントからECC公開鍵を受け取る
    -E             ECC秘密鍵を先にロードする
    -f             入力をエコーする（シェル対応ビルドのみ）
    -A             アプリケーションコールバックからチャネルを駆動する
    -p <num>       待ち受けポート番号を指定する（デフォルトは22222）
    -N             ノンブロッキングソケットを使う
    -d <string>    SFTPコネクションのホームディレクトリを指定する
    -D             SFTPコネクションをホームディレクトリから開始する
                   だけでなく、ホームディレクトリ内に制限する
    -j <file>      接続相手からのSSH公開鍵を受け付ける為にロードする
                   （ユーザーはコメントにあるものとみなす）
    -I <name>:<file>
                   接続相手からのSSH公開鍵を受け付ける為にロードする
    -s <file>      デフォルトのhansel鍵を置き換えるTPM公開鍵ファイルを
                   ロードする
    -G <file>      TPMからECC/RSAホスト鍵blobをロードする（秘密鍵は
                   TPM内に留まる）
    -J <name>:<file>
                   接続相手からのX.509 PEM証明書を受け付ける為にロードする
    -K <name>:<file>
                   接続相手からのX.509 DER証明書を受け付ける為にロードする
    -P <name>:<password>
                   接続相手から受け付けるパスワードを追加する
    -i <name>:<password>
                   接続相手からkeyboard-interactiveで受け付ける
                   パスワードを追加する
    -a <file>      ルートCA証明書ファイルをロードする
    -k <list>      使用する鍵アルゴリズムのカンマ区切りリストを指定する
    -x <list>      使用する鍵交換アルゴリズムのカンマ区切りリストを
                   指定する
    -m <list>      使用するMACアルゴリズムのカンマ区切りリストを指定する
    -W <spec>      Windows証明書ストア: "store:subject[:flags]"
    -b <num>       ユーザー認証がブロックする場合をテストする
    -H             テスト用のハイウォーターコールバックを設定する
```

###  wolfSSH Client

このクライアントはSSHサーバーとの接続を確立します。最も単純なモードでは"Hello, wolfSSH!"という文字列をサーバーに送信し、その応答を表示して終了します。疑似ターミナルオプションを使うと、このクライアントは実際のクライアントとして機能します。

クライアントサンプルプログラムには以下のコマンドラインオプションが指定できます。一部のオプションは、対応する機能が組み込まれている場合にのみ使用できます。
```
    -?             ヘルプを表示して終了する
    -h <host>      接続先ホストアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先ポート（デフォルト 22222)
    -u <username>  認証の為のユーザー名（指定必須）
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -K <password>  TPM鍵の認証パスワード
    -e             サンプルecc公開鍵を指定
    -i <filename>  ユーザーの秘密鍵ファイル名
    -j <filename>  ユーザーの公開鍵ファイル名
    -x             接続成功後、データの読み書きをせずに終了
    -N             ノンブロッキングソケットを使う
    -t             疑似ターミナルを使用
    -c <command>   リモートコマンドを実行し stdin/stdout をパイプする
    -R             変換なしの生の出力（Windowsのみ）
    -a             SSH-AGENTの使用を試みる
    -J <filename>  使用するDER証明書のファイル名
    -A <filename>  ホストを検証するためのDER CA証明書のファイル名
    -X             接続相手と接続相手の証明書のIPチェックを無視する
    -E             使用可能なすべてのアルゴリズムを一覧表示する
    -k <list>      鍵アルゴリズムのリストを指定する
    -C <list>      暗号化アルゴリズムのリストを指定する
    -q             デバッグ出力をオフにする
```

### wolfSSH portfwd

portfwdサンプルプログラムはSSHサーバーとの接続を確立し、ローカルポートフォワーディングのための待ち受けリスナーを設定するか、あるいはオプション`-r`を指定した場合はリモートポートフォワーディングのための待ち受けをサーバーに要求します。プログラムは接続が終了するまで動作し続けます。

portfwd サンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -?             ヘルプを表示して終了する
    -h <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -F <host>      フォーワード元ホストアドレス（デフォルト 0.0.0.0）
    -f <num>       フォーワード元ホストポート（指定必須）。-rと共に0を
                   指定すると、リスナーのポートを接続相手が選択する
    -T <host>      フォーワード先ホストアドレス(デフォルト host)
    -t <num>       フォーワード先ホストポート（指定必須）
    -r             リモート（リバース）フォワード: SSHサーバーに-F/-fで
                   待ち受けさせ、接続をローカルの-T/-t宛てにトンネルで
                   戻す
```

### wolfSSH scpclient

scpclient、すなわちwolfscpはSSHサーバーとの接続を確立し、指定されたファイルをサーバーへ、あるいはサーバーからローカルマシンへコピーします。wolfSSHのサンプルプログラムを使用する際は、絶対パスを使用する必要があり、ディレクトリは`/`で終わる必要があります。

scpclientサンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -h             ヘルプを表示して終了する
    -H <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -L <from>:<to> ローカルマシンからサーバーへコピーする
    -S <from>:<to> サーバーからローカルマシンへコピーする
    -i <filename>  ユーザーの秘密鍵ファイル名
    -j <filename>  ユーザーの公開鍵ファイル名
    -J <filename>  使用するDER証明書のファイル名
    -A <filename>  ホストを検証するためのDER CA証明書のファイル名
    -X             接続相手と接続相手の証明書のIPチェックを無視する
```

### wolfSSH sftpclient

sftpclient、すなわちwolfsftpはSSHサーバーとの接続を確立し、ディレクトリ移動、ファイルの取得と配置、ディレクトリの作成と削除などを実行できるようにします。

sftpclientサンプルプログラムには以下のコマンドラインオプションが指定できます。一部のオプションは、対応する機能が組み込まれている場合にのみ使用できます。
```
    -?             ヘルプを表示して終了する
    -h <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -d <path>      ローカルマシンのデフォルトのパスを設定する
    -N             ノンブロッキングソケットを使う
    -l <filename>  ローカルファイル名
    -r <filename>  リモートファイル名
    -g             ローカルファイルをリモートファイルとして送信する
    -G             リモートファイルをローカルファイルとして受信する
    -i <filename>  ユーザーの秘密鍵ファイル名
    -j <filename>  ユーザーの公開鍵ファイル名
    -k <list>      受け付けるサーバーホスト鍵アルゴリズムのカンマ区切り
                   リストを指定する
    -W <spec>      Windows証明書ストア: "store:subject[:flags]"
    -J <filename>  使用するDER証明書のファイル名
    -A <filename>  ホストを検証するためのDER CA証明書のファイル名
    -X             接続相手と接続相手の証明書のIPチェックを無視する
```

### wolfsshクライアントアプリケーション

wolfsshクライアントアプリケーションは`--enable-sshclient`を指定してビルドされ、サーバーに接続してターミナルを開くか、あるいは接続先の後に指定されたコマンドを実行します。ユーザー名はデフォルトで現在のユーザーとなり、認証には秘密鍵`$HOME/.ssh/id_ecdsa`を使用します。
```
    wolfssh [-a] [-E logfile] [-G] [-l login_name] [-p port] [-V]
            destination [command]
```

オプションは次のとおりです:
```
    -a             SSH-AGENTの使用を試みる（agent対応ビルドのみ）
    -E logfile     ログをstderrではなくこのファイルに追記し、ログ出力を
                   有効にする
    -G             使用される設定を出力する
    -l login_name  接続先に含まれるログイン名を上書きする
    -p port        接続先のポート番号を上書きする
    -V             バージョンを出力する
```

接続先は`[user@]hostname`または`ssh://[user@]hostname[:port]`のいずれかです。デフォルトのポートは22です。オプション`-N`は受け付けられなくなりました。

### wolfSSHd

wolfSSHdは`--enable-sshd`を指定してビルドされるSSHサーバーデーモンで、OpenSSH形式の`sshd_config`ファイルを読み込み、ユーザーをローカルシステムにログインさせます。シェルセッションとexecセッション、およびビルド時に組み込まれていればSCPとSFTPをサポートします。

wolfSSHdは、実行ユーザー（またはroot）が所有していないホスト鍵ファイルや、グループまたは全ユーザーから読み取り可能なホスト鍵ファイルを拒否します。そのため、wolfSSHdが使用できる鍵のコピーを渡してください。例えば次のようにします:
```
    $ sudo install -m 600 keys/gretel-key-ecc.pem /etc/ssh/wolfsshd_key.pem
    $ sudo ./apps/wolfsshd/wolfsshd -D -h /etc/ssh/wolfsshd_key.pem -p 11111
    $ ssh <user>@localhost -p 11111
```

システムの`sshd_config`ファイルにwolfSSHdがサポートしていないディレクティブがあって停止する場合は、ファイルをコピーしてその行を削除し、そのコピーを`-f`で指定してください。

wolfSSHdには以下のコマンドラインオプションが指定できます:
```
    -?             ヘルプを表示して終了する
    -f <file name> 使用する設定ファイル（デフォルトは
                   /etc/ssh/sshd_config）
    -p <int>       待ち受けポート番号
    -d             デバッグモードを有効にする
    -D             フォアグラウンドで実行する（デタッチしない）
    -h <file name> 使用するホスト秘密鍵ファイル
    -E <file name> ログファイルに追記する
    -t             テストモード: 設定を読み込み、待ち受けを行わずに
                   終了する
```

wolfSSHdは次の設定ディレクティブを認識します:

| ディレクティブ | 備考 |
|--------------------------------|-----------------------------------------------|
| `Port` | 待ち受けポート。デフォルトは22です。 |
| `Protocol` | `2`のみ受け付けます。 |
| `HostKey` | ホスト秘密鍵ファイル。`Match`ブロック内では使用できません。 |
| `HostCertificate` | ホストX.509証明書ファイル。`Match`ブロック内では使用できません。 |
| `PasswordAuthentication` | `yes`（デフォルト）または`no`。 |
| `PubkeyAuthentication` | `yes`（デフォルト）または`no`。 |
| `PermitEmptyPasswords` | `yes`または`no`（デフォルト）。 |
| `PermitRootLogin` | `no`（デフォルト）、`yes`、`prohibit-password`（`without-password`とも記述可能）、`forced-commands-only`。UIDが0のすべてのアカウントに適用されます。 |
| `AuthorizedKeysFile` | 認可済み鍵ファイル。デフォルトはユーザーのホームディレクトリ内の`.ssh/authorized_keys`です。相対パスはホームディレクトリからのパスとみなされます。`%u`はユーザー名に、`%h`はホームディレクトリに、`%%`はパーセント記号に展開されます。それ以外の`%`トークンはエラーになります。 |
| `StrictModes` | `yes`（デフォルト）または`no`。 |
| `TrustedUserCAKeys` | ユーザー証明書用のCAファイル。X.509 CA証明書、またはOpenSSH証明書用のOpenSSH CA公開鍵です。 |
| `AuthorizedUPNDomains` | ユーザーのFPKI証明書のUPNレルムを制限します。 |
| `LoginGraceTime` | 認証に許容される秒数。デフォルトは120です。 |
| `UsePrivilegeSeparation` | `yes`、`no`、または`sandbox`。 |
| `ChrootDirectory` | ユーザーのセッションをchrootするディレクトリ。 |
| `ForceCommand` | クライアントが要求したコマンドの代わりに実行するコマンド。 |
| `Banner` | 認証前にクライアントへ送信するファイル。 |
| `PidFile` | デーモンのプロセスIDを書き込むファイル。 |
| `Include` | 別の設定ファイルを読み込みます。 |
| `Match` | `User`または`Group`に対する設定ブロックを開始します。 |
| `wolfSSH_HostKeyStore`, `wolfSSH_HostKeyStoreSubject`, `wolfSSH_HostKeyStoreFlags` | Windows証明書ストア対応ビルドのみ。証明書ストアからホスト鍵と証明書を読み込みます。 |
| `wolfSSH_TrustedUserCAStore`, `wolfSSH_WinUserStores`, `wolfSSH_WinUserPvPara`, `wolfSSH_WinUserDwFlags` | Windows証明書ストア対応ビルドのみ。Windows証明書ストアからユーザー証明書のCAを読み込みます。 |
| `wolfSSH_TrustedSystemCAKeys` | `yes`または`no`。オペレーティングシステムのトラストストアをユーザー証明書のCAとして読み込みます。 |

ディレクティブ`Subsystem`、`ChallengeResponseAuthentication`、`UsePAM`、`X11Forwarding`、`PrintMotd`、`AcceptEnv`、`UseDNS`はOpenSSHの設定ファイルとの互換性のために認識されますが、効果はありません。wolfSSHdはそれぞれについて警告をログに出力します。それ以外のディレクティブはエラーになります。ディレクティブとその値は空白で区切る必要があり、OpenSSHの`Keyword=value`形式は拒否されます。

`Match`ブロックのキーには`User`または`Group`のみを指定できます。`Match User X Group Y`は両方が一致する必要があります。`wolfSSH_`で始まるストア関連のディレクティブと`wolfSSH_TrustedSystemCAKeys`はグローバルにのみ指定でき、`Match`ブロック内では拒否されます。`TrustedUserCAKeys`は`Match`ブロック内でも設定できます。

`StrictModes yes`の場合、認可済み鍵ファイルはシンボリックリンクではない通常ファイルで、ユーザーまたはrootが所有し、パス中にグループまたは全ユーザーが書き込み可能な要素を含んではなりません。`StrictModes no`で緩和されるのは認可済み鍵ファイルのチェックのみです。ホスト鍵ファイルとCAファイルは常にチェックされます。これらはデーモンの実行ユーザーまたはrootが所有している必要があり、ホスト秘密鍵はグループまたは全ユーザーから読み取り可能であってはなりません。

`PermitRootLogin prohibit-password`はrootのパスワードおよびkeyboard-interactiveによるログインを拒否し、公開鍵によるログインを許可します。`forced-commands-only`はさらに、rootの公開鍵ログインに`ForceCommand`を必要とします。認可済み鍵ファイルの`command=`オプションは強制されません。

X.509ユーザー証明書（`--enable-certs`）の場合、CAは`TrustedUserCAKeys`で設定します。証明書は、wolfSSLがFPKIをサポートしている場合はそのUPNによって、そうでない場合はサブジェクトCNの大文字小文字を区別しない一致によって、要求されたアカウントに結び付けられます。FPKIがない場合、Windows以外のシステムでは設定で`AuthorizedKeysFile`も指定する必要があり、証明書はユーザーの認可済み鍵ファイルと照合されます。CAのみに依存するログインは失敗します。FPKIがある場合、`AuthorizedUPNDomains`でUPNレルムを制限できます。

OpenSSHユーザー証明書（`--enable-ossh-certs`）の場合、署名するCAの公開鍵を`TrustedUserCAKeys`に列挙します。証明書のプリンシパルには要求されたユーザーが含まれている必要があり、証明書が有効期間内である必要があります。また、`source-address`制限がある場合はクライアントと一致する必要があります。証明書の`force-command`は要求されたコマンドを上書きします。OpenSSH証明書によるログインはWindowsではサポートされていません。

wolfSSHdのセッションはumask 022（`WOLFSSHD_DEFAULT_UMASK`）で実行されます。

## SCP

wolfSSHはscpの為のサーバー側サポートを含んでおり、サーバーへのファイルコピーとサーバーからのファイルコピーの両方をサポートしています。単一ファイルのコピーとディレクトリ単位の再帰的コピーの両方が、デフォルトの送信・受信コールバックでサポートされています。

wolfSSHをscpサポート付きでコンパイルするには、`--enable-scp` ビルドオプションを指定するか、あるいは`WOLFSSH_SCP`を定義してください:
```
    $ ./configure --enable-scp
    $ make
```


wolfSSHのサンプルechoserverは、wolfSSHがSCPサポート付きでビルドされている場合にscpリクエストを受け付けます。サンプルサーバーを起動するには次を実行してください:

    $ ./examples/echoserver/echoserver

クライアント側では標準のscpコマンドが使用できます。以下はその使用例です。ここで`scp`は使用しているsshクライアントを表します。

既定のサンプルユーザー"jill"を使って単一ファイルをサーバーに送信するには:

    $ scp -P 22222 <local_file> jill@127.0.0.1:<remote_path>

同じ単一ファイルをサーバーに送信するが、今度はタイムスタンプ付きでバーバスモードを使うには:

    $ scp -v -p -P 22222 <local_file> jill@127.0.0.1:<remote_path>

あるディレクトリを再帰的にサーバーへコピーするには:

    $ scp -P 22222 -r <local_dir> jill@127.0.0.1:<remote_dir>

単一ファイルをサーバーからローカルクライアントへコピーするには:

    $ scp -P 22222 jill@127.0.0.1:<remote_file> <local_path>

あるディレクトリをサーバーからローカルクライアントへ再帰的にコピーするには:

    $ scp -P 22222 -r jill@127.0.0.1:<remote_dir> <local_path>

## SFTP

wolfSSHはSFTPバージョン3のサーバー側およびクライアント側サポートを提供します。これにより、ファイルシステムを管理するための暗号化された接続を設定することができます。

wolfSSHをSFTPサポート付きでコンパイルするには、`--enable-sftp` ビルドオプションを指定するか、あるいは`WOLFSSH_SFTP`を定義してください:

```
    $ ./configure --enable-sftp
    $ make
```

作成されるSFTPクライアントはexamples/sftpclient/ディレクトリに配置され、サーバーはwolfSSHと同じechoserverを使って実行されます。

```
    src/wolfssh$ ./examples/sftpclient/wolfsftp
```

サポートされているコマンドの完全な一覧は、接続後に"help"と入力することで確認できます。

```
    wolfSSH sftp> help

    Commands :
        cd  <string>                      change directory
        chmod <mode> <path>               change mode
        creat <mode> <path>               create file with given permissions
        get <remote file> <local file>    pulls file(s) from server
        lcd <path>                        change local directory
        lls                               list local directory
        ls                                list current directory
        mkdir <dir name>                  creates new directory on server
        put <local file> <remote file>    push file(s) to server
        pwd                               list current path
        quit                              exit
        rename <old> <new>                renames remote file
        reget <remote file> <local file>  resume pulling file
        reput <remote file> <local file>  resume pushing file
        <crtl + c>                        interrupt get/put cmd
```
別のシステムに接続する例は次のようになります:

```
    src/wolfssh$ ./examples/sftpclient/wolfsftp -p 22 -u user -h 192.168.1.111
```

##  シェルサポート

wolfSSHのサンプルechoserverは、ログインを試みるユーザーの為にシェルをforkできるようになりました。この機能は現在のところLinuxとmacOSでのみテストされています。echoserver.cファイルは、ユーザー認証コールバック内にユーザーのクレデンシャルを保持するように変更するか、あるいは提供されたパスワードを検証するようにユーザー認証コールバックを変更する必要があります。

wolfSSHをシェルサポート付きでコンパイルするには、--enable-shellビルドオプションを指定するか、あるいはWOLFSSH_SHELLを定義してください:
```
$ ./configure --enable-shell
$ make
```

試すには、現在のユーザーのパスワードを指定してechoserverを起動し、疑似ターミナルを使用するサンプルクライアントで接続します。ここで`<user>`は現在ログインしているユーザーの名前です:
```
$ ./examples/echoserver/echoserver -P <user>:junk
$ ./examples/client/client -t -u <user> -P junk
```

デフォルトでechoserverはシェルを起動しようとします。エコーテストの動作を使うには、echoserverにコマンドラインオプション-fを指定してください:
```
$ ./examples/echoserver/echoserver -f
```

## Post-Quantum

wolfSSHは、ML-KEM（旧称Kyber）によるポスト量子鍵交換と、ML-DSA（旧称Dilithium）によるポスト量子署名をサポートしています。

* **ML-KEM**: ハイブリッド鍵交換`mlkem768x25519-sha256`（ML-KEM-768とCurve25519）、`mlkem768nistp256-sha256`（ML-KEM-768とP-256上のECDH）、`mlkem1024nistp384-sha384`（ML-KEM-1024とP-384上のECDH）。利用可能な場合、これらは従来の鍵交換よりも優先して提示されます。
* **ML-DSA**: ML-DSA-44、ML-DSA-65、ML-DSA-87のパラメータセット（`ssh-mldsa-44`、`ssh-mldsa-65`、`ssh-mldsa-87`）をサーバーホスト鍵とクライアント公開鍵認証の両方でサポートし、ML-DSAとECDSA、Ed25519、Ed448とのコンポジットもサポートします。証明書サポート付きでビルドした場合は、ML-DSA X.509証明書（`x509v3-ssh-mldsa-44`、`x509v3-ssh-mldsa-65`、`x509v3-ssh-mldsa-87`）もサポートされます。

これらのアルゴリズムはwolfCryptによって提供され、liboqsは使用しません。これらをサポートするようにwolfSSLをビルドしてインストールしてください。ML-DSAにはwolfSSL 5.9.2以降が必要です。例えば次のようにします:

```
    $ ./configure --enable-wolfssh --enable-mlkem --enable-mldsa
```

その後、通常どおりwolfSSHをコンフィギュレーションしてビルドします:

```
    $ ./configure
    $ make all
```

wolfSSHのクライアントとサーバーは、ML-KEMハイブリッド鍵交換を使うように自動的にネゴシエートします。

```
    $ ./examples/echoserver/echoserver -f

    $ ./examples/client/client -u jill -P upthehill
```

クライアント側では、次のような出力が表示されます:

```
Server said: Hello, wolfSSH!
```

これらの鍵交換をサポートする他のSSHクライアント（`mlkem768x25519-sha256`に対するOpenSSHなど）もechoserverに接続できます。


## Certificate Support

wolfSSHはユーザーを認証する際に、単なる公開鍵の代わりにX.509証明書を受け付けることができます。

wolfSSHをX.509サポート付きでコンパイルするには、`--enable-certs`ビルドオプションを指定するか、あるいは`WOLFSSH_CERTS`を定義してください:

```
    $ ./configure --enable-certs CPPFLAGS=-DWOLFSSH_NO_FPKI
    $ make
```

この例では、同梱の"fred"の証明書が必要なFPKI拡張を持っていないため、FPKIチェックを無効にしています。`WOLFSSH_NO_FPKI`が定義されていない場合、この証明書は拒否されます。

FPKIの有無にかかわらず、接続相手の証明書にはRFC 6187のセクション2.2が適用されます。KeyUsage拡張はdigitalSignatureを示している必要があり、ExtendedKeyUsage拡張はanyExtendedKeyUsageか、検証対象の役割に対応する用途（ユーザー証明書の場合はid-kp-secureShellClientまたはclientAuth、ホスト証明書の場合はid-kp-secureShellServerまたはserverAuth）を指定している必要があります。これらの拡張を持たない証明書は受け付けられます。一致しない場合は`WS_CERT_KEY_USAGE_E`で失敗します。

ユーザーの証明書を検証するためのCAルート証明書を提供するには、echoserverにコマンドラインオプション`-a`を指定してください:

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem
```

echoserverとクライアントには"fred"という名前の偽のユーザーが用意されており、その証明書が認証に使用されます。

サンプル証明書fred-cert.derを使ったechoserver/client接続の例は次のようになります:

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem -K fred:./keys/fred-cert.der

    $ ./examples/client/client -u fred -J ./keys/fred-cert.der -i ./keys/fred-key.der
```

## OpenSSH証明書サポート

wolfSSHは、公開鍵によるユーザー認証でOpenSSHユーザー証明書（`*-cert-v01@openssh.com`）を受け付けることができます。wolfSSHをOpenSSH証明書サポート付きでコンパイルするには、`--enable-ossh-certs`ビルドオプションを指定するか、あるいは`WOLFSSH_OSSH_CERTS`を定義してください。証明書のCA鍵、プリンシパル、有効期間、およびforce-commandとsource-addressオプションはユーザー認証コールバックに渡され、コールバックはCAが信頼できることを確認する必要があります。wolfSSHdは`TrustedUserCAKeys`に列挙されたCA鍵を使用します。

## Windows証明書ストア

Windowsでは、ホスト鍵とユーザー鍵をファイルの代わりにWindows証明書ストアから取得できます。これには証明書サポートが必要です。`--enable-windows-cert-store`ビルドオプション（mingwホストのみ）を指定するか、`WOLFSSH_WINDOWS_CERT_STORE`を定義して有効にしてください。RSAのストア証明書は`x509v3-ssh-rsa`として提示され、RFC 6187ではこれをSHA-1で署名するため、`WOLFSSH_NO_SHA1_SOFT_DISABLE`と、`WC_SIG_MIN_HASH_TYPE=WC_HASH_TYPE_SHA`付きでビルドしたwolfSSLも必要です。ECDSAのストア鍵にはどちらも不要です。

echoserverとSFTPクライアントは`-W store:subject[:flags]`オプションを受け付けます。このオプションでは、ストア、証明書のサブジェクトCN、および任意でストアの場所を指定します。ストアの場所はCURRENT_USER（デフォルト）、LOCAL_MACHINE、USERS、CURRENT_SERVICE、SERVICES、CURRENT_USER_GROUP_POLICY、LOCAL_MACHINE_GROUP_POLICY、LOCAL_MACHINE_ENTERPRISEのいずれかで、それぞれ`CERT_SYSTEM_STORE_`プレフィックス付きの形式や数値でも指定できます。`-W`は証明書とその秘密鍵の両方を提供します。SFTPクライアントでは`-i`、`-j`、`-J`と組み合わせることはできません。

```
    $ ./examples/echoserver/echoserver -W "My:wolfSSH-Server:LOCAL_MACHINE" -a ./keys/ca-cert-ecc.pem

    $ ./examples/sftpclient/wolfsftp -u testuser -W "My:testuser:CURRENT_USER" -A ./keys/ca-cert-ecc.der -X
```

## TPMホスト鍵

`--enable-tpm`を指定すると、サーバーはECDSAまたはRSAのホスト鍵をTPM 2.0内に保持できるため、ホスト秘密鍵がメモリ上に置かれることはありません。鍵は`wolfSSH_CTX_UseTpmHostKey()`で登録され、交換ハッシュはTPMによって署名されます。`wolfSSH_CTX_UseTpmHostKey()`の後に`wolfSSH_CTX_UseCert_buffer()`を呼び出すことで、X.509ホスト証明書をTPM鍵と組み合わせることができます。echoserverはオプション`-G`でTPMホスト鍵blobをロードします:

```
    $ ./examples/echoserver/echoserver -G ../wolfTPM/hostkey.bin
```

サンプル`examples/tpmcertserver/tpmcertserver`と`tpmcertclient`は、TPMホスト鍵と自己署名X.509ホスト証明書の組み合わせを示しています。

## 厳格な鍵交換

wolfSSHは、Terrapin攻撃（CVE-2023-48795）への対策である厳格な鍵交換（strict KEX）を実装しています。これは最初のKEXINITで提示され、接続相手も提示した場合には常に使用されるため、通常の場合は設定が不要です。strict KEXが有効な場合、wolfSSHは接続相手のSSH_MSG_NEWKEYSが到着するまで鍵交換メッセージとSSH_MSG_DISCONNECT以外は何も受け付けず、SSH_MSG_NEWKEYSのたびにパケットシーケンス番号をリセットします。順序外で到着したメッセージは接続を終了させます。

strict KEXを正しく扱えない接続相手と相互運用する必要があるアプリケーションは、`wolfSSH_CTX_SetStrictKex(ctx, 0)`で以降のセッションに対してこれを無効にできます。`wolfSSH_GetStrictKexNegotiated()`は、セッションがこれを使用しているかどうかを報告します。
