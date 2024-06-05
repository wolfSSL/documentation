# Recipes

## Recipe #1 Minimum Footprint

Many users are on deeply embedded systems, where memory resources are tight.
For those users, this section describes methods to reduce the footprint size of wolfSSL.

1. Limit supported protocol versions to only those required, for example only allowing TLS 1.2
connections.
2. Remove unnecessary library features at compile time - section
[2.4.1](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html) of the
wolfSSL Manual.
3. Choose a limited set of cipher suites:
    a. Memory usage difference between RSA, ECC, PSK.
    b. Choose smaller key sizes - section
    [4.3](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html) of the wolfSSL
    manual.
4. Take advantage of hardware crypto if available - section
[4.4](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html) of the wolfSSL manual.
5. Use compiler and toolchain optimizations.
6. Decrease maximum SSL record size if you control both ends of the connection.

## Recipe #2 Maximum Speed

Adding SSL/TLS to a connection will always result in an inevitable reduction of performance.
Our goal is to make that PERFORMANCE decrease as small as possible.
This section describes ways to speed up wolfSSL, both during and after the handshake.

There are two main areas of concern regarding performance:

1. SSL/TLS handshake speed.
2. Data flow rate (bulk data transfer, after the SSL handshake).

When optimizing SSL handshake performance, items to consider include:

1. Use a faster math library (big integer vs. fastmath).
2. Take advantage of hardware crypto if available - section
[4.4](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html) of the wolfSSL manual.
3. Key size - [Chapter 4](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html) of
the wolfSSL manual.
4. Key type (RSA vs ECC for example).
5. Trade off between handshake speed and security level (such as client/server cert verification
- section [4.8](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html)
- of the wolfSSL manual).
6. Consider using PSK (pre-shared keys) -
section [4.7](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-4-features.html) of the wolfSSL
manual.

**Maximum data flow rate** in a streaming media environment for example, such as a video game,
VoIP application, or cloud infrastructure, cipher suite choice is critical. In this recipe,
there are many options depending on the hardware environment and number of connections. To simplify
the recipe to make it usable, we will focus on a single connection environment running on a
typical cloud-based server.

When optimizing for maximum data flow rate, items to consider include:

1. Choose cipher suites to prioritize faster algorithms over slower ones: Stream Ciphers, Rabbit,
HC-128.
2. Take advantage of better compiler optimization. (I am not sure if this is a
user’s practical option).
3. Take advantage of hardware crypto if available.

## Recipe #3 Maximum Security

The security of a SSL/TLS connection should be of high concern, since having a secure
communication channel is the primary reason for adding SSL/TLS to a project.

As with all cryptography-based protocols, SSL/TLS security recommendations can change as new
attacks and vulnerabilities are discovered and released. Optimizing for maximum security can
have negative effects on both memory usage and performance, depending on configuration.

1.  Cipher suite choices based on the best currently available information.
2.  Key size choices based on the best currently available information.
3.  Other considerations…

As you can see from the basic recipes above, optimizing SSL is a complex multivariate problem
that depends heavily on a wide range of assumptions about your initial environment.  We are here
to help. The wolfSSL team has successfully guided a vast number of our customers through these
choices. We can support you in an entire spectrum of ways, from the simple question and answer
process of typical commercial support, to short term professional design consulting, up to
managing the entire implementation of your SSL project.
