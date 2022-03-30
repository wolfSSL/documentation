#  Usage

For usage, please follow the Oracle/OpenJDK Javadocs for the classes specified in [Chapter 6](chapter06#supported-algorithms-and-classes) above. Note that you will need to explicitly request the “wolfJCE” provider if it has been set lower in precedence than other providers that offer the same algorithm in the java.security file. For example, to use the wolfJCE provider with the MessageDigest class for SHA-1 you would create a MessageDigest object like so:
```
MessageDigest md = MessageDigest.getInstance(“SHA-1”, “wolfJCE”);
```


Please email support@wolfssl.com with any questions or feedback.
