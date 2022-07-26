# Integrating wolfBoot in an existing project

## Required steps

   - See the [Targets](chapter03.md#targets) chapter for reference implementation examples.
   - Provide a HAL implementation for the target platform (see [Hardware Abstraction Layer](chapter04.md#hardware-abstraction-layer))
   - Decide a flash partition strategy and modify `include/target.h` accordingly (see [Flash partitions](chapter05.md#flash-partitions))
   - Change the entry point of the firmware image to account for bootloader presence
   - Equip the application with the [wolfBoot library](chapter06.md#application-interface-for-interactions-with-the-bootloader) to interact with the bootloader
   - [Configure and compile](chapter02.md#compiling-wolfboot) a bootable image with a single "make" command
   - For help signing firmware see [wolfBoot Signing](chapter06.md#signing)
   - For enabling measured boot see [wolfBoot measured boot](chapter06.md#measured-boot)

## Examples provided

Additional examples available on our GitHub wolfBoot-examples repository [here](https://github.com/wolfSSL/wolfBoot-examples).

The following steps are automated in the default `Makefile` target, using the baremetal test application as an example to create the factory image. By running `make`, the build system will:

   - Create a Ed25519 Key-pair using the `keygen` tool
   - Compile the bootloader. The public key generated in the step above is included in the build
   - Compile the firmware image from the test application in the `test_app' directory
   - Re-link the firmware to change the entry-point to the start address of the primary partition
   - Sign the firmware image using the `sign` tool
   - Create a factory image by concatenating the bootloader and the firmware image

The factory image can be flashed to the target device. It contains the bootloader and the signed initial firmware at the specified address on the flash.

The `sign.py` tool transforms a bootable firmware image to comply with the firmware image format required by the bootloader.

For detailed information about the firmware image format, see [Firmware image](chapter06.md#firmware-image)

For detailed information about the configuration options for the target system, see [Compiling wolfBoot](chapter02.md#compiling-wolfboot)

## Upgrading the firmware

   - Compile the new firmware image, and link it so that its entry point is at the start address of the primary partition
   - Sign the firmware using the `sign.py` tool and the private key generated for the factory image
   - Transfer the image using a secure connection, and store it to the secondary firmware slot
   - Trigger the image swap using libwolfboot `wolfBoot_update_trigger()` function. See [wolfBoot library API](chapter06.md#application-interface-for-interactions-with-the-bootloader) for a description of the operation
   - Reboot to let the bootloader begin the image swap
   - Confirm the success of the update using libwolfboot `wolfBoot_success()` function. See [wolfBoot library API](chapter06.md#application-interface-for-interactions-with-the-bootloader) for a description of the operation

For more detailed information about firmware update implementation, see [Firmware Update](chapter06.md#firmware-update)

