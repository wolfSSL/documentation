#  Callback Function Setup API

The following functions are used to set up the user authentication callback function.

##  Setting the User Authentication Callback Function
```
void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx , WS_CallbackUserAuth
cb );
```
The callback function is set on the wolfSSH CTX object that is used to create the wolfSSH session objects. All sessions using this CTX will use the same callback
function. This context is not to be confused with the callback function's context.

##  Setting the User Authentication Callback Context Data
```
void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh , void* ctx );
```
Each wolfSSH session may have its own user authentication context data or share some. The wolfSSH library knows nothing of the contents of this context data. It is up to the application to create, release, and if needed provide a mutex for the data. The callback receives this context data from the library.

##  Getting the User Authentication Callback Context Data
```
void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh );
```
This returns the pointer to the user authentication context data stored in the provided wolfSSH session. This is not to be confused with the wolfSSH's context data used to create the session.

## Setting the Keyboard-Interactive Prompts

There is no separate callback for the keyboard-interactive prompts. The server
calls the user authentication callback with the `authType`
`WOLFSSH_USERAUTH_KEYBOARD_SETUP` to get the prompts to send to the client, as
described in the previous chapter. Keyboard-interactive authentication requires
a build with `--enable-keyboard-interactive` (`WOLFSSH_KEYBOARD_INTERACTIVE`).

## Setting the Allowed Authentication Types Callback Function
```
void wolfSSH_SetUserAuthTypes(WOLFSSH_CTX* ctx, WS_CallbackUserAuthTypes cb);
```

The optional callback returns the set of authentication types, as a bit mask of
the `WOLFSSH_USERAUTH_*` type constants, that the server lists to the client as
able to continue. Without it, the server lists password, public key, and, when
built in, keyboard-interactive.

## Setting the User Authentication Result Callback Function
```
void wolfSSH_SetUserAuthResult(WOLFSSH_CTX* ctx, WS_CallbackUserAuthResult cb);
void wolfSSH_SetUserAuthResultCtx(WOLFSSH* ssh, void* userAuthResultCtx);
```

The optional callback is told the result of the library's check of a public
key user authentication signature. When it is told of a success, returning a
value other than `WS_SUCCESS` turns the attempt into a failure.

## Setting the Maximum Authentication Attempts
```
int wolfSSH_CTX_SetMaxAuthAttempts(WOLFSSH_CTX* ctx, int value);
int wolfSSH_SetMaxAuthAttempts(WOLFSSH* ssh, int value);
```

The server disconnects a client after this many failed user authentication
attempts. The default is `DEFAULT_MAX_AUTH_ATTEMPTS` (6). A value of 0 or less
restores the default.

##  Example Echo Server User Authentication

The example echo server implements the authentication callback with sample users using passwords and public keys. The example callback, wsUserAuth, is set on the wolfSSH context:
```
wolfSSH_SetUserAuth(ctx, wsUserAuth);
```
The example password file (passwd.txt) is a simple list of usernames and passwords separated with a colon respectively. The defaults that exist within this file are as follows.

```   
jill:upthehill
jack:fetchapail
```
The public key file are the concatenation of the public key outputs of running ssh-keygen twice.

```
ssh-rsa AAAAB3NzaC1yc...d+JI8wrAhfE4x hansel
ssh-rsa AAAAB3NzaC1yc...UoGCPIKuqcFMf gretel
```
All users' authorization data is stored in a linked list of pairs of usernames and SHA-256 hashes of either the password or the public key blob.

The public key blobs in the configuration file are Base64 encoded and are decoded before hashing. The pointer to the list of username-hash pairs is stored into a new wolfSSH session:
```
wolfSSH_SetUserAuthCtx(ssh, &pwMapList);
```
The callback function first checks if the authType is either public key or a password, and returns the general user authentication failure error code if neither. Then it hashes the public key or password passed in via the authData. It then walks through the list trying to find the username, and if not found returns the invalid user error code. If found, it compares the calculated hash of the public key or password passed in and the hash stored in the pair. If they match, the function returns success, otherwise it returns the invalid password or public key error code.
