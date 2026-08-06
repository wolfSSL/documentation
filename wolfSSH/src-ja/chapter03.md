# 始めよう

wolfSSHのダウンロードとビルドが終わったら、ライブラリの使い方を示す自動テストプログラムとサンプルプログラムが用意されています。

## テスト

###  wolfSSHユニットテスト

wolfSSHのユニットテストはAPIの動作を確認するためのものです。ポジティブ/ネガティブの両テストケースが実行されます。テストはマニュアルで実行することができますが、makeやmake checkコマンドなど他の自動化された処理の一部として実行される場合もあります。

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

レポジトリをクローンした後、テスト用の秘密鍵はユーザーにとってリードオンリーになっていることを確認してください。そうなっていない場合はssh_clientがそうするように警告します。
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

ここで、_USER_の部分にはgretelかhanselが指定でき、TYPEにはrsaかeccを指定します。

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

echoserverサンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -1             一回の接続後に終了する
    -e             クライアントからECC公開鍵を受け取る
    -E             ECC秘密鍵を使う
    -f             入力をエコーする
    -p <num>       待ち受けポート番号を指定する（デフォルトは22222）
    -N             ノンブロッキングソケットを使う
    -d <string>    SFTPコネクションのホームディレクトリを指定する
    -j <file>      接続相手からの公開鍵を受け付ける為にロードする
```

###  wolfSSH Client

このクライアントはSSHサーバーとの接続を確立します。最も単純なモードでは"Hello, wolfSSH!"という文字列をサーバーに送信し、その応答を表示して終了します。疑似ターミナルオプションを使うと、このクライアントは実際のクライアントとして機能します。

クライアントサンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -h <host>      接続先ホストアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先ポート（デフォルト 22222)
    -u <username>  認証の為のユーザー名（指定必須）
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -e             サンプルecc公開鍵を指定
    -i <filename>  ユーザーの秘密鍵ファイル名
    -j <filename>  ユーザーの公開鍵ファイル名
    -x             接続成功後、データの読み書きをせずに終了
    -N             ノンブロッキングソケットを使う
    -t             疑似ターミナルを使用
    -c <command>   リモートコマンドを実行し stdin/stdout をパイプする
    -a             SSH-AGENTの使用を試みる
```

### wolfSSH portfwd

portfwdサンプルプログラムはSSHサーバーとの接続を確立し、ローカルポートフォワーディングのための待ち受けリスナーを設定するか、あるいはリモートポートフォワーディングのためのリスナーを要求します。接続確立の後、プログラムは終了します。

portfwd サンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -h <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -F <host>      フォーワード元ホストアドレス（デフォルト 0.0.0.0）
    -f <num>       フォーワード元ホストポート（指定必須）
    -T <host>      フォーワード先ホストアドレス(デフォルト host)
    -t <num>       フォーワード先ホストポート（指定必須）
```

### wolfSSH scpclient

scpclient、すなわちwolfscpはSSHサーバーとの接続を確立し、指定されたファイルをサーバーへ、あるいはサーバーからローカルマシンへコピーします。wolfSSHのサンプルプログラムを使用する際は、絶対パスを使用する必要があり、ディレクトリは`/`で終わる必要があります。

scpclientサンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -H <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -L <from>:<to> ローカルマシンからサーバーへコピーする
    -S <from>:<to> サーバーからローカルマシンへコピーする
```

### wolfSSH sftpclient

sftpclient、すなわちwolfsftpはSSHサーバーとの接続を確立し、ディレクトリ移動、ファイルの取得と配置、ディレクトリの作成と削除などを実行できるようにします。

sftpclientサンプルプログラムには以下のコマンドラインオプションが指定できます:
```
    -h <host>      接続先SSHサーバーアドレス（デフォルト 127.0.0.1）
    -p <num>       接続先SSHサーバーポート（デフォルト 22222）
    -u <username>  ユーザー名(指定必須)
    -P <password>  パスワード（省略した場合はプロンプトが表示される）
    -d <path>      ローカルマシンのデフォルトのパスを設定する
    -N             ノンブロッキングソケットを使う
    -e             ECCユーザー認証を使う
    -l <filename>  ローカルファイル名
    -r <filename>  リモートファイル名
    -g             ローカルファイルをリモートファイルとして送信する
    -G             リモートファイルをローカルファイルとして受信する
```

### wolfSSHサーバー

このツールはプレースホルダーです。


## SCP

wolfSSHはscpの為のサーバー側サポートを含んでおり、サーバーへのファイルコピーとサーバーからのファイルコピーの両方をサポートしています。単一ファイルのコピーとディレクトリ単位の再帰的コピーの両方が、デフォルトの送信・受信コールバックでサポートされています。

wolfSSHをscpサポート付きでコンパイルするには、`--enable-scp` ビルドオプションを指定するか、あるいは`WOLFSSL_SCP`を定義してください:
```
    $ ./configure --enable-scp
    $ make
```


wolfSSLサンプルサーバープログラムは単一のscpリクエストを受け付けるように設定されており、wolfSSHライブラリのコンパイル時にデフォルトでコンパイルされます。サンプルサーバーを起動するには次を実行してください:

    $ ./examples/server/server

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

APIの完全な使用方法と実装の詳細については、wolfSSHユーザーマニュアルを参照してください。

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
        get <remote file> <local file>    pulls file(s) from server
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

デフォルトでechoserverはシェルを起動しようとします。エコーテストの動作を使うには、echoserverにコマンドラインオプション-fを指定してください:
```
$ ./examples/echoserver/echoserver -f
```

## Post-Quantum

wolfSSHはポスト量子アルゴリズムのKyberをサポートするようになりました。これはNIST提出のLevel 1パラメータセットを使用し、wolfSSHとの統合を通じてliboqsによって実装されています。これはP-256 ECC曲線上のECDHEとハイブリッド化されています。

liboqsを使用できるようにするためには、システム上でliboqsをビルドしインストールしておく必要があります。liboqsの0.7.0リリースをサポートしています。次のリンクからダウンロードできます:

```
    https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.7.0.tar.gz
```

展開後、次の手順で十分です:

```
    $ cd liboqs-0.7.0
    $ mkdir build
    $ cd build
    $ cmake -DOQS_USE_OPENSSL=0 ..
    $ make all
    $ sudo make install
```


wolfSSHでP-256 ECC曲線上のECDHEとハイブリッド化されたKyber Level1のサポートを有効にするには、configure時に`--with-liboqs`ビルドオプションを使用してください:

```
    $ ./configure --with-liboqs
```

この機能が有効になっていると、wolfSSHのクライアントとサーバーはP-256 ECC曲線上のECDHEとハイブリッド化されたKyber Level1を使うように自動的にネゴシエートします。

```
    $ ./examples/echoserver/echoserver -f

    $ ./examples/client/client -u jill -P upthehill
```

クライアント側では、次のような出力が表示されます:

```
Server said: Hello, wolfSSH!
```

OpenQuantumSafeのOpenSSHフォークとの相互運用性を確認したい場合は、echoserverを実行している間にそのフォークをビルドして実行できます。次のリンクからリリースをダウンロードしてください:

```
    https://github.com/open-quantum-safe/openssh/archive/refs/tags/OQS-OpenSSH-snapshot-2021-08.tar.gz
```

ビルドと実行には次の手順で十分です:

```
    $ tar xmvf openssh-OQS-OpenSSH-snapshot-2021-08.tar.gz
    $ cd openssh-OQS-OpenSSH-snapshot-2021-08/
    $ ./configure --with-liboqs-dir=/usr/local
    $ make all
    $ ./ssh -o"KexAlgorithms +ecdh-nistp256-kyber-512-sha256" \
      -o"PubkeyAcceptedAlgorithms +ssh-rsa" \
      -o"HostkeyAlgorithms +ssh-rsa" \
      jill@localhost -p 22222
```

注記: プロンプトが表示されたら、パスワード"upthehill"を入力してください。

1行のテキストを入力してEnterを押すと、その行がエコーバックされます。接続を終了するにはCTRL-Cを使用してください。


## Certificate Support

wolfSSHはユーザーを認証する際に、単なる公開鍵の代わりにX.509証明書を受け付けることができます。

wolfSSHをX.509サポート付きでコンパイルするには、`--enable-certs`ビルドオプションを指定するか、あるいは`WOLFSSH_CERTS`を定義してください:

```
    $ ./configure --enable-certs
    $ make
```

ユーザーの証明書を検証するためのCAルート証明書を提供するには、echoserverにコマンドラインオプション`-a`を指定してください:

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem
```

echoserverとクライアントには"john"という名前の偽のユーザーが用意されており、その証明書が認証に使用されます。

サンプル証明書john-cert.derを使ったechoserver/client接続の例は次のようになります:

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem -K john:./keys/john-cert.der

    $ ./examples/client/client -u john -J ./keys/john-cert.der -i ./keys/john-key.der
```
