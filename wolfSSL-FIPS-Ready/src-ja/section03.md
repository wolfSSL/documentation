# FIPS 140-2 Ready版からの変更点

1. FIPSモードで実行する場合は、アプリケーションレベルで wc_SetSeed_Cb を呼び出す必要があります。

  a.  +#ifdef WC_RNG_SEED_CB

  b.  + wc_SetSeed_Cb(wc_GenerateSeed);

  c.  +#endif

2. 鍵アクセス管理

  a.  wolfSSL(SSL/TLS)APIを呼び出す場合には、この項による影響はありません。しかしCrypt API(wc_XXX)を呼び出す場合には、次のステップをご参照ください。

  b.  秘密鍵のロードまたは使用を伴う wolfCrypt (wc_XXX) API を直接呼び出す場合は、アプリケーション レベルで鍵へのアクセスを管理する必要があります。具体的には、秘密鍵のロードや使用前に、アプリケーションでPRIVATE_KEY_UNLOCK()を呼び出してロックを解除しなければなりません。使用後にはPRIVATE_KEY_LOCK()を呼び出して再度ロックする必要があります。

     i.  PRIVATE_KEY_UNLOCK()とPRIVATE_KEY_LOCK()は、アプリケーションの起動時及びシャットダウン時にそれぞれ1回だけ呼び出すことも可能です。

     ii.  秘密鍵のロードや使用の前後で都度これらを呼び出すことで、より厳密なアクセス管理を実現できます。

     ** アプリケーション終了前に、必ずロックする必要があります。 - これはドキュメント要件であり、実行時にエラーや終了防止によって強制されるものではありません。 終了する前にキーを再ロックしないと、アプリケーションは「FIPS に準拠していない」ことになります。


  c.  アプリケーションをwolfSSL FIPS版と非FIPS版の両方にリンクできるようにするには、次のように実装します。


```
#if !defined(PRIVATE_KEY_LOCK) && !defined(PRIVATE_KEY_UNLOCK)
    #define PRIVATE_KEY_LOCK() do {} while (0)
    #define PRIVATE_KEY_UNLOCK() do {} while (0)
#endif
```

