# Considerations

## Anticipated Requirements

The first step in tuning wolfSSL to your environment is to document your anticipated requirements.
At the highest level, design goals for SSL/TLS usually boil down to:

- **Memory Footprint (ROM)**
- **Per-session Memory Usage (RAM)**
- **SSL Handshake Performance**
- **Data Flow Performance (bulk data transfer)**
- **Desired Security Level (see Figure 1, below)**

## Desired Security Levels

| Security Level | Level Name          | Description                                             |
|----------------|---------------------|---------------------------------------------------------|
| 1              | Relaxed             | You just need to keep out the casual onlookers          |
| 2              | Moderate            | You have potential attackers out there, but they are not highly motivated |
| 3              | Corporate           | Secure against professional attacks                     |
| 4              | Military Grade      | Title speaks for itself                                 |
| 5              | Quantum Survivable  | Can survive against quantum computing based attacks     |

**Figure 1: Desired Security Levels**

Each of these top-level goals will have trade-offs against the others as you evolve your design.

To get started, the key variables you need to define include:

1. Available hardware:
    a. Memory available to SSL/TLS (ROM / RAM)
    b. CPU type and clock speed
2. Required SSL/TLS protocol levels (i.e: TLS 1.0, TLS 1.1, TLS 1.2, etc.)
3. Required cipher suites. If the cipher suites are not defined in your requirement, you are
free to choose cipher suites that match your performance goals:
    a. Public key algorithm with key length (RSA, ECC, NTRU, PSK, etc.)
    b. Block / Stream ciphers (AES, DES, 3DES, RC4, HC-128, etc.)
    c. Hash functions (SHA, SHA2, MD5, Blake2b, etc.)
4. What side of the connection are you on: client, server, or both?
5. Client authentication?
6. Is the other side of the SSL connection defined?
    a. What SSL implementation is it using?
    b. Which SSL/TLS protocol version?
    c. What is the key length?
    d. Is it a client or server?
7. What are the maximum number of active SSL/TLS connections/sessions needed at one time?
8. What are the SSL handshake performance requirements?
9. What are the bulk data transfer performance requirements, after SSL handshake has completed?
10. Is hardware crypto available? If yes, then what ciphers are available in hardware?
11. Editors Note: For the purpose of keeping this document usable in scope, we are excluding
operating system and TCP/IP stack tuning opportunities and reserving that for another document.

Having noted all of the above variables, you will see that there is much to consider, so our
approach is to present three optimization recipes for reference in this guide:

1. Optimizing for minimum footprint size (heap, stack, static data, code)
2. Optimizing for maximum speed
3. Optimizing for maximum security

Other optimization recipes are available. Just contact us at
[facts@wolfssl.com](mailto:facts@wolfssl.com).
Additional reference recipes that we can help with include:

1. Optimizing for large numbers of connections
2. Optimizing for particular operating systems/chipsets
3. Optimizing for particular applications
4. Optimizing for a combination of higher goals, for example maximum security with minimum footprint
5. Optimization for lower power consumption
6. Optimizing for fun and relaxation
