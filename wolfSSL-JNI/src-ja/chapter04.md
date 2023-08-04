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

##  OS / システムレベルでのインストール

###  Unix/Linux

システム/OS レベルで wolfJSSE プロバイダーをインストールするには、"wolfssl.jar"および/または"wolfssl-jsse.jar"を OS の正しい Java インストール ディレクトリにコピーし、"libwolfssljni.so"または"libwolfssljni.jnilib" 共有ライブラリがライブラリ検索パスに存在することを確認します。

JAR ファイル (`wolfssl.jar`、`wolfssl-jsse.jar`) と共有ライブラリ(`libwolfssljni.so`)を次のディレクトリに追加します：



```
$JAVA_HOME/jre/lib/ext
```
OpenJDK を使用する Ubuntu では、このパスは次のようになります：

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

さらに、次のエントリを `java.security` ファイルに追加します：


```
security.provider.N=com.wolfssl.provider.jsse.WolfSSLProvider
```

java.security ファイルは次の場所にあります:

```
$JAVA_HOME /jre/lib/security/java.security
```
"N"を、ファイル内の他のプロバイダーと比較して wolfJSSE に持たせたい優先順位に置き換えます。 WolfSSLProvider を最優先プロバイダとして配置するには、次の行を `java.security` ファイルのプロバイダリストに追加します。 また、java.security ファイルにリストされている他のプロバイダーの優先番号を付け直す必要があります。 最高の優先度は「1」です。


```
security.provider.1=com.wolfssl.provider.jsse.WolfSSLProvider
```

###  Android OSP (AOSP)

wolfJSSE をシステム セキュリティ プロバイダーとして Android OSP (AOSP) ソース ツリーにインストールする手順については、別のドキュメント「Installing a JSSE Provider in Android OSP」を参照してください。


