#  インストール

wolfJCE をインストールして使用するには、次の 2 つの方法があります：


##  実行時インストール

実行時に wolfJCE をインストールして使用するには、まず  "**libwolfcryptjni.so**" がシステムのライブラリ検索パスにあることを確認してください。 Linux では、このパスを次のようにして変更できます：


```
    $ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```
次に、wolfCrypt JNI / wolfJCE JAR ファイル (**wolfcrypt-jni.jar**) を Java クラスパスに配置します。 これを行うには、システムのクラスパス設定を調整するか、コンパイル時と実行時に次のようにします：


```
    $ javac -classpath <path/to/jar> ...
    $ java -classpath <path/to/jar> ...
```
最後に、Java アプリケーションで、プロバイダークラスをインポートし、Security.addProvider() を呼び出して、実行時にプロバイダーを追加します：

```
    import com.wolfssl.provider.jce.WolfCryptProvider;
    public class TestClass {
       public static void main(String args[]) {
          ...
          Security.addProvider(new WolfCryptProvider());
          ...
       }
    }
```
検証のためにインストールされているすべてのプロバイダーのリストを出力するには、次のようにします：

```
    Provider[] providers = Security.getProviders()
    for (Provider prov:providers) {
       System.out.println(prov);
    }
```

##  OS / システムレベルでのインストール

システム レベルで wolfJCE プロバイダーをインストールするには、JAR を OS の正しい Java インストール ディレクトリにコピーし、共有ライブラリがライブラリ検索パスにあることを確認します。

wolfJCE JAR ファイル (**wolfcrypt-jni.jar**) と共有ライブラリ (**libwolfcryptjni.so**) を次のディレクトリに追加します：


```
       $JAVA_HOME/jre/lib/ext directory
```

たとえば、OpenJDK を使用する Ubuntu では、次のようになります：

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```
さらに、次のようなエントリを java.security ファイルに追加します：

```
security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider
```
ava.security ファイルは次の場所にあります：

```
$JAVA_HOME/jre/lib/security/java.security
```
"N" を、ファイル内の他のプロバイダーと比較して WolfCryptProvider に持たせたい優先順位に置き換えます。

