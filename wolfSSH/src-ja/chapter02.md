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

Visual Studioプロジェクトファイルは以下で取得できます:
https://github.com/wolfSSL/wolfssh/blob/master/ide/winvs/wolfssh.sln


ソリューションファイル'wolfssh.sln'はwolfSSH,そのサンプルプログラムとテストプログラムをビルドするように構成されています。DebugビルドとReleaseビルドの構成をスタティックリンクライブラリとダイナミック（32/64ビット）ライブラリの両形式で提供しています。user_settings.hはwolfSSLのコンフィギュレーションで必要となります。


このプロジェクトファイルではwolfSSHとwolfSSLのソースフォルダ階層が隣同士に配置されていることを前提にしています。また、それらのルートフォルダにはバージョン番号が含まれていないフォルダ名となっていることを前提としています。つまり、次のようなフォルダ構成です:


```
Projects\
wolfssh\
wolfssl\
```

`wolfssh\ide\winvs\user_settings.h`ファイルはwolfSSLに対する設定も既に含んだ適切な内容となっています。このファイルを忘れずに`wolfssh\ide\winvs`フォルダから`wolfssl\IDE\WIN`フォルダにコピーしてください。もし、一方の内容を変更した場合には、
その内容を他方にもコピーして下さい。

`WOLFCRYPT_ONLY`マクロ定義はwolfSSLコードをビルド対象から除外し、wolfCryptのアルゴリズム部分のみをビルドするの為に指定してあります。もし、wolfSSLコードもビルドする場合にはこの定義を削除してください。


### Windows上でのビルドに使用するユーザーマクロ定義



ソリューションではwolfSSLライブラリとヘッダーファイルのロケーションを指定するためにユーザーマクロを利用します。wolfssl64ソリューションでは全てのパスは既定のビルド出力先に設定されます。ユーザーマクロ'wolfCryptDir'はライブラリを検索するためのベースパスとして使用します。初期値として、`..\..\..\..\wolfssl`に設定されています。その後、例えば追加のインクルードファイル検索パスが追加される場合には、`$(wolfCryptDir)`に対して追加を行います。

wolfCryptDirパスはプロジェクトファイルからの相対位置で表せなければなりません。



```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```

そのほかのユーザーマクロは異なるビルドターゲットのためのディレクトリを表すために使用されます。例えば、   `wolfCryptDllRelease64` は次のフォルダを表します:


```
$(wolfCryptDir)\x64\DLL Release
```

このパスはechoserverサンプルプログラムのデバッグ環境設定で64-bit DLLリリースビルド版の出力先を表現するのに次の様に使われます:

```
PATH=$(wolfCryptDllRelease64);%PATH%
```

echoserverプログラムをデバッガーを使って実行する際にはこの設定によってwolfSSL DLLがこのディレクトリから見つかります。


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

ここでご紹介した以外のTipsをお持ちでしたらぜひ info@wolfssl.comまで お知らせください。

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
