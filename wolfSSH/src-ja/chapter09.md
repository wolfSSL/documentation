#  メモと制限事項

- SFTPはプロトコルバージョン3で実装されています。拡張ファイル属性は扱われず、送信も適用もされません。SFTPの`SETSTAT`または`FSETSTAT`リクエストは、含まれる属性を適用するか、`SSH_FX_OP_UNSUPPORTED`で応答されます。
- パスワード変更リクエストはサポートされておらず、拒否されます。
- 圧縮はサポートされていません。"none"のみが提示されます。
- wolfSSHは`chacha20-poly1305@openssh.com`暗号も`*-etm@openssh.com` MACも提示しません。
- SHA-1を使用するアルゴリズムとAES-CBCはコンパイルされますが、デフォルトでは提示されません。
- "none"暗号とMACは、`--enable-none-cipher`（`WOLFSSH_ALLOW_NONE_CIPHER`）を指定したビルドでのみネゴシエーションできます。
- RSAのユーザー認証鍵は2048ビット（`WOLFSSH_RSA_MIN_KEY_BITS`）以上でなければなりません。
- DHグループ交換は2048ビット（`WOLFSSH_DEFAULT_GEXDH_MIN`）以上のグループを使用するため、1024ビットのグループしか提示しないサーバーとは失敗します。
- アプリケーションは、接続相手が送信するstderr（拡張）データを読み取る必要があります。読み取られないデータはチャネルウィンドウを埋め、チャネルを停止させます。
- wolfSSHdは、ディレクティブ`Subsystem`、`ChallengeResponseAuthentication`、`UsePAM`、`X11Forwarding`、`PrintMotd`、`AcceptEnv`、`UseDNS`を認識しますが、実装はしていません。認可済み鍵ファイルの`command=`オプションは強制されず、WindowsでのOpenSSH証明書によるログインはサポートされていません。
