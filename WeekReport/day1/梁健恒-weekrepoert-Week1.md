# 第一周周记
在第一周的实训中，我们初步接触了区块链的背景知识。区块链借助其分布式的特点逐渐提高其在商业上的价值和地位。分布式的特点允许交易在发生时同时引入多家机构的验证和确认，省去了事后同步的操作，保证了交易记录的一致性和真实性。而联盟链在区块链的基础上引入了准入机制、监管节点、身份认证、去代币等安全保障，进一步保证了各方在进行金融交易等操作时，信息能够得到保障，而FISCO-BCOS就是一个开源的联盟连底层平台。  
在学习中我了解到区块链的几个核心特性，首先共识协作使交易在进行时得到协同计算和群体验证，在多方的监督和验证下，交易变得更加准确、可信。其次区块链由于密码学的应用，确保了信息在传输过程中难以被破解，也使交易内容难以被篡改，进一步保证了其安全性。然后它的区块数据保证了数据的一致性，增加了篡改记录的难度性。最后分布网络的特点使得整个结构可以高效地使用各方的资源。  
在了解完区块链的基本知识后，我们在助教和企业老师的指导下尝试了建立基本的链。使用以下代码建立四个节点  
```$ cd nodes/127.0.0.1```  
```$ ./start_all.sh```  
节点建立完毕以后执行以下代码，建立一条有四个节点的链  
```$ ./build_chain.sh -l "127.0.0.1:4" -p30300,20200,8545```  
生成该链以后，我们输入以下代码，启动我们之前建立的节点  
```$ nodes/127.0.0.1/start_all.sh```  
完成以上操作后可以利用现有的脚本，配置并使用控制台。  
```$ cd ~/fisco  
$ sudo apt install -y default-jdk  
$ bash <(curl -s https://raw.githubusercontent.com/FISCO-BCOS/console/master/tools/download_console.sh)  
$ cp -n console/conf/applicationContext-sample.xml console/conf/applicationContext.xml  
$ cp nodes/127.0.0.1/sdk/* console/conf/
```  
成功配置控制台后，输入以下代码启动控制台  
```
$ ./start.sh```
在这次实验中，我们选择部署已经准备好的HelloWorld合约来查看、修改所建的链  
```[group:1]> deploy HelloWorld```  
执行上述代码后，系统会返回对应的合约地址。我们可以通过HelloWorld中原有的方法查询链的信息：比如getBlockNumber获取当前块高，get、set方法进行内容输出、设置name等操作。  
熟悉相关操作后，我尝试完成实训课上的练习，以下是操作结果：  
![查看区块高度](F:/BlockChain/微信图片_20190602221928.png)  

![使用查看getDeployLog](F:/BlockChain/微信图片_20190602221940.png)  

![调用智能合约](F:/BlockChain/微信图片_20190602221944.png) 

![再次查看区块高度](F:/BlockChain/微信图片_20190602221949.png) 

![获取区块数据](F:/BlockChain/微信图片_20190602221955.png) 

![按CNS方式部署HelloWorld智能合约](F:/BlockChain/微信图片_20190602221958.png) 

![再次查看区块高度](F:/BlockChain/微信图片_20190602222002.png) 

![获取区块数据](F:/BlockChain/微信图片_20190602222005.png) 
