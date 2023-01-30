# 始めに

wolfTPM は、組み込み用途向けに設計された後方 API 互換性を備えた移植可能なオープンソース TPM 2.0 スタックです。 C言語で書かれており、SPIハードウェア インターフェイス用のIOコールバックは1つだけであり、外部依存関係がなく、リソース使用量が少なくコンパクトなコードであるため、移植性が高くなります。 wolfTPM は、認証などの複雑なTPM操作を支援するAPIラッパーと、TPMを使用した証明書署名要求 (CSR) の生成などの複雑な暗号化プロセスを支援するサンプルプログラムを提供します。


## プロトコル概要

トラステッド・プラットフォーム・モジュール (TPM、ISO/IEC 11889 とも呼ばれる) は、統合された暗号化鍵を通じてハードウェアを保護するように設計された専用のマイクロ コントローラーであり、安全な暗号化プロセッサの国際標準です。 各TPMチップには、製造時に固有の秘密のRSA鍵が焼き付けられているため、コンピュータープログラムはTPMを使用してハードウェアデバイスを認証できます。

ウィキペディアによると、TPM は次の機能を提供します[\[1\]](chapter06.md#cited-sources) :

- 乱数生成器

- 用途が限定された暗号鍵を安全に生成する機能

- リモート認証: ハードウェアおよびソフトウェア構成のほぼ偽造不可能なハッシュ鍵のサマリーを作成します。 構成データのハッシュを担当するソフトウェアによって、要約の範囲が決まります。 これにより、第三者はソフトウェアが変更されていないことを確認できます。

- バインド: ストレージ鍵から派生した一意のRSA鍵であるTPMバインド鍵を使用してデータを暗号化します。

- シール: バインドに似ていますが、さらに、復号(アンシール)されるデータのTPM 状態を指定します。

さらに、TPMは、プラットフォームの整合性、ディスク暗号化、パスワード保護、ソフトウェアライセンス保護などのさまざまなアプリケーションにも使用できます。

## 階層

プラットフォーム: **TPM_RH_PLATFORM**

オーナー: **PM_RH_OWNER**

エンドースメント: **TPM_RH_ENDORSEMENT**

各階層には、製造時に生成された独自のシード（種）があります。 TPM2_Create または TPM2_CreatePrimary で使用される引数はテンプレートを作成します。テンプレートはKDFに供給され、使用されるのと同じ鍵ベースの階層を生成します。生成される鍵は再起動しても毎回同一のものとなります。新しいRSA2048ビット鍵の生成には約 15 秒かかります。

通常、これらは作成され、TPM2_EvictControl を使用して NV に格納されます。 各 TPM は、シードに基づいて独自の鍵を一意に生成します。 一時的な鍵を作成するために使用できる一時的な階層 (TPM_RH_NULL) もあります。



## プラットフォーム構成レジスター(PCR)

プラットフォーム構成レジスタ (PCR) は、TPM の重要な機能の 1 つです。 主な使用例は、ソフトウェアの状態 (プラットフォーム上で実行されているソフトウェアとそのソフトウェアによって使用される構成データの両方) を暗号化して記録 (測定) する方法を提供することです。[\[2\]](chapter06.md#cited-sources)

wolfTPM には、SHA-1 および SHA-256 のインデックス 0 ～ 23 のハッシュ ダイジェストが含まれています。 これらのハッシュダイジェストを拡張して、ブートシーケンス (セキュアブート) の整合性を証明できます。


## 用語

このプロジェクトでは、append と marshall および parse と unmarshall という用語を使用しています。

## ハードウエア

wolfTPMは下記のハードウエアでテスト済みです:

* Infineon OPTIGA (TM) Trusted Platform Module 2.0 SLB 9670.
    - LetsTrust: [http://letstrust.de] (<https://buyzero.de/collections/andere-platinen/products/letstrust-hardware-tpm-trusted-platform-module).> Compact Raspberry Pi TPM 2.0 board based on Infineon SLB 9670.

* ST ST33TP* TPM 2.0 モジュール (SPI and I2C)

* Microchip ATTPM20 モジュール

* Nuvoton NPCT65X or NPCT75x TPM2.0 モジュール

### デバイスID

Infineon SLB9670:
TIS: TPM2: Caps 0x30000697, Did 0x001b, Vid 0x15d1, Rid 0x10
Mfg IFX (1), Vendor SLB9670, Fw 7.85 (4555), FIPS 140-2 1, CC-EAL4 1

ST ST33TP SPI
TPM2: Caps 0x1a7e2882, Did 0x0000, Vid 0x104a, Rid 0x4e
Mfg STM  (2), Vendor , Fw 74.8 (1151341959), FIPS 140-2 1, CC-EAL4 0

ST ST33TP I2C
TPM2: Caps 0x1a7e2882, Did 0x0000, Vid 0x104a, Rid 0x4e
Mfg STM  (2), Vendor , Fw 74.9 (1151341959), FIPS 140-2 1, CC-EAL4 0

Microchip ATTPM20
TPM2: Caps 0x30000695, Did 0x3205, Vid 0x1114, Rid 0x 1
Mfg MCHP (3), Vendor , Fw 512.20481 (0), FIPS 140-2 0, CC-EAL4 0

Nations Technologies Inc. TPM 2.0 module
Mfg NTZ (0), Vendor Z32H330, Fw 7.51 (419631892), FIPS 140-2 0, CC-EAL4 0

Nuvoton NPCT650 TPM2.0
Mfg NTC (0), Vendor rlsNPCT , Fw 1.3 (65536), FIPS 140-2 0, CC-EAL4 0

Nuvoton NPCT750 TPM2.0
TPM2: Caps 0x30000697, Did 0x00fc, Vid 0x1050, Rid 0x 1
Mfg NTC (0), Vendor NPCT75x"!!4rls, Fw 7.2 (131072), FIPS 140-2 1, CC-EAL4 0


