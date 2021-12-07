# wolfTPM Library Design

## Library Headers

wolfTPM header files are located in the following locations:
**wolfTPM** :                     wolftpm/
**wolfSSL** :                        wolfssl/
**wolfCrypt** :                    wolfssl/wolfcrypt

The general header file that should be included from wolfTPM is shown below:
```c
#include <wolftpm/tpm2.h>
```

## Example Design

Every example application that is included with wolfTPM includes the tpm_io.h header file, located in wolfTPM/examples. The tpm_io.c file sets up the example HAL IO callback necessary for testing and running the example applications with a Linux Kernel, STM32 CubeMX HAL or Atmel/Microchip ASF. The reference is easily modified, such that custom IO callbacks or different callbacks may be added or removed as desired.
