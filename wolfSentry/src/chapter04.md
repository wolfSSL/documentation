# Examples

## wolfSSL Integration Example

In [the wolfSSL repository](https://github.com/wolfSSL/wolfssl), see code in `wolfsentry/test.h` gated on `WOLFSSL_WOLFSENTRY_HOOKS`, including
`wolfsentry_store_endpoints()`, `wolfSentry_NetworkFilterCallback()`, `wolfsentry_setup()`, and `tcp_connect_with_wolfSentry()`.  See also code in
`examples/server/server.c` and `examples/client/client.c` gated on  `WOLFSSL_WOLFSENTRY_HOOKS`.  Use `configure --enable-wolfsentry` to build with
wolfSentry integration, and use `--with-wolfsentry=/the/install/path` if wolfSentry is installed in a nonstandard location.  The wolfSSL test
client/server can be loaded with user-supplied wolfSentry JSON configurations
from the command line, using `--wolfsentry-config <file>`.

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

## wolfSentry Examples

Examples are loacated in wolfSentry rero, `<wolfSentry root>/examples`

### wolfSentry lwIP Echo Test

This is an extremely basic demo application that uses wolfSentry with the lwIP stack via PCAP on Docker to echo anything sent to it. wolfSentry will filter various types of traffic which can be tested using three Docker nodes the test generates.

#### Prerequisites

This test is designed to be run on Linux or macOS, but should work on Windows as well. You need the following installed on your computer:

* Docker - <https://docs.docker.com/get-docker/>
* docker-compose - <https://docs.docker.com/compose/install/>

#### Running echo server

The following command will build the test echo server and start this up along with three testing nodes:

```sh
sudo docker-compose -f docker-compose.yml up --build -d
```

You can follow the logs for the echo server using:

```sh
sudo docker-compose -f docker-compose.yml logs -f
```

It is recommended that you keep the logs following running whilst running the tests.

#### Testing

##### Accessing nodes

There are three user test nodes to play with. They are named `linux-lwip-tester?-1` where `?` is 1, 2 or 3. To log into tester2 as an example:

```sh
sudo docker exec -it linux-lwip-tester2-1 /bin/sh
```
##### Ping test

You can ping from any of the nodes using:

```sh
ping 127.20.20.5
```

Tester node 1 will work, tester 2 will be rejected for ICMP ping and tester 3 will be rejected for MAC address. This will be reflected in the logging output.

##### Echo test

You can connect from any of the nodes using:

```sh
nc -v 172.20.20.5 11111
```

Tested node 2 will work and whatever you enter into the netcat terminal will be logged in the server log. Tester 1 will be rejected for the TCP connection and tester 3 will be rejected for MAC address.

#### Node details

##### Echoserver

* IP address: 172.20.20.3 (node) 172.20.20.5 (echo process)
* MAC address: `de:c0:de:01:02:03`

The echo test process runs from this node, it uses PCAP and lwIP to create a static IP of 127.20.20.5 for the actually test.

##### Tester 1

* IP address: 172.20.20.10
* MAC address: `de:c0:de:03:02:01`

The sentry test is configured to allow this node to ping the echoserver node, but the TCP connection is not accepted during handshake.

Example of linux-lwip-tester1-1 log:
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

Example of linux-lwip-echoserver-1 log:
```sh
....
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

##### Tester 2

* IP address: 172.20.20.20
* MAC address: `de:c0:de:03:02:02`

The sentry test is configured to block this node pinging the echoserver node, but the TCP connection is accepted during handshake.

Example of linux-lwip-tester2-1 log:

```sh
$ sudo docker exec -it linux-lwip-tester2-1 /bin/sh
/ # ping 172.20.20.3 -c 3
PING 172.20.20.3 (172.20.20.3): 56 data bytes
64 bytes from 172.20.20.3: seq=0 ttl=64 time=0.230 ms
64 bytes from 172.20.20.3: seq=1 ttl=64 time=0.608 ms
64 bytes from 172.20.20.3: seq=2 ttl=64 time=0.323 ms

--- 172.20.20.3 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.230/0.387/0.608 ms
/ # ping 172.20.20.5 -c 3
PING 172.20.20.5 (172.20.20.5): 56 data bytes
^C
--- 172.20.20.5 ping statistics ---
3 packets transmitted, 0 packets received, 100% packet loss
/ # nc -v 172.20.20.5 11111
172.20.20.5 (172.20.20.5:11111) open
hello
^C

/ #
```

Example of linux-lwip-echoserver-1 log:

```sh
// Reject PING
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02
linux-lwip-echoserver-1  | PING Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Ping rejected from 172.20.20.20
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02
...
// Accept TCP
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02
linux-lwip-echoserver-1  | Incomming connection from: 172.20.20.20
linux-lwip-echoserver-1  | TCP Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02
linux-lwip-echoserver-1  | Connect from: 172.20.20.20 port: 36737
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02
linux-lwip-echoserver-1  | Got: hello
linux-lwip-echoserver-1  | 
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1107
linux-lwip-echoserver-1  | Sentry accepted MAC address DE:C0:DE:03:02:02

```

##### Tester 3

* IP address: 172.20.20.30
* MAC address: `de:c0:de:03:03:01`

The sentry test is configured to deny traffic from this MAC address.

Example of linux-lwip-tester3-1 log:

```sh
$ sudo docker exec -it linux-lwip-tester3-1 /bin/sh
/ # ping 172.20.20.5 -c 3
PING 172.20.20.5 (172.20.20.5): 56 data bytes
^C
--- 172.20.20.5 ping statistics ---
3 packets transmitted, 0 packets received, 100% packet loss
/ # nc -v 172.20.20.5 11111
nc: 172.20.20.5 (172.20.20.5:11111): Host is unreachable

```

Example of linux-lwip-echoserver-1 log:

```sh
// Reject PING
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01

// Rject TCP
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01
linux-lwip-echoserver-1  | MAC Sentry action returned code 0 (OK, operation succeeded), src 4 (routes.c), line 1116
linux-lwip-echoserver-1  | Sentry rejected MAC address DE:C0:DE:03:03:01

```

#### Shutting down

You can stop and clean up the nodes by running the following, this will also remove the virtual network:

```sh
sudo docker-compose -f docker-compose.yml down
```

#### Notes

* The `lwip-include/arch` directory is a copy of the lwIP directory from `contrib/ports/unix/port/include/arch`.


## wolfSentry STM32 LWIP Example

The is a demo application which is very similar to the Linux example in this codebase. It allows filtering on TCP echo, ICMP ping and MAC address. It uses STM32 with FreeRTOS for the OS and LWIP for the network stack.

This example is designed to be used with STM32CubeMX and STM32CubeIDE.

### STM32CubeMX Setup

When creating a project in STM32CubeMX enable FREERTOS and LWIP, you will also need to configure the `ETH` Connectivity option as appropriate for your hardware. If you wish to do ICMP ping filtering, go into the "Key Options", select "Show Advanced Parameters" and enable `LWIP_RAW`.

**NOTES:**
1. It is recommended that in FREERTOS "Tasks and Queues" you increase the `defaultTask` stack size, especially if you are doing DHCP in LWIP. 8KB should work fine.

2. It is recommended you use CMSISv1 and do not use multi-threaded support with STM32Cube's version of LWIP. This can have stability issues.

### Copying Files

1. Copy the wolfsentry git checkout (or make a new clone) at the base of the project.
2. Copy the files in the `Src` directory next to this README to the `Core/Src` directory of the project.
3. Copy the files in the `Inc` directory next to this README to the `Core/Inc` directory of the project.

### STM32CubeIDE Setup

In STM32CubeIDE click on "Project" -> "Properties". From here go to "C/C++ General" -> "Paths and Symbols". Now click on the "Source Location" tab and click on "Add Folder". There will be "wolfsentry" available to select which will add wolfSentry to the build chain. Once added click on "Edit Filter", click on "Add..." and add the following:

```
**/unittests.c
**/examples
```

This is so that the unittests do not build as part of your application, causing a conflict for `main()`.

#### Code Changes

#### wolfsentry_options.h

In `wolfsentry/wolfsentry` create the file `wolfsentry_options.h`:

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

Uncomment the `WOLFSENTRY_SINGLETHREADED` if you are using single threaded as this will remove the need for semaphores.

#### main.c

In `main()` add the following as needed, use the comment blocks to locate where to place the code.

Near the top of the file:

```c
/* USER CODE BEGIN Includes */

#include "echo.h"
#include "ping.h"
```

In `StartDefaultTask()`:

```c
  /* USER CODE BEGIN 5 */
  printf("Sentry init\n");
  sentry_init();
  printf("Echo init\n");
  echo_init();
  printf("Ping init\n");
  ping_init();
```

#### sentry.c

The sentry configuration is at the top of the file. You can see configurations for ping, TCP and MAC address. Edit these addresses / prefix ranges as needed.

#### ethernetif.c

Changes to this file are needed for MAC address filtering. You do not need to do these changes if you do not wish to do MAC address filtering.

This file can be found in `LWIP/Target`. Near the top of the code add:

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

Find the function `ethernetif_init()` and below `#if LWIP_ARP` add:

```c
    netif->input = filter_input;
```

Note that the last edit above will be erased if you regenerate the code using STM32CubeMX.

Finally open `lwipopts.h` in the same directory and add the following inside the `USER CODE BEGIN 0` section:

```c
#include "echo.h"
#define LWIP_HOOK_TCP_INPACKET_PCB sentry_tcp_inpkt
```

#### Using the Application

Once running you should be able to TCP connect on port 11111 and anything sent to that will be echoed via `printf()` (if it is not blocked). The filtering will also apply to pings and incoming packets will be filtered based on MAC address.


## wolfSentry STM32 LWIP wolfSSL Example

This is a demo application that starts a very basic HTTPS server. It is designed to accept HTTPS connections on port 8080 from a specific IP. Connections from other IPs will be blocked. On the wolfSSL side the native LWIP code is used to send/receive data.

This example is designed to be used with STM32CubeIDE.

### STM32CubeMX Setup

When creating a project in STM32CubeMX enable FREERTOS and LWIP, you will also need to configure the `ETH` Connectivity option as appropriate for your hardware.

**NOTES:**
1. It is recommended that in FREERTOS "Tasks and Queues" you increase the `defaultTask` stack size, especially if you are doing DHCP in LWIP. 8KB should work fine.

2. It is recommended you use CMSISv1 and do not use multi-threaded support with STM32Cube's version of LWIP. Alternative configurations can have stability issues.

### Copying Files

1. Copy the wolfsentry git checkout (or make a new clone) at the base of the project.
2. Copy the files in the `Src` directory next to this README to the `Core/Src` directory of the project.
3. Copy the files in the `Inc` directory next to this README to the `Core/Inc` directory of the project.

### STM32CubeIDE Setup

In STM32CubeIDE click on "Project" -> "Properties". From here go to "C/C++ General" -> "Paths and Symbols". Now click on the "Source Location" tab and click on "Add Folder". There will be "wolfsentry" available to select which will add wolfSentry to the build chain. Once added click on "Edit Filter", click on "Add..." and add the following:

```
**/unittests.c
**/examples
```

This is so that the unittests do not build as part of your application, causing a conflict for `main()`.

### Code Changes

#### wolfsentry_options.h

In `wolfsentry/wolfsentry` create the file `wolfsentry_options.h`:

```c
#ifndef WOLFSENTRY_OPTIONS_H
#define WOLFSENTRY_OPTIONS_H

#define FREERTOS
#define WOLFSENTRY_SINGLETHREADED
#define WOLFSENTRY_LWIP
#define WOLFSENTRY_NO_PROTOCOL_NAMES
#define WOLFSENTRY_NO_POSIX_MEMALIGN
#endif /* WOLFSENTRY_OPTIONS_H */
```

#### main.c

In `main()` add the following as needed, use the comment blocks to locate where to place the code.

Near the top of the file:

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

The sentry configuration is at the top of the file. Edit the addresses / prefix ranges as needed.

#### ethernetif.c

Changes to this file are needed for MAC address filtering. You do not need to do these changes if you do not wish to do MAC address filtering.

This file can be found in `LWIP/Target`. Near the top of the code add:

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

Find the function `ethernetif_init()` and below `#if LWIP_ARP` add:

```c
    netif->input = filter_input;
```

Note that the last edit above will be erased if you regenerate the code using STM32CubeMX.

Finally open `lwipopts.h` in the same directory and add the following inside the `USER CODE BEGIN 0` section:

```c
#include "echo.h"
#define LWIP_HOOK_TCP_INPACKET_PCB sentry_tcp_inpkt
```

#### Using the Application

Once running you should be able to TCP connect on port 8080 using an HTTP client. If it is blocked then you will get a timeout and the UART will show details. Otherwise an SSL handshake will happen and an HTTP response will be provided.
