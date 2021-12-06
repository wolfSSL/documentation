### RAND Command
Generates random bytes in raw or base64 form. By default it outputs the result to stdout but can be redirected with using the '-out' argument. The last argument passed in is the number of random bytes to generate.

- [-base64] base64 encode the resulting random bytes
- [-out] ouput file to write results to

Example:

```
wolfssl rand -base64 10
```
