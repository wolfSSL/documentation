### RSA コマンド

RSA操作を行います。 RSA鍵の読み取り、RSA鍵またはモジュラスの出力、暗号化された PEM ファイルの読み取りが含まれます。 入力と出力の DER と PEM 形式の両方を処理できます。

引数:

- [-in] 入力となる鍵ファイル
- [-inform] 入力ファイル形式：PEM あるいは DER (デフォルト：PEM)
- [-out] 出力ファイル(デフォルト：stdout)
- [-outform] 出力ファイル形式：PEM あるいは DER (デフォルト：PEM)
- [-passin] PEM形式の暗号化されたファイルのパスワード
- [-noout] 鍵をプリントアウトしない
- [-modulus] RSA modulus (n value)をプリントする
- [-RSAPublicKey_in] 公開鍵入力を期待する
