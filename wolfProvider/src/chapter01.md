# Introduction

The wolfCrypt Provider (wolfProvider) is an OpenSSL provider for the wolfCrypt and wolfCrypt FIPS cryptography libraries. wolfProvider provides an OpenSSL provider implementation, as a shared or static library, to allow applications currently using OpenSSL to leverage wolfCrypt cryptography for FIPS and non-FIPS use cases.

wolfProvider is structured as a separate standalone library which links against wolfSSL (libwolfssl) and OpenSSL. wolfProvider implements and exposes an **OpenSSL provider implementation** which wraps the wolfCrypt native API internally. A high-level diagram of wolfProvider and how it relates to applications and OpenSSL is displayed below in Figure 1.

For more details on the design and architecture of wolfProvider see the [wolfProvider Design](chapter09.md) chapter.


![wolfProvider Overview](wolfProvider_overview.png)

wolfProvider is compiled by default as a shared library called **libwolfprov** which can be dynamically registered at runtime by an application or OpenSSL through a config file. wolfProvider also provides an entry point for applications to load the provider when compiled in a static build.
