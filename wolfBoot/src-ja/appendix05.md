# wolfBootをライブラリとしてビルド

wolfBootをスタンドアロンリポジトリではなくセキュアブートライブラリとしてビルドし、サードパーティのブートローダーやカスタムステージングソリューションなどに統合することもできます。

## ライブラリAPI

wolfBootセキュアブートイメージ検証は非常にシンプルなインターフェースを持っています。
イメージを記述するコアオブジェクトは`struct wolfBoot_image`であり、`wolfBoot_open_image_address()`が呼び出されるときに初期化されます。
シグネチャは以下のとおりです。

`int wolfBoot_open_image_address(struct wolfBoot_image* img, uint8_t* image)`

ここで`img`はローカルの（初期化されていない）`wolfBoot_image`型の構造体へのポインタで、`image`はマニフェストヘッダーの先頭から始まる、署名されたイメージがメモリにマップされている場所へのポインタです。

成功すると、ゼロが返されます。
イメージがマニフェストの先頭に有効な「マジックナンバー」を含んでいない場合、またはイメージのサイズが`WOLFBOOT_PARTITION_SIZE`より大きい場合、`-1`が返されます。

`open_image_address`操作が成功した場合、他の2つの関数を呼び出すことができます。

- `int wolfBoot_verify_integrity(struct wolfBoot_image *img)`

この関数は、イメージの内容のSHAハッシュを計算し、マニフェストヘッダーに保存されているダイジェストと比較することによって、イメージの整合性を検証します。
`img`は以前に`wolfBoot_open_image_address`によって初期化された`wolfBoot_image`型のオブジェクトへのポインタです。

イメージの整合性が正常に検証できた場合は0が返され、そうでない場合は`-1`が返されます。

- `int wolfBoot_verify_authenticity(struct wolfBoot_image *img)`

この関数は、イメージの内容が信頼できる相手によって署名されたこと（つまり、利用可能な公開鍵の1つを使用して検証できること）を確認します。

認証が成功した場合は`0`が返され、操作中に何か問題が発生した場合は`-1`が返され、署名が見つかったが公開鍵に対して認証できなかった場合は`-2`が返されます。

## ライブラリモード：サンプルアプリケーション

サンプルアプリケーションは`hal/library.c`で提供しています。

アプリケーション`test-lib`はコマンドラインから引数として渡されたパスからファイルを開き、そのファイルが有効で署名されたイメージを含み、ライブラリモードでwolfBootを使用して整合性と真正性を検証できることを確認します。

## test-libアプリケーションの設定とコンパイル

ステップ1：提供された設定を使用してライブラリモードでwolfBootをコンパイルします。

```sh
cp config/examples/library.config .config
```

ステップ2：次の行だけを含む`target.h`ファイルを作成します。

```sh
cat > include/target.h << EOF
#ifndef H_TARGETS_TARGET_
#define H_TARGETS_TARGET_

#define WOLFBOOT_NO_PARTITIONS

#define WOLFBOOT_SECTOR_SIZE                 0x20000
#define WOLFBOOT_PARTITION_SIZE              0x20000

#endif /* !H_TARGETS_TARGET_ */

EOF
```

`WOLFBOOT_PARTITION_SIZE`は適宜変更してください。
`wolfBoot_open_image_address()`は`WOLFBOOT_PARTITION_SIZE` - `IMAGE_HEADER_SIZE`より大きいイメージを廃棄します。


ステップ3：keytoolsをコンパイルし、鍵を作成します。

```sh
make keytools
./tools/keytools/keygen --ed25519 -g wolfboot_signing_private_key.der
```


ステップ4：空のファイルを作成し、秘密鍵を使用して署名します。

```sh
touch empty
./tools/keytools/sign --ed25519 --sha256 empty wolfboot_signing_private_key.der 1
```


ステップ5：ライブラリモードのwolfBootとステップ4で作成した鍵ペアの公開鍵にリンクされたtest-libアプリケーションをコンパイルします。

```sh
make test-lib
```

ステップ6：署名されたイメージでアプリケーションを実行します。

```sh
./test-lib empty_v1_signed.bin
```

すべてがうまくいった場合、出力は次のようになるはずです。

```sh
Firmware Valid
booting 0x5609e3526590(actually exiting)
```
