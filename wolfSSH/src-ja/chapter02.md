#  wolfSSHのビルド

wolfSSHはポータビリティを念頭において開発されているので多くのシステム上に移植するのは容易にできるはずです。ですが、もし移植上で問題がありましたら https://www.wolfssl.com/forums を参照されるか support@wolfssl.com へ質問をお寄せください。


この章ではwolfSSHを*nix システム（あるいはその派生システム）やWindows上でビルドする方法を説明します。また、上記以外のシステムにおいてのビルド方法のガイダンスも提供します。次章では「サンプルプログラムを使って始めてみよう」を用意しています。

autoconf/automakeシステムを使ってビルドする際にはwolfSSHは単一のMakefileによってすべてのコンポーネントとサンプルプログラムをビルドできます。Makefileを繰り返し使用する場合に比べてシンプルで早いです。

##  ソースコードの入手

最新バージョンのコードを入手する場合には次のGitHubサイトからダウンロードできます：<br>
 [https://github.com/wolfSSL/wolfSSH](https://github.com/wolfSSL/wolfSSH)

 “Download ZIP” ボタンをクリックするかターミナルを開いて次のコマンドを実行してください:<br>
 
```
$ git clone https://github.com/wolfSSL/wolfssh.git
```

##  wolfSSH が依存するモジュール

wolfSSHはwolfCryptに依存しているので、wolfSSLのコンフィギュレーションが必要となっています。wolfSSLはここからダウンロードできます:<br>
https://github.com/wolfSSL/wolfssl

最も簡潔なwolfSSHの構成のためのwolfSSLのコンフィギュレーションを行うにはwolfSSLのルートフォルダから以下のコマンドを実行します:<br>


```
$ ./autogen.sh (GitHubからクローンした場合にのみ実行が必要)
$ ./configure --enable-ssh
$ make check
$ sudo make install
```

wolfSSHの鍵生成機能を利用する場合には `--enable-keygen` を追加してください。
また、もしwolfSSLのコードが必要ない場合には `--enable-cryptonly` を追加してください。

上記により、wolfSSHの実行に必要なwolfSSLライブラリがインストールされます。

##   ＊nixシステム上でのwolfSSHのビルド

Linux, ＊BSD, OS X, Solaris ＊nix類似のシステム上でビルドを行う場合には、autoconfシステムを利用します。wolfSSHのビルドには以下のコマンドを実行します:<br>

```
$ ./autogen.sh (GitHubからクローンした場合にのみ実行が必要)
$ ./configure
$ make
$ make install
```

configureコマンドにはオプションを追加することができます。追加可能なオプションとその用途は以下のコマンドで参照することができます:<br>

```
$ ./configure --help
```

wolfSSHのビルドには以下を実行してください:

```
$ make
```

wolfSSHのビルドが正常に終了したことを確認する為に、以下のコマンドを実行して、全てのテストがパスすることを確認してください:


```
$ make check
```

以下を実行してwolfSSHをインストールします:

```
$ make install
```

インストールにはスーパーユーザー権限が必要なので、場合によっては以下の様に'sudo'コマンドを前置して実行する必要があるかもしれません:

```
$ sudo make install
```

場合によっては、wolfssh/src以下のwolfSSHライブラリだけをビルドし、その他のアイテム（サンプルプログラムやテスト）を除外したいかもしれません。その場合にはwolfSSHのルートフォルダから以下のコマンドを実行してください:

```
$ make src/libwolfssh.la
```

##  Windows上でのwolfSSHのビルド

Visual Studioプロジェクトファイルは`ide\winvs`ディレクトリにあります。


ソリューションファイル`wolfssh.sln`は、wolfSSHとそのサンプルプログラム、テストプログラムをビルドするように構成されています。32ビット版と64ビット版それぞれのスタティックライブラリとダイナミックライブラリについて、DebugビルドとReleaseビルドの構成を提供しています。wolfSSLのビルド設定には`user_settings.h`を使用してください。


このプロジェクトファイルは、wolfSSHとwolfSSLのソースディレクトリが同じ階層に並べて配置されており、ディレクトリ名にバージョン番号が含まれていないことを前提としています。つまり、次のようなディレクトリ構成です:


```
Projects\
    wolfssh\
    wolfssl\
```

wolfSSHは次の手順でビルドします:

1. `wolfssh\ide\winvs\user_settings.h`を`wolfssl\IDE\WIN`にコピーします。
   このファイルにはwolfSSLを構成するための設定が含まれています。
   一方を変更した場合は、もう一方も同じように変更してください。
   `WOLFCRYPT_ONLY`マクロはwolfSSLコードをビルド対象から除外し、
   wolfCryptのアルゴリズム部分のみをビルドするために定義されています。
   wolfSSLコードもビルドする場合は、この定義を削除してください。
2. `wolfssl\wolfssl64.sln`を使ってwolfSSLをビルドします。
3. `wolfssh\ide\winvs\wolfssh.sln`を使ってwolfSSHをビルドします。

wolfSSHをビルドする前に、同じ構成（Debug、Release、DLL Debug、DLL Release）と
プラットフォーム（Win32またはx64）でwolfSSLをビルドしておく必要があります。
wolfSSHのプロジェクトは`wolfssl\<構成>\<プラットフォーム>`
（例：`wolfssl\DLL Release\x64`）にあるwolfSSLライブラリを使用します。


### Windows上でのビルドに使用するユーザーマクロ定義



ソリューションでは、wolfSSLライブラリとヘッダーファイルの場所を指定するためにユーザーマクロを使用します。すべてのパスは、wolfssl64ソリューションの既定のビルド出力先に設定されています。ユーザーマクロ`wolfCryptDir`は、ライブラリを検索するためのベースパスとして使用します。初期値は`..\..\..\..\wolfssl`です。例えば、APIテストプロジェクトの「追加のインクルードディレクトリ」には`$(wolfCryptDir)`が設定されています。

`wolfCryptDir`のパスは、プロジェクトファイルからの相対パスで指定する必要があります。プロジェクトファイルはいずれも1階層下のディレクトリにあります（例）:



```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```

そのほかのユーザーマクロは、各ビルド構成のwolfSSLライブラリが置かれているディレクトリを示します。例えば、`wolfCryptDllRelease64`の初期値は次のとおりです:


```
$(wolfCryptDir)\DLL Release\x64
```

この値は、echoserverの64ビットDLL Releaseビルドのデバッグ環境で次のように使用されます:

```
PATH=$(wolfCryptDllRelease64);%PATH%
```

デバッガーからechoserverを実行すると、このディレクトリにあるwolfSSL DLLが読み込まれます。


##  その他の環境上でのビルド

公式にはサポートしていませんが、wolfSSHを非標準の環境でビルドしたいお客様、特に組み込み機器向け環境でのビルドをご希望の方々をできるだけお手伝いしようとしています。以下はその際に理解しておいていただきたい点です:

1. ソースとヘッダーファイルはwolfSSHダウンロードパッケージの階層構造に存在する必要があります。
2. いくつかのビルドシステムではwolfSSHヘッダーファイルの格納場所を明示的に指定することを求める場合があります。その格納場所は<wolfssh_root>/wolfsshディレクトリなので通常は<wolfssh_root>ディレクトリをインクルードファイルパスに追加することで解決します。
3. wolfSSHはコンフィギュレーションで指定されない限りリトルエンディアンをデフォルトにしています。ユーザーが使用している非標準環境ではconfigureコマンドを使用していない場合で、ビッグエンディアンシステムに指定する場合にはBIG_ENDIAN_ORDERマクロ定義が必要となります。
4. ライブラリをビルドしてみて何か問題が生じた場合にはwolfSSLにお知らせください。サポートが必要な場合には、support@wolfssl.com 宛てにご連絡ください。



##  クロスコンパイル

組み込み機器開発環境ではクロスコンパイルを行います。そのための簡単な方法はライブラリをコンフィギュアシステムを使ってクロスコンパイルを行うことです。コンフィギュアシステムはMakefileを一つ生成し、それを使ってwolfSSHをビルドします。

クロスコンパイルを行う際には、次の様にコンフィギュアを行うホストを指定する必要があります:

```
$ ./configure --host=arm-linux
```

さらにコンパイラ、リンカー等も指定する必要があるでしょう：

```
$ ./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```

クロスコンパイル用にwolfSSHを正しくコンフィギュレーションできた後は、標準のautoconf作法にしたがってビルドとライブラリのインストールを行います:

```
$ make
$ sudo make install
```

ここでご紹介した以外のTipsをお持ちでしたらぜひ facts@wolfssl.comまで お知らせください。

##  カスタムディレクトリへのインストール

wolfSSLをカスタムディレクトリへインストールする場合には次のようにしてください:

```
$ ./configure --prefix=`~`/wolfSSL
$ make
$ make install
```

上記コマンドによってライブラリを ”~/wolfSSL/lib” に、インクルードファイルを ”~/wolfssl/include” に配置するように指定します。wolfSSHをカスタムディレクトリに配置する場合には次の様にしてください:


```
$ ./configure  --prefix=`~`/wolfssh  --libdir=`~`/wolfssl/lib  --includedir=`~`/wolfssl/include
$ make
$ make install
```

上記パスがご自分の実際のディレクトリとマッチすることを確認して下さい。
