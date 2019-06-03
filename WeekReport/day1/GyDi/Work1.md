# 练习1



## 1. 查看区块高度

刚开始区块高度是0，截图的时候我已经部署过一次HelloWorld.sol

![](.//assets//Snipaste_2019-05-28_16-28-58.png)



## 2. 获取区块数据

这里，因为我只知道当前链上的高度是1，是部署的HelloWorld合约，所以我使用`getBlockByNumber`来查看区块数据。

![](.//assets//Snipaste_2019-05-28_16-33-49.png)



这里已经查出了区块的数据，可以看到区块的Hash地址，于是可以使用`getBlockByHash`来查看数据，当然，也可以使用`getBlockHashByNumber`查看区块的Hash地址。

![](.//assets//Snipaste_2019-05-28_16-39-04.png)

这里可以简要看看，两者数据一致。



## 3. 部署HelloWorld智能合约

可以看到已有默认的`solidity/contracts/HelloWorld.sol`HelloWorld合约代码

直接部署

![](.//assets//Snipaste_2019-05-28_16-40-53.png)



## 4. 使用查看getDeployLog

![](.//assets//Snipaste_2019-05-28_16-44-28.png)

这里可以看到，我前后两次部署了HelloWorld合约，与上文提及一致。



## 5. 调用智能合约

![](.//assets//Snipaste_2019-05-28_16-48-03.png)

如图可以看到，这里我分别调用了`HelloWorld.sol`的`get`和`set`方法，其中由于调用set方法，参数写的时候粘贴数据出现意外，但是本次事务是成功执行的。



## 6. 再次查看区块高度

![](.//assets//Snipaste_2019-05-28_16-51-28.png)

我又重新查看了区块个数，可以看到是3；然后我又调用了set方法，参数的填写如自己所愿；再次查看区块个数，已经变为4，可见set方法会增加区块个数。



## 7. 获取区块数据

我使用`getBlockByNumber 4`查看第4个区块的数据，也就是最新的区块的数据。

![](.//assets//Snipaste_2019-05-28_16-56-36.png)



## 8. 按CNS方式部署HelloWorld智能合约

我将HelloWorld.sol的别名设置为 HelloTwo

![](.//assets//Snipaste_2019-05-28_16-58-33.png)



## 9. 再次查看区块高度

![](.//assets//Snipaste_2019-05-28_17-01-57.png)

这里可以看到，使用`deployByCNS`之前，区块高度为4，调用之后，区块高度为6。根据老师的描述，该调用产生两个交易，一般会出现一个区块，如果计算机性能好，会出现两个块。



## 10. 获取区块数据

这里我使用`getBlockByNumber 5`查看第5个区块的信息

![](.//assets//Snipaste_2019-05-28_17-04-34.png)



