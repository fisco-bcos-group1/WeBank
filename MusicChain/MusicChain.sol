pragma solidity ^0.4.25;

contract MusicChain{

  struct Music { // 音乐的版权信息
    address owner;    // 音乐版权所有者的地址
    string bin;       // 记录音乐二进制文件的hash
    string mname;    // 音乐名称
    string singer;     // 歌手
    bool isvalid;     // 标识该版权是否有效
    string alltime;    // 所有时间，beg_time # end_time # modified
  }

  struct Record { // 一个授权记录
    address user;     // 被授权人地址
    address author;  // 授权人/版权拥有人地址
    string alltime;   // 所有时间，beg_time # end_time # modified
    string music;     // bin # mname # singer # owner
    string info;       // applicantName # phone # use # location # length # text # price
  }

  struct UserEntity { // 这里的用户实体可以是任何，包括节点，用户，企业
    string name;   // 用户实体的名称
    string type;   // 用户类型 - user,company,musician,judge
    string id;     // 企业编号或身份证
    string location;
    string phone;
    string email;
  }

  struct Notice {     // 一个系统通知
    address from;  // 通知发起方
    address to;    // 接收方
    string music;   // mname # singer # recordTime # applyTime
    string info;   // applicantName # phone # use # location # length # text # price
    bool valid;     // 是否授权
  }

  mapping(address => UserEntity) account;  // 每个地址对应一个用户实体

  Music[] musics;     // 记录链上所有的音乐版权信息
  Record[] records;   // 记录链上所有的授权信息
  Notice[] notices;   // 记录所有通知消息

}