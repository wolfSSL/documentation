#  wolfSSH SFTPのビルドと使用

## wolfSSH SFTPのビルド

wolfSSLは既にwolfSSHの使用のためにビルドが済んでいると仮定しています。wolfSSLのビルド方法については２章を参照してください。

SFTPサポート機能を有効にしてwolfSSHをビルドする場合には、autotoolsを使ったビルドでは--enable-sftpオプションを指定します。autotoolsを使わない場合にはWOLFSSH_SFTPマクロ定義を指定します。コマンドラインは次のようになります:
```
./configure --enable-sftp && make
```
リード・ライトをハンドリングするためのバッファサイズはデフォルトで1024バイトです。この値はアプリケーションがより少ないリソース消費に抑えたい場合やより大きなバッファが必要な場合には変更することができます。デフォルトサイズの変更は、コンパイル時に`WOLFSSH_MAX_SFTP_RW`マクロを定義して行います。設定例は次のとおりです:

```
./configure --enable-sftp
C_EXTRA_FLAGS=’WOLFSSH_MAX_SFTP_RW=2048
```

##  wolfSSH SFTP アプリケーションの使用

SFTPサーバーとクライアントアプリケーションはwolfSSHにバンドルされています。両アプリケーションともautotoolsを使ってwolfSSHライブラリをSFTPサポートを有効にしてビルドする際に同時にビルドされて生成されます。サーバーアプリケーションはexamples/echoserverフォルダに存在しておりechoserverと呼ばれます。クライアントアプリケーションはwolfsftp/clientフォルダに存在しておりwolfsftpと呼ばれます。

サーバーの起動例を示します。起動するとSFTPクライアントからの接続を待ち受けます:
```
./examples/echoserver/echoserver
```
ここで、コマンドはルートwolfSSHディレクトリから実行します。サーバーはSSHとSFTPの両方の接続を処理することができます。

一方、クライアントを起動するには特定のユーザー名を与えて起動します:
```
$ ./wolfsftp/client/wolfsftp -u <username>
```
テストを実行するためのデフォルトの“username:password”は“jack:fetchapail” または “jill:upthehill”です。デフォルトのポートは22222です。

サポートしているコマンドの全リストは、接続後に"help"と入力すると得られます。
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

他のシステムへの接続例は次のとおりです:
```
src/wolfssh$ ./examples/sftpclient/wolfsftp -p 22 -u user -h 192.168.1.111
```
