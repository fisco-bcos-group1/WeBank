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
+ **gen_node_cert_gm()** 为国密版本的证书生成函数

## generate_cert_conf()
```shell
generate_cert_conf()
{
    local output=$1
    cat << EOF > ${output} 
[ca]
default_ca=default_ca
[default_ca]
default_days = 365
default_md = sha256
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
[req_distinguished_name]
countryName = CN
countryName_default = CN
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default =GuangDong
localityName = Locality Name (eg, city)
localityName_default = ShenZhen
organizationalUnitName = Organizational Unit Name (eg, section)
organizationalUnitName_default = fisco-bcos
commonName =  Organizational  commonName (eg, fisco-bcos)
commonName_default = fisco-bcos
commonName_max = 64
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[ v4_req ]
basicConstraints = CA:TRUE
EOF
}
```
+ 显示了一些证书的基本信息，以及一些配置的默认设置
+ 默认使用***sha256***计算哈希值进行加密


## generate_cert_conf_gm()
```shell
generate_cert_conf_gm()
{
    local output=$1
    cat << EOF > ${output} 
HOME			= .
RANDFILE		= $ENV::HOME/.rnd
oid_section		= new_oids
[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7
####################################################################
[ ca ]
default_ca	= CA_default		# The default ca section
}
```
+ 显示了国密版本证书的一些基本信息，以及默认取值
+ ***HOME*** 为起始的地址
+ ***oid_section*** ：指定了一个字段，该字段配置文件中包含的额外的对象标识符
+ 上面还有TSA实例所使用的Policy
