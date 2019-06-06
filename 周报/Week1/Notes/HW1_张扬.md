# 生成证书函数
+ 概述：默认采用三级的证书结构，自上而下分别为链证书、机构证书、节点证书
## gen_chain_cert()
```shell
gen_chain_cert() {
    path="$2"
    name=$(getname "$path")
    echo "$path --- $name"
    dir_must_not_exists "$path"
    check_name chain "$name"  
    chaindir=$path
    mkdir -p $chaindir
    openssl genrsa -out $chaindir/ca.key 2048
    openssl req -new -x509 -days 3650 -subj "/CN=$name/O=fisco-bcos/OU=chain" -key $chaindir/ca.key -out $chaindir/ca.crt
    mv cert.cnf $chaindir
}
```
+ 联盟链委员会使用openssl命令请求链私钥，并输出在*ca.key*文件中，长度为2048
+ 根据ca.key生成链证书*ca.crt*
+ 使用-new，说明是要生成证书请求，当使用-x509选项的时候，说明是要生成自签名证书
+ **gen_chain_cert_gm()** 为使用国密版本的证书生成函数

## gen_agency_cert()
```shell
gen_agency_cert() {
    chain="$2"
    agencypath="$3"
    name=$(getname "$agencypath")

    dir_must_exists "$chain"
    file_must_exists "$chain/ca.key"
    check_name agency "$name"
    agencydir=$agencypath
    dir_must_not_exists "$agencydir"
    mkdir -p $agencydir

    openssl genrsa -out $agencydir/agency.key 2048
    openssl req -new -sha256 -subj "/CN=$name/O=fisco-bcos/OU=agency" -key $agencydir/agency.key -config $chain/cert.cnf -out $agencydir/agency.csr
    openssl x509 -req -days 3650 -sha256 -CA $chain/ca.crt -CAkey $chain/ca.key -CAcreateserial\
        -in $agencydir/agency.csr -out $agencydir/agency.crt  -extensions v4_req -extfile $chain/cert.cnf
    
    cp $chain/ca.crt $chain/cert.cnf $agencydir/
    cp $chain/ca.crt $agencydir/ca-agency.crt
    more $agencydir/agency.crt | cat >>$agencydir/ca-agency.crt
    rm -f $agencydir/agency.csr

    echo "build $name agency cert successful!"
}
```
+ 使用openssl命令生成机构私钥*agency.key*
+ 机构使用机构私钥*agency.key*得到机构证书请求文件*agency.csr*
+ 联盟链委员会使用链私钥*ca.key*，根据得到机构证书请求文件*agency.csr*生成机构证书*agency.crt*
+ 机构接受证书，并对其进行整合
+ **gen_agency_cert_gm()** 为国密版本的证书生成函数

## gen_node_cert()
```shell
gen_node_cert() {
    if [ "" == "$(openssl ecparam -list_curves 2>&1 | grep secp256k1)" ]; then
        echo "openssl don't support secp256k1, please upgrade openssl!"
        exit $EXIT_CODE
    fi

    agpath="$2"
    agency=$(getname "$agpath")
    ndpath="$3"
    node=$(getname "$ndpath")
    dir_must_exists "$agpath"
    file_must_exists "$agpath/agency.key"
    check_name agency "$agency"
    dir_must_not_exists "$ndpath"	
    check_name node "$node"

    mkdir -p $ndpath

    gen_cert_secp256k1 "$agpath" "$ndpath" "$node" node
    #nodeid is pubkey
    openssl ec -in $ndpath/node.key -text -noout | sed -n '7,11p' | tr -d ": \n" | awk '{print substr($0,3);}' | cat >$ndpath/node.nodeid
    # openssl x509 -serial -noout -in $ndpath/node.crt | awk -F= '{print $2}' | cat >$ndpath/node.serial
    cp $agpath/ca.crt $agpath/agency.crt $ndpath

    cd $ndpath

    echo "build $node node cert successful!"
}
```
+ 节点生成私钥*node.key*和证书请求文件*node.csr*
+ 机构管理员使用私钥*agency.key*和证书请求文件*node.csr*为节点颁发证书*node.crt*
