# 实验2报告
## 实验内容：基于区块链的积分系统 
### 实验系统简介  
本次实验实现一个积分系统，由商家进行积分发放，用户进行积分消费 
### 实验系统功能介绍  
(1)总积分初始化  
(2)总积分查询  
(3)积分转账  
(4)积分查询  
(5)积分转账明细记录  
### 控制台开发
#### 实验步骤  
1.编写合约  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/0.JPG)  
2.使用```get_account.sh```分别创建商家和用户两个账号  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/1.JPG)  
3.使用商家的私钥登陆FISCO-BCOS控制台  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/2.JPG)  
4.使用用户的私钥登陆FISCO-BCOS控制台  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/3.JPG)  
5.在商家的账号上部署```Credit.sol```，初始化总积分  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/4.JPG)  
6.查询总积分  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/5.JPG)  
7.调用```transfer```方法从商家的账号向用户的帐号转账100积分  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/7.JPG)  
8.调用```balanceOf```方法查询商家账号的积分  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/6.JPG)  
9.调用```balanceOf```方法查询用户账号的积分  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/9.JPG)  
### SDK开发  
1.从github下载spring-boot-starter  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/2.1.JPG)  
2.搭建gradle环境  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/2.2.JPG)  
3.运行gradle  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/day2/JianhengLiang/assets/2.3.JPG)
