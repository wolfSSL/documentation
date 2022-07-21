# wolfSentry JSON[^3] Setting File

wolfSentry uses JSON format as its configuration.

The following table lists the possible value of top configuration:

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `wolfsentry-config-version` | number | wolfSentry JSON format version |
| `config-update` | object | Default Configuration Object|
| `event-insert` | object | Objet for named event type |
| `static-routes-insert` | object | Object for named static-route type |
| `user-values` | object | User-value Object |


The following table lists the possible value of `config-update` object :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `max-connection-count` | number | The value is the max number of simultaneous connections that are allowed at a time for a given peer. |
| `penaltybox-duration` | number\|string | The value tells wolfSentry how long a peer should be blocked |


The following table lists the possible value of `event-insert` object :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `label` | string | event name |
| `priority` | number | event priority |
| `config` | object | event configuration |
| `actions` | string array | list of callback function name to be combined to event |
| `insert-event` | string | An event  name. That value tells wolfSentry to call the specified event when  a route is added to the route table for `label` event. |
| `match-event` | string | An event  name. That value tells wolfSentry to call the specified event by wolfsentry_route_dispatch() for a route match |
| `delete-event` | string | An event name. That value tells wolfSentry to call the specified event when a route associated with this `label` event expires or is otherwise deleted |
| `decision-event`| string | An event name. That value tells wolfSentry to call the specified event after final decision has been made by wolfsentry_route_event_dispatch() |


The following table lists the possible value of `config` object of `event-insert` object :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `max-connection-count` | number | The value is the max number of simultaneous connections that are allowed at a time for a given peer |
| `penaltybox-duration` | number\|string | The value tells wolfSentry how long a peer should be blocked. |

The following table lists the possible value of `static-routes-insert` object :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `parent-event` | string | A parent event name. The event should be defined event in `event-insert` object. |
| `direction-in` | true\|false | `true` means in-coming trafic. |
| `direction-out` | true\|false | `true` means out-going trafic. |
| `penalty-boxed` | true\|false | if true, matching connection is blocked. |
| `green-list` | true\|false | if true, matching connetion is allowed.|
| `dont-count-hits` | true\|fase | if true, wolfSentry just skip incrementing the hit count for the rule. |
| `dont-count-current-connetion` | true\|false | if true, wolfSentry disables `max-connection-count` logic. |
| `family` | string\|number | address familiy. The possible value of the name can be found from [the table](#reference-of-address-family-table) |
| | | The Numerical value corresponding to the name can be retrived by  wolfsentry_addr_family_pton() |
| `protocol`| string\|number | The value is protocol name or protocol number which expects to be storea in /etc/protocols |
| `remote` | object | peer interface attributes |
| `local` | object | local interface attributes |


The following table lists the possible value of `remote` of `static-routes-insert` :

| `value` | type | Description  |
| --------| -----|------------- |
| `port` | string\|number | Port number |
| `address` | string | Ip address |
| `prefix-bits` | number | The value determines the size of the subnet and is the number of 1 bits in the netmask.|
| `interface` | number | The value is able to be used to label traffic differently depending on which physical interface the traffic is coming from or going to. Default value is zero. |

The following table lists the possible value of `remote` of `static-routes-insert` :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `port` | string\|number | Port number |
| `address` | string | Ip address |
| `prefix-bits` | number | The value determines the size of the subnet and is the number of 1 bits in the netmask.|
| `interface` | number | The value is able to be used to label traffic differently depending on which physical interface the traffic is coming from or going to. Default value is zero. |

The following table lists the possible value of `user-values` :

| `value` | type | Description |
| --------| -----|----------------------------------- |
| `user-null` | null | The value is able to be stored by wolfsentry_user_value_store_null().|
| `user-bool` | true\|false | The value is able to be gotten or stored by wolfsentry_user_value_get/store_string() |
| `user-bool2` | true\|false | The value is able to be gotten or stored by wolfsentry_user_value_get/store_bool() |
| `user-uint`  | number | The value is able to be gotten or stored by wolfsentry_user_value_get/store_uint() |
| `user-sint`  | number | The value is able to be gotten or stored by wolfsentry_user_value_get/store_sint()) |
| `user-float` | number | The value is able to be gotten or stored by wolfsentry_user_value_get_float() or wolfsentry_user_value_store_double() |
| `user-string` |  string | The value is able to be gotten or stored by wolfsentry_user_value_get/store_string() |

[^3]: [Introducing JSON](https://www.json.org/json-en.html)
JSON (JavaScritp Object Notation) is a lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse ange generate.

JSON is built on two structures:
 * A collection of name/value pairs. In various languages, this is realized as an object, record, struct, dictionary, hash table, keyed list, or associateive array.
   An ordered list of values. In most languages, this is realized as an array, vector, list or sequence.

## wolfSenty JSON examples

wolfSentry JSON file examples can be found in wolfSentry source tree.

```
./tests/test-config.json
./tests/test-config-numeric.json
./examples/Linux-LWIP/echo-config.json
```

## wolfSentry JSON handling example

It is able to pass JSON configuration through file or a part of C programming to wolfSentry.

Example : Reading JSON configuration from file and sending the data to wolfsentry

```c
    struct wolfsentry_json_process_state *jps;

    /* Open the config file */
    FILE *f = fopen(wolfsentry_config_path, "r");

    /* Initalize the wolfSentry JSON parser */
    ret = wolfsentry_config_json_init(
             wolfsentry,
             WOLFSENTRY_CONFIG_LOAD_FLAG_NONE,
             &jps);

    /* wolfSentry uses a streaming reader/parser for the config file */
    for (;;) {
        /* Read some data from the config file */
        size_t n = fread(buf, 1, sizeof buf, f);
        
        /* Send the read data into the JSON parser */
        ret = wolfsentry_config_json_feed(jps, buf, n, err_buf, sizeof err_buf);
        
        if ((n < sizeof buf) && feof(f))
            break;
    }
    fclose(f);

    /* Clean up the JSON parser */
    ret = wolfsentry_config_json_fini(&jps, err_buf, sizeof err_buf);
```

Example : Sending JSON string by char array defined in C program :

```c

 static const char *wolfsentry_config_data = "{\n"
"    \"wolfsentry-config-version\" : 1,\n"
"    \"config-update\" : {\n"
" 	 \"max-connection-count\" : 5,\n"
"    \"penalty-box-duration\" : \"1h\"\n"
   ....
   ....
   };

   struct wolfsentry_json_process_state *jps;

    /* Initalize the wolfSentry JSON parser */
    ret = wolfsentry_config_json_init(
                   wolfsentry,
                   WOLFSENTRY_CONFIG_LOAD_FLAG_NONE,
                   &jps)

    /* wolfSentry uses a streaming reader/parser for the config file */
    /* Send the read data into the JSON parser */
	ret = wolfsentry_config_json_feed(jps, wolfsentry_config_data, strlen(wolfsentry_config_data), err_buf, sizeof err_buf);

    /* Clean up the JSON parser */
    ret = wolfsentry_config_json_fini(&jps, err_buf, sizeof err_buf);
```

## Reference of address family table

The following table lists the possible value of `family` :

| `name`  |  macro definition |  
| --------| ------------------|
| `UNIX`  | WOLFSENTRY_AF_UNIX |
| `LOCAL` | WOLFSENTRY_AF_LOCAL |
| `INET` | WOLFSENTRY_AF_INET |
| `AX25` | WOLFSENTRY_AF_AX25 |
| `IPX` | WOLFSENTRY_AF_IPX |
| `APPLETALK` | WOLFSENTRY_AF_APPLETALK |
| `NETROM` | WOLFSENTRY_AF_NETROM |
| `BRIDGE` | WOLFSENTRY_AF_BRIDGE |
| `ATMPVC` |  WOLFSENTRY_AF_ATMPVC |
| `X25` |  WOLFSENTRY_AF_X25 |
| `INET6` |  WOLFSENTRY_AF_INET6 |
| `ROSE`  |  WOLFSENTRY_AF_ROSE |
| `DECnet` |  WOLFSENTRY_AF_DECnet |
| `NETBEUI` |  WOLFSENTRY_AF_NETBEUI |
| `SECURITY` |  WOLFSENTRY_AF_SECURITY |
| `KEY` |  WOLFSENTRY_AF_KEY |
| `NETLINK` |  WOLFSENTRY_AF_NETLINK |
| `ROUTE` |  WOLFSENTRY_AF_ROUTE |
| `PACKET` |  WOLFSENTRY_AF_PACKET |
| `ASH` |  WOLFSENTRY_AF_ASH |
| `ECONET` |  WOLFSENTRY_AF_ECONET |
| `ATMSVC` |  WOLFSENTRY_AF_ATMSVC |
| `RDS` |  WOLFSENTRY_AF_RDS |
| `SNA` |  WOLFSENTRY_AF_SNA |
| `IRDA` |  WOLFSENTRY_AF_IRDA |
| `PPPOX` |  WOLFSENTRY_AF_PPPOX |
| `WANPIPE` |  WOLFSENTRY_AF_WANPIPE |
| `LLC` |  WOLFSENTRY_AF_LLC |
| `IB`  |  WOLFSENTRY_AF_IB |
| `MPLS` |  WOLFSENTRY_AF_MPLS |
| `CAN`  |  WOLFSENTRY_AF_CAN |
| `TIPC` |  WOLFSENTRY_AF_TIPC |
| `BLUETOOTH` |  WOLFSENTRY_AF_BLUETOOTH |
| `IUCV` |  WOLFSENTRY_AF_IUCV |
| `RXRPC` |  WOLFSENTRY_AF_RXRPC |
| `ISDN`  |  WOLFSENTRY_AF_ISDN |
| `PHONET` |  WOLFSENTRY_AF_PHONET |
| `IEEE802154` |  WOLFSENTRY_AF_IEEE802154 |
| `CAIF` |  WOLFSENTRY_AF_CAIF |
| `ALG` |  WOLFSENTRY_AF_ALG |
| `NFC` |  WOLFSENTRY_AF_NFC |
| `VSOCK` |  WOLFSENTRY_AF_VSOCK |
| `KCM` |  WOLFSENTRY_AF_KCM |
| `QIPCRTR` |  WOLFSENTRY_AF_QIPCRTR |
| `SMC` |  WOLFSENTRY_AF_SMC |
| `XDP` |  WOLFSENTRY_AF_XDP |
| `IMPLINK` |  WOLFSENTRY_AF_IMPLINK |
| `PUP` |  WOLFSENTRY_AF_PUP |
| `CHAOS` |  WOLFSENTRY_AF_CHAOS |
| `NETBIOS` |  WOLFSENTRY_AF_NETBIOS |
| `ISO` |  WOLFSENTRY_AF_ISO |
| `OSI` |  WOLFSENTRY_AF_OSI |
| `ECMA` |  WOLFSENTRY_AF_ECMA |
| `DATAKIT` |  WOLFSENTRY_AF_DATAKIT |
| `DLI` |  WOLFSENTRY_AF_DLI |
| `LAT` |  WOLFSENTRY_AF_LAT |
| `HYLINK` |  WOLFSENTRY_AF_HYLINK |
| `LINK` |  WOLFSENTRY_AF_LINK |
| `COIP` |  WOLFSENTRY_AF_COIP |
| `CNT` |  WOLFSENTRY_AF_CNT |
| `SIP` |  WOLFSENTRY_AF_SIP |
| `SLOW` |  WOLFSENTRY_AF_SLOW |
| `SCLUSTER` |  WOLFSENTRY_AF_SCLUSTER |
| `ARP` |  WOLFSENTRY_AF_ARP |
| `IEEE80211` |  WOLFSENTRY_AF_IEEE80211 |
| `INET_SDP`  |  WOLFSENTRY_AF_INET_SDP |
| `INET6_SDP` |  WOLFSENTRY_AF_INET6_SDP |
| `HYPERV` |  WOLFSENTRY_AF_HYPERV |
