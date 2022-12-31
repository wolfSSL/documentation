# Introduction

This guide provides a reference for developers and engineers porting the
wolfSSL lightweight SSL/TLS library to new embedded platforms, operating
systems, or transport mediums (TCP/IP, bluetooth, etc). It calls out
areas in the wolfSSL codebase which typically require modification when
porting wolfSSL. It should be considered a guide and as such, it is an
evolving work.  If there is something you find missing, please let us
know and we’ll be happy to add instructions or clarification to the
document.

## Audience

This guide caters to developers or engineers porting the wolfSSL and
wolfCrypt to new platforms or environments that are not supported by
default.

## Overview

Several steps need to be iterated through when getting wolfSSL to run on
an embedded platform.  Some of these steps are outlined in Section 2.4
of the wolfSSL Manual.

Apart from steps in Chapter 2 of the wolfSSL Manual, there are areas in
the code which may need porting or modifications in order to accommodate
a specific platform. wolfSSL abstracts many of these areas, attempting
to make it as easy as possible to port wolfSSL to a new platform.

In the ./wolfssl/wolfcrypt/settings.h file, there are several defines
specific to different operating systems, TCP/IP stacks, and chipsets
(ie: MBED, FREESCALE\_MQX, MICROCHIP\_PIC32, MICRIUM, EBSNET, etc).
There are two main locations to put \#defines when compiling and porting
wolfSSL to a new platform:

First, new defines for a Operating System or TCP/IP stack port are
typically added to the settings.h file when a new port of wolfSSL is
completed. This provides an easy way to turn on/off features as well as
customize build settings that should be default for that build. New
custom defines can be added in this file when doing a port of wolfSSL to
a new platform. We encourage users to contribute ports of wolfSSL back
to the master open source code branch on GitHub. This helps keep wolfSSL
up to date and allows different ports to remain updated as the wolfSSL
project improves and moves forward.

For users not wanting to contribute back their changes to wolfSSL
proper, or for users who want to customize the wolfSSL build with
additional preprocessor defines, wolfSSL recommends the use of a
custom "user\_settings.h" header file.  If WOLFSSL\_USER\_SETTINGS is
defined when compiling the wolfSSL source files, wolfSSL will
automatically include a custom header file called "user\_settings.h".
This header should be created by the user and placed on the include
path. This allows users to maintain one single file for their wolfSSL
build, and makes it much easier to update to newer versions of wolfSSL.

wolfSSL encourages the submission of patches and code changes through either
direct email (info@wolfssl.com), or through GitHub pull request.
