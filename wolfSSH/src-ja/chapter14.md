#  wolfSSL SFTP API リファレンス

##  接続機能



### wolfSSH_SFTP_accept()



**用法**

**説明**

クライアントからの接続要求を処理します

**戻り値**

**WS_SFTP_COMPLETE** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_accept(WOLFSSH* ssh );
```
**使用例**

```
WOLFSSH* ssh;

//create new WOLFSSH structure
...

if (wolfSSH_SFTP_accept(ssh) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_free()<br>

wolfSSH_new()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_connect()


**用法**

**説明**

SFTPサーバーへの接続を開始します。

**戻り値**

**WS_SFTP_COMPLETE** - 成功<br>

**引数**

**ssh** - – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_connect(WOLFSSH* ssh );
```


**使用例**

```
WOLFSSH* ssh;

//after creating a new WOLFSSH structure

wolfSSH_SFTP_connect(ssh);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_new()<br>

wolfSSH_free()<br>


### wolfSSH_SFTP_negotiate()



**用法**

**説明**

本関数はクライアントからの接続要求かサーバーへの接続要求のいずれかを処理します。いずれを処理するかはwolfSSHオブジェクトにセットされているアクションに依存します。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** - – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_negotiate(WOLFSSH* ssh)
```

**使用例**

```
WOLFSSH* ssh;

//create new WOLFSSH structure with side of connection
set
....

if (wolfSSH_SFTP_negotiate(ssh) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_free()<br>

wolfSSH_new()<br>

wolfSSH_SFTP_connect()<br>

wolfSSH_SFTP_accept()<br>



##  プロトコル関係



### wolfSSH_SFTP_RealPath()



**用法**

**説明**

REALPATHパケットを相手に送信し、相手から取得したファイル名を返します。


**戻り値**

成功時にはWS_SFTPNAME構造体へのポインターを返します。エラー発生時にはNULLを返します。


**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - 実際のパスを取得するためのディレクトリ/ファイル名



```
#include <wolfssh/wolfsftp.h>
WS_SFTPNAME* wolfSSH_SFTP_RealPath(WOLFSSH* ssh , char* dir);
```
**使用例**

```
WOLFSSH* ssh ;

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_read( ssh ) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>



### wolfSSH_SFTP_Close()



**用法**

**説明**

相手にクローズパケットを送信します。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**handle** - 閉じようとするハンドル<br>

**handleSz** - ハンドルバッファーのサイズ


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Close(WOLFSSH* ssh , byte* handle , word32 handleSz );
```
**使用例**

```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_Close(ssh, handle, handleSz) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_Open()



**用法**

**説明**

Openパケットを相手に送信します。結果を受け取るバッファサイズのをhandleSzで指定し、相手から受け取ったハンドルをバッファに格納します。


openの理由として取り得る値は:<br>

WOLFSSH_FXF_READ<br>

WOLFSSH_FXF_WRITE<br>

WOLFSSH_FXF_APPEND<br>

WOLFSSH_FXF_CREAT<br>

WOLFSSH_FXF_TRUNC<br>

WOLFSSH_FXF_EXCL<br>


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - 開くファイルの名前<br>

**reason** - ファイルを開く理由<br>

**atr** - ファイルの初期属性<br>

**handle** - 結果として得られるハンドル<br>

**handleSz** - ハンドル用バッファのサイズ<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Open(WOLFSSH* ssh , char* dir , word32　reason, WS_SFTP_FILEATRB* atr , byte* handle , word32* handleSz);
```

**使用例**



```
WOLFSSH* ssh ;
char name[NAME_SIZE];
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
WS_SFTP_FILEATRB atr;

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_Open( ssh , name , WOLFSSH_FXF_WRITE | WOLFSSH_FXF_APPEND | WOLFSSH_FXF_CREAT , &atr , handle , &handleSz ) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_SendReadPacket()

**用法**

**説明**

readパケットを相手に送信します。ハンドル用のバッファは直前のwolfSSH_SFTP_Openで得られたハンドルを格納していなければなりません。読みだすことができたデータはoutバッファに格納されます。


**戻り値**

成功時には読みだしたデータ数を返します。エラー発生時には、負の値を返します。

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**handle** - 読みだそうとするハンドル<br>

**handleSz** - ハンドルバッファのサイズ<br>

**ofst** - 読み出しを開始するオフセット<br>

**out** - 読み出した結果を格納するバッファ<br>

**outSz** - バッファサイズ


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SendReadPacket(WOLFSSH* ssh , byte*　handle , word32 handleSz , word64 ofst , byte* out , word32 outSz );
```



**使用例**

```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
byte out[OUT_SIZE];
word32 outSz = OUT_SIZE;
word32 ofst = 0;
int ret;

//set up ssh and do sftp connections
...
//get handle with wolfSSH_SFTP_Open()

if ((ret = wolfSSH_SFTP_SendReadPacket(ssh, handle, handleSz, ofst, out, outSz)) < 0) {
//handle error case
}
//ret holds the number of bytes placed into out buffer
```

**関連項目**

wolfSSH_SFTP_SendWritePacket()<br>

wolfSSH_SFTP_Open()<br>


### wolfSSH_SFTP_SendWritePacket()



**用法**

**説明**

writeパケットを相手に送信します。ハンドル用のバッファは直前のwolfSSH_SFTP_Openで得られたハンドルを格納していなければなりません。

**戻り値**

成功時には書き込んだサイズを返します。エラー発生時には負の値を返します。

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**handle** - 書き込もうとするハンドル<br>

**handleSz** - ハンドルバッファのサイズ<br>

**ofst** - 書き込みを開始するオフセット<br>

**out** - 書き込むデータを保持するバッファ<br>

**outSz** - バッファサイズ<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SendWritePacket(WOLFSSH* ssh, byte*　handle, word32　handleSz, word64 ofst, byte* out, word32 outSz);
```

**使用例**


```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
byte out[OUT_SIZE];
word32 outSz = OUT_SIZE;
word32 ofst = 0;
int ret;

//set up ssh and do sftp connections
...
//get handle with wolfSSH_SFTP_Open()

if ((ret = wolfSSH_SFTP_SendWritePacket(ssh, handle, handleSz, ofst, out, outSz)) < 0) {
//handle error case
}
//ret holds the number of bytes written
```

**関連項目**

wolfSSH_SFTP_SendReadPacket()<br>

wolfSSH_SFTP_Open()<br>


### wolfSSH_SFTP_STAT()



**用法**

**説明**

STATパケットを相手に送信します。ファイルあるいはディレクトリの属性を取得します。ファイルが存在しないかあるいは属性が存在しない場合は相手はエラーを返します。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - NULLターミネートされたファイルあるいはディレクトリ名<br>

**atr** - 属性値がこの構造体に返却されます


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_STAT(WOLFSSH* ssh , char* dir, WS_SFTP_FILEATRB* atr);
```
**使用例**

```
WOLFSSH* ssh;
byte name[NAME_SIZE];
int ret;
WS_SFTP_FILEATRB atr;

//set up ssh and do sftp connections
...

if ((ret = wolfSSH_SFTP_STAT(ssh, name, &atr)) < 0) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_LSTAT()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_LSTAT()

**用法**

**説明**

LSTATパケットを相手に送信します。ファイルあるいはディレクトリの属性値を取得します。STATパケットがシンボリックリンクをたどりませんがLSTATパケットはシンボリックリンクをたどって処理します。ファイルが存在しないかあるいは属性が存在しない場合は相手はエラーを返します。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - NULLターミネートされたファイルあるいはディレクトリ名<br>

**atr** - 属性値がこの構造体に返却されます


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_LSTAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```
**使用例**
```
WOLFSSH* ssh;
byte name[NAME_SIZE];
int ret;
WS_SFTP_FILEATRB atr;

//set up ssh and do sftp connections
...

if ((ret = wolfSSH_SFTP_LSTAT(ssh, name, &atr)) < 0) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_STAT()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTPNAME_free()

**用法**

**説明**

単一のWS_SFTPNAMEノードを解放します。指定したノードがノードリストの途中のものであった場合には、リストは壊れます。

**戻り値**

なし

**引数**

**name** - 解放されるノード




```
#include <wolfssh/wolfsftp.h>
void wolfSSH_SFTPNAME_free(WS_SFTPNAME* name );
```
**使用例**

```
WOLFSSH* ssh;
WS_SFTPNAME* name;

//set up ssh and do sftp connections
...
name = wolfSSH_SFTP_RealPath(ssh, path);
if (name != NULL) {
wolfSSH_SFTPNAME_free(name);
}
```

**関連項目**

wolfSSH_SFTPNAME_list_free()


### wolfSSH_SFTPNAME_list_free()



**用法**

**説明**

リスト中の全WS_SFTPNAMEノードを解放します。


**戻り値**

なし

**引数**

**name** - 解放するリストの先頭



```
#include <wolfssh/wolfsftp.h>
void wolfSSH_SFTPNAME_list_free(WS_SFTPNMAE* name );
```

**使用例**

```
WOLFSSH* ssh;
WS_SFTPNAME* name;

//set up ssh and do sftp connections
...

name = wolfSSH_SFTP_LS(ssh, path);
if (name != NULL) {
wolfSSH_SFTPNAME_list_free(name);
}
```

**関連項目**

wolfSSH_SFTPNAME_free()


##  Reget/Reput 機能

### wolfSSH_SFTP_SaveOfst()



**用法**

**説明**
get あるいはputコマンドが中断された場合のオフセットを保存します。オフセットはwolfSSH_SFTP_GetOfstで復元できます。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**from** - NULL終端されたソースパスを示す文字列<br>

**to** - NULL終端されたデスティネーションパスを示す文字列<br>

**ofst** - 記憶されるべきファイルのオフセット



```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SaveOfst(WOLFSSH* ssh , char* from , char*
to ,
word64 ofst );
```

**使用例**

```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_SaveOfst(ssh, from, to, ofst) !=　WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_GetOfst()<br>

wolfSSH_SFTP_Interrupt()<br>


### wolfSSH_SFTP_GetOfst()



**用法**

**説明**

get あるいはputコマンドが中断された場合のオフセットを取得します。


**戻り値**

成功時にはオフセット値を返します。オフセットが保存されていない場合には0が返されます。


**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**from** - NULL終端されたソースパスを示す文字列<br>

**to** - NULL終端されたデスティネーションパスを示す文字列<br>


```
#include <wolfssh/wolfsftp.h>
word64 wolfSSH_SFTP_GetOfst(WOLFSSH* ssh, char* from, char* to);
```

**使用例**

```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;

//set up ssh and do sftp connections
...

ofst = wolfSSH_SFTP_GetOfst(ssh, from, to);
//start reading/writing from ofst
```

**関連項目**

wolfSSH_SFTP_SaveOfst()<br>

wolfSSH_SFTP_Interrup()<br>



### wolfSSH_SFTP_ClearOfst()



**用法**

**説明**

保存されている全オフセット値をクリアします。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_ClearOfst(WOLFSSH* ssh);
```
**使用例**

**関連項目**

wolfSSH_SFTP_SaveOfst()<br>

wolfSSH_SFTP_GetOfst()<br>


### wolfSSH_SFTP_Interrupt()



**用法**

**説明**

中断フラグをセットし、get/putコマンドを停止します。


**戻り値**

なし

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
void wolfSSH_SFTP_Interrupt(WOLFSSH* ssh);
```

**使用例**

```
WOLFSSH* ssh;

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_ClearOfst(ssh) != WS_SUCCESS) {
//handle error
}
```


```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;

//set up ssh and do sftp connections
...

wolfSSH_SFTP_Interrupt(ssh);
wolfSSH_SFTP_SaveOfst(ssh, from, to, ofst);
```

**関連項目**

wolfSSH_SFTP_SaveOfst()<br>

wolfSSH_SFTP_GetOfst()<br>


##  コマンド機能



### wolfSSH_SFTP_Remove()



**用法**

**説明**

"remove"パケットをチャネルを通じて送信します。削除するファイル名"f"は相手に渡されます。

**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>
**f** - 削除したいファイル名


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Remove(WOLFSSH* ssh , char* f );
```

**使用例**

```
WOLFSSH* ssh;
int ret;
char* name[NAME_SZ];

//set up ssh and do sftp connections
...

ret = wolfSSH_SFTP_Remove(ssh, name);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_MKDIR()



**用法**

**説明**

チャネルを通して“mkdir”パケットを送信します。相手に作成するディレクトリ名が"dir"として渡されます。現時点では、属性は使用されず、既定の属性が使用されます。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

ssh – WOLFSSHオブジェクトへのポインター<br>

dir - NULL終端された作成するディレクトリ名を示す文字列<br>

atr - ディレクトリ作成に使う属性値


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_MKDIR(WOLFSSH* ssh, char* dir,　WS_SFTP_FILEATRB* atr);
```

**使用例**

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];

//set up ssh and do sftp connections
...

ret = wolfSSH_SFTP_MKDIR(ssh, dir, DIR_SZ);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>

### wolfSSH_SFTP_RMDIR()



**用法**

**説明**

“rmdir”パケットをチャネルを通じて送信します。削除するディレクトリ名は"dir"として相手に送られます。

**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - NULL終端された削除するディレクトリ名を示す文字列<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_RMDIR(WOLFSSH* ssh , char* dir );
```
**使用例**

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];

//set up ssh and do sftp connections
...

ret = wolfSSH_SFTP_RMDIR(ssh, dir);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>

### wolfSSH_SFTP_Rename()



**用法**

**説明**

“rename”パケットをチャネルを通じて送信します。相手側のファイル名を“old” から “nw”に変更しようとします。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**old** - 旧ファイル名<br>

**nw** - 新ファイル名


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Rename(WOLFSSH* ssh , const char* old ,　const char* nw);
```

**使用例**


```
WOLFSSH* ssh;
int ret;
char* old[NAME_SZ];
char* nw[NAME_SZ]; //new file name

//set up ssh and do sftp connections
...

ret = wolfSSH_SFTP_Rename(ssh, old, nw);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()


### wolfSSH_SFTP_LS()



**用法**

**説明**

LS操作（全ファイルとディレクトリのリストを取得する）を現在のワーキングディレクトリで実行します。
この関数はREALPATH, OPENDIR, READDIR と CLOSE操作を実行する高水準関数です。

**戻り値**

成功時にはWS_SFTPNAME構造体のリストを返します。失敗時にはNULLを返します。

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**dir** - リストを作成するディレクトリ名


```
#include <wolfssh/wolfsftp.h>
WS_SFTPNAME* wolfSSH_SFTP_LS(WOLFSSH* ssh , char* dir );
```



**使用例**

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];
WS_SFTPNAME* name;
WS_SFTPNAME* tmp;

//set up ssh and do sftp connections
...

name = wolfSSH_SFTP_LS(ssh, dir);
tmp = name;
while (tmp != NULL) {
printf("%s\n", tmp->fName);
tmp = tmp->next;
}
wolfSSH_SFTPNAME_list_free(name);
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>

wolfSSH_SFTPNAME_list_free()<br>


### wolfSSH_SFTP_Get()



**用法**

**説明**

相手からファイルを取得するget操作を実行し、ローカルディレクトリに配置します。この関数は高水準関数であり、LSTAT, OPEN, READ, とCLOSEを実行します。関数の実行を中断したい場合には、wolfSSH_SFTP_Interruptを呼び出すことができます。


**戻り値**

**WS_SUCCESS** - 成功
その他の値はすべてエラーとみなすべきです。

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**from** - 取得するファイルの名前<br>

**to** - 配置する際のファイルの名前<br>

**resume** - 操作を再開するか（1は再開する、0はしない）<br>

**statusCb** - ステータスを取得するコールバック関数



```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Get(WOLFSSH* ssh , char* from , char* to ,　byte resume ,　WS_STATUS_CB* statusCb );
```

**使用例**

```
static void myStatusCb(WOLFSSH* sshIn, long bytes, char* name)
{
char buf[80];
WSNPRINTF(buf, sizeof(buf), "Processed %8ld\t bytes
\r", bytes);
WFPUTS(buf, fout);
(void)name;
(void)sshIn;
}
...
WOLFSSH* ssh;
char* from[NAME_SZ];
char* to[NAME_SZ];

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_Get( ssh , from , to , 0 , & myStatusCb ) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>


### wolfSSH_SFTP_Put()



**用法**

**説明**

ローカルのファイルを相手のディレクトリに配置するput操作を実行します。この関数は高水準関数であり、OPEN, WRITE, と CLOSE操作を実行します。操作を中断する場合にはwolfSSH_SFTP_Interruptを呼び出してください。


**戻り値**

**WS_SUCCESS** - 成功<br>

その他の値はすべてエラーとみなすべきです。

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>

**from** - 配置したい対象ファイルの名前<br>

**to** - 配置先でのファイルの名前<br>

**resume** - 操作を再開するかのフラグ(1は再開、0は再開しない）<br>

**statusCb** - ステータスを取得するコールバック関数


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Put(WOLFSSH* ssh, char* from, char* to, byte resume, WS_STATUS_CB* statusCb);
```
**使用例**

```
static void myStatusCb(WOLFSSH* sshIn, long bytes, char* name)
{
char buf[80];
WSNPRINTF(buf, sizeof(buf), "Processed %8ld\t bytes
\r", bytes);
WFPUTS(buf, fout);
(void)name;
(void)sshIn;
}
...

WOLFSSH* ssh;
char* from[NAME_SZ];
char* to[NAME_SZ];

//set up ssh and do sftp connections
...

if (wolfSSH_SFTP_Put(ssh, from, to, 0, &myStatusCb) !=
WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>


##  SFTPサーバー機能



### wolfSSH_SFTP_read()



**用法**

**説明**

メインのSFTPサーバー機能を提供する関数です。到着するパケットを処理し、I/O　バッファからデータを読み出しSFTPパケットのタイプに応じて内部の関数を呼び出します。


**戻り値**

**WS_SUCCESS** - 成功

**引数**

**ssh** – WOLFSSHオブジェクトへのポインター<br>


```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_read(WOLFSSH* ssh );
```


**使用例**

```
WOLFSSH* ssh;

//set up ssh and do sftp connections
...
if (wolfSSH_SFTP_read(ssh) != WS_SUCCESS) {
//handle error case
}
```

**関連項目**

wolfSSH_SFTP_accept()<br>

wolfSSH_SFTP_connect()<br>
