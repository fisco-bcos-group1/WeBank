# 第三周工作总结及感想

### 在服务器云端搭建区块链并进行测试

### 0.整体部署方案及架构图

后台采用Java Spring boot的MVC框架。

后台和区块链网络部署在云服务器端，通过访问前端，后台调用合约的结构进行部署。其中，我们使用到了Web3SDK以供后台访问节点，查询节点，并调用智能合约等。

逻辑架构和物理架构如下：

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day3/hym/assets/逻辑架构.jpg)

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day3/hym/assets/物理架构.jpg)

### 1.安装依赖，及环境配置

#### 1.1运行环境

阿里云服务器端Ubuntu 16.04

Java 8 （JDK-8u181）

#### 1.2 openssl配置

sudo apt install -y openssl curl

由于搭建联盟链的脚本文件Build_chain.sh依赖于openssl和curl，使用该语句配置openssl。

#### 1.3 Java安装

进入官网下载页面

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>

选择云服务器端所适合的JAVA SE版本，下载。

在/opt路径下用以下解压命令：

sudo tar -xvzf /mnt/share/tmp/jdk-8u181-linux-x64.tar.gz

在opt路径下使用ls命令查看解压是否成功：

   ![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day3/hym/assets/2.jpg)

在/bin目录下创建java软链接：

cd /bin

sudo ln –s /opt/jdk1.8.0_181/bin/java java

随后设置Java环境：

vi ~/.bashrc

添加以下内容：

export JAVA_HOME=/opt/jdk1.8.0_181

export JRE_HOME=${JAVA_HOME}/jre

export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib

export PATH=${JAVA_HOME}/bin:$PATH

最后使用以下语句检验安装是否成功：

Java –version

   ![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day3/hym/assets/1.jpg)

#### 1.4创建操作目录及下载脚本

使用以下命令创建fisco文件夹以进行后续搭建区块链工作：

cd ~ && mkdir -p fisco && cd fisco

使用以下命令下载脚本文件：

curl -LO https://github.com/FISCO-BCOS/FISCO-BCOS/releases/download/ curl -s https://api.github.com/repos/FISCO-BCOS/FISCO-BCOS/releases | grep "\"v2\." | sort -u | tail -n 1 | cut -d \" -f 4`/build_chain.sh && chmod u+x build_chain.sh

#### 1.5配置控制台文件，以及控制台证书

使用如下指令获取及拷贝控制台文件：

bash <(curl -s 

https://raw.githubusercontent.com/FISCO-BCOS/console/master/tools/download_console.sh)

cp -n console/conf/applicationContext-sample.xml console/conf/applicationContext.xml

 

使用如下指令配置控制台证书：

cp nodes/127.0.0.1/sdk/* console/conf/

 

 

 

### 2.搭建4节点的单群组联盟链

在fisco目录下执行如下命令：

bash build_chain.sh -l "127.0.0.1:4" -p 30300,20200,8545

其中，30300,20200,8545分别对应p2p_port,channel_port,jsonrpc_port。由于链在本地运行，因此使用本机地址127.0.0.1，也可以使用云服务器端网卡局域网地址，在本ubuntu服务器端中，该地址为172.19.31.230。

运行成功后，返回如下信息：

Checking fisco-bcos binary...

Binary check passed.

==============================================================

Generating CA key...

==============================================================

Generating keys ...

Processing IP:127.0.0.1 Total:4 Agency:agency Groups:1

==============================================================

Generating configurations...

Processing IP:127.0.0.1 Total:4 Agency:agency Groups:1

==============================================================

[INFO] FISCO-BCOS Path   : bin/fisco-bcos

[INFO] Start Port        : 30300 20200 8545

[INFO] Server IP         : 127.0.0.1:4

[INFO] State Type        : storage

[INFO] RPC listen IP     : 127.0.0.1

[INFO] Output Dir        : /root/fisco/nodes

[INFO] CA Key Path       : /root/fisco/nodes/cert/ca.key

 

执行以下指令启动四个节点：

bash nodes/127.0.0.1/start_all.sh

成功后，执行以下指令检查进程启动情况：

   ![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day3/hym/assets/3.jpg)

 

 

### 3.机构群组的组网模式搭建过程

#### 3.1下载安装部署工具

通过以下语句下载和安装：

cd ~/ && git clone https://github.com/FISCO-BCOS/generator.git

cd generator && bash ./scripts/install.sh

 

按照以下语句拉取最新fisco-bcos二进制文件到meta文件中：

./generator --download_fisco ./meta

使用以下语句检查二进制版本是否安装成功：

./meta/fisco-bcos -v

 

 

#### 3.2组网模式结构

本项目构建的4节点2结构1群组的组网模式的区块链结构如图：

![avatar](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/_images/tutorial_step_1.png)

#### 3.3机构，节点，群组，地址信息配置

每个节点的IP，端口号及所属信息如下表：

| **机构** | **节点** | **所属群组** | **P2P****地址** | **RPC/channel****监听地址** |
| -------- | -------- | ------------ | --------------- | --------------------------- |
| 机构A    | 节点0    | 群组1、2     | 127.0.0.1:30300 | 0.0.0.0:8545/:20200         |
| 机构A    | 节点1    | 群组1、2     | 127.0.0.1:30301 | 0.0.0.0:8546/:20201         |
| 机构B    | 节点2    | 群组1        | 127.0.0.1:30302 | 0.0.0.0:8547/:20202         |
| 机构B    | 节点3    | 群组1        | 127.0.0.1:30303 | 0.0.0.0:8548/:20203         |

需要注意的是，为了开发人员能够在开发后台的时候可以直接调试，我们允许外网进行访问，因此监听地址设置为广播地址，而对于后台访问云服务器的时候，其设置的P2P参数则为：

   

其中，云服务器端的公网ip为101.132.68.46。端口设置为搭建联盟链时设定的端口参数。



其余部分见

[构建群组](https://github.com/fisco-bcos-group1/WeBank/tree/master/day4/hym/构建群组.md)