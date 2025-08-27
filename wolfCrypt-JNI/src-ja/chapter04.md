#  インストール

wolfJCEをインストールして使用する方法は2つあります - 1つは単一のJavaアプリケーション内での実行時、もう1つは全てのJavaアプリケーションが使用するためのシステムレベルです。


##  実行時インストール

単一のアプリケーション内での実行時にwolfJCEをインストールして使用するには、まず「**libwolfcryptjni.so**」（MacOSの場合は「**libwolfcryptjni.dylib**」）がシステムのライブラリ検索パスにあることを確認してください。
Linuxでは、このパスを次のようにして変更できます：

```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```

MacOSでは、代わりに `DYLD_LIBRARY_PATH` を使用できます：

```
$ export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/path/to/add
```

次に、wolfCrypt JNI / wolfJCE JAR ファイル (**wolfcrypt-jni.jar**) を Java クラスパスに配置します。 これを行うには、システムのクラスパス設定を調整するか、コンパイル時と実行時に次のようにします：

```
$ javac -classpath <path/to/jar> ...
$ java -classpath <path/to/jar> ...
```

最後に、Javaアプリケーションで、プロバイダークラスをインポートし、`Security.insertProviderAt()` を呼び出してwolfCryptProviderをJavaプロバイダーリストの最上位優先プロバイダーとして挿入することで、実行時にプロバイダーを追加してください。
プロバイダーの位置1が最も優先度の高い位置であることにご注意ください。

```
import com.wolfssl.provider.jce.WolfCryptProvider;

public class TestClass {
   public static void main(String args[]) {
      ...
      Security.insertProviderAt(new WolfCryptProvider(), 1);
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

##  OS / システムレベルでのインストール (Java 8以下)

wolfJCEはシステムレベルでインストールできるため、暗号化にJava Security APIを使用するあらゆるJavaアプリケーションがwolfJCEを活用できます。
wolfJCEプロバイダーをシステムレベルでインストールするには、JARをお使いのOSとJDKに対応した正しいJavaインストールディレクトリにコピーし、共有ライブラリがライブラリ検索パスにあることを確認します。

wolfCrypt JNI/JCE JARファイル（**wolfcrypt-jni.jar**）と共有ライブラリ（**libwolfcryptjni.so** または **libwolfcryptjni.dylib**）を以下のディレクトリに追加してください：

```
$JAVA_HOME/jre/lib/ext
```

たとえば、OpenJDK を使用する Ubuntu では、次のようになります：

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

次に、以下のように `java.security` ファイルにWolfCryptProviderのプロバイダーエントリを追加してください：

```
security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider
```

java.security ファイルは次の場所にあります：

```
$JAVA_HOME/jre/lib/security/java.security
```

"N" を、ファイル内の他のプロバイダーと比較して WolfCryptProvider に持たせたい優先順位に置き換えます。
