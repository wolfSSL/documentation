

## wolfSSL 統合の例

[the wolfSSL repository](https://github.com/wolfSSL/wolfssl) で、`WOLFSSL_WOLFSENTRY_HOOKS` でゲートされた `wolfsentry/test.h` のコードを参照してください。
`wolfsentry_store_endpoints()`、`wolfSentry_NetworkFilterCallback()`、`wolfsentry_setup()`、および`tcp_connect_with_wolfSentry()`。 次のコードも参照してください。 
`examples/server/server.c` と `examples/client/client.c` は `WOLFSSL_WOLFSENTRY_HOOKS` でゲートされています。 `configure --enable-wolfsentry` を使用してビルドします。 
wolfSentry 統合、および wolfSentry が非標準の場所にインストールされている場合は、`--with-wolfsentry=/the/install/path` を使用します。 wolfSSL テスト
クライアント/サーバーは、ユーザー提供の wolfSentry JSON 構成でロードできます。 
コマンドラインから、`--wolfsentry-config <file>` を使用して。

```sh
$ ./examples/server/server -b -i
wolfSentry got network filter callback: family=2 proto=6 rport=52666 lport=11111 raddr=127.0.0.1 laddr=127.0.0.1 interface=0; decision=1 (ACCEPT)
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
Client message: hello wolfssl!
```

```sh
$ ./examples/client/client 
wolfSentry callin from tcp_connect_with_wolfSentry: family=2 proto=6 rport=11111 lport=0 raddr=127.0.0.1 laddr=0.0.0.0 interface=0; decision=1 (ACCEPT)
wolfSentry got network filter callback: family=2 proto=6 rport=11111 lport=0 raddr=127.0.0.1 laddr=0.0.0.0 interface=0; decision=1 (ACCEPT)
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
I hear you fa shizzle!
```

## wolfSentryの例

例は wolfSentry rero、`<wolfSentry root>/examples` にあります。

### wolfSentry lwIP Echo テスト

これは非常に基本的なデモ アプリケーションであり、Docker 上の PCAP を介して lwIP スタックで wolfSentry を使用し、送信されたものをすべてエコーします。 wolfSentry は、テストで生成された 3 つの Docker ノードを使用してテストできるさまざまなタイプのトラフィックをフィルタリングします。

#### 前提条件

このテストは Linux または macOS で実行するように設計されていますが、Windows でも動作するはずです。 コンピューターに次のものがインストールされている必要があります。

* Docker - <https://docs.docker.com/get-docker/>
* docker-compose - <https://docs.docker.com/compose/install/>

#### 実行中の サーバー

次のコマンドは、テスト Echo サーバーを構築し、3 つのテスト ノードと共にこれを起動します。

```sh
sudo docker-compose -f docker-compose.yml up --build -d
```

以下を使用して、Echo サーバーのログを追跡できます。

```sh
sudo docker-compose -f docker-compose.yml log -f
```

テストの実行中は、ログを実行したままにしておくことをお勧めします。

#### テスト

##### ノードへのアクセス

操作する 3 つのユーザー テスト ノードがあります。 それらは `linux-lwip-tester?-1` という名前で、`?` は 1、2、または 3 です。例として tester2 にログインするには:

```sh
sudo docker exec -it linux-lwip-tester2-1 /bin/sh
```
##### Ping テスト

以下を使用して、任意のノードから ping を実行できます。

```sh
ping 127.20.20.5
```

テスター ノード 1 は動作し、テスター 2 は ICMP ping で拒否され、テスター 3 は MAC アドレスで拒否されます。 これはログ出力に反映されます。

##### Echo テスト

以下を使用して、任意のノードから接続できます。

```sh
nc -v 172.20.20.5 11111
```

テスト済みのノード 2 は動作し、netcat ターミナルに入力した内容はすべてサーバー ログに記録されます。 テスター 1 は TCP 接続で拒否され、テスター 3 は MAC アドレスで拒否されます。

#### ノードの詳細

##### エコーサーバー

* IP アドレス: 172.20.20.3 (ノード) 172.20.20.5 (エコー プロセス)
* MAC アドレス: `de:c0:de:01:02:03`

エコー テスト プロセスはこのノードから実行され、PCAP と lwIP を使用して、実際のテスト用に 127.20.20.5 の静的 IP を作成します。

##### テスター 1

※IPアドレス：172.20.20.10
* MAC アドレス: `de:c0:de:03:02:01`

セントリー テストは、このノードが echoserver ノードに ping を実行できるように構成されていますが、ハンドシェイク中に TCP 接続が受け入れられません。

linux-lwip-tester1-1 ログの例:
```sh
$ sudo docker exec -it linux-lwip-tester1-1 /bin/sh
/ # ping 172.20.20.5 -c 3
PING 172.20.20.5 (172.20.20.5): 56 data bytes
64 bytes from 172.20.20.5: seq=0 ttl=255 time=193.580 ms
64 bytes from 172.20.20.5: seq=1 ttl=255 time=25.759 ms
64 bytes from 172.20.20.5: seq=2 ttl=255 time=62.264 ms

--- 172.20.20.5 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 25.759/93.867/193.580 ms
/ # nc -v 172.20.20.5 11111
^Cpunt!

/ #

```

linux-lwip-echoserver-1 ログの例:
```sh
...
// Accept PING
linux-lwip-echoserver-1  | Ping accepted from 172.20.20.10
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:01
linux-lwip-echoserver-1  | PING Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Ping accepted from 172.20.20.10
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:01

....
// Reject TCP
linux-lwip-echoserver-1  | Sentry rejected connection from: 172.20.20.10
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:01
linux-lwip-echoserver-1  | Incomming connection from: 172.20.20.10
linux-lwip-echoserver-1  | TCP Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1064
linux-lwip-echoserver-1  | Sentry rejected connection from: 172.20.20.10

```

##### テスター 2

※IPアドレス：172.20.20.20
* MAC アドレス: `de:c0:de:03:02:02`

セントリー テストは、このノードがエコー サーバー ノードに ping を送信するのをブロックするように構成されていますが、TCP 接続はハンドシェイク中に受け入れられます。

linux-lwip-tester2-1 ログの例:

```sh
$ sudo docker exec -it linux-lwip-tester2-1 /bin/sh
/ # ping 172.20.20.3 -c 3
PING 172.20.20.3 (172.20.20.3): 56 データ バイト
172.20.20.3 からの 64 バイト: seq=0 ttl=64 time=0.230 ms
172.20.20.3 からの 64 バイト: seq=1 ttl=64 time=0.608 ms
172.20.20.3 からの 64 バイト: seq=2 ttl=64 time=0.323 ms

--- 172.20.20.3 ping 統計 ---
3 パケット送信、3 パケット受信、0% パケットロス
往復最小/平均/最大 = 0.230/0.387/0.608 ミリ秒
/ # ping 172.20.20.5 -c 3
PING 172.20.20.5 (172.20.20.5): 56 データ バイト
^C
--- 172.20.20.5 ping 統計 ---
3 パケット送信、0 パケット受信、100% パケットロス
/ # nc -v 172.20.20.5 11111
172.20.20.5 (172.20.20.5:11111) オープン
こんにちは
^C

/ #
```

linux-lwip-echoserver-1 ログの例:

```sh
// PING を拒否
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02
linux-lwip-echoserver-1 | PING Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | 172.20.20.20 からの ping が拒否されました
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02
...
// TCP を受け入れる
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02
linux-lwip-echoserver-1 | 着信接続: 172.20.20.20
linux-lwip-echoserver-1 | TCP Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02
linux-lwip-echoserver-1 | 接続元: 172.20.20.20 ポート: 36737
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02
linux-lwip-echoserver-1 | 得：こんにちは
linux-lwip-echoserver-1 |
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1107 を返しました
linux-lwip-echoserver-1 | Sentry が受け入れた MAC アドレス DE:C0:DE:03:02:02

```

##### テスター 3

※IPアドレス：172.20.20.30
* MAC アドレス: `de:c0:de:03:03:01`

セントリー テストは、この MAC アドレスからのトラフィックを拒否するように構成されています。

linux-lwip-tester3-1 ログの例:

```sh
$ sudo docker exec -it linux-lwip-tester3-1 /bin/sh
/ # ping 172.20.20.5 -c 3
PING 172.20.20.5 (172.20.20.5): 56 データ バイト
^C
--- 172.20.20.5 ping 統計 ---
3 パケット送信、0 パケット受信、100% パケットロス
/ # nc -v 172.20.20.5 11111
nc: 172.20.20.5 (172.20.20.5:11111): ホストに到達できません

```

linux-lwip-echoserver-1 ログの例:

```sh
// PING を拒否
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01

// TCP を拒否
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01
linux-lwip-echoserver-1 | MAC Sentry アクションがコード 0 (OK、操作は成功しました)、src 4 (routes.c)、行 1116 を返しました
linux-lwip-echoserver-1 | Sentry が拒否した MAC アドレス DE:C0:DE:03:03:01

```

#### シャットダウン

以下を実行して、ノードを停止してクリーンアップできます。これにより、仮想ネットワークも削除されます。

```sh
sudo docker-compose -f docker-compose.yml down
```

＃＃＃＃ ノート

* `lwip-include/arch` ディレクトリは、`contrib/ports/unix/port/include/arch` の lwIP ディレクトリのコピーです。


## wolfSentry STM32 LWIPの例

これは、このコードベースの Linux の例と非常によく似たデモ アプリケーションです。 TCP エコー、ICMP ping、および MAC アドレスでフィルタリングできます。 OSにはFreeRTOS、ネットワークスタックにはLWIPを備えたSTM32を使用しています。

この例は、STM32CubeMX および STM32CubeIDE で使用するように設計されています。

### STM32CubeMX のセットアップ

STM32CubeMX でプロジェクトを作成して FREERTOS と LWIP を有効にするには、ハードウェアに応じて「ETH」接続オプションを構成する必要もあります。 ICMP ping フィルタリングを行う場合は、[キー オプション] に移動し、[高度なパラメータを表示] を選択して、`LWIP_RAW` を有効にします。

**ノート：**
1. 特に LWIP で DHCP を実行している場合は、FREERTOS の「タスクとキュー」で「defaultTask」スタック サイズを増やすことをお勧めします。 8KB で問題なく動作するはずです。

2. CMSISv1 を使用し、STM32Cube のバージョンの LWIP ではマルチスレッド サポートを使用しないことをお勧めします。 これにより、安定性の問題が発生する可能性があります。

### ファイルのコピー

1. プロジェクトのベースに wolfsentry git checkout をコピー (または新しいクローンを作成) します。
2. この README の隣にある `Src` ディレクトリのファイルをプロジェクトの `Core/Src` ディレクトリにコピーします。
3. この README の隣にある `Inc` ディレクトリのファイルをプロジェクトの `Core/Inc` ディレクトリにコピーします。

### STM32CubeIDE のセットアップ

STM32CubeIDE で、[プロジェクト] -> [プロパティ] をクリックします。 ここから「C/C++ General」→「Paths and Symbols」へ。 [ソースの場所] タブをクリックし、[フォルダーの追加] をクリックします。 wolfSentry をビルド チェーンに追加する "wolfsentry" を選択できます。 追加したら、[フィルターの編集] をクリックし、[追加...] をクリックして、次を追加します。

```
**/unittests.c
**/examples
```

これは、単体テストがアプリケーションの一部としてビルドされないようにするためであり、`main()` で競合が発生します。

#### コードの変更

#### wolfsentry_options.h

「wolfsentry/wolfsentry」で、「wolfsentry_options.h」ファイルを作成します。

`
```c
#ifndef WOLFSENTRY_OPTIONS_H
#define WOLFSENTRY_OPTIONS_H

#define FREERTOS
//#define WOLFSENTRY_SINGLETHREADED
#define WOLFSENTRY_LWIP
#define WOLFSENTRY_NO_PROTOCOL_NAMES
#define WOLFSENTRY_NO_POSIX_MEMALIGN
#endif /* WOLFSENTRY_OPTIONS_H */
```

シングル スレッドを使用している場合は、`WOLFSENTRY_SINGLETHREADED` のコメントを外します。これにより、セマフォが不要になります。

#### main.c

`main()` で、必要に応じて以下を追加し、コメント ブロックを使用してコードを配置する場所を見つけます。

ファイルの上部付近:

```c
/* USER CODE BEGIN インクルード */

#include "echo.h"
#include "ping.h"
```

`StartDefaultTask()` で:

```c
  /* USER CODE BEGIN 5 */
  printf("Sentry init\n");
  sentry_init();
  printf("Echo init\n");
  echo_init();
  printf("Ping init\n");
  ping_init();
```

#### 歩哨.c

セントリー構成はファイルの先頭にあります。 ping、TCP、および MAC アドレスの構成を確認できます。 必要に応じて、これらのアドレス/プレフィックス範囲を編集します。

#### ethernetif.c

このファイルへの変更は、MAC アドレス フィルタリングのために必要です。 MAC アドレス フィルタリングを行いたくない場合は、これらの変更を行う必要はありません。

このファイルは「LWIP/Target」にあります。 コードの上部近くに次を追加します。

```c
/* ユーザーコード BEGIN 0 */
#include "sentry.h"
/* MAC アドレス フィルタリングに使用される raw 入力パケット コールバック */
static err_t filter_input(struct pbuf *p, struct netif *inp)
{
     /* ペイロードの先頭にはイーサネット ヘッダーが含まれます */
     struct eth_hdr *ethhdr = (struct eth_hdr *)p->ペイロード;
     struct eth_addr *ethaddr = &ethhdr->src;

     /* 「src」には、パケットからの送信元ハードウェア アドレスが含まれます */
     if (sentry_action_mac(&ethhdr->src) != 0)
     {
         /* printf("Sentry は MAC アドレス %02X:%02X:%02X:%02X:%02X:%02X を拒否しました\n",
                 ethaddr->addr[0]、ethaddr->addr[1]、ethaddr->addr[2]、
                 ethaddr->addr[3]、ethaddr->addr[4]、ethaddr->addr[5]); */

         /* 基本的にパケットをドロップします */
         ERR_ABRT を返します。
     }

     printf("Sentry は MAC アドレス %02X:%02X:%02X:%02X:%02X:%02X を受け入れました\n",
         ethaddr->addr[0]、ethaddr->addr[1]、ethaddr->addr[2]、
         ethaddr->addr[3]、ethaddr->addr[4]、ethaddr->addr[5]);

     /* MAC フィルタを通過したので、パケットを通常の内部に渡します
      * lwIP 入力コールバック */
     return netif_input(p, inp);
}
```

関数 `ethernetif_init()` を見つけて、`#if LWIP_ARP` の下に以下を追加します。

```c
     netif->input = filter_input;
```

STM32CubeMX を使用してコードを再生成すると、上記の最後の編集が消去されることに注意してください。

最後に、同じディレクトリにある `lwipopts.h` を開き、`USER CODE BEGIN 0` セクション内に次を追加します。

```c
#include "echo.h"
#define LWIP_HOOK_TCP_INPACKET_PCB sentry_tcp_inpkt
```


#### アプリケーションの使用

実行すると、ポート 11111 で TCP 接続できるようになり、そこに送信されたものはすべて `printf()` を介してエコーされます (ブロックされていない場合)。 フィルタリングは ping にも適用され、着信パケットは MAC アドレスに基づいてフィルタリングされます。

## wolfSentry STM32 LWIP wolfSSL の例

これは、非常に基本的な HTTPS サーバーを起動するデモ アプリケーションです。 特定の IP からポート 8080 で HTTPS 接続を受け入れるように設計されています。 他の IP からの接続はブロックされます。 wolfSSL 側では、データの送受信にネイティブ LWIP コードが使用されます。

この例は、STM32CubeIDE で使用するように設計されています。

### STM32CubeMX のセットアップ

STM32CubeMX でプロジェクトを作成して FREERTOS と LWIP を有効にするには、ハードウェアに応じて「ETH」接続オプションを構成する必要もあります。

**ノート：**
1. 特に LWIP で DHCP を実行している場合は、FREERTOS の「タスクとキュー」で「defaultTask」スタック サイズを増やすことをお勧めします。 8KB で問題なく動作するはずです。

2. CMSISv1 を使用し、STM32Cube のバージョンの LWIP ではマルチスレッド サポートを使用しないことをお勧めします。 別の構成では、安定性の問題が発生する可能性があります。

### ファイルのコピー

1. プロジェクトのベースに wolfsentry git checkout をコピー (または新しいクローンを作成) します。
2. この README の隣にある `Src` ディレクトリのファイルをプロジェクトの `Core/Src` ディレクトリにコピーします。
3. この README の隣にある `Inc` ディレクトリのファイルをプロジェクトの `Core/Inc` ディレクトリにコピーします。

### STM32CubeIDE のセットアップ

STM32CubeIDE で、[プロジェクト] -> [プロパティ] をクリックします。 ここから「C/C++ General」→「Paths and Symbols」へ。 [ソースの場所] タブをクリックし、[フォルダーの追加] をクリックします。 wolfSentry をビルド チェーンに追加する "wolfsentry" を選択できます。 追加したら、[フィルターの編集] をクリックし、[追加...] をクリックして、次を追加します。

```
**/unittests.c
**/examples
```

これは、単体テストがアプリケーションの一部としてビルドされないようにするためであり、`main()` で競合が発生します。

### コードの変更

#### wolfsentry_options.h

「wolfsentry/wolfsentry」で、「wolfsentry_options.h」ファイルを作成します。

```c
#ifndef WOLFSENTRY_OPTIONS_H
#define WOLFSENTRY_OPTIONS_H

#FREERTOS の定義
#定義 WOLFSENTRY_SINGLETHREADED
#WOLFSENTRY_LWIP を定義
#define WOLFSENTRY_NO_PROTOCOL_NAMES
#define WOLFSENTRY_NO_POSIX_MEMALIGN
#endif /* WOLFSENTRY_OPTIONS_H */
```

#### main.c

`main()` で、必要に応じて以下を追加し、コメント ブロックを使用してコードを配置する場所を見つけます。

ファイルの上部付近:

```c
/* USER CODE BEGIN インクルード */

#include "echo.h"
#include "sentry.h"
```

`StartDefaultTask()` で:

```c
/* USER CODE BEGIN Includes */

#include "echo.h"
#include "sentry.h"
```

In `StartDefaultTask()`:

```c
  /* USER CODE BEGIN 5 */
  printf("Start!\r\n");
  printf("Sentry init\n");
  sentry_init();
  printf("Echo init\n");
  echo_ssl();

  connQueue = xQueueCreate( 10, sizeof( struct thread_data* ) );
  echo_init();

  /* Infinite loop */
  for(;;)
  {
		BaseType_t qRet = pdFALSE;
		struct thread_data tdata;
		while (qRet != pdTRUE) {
		  qRet = xQueueReceive( connQueue, &( tdata ), ( TickType_t ) 10 );
		}
		char buff[256];
		int ret;
		int retry = 10;
		struct tcp_pcb *pcb = tdata.pcb;
		WOLFSSL *ssl = tdata.ssl;

		fprintf(stderr, "Queue item running\r\n");
		do {
			if (pcb->state == CLOSE_WAIT) {
				fprintf(stderr, "Client immediately hung-up\n");
				goto close_wait;
			}
			ret = wolfSSL_accept(ssl);
			if ((wolfSSL_want_read(ssl) || wolfSSL_want_write(ssl))) {
				osDelay(500);
				retry--;
			} else {
				retry = 0;
			}
		} while (retry);
		if (ret != WOLFSSL_SUCCESS) {
			fprintf(stderr, "wolfSSL_accept ret = %d, error = %d\n",
				ret, wolfSSL_get_error(ssl, ret));
			goto ssl_shutdown;
		} else {
			fprintf(stderr, "Handshake done!\n");
		}

		memset(buff, 0, sizeof(buff));
		if (ret == WOLFSSL_SUCCESS) {
			retry = 10;
			do {
				ret = wolfSSL_read(ssl, buff, sizeof(buff));
				if ((wolfSSL_want_read(ssl) || wolfSSL_want_write(ssl))) {
					osDelay(500);
					retry--;
				} else {
					retry = 0;
				}
			} while (retry);
			if (ret == -1) {
				fprintf(stderr, "ERROR: failed to read\n");
				goto ssl_shutdown;
			}
			else
			{
				fprintf(stderr, "Sending response\n");
				if ((ret = wolfSSL_write(ssl, response, strlen(response))) != strlen(response)) {
					fprintf(stderr, "ERROR: failed to write\n");
				}
			}
		}

ssl_shutdown:
		retry = 10;
		do {
			ret = wolfSSL_shutdown(ssl);
			if (ret == SSL_SHUTDOWN_NOT_DONE) {
				osDelay(500);
				retry--;
			} else {
				break;
			}
		} while (retry);

close_wait:
		fprintf(stderr, "Connection closed\n");
		wolfSSL_free(ssl);
  }
  /* USER CODE END 5 */
```

#### sentry.c

セントリー構成はファイルの先頭にあります。 必要に応じてアドレス/プレフィックス範囲を編集します。

#### ethernetif.c

このファイルへの変更は、MAC アドレス フィルタリングのために必要です。 MAC アドレス フィルタリングを行いたくない場合は、これらの変更を行う必要はありません。

このファイルは「LWIP/Target」にあります。 コードの上部近くに次を追加します。

```c
/* USER CODE BEGIN 0 */
#include "sentry.h"
/* Raw input packet callback used for MAC address filtering */
static err_t filter_input(struct pbuf *p, struct netif *inp)
{
    /* Start of payload will have an Ethernet header */
    struct eth_hdr *ethhdr = (struct eth_hdr *)p->payload;
    struct eth_addr *ethaddr = &ethhdr->src;

    /* "src" contains the source hardware address from the packet */
    if (sentry_action_mac(&ethhdr->src) != 0)
    {
        /* printf("Sentry rejected MAC address %02X:%02X:%02X:%02X:%02X:%02X\n",
                ethaddr->addr[0], ethaddr->addr[1], ethaddr->addr[2],
                ethaddr->addr[3], ethaddr->addr[4], ethaddr->addr[5]); */

        /* Basically drop the packet */
        return ERR_ABRT;
    }

    printf("Sentry accepted MAC address %02X:%02X:%02X:%02X:%02X:%02X\n",
        ethaddr->addr[0], ethaddr->addr[1], ethaddr->addr[2],
        ethaddr->addr[3], ethaddr->addr[4], ethaddr->addr[5]);

    /* We passed the MAC filter, so pass the packet to the regular internal
     * lwIP input callback */
    return netif_input(p, inp);
}
```

関数 `ethernetif_init()` を見つけて、`#if LWIP_ARP` の下に以下を追加します。

```c
     netif->input = filter_input;
```

STM32CubeMX を使用してコードを再生成すると、上記の最後の編集が消去されることに注意してください。

最後に、同じディレクトリにある `lwipopts.h` を開き、`USER CODE BEGIN 0` セクション内に次を追加します。

```c
#include "echo.h"
#define LWIP_HOOK_TCP_INPACKET_PCB sentry_tcp_inpkt
```

#### アプリケーションの使用

実行すると、HTTP クライアントを使用してポート 8080 で TCP 接続できるようになります。 ブロックされている場合はタイムアウトになり、UART に詳細が表示されます。 それ以外の場合、SSL ハンドシェイクが発生し、HTTP 応答が提供されます。
