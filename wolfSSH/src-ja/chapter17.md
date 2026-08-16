# wolfSSH プリプロセッサガードマクロ

wolfSSH の多くの機能、アルゴリズム、関数は、ビルド時のプリプロセッサマクロによって
制御されます。この章は、アプリケーションが設定することを意図したマクロのリファレンス
です。これらはビルド時にコンパイラのコマンドライン（例えば `CPPFLAGS`/`CFLAGS`）を
通じて、または「wolfSSH のビルド」の章で説明した `./configure` オプションによって
定義されます。

##  アルゴリズム無効化マクロ

以下の各 `WOLFSSH_NO_*` マクロは、1 つのアルゴリズム（またはアルゴリズムファミリー）
を無効にします。autotools ビルドでは、これらは通常、wolfCrypt でどのアルゴリズムが
有効になっているかに基づいて自動的に設定されます。wolfSSH からアルゴリズムを削除する
ために手動で定義することもできます。

2 つのアルゴリズムファミリーはデフォルトで「ソフト無効化」されています。これらは
コンパイルされており動作もしますが、再度有効化しない限り鍵交換時にアドバタイズ
されません。

| マクロ | 効果 |
|--------------------------------------|------------------------------------|
| `WOLFSSH_NO_SHA1_SOFT_DISABLE` | SHA-1 アルゴリズムはコンパイルされますが、デフォルトでは KEX 時にアドバタイズされません。デフォルトで SHA-1 アルゴリズムをアドバタイズするには、これを定義します。 |
| `WOLFSSH_NO_AES_CBC_SOFT_DISABLE` | AES-CBC アルゴリズムはコンパイルされますが、デフォルトでは KEX 時にアドバタイズされません。デフォルトで AES-CBC アルゴリズムをアドバタイズするには、これを定義します。 |
| `WOLFSSH_NO_SHA1` | HMAC およびデジタル署名における SHA-1 を無効にします。 |
| `WOLFSSH_NO_HMAC_SHA1` | HMAC-SHA1 を無効にします。 |
| `WOLFSSH_NO_HMAC_SHA1_96` | HMAC-SHA1-96 を無効にします。 |
| `WOLFSSH_NO_HMAC_SHA2_256` | HMAC-SHA2-256 を無効にします。 |
| `WOLFSSH_NO_HMAC_SHA2_512` | HMAC-SHA2-512 を無効にします。 |
| `WOLFSSH_NO_DH_GROUP1_SHA1` | SHA-1 を用いた DH グループ 1（Oakley 1）を無効にします。 |
| `WOLFSSH_NO_DH_GROUP14_SHA1` | SHA-1 を用いた DH グループ 14（Oakley 14）を無効にします。 |
| `WOLFSSH_NO_DH_GROUP14_SHA256` | SHA-256 を用いた DH グループ 14 を無効にします。 |
| `WOLFSSH_NO_DH_GROUP16_SHA512` | SHA-512 を用いた DH グループ 16 を無効にします。 |
| `WOLFSSH_NO_DH_GEX_SHA256` | SHA-256 を用いた DH グループ交換を無効にします。 |
| `WOLFSSH_NO_DH` | すべての DH 鍵合意を無効にします。 |
| `WOLFSSH_NO_ECDH_SHA2_NISTP256` | NIST P-256 を用いた ECDH 鍵交換を無効にします。 |
| `WOLFSSH_NO_ECDH_SHA2_NISTP384` | NIST P-384 を用いた ECDH 鍵交換を無効にします。 |
| `WOLFSSH_NO_ECDH_SHA2_NISTP521` | NIST P-521 を用いた ECDH 鍵交換を無効にします。 |
| `WOLFSSH_NO_ECDH` | すべての ECDH 鍵合意を無効にします。 |
| `WOLFSSH_NO_CURVE25519_SHA256` | Curve25519 鍵交換を無効にします。 |
| `WOLFSSH_NO_NISTP256_MLKEM768_SHA256` | NIST P-256 と ML-KEM-768 を組み合わせたポスト量子ハイブリッド鍵交換を無効にします。 |
| `WOLFSSH_NO_NISTP384_MLKEM1024_SHA384` | NIST P-384 と ML-KEM-1024 を組み合わせたポスト量子ハイブリッド鍵交換を無効にします。 |
| `WOLFSSH_NO_CURVE25519_MLKEM768_SHA256` | Curve25519 と ML-KEM-768 を組み合わせたポスト量子ハイブリッド鍵交換を無効にします。 |
| `WOLFSSH_NO_RSA` | RSA サーバー認証およびユーザー認証を無効にします。 |
| `WOLFSSH_NO_SSH_RSA_SHA1` | SHA-1 を用いた RSA サーバー認証を無効にします。 |
| `WOLFSSH_NO_ECDSA` | ECDSA サーバー認証およびユーザー認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP256` | NIST P-256 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP384` | NIST P-384 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP521` | NIST P-521 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_AES_CBC` | AES-CBC 暗号化を無効にします。 |
| `WOLFSSH_NO_AES_CTR` | AES-CTR 暗号化を無効にします。 |
| `WOLFSSH_NO_AES_GCM` | AES-GCM 暗号化を無効にします。 |
| `WOLFSSH_NO_AEAD` | すべての AEAD 暗号を無効にします。 |

##  機能有効化マクロ

これらのマクロはサブシステム全体を有効にします。autotools ビルドでは、各マクロは
以下に示す対応する `./configure` オプションによって定義されます。これらの機能の
ほとんどに関連する API は、API リファレンスの各章で説明されています。

| マクロ | 有効化する機能 | Configure オプション |
|--------------------------------|---------------------|------------------------------|
| `WOLFSSH_SFTP` | SFTP サポート | `--enable-sftp` |
| `WOLFSSH_SCP` | SCP サポート | `--enable-scp` |
| `WOLFSSH_FWD` | TCP/IP ポートフォワーディング | `--enable-fwd` |
| `WOLFSSH_AGENT` | ssh-agent フォワーディング | `--enable-agent` |
| `WOLFSSH_CERTS` | X.509 証明書サポート | `--enable-certs` |
| `WOLFSSH_TPM` | TPM 2.0 ホスト鍵サポート | `--enable-tpm` |
| `WOLFSSH_SSHD` | wolfsshd デーモン | `--enable-sshd` |
| `WOLFSSH_SHELL` | echoserver のシェルサポート | `--enable-shell` |
| `WOLFSSH_KEYGEN` | 鍵生成 API | `--enable-keygen` |
| `WOLFSSH_KEYBOARD_INTERACTIVE` | キーボードインタラクティブ認証 | `--enable-keyboard-interactive` |
| `WOLFSSH_SSHCLIENT` | wolfSSH クライアントアプリケーション | `--enable-sshclient` |
| `WOLFSSH_TERM` | PTY / 端末処理 | デフォルトで有効（削除するには `--disable-term`） |
| `WOLFSSH_SMALL_STACK` | リソース制約のあるターゲット向けのスタック使用量削減 | `--enable-smallstack` |

次のマクロは、サブシステムを有効にするのではなく、動作を調整します。

| マクロ | 効果 |
|--------------------------------------|--------------------------------------------------|
| `WOLFSSH_NO_DEFAULT_LOGGING_CB` | 組み込みのデフォルトロギングコールバックを省略します。 |
| `WOLFSSH_NO_TIMESTAMP` | ログ出力からタイムスタンプを省略します。 |
| `WOLFSSH_NO_SYMLINK_CHECK` | SFTP のシンボリックリンク安全性チェックを無効にします。 |
| `WOLFSSH_NO_SFTP_BUFFER_ZERO` | 操作の間で SFTP 転送バッファをゼロクリアする処理をスキップします。 |

##  チューニングおよび値マクロ

これらのマクロは、オン/オフのスイッチとして機能するのではなく、数値を取ります。
デフォルトを上書きするには、ビルド時に定義します。

| マクロ | 意味 | デフォルト |
|-------------------------------------|-----------------------------------|--------------|
| `DEFAULT_WINDOW_SZ` | 初期のチャネルウィンドウサイズ（バイト単位）。 | 131072（128 KB） |
| `DEFAULT_MAX_PACKET_SZ` | チャネルの最大パケットサイズ（バイト単位）。 | 32768 |
| `DEFAULT_HIGHWATER_MARK` | 再鍵交換がトリガーされるまでのデフォルトのデータ最高水位（バイト単位）。 | 約 1 GB |
| `WOLFSSH_DEFAULT_MSG_HIGHWATER_MARK` | 再鍵交換がトリガーされるまでのデフォルトのパケット数最高水位。 | 0x80000000 |
| `WOLFSSH_MR_ROUNDS` | クライアントがサーバーの DH グループ交換素数を検査する際に使用する Miller-Rabin のラウンド数。 | 8 |
| `WOLFSSH_KEY_QUANTITY_REQ` | OpenSSH 形式の鍵ラッパーで必要な鍵の数。 | 1 |
| `WOLFSSH_MAX_FILENAME` | 最大ファイル名長（バイト単位）。 | 256 |
| `WOLFSSH_MAX_SFTP_RW` | SFTP の読み書きチャンクの最大サイズ（バイト単位）。 | 32768 |
| `WOLFSSH_MAX_SFTP_RECV` | SFTP の最大受信サイズ（バイト単位）。 | 32768 |
| `WOLFSSH_MAX_SFTP_NAME` | SFTP 名前リストの最大サイズ（バイト単位）。 | 1048576（1 MB） |
