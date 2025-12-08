# Introduction

This page lists some of the most common issues and questions that are recieved by our wolfSSL security experts, along with their responses. This FAQ is useful for solving general questions that pertain to building/implementing wolfSSL FIPS. If this page does not provide an answer to your question, please feel free to check the wolfSSL Manual, or contact us at support@wolfssl.com.

Last Updated: 8 Dec 2025

## Questions

1. [Why did I receive wolfSSL_X.X.X_commercial-fips-OE-v2.7z when we validated with Y.Y.Y?](./section02.md#why-did-i-receive-wolfssl-xxx-xommercial-fips-oe-v27z-when-we=validated-with-yyy)
2. [How do I know if I am using the FIPS module?](./section02.md#how-do-i-know-if-i-am-using-the-fips-module)
3. [Does the Power On Self Test (POST) really have to run every time?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-time)
	1. [Followup Post Q: What about this feature NO_ATTRIBUTE_CONSTRUCTOR? Can I use that to by-pass the POST by not running it in the constructor?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-time)
	2. [Followup Post Q: Why is the feature NO_ATTRIBUTE_CONSTRUCTOR there then if I can not use it?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-time)
	3. [Followup Post Q: Who can determine when NO_ATTRIBUTE_CONSTRUCTOR is allowed?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-time)
	4. [Followup Post Q: What about with fips-ready, can I use NO_ATTRIBUTE_CONSTRUCTOR with fips-ready?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-time)
4. [What can go wrong for the end user after basic testing?](./section02.md#what-can-go-wrong-for-the-end-user-after-basic-testing)
5. [Moving from 140-2 to 140-3, what's new?](./section02.md#moving-from-140-2-to-140-3-whats-new)
	1. [Will my applications that are linked agaist the 140-2 module still work with the 140-3 module?](./section02.md#will-my-app-for-1402-still-work-with-1403)
	2. [The wc_SetSeed_Cb() callback and the TLS Layer:](./section02.md#wc-setseed-and-tls)
	3. [The wc_SetSeed_Cb() callback and a custom seed generation function:](./section02.md#wc-setseed-and-custom-genseed)
	4. [Threading consideration for all CASTs():](./section02.md#threading-and-casts)
	5. [wc_SetSeedCb() a bit unique with relation to CAST's:](./section02.md#setseedcb-and-casts)
	6. [Key Access Management](./section02.md#key-access-management)
	7. [wc_SetSeedCb() a bit unique with relation to CAST's:](./section02.md#setseedcb-and-casts)
		1. [API's that require UNLOCK before first use (should also be re-LOCKED after use):](./section02.md#apis-to-unlock)


