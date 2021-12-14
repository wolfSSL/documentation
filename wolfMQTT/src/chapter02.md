#  Building wolfMQTT

wolfMQTT was written with portability in mind, and should generally be easy to build on most systems. If you have difficulty building, please don’t hesitate to seek support through our  **support forums**  https://www.wolfssl.com/forums or contact us directly at **support@wolfssl.com** . This chapter explains how to build wolfMQTT on Unix and Windows, and provides guidance for building in a non-standard environment.

When using the autoconf / automake system to build, wolfMQTT uses a single Makefile to build all parts and examples of the library, which is both simpler and faster than using Makefiles recursively. If using the TLS features or the Firmware/Azure IoT Hub examples you’ll need to have wolfSSL installed. For wolfSSL and wolfMQTT we recommend using config options below
```
./configure  --enable-ecc  --enable-supportedcurves  --enable-base64encode. 
```
For wolfSSL use `make && sudo make install`. If you get an error locating the libwolfssl.so, run `sudo ldconfig` from the wolfSSL directory.

##  Getting the Source Code

The most recent version of wolfMQTT can be downloaded from the wolfSSL downloads page [here](https://www.wolfssl.com/download/)

Or from Github with the command:
```
git clone https://github.com/wolfSSL/wolfMQTT.git
```

##  Building on *nix/Mac

When building on Linux, *BSD, OS X, Solaris, or other *nix-like systems, use the autoconf system. If cloned from github, run the following three commands:
```
./autogen.sh
./configure
make
```
Otherwise, just run these two commands:
```
./configure
make
```
You can append any number of build options to `./configure`. For a list of available build options, run the command below:
```
./configure --help
```

To build wolfMQTT, run:
```
make
```
To install wolfMQTT run:
```
make install
```
You may need superuser privileges to install, in which case precede the command with sudo:
```
sudo make install
```

Notes:
* If `wolfssl` was recently installed, run `sudo ldconfig` to update the linker cache.
* Debug messages can be enabled using `--enable-debug` or `--enable-debug=verbose` (for extra logging).
* For a list of build options run `./configure --help`.
* The build options are generated in a file here: `wolfmqtt/options.h`.

To test the build, run the  _mqttclient_  program from the root wolfMQTT source directory:
```
./examples/mqttclient/mqttclient
```
If you want to build only the wolfMQTT library and not the additional items (examples), you can run the following command from the wolfMQTT root directory:
```
make src/libwolfmqtt.la
```


##  Building on Windows

**Visual Studio** :

For building wolfMQTT with TLS support in Visual Studio:

1. Open the `<wolfssl-root>/wolfssl64.sln`.
2. Re-target for your Visual Studio version (right-click on solution and choose `Retarget solution`).
3. Make sure the `Debug DLL` or `Release DLL` configuration is selected. Make note if you are building 32-bit `x86` or 64-bit `x64`.
4. Build the wolfSSL solution.
5. Copy the `wolfssl.lib` and `wolfssl.dll` files into `<wolfmqtt-root>`.
   * For `DLL Debug` with `x86` the files are in: `DLL Debug`.
   * For `DLL Release` with `x86` the files are in: `DLL Release`.
   * For `DLL Debug` with `x64` the files are in: `x64/DLL Debug`.
   * For `DLL Release` with `x64` the files are in: `x64/DLL Release`.
6. Open the `<wolfmqtt-root>/wolfmqtt.sln` solution.
7. Make sure you have the same architecture (`x86` or `x64` selected) as used in wolfSSL above.
8. By default the include path for the wolfssl headers is `./../wolfssl/`. If your wolfssl root location is different you can go into the project settings and adjust this in `C/C++` -> `General` -> `Additional Include Directories`.
9. Configure your Visual Studio build settings using `wolfmqtt/vs_settings.h`.
10. Build the wolfMQTT solution.

The wolfmqtt.sln solution is included for Visual Studio 2015 in the root directory of the install. To test each build, choose “Build All” from the Visual Studio menu and then run the mqttclient program. To edit build options in the Visual Studio project, select your desired project (wolfmqtt, mqttclient) and browse to the “Properties” panel. 

For instructions on building the required wolfssl.dll see [here](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio). When done copy the wolfssl.dll and wolfssl.lib into the wolfMQTT root. The project also assumes the wolfSSL headers are located `../wolfssl/`.

**Cygwin** : If using Cygwin, or other toolsets for Windows that provides *nix-like commands and functionality, please follow the instructions in Section 2.2, above, for “Building on *nix”. If building wolfMQTT for Windows on a Windows development machine, we recommend using the included Visual Studio project files to build wolfMQTT.

##  Building on Arduino 

### Reformatting wolfMQTT as a compatible Arduino Library 

wolfmqtt-arduino.sh is a shell script that will re-organize the wolfMQTT library to be compatible with Arduino projects. The Arduino IDE requires a library's source files to be in the library's root directory with a header file in the name of the library. This script copies all source files to the `IDE/ARDUINO/wolfMQTT` directory and creates a stub header file called `wolfMQTT.h`.

To configure wolfMQTT with Arduino, enter the following from within the IDE/ARDUINO directory:
```
    ./wolfmqtt-arduino.sh
```
### Including wolfMQTT in Arduino Libraries (for Arduino version 1.8.2)

1. In the Arduino IDE:
    - In `Sketch -> Include Library -> Add .ZIP Library...` and choose the
        `IDE/ARDUNIO/wolfMQTT` folder.
    - In `Sketch -> Include Library` choose wolfMQTT.

To enable TLS support, add `#define ENABLE_MQTT_TLS` in
    `IDE/ARDUNIO/wolfMQTT/wolfmqtt/options.h`.
Note: If using wolfSSL TLS then you'll need to do this for wolfSSL as well.
See `<wolfssl-root>/IDE/ARDUINO/README.md` for instructions.


An example wolfMQTT client INO sketch exists here:
`wolfmqtt_client/wolfmqtt_client.ino` to demonstrate using the wolfMQTT library.


##  Building with MinGW

After downloading both wolfSSL and wolfMQTT, run the script below to build then install both:

```sh
export PATH="/opt/mingw-w32-bin_i686-darwin/bin:$PATH"
export PREFIX=$PWD/build

# wolfSSL
cd wolfssl
./configure --host=i686 CC=i686-w64-mingw32-gcc LD=i686-w64-mingw32-ld CFLAGS="-DWIN32 -DMINGW -D_WIN32_WINNT=0x0600" LIBS="-lws2_32 -L$PREFIX/lib -lwolfssl" --prefix=$PREFIX
make
make install

# wolfMQTT
cd ../wolfmqtt
./configure --host=i686 CC=i686-w64-mingw32-gcc LD=i686-w64-mingw32-ld CFLAGS="-DWIN32 -DMINGW -D_WIN32_WINNT=0x0600 -DBUILDING_WOLFMQTT -I$PREFIX/include" LDFLAGS="-lws2_32 -L$PREFIX/lib -lwolfssl" --prefix=$PREFIX --disable-examples
make
```

##  Building in a non-standard environment

While not officially supported, we try to help users wishing to build wolfMQTT in a non-standard environment, particularly with embedded and cross-compilation systems. Below are some notes on getting started with this.

1. The source and header files need to remain in the same directory structure as they are in the wolfMQTT download package.
2. Some build systems will want to explicitly know where the wolfMQTT header files are located, so you may need to specify that. They are located in the `<wolfmqtt_root>/wolfmqtt` directory. Typically, you can add the <wolfmqtt_root> directory to your include path to resolve header problems.
3. wolfMQTT defaults to a little endian system unless the configure process detects big endian. Since users building in a non-standard environment aren't using the configure process, BIG_ENDIAN_ORDER will need to be defined if using a big endian system.
4. Try to build the library, and let us know if you run into any problems. If you need help, contact us at  _support@wolfssl.com_ .

##  Cross Compiling

Many users on embedded platforms cross compile for their environment. The easiest way to cross compile the library is to use the ./configure system. It will generate a Makefile which can then be used to build wolfMQTT. When cross compiling, you’ll need to specify the host to `./configure`, such as:
```
./configure --host=arm-linux
```
You may also need to specify the compiler, linker, etc. that you want to use:
```
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```
After correctly configuring wolfMQTT for cross-compilation, you should be able to follow standard autoconf practices for building and installing the library:
```
make
sudo make install
```
If you have any additional tips or feedback about cross compiling wolfMQTT, please let us know at _info@wolfssl.com_.

### Install to Custom Directory

To setup a custom install directory for wolfSSL and specify the custom wolfSSL lib/include directories for wolfMQTT, use the following:

In wolfSSL:
```
./configure  --prefix=~/wolfssl
make
make install
```
This will place the libs in `~/wolfssl/lib` and includes in `~/wolfssl/include`.

In wolfMQTT:
```
./configure --prefix=~/wolfmqtt  --libdir=~/wolfssl/lib  --includedir=~/wolfssl/include
make
make install
```
Make sure the paths above match your actual location.


