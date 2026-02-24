#  インストール

wolfJSSE をインストールして使用するには、実行時に行うかあるいはシステム レベルでグローバルでインストールするかの2つの方法があります。


##  実行時インストール

実行時に wolfJSSE をインストールして使用するには、まず"libwolfssljni.so" がシステム ライブラリの検索パスに存在していることを確認してください。 Linux では、このパスを次のように変更できます:


```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```
OSX では、`LD_LIBRARY_PATH` の代わりに `DYLD_LIBRARY_PATH` を使用します。

次に、wolfSSL JNI / wolfJSSE JAR ファイル (wolfssl.jar、wolfssl-jsse.jar) を Java クラスパスに配置します。 このために、システムのクラスパス設定を調整するか、特定のアプリケーションのコンパイル時および実行時に次のようにします：


```
$ javac -classpath <path/to/jar> ...
$ java -classpath <path/to/jar> ...
```
最後に、Java アプリケーションで、プロバイダ クラスをインポートして `Security.addProvider()` を呼び出すことにより、実行時にプロバイダを追加します：

```
import com.wolfssl.provider.jsse.WolfSSLProvider;

public class TestClass {
    public static void main(String args[]) {
        ...
        Security.addProvider(new WolfSSLProvider());
        ...
    }
}
```
インストールされているすべてのセキュリティプロバイダのリストを確認用に出力するには、次の手順を実行します：


```
Provider[] providers = Security.getProviders();
for (Provider prov:providers) {
    System.out.println(prov);
}
```

### Java Module System (JPMS)のサポート

wolfJSSEはJava Module System (JPMS)との互換性のため、Java ServiceLoaderに対応しています。
これによって、JARファイルがモジュールパスに存在するとき、wolfJSSEプロバイダーが自動的に検出・ロードできるようになっています。

wolfJSSEのJARファイルは自動検出のために`com.wolfssl.provider.jsse.WolfSSLProvider`を登録する`META-INF/services/java.security.Provider`ファイルを含んでいます。
アプリケーションはJava標準のServiceLoader APIを使用してwolfJSSE プロバイダーを検出・ロードできます。

```java
import java.security.Provider;
import java.security.Security;
import java.util.ServiceLoader;

ServiceLoader<Provider> loader = ServiceLoader.load(Provider.class);
for (Provider provider : loader) {
    if (provider.getName().equals("wolfJSSE")) {
        Security.addProvider(provider);
        break;
    }
}
```

複数のモジュールで成り立っているアプリケーションにおいて、wolfJSSEは自動的に検出されて、あるいは`module-info.java`で定義された依存関係の1つとして使用できます。

**注意：** ServiceLoaderベースのプロバイダー検出は、JAR/モジュールシステムの1つとして`META-INF/services`機構によって実行されます。
Android環境においては、`Security.addProvider(new WolfSSLProvider())`を使用して明示的にプロバイダーをロードする必要があります。

##  OS / システムレベルでのインストール

###  Unix/Linux

システム/OS レベルで wolfJSSE プロバイダーをインストールするには、"wolfssl.jar"および/または"wolfssl-jsse.jar"を OS の正しい Java インストール ディレクトリにコピーし、"libwolfssljni.so"または"libwolfssljni.dylib" 共有ライブラリがライブラリ検索パスに存在することを確認します。

JAR ファイル (`wolfssl.jar`、`wolfssl-jsse.jar`) と共有ライブラリ(`libwolfssljni.so` または `libwolfssljni.dylib`)を次のディレクトリに追加します：

**JDK 8**では：

```
$JAVA_HOME/jre/lib/ext
```

OpenJDK 8 を使用する Ubuntu では、このパスは次のようになります：

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

**注意：** `jre/lib/ext`拡張は、JDK 9で削除されました。JDK 9以降では、JARファイルをクラスパスまたはモジュールパスに配置してください。

さらに、次のエントリを `java.security` ファイルに追加します：


```
security.provider.N=com.wolfssl.provider.jsse.WolfSSLProvider
```

java.security ファイルは次の場所にあります:

**JDK 8**では：

```
$JAVA_HOME/jre/lib/security/java.security
```

**JDK 9以降**では：

```
$JAVA_HOME/conf/security/java.security
```

"N"を、ファイル内の他のプロバイダーと比較して wolfJSSE に持たせたい優先順位に置き換えます。 WolfSSLProvider を最優先プロバイダとして配置するには、次の行を `java.security` ファイルのプロバイダリストに追加します。 また、java.security ファイルにリストされている他のプロバイダーの優先番号を付け直す必要があります。 最高の優先度は「1」です。


```
security.provider.1=com.wolfssl.provider.jsse.WolfSSLProvider
```

###  Android OSP (AOSP)

wolfJSSE をシステム セキュリティ プロバイダーとして Android OSP (AOSP) ソース ツリーにインストールする手順については、別のドキュメント「Installing a JSSE Provider in Android OSP」を参照してください。


