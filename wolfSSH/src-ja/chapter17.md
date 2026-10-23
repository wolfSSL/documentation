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
| `WOLFSSH_NO_SSH_RSA_SHA1` | `ssh-rsa`（SHA-1 を用いた RSA）および `x509v3-ssh-rsa` を無効にします。 |
| `WOLFSSH_NO_RSA_SHA2_256` | `rsa-sha2-256` を無効にします。 |
| `WOLFSSH_NO_RSA_SHA2_512` | `rsa-sha2-512` を無効にします。 |
| `WOLFSSH_NO_ECDSA` | ECDSA サーバー認証およびユーザー認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP256` | NIST P-256 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP384` | NIST P-384 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP521` | NIST P-521 を用いた ECDSA 認証を無効にします。 |
| `WOLFSSH_NO_ED25519` | Ed25519 サーバー認証およびユーザー認証と、Ed25519 を用いた ML-DSA コンポジットを無効にします。wolfCrypt が署名、検証、ストリーミング検証、鍵のインポートとエクスポートを備えた Ed25519 を持たない場合に設定されます。 |
| `WOLFSSH_NO_MLDSA` | すべての ML-DSA サーバー認証およびユーザー認証を無効にします。wolfCrypt が ML-DSA を持たないか、バージョン 5.9.2 より前の場合に設定されます。 |
| `WOLFSSH_NO_MLDSA44` | ML-DSA-44 を無効にします。 |
| `WOLFSSH_NO_MLDSA65` | ML-DSA-65 を無効にします。 |
| `WOLFSSH_NO_MLDSA87` | ML-DSA-87 を無効にします。 |
| `WOLFSSH_NO_MLDSA44_ES256`, `WOLFSSH_NO_MLDSA65_ES256`, `WOLFSSH_NO_MLDSA87_ES384`, `WOLFSSH_NO_MLDSA44_ED25519`, `WOLFSSH_NO_MLDSA65_ED25519`, `WOLFSSH_NO_MLDSA87_ED448` | それぞれ 1 つの ML-DSA コンポジットを無効にします。ML-DSA のレベル、または組み合わせるアルゴリズムが無効になっている場合に設定されます。 |
| `WOLFSSH_NO_MLDSA_COMPOSITES` | すべての ML-DSA コンポジットを無効にします。 |
| `WOLFSSH_NO_OSSH_CERT_RSA` | RSA の OpenSSH 証明書を無効にします。RSA が無効になっている場合、または `rsa-sha2-256` と `rsa-sha2-512` の両方が無効になっている場合に設定されます。 |
| `WOLFSSH_NO_AES_CBC` | AES-CBC 暗号化を無効にします。 |
| `WOLFSSH_NO_AES_CTR` | AES-CTR 暗号化を無効にします。 |
| `WOLFSSH_NO_AES_GCM` | AES-GCM 暗号化を無効にします。 |
| `WOLFSSH_NO_AEAD` | すべての AEAD 暗号を無効にします。 |

また、RSA、ECDSA、Ed25519、ML-DSA がすべて無効になっている場合、ライブラリは
`WOLFSSH_NO_PUBKEY_AUTH` を設定し、公開鍵によるユーザー認証を除外します。

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
| `WOLFSSH_OSSH_CERTS` | OpenSSH 証明書によるユーザー認証 | `--enable-ossh-certs` |
| `WOLFSSH_WINDOWS_CERT_STORE` | Windows 証明書ストアからの鍵と証明書。`WOLFSSH_CERTS` と Windows ターゲットが必要 | `--enable-windows-cert-store` |
| `WOLFSSH_TPM` | ホスト鍵とユーザー鍵の TPM 2.0 サポート | `--enable-tpm` |
| `WOLFSSH_SSHD` | wolfsshd デーモン | `--enable-sshd` |
| `WOLFSSH_USE_PAM` | wolfsshd 用の PAM | `--with-pam` |
| `WOLFSSH_SHELL` | echoserver のシェルサポート | `--enable-shell` |
| `WOLFSSH_KEYGEN` | 鍵生成 API | `--enable-keygen` |
| `WOLFSSH_KEYBOARD_INTERACTIVE` | キーボードインタラクティブ認証 | `--enable-keyboard-interactive` |
| `WOLFSSH_SSHCLIENT` | wolfSSH クライアントアプリケーション | `--enable-sshclient` |
| `WOLFSSH_TERM` | PTY / 端末処理 | デフォルトで有効（削除するには `--disable-term`） |
| `WOLFSSH_SMALL_STACK` | リソース制約のあるターゲット向けのスタック使用量削減 | `--enable-smallstack` |
| `WOLFSSH_ALLOW_NONE_CIPHER` | 安全でない "none" 暗号および MAC のネゴシエーション | `--enable-none-cipher` |
| `NO_WOLFSSH_SERVER` | サーバーのコードを除外 | `--disable-server` |
| `NO_WOLFSSH_CLIENT` | クライアントのコードを除外 | `--disable-client` |

次のマクロは、サブシステムを有効にするのではなく、動作を調整します。

| マクロ | 効果 |
|--------------------------------------|--------------------------------------------------|
| `WOLFSSH_NO_DEFAULT_LOGGING_CB` | 組み込みのデフォルトロギングコールバックを省略します。 |
| `WOLFSSH_NO_TIMESTAMP` | ログ出力からタイムスタンプを省略します。 |
| `WOLFSSH_NO_SYMLINK_CHECK` | SFTP の制限ルート配下のシンボリックリンクを拒否するチェックと、それによるルート外へのアクセス防止を無効にします。 |
| `WOLFSSH_NO_SFTP_BUFFER_ZERO` | SFTP のファイルデータバッファを解放前にゼロクリアする処理をスキップします。`--disable-sftp-zeroize` によって設定されます。 |
| `WOLFSSH_NO_FPKI` | X.509 証明書に対する Federal PKI（FPKI）プロファイルのチェックをスキップします。 |
| `WOLFSSH_ALLOW_USERAUTH_NONE` | サーバーが "none" ユーザー認証方式を受け付けるようにし、それを `WOLFSSH_USERAUTH_NONE` としてユーザー認証コールバックに渡します。 |
| `WOLFSSH_SCP_USER_CALLBACKS` | デフォルトの SCP 送信・受信コールバックを省略します。アプリケーションは独自のコールバックを設定する必要があります。 |
| `WOLFSSH_USER_IO` | デフォルトのソケット I/O コールバックを省略します。アプリケーションは独自のコールバックを設定する必要があります。 |
| `WOLFSSH_CERT_STORE_ALLOW_EXPIRED` | 有効期間内の証明書が一致しない場合に、Windows 証明書ストアの検索で期限切れまたはまだ有効でない証明書を使用できるようにします。 |
| `WOLFSSH_IGNORE_UNKNOWN_CONFIG` | wolfSSHd は、未知またはサポートされていない設定行に対して起動に失敗する代わりに、警告をログに出力してその行を無視します。 |
| `WOLFSSH_NO_HOSTKEY_PERMS` | QNX において、wolfSSHd はホスト鍵ファイルの所有者とモードのチェックをスキップします。 |

##  チューニングおよび値マクロ

これらのマクロは、オン/オフのスイッチとして機能するのではなく、数値を取ります。
デフォルトを上書きするには、ビルド時に定義します。

| マクロ | 意味 | デフォルト |
|-------------------------------------|-----------------------------------|--------------|
| `DEFAULT_WINDOW_SZ` | 初期のチャネルウィンドウサイズ（バイト単位）。 | 131072（128 KB） |
| `DEFAULT_MAX_PACKET_SZ` | チャネルの最大パケットサイズ（バイト単位）。 | 32768 |
| `MAX_PACKET_SZ` | 送信または受け付ける SSH パケットの最大サイズ（バイト単位）。 | 35000 |
| `DEFAULT_MAX_AUTH_ATTEMPTS` | サーバーが切断するまでに許容するユーザー認証の失敗回数。 | 6 |
| `WOLFSSH_RSA_MIN_KEY_BITS` | RSA ユーザー認証鍵の最小サイズ（ビット単位）。 | 2048 |
| `WOLFSSH_DEFAULT_GEXDH_MIN` | クライアントが要求する DH グループ交換のグループの最小サイズ（ビット単位）。 | 2048 |
| `WOLFSSH_DEFAULT_GEXDH_PREFERRED` | クライアントが要求する DH グループ交換のグループの推奨サイズ（ビット単位）。 | 3072 |
| `WOLFSSH_DEFAULT_GEXDH_MAX` | クライアントが要求する DH グループ交換のグループの最大サイズ（ビット単位）。 | 8192 |
| `WOLFSSH_DH_GEX_MIN_BITS` | 双方が受け付ける DH グループ交換のグループの最小サイズ（ビット単位）。 | 2048 |
| `WOLFSSH_MAX_NAMELIST_SZ` | 接続相手から受け付ける name-list の最大サイズ（バイト単位）。 | 4096 |
| `WOLFSSH_MAX_NAMELIST_CNT` | 接続相手から受け付ける name-list 内の名前の最大数。 | 64 |
| `WOLFSSH_MAX_PVT_KEYS` | 1 つのコンテキストが保持できる秘密鍵の最大数。 | 16 |
| `WOLFSSH_MAX_PROMPTS` | keyboard-interactive プロンプトの最大数。 | 64 |
| `WOLFSSH_MAX_PROMPT_SZ` | keyboard-interactive プロンプトの最大サイズ（バイト単位）。 | 1024 |
| `DEFAULT_HIGHWATER_MARK` | 再鍵交換がトリガーされるまでのデフォルトのデータ最高水位（バイト単位）。 | 約 1 GB |
| `WOLFSSH_DEFAULT_MSG_HIGHWATER_MARK` | 再鍵交換がトリガーされるまでのデフォルトのパケット数最高水位。 | 0x80000000 |
| `WOLFSSH_MR_ROUNDS` | クライアントがサーバーの DH グループ交換素数を検査する際に使用する Miller-Rabin のラウンド数。 | 8 |
| `WOLFSSH_KEY_QUANTITY_REQ` | OpenSSH 形式の鍵ラッパーで必要な鍵の数。 | 1 |
| `WOLFSSH_MAX_FILENAME` | 最大ファイル名長（バイト単位）。 | 256 |
| `WOLFSSH_MAX_SFTP_RW` | SFTP の読み書きチャンクの最大サイズ（バイト単位）。 | 32768 |
| `WOLFSSH_MAX_SFTP_RECV` | SFTP の最大受信サイズ（バイト単位）。 | 32768 |
| `WOLFSSH_MAX_SFTP_NAME` | SFTP 名前リストの最大サイズ（バイト単位）。 | 1048576（1 MB） |
| `WOLFSSH_MAX_SFTP_PACKET` | サーバーが受け付ける SFTP リクエストの最大サイズ（バイト単位）。 | `WOLFSSH_MAX_SFTP_RW` + `WOLFSSH_MAX_SFTP_RECV` |
| `WOLFSSH_MAX_SFTP_HANDLES` | サーバーのセッションあたりにオープンできる SFTP ハンドルの最大数。 | 64 |
| `WOLFSSHD_DEFAULT_UMASK` | wolfSSHd のセッションが実行される umask。 | 022 |
