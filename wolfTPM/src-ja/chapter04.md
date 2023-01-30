# wolfTPM ライブラリデザイン

## ライブラリヘッダーファイル

wolfTPM のヘッダーファイルは以下の場所に格納されています：<br>

**wolfTPM** :                     wolftpm/<br>

**wolfSSL** :                        wolfssl/<br>

**wolfCrypt** :                    wolfssl/wolfcrypt<br>

wolfTPMがインクルードすべき一般的なヘッダーファイルは次のファイルです：<br>

```
#include <wolftpm/tpm2.h>
```

## サンプルプログラムの設計

wolfTPM に含まれるすべてのサンプル アプリケーションには、wolfTPM/examples にある tpm_io.h ヘッダ ファイルをインクルードします。 tpm_io.c ファイルは、サンプル アプリケーションを Linux カーネル、STM32 CubeMX HAL、または Atmel/Microchip ASF でテストおよび実行するために必要なサンプル HAL IO コールバックをセットアップします。 カスタム IO コールバックまたは別のコールバックを必要に応じて追加または削除できるように、参照は簡単に変更できます。
