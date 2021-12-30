#  wolfSSL JNI and wolfJSSE Compilation

There are three ways to compile wolfJSSE listed in this section, including using the Unix Command Line, Android Studio Build and Generic IDE Build.

##  Unix Command Line

Before following steps in this section, please ensure that the dependencies listed in Chapter 1 are installed. The “ java.sh ” script in the root package directory is used to compile the native JNI C source files into a shared library for either Unix/Linux or Mac. This script tries to auto-detect between OSX (Darwin) and Linux to set up include paths and shared library extension type. This script directly calls gcc on the JNI C source files, producing “./lib/libwolfssljni.so” or “./lib/libwolfssljni.dylib”
```
$ ./java.sh

Compiling Native JNI library:
WOLFSSL_INSTALL_DIR = /usr/local
Detected Linux host OS
Generated ./lib/libwolfssljni.so
```
To compile the Java sources, “ ant ” is used:
```
$ ant
```
This will build the wolfJSSE jar and native code necessary to use wolfJSSE in a project. To compile and run tests the command “ ant test ”is used:
```
$ ant test
```
This will compile tests and the main wolfJSSE code and output with the results of the tests will be displayed along with a summary of total tests that passed at the end of the wolfJSSE testsuite and wolfSSL JNI testsuite. A successful build will display the message “BUILD SUCCESSFUL” at the end.

```
[junit] WolfSSLTrustX509 Class
[junit] Testing parse all_mixed.jks ... passed
[junit] Testing loading default certs ... passed
[junit] Testing parse all.jks ... passed
[junit] Testing verify ... passed
...
...
...

build:

BUILD SUCCESSFUL
Total time: 18 seconds
```
To compile and run examples bundled with wolfJSSE the command “ ant examples ” is used:
```
$ ant examples
```
##  Android Studio Build

An example Android Studio project is located in the directory IDE/Android. To run the example Android Studio project use the following steps;

1. On an Android device, BKS format key stores are expected. To convert the JKS example bundles to BKS use the following commands:

```
cd examples/provider
./convert-to-bks.sh <path/to/provider>
```
Example:
```
cd examples/provider
./convert-to-bks.sh ~/Downloads/bcprov-jdk15on-161.jar
```

2. Push BKS bundles up to the device along with certificates. To do this, start up the emulator/device and use "adb push". An example of this would be the following commands from root wolfssljni directory:
```
adb shell
cd sdcard
mkdir examples
mkdir examples/provider
mkdir examples/certs
exit
adb push ./examples/provider/*.bks /sdcard/examples/provider/
adb push ./examples/certs/ /sdcard/examples/
```

3. Add wolfSSL source code for compiling. The project looks for the directory wolfssljni/IDE/Android/app/src/main/cpp/wolfssl for wolfSSL source code. This can be done multiple ways one being to download the latest release from wolfSSL's website, unzip it, rename it to wolfssl, and place it in the directory wolfssljni/IDE/Android/app/src/main/cpp/. Alternatively GitHub can be used with "cd /IDE/Android/app/src/main/cpp/ && git clone https://github.com/wolfssl/wolfssl". And the final method to be mentioned in this document is by creating a symbolic link to a wolfssl directory on the system by using "cd /IDE/Android/app/src/main/cpp/ && ln -s /path/to/local/wolfssl ./wolfssl".

4. Open the Android studio project by double clicking on the Android folder in wolfssljni/IDE/.

5. Compile the project and run MainActivity from app -> java -> com ->example.wolfssl. This will ask for permissions to access the certificates in the
    /sdcard/ directory and then print out the server certificate information on success.

6. OPTIONAL : The androidTests can then be run after permissions have been given. app->java->com.wolfssl->provider.jsse.test->WolfSSLJSSETestSuite and
    app->java->com.wolfssl->test->WolfSSLTestSuite.

7. OPTIONAL : To build with TLS 1.3 enabled macros need added to IDE/Android/app/src/main/cpp/CMakeLists.txt. The macros needed to be defined
    are; `HAVE_HKDF`, `WC_RSA_PSS`, `HAVE_FFDHE_2048`, `HAVE_SUPPORTED_CURVES`,`WOLFSSL_TLS13` and `HAVE_TLS_EXTENSION`. Each of those should be added to the “add_definitions” list in the CMakeLists.txt file.

## Generic IDE Build

For generic IDE builds create a new project in the IDE, then add source files from src/java. This will be the following packages:
```
com.wolfssl
com.wolfssl.provider.jsse
com.wolfssl.wolfcrypt
```
Run java.sh from the command line or have the IDE execute "java.sh" to generate the native shim layer linking against wolfSSL.

Add native library reference to the project. It should look in the lib directory for libwolfssl.jnilib (i.e. wolfssljni/lib/).
 
To compile test cases add the packages com.wolfssl.provider.jsse.test and com.wolfssl.test from the directory src/test. The project will also need JUNIT5 to run the tests.

If adding in optional examples then the source code in examples/provider/ can be added to the project. Optionally the IDE can execute examples/provider/ClientJSSE.sh. One of the difficult parts to adding in the examples is making sure the path to keystores is known to the IDE when it runs the examples, if trying to use the default keystores.


