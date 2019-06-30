# 详细设计

## 智能合约设计

### 功能列表

- 创建用户
- 登记音乐
- 版权转让
- 版权注销
- 授权
- 查询
  - 版权查询
  - 授权记录查询

### 功能描述

> ！这段话和下面实现不太符合，并且有点矛盾
> ！虽然这描述已经是错误的，但是我不想删掉

- 节点分为**合作节点**和**管理员节点**两种
- 所有节点都可以登记音乐，登记时仅判断 music.bin 是否重复
- 音乐版权归属者，分三种类型：普通大众用户、没能力合作的小音乐平台、合作节点平台
- **管理员节点**不拥有音乐版权，用户在该节点上登记，版权归属为用户
- 用户可以在链上**任意合作节点**登记自己的音乐，版权归属问题属于用户和平台两方的交易问题；合作节点务必将用户的选择准确无误的传达到链上，如用户有任何异议，可在链上其余节点查询版权归属信息，提出异议，解决与合作节点之间的问题
- **合作节点**仅允许将该平台所属的音乐转让、授权、注销
- **仅管理员节点**可以转让、授权属于**用户**的音乐
- 所有节点均可以查询版权信息，仅支持通过十分明确的关键词查询

### 数据结构与实现

```js
struct Music { // 音乐的版权信息
    owner: address,    // 音乐版权所有者的地址
    bin: string,       // 记录音乐二进制文件的hash
    name: string,      // 音乐名称
    ...,               // 省略音乐其他信息
    isvalid: bool,     // 标识该版权是否有效
    beg_time: string,  // 版权有效期开始日期
    end_time: string,  // 版权有效期结束日期，可以设置为NaN
    platform: string,  // 信息变更的节点名称
    modified: string   // 信息变更的时间
}

struct Record { // 一个授权记录
    user: address,     // 被授权人地址
    author: address,   // 授权人/版权拥有人地址
    bin: string,       // 音乐的hash
    beg_time: string,  // 版权使用有效期 开始时间
    end_time: string,  // 版权使用有效期 结束时间
    platform: string,  // 信息变更的节点名称
    modified: string   // 信息变更的时间
}

struct UserEntity { // 这里的用户实体可以是任何，包括节点，用户，企业
    name: string,   // 用户实体的名称
    more_info: ...  //
}

mapping(address => UserEntity) account;  // 每个地址对应一个用户实体

Music[] musics;     // 记录链上所有的音乐版权信息
Record[] records;   // 记录链上所有的授权信息

// 注册用户实体
function registerUser(...) {
    // 判断用户是否存在account中
    // 构造新用户
    // 存到account中
}

// 注册音乐，登记音乐版权
function registerMusic(binhash, ...) {
    // 检查binhash是否存在musics中，存在->返回错误
    // 构造music，music.owner = msg.sender
    // musics.push(music)
}

// 版权转让
function transferMusic(_to, _binhash, ...) {
    // address owner = msg.sender
    // for music in musics:
    //   if (music.isvalid && music.owner == owner \
    //     && music.bin == _binhash):
    //     music.owner = _to
}

// 注销版权
function cancelMusic(...) {}

// 授权
function authorizeMusic(_to, _binhash) {
    // 参考transferMusic，检查_binhash是否有效且属于msg.sender的
    // Record record;
    // record.author = msg.sender;
    // record.user = _to;
    // records.push(record);
}

// 查询...略
```
