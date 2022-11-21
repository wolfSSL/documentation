

# wolfBootの既存のプロジェクトへの統合




## 必要な手順






- 参照実装の例については、[ターゲット](chapter03.md#targets)の章を参照してください。

- ターゲットプラットフォームのHAL実装を提供します([ハードウェア抽象化レイヤー](chapter04.md#hardware-abstraction-layer)を参照)

- フラッシュパーティションの方針を決定し、それに応じて`include/target.h`を変更します([フラッシュパーティション](chapter05.md#flash-partitions)を参照)

- ブートローダーの存在を考慮して、ファームウェアイメージのエントリポイントを変更します

- アプリケーションに[wolfBootライブラリ](chapter06.md#application-interface-for-interactions-with-the-bootloader)を装備して、ブートローダーと対話します

- [構成してコンパイルします](chapter02.md#compiling-wolfboot)単一の「make」コマンドを備えた起動可能なイメージ

- ファームウェアの署名については、[wolfBoot署名](chapter06.md#signing)を参照してください

- メジャードブートを有効にするには、[wolfBoot管理ブート](chapter06.md#measured-boot)を参照してください




## 提供されているサンプルプログラム



[GitHub wolfBoot-Examplesリポジトリ](https://github.com/wolfSSL/wolfBoot-examples)でも別のサンプルプログラムが入手できます。


次の手順は、工場イメージ（工場出荷時のアプリケーションイメージ）を作成するための例として非OSのテストアプリケーションを使用して、デフォルトの`Makefile`ターゲットで自動化されています。`make`を実行することにより、ビルドシステムは次のとおりです。





- `ed25519_keygen`ツールを使用して、ED25519鍵ペアを作成します

- ブートローダーをコンパイルします。上記のステップで生成された公開鍵はビルドに含まれています

- 「test_app」ディレクトリにあるテスト アプリケーションからファームウェア イメージをコンパイルします。

- ファームウェアを再リンクして、エントリポイントをプライマリパーティションの開始アドレスに変更します

- `ed25519_sign`ツールを使用してファームウェアイメージに署名します

- ブートローダーとファームウェアイメージを連結して、工場イメージを作成します

工場イメージはターゲットデバイスにフラッシュできます。フラッシュ上の指定されたアドレスにブートローダーと署名された初期ファームウェアが含まれています。


`sign.py`ツールは、ブートローダーが必要とするファームウェアイメージ形式に準拠するように、起動可能なファームウェアイメージを変換します。


ファームウェアイメージ形式の詳細については、[ファームウェアイメージ](chapter06.md#firmware-image)を参照してください。


ターゲットシステムの構成オプションの詳細については、[WolfBootのコンパイル](chapter02.md#compiling-wolfboot)を参照してください。



## ファームウェアのアップグレード




- 新しいファームウェアイメージをコンパイルし、そのエントリポイントがプライマリパーティションの開始アドレスにあるようにリンクします

- `sign.py`ツールと、工場のイメージ用に生成された秘密鍵を使用してファームウェアに署名します

- 安全な接続を使用してイメージを転送し、セカンダリファームウェアスロットに保存します

- libwolfboot `wolfBoot_update_trigger()`関数を使用してイメージスワップをトリガーします。操作の説明については、[wolfBoot Library API](chapter06.md#application-interface-for-interactions-with-the-bootloader)を参照してください


- 再起動して、ブートローダーがイメージスワップを開始します

- libwolfboot `wolfBoot_success()`関数を使用して、更新の成功を確認します。操作の説明については、[wolfBoot Library API](chapter06.md#application-interface-for-interactions-with-the-bootloader)を参照してください



ファームウェアの更新実装の詳細については、[ファームウェアの更新](chapter06.md#firmware-update)を参照してください。

