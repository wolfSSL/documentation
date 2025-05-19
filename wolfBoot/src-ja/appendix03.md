# One Time Programmable (OTP) フラッシュ領域を鍵ストアとして使用

一部のマイクロコントローラーは、一度だけ書き込みが可能で消去できないフラッシュメモリの特別な領域を提供しています。

この機能は、ファームウェア更新イメージを認証するために必要な公開鍵を保存する場合に特に便利です。
公開鍵は自由に配布できる暗号鍵であり、ファームウェア更新イメージの署名を検証するために使用されます。
公開鍵をOTP領域に保存することで、それらが不変であり改ざんできないことを保証できます。

## OTPを鍵ストアとしてアクセスするためのwolfBootのコンパイル

OTP領域を鍵ストアとして使用するには、`FLASH_OTP_KEYSTORE`オプションを有効にしてwolfBootをコンパイルする必要があります。
このオプションはデフォルトでは無効であり、鍵ストアはwolfBootバイナリ自体に組み込まれています。

wolfBootがOTP領域を鍵ストアとして使用する場合、実行時にOTP領域から公開鍵を読み取ります。
公開鍵は、格納されている鍵の数、各鍵のサイズ、その他の情報を含む最初の16バイトヘッダーの後にOTP領域に格納されます。

wolfBootが起動時や更新時にファームウェアイメージの認証を開始するためには、次のセクションで説明するように、公開鍵を別のステップでOTP領域にプロビジョニングする必要があります。

ターゲットデバイスに応じて、OTP領域コンテンツのバイナリイメージを準備するか、`otp-keystore-primer`ファームウェアを使用してターゲットに直接鍵をプロビジョニングできます。

## OTP領域コンテンツのイメージの作成

OTP領域のコンテンツのバイナリイメージを作成できます。
結果のファイル（`otp.bin`）は、ターゲットOTP領域への書き込みを可能にする任意の外部ツールを使用して手動でプロビジョニングできます。

現在の鍵ストアコンテンツを使用してotp-keystore-genツールをコンパイルするには、次のようにします。

```sh
make otpgen
```

そして、イメージファイル`otp.bin`を作成するには、次のようにします。

```sh
./tools/keytools/otp/otp-keystore-gen
```

## OTP領域への公開鍵の直接プロビジョニング（プライマー）

`.config`ファイルで`FLASH_OTP_KEYSTORE`オプションを有効にした後、「`make`」を実行してwolfBootをコンパイルすると、`tools/keytools/otp`の下に`otp-keystore-primer`という追加アプリケーションが生成されます。
このアプリケーションはOTP領域に公開鍵をプロビジョニングするために使用されます。
このアプリケーションをマイクロコントローラーにフラッシュすることで、鍵ストア（以前に`keygen`によって生成された）に含まれる公開鍵がOTP領域に書き込まれます。

`otp-keystore-primer`アプリケーションは埋め込まれた公開鍵で生成されます。
鍵は`keygen`コマンドによって生成された`keystore.c`ファイルから取得されます。
`otp-keystore-primer`アプリケーションは`keystore.c`ファイルから公開鍵を読み取り、OTP領域に書き込みます。

`keygen`アプリケーションで新しい`keystore.c`を生成した後、`make otp`を実行することで、`otp-keystore-primer`アプリケーションを再度生成できます。

> [!警告]
> `otp-keystore-primer`アプリケーションは一回限りのアプリケーションです。アプリケーションがターゲットで実行されると、公開鍵がOTP領域に書き込まれ、それらを消去することは不可能になります。したがって、公開鍵をOTP領域にプロビジョニングする前に、公開鍵が正しいことを確認し、関連する秘密鍵が安全に保存されていることを確認することが重要です。誤って秘密鍵を紛失すると、OTP領域に保存されている公開鍵は使用できなくなります。

> [!注意]
> **`otp-keystore-primer`アプリケーションを使用する際は十分注意してください。ご自身の責任で使用してください。**

## 例

### STM32H5 OTP KeyStore

NULCLEO-STM32H563ZI（TrustZone（PKCS11経由）、DualBank、PQ LMSによる署名）の場合

1) 設定と鍵ツールをセットアップする

```sh
cp config/examples/stm32h5-tz-dualbank-otp-lms.config .config
make include/target.h
make keytools
```

2) OTPに書き込む鍵を生成する

 - `./examples/keytools/keygen --lms -g 1.key -g 2.key -g 3.key -g 4.key -g 5.key`

3) 生成された鍵と`src/keystore.c`をバックアップする

 - wolfBootツリー外の安全な場所に保存する

4) 使用する署名鍵を設定する

 - 生成された鍵の1つを`wolfboot_signing_private_key.der`にコピーする
 - `cp 1.key wolfboot_signing_private_key.der`

5) OTP鍵ストアをセットアップする

 OTP鍵ストアプライマーをフラッシュする
 
 - `make otp`を実行する
 - `./tools/keytools/otp/otp-keystore-primer.bin`を`0x08000000`にフラッシュする
 - ツールを切断してリセットボタンを押す
 - プライマーが実行され、keystore.cをOTPにフラッシュし、それらのブロックに書き込み保護を有効にする

 または

 外部ツールを使用してOTP（otp.bin）を生成してフラッシュする
 
 - `make otpgen`を実行する
 - `./tools/keytools/otp/otp-keystore-gen`を実行してotp.binファイルを生成する
 - STM32CubeProgrammerなどの外部ツールを使用してotp.binを`0x08FFF000`にプログラムする

6) OTP鍵ストアを検証する

 - アドレス`0x08FFF000`のメモリを読み取る（ASCII「`WOLFBOOT`」で始まるはずです）
 - 通常はSTM32CubeProgrammerを使用する

7) オプションバイトを設定する

 - ユーザー構成2 -> TrustZone有効（TZEN=0xB4）
 - Bank1 - フラッシュウォーターマークエリア（`SECWM1_START=0x00`、`SECWM1_END=0x1F`）
 - Bank2 - フラッシュウォーターマークエリア（`SECWM2_START=0x00`、`SECWM2_END=0x1F`）

8) デバイスの一括消去

 - STM32CubeProgrammer -> フルチップ消去

9) `make`を使用してwolfBootとテストアプリケーションをビルドする

10) wolfBootとtest-appをフラッシュする

- `wolfboot.bin`を`0x0C000000`にフラッシュする
- `test-app/image_v1_signed.bin`を`0x08040000`にフラッシュする

11) 切断して再起動すると、赤色LEDが点灯するはず。

12) コンソール用にNUCLEOボード上のUSB UARTに接続する

コマンドラインを探索する（helpを実行）

```sh
========================
STM32H5 wolfBoot demo Application
Copyright 2024 wolfSSL Inc
GPL v3
Version : 0x1
========================

cmd> help
help : shows this help message
info : display information about the system and partitions
success : confirm a successful update
pkcs11 : enable and test crypto calls with PKCS11 in secure mode
random : generate a random number
timestamp : print the current timestamp
benchmark : run the wolfCrypt benchmark
test : run the wolfCrypt test
update : update the firmware via XMODEM
reboot : reboot the system
```

13) 更新をテストする

 - ファームウェアの新しいバージョンに署名する：`./tools/keytools/sign --lms test-app/image.bin wolfboot_signing_private_key.der 2`
 - シェルで「update」コマンドを実行し、xmodem転送を待つ
 - 「minicom」や「CoolTerm」などのxmodemをサポートするシリアルターミナルを使用する。
   * `/dev/ttyACM0`で`minicom`を実行し、「CTRL+A; S」を使用してファイル転送を開始する
   * xmodemを選択し、新しい署名付きファームウェアファイル`test-app/image_v2_signed.bin`に移動する
 - 転送中、黄色のLEDが点滅する。
 - 緑色のLEDはUART RXと同期しているため薄暗い
 - 転送の終わりに、新しいイメージが更新パーティションに配置される。
 - ボードをリセットして新しいファームウェアをインストールし、新しいバージョン番号を確認する。

更新出力の例：

```sh
cmd> update
Erasing update partition...Done.
Waiting for XMODEM transfer...
.................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................




End of transfer. ret: 0
New firmware version: 0x2
Triggering update...
Update completed successfully.

cmd> reboot

========================
STM32H5 wolfBoot demo Application
Copyright 2024 wolfSSL Inc
GPL v3
Version : 0x2
========================

cmd>
```
