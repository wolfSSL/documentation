### MD5 コマンド
入力データの MD5 ハッシュを作成するために使用されます。 最後の引数は、ハッシュ対象のファイルです。ファイル引数が使用されていない場合、ハッシュ対象のデータはstdinから取得します。


使用例 :

```
wolfssl md5 configure.ac
978425cba5277d73db2a76d72b523d48
```

```
echo "hi" | wolfssl md5
764efa883dda1e11db47671c4a3bbd9e
```