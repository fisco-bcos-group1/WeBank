## 配置文件函数阅读报告

### generate_config_ini函数

> ```shell
> local output=${1}
> local ip=${2}
> local offset=${ip_node_counts[${ip//./}]}
> local node_groups=(${3//,/ })
> local prefix=""
> if [ -n "$guomi_mode" ]; then
> 	prefix="gm"
> ```

基础变量设置

> [rpc]
>     ; rpc listen ip
>     listen_ip=${listen_ip}
>     ; channelserver listen port
>     channel_listen_port=$((offset + port_start[1]))
>     ; jsonrpc listen port
>     jsonrpc_listen_port=$((offset + port_start[2]))

设置远程过程调用服务的ip，端口等参数

> [p2p]
>     ; p2p listen ip
>     listen_ip=0.0.0.0
>     ; p2p listen port
>     listen_port=$((offset + port_start[0]))
>     ; nodes to connect
>     $ip_list
>     ;enable/disable network compress
>     ;enable_compress=false

p2p情况下的ip，端口配置，如上段，但这里需要采用广播地址，另外port也需要提前设定好

> ;certificate rejected list		
> [certificate_blacklist]		
>     ; crl.0 should be nodeid, nodeid's length is 128 
>     ;crl.0=
> ;group configurations
> ;WARNING: group 0 is forbided

设定黑名单

> [network_security]
>     ; directory the certificates located in
>     data_path=${conf_path}/
>     ; the node private key file
>     key=${prefix}node.key
>     ; the node certificate file
>     cert=${prefix}node.crt
>     ; the ca certificate file
>     ca_cert=${prefix}ca.crt
> ; storage security releated configurations
> [storage_security]
> ; enable storage_security or not
> ;enable=true
> ; the IP of key mananger
> ;key_manager_ip=
> ; the Port of key manager
> ;key_manager_port=
> ;cipher_data_key=

设定数据路径，以及配置证书。此外，可以通过设置key manager的信息来确保储存信息的安全性。

> [chain]
>     id=${chain_id}
> [compatibility]
>     supported_version=${fisco_version}

根据此前设置的chain_id配置链

> [log]
>     ; the directory of the log
>     log_path=./log
>     ; info debug trace 
>     level=${log_level}
>     ; MB
>     max_log_file_size=200
>     ; control log auto_flush
>     flush=${auto_flush}
>     ; easylog config
>     format=%level|%datetime{%Y-%M-%d %H:%m:%s:%g}|%msg
>     log_flush_threshold=100

配置完成后记录日志。根据指定的配置路径存放日志，并且设置了日志的最大限制，使得能够自动刷新日志。



### generate_group_genesis函数

> ```shell
> local output=$1
> local index=$2
> local node_list=$3
> ```

根据传入参数配置序号，节点等信息。

> ;consensus configuration
> [consensus]
>     ;consensus algorithm type, now support PBFT(consensus_type=pbft) and Raft(consensus_type=raft)
>     consensus_type=${consensus_type}
>     ;the max number of transactions of a block
>     max_trans_num=1000
>     ;the node id of leaders
>     ${node_list}

初始化设定区块内交易次数最大限制，同时允许用户选择不同的算法应用，如PBFT（拜占庭容错）和Raft算法，能够很好地解决区块链中一致性问题。

> [storage]
>     ;storage db type, leveldb or external
>     type=${storage_type}
>     topic=DB

设定储存形式

> [state]
>     ;support mpt/storage
>     type=${state_type}
> ;tx gas limit
>
> [tx]
>     gas_limit=300000000

设定state_type，并设定了最大限制数量。

> [group]
>     id=${index}
>     timestamp=${timestamp}

接收参数配置序号和发生的时间戳。



### generate_group_ini函数

> ```shell
> local output="${1}"
> cat <<EOF >${output}
> ```

接收参数

> [consensus]
>     ;ttl=2
>     ;min block generation time(ms), the max block generation time is 1000 ms
>     ;min_block_generation_time=500
>     ;enable_dynamic_block_size=true

设定区块产生的时间限制，因此发生交易之后区块高度的变化受制于机器性能。

> ;txpool limit
> [tx_pool]
>     limit=150000
> [tx_execute]
>     enable_parallel=true

设定池最大限制，并线性执行。

