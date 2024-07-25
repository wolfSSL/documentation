# FIPS 140-3 Support

wolfEngine has been designed to work with FIPS 140-3 validated versions of wolfCrypt when compiled against a FIPS-validated version of wolfCrypt. This usage scenario requires a properly licensed and validated version of wolfCrypt, as obtained from wolfSSL Inc.

Note that wolfCrypt FIPS libraries cannot be “switched” into non-FIPS mode. wolfCrypt FIPS and regular wolfCrypt are two separate source code packages.

When wolfEngine is compiled to use wolfCrypt FIPS, it will only include support and register engine callbacks for FIPS-validated algorithms, modes, and key sizes. If OpenSSL based applications call non-FIPS validated algorithms, execution may not enter wolfEngine and could be handled by the default OpenSSL engine or other registered engine providers, based on the OpenSSL configuration. 

**NOTE** : If targeting FIPS compliance,and non-wolfCrypt FIPS algorithms are called from a different engine, those algorithms are outside the scope of
wolfEngine and wolfCrypt FIPS and may not be FIPS validated.

For more information on using wolfCrypt FIPS (140-2 / 140-3), contact wolfSSL at facts@wolfssl.com.
