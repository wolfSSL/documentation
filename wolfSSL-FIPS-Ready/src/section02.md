# Building wolfSSL as FIPS Ready

Once you have a copy of the source code unarchived into a directory, building 
is similar to normal wolfSSL, but with extra steps.

The following steps assume you are on a Linux or macOS box and are using the 
GPLv3 distribution of wolfSSL FIPS Ready to make a shared library to be 
installed into the system.

## Unarchive the source

```
$ tar xzvf wolfssl-5.6.4-gplv3-fips-ready.tar.gz
```

This unarchives the source into the directory wolfssl-5.6.4-gplv3-fips-ready. 
Change into this directory. If you received a commercial release, replace 
gplv3 with commercial and .tar.gz with .7z and tar xzvf with 7z x -p<password> 
found in the distribution email.

## Configure the build.

```
$ ./configure --enable-fips=ready
```

This command configures the Makefile to build wolfSSL for FIPS Ready.

## Make the library.

```
$ make
```

This compiles all the sources and links together the library. It also builds 
the example tools and testing tools.

## Update the in-core memory hash.

```
$ ./fips-hash.sh

$ make # Re-build once the hash has been updated
```

This step is where the hash for the in-core memory test is calculated and will 
need to be updated. The wolfCrypt test should fail when called by the 
fips-hash.sh script and if you were to echo out the output the following 
message would be observed (NOTE the hash value will be unique):

```
in my Fips callback, ok = 0, err = -203

message = In Core Integrity check FIPS error

hash = 8D29242F610EAEA179605BB1A99974EBC72B0ECDB26B483B226A729F36FC82A2

In core integrity hash check failure, copy above hash

into verifyCore[] in fips_test.c and rebuild
```

Should you add other options to the build, this may change the hash value and 
this step will need to be repeated. Also modifications to the application may 
result in the fips boundary shifting in memory when the application is 
re-compiled. The hash changing when only the application is updated is not an 
indication of the module being effected, only shifted in place in memory. This 
is expected if compiling a static library and application. Shared objects tend 
to not experience this issue.

4.1 If one were to do the above without using the provided 
fips-hash.sh/span>script one could either edit the file 
wolfcrypt/src/fips_test.c and update the hash manually or use a configure 
like so:

```
$ ./configure --enable-fips=ready CFLAGS=”-DWOLFCRYPT_FIPS_CORE_HASH_VALUE=8D29242F610EAEA179605BB1A99974EBC72B0ECDB26B483B226A729F36FC82A2”
```

4.2 Make the library again.

## Test the build.

```
$ make check
```

The check target in the Makefile will run all the test tools and scripts we 
provide with wolfSSL and wolfCrypt. If everything is OK, you should see the 
following output:

```

PASS: scripts/resume.test

PASS: scripts/external.test

PASS: scripts/google.test

PASS: testsuite/testsuite.test

PASS: scripts/openssl.test

PASS: tests/unit.test

=======================================================================

Testsuite summary for wolfssl 4.0.0

=======================================================================

# TOTAL: 6

# PASS:  6

# SKIP:  0

# XFAIL: 0

# FAIL:  0

# XPASS: 0

# ERROR: 0

=======================================================================

```



## Install the library and headers.

```
$ make install
```

The install target in the Makefile will install all the headers and the 
library into your system By default, this is into the directory /usr/local.

At this point, wolfSSL FIPS Ready should be ready to be used in your 
application builds.



