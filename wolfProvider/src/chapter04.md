# FIPS 140-3 Support

wolfProvider has been designed to work with FIPS 140-3 validated versions of wolfCrypt when compiled against a FIPS-validated version of wolfCrypt. This usage scenario requires a properly licensed and validated version of wolfCrypt, as obtained from wolfSSL Inc.

Note that wolfCrypt FIPS libraries cannot be “switched” into non-FIPS mode. wolfCrypt FIPS and regular wolfCrypt are two separate source code packages.

When wolfProvider is compiled to use wolfCrypt FIPS, it will only include support and register provider callbacks for FIPS-validated algorithms, modes, and key sizes. If OpenSSL based applications call non-FIPS validated algorithms, execution may not enter wolfProvider and could be handled by the default OpenSSL provider or other registered provider providers, based on the OpenSSL configuration. 

**NOTE** : If targeting FIPS compliance,and non-wolfCrypt FIPS algorithms are called from a different provider, those algorithms are outside the scope of
wolfProvider and wolfCrypt FIPS and may not be FIPS validated.

For more information on using wolfCrypt FIPS (140-2 / 140-3), contact wolfSSL at facts@wolfssl.com.
