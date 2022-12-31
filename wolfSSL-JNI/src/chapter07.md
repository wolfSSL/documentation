#  Usage

For usage, please follow the Oracle/OpenJDK Javadocs for the classes specified
in the previous chapter. Note that you will need to explicitly request the
“wolfJSSE” provider if it has been set lower in precedence than other providers
that offer the same algorithm in the `java.security` file.

For example, to use the wolfJSSE provider with the SSLContext class for TLS 1.2
an application would create a SSLContext object like so:

```
SSLContext ctx = SSLContext.getInstance(“TLSv1.2”, “wolfJSSE”);
```
