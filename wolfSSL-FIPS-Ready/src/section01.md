# wolfSSL FIPS Ready

Do you have a project that will need a FIPS approved cryptographic library at 
a later date, but want to be ready for it now? wolfSSL FIPS Ready includes the 
cryptography layer from the public wolfSSL source tree, along with the FIPS 
tooling enabled for a FIPS Ready build. FIPS Ready allows application developers 
to assure that they have correctly integrated the necessary FIPS setup, and are 
correctly using the API and underlying protocols, providing for a seamless 
transition to the full FIPS certified wolfSSL library for an application. When 
the time comes, we will shepherd your operating environment through testing and 
add it to the wolfCrypt FIPS 140-3 certificate. In special situations, a new 
FIPS 140-3 certificate will be required, but we are ready to provide guidance 
through the testing and certification process. In both scenarios, FIPS Ready 
assures that your application will be fully functional with wolfCrypt as 
certified.

FIPS Ready is open source and dual-licensed. wolfSSL Inc distributes FIPS 
Ready wolfSSL with the GPLv3 license or can negotiate commercial licensing 
terms with support if needed beyond the proof of concept phase.

FIPS is a complicated topic. If you have questions after reviewing this 
document, then just contact us at facts -at- wolfssl  _dot_ calm. The email 
address is obfuscated for the spiders, but the calm is for the calm you’ll feel 
when you are FIPS Ready.

## What is Different from a non-FIPS build of wolfSSL? 

The wolfCrypt FIPS API provides wrappers for all the approved algorithm 
functions that are within the FIPS boundary. The FIPS wrappers can be called 
directly, or you can keep calling the original APIs; at compile time the API 
is swapped by the headers so that the FIPS wrappers will be called either way. 
The FIPS wrapper functions check the status of the internal self-testing before 
calling the actual function. If the CAST for that specific algorithm has not 
been run at least one time previously it will run the first time the algorithm 
is used. Users now have the option to either pre-emptively test algorithms at 
start up if they wish to avoid the test running at a later time or they can 
just let the test run when the algorithm is used.

The wolfCrypt FIPS 140-3 ready code has a required power-on self-test (POST) 
that automatically checks the integrity of the executable in memory, this has 
not changed since 140-2, only the known answer tests (KATs) for algorithms not 
used by the POST are now conditional upon use. The executable is organized so 
the code in the FIPS boundary is contiguous in memory. When the application 
using the FIPS code starts up, or the shared library is loaded, the default 
entry point of the library is called, and the POST runs automatically. It has 
two major parts: the in-core memory check and the known answer tests (KAT) for 
the algo used by the POST (HMAC-SHA256).

The POST for HMAC-SHA256 is performed first followed by the in-core memory 
test. The code in memory is hashed with HMAC-SHA256. If the hash matches, the 
test progresses. Otherwise the FIPS module is placed in an error state and all 
calls into the module will fail. In this case, the FIPS source code must be 
updated with the correct integrity hash, and only after recompilation can the 
module successfully initialize.

All other algorithms in the FIPS boundary are tested with canned data the 
first time they are used or optionally whenever the developer wants them to 
run. The output is compared to pre-computed known answers. The test values are 
all inside the boundary and are checked at the time they are called. Several of
the tests have a random component, for example a sign and verify, so a known 
piece of data is signed and then verified with a canned key. The key generation
is tested in a similar fashion.

The FIPS boundary provides confirmation about multiple aspects of your 
application. The processing of private key access that will assure proper 
unlocking and relocking of keys according to the FIPS specification. The 
assurance that no FIPS-forbidden modes or key sizes are being used, along with 
proper entropy source setup. FIPS Ready also helps discover conflicts with 
outside sub-system integration your application needs, for example determining 
if other applications or devices on a network support your new FIPS Ready 
cipher suites for communication between each other.


