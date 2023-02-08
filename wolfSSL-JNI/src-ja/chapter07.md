#  使用方法

使用方法については、前の章で指定されたクラスの Oracle/OpenJDK Javadoc に従ってください。"wolfJSSE" プロバイダーが、　`java.security` ファイルで同じアルゴリズムを提供している他のプロバイダーよりも優先順位が低く設定されている場合は、明示的に"wolfJSSE" プロバイダーを使用することを要求する必要あります。

たとえば、TLS 1.2 の SSLContext クラスで wolfJSSE プロバイダーを使用するには
アプリケーションは次のように SSLContext オブジェクトを作成します：


```
SSLContext ctx = SSLContext.getInstance(“TLSv1.2”, “wolfJSSE”);
```
