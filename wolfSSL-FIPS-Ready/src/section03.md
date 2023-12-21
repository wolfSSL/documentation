# What has changed from the original FIPS 140-2 ready?

1. One now needs to call wc_SetSeed_Cb at the application level when running in 
FIPS mode.

  a.  +#ifdef WC_RNG_SEED_CB

  b.  + wc_SetSeed_Cb(wc_GenerateSeed);

  c.  +#endif

2. KEY Access Management

  a.  Users calling wolfSSL (SSL/TLS) APIs’ do not need to worry about the KEY 
  Access Management item, however for those calling crypto APIs please see 
  next steps

  b.  Users invoking wolfcrypt (wc_XXX) APIs’ directly that involve loading or 
  using a private key must manage the key access at the application level. To 
  be able to read in or use a private key the application must allow this by 
  calling PRIVATE_KEY_UNLOCK(); prior to reading a key or using a key. When 
  finished the application must** lock the key access again before terminating 
  by calling PRIVATE_KEY_LOCK();

     i.  The PRIVATE_KEY_UNLOCK and PRIVATE_KEY_LOCK can optionally be invoked 
     only once on startup and once on shutdown or…

     ii.  If the application wishes to be very strict, these can be called 
     immediately before and after each call that involves a private key load 
     or use.

     ** “application must lock again before terminating” - This is a 
     documentation requirement, this is not enforced at run-time by an error 
     or prevention from exiting. Failing to re-locking the key before exiting 
     makes the application “not FIPS compliant”.

  c.  To support an application that can link to both a wolfSSL FIPS library 
  version and a wolfSSL non-FIPS library version users can implement NO-OP 
  versions for the non-FIPS cases like so:

```
#if !defined(PRIVATE_KEY_LOCK) && !defined(PRIVATE_KEY_UNLOCK)
    #define PRIVATE_KEY_LOCK() do {} while (0)
    #define PRIVATE_KEY_UNLOCK() do {} while (0)
#endif
```

