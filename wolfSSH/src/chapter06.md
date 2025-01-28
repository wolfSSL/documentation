#  Callback Function Setup API

The following functions are used to set up the user authentication callback function.

##  Setting the User Authentication Callback Function
```
void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx , WS_CallbackUserAuth
cb );
```
The callback function is set on the wolfSSL CTX object that is used to create the wolfSSH session objects. All sessions using this CTX will use the same callback
function. This context is not to be confused with the callback function’s context.

##  Setting the User Authentication Callback Context Data
```
void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh , void* ctx );
```
Each wolfSSH session may have its own user authentication context data or share some. The wolfSSH library knows nothing of the contents of this context data. It is up to the application to create, release, and if needed provide a mutex for the data. The callback receives this context data from the library.

##  Getting the User Authentication Callback Context Data
```
void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh );
```
This returns the pointer to the user authentication context data stored in the provided wolfSSH session. This is not to be confused with the wolfSSH’s context data used to create the session.

## Setting the Keyboard Authentication Prompts Callback Function
```
void wolfSSH_SetKeyboardAuthPrompts(WOLFSSH_CTX* ctx, WS_CallbackKeyboardAuthPrompts cb);
```

The server needs to specify the prompts that are to be given to the client so
that it can authenticate in Keyboard-Interactive mode. This callback allows the
server to set the prompts ready to send to the client.

Without this set, Keyboard-Interactive mode will be disabled on the server, even
if attempts are made to explicitly enable it.

##  Example Echo Server User Authentication

The example echo server implements the authentication callback with sample users using passwords and public keys. The example callback, wsUserAuth, is set on the wolfSSH context:
```
wolfSSH_SetUserAuth(ctx, wsUserAuth);
```
The example password file (passwd.txt) is a simple list of usernames and passwords seperated with a colon respectively. The defaults that exist within this file are as follows.

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
