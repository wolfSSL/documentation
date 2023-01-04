# Next Steps

## wolfCrypt Test Application

After getting wolfSSL proper to build on the target platform, a good
next step is to port the wolfCrypt test application. Running this
application on the target system will verify that all the crypto
algorithms are working correctly, using NIST test vectors.

If this step is skipped, and you instead proceed directly to
establishing an SSL connection, it can be more difficult to debug
problems caused by underlying crypto operations failing.

The wolfCrypt test application is located in _./wolfcrypt/test/test.c_.
If an embedded application has its own `main()` function, then
__NO_MAIN_DRIVER__ must be defined when compiling
_./wolfcrypt/test/test.c_. This will allow the application's `main()`
to call each cipher/algorithm test individually on its own.

If an embedded device does not have enough resources to run the entire
wolfCrypt test application, individual tests can be broken out of
_test.c_ and compiled individually. Please ensure that correct header
files needed for the specific test case are included in the build when
extracting isolated crypto tests from _test.c_.
