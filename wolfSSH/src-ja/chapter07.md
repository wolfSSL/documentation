#  wolfSSH SFTPのビルドと使用

## wolfSSH SFTPのビルド

wolfSSLは既にwolfSSHの使用のためにビルドが済んでいると仮定しています。wolfSSLのビルド方法については２章を参照してください。

SFTPサポート機能を有効にしてwolfSSHをビルドする場合には、autotoolsを使ったビルドでは--enable-sftpオプションを指定します。autotoolsを使わない場合にはWOLFSSH_SFTPマクロ定義を指定します。コマンドラインは次のようになります:
```
./configure --enable-sftp && make
```
リード・ライトをハンドリングするためのバッファサイズはデフォルトで32768バイトです。この値はアプリケーションがより少ないリソース消費に抑えたい場合やより大きなバッファが必要な場合には変更することができます。デフォルトサイズの変更は、コンパイル時に`WOLFSSH_MAX_SFTP_RW`マクロを定義して行います。設定例は次のとおりです:

```
./configure --enable-sftp CPPFLAGS="-DWOLFSSH_MAX_SFTP_RW=2048"
```

サーバーは各セッションに対して、最大`WOLFSSH_MAX_SFTP_HANDLES`（64）個のファイルハンドルおよびディレクトリハンドルのオープンを許可します。ファイルデータバッファは解放前にゼロクリアされます。configureオプション`--disable-sftp-zeroize`（`WOLFSSH_NO_SFTP_BUFFER_ZERO`）を指定するとこれを無効にできます。

##  wolfSSH SFTP アプリケーションの使用

SFTPサーバーとクライアントアプリケーションはwolfSSHにバンドルされています。両アプリケーションともautotoolsを使ってwolfSSHライブラリをSFTPサポートを有効にしてビルドする際に同時にビルドされて生成されます。サーバーアプリケーションはexamples/echoserverフォルダに存在しておりechoserverと呼ばれます。クライアントアプリケーションはexamples/sftpclientフォルダに存在しておりwolfsftpと呼ばれます。

サーバーの起動例を示します。起動するとSFTPクライアントからの接続を待ち受けます:
```
./examples/echoserver/echoserver
```
ここで、コマンドはルートwolfSSHディレクトリから実行します。サーバーはSSHとSFTPの両方の接続を処理することができます。

一方、クライアントを起動するには特定のユーザー名を与えて起動します:
```
$ ./examples/sftpclient/wolfsftp -u <username>
```
テストを実行するためのデフォルトの"username:password"は"jack:fetchapail" または "jill:upthehill"です。デフォルトのポートは22222です。

サポートしているコマンドの全リストは、接続後に"help"と入力すると得られます。
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

他のシステムへの接続例は次のとおりです:
```
src/wolfssh$ ./examples/sftpclient/wolfsftp -p 22 -u user -h 192.168.1.111
```

##  SFTPサーバーの開始ディレクトリと制限

SFTPサーバーのセッションには、互いに独立した2つのパス設定があります:

- 開始パスは、セッションが開始するディレクトリで、相対パスはこのディレクトリを基準に解決されます。これはアクセスの許可も拒否も行いません。`wolfSSH_SFTP_SetDefaultPath()`で設定します。
- 制限ルートは、セッションのアクセスが制限されるディレクトリです。このディレクトリの外側に解決されるパスへのリクエストは`WS_PERMISSIONS`で失敗します。ルートが設定されていないか、ルートが"/"の場合、セッションは制限されません。`wolfSSH_SFTP_SetConfinePath()`で設定します。

開始パスを設定してもセッションは制限されません。2つを分けておくことで、サーバーは制限ルートの深い階層でセッションを開始したり、開始位置を変えずにセッションを制限したり、あるいはどちらも行わずにオペレーティングシステムにアクセスを制限させたりできます（wolfSSHdは、認証されたユーザーとしてセッションを実行することで最後の方法をとっています）。

パスは字句的に解決されるため、シンボリックリンクがルート内に留まることを証明できません。そのため、制限されたセッションでは、ルート配下のすべてのシンボリックリンクを拒否します。これにはルート内を指すリンクも含まれます。シンボリックリンクを含まないツリーを提供するか、あるいは`WOLFSSH_NO_SYMLINK_CHECK`を指定してビルドし、このチェックとそれによる保護を外してください。ルート自体はチェックされないため、ルートはサーバーが管理し、パス中にシンボリックリンクを含まないディレクトリにすべきです。チェックは操作がパスを使用する前に行われるため、同じユーザーとして実行されているプロセスがその間にパスの要素をリンクに差し替えることは依然として可能です。悪意のあるユーザーが存在しうるマルチユーザー環境では、オペレーティングシステムのjailも併用してください。

サンプルのechoserverは、オプション`-d`で開始パスを設定し、オプション`-D`を指定するとセッションをそのパスに制限します:
```
./examples/echoserver/echoserver -d /srv/sftp -D
```
