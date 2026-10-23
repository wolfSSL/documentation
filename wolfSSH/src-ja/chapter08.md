#  ポートフォワーディング

##  wolfSSHをポートフォワーディング機能を有効にしてビルド

wolfSSLは既にwolfSSHの使用のためにビルドが済んでいると仮定しています。wolfSSLのビルド方法については２章を参照してください。

ポートフォワーディング機能を有効にしてwolfSSHをビルドする場合には、autotoolsを使ったビルドのビルドでは--enable-fwdオプションを指定します。autotoolsを使わない場合にはWOLFSSH_FWDマクロ定義を指定します。コマンドラインは次のようになります:


```
$ ./configure --enable-fwd && make
```
##  wolfSSHポートフォワーディングサンプルプログラムを使用する

portfwdサンプルプログラムは"direct-tcpip"スタイルのチャネルを生成します。この例ではOpenSSHサーバーがポートフォワーディング機能を有効にした状態でバックグラウンドで実行中である前提としています。このサンプルプログラムはwolfSSLクライアントのためにポートをフォワーディングしてサーバーとの通信を仲介します。すべてのプログラムは同一マシン上で動作しているもとの前提です。

```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/portfwd/portfwd -p 22 -u <username> \
             -f 12345 -t 11111
src/wolfssl$ ./examples/client/client -p 12345
```

既定でwolfSSLサーバーはポート11111でリスンします。クライアントはポート12345に接続を試みるように設定されています。portfwdはusernameでOpenSSHサーバーにログインし、自身はポート12345でリスンを開始しつつ、ポート11111でリスンしているサーバーにSSHサーバー経由で接続を行います。結果としてパケットはクライアントとサーバーの間でルーティングされることになります。

portfwdサンプルプログラムのソースファイルはwolfSSHでのポートフォワーディング機能の利用と設定方法を示す良い例となるはずです。

echoerverサンプルプログラムはローカルポートフォワーディングとリモートポートフォワーディングを扱います。sshツールに接続するには以下のいずれかのコマンドを実行してください。コマンド実行はどのマシンからでも実行できます。


```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/echoserver/echoserver
anywhere 1$ ssh -p 22222 -L 12345:localhost:11111 jill@localhost
anywhere 2$ ssh -p 22222 -R 12345:localhost:11111 jill@localhost
src/wolfssl$ ./examples/client/client -p 12345
```

上記実行により、wolfSSLクライアントとサーバーサンプルプログラム間でportfwdサンプルプログラムと同様のポートフォワーディングを行います。

portfwdサンプルプログラムは、オプション`-r`を指定してリモート（リバース）フォワーディングを設定することもできます。この場合、SSHサーバーに`-F`/`-f`のアドレスとポートで待ち受けるよう要求し、サーバーはそこに対して行われた各接続をportfwdへトンネルで戻し、portfwdはそれをローカルの`-T`/`-t`宛てに接続します。`-r`を指定した場合、`-f`のポートに0を指定するとサーバーがポートを選択します。

```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/portfwd/portfwd -p 22 -u <username> -r \
             -f 12345 -t 11111
src/wolfssl$ ./examples/client/client -p 12345
```

##  ポートフォワーディングAPI

アプリケーションは、`wolfSSH_CTX_SetFwdCb()`で設定するフォワーディングコールバックと、`wolfSSH_SetFwdCbCtx()`で設定するそのコンテキストによってフォワーディングを制御します。コールバックはすべてのフォワーディングチャネルについて参照されます。受信した"direct-tcpip"または"forwarded-tcpip"チャネルのオープンは、フォワーディングコールバックが設定されていて、その`WOLFSSH_FWD_LOCAL_SETUP`呼び出しが成功しない限り拒否されます。成功した各`WOLFSSH_FWD_LOCAL_SETUP`には後で1回の`WOLFSSH_FWD_LOCAL_CLEANUP`が対応するため、コールバックはその状態を二重に解放してはなりません。サーバーでは、クライアントからの"tcpip-forward"リクエストによって`WOLFSSH_FWD_REMOTE_SETUP`でフォワーディングコールバックが呼び出されます。ポート0に対するリクエストの場合、コールバックは`WS_FWD_SUCCESS`ではなく割り当てたポートを返します。

クライアントは`wolfSSH_FwdRemoteSetup()`でリモートフォワーディングを設定します。この関数は、サーバーにアドレスとポートで待ち受け、そこに対して行われた接続を"forwarded-tcpip"チャネルとして返送するよう要求します。停止するには`wolfSSH_FwdRemoteCancel()`を使用します。クライアントは、`wolfSSH_FwdRemoteSetup()`で登録したフォワードと一致しない"forwarded-tcpip"チャネルのオープンを拒否するため、何も登録していないクライアントはすべて拒否します。登録したバインドアドレスが""、"*"、"0.0.0.0"、またはIPv6の任意アドレスの場合はポートのみで照合され、それ以外のアドレスはサーバーが報告するアドレスと等しくなければなりません。アドレスを異なる表記で報告するサーバーに対しては、`wolfSSH_SetFwdRemoteMatch()`で照合をポートのみに緩和する（`WOLFSSH_FWD_MATCH_PORT`）か、照合を無効にする（`WOLFSSH_FWD_MATCH_OFF`）ことができます。クライアントは、自身に送られた"tcpip-forward"および"cancel-tcpip-forward"リクエストを拒否します。

宣言されていたものの定義されていなかった関数`wolfSSH_CTX_SetFwdEnable()`および`wolfSSH_SetFwdEnable()`は削除されました。フォワーディングは、`WOLFSSH_FWD`を指定してビルドし、フォワーディングコールバックを設定することで有効になります。

