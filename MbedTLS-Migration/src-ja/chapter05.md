# ハードウェアとプラットフォーム

## ハードウェアアクセラレーション

wolfSSL は `wolfcrypt/src/port/` に 30 を超えるハードウェアおよびプラットフォーム向けのポートを同梱しています（NXP、ST、Renesas、Microchip、Cypress PSoC 6、Silicon Labs、Espressif、Xilinx、Intel QuickAssist など）。
さらに、Intel AES-NI/AVX、ARMv8、RISC-V 向けに手作業で最適化したアセンブリも含まれています。
ドライバを作成する前に、お使いのデバイス向けのポートがこのディレクトリにないか確認してください。

## 暗号コールバック

ツリー内にポートが存在しないハードウェアでは、暗号コールバックインターフェース（`--enable-cryptocb`）が実装すべき唯一のフックです。
Mbed TLS の代替手段と比較すると次のようになります。

- 暗号の `_ALT` マクロ（3.6）は、コンパイル時にソフトウェア実装を置き換え、すべての呼び出し元に影響します。
  4.x では廃止されています。
- PSA ドライバ（4.x）は、いまだベータとされている仕様に従っています。
  ディスパッチ層の一部のみがコード生成され、残りは手作業で接続します。
- wolfSSL の暗号コールバックは、実行時にデバイス ID の下で登録され、個々のオブジェクトまたは TLS コンテキスト全体がそのデバイス ID を選択して利用します。
  コールバックが `CRYPTOCB_UNAVAILABLE` を返すとソフトウェア処理にフォールバックします。
  このインターフェースはハッシュ、共通鍵暗号、MAC、RNG、従来型およびポスト量子の公開鍵アルゴリズムをカバーしているため、ML-KEM や ML-DSA の処理もセキュアエレメントや HSM に任せることができます。
  ただし、鍵をデバイス内にだけ保持したまま ML-KEM のデカプセル化を行うには、wolfSSL 5.9.4 より新しいリリース（5.9.4 は含まない）が必要です。

コンテキスト上のすべての TLS 接続で ECDSA 署名をオフロードする例は次のとおりです。

```c
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/cryptocb.h>
#include <wolfssl/ssl.h>

#define MY_HW_DEVID 0x48570001

int my_hw_ecdsa_sign(const byte* hash, word32 hashSz, byte* sig,
                     word32* sigSz, ecc_key* key);

static int myHwCallback(int devId, wc_CryptoInfo* info, void* ctx)
{
    (void)devId;
    (void)ctx;
    if (info->algo_type == WC_ALGO_TYPE_PK &&
        info->pk.type == WC_PK_TYPE_ECDSA_SIGN) {
        return my_hw_ecdsa_sign(info->pk.eccsign.in, info->pk.eccsign.inlen,
                                info->pk.eccsign.out, info->pk.eccsign.outlen,
                                info->pk.eccsign.key);
    }
    return CRYPTOCB_UNAVAILABLE; /* それ以外はすべてソフトウェアで処理 */
}

int use_hw(WOLFSSL_CTX* ctx)
{
    if (wc_CryptoCb_RegisterDevice(MY_HW_DEVID, myHwCallback, NULL) != 0)
        return -1;
    return wolfSSL_CTX_SetDevId(ctx, MY_HW_DEVID) == WOLFSSL_SUCCESS ? 0 : -1;
}
```

`sig` には DER 形式の署名が格納されます。
生の r と s は `wc_ecc_rs_raw_to_sig()` で変換してください。
秘密鍵をセキュアエレメント内に保持したままにするには、同じデバイス ID を指定して `wolfSSL_CTX_use_PrivateKey_Id()` で読み込みます。
wolfHSM、wolfTPM、PKCS#11 も同じ仕組みで動作しています。
また、PK コールバック（`--enable-pkcallbacks`）は TLS レベルでの代替手段を提供します。

`use_hw()` は `wolfSSL_new()` より前に呼び出してください。
各 `WOLFSSL` は、作成時にコンテキストのデバイス ID を引き継ぎます。
すでに存在するセッションに対しては、`wolfSSL_SetDevId()` で設定します。

## Zephyr

Zephyr の TLS ソケット（`SOL_TLS`）は Mbed TLS 上に構築されています。
wolfSSL は [Zephyr モジュール](https://github.com/wolfSSL/wolfssl/tree/master/zephyr)を提供しており、[wolfSSL OSP リポジトリ](https://github.com/wolfSSL/osp/tree/master/zephyr)には、サポート対象の Zephyr リリースごとに TLS ソケットを wolfSSL に切り替えるパッチが用意されています。
新しいリリースに移行する際は、パッチを再適用してください。
Bluetooth など PSA Crypto API を使用するサブシステムは、[wolfPSA](https://github.com/wolfSSL/wolfPSA) を Zephyr の PSA Crypto プロバイダとして使うことで、変更なしに wolfCrypt 上で動作します。

## ESP-IDF

wolfSSL は Espressif Component Registry のマネージドコンポーネントとして提供されています。
ビルド手順とサンプルは、wolfSSL リポジトリの [IDE/Espressif](https://github.com/wolfSSL/wolfssl/tree/master/IDE/Espressif) にあります。

## その他のプラットフォーム

wolfSSL の `IDE/` ディレクトリには 60 を超える IDE およびプラットフォーム向けのプロジェクトがあり、そのほかにも Arduino および PlatformIO 向けのパッケージや、Linux および BSD のカーネルモジュールが用意されています。
configure を使わないビルドでは `user_settings.h` を使用します。
テンプレートは `examples/configs/` にあります。
