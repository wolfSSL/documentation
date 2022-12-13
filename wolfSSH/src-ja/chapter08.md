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

