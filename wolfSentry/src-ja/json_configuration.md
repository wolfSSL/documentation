# JSONドキュメントを使用したwolfSentryの設定

wolfSentryのほとんどの機能は、ライブラリにJSONドキュメントを提供することで設定、および動的に再設定することができます。
この機能を使用するには、アプリケーションのwolfSentry初期化に以下を追加してください。

```
#include <wolfsentry/wolfsentry_json.h>
```

初期化とアプリケーション提供のコールバック（ある場合）のインストール後、設定を読み込むために以下のAPIのうち1つを呼び出す必要があります。

* `wolfsentry_config_json_oneshot()`
* `wolfsentry_config_json_oneshot_ex()`、JSON解析の細かい制御のための追加の`json_config`引数付き（`wolfsentry/centijson_sax.h`の`struct JSON_CONFIG`を参照）
* ストリーミングAPI：
   * `wolfsentry_config_json_init()` または `wolfsentry_config_json_init_ex()`
   * `wolfsentry_config_json_feed()`
   * `wolfsentry_config_json_fini()`

引数の詳細については、`wolfsentry/wolfsentry_json.h`をご参照ください。


## JSON基本事項

wolfSentryの設定には、[RFC 8259](https://tex2e.github.io/rfc-translater/html/rfc8259.html)で定義された標準JSON構文を使用します。
ただし[RFC 7493](https://tex2e.github.io/rfc-translater/html/rfc7493.html)による制限を受け、さらに以下に示す追加の要件があります。
特にJSONドキュメント内の特定のセクションは、出現順序が制限されています。

* `"wolfsentry-config-version"`は最初に現れ、各イベント定義は、`"aux-parent-event"`、`"parent-event"`、`"default-event"`句を通じてそれを参照するイベント、ルート、デフォルトポリシーの定義より前に現れる必要があります。

* イベント定義内では、`"label"`、`"priority"`、および`"config"`要素は他のすべての要素より前に現れる必要があります。

これらの順序制約は、設定の高効率SAXスタイル（逐次増分）読み込みを可能にするために必要です。

すべてのワイルドカードフラグはルート上で暗黙的に設定され、設定内で明示的な割り当てがあるフィールドに対してはクリアされます。
例えば、ルートが特定の`"family"`を指定する場合、`WOLFSENTRY_ROUTE_FLAG_SA_FAMILY_WILDCARD`は暗黙的にクリアされます。
したがって、ルート定義内でワイルドカードフラグを明示的に設定またはクリアする必要はありません。

特定の要素バリアントは、ビルド設定により利用できない場合があることに注意してください。

* `address_family_name`: `defined(WOLFSENTRY_PROTOCOL_NAMES)`の場合に利用可能
* `route_protocol_name`: `!defined(WOLFSENTRY_NO_GETPROTOBY)`の場合に利用可能
* `address_port_name`: `!defined(WOLFSENTRY_NO_GETPROTOBY)`の場合に利用可能
* `json_value_clause`: `defined(WOLFSENTRY_HAVE_JSON_DOM)`の場合に利用可能

呼び出し側が提供するイベントおよびアクションラベルは、`WOLFSENTRY_BUILTIN_LABEL_PREFIX`（デフォルトでは`"%"`）で始まってはいけません。
これらが組み込み用に予約されているためです。

`"config-update"`により、デフォルト設定を更新することができます。
wolfSentryは最初に`wolfsentry_init()`の`config`引数によって設定されるため（これは`NULL`で渡すことができ、組み込みデフォルトを意味します）、これは「更新」と呼ばれます。
時間（`wolfsentry_eventconfig.penaltybox_duration`と`wolfsentry_eventconfig.route_idle_time_for_purge`）は、メンバーの`wolfsentry_time_t`型に関係なく、秒単位で`wolfsentry_init()`に渡される必要があることに注意してください。

## JSON読み込みフラグ

`wolfsentry_config_json_init()`と`wolfsentry_config_json_oneshot()`への`flags`引数は、ビット単位ORで構築され、以下のようにJSONの処理方法を変更します。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_NONE` -- フラグではなく、すべてゼロで、デフォルト動作を意味します。
	wolfSentryコアはロックされ、現在の設定はフラッシュされ、新しい設定が増分的に読み込まれます。
	読み込み中のエラーは、wolfSentryを未定義状態に残し、その後のフラッシュと成功する読み込みで回復できます。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_NO_FLUSH` -- 設定の初期フラッシュを抑制し、増分読み込みを可能にします。
	読み込み中のエラーは、wolfSentryを未定義状態に残し、`WOLFSENTRY_CONFIG_LOAD_FLAG_DRY_RUN`または`WOLFSENTRY_CONFIG_LOAD_FLAG_LOAD_THEN_COMMIT`も提供されていない限り、その後のフラッシュと成功する読み込みでのみ回復できます。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_DRY_RUN` -- 一時設定に読み込み、戻る前に割り当て解除します。
	実行中の設定は変更されません。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_LOAD_THEN_COMMIT` -- 新しく割り当てられた設定に読み込み、読み込みが正常に完了した場合にのみインストールします。
	エラー時、実行中の設定は変更されません。
	成功時、古い設定は割り当て解除されます。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_NO_ROUTES_OR_EVENTS` -- 提供されたJSON内の`"routes"`および`"events"`セクションの読み込みを抑制します。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_FLUSH_ONLY_ROUTES` -- 読み込みプロセスの開始時、ルートを除くすべての現在の設定を保持し、ルートはフラッシュされます。
	これは、動的に追加されたルートの保存/復元のために`wolfsentry_route_table_dump_json_*()`と組み合わせて使用すると便利です。

* `WOLFSENTRY_CONFIG_LOAD_FLAG_JSON_DOM_DUPKEY_ABORT` -- ユーザー定義JSON値の処理時、重複キーで読み込みを中断します。
* `WOLFSENTRY_CONFIG_LOAD_FLAG_JSON_DOM_DUPKEY_USEFIRST` -- ユーザー定義JSON値の処理時、オブジェクト内の任意のキーについて、最初に遭遇した出現を使用します。
* `WOLFSENTRY_CONFIG_LOAD_FLAG_JSON_DOM_DUPKEY_USELAST` -- ユーザー定義JSON値の処理時、オブジェクト内の任意のキーについて、最後に遭遇した出現を使用します。
* `WOLFSENTRY_CONFIG_LOAD_FLAG_JSON_DOM_MAINTAINDICTORDER` -- ユーザー定義JSON値の処理時、順序情報を保存し、その後の`wolfsentry_kv_render_value()`または`json_dom_dump(..., JSON_DOM_DUMP_PREFERDICTORDER)`への呼び出しが、辞書的にソートされるのではなく、提供された順序でオブジェクトをレンダリングするようにします。

`WOLFSENTRY_CONFIG_LOAD_FLAG_JSON_DOM_*`フラグはデフォルト設定の場合のように、ビルドで`WOLFSENTRY_HAVE_JSON_DOM`が定義されている場合にのみ許可されることにご注意ください。

## JSON構文の概要

以下は、利用可能なすべての設定ノードを示すJSON「lint」疑似ドキュメントです。
この後に示すABNF定義を参照する値指定子を含んでいます。
許可される値についても後に示しています。

```
{
    "wolfsentry-config-version" : 1,
    "config-update" : {
        "max-connection-count" : uint32,
        "penalty-box-duration" : duration,
        "route-idle-time-for-purge" : duration,
        "derog-thresh-for-penalty-boxing" : uint16,
        "derog-thresh-ignore-commendable" : boolean,
        "commendable-clears-derogatory" : boolean,
        "route-flags-to-add-on-insert" : route_flag_list,
        "route-flags-to-clear-on-insert" : route_flag_list,
        "action-res-filter-bits-set" : action_res_flag_list,
        "action-res-filter-bits-unset" : action_res_flag_list,
        "action-res-bits-to-add" : action_res_flag_list,
        "action-res-bits-to-clear" : action_res_flag_list,
        "max-purgeable-routes" : uint32,
        "max-purgeable-idle-time" : duration
    },
    "events" : [
       { "label" : label,
         "priority" : uint16,
         "config" : {
            "max-connection-count" : uint32,
            "penalty-box-duration" : duration,
            "route-idle-time-for-purge" : duration,
            "derog-thresh-for-penalty-boxing" : uint16,
            "derog-thresh-ignore-commendable" : boolean,
            "commendable-clears-derogatory" : boolean,
            "route-flags-to-add-on-insert" : route_flag_list,
            "route-flags-to-clear-on-insert" : route_flag_list,
            "action-res-filter-bits-set" : action_res_flag_list,
            "action-res-filter-bits-unset" : action_res_flag_list,
            "action-res-bits-to-add" : action_res_flag_list,
            "action-res-bits-to-clear" : action_res_flag_list
         },
         "aux-parent-event"  : label,
         "post-actions" : action_list,
         "insert-actions" : action_list,
         "match-actions" : action_list,
         "update-actions" : action_list,
         "delete-actions" : action_list,
         "decision-actions" : action_list
      }
    ],
    "default-policies" : {
        "default-policy" : default_policy_value,
        "default-event" ":" label
    },
    "routes" : [
      {
        "parent-event" : label,
        "af-wild" : boolean,
        "raddr-wild" : boolean,
        "rport-wild" : boolean,
        "laddr-wild" : boolean,
        "lport-wild" : boolean,
        "riface-wild" : boolean,
        "liface-wild" : boolean,
        "tcplike-port-numbers" : boolean,
        "direction-in" : boolean,
        "direction-out" : boolean,
        "penalty-boxed" : boolean,
        "green-listed" : boolean,
        "dont-count-hits" : boolean,
        "dont-count-current-connections" : boolean,
        "port-reset" : boolean,

        "family" : address_family,
        "protocol" : route_protocol,
        "remote" : {
          "interface" : uint8,
          "address" : route_address,
          "prefix-bits" : uint16,
          "bitmask" : route_address,
          "port" : endpoint_port
        },
        "local" : {
          "interface" : uint8,
          "address" : route_address,
          "prefix-bits" : uint16,
          "bitmask" : route_address,
          "port" : endpoint_port
        }
      }
    ],
    "user-values" : {
      label : null,
      label : true,
      label : false,
      label : number_sint64,
      label : number_float,
      label : string,
      label : { "uint" : number_uint64 },
      label : { "sint" : number_sint64 },
      label : { "float" : number_float },
      label : { "string" : string_value },
      label : { "base64" : base64_value },
      label : { "json" : json_value }
    }
}
```

## 要素の概要

<b>`wolfsentry-config-version`</b> -- 最初に現れ、値は `1` でなければならない。

<b>`config-update`</b> -- デフォルトおよびグローバルパラメータを設定する。
	デフォルトパラメータは、親イベントを持たないルート、独自の設定を持たない親イベントを持つルートに適用される。

* <b>`max-connection-count`</b> -- ゼロ以外の場合、同時接続制限で、これを超える追加の接続要求は拒否される。

* <b>`penalty-box-duration`</b> -- ゼロ以外の場合、ルートが自動解除される前にペナルティボックス状態に留まる期間。

* <b>`derog-thresh-for-penalty-boxing`</b> -- ゼロ以外の場合、累積された否定的カウント（`WOLFSENTRY_ACTION_RES_DEROGATORY` インシデントから）がルートを自動的にペナルティボックス化する閾値。

* <b>`derog-thresh-ignore-commendable`</b> -- trueの場合、自動ペナルティボックス化をチェックする際に、`WOLFSENTRY_ACTION_RES_COMMENDABLE` からのカウントは否定的カウントから減算されない。

* <b>`commendable-clears-derogatory`</b> -- trueの場合、`WOLFSENTRY_ACTION_RES_COMMENDABLE` からの各カウントは否定的カウントをゼロにする。

* <b>`max-purgeable-routes`</b> -- ルートテーブルで許可する短命ルートの数のグローバル制限で、これを超えると最も最近にマッチしていない短命ルートが早期に強制削除される。
	イベントの <b>`config`</b> 句では許可されない。

* <b>`max-purgeable-idle-time`</b> -- 短命ルートのグローバル絶対最大アイドル時間で、ゼロ以外の `wolfsentry_route_metadata_exports.connection_count` を持つ古い（期限切れ）短命ルートのパージを制御する。
	デフォルトは制限なし。
	イベントの <b>`config`</b> 句では許可されない。

* <b>`route-idle-time-for-purge`</b> -- ゼロ以外の場合、ルートの最新のディスパッチマッチ後にガベージコレクションされるまでの時間。
	主にイベントの <b>`config`</b> 句で有用（下記の <b>`events`</b> を参照）。

* <b>`route-flags-to-add-on-insert`</b> -- 挿入時に新しいルートに設定するルートフラグのリスト。
	主にイベントの <b>`config`</b> 句で有用（下記の <b>`events`</b> を参照）。

* <b>`route-flags-to-clear-on-insert`</b> -- 挿入時に新しいルートでクリアするルートフラグのリスト。
	主にイベントの <b>`config`</b> 句で有用（下記の <b>`events`</b> を参照）。

* <b>`action-res-filter-bits-set`</b> -- 参照ルートがマッチするためにルックアップ時（ディスパッチ）に設定されている必要がある `action_res` フラグのリスト。
	主にイベントの <b>`config`</b> 句で有用（下記の <b>`events`</b> を参照）。

* <b>`action-res-filter-bits-unset`</b> -- 参照ルートがマッチするためにルックアップ時（ディスパッチ）にクリアされている必要がある `action_res` フラグのリスト。
	主にイベントの <b>`config`</b> 句で有用（下記の <b>`events`</b> を参照）。

* <b>`action-res-bits-to-add`</b> -- マッチ時に設定される `action_res` フラグのリスト。

* <b>`action-res-bits-to-clear`</b> -- マッチ時にクリアされる `action_res` フラグのリスト。


<b>`events`</b> -- それぞれの定義を持つイベントのリスト。
	このセクションは複数回現れることができるが、任意の特定のイベント定義は、それを参照する定義よりも前に現れなければならない。

各イベントは以下の要素で構成され、<b>`label`</b> を除いてすべてオプションである。
<b>`label`</b>、<b>`priority`</b>、<b>`config`</b> は他の要素より前に現れなければならない。

* <b>`label`</b> -- イベントが識別される名前。
	許可される値については、下記のABNF文法の `label` の定義を参照。

* <b>`priority`</b> -- このイベントを <b>`parent-event`</b> として持つルートの優先度（下記の <b>`routes`</b> を参照）。
	数値が低いほど優先度が高い。

* <b>`config`</b> -- この <b>`parent-event`</b> を持つルートに関連付ける設定。
	上記の <b>`config-update`</b> と同様。

* <b>`aux-parent-event`</b> -- アクションハンドラーが使用するイベント参照、例えば組み込みの `"%track-peer-v1"` は <b>`aux-parent-event`</b> を新しいルートの <b>`parent-event`</b> としてルートを作成する。

* <b>`post-actions`</b> -- このイベントが <b>`event_label`</b> を介して `wolfsentry_route_event_dispatch()` などのディスパッチルーチンに渡されたときに実行するアクションのリスト。

* <b>`insert-actions`</b> -- このイベントを <b>`parent-event`</b> としてルートが挿入されたときに実行するアクションのリスト。

* <b>`match-actions`</b> -- ルートがディスパッチルーチンによってマッチし、そのルートがこのイベントを <b>`parent-event`</b> として持つときに実行するアクションのリスト。

* <b>`update-actions`</b> -- ルートがペナルティボックス状態の変更などのステータス更新を持ち、このイベントを <b>`parent-event`</b> として持つときに実行するアクションのリスト。

* <b>`delete-actions`</b> -- ルートが削除され、このイベントを <b>`parent-event`</b> として持つときに実行するアクションのリスト。

* <b>`decision-actions`</b> -- ディスパッチ最終決定（<b>`action_results`</b> の最終値）が決定され、マッチしたルートがこのイベントを <b>`parent-event`</b> として持つときに実行するアクションのリスト。

<b>`default-policies`</b> -- `wolfsentry_route_event_dispatch()` などの、ディスパッチルーチンのグローバルフォールスルーデフォルトポリシー。

* <b>`default-policy`</b> -- デフォルトで設定する単純な <b>`action_result`</b> フラグ、**accept**、**reject**、**reset** のいずれか。
	`reset`は関連する場合にTCPリセットとICMP到達不能応答パケットの生成を引き起こす。

* <b>`default-event`</b> -- ディスパッチルーチンがnull <b>`event_label`</b> で呼び出されたときに使用するイベント。

<b>`routes`</b> -- それぞれの定義を持つルートのリスト。
	このセクションは複数回現れることができる。

各ルートは以下の要素で構成され、すべてオプションである。

* <b>`parent-event`</b> -- ルートのダイナミクスを決定する属性を持つイベント。

* <b>`family`</b> -- マッチするアドレスファミリ。
	許可される値については、下記のABNF文法の `address_family` の定義を参照。

* <b>`protocol`</b> -- マッチするプロトコル。
	許可される値については、下記のABNF文法の `route_protocol` の定義を参照。

* <b>`remote`</b> -- トラフィックのリモートエンドポイントでマッチする属性。
   * <b>`interface`</b> -- 呼び出し元またはIPスタック統合によって選択され一貫して使用される任意の整数としてのネットワークインターフェースID。
   * <b>`address`</b> -- 慣用的な形式のネットワークアドレス。
   		IPv4、IPv6、およびMACアドレスはすべてのオクテットを列挙しなければならない。
   		許可される値については、下記のABNF文法の `route_address` の定義を参照。
   * <b>`prefix-bits`</b> -- トラフィックがマッチしなければならない <b>`address`</b> のビット数（<b>`bitmask`</b> と相互排他的）。
   * <b>`bitmask`</b> -- ルート <b>`address`</b> とマッチする前にトラフィックアドレスに適用されるビットマスク（<b>`prefix-bits`</b> と相互排他的）。
   * <b>`port`</b> -- トラフィックがマッチしなければならないポート番号。

* <b>`local`</b> -- トラフィックのローカルエンドポイントでマッチする属性。
	<b>`remote`</b> と同じノードが利用可能。
* <b>`direction-in`</b> -- trueの場合、インバウンドトラフィックをマッチ。
* <b>`direction-out`</b> -- trueの場合、アウトバウンドトラフィックをマッチ。
* <b>`penalty-boxed`</b> -- trueの場合、ルートにマッチするトラフィックはペナルティボックス化される（拒否またはリセット）。
* <b>`green-listed`</b> -- trueの場合、ルートにマッチするトラフィックは受け入れられる。
* <b>`dont-count-hits`</b> -- trueの場合、統計的記録管理を抑制する（ダイナミクスには影響しない）。
* <b>`dont-count-current-connections`</b> -- trueの場合、同時接続の追跡を抑制し、<b>`max-connection-count`</b> がこのルートにマッチするトラフィックに影響しないようにする。
* <b>`port-reset`</b> -- trueの場合、このルートがマッチしたときに <b>`action_results`</b> で `WOLFSENTRY_ACTION_RES_PORT_RESET` フラグを設定し、IPスタック統合が有効化されている場合（例：`wolfsentry_install_lwip_filter_callbacks()`）にTCPリセットまたはICMP到達不能応答パケットを生成させる。

<b>`user-values`</b> -- 任意の使用のためにアプリケーションコードで利用可能な完全にユーザー定義のデータの1つ以上のセクション。
	各キーは下記のABNF文法で定義されるラベルである。
	値は以下のいずれかになる。

* <b>`null`</b>
* <b>`true`</b>
* <b>`false`</b>
* 整数値、暗黙的に符号付き64ビット整数
* 浮動小数点数、下記のABNF文法の `number_float` で定義される
* 標準のJSONエスケープを許可する引用符付き文字列
* 下記のABNF文法で値が定義される、いくつかの明示的に型付けされた構造のいずれか
	* `{ "uint" : number_uint64 }`
	* `{ "sint" : number_sint64 }`
	* `{ "float" : number_float }`
	* `{ "string" : string_value }`
	* `{ "base64" : base64_value }`
	* `{ "json" : json_value }`


## 形式的ABNF文法

以下は設定構文と許可される値の形式的ABNF定義です。

この定義は、[RFC 5234](https://tex2e.github.io/rfc-translater/html/rfc5234)および[RFC 7405](https://tex2e.github.io/rfc-translater/html/rfc7405)で規定されるABNF構文を使用します。
しかし、以下の例外があります。

* [RFC 8259](https://tex2e.github.io/rfc-translater/html/rfc8259.html)で提供されるように、空白は無視されます。

* `-` 演算子が追加され、引用符付きリテラル文字列またはリテラル文字のグループを受け入れ、対象テキストから省略された文字（ここでは、末尾のコンマ区切り文字）を提供し、演算子の引数で概念的に拡張された対象テキストでその時点まで含有グループのすべての概念的マッチング操作を実行します。

定義で使用される長さ制限は、wolfsentry_settings.h のデフォルト値を想定し、ラベルに32オクテット（`WOLFSENTRY_MAX_LABEL_BYTES`）、ユーザー定義値に16384オクテット（`WOLFSENTRY_KV_MAX_VALUE_BYTES`）です。
これらの値は、ビルド時にユーザー提供の値でオーバーライドできます。

```
"{"
    DQUOTE %s"wolfsentry-config-version" DQUOTE ":" uint32
    [ "," DQUOTE %s"config-update" DQUOTE ":" top_config_list "," ]
    *("," DQUOTE %s"events" ":" "["
       event *("," event)
    "]")
    [ "," DQUOTE %s"default-policies" DQUOTE ":" "{"
        default_policy_item *("," default_policy_item)
    "}" ]
    *("," DQUOTE %s"routes" DQUOTE ":" "["
        route *("," route)
    "]")
    *("," DQUOTE %s"user-values" DQUOTE ":" "{"
        user_item *("," user_item)
    "}")
"}"

event = "{" label_clause
        [ "," priority_clause ]
        [ "," event_config_clause ]
        [ "," aux_parent_event_clause ]
        *("," action_list_clause) "}"

default_policy_item =
        (DQUOTE %s"default-policy" DQUOTE ":" default_policy_value) /
        (DQUOTE %s"default-event" DQUOTE ":" label)

default_policy_value = (%s"accept" / %s"reject" / %s"reset")

label_clause = DQUOTE %s"label" DQUOTE ":" label

priority_clause = DQUOTE %s"priority" DQUOTE ":" uint16

event_config_clause = DQUOTE %s"config" DQUOTE ":" event_config_list

aux_parent_event_clause = DQUOTE %s"aux-parent-event" DQUOTE ":" label

action_list_clause = DQUOTE (%s"post-actions" / %s"insert-actions" / %s"match-actions"
            / %s"update-actions" / %s"delete-actions" / %s"decision-actions") DQUOTE
            ":" action_list

action_list = "[" label *("," label) "]"

event_config_list = "{" event_config_item *("," event_config_item) "}"

top_config_list = "{" top_config_item *("," top_config_item) "}"

top_config_item = event_config_item / max_purgeable_routes_clause / max_purgeable_idle_time_clause

event_config_item =
  (DQUOTE %s"max-connection-count" DQUOTE ":" uint32) /
  (DQUOTE %s"penalty-box-duration" DQUOTE ":" duration) /
  (DQUOTE %s"route-idle-time-for-purge" DQUOTE ":" duration) /
  (DQUOTE %s"derog-thresh-for-penalty-boxing" DQUOTE ":" uint16 /
  (DQUOTE %s"derog-thresh-ignore-commendable" DQUOTE ":" boolean /
  (DQUOTE %s"commendable-clears-derogatory" DQUOTE ":" boolean /
  (DQUOTE (%s"route-flags-to-add-on-insert" / %s"route-flags-to-clear-on-insert") DQUOTE ":" route_flag_list) /
  (DQUOTE (%s"action-res-filter-bits-set" / %s"action-res-filter-bits-unset" / %s"action-res-bits-to-add" / %s"action-res-bits-to-clear") DQUOTE ":" action_res_flag_list)

duration = number_sint64 / (DQUOTE number_sint64 [ %s"d" / %s"h" / %s"m" / %s"s" ] DQUOTE)

max_purgeable_routes_clause = DQUOTE %s"max-purgeable-routes" DQUOTE ":" uint32

max_purgeable_idle_time_clause = DQUOTE %s"max-purgeable-idle-time" DQUOTE ":" duration

route_flag_list = "[" route_flag *("," route_flag) "]"

action_res_flag_list = "[" action_res_flag *("," action_res_flag) "]"

route = "{"
    [ parent_event_clause "," ]
    *(route_flag_clause ",")
    [ family_clause ","
      [ route_protocol_clause "," ]
    ]
    [ route_remote_endpoint_clause "," ]
    [ route_local_endpoint_clause "," ]
    -","
"}"

parent_event_clause = DQUOTE %s"parent-event" DQUOTE ":" label
route_flag_clause = route_flag ":" boolean
family_clause = DQUOTE %s"family" DQUOTE ":" address_family
route_protocol_clause = DQUOTE %s"protocol" DQUOTE ":" route_protocol

route_remote_endpoint_clause = DQUOTE %s"remote" DQUOTE ":" route_endpoint
route_local_endpoint_clause = DQUOTE %s"local" DQUOTE ":" route_endpoint

route_endpoint = "{"
    [ route_interface_clause "," ]
    [ route_address_clause ","
      [ (route_address_prefix_bits_clause / route_address_bitmask_clause) "," ]
    ]
    [ route_port_clause "," ]
    -","
"}"

route_interface_clause = DQUOTE %s"interface" DQUOTE ":" uint8

route_address_clause = DQUOTE %s"address" DQUOTE ":" route_address

route_address_bitmask_clause = DQUOTE %s"bitmask" DQUOTE ":" route_address

route_address = DQUOTE (route_address_ipv4 / route_address_ipv6 / route_address_mac / route_address_user) DQUOTE

route_address_ipv4 = uint8 3*3("." uint8)

route_address_ipv6 = < IPv6address from RFC 5954 section 4.1 >

route_address_mac = 1*2HEXDIG ( 5*5(":" 1*2HEXDIG) / 7*7(":" 1*2HEXDIG) )

route_address_user = < an address in a form recognized by a parser
                       installed with `wolfsentry_addr_family_handler_install()`
                     >

address_family = uint16 / address_family_name

address_family_name = DQUOTE ( "inet" / "inet6" / "link" / < a value recognized by wolfsentry_addr_family_pton() > ) DQUOTE

route_address_prefix_bits_clause = DQUOTE %s"prefix-bits" DQUOTE ":" uint16

route_protocol = uint16 / route_protocol_name

route_protocol_name = DQUOTE < a value recognized by getprotobyname_r(), requiring address family inet or inet6 >

route_port_clause = DQUOTE %s"port" DQUOTE ":" endpoint_port

endpoint_port = uint16 / endpoint_port_name

endpoint_port_name = DQUOTE < a value recognized by getservbyname_r() for the previously designated protocol > DQUOTE

route_flag = DQUOTE (
  %s"af-wild" /
  %s"raddr-wild" /
  %s"rport-wild" /
  %s"laddr-wild" /
  %s"lport-wild" /
  %s"riface-wild" /
  %s"liface-wild" /
  %s"tcplike-port-numbers" /
  %s"direction-in" /
  %s"direction-out" /
  %s"penalty-boxed" /
  %s"green-listed" /
  %s"dont-count-hits" /
  %s"dont-count-current-connections" /
  %s"port-reset"
) DQUOTE

action_res_flag = DQUOTE (
  %s"none" /
  %s"accept" /
  %s"reject" /
  %s"connect" /
  %s"disconnect" /
  %s"derogatory" /
  %s"commendable" /
  %s"stop" /
  %s"deallocated" /
  %s"inserted" /
  %s"error" /
  %s"fallthrough" /
  %s"update" /
  %s"port-reset" /
  %s"sending" /
  %s"received" /
  %s"binding" /
  %s"listening" /
  %s"stopped-listening" /
  %s"connecting-out" /
  %s"closed" /
  %s"unreachable" /
  %s"sock-error" /
  %s"user+0" /
  %s"user+1" /
  %s"user+2" /
  %s"user+3" /
  %s"user+4" /
  %s"user+5" /
  %s"user+6" /
  %s"user+7"
) DQUOTE

user_item = label ":" ( null / true / false / number_sint64_decimal / number_float / string / strongly_typed_user_item )

strongly_typed_user_item =
  ( "{" DQUOTE %s"uint" DQUOTE ":" number_uint64 "}" ) /
  ( "{" DQUOTE %s"sint" DQUOTE ":" number_sint64 "}" ) /
  ( "{" DQUOTE %s"float" DQUOTE ":" number_float "}" ) /
  ( "{" DQUOTE %s"string" DQUOTE ":" string_value "}" ) /
  ( "{" DQUOTE %s"base64" DQUOTE ":" base64_value "}" ) /
  json_value_clause

json_value_clause = "{" DQUOTE %s"json" DQUOTE ":" json_value "}"

null = %s"null"

true = %s"true"

false = %s"false"

boolean = true / false

number_uint64 = < decimal number in the range 0...18446744073709551615 > /
                ( DQUOTE < hexadecimal number in the range 0x0...0xffffffffffffffff > DQUOTE ) /
                ( DQUOTE < octal number in the range 00...01777777777777777777777 > DQUOTE )

number_sint64_decimal = < decimal number in the range -9223372036854775808...9223372036854775807 >

number_sint64 = number_sint64_decimal /
                ( DQUOTE < hexadecimal number in the range -0x8000000000000000...0x7fffffffffffffff > DQUOTE ) /
                ( DQUOTE < octal number in the range -01000000000000000000000...0777777777777777777777 > DQUOTE )

number_float = < floating point value in a form and range recognized by the linked strtod() implementation >

string_value = DQUOTE < any RFC 8259 JSON-valid string that decodes to at most 16384 octets > DQUOTE

base64_value = DQUOTE < any valid RFC 4648 base64 encoding that decodes to at most 16384 octets > DQUOTE

json_value = < any valid, complete and balanced RFC 8259 JSON expression, with
               keys limited to WOLFSENTRY_MAX_LABEL_BYTES (default 32 bytes),
               overall input length limited to WOLFSENTRY_JSON_VALUE_MAX_BYTES
               if set (default unset), and overall depth limited to
               WOLFSENTRY_MAX_JSON_NESTING (default 16) including the 4 parent
               levels
             >

label = DQUOTE < any RFC 8259 JSON-valid string that decodes to at at least 1 and at most 32 octets > DQUOTE

uint32 = < decimal integral number in the range 0...4294967295 >

uint16 = < decimal integral number in the range 0...65535 >

uint8 = < decimal integral number in the range 0...255 >
```
