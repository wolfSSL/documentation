# FIPS 140-3 Support

wolfProvider has been designed to work with FIPS 140-3 validated versions of wolfCrypt when compiled against a FIPS-validated version of wolfCrypt. This usage scenario requires a properly licensed and validated version of wolfCrypt, as obtained from wolfSSL Inc.

Note that wolfCrypt FIPS libraries cannot be “switched” into non-FIPS mode. wolfCrypt FIPS and regular wolfCrypt are two separate source code packages.

When wolfProvider is compiled to use wolfCrypt FIPS, it registers provider callbacks for the algorithms supplied by the wolfCrypt FIPS module. Applications targeting FIPS compliance must restrict their usage to the approved algorithms, modes, and key sizes listed in the module's Security Policy; some registered modes may fall outside the validated set and must not be relied on in a FIPS-compliant deployment. If OpenSSL based applications call non-FIPS validated algorithms, execution may not enter wolfProvider and could be handled by the default OpenSSL provider or other registered providers, based on the OpenSSL configuration. 

**NOTE** : If targeting FIPS compliance, and non-wolfCrypt FIPS algorithms are called from a different provider, those algorithms are outside the scope of both wolfProvider and wolfCrypt FIPS and may not be FIPS validated.

For broader FIPS coverage, wolfProvider is typically built in replace-default mode, which makes wolfProvider OpenSSL's default provider and reduces the risk of applications silently falling back to non-FIPS algorithms in the default provider. Enabling this requires both the `--enable-replace-default` build option and building OpenSSL with wolfProvider's provider replacement; `scripts/build-wolfprovider.sh --replace-default` performs both steps. It does not by itself guarantee system-wide FIPS compliance, as explicitly loaded providers and direct low-level calls remain outside its control. See the [Loading wolfProvider](chapter07.md) chapter for replace-default mode, and the wolfProvider FIPS Integration Guide (`docs/FIPS_INTEGRATION_GUIDE.md` in the wolfProvider package) for the FIPS baseline verification and production FIPS build workflow, including the supported wolfCrypt FIPS module generations (for example v5, v6, and v7) and FIPS Ready bundles.

For more information on using wolfCrypt FIPS (140-2 / 140-3), contact wolfSSL at facts@wolfssl.com.
