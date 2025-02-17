# Building U-Boot and wolfBoot for Xilinx UltraScale+ MPSoC

## Table of Contents
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Build Instructions](#detailed-build-instructions)
  - [Building wolfBoot](#wolfboot-building)
  - [Building PetaLinux](#building-petalinux)
  - [Building U-Boot](#building-u-boot)
- [Flashing Instructions](#flashing-instructions)
- [Running the System](#running)
- [Troubleshooting](#troubleshooting)
- [Advanced Topics](#advanced-topics)

## Prerequisites

### Hardware Requirements
- Xilinx UltraScale+ MPSoC Development Board
  - Supported models: ZCU102 or MCNAV (ZCU109)
- SD Card (optional, for SD boot mode)
- JTAG programmer (optional, for JTAG programming)

### Software Requirements
- PetaLinux 2021.2
- Xilinx Vitis 2021.2
- Docker (for PetaLinux build environment)
- Cross-compilation toolchain (aarch64-linux-gnu-)

### Required Files
- `petalinux-v2021.2-final-installer.run`
- `system.xsa` (hardware description file)
- Xilinx U-Boot source (xilinx-v2021.2.tar.gz)

## Quick Start

For experienced users, here are the basic steps to get up and running:

1. Configure wolfBoot:
```bash
cp config/examples/zynqmp.config .config
# Edit .config with required settings (see Configuration section)
make clean && make
```

2. Sign the image:
```bash
./tools/keytools/sign --rsa4096 --sha3 ../lynx-test-arm.srp ./wolfboot_signing_private_key.der 1
```

3. Create BOOT.BIN:
```bash
bootgen -image bootgen.bif -arch zynqmp -o BOOT.BIN -w
```

4. Flash the image:
   - QSPI: Use Vitis -> Program Flash
   - SD: Copy BOOT.BIN to SD card

## Detailed Build Instructions

### wolfBoot Building

1. Create and customize `.config`:
```bash
# Create initial config
cp config/examples/zynqmp.config .config

# Required .config settings
OPTIMIZATION_LEVEL=2
ELF?=0
WOLFBOOT_PARTITION_SIZE=0xA000000
WOLFBOOT_PARTITION_UPDATE_ADDRESS?=0xA800000
WOLFBOOT_PARTITION_SWAP_ADDRESS?=0xFFE0000
WOLFBOOT_LOAD_DTS_ADDRESS?=0x0FFF2000

# QSPI Configuration
# For MCNAV: 300MHz reference clock
CFLAGS_EXTRA+=-DGQSPI_CLK_REF=300000000
# For ZCU102: 125MHz reference clock
#CFLAGS_EXTRA+=-DGQSPI_CLK_REF=125000000

# QSPI Bus Divisor (2 << div):
# 0=div2, 1=div4, 2=div8
CFLAGS_EXTRA+=-DGQSPI_CLK_DIV=1

# Performance optimization
CFLAGS_EXTRA+=-DWOLFBOOT_SHA_BLOCK_SIZE=131072

# Hardware acceleration settings
NO_ARM_ASM?=1
PKA?=1
```

2. Build wolfBoot:
```bash
make clean && make
```

Validation: Check that `wolfboot.elf` is created in the build directory.

### Building PetaLinux

1. Setup Docker Environment:
```bash
# Clone docker environment
git clone https://github.com/carlesfernandez/docker-petalinux2.git
cd docker-petalinux2

# Copy installer
cp /path/to/petalinux-v2021.2-final-installer.run installers/

# Build docker image
./docker_build.sh

# Start docker environment
./etc/petalin2.sh
```

2. Create and Configure Project:
```bash
# Create project
petalinux-create -t project -n pim --template zynqMP

# Copy hardware description
cp /path/to/system.xsa pim/hw/

# Configure project
cd pim
petalinux-config --get-hw-description=hw/
```

3. Configure Build Settings:
   - Linux Components Selection -> u-boot -> ext-local-src
   - PMU Configuration: Add compiler flags
     ```
     -DSECURE_ACCESS_VAL=1
     -DENABLE_EFUSE_ACCESS=1
     -DXSK_ACCESS_SECURE_CRITICAL_EFUSE
     -DXSK_ACCESS_PUF_USER_EFUSE
     -DXSK_ACCESS_USER_EFUSE
     ```

4. Configure Memory Partitions:
   
   Subsystem AUTO Hardware Settings -> Flash Settings:
   | Partition | Size      | Offset    |
   |-----------|-----------|-----------|
   | boot      | 0x1E00000 | 0x0       |
   | bootenv   | 0x40000   | 0x1E00000 |
   | kernel    | 0x2040000 | 0x1E40000 |
   | bootscr   | 0x180000  | 0x3E80000 |
   | rootfs    | 0x4000000 | 0x4000000 |
   | FIT       | 0x6400000 | 0x8000000 |

5. Build System:
```bash
petalinux-build
```

Validation: Check for output files in `pim/images/linux/`

### Building U-Boot (Standalone)

```bash
wget https://github.com/Xilinx/u-boot-xlnx/archive/refs/tags/xilinx-v2021.2.tar.gz
tar -xzf xilinx-v2021.2.tar.gz
cd u-boot-xlnx-xilinx-v2021.2

# Set environment
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=aarch64

# Build
make distclean
make xilinx_zynqmp_virt_defconfig
make
```

Validation: Check for `u-boot.elf` in build directory

## Flashing Instructions

### Boot Mode Selection

Set boot mode using jumpers (SW6[4:1]):

| Boot Mode | MODE[3:0] | SW6[4:1]    |
|-----------|-----------|-------------|
| JTAG      | 0000      | on,on,on,on |
| QSPI32    | 0010      | on,on,off,on|
| SD        | 1110      | off,off,off,on|

### QSPI Flashing Methods

#### Method 1: Using Vitis
1. Open Xilinx -> Program Flash
2. Configure settings:
   ```
   Flash type: qspi-x8-dual_parallel
   Offset: 0
   FSBL: zynqmp_fsbl.elf
   ```
3. Click Program

#### Method 2: Using U-Boot
```bash
# Load BOOT.BIN from SD to RAM
fatload mmc 0 0x10000000 BOOT_wolf.BIN

# Initialize QSPI
sf probe

# Flash image (adjust size as needed)
sf update 0x10000000 0 0xA275684
```

#### Method 3: Using Lauterbach
Use the provided `.cmm` script (see Advanced Topics)

### SD Card Flashing
1. Format SD card as FAT32
2. Copy BOOT.BIN to SD card root
3. Insert card and set boot mode jumpers

## Running the System

1. Power on the board
2. Check UART output for boot messages
3. Verify successful boot:
```
wolfBoot Secure Boot
QSPI Init: Ref=300MHz, Div=4, Bus=75000000, IO=DMA
...
Successfully selected image in part: 0
Firmware Valid
```

## Troubleshooting

### Common Issues

1. QSPI Flash Fails
   - Verify jumper settings match boot mode table
   - Check flash partition table alignment
   - Ensure correct flash clock settings for your board
   - Verify QSPI initialization messages

2. Boot Fails
   - Verify image signing was successful
   - Check partition offsets in bootgen.bif
   - Validate hardware configuration
   - Check UART output for error messages

3. Build Errors
   - Verify toolchain is properly set up
   - Check PetaLinux version compatibility
   - Ensure all prerequisites are installed
   - Check log files in build directories

### Validation Commands

1. Verify QSPI Contents:
```bash
# Read partition (adjust offset/size as needed)
sf read 0x10000000 0x800000 0x400

# Verify SHA3 hash
zynqmp sha3 0x10000000 0x9A75281
```

2. Check System Info:
```bash
# In U-Boot
bdinfo
```

## Advanced Topics

### Debugging

1. Enable FSBL Debug Output:
   Add compiler option `-DFSBL_DEBUG_DETAILED_VAL`
   ```bash
   petalinux-build -c bootloader -x cleanall
   petalinux-build -c bootloader
   ```

2. Vitis Debug Attachment:
   ```bash
   # Load symbol files
   memmap -file path/to/u-boot.elf
   memmap -file path/to/wolfboot.elf
   memmap -file path/to/fsbl_a53.elf
   ```

### FIT Image Handling

1. Extract components:
```bash
dumpimage -T flat_dt -p 0 zcu102.srp -o lsk.bin
dumpimage -T flat_dt -p 1 zcu102.srp -o linux.dtb
```

2. Modify device tree:
```bash
dtc -I dtb -O dts linux.dtb -o linux.dts
# Edit linux.dts as needed
dtc -I dts -O dtb linux.dts -o linux.dtb
```

3. Rebuild SRP:
```bash
mkimage -f srp.its zcu102_new.srp
```

## Support

For questions or assistance, please contact:
- Email: support@wolfssl.com
