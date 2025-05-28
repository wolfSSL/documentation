# Introduction

This page lists some of the most common issues and questions that are recieved by our wolfSSL security experts, along with their responses. This FAQ is useful for solving general questions that pertain to building/implementing wolfSSL FIPS. If this page does not provide an answer to your question, please feel free to check the wolfSSL Manual, or contact us at support@wolfssl.com.

## Questions

1. [Why did I receive wolfSSL_X.X.X_commercial-fips-OE-v2.7z when we validated with Y.Y.Y?](./section02.md#why-did-i-receive-wolfssl-xxx-xommercial-fips-oe-v27z-when-we=validated-with-yyy)
2. [How do I know if I am using the FIPS module?](./section02.md#how-do-i-if-i-am-using-the-fips-module)
3. [Does the Power On Self Test (POST) really have to run every time?](./section02.md#does-the-power-on-self-test-post-really-have-to-run-every-teime)
	a. [Followup POST Q: What about this feature NO_ATTRIBUTE_CONSTRUCTOR? Can I use that to by-pass the POST by not running it in the constructor?](./section02.md#followup-post-q-what-about-this-feature-no-attribute-constructor-can-i-use-that-to-by-pass-the-post-by-not-running-it-in-the-constructor)
	b. [Followup POST Q: Why is the feature NO_ATTRIBUTE_CONSTRUCTOR there then if I can not use it?](./section02.md#followup-post-q-why-is-the-feature-no-attribute-constructor-there-then-if-i-can-not-use-it)
	c. [Followup POST Q: Who can determine when NO_ATTRIBUTE_CONSTRUCTOR is allowed?](./section02.md#followup-post-q-who-can-determine-when-no-attribute-constructor-is-allowed)
	d. [Followup POST Q: What about with fips-ready, can I use NO_ATTRIBUTE_CONSTRUCTOR with fips-ready?](./section02.md#followup-post-q-what-about-with-fips-ready-can-i-use-no-attribute-constructor-with-fips-ready)
4. [WhatWhat can go wrong for the end user after basic testing?](./section02.md#what-can-go-wrong-for-the-end-user-after-basic-testing)
