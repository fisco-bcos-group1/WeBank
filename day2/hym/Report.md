## 基于区块链的积分系统

本次实验，我们实现的积分系统包含以下部分：

* 查询总积分

* 查询账户余额
* 转账积分
* 查询交易记录



### 实验步骤

* 编写书店积分智能合约

```

pragma solidity ^0.4.25;

contract Credit {
   string name="Credit";
   string symbol="LAG";
   uint totalSupply;
   mapping(address=>uint) private balances;
   event transferEvent(address _from, address _to, uint value);
   
   constructor(uint initialSupply, string creditName, string creditSymbol) public
   { totalSupply = initialSupply; 
   balances[msg.sender] = totalSupply; 
   name = creditName; 
   symbol = creditSymbol; }
function getTotalSupply() constant returns (uint){
  return totalSupply;}
function _transfer(address _from, address _to, uint _value) internal {
require(_to != 0x0); 
require(balances[_from] >= _value); 
require(balances[_to] + _value > balances[_to]); 
uint previousBalances = balances[_from] + balances[_to]; 
balances[_from] -= _value; 
balances[_to] += _value;
emit transferEvent(_from, _to, _value);   
assert(balances[_from] + balances[_to] == previousBalances);  
}

function transfer(address _to, uint _value) public {
    _transfer(msg.sender, _to, _value); }
    
    function balanceOf(address _owner) constant returns (uint) {
     return balances[_owner]; }

function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    }
```

* 启动节点

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/6.jpg)

* 使用get_account脚本生成两个账户，分别用于书店和客户

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/5.jpg)

* 分别使用两个账户的私钥同时启动控制台

书店方的账户启动

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/7.jpg)

客户方的账户启动

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/14.jpg)

* 部署编写好的书店合约Credit.sol

同时赋予系统总积分500

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/8.jpg)

可以看到部署成功，已经返回了合约地址

* 查询书店方的积分余额，可以看到是500积分

需要注意的是，此时使用的是账户地址而不是私钥。

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/9.jpg)

* 查询客户方的积分余额，此时为0积分

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/15.jpg)

* 查询系统总积分，同样也是500积分

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/10.jpg)

* 向客户方转账100积分

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/11.jpg)

同样也是使用账户地址进行转账。

* 查询书店方的账户余额，可以看到此时只有400积分

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/12.jpg)

* 查询客户方的账户余额，此时有100积分

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/16.jpg)

* 此时查询系统总积分，仍然保持不变

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/13.jpg)





### Spring Boot Starter

* 在Github上获取代码

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/17.jpg)

* 将nodes下的证书移动到Spring Boot Starter对应文件夹下

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/1.jpg)

* build gradlew

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/2.jpg)

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/3.jpg)

可以看到build成功

* 运行

![avatar](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/hym/assets/4.jpg)

可以看到运行成功了。
