## wolfCLUのビルド

### *NIX上でのビルド

wolfCLU のビルドに先立ち、最初に --enable-wolfclu フラグを指定して 次のようにwolfSSL をビルドしインストールする必要があります：

```
cd wolfssl
./configure --enable-wolfclu
make
sudo make install
```
    
RC2を使用してPKCS12ファイルを解析する場合、またはCRLを使用する場合には、wolfSSLのビルドの際にフラグ "--enable-rc2" および "--enable-crl" も使用する必要があることに注意してください。

次に、作成した wolfSSLライブラリをリンクしてwolfCLUをビルドします。

```
cd wolfclu
./configure
make
sudo make install
```

あるいは

```
cd wolfclu
./configure --with-wolfssl=/path/to/wolfssl/install
make
sudo make install
```

ユニットテストを実行する場合には"make check"を実行してください。


### Windows上でのビルド

wolfCLU は、そのVisual Studioソリューションファイルである wolfclu.sln を使用してビルドすることもできます。 このソリューションファイルは、32ビットまたは 64ビットのダイナミックリンクライブラリのデバッグ ビルドとリリース ビルドの両方を提供します。コンフィグレーションオプション指定のためにファイル`user_settings.h`を用意する必要があります。

この`user_settings.h`のテンプレートとして使用できるファイルが`wolfclu\ide\winvs\user_settings.h` に用意してありいます。このファイルを、ディレクトリ `wolfclu\ide\winvs` から `wolfssl\IDE\WIN` にコピーして使用してください。wolfCLU をサポートする wolfSSL をビルドすることができます。

wolfCLU をビルドする前に、wolfSSL で使用されているのと同じアーキテクチャ (Win32 または x64) が選択されていることを確認してください。

このプロジェクトでは、wolfSSH および wolfSSL ソース ディレクトリが各々バージョン番号がない状態でサイドバイサイドで配置されていることを前提としています：

```
    Projects\
        wolfclu\
        wolfssl\
```
リリース構成でwolfCLUをビルドすると、`Release\Win32` あるいは `Release\x64`フォルダに`wolfssl.exe`が生成されます。
 

#### ユニットテストの実行

シェルスクリプトのユニットテストを実行するには、`shコマンド`または`bashコマンド`のいずれかが必要です。
どちらのコマンドも、Windows の Git インストールに付属しています (ただし、それらを PATH に追加する必要がある場合があります)。

1. wolfssl.exe を wolfclu のルートディレクトリにコピーします。
2. `./wolfssl $1` の代わりに `./wolfssl.exe $1` を実行するように、目的のユニットテストの `run` 関数 (存在する場合は `run_fail` も) を変更します。
3. ターミナルで、ルート ディレクトリから `sh <desired_unit_test>` を実行します。 たとえば、ハッシュ ユニット テストを実行するには、`sh tests\hash\hash-test.sh`を実行します。
