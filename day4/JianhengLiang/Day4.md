# Day4  

## 1. 初步构建MusicChain合约

### 1.1 根据Design.md和需求设计确定合约中所需要的架构

```
    struct Music{            //储存音乐的相关信息
        address owner;
        string bin;
        string mname;
        string singer;
        bool isvalid;
        string beg_time;
        string end_time;
        string platform;
        string modified;
    }
    
    struct Record{          //记录版权授权的信息
        address user;
        address author;
        string bin;
        string beg_time;
        string end_time;
        string platform;
        string modified;
    }
    
    struct UserEntity{     //用户实体，记录用户相关信息
        string name;
        string id;
        string location;
        string phone;
        string email;
    }
    
    struct Notice{         //通知结构，在被授权方向授权方发起请求时生成
        address from;
        address to;
        string time;
        string text;
        bool valid;
    }
    
    mapping(address => UserEntity) account;    //将用户地址与用户实例对象进行映射
    
    Music []musics;                            //储存音乐的数组
    Record []records;                          //储存记录的数组
    Notice []notices;                          //储存通知的数组

```

### 1.2 由界面功能设计所需函数

```
//用户注册功能
function registerUser(string _name,  string _phone){
        account[msg.sender].name = _name;    
        account[msg.sender].phone = _phone;
        
        account[msg.sender].location = _location;
        account[msg.sender].email = _email;
    }
    
//用户申请成为音乐人
    function registerMusician(string _name, string _id, string _location, string _phone, string _email){
        account[msg.sender].name = _name;    //doesn't validate if the username has been used
        account[msg.sender].phone = _phone;
        account[msg.sender].id = _id;
        account[msg.sender].location = _location;
        account[msg.sender].email = _email;
        account[msg.sender].identifier = "1";
    }
    
//用户申请成为企业
    function registerEnterprise(string _name, string _id, string _location, string _phone, string _email){
        account[msg.sender].name = _name;    //doesn't validate if the username has been used
        account[msg.sender].phone = _phone;
        account[msg.sender].id = _id;
        account[msg.sender].location = _location;
        account[msg.sender].email = _email;
        account[msg.sender].identifier = "2";
    }
    
//用户申请成为仲裁机构
    function registerJudge(string _name, string _id, string _location, string _phone, string _email){
        account[msg.sender].name = _name; 
        account[msg.sender].phone = _phone;
        account[msg.sender].id = _id;
        account[msg.sender].location = _location;
        account[msg.sender].email = _email;
        account[msg.sender].identifier = "3";
    }

//用户上传、注册音乐
    function registerMusic(string _bin, string _name){
        uint8 validate = 0;
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].bin) == keccak256(_bin)){
                validate = 1;
            }            
        }
        require(validate == 0);
        uint256 endtime = now + 316224000;
        musics.push(Music(msg.sender, _bin, _name, account[msg.sender].name, true, now, endtime , "", now));
    }

//被授权方生成通知
    function registerNotice(address _to, string _text, string _price){
        notices.push(Notice(msg.sender, _to, now, _text, false, _price));
    }

//音乐版权变更
    function transferMusic(address _to, string _binhash){
        address owner = msg.sender;
        uint8 num = 0;
        for (num = 0; num < musics.length; num++){
            if(owner == musics[num].owner && keccak256(musics[num].bin) == keccak256(_binhash)){   //modified
                musics[num].owner = _to;
                //doesn't modify both time, platform and modified
                musics[num].modified = now;
                musics[num].beg_time = now;
            }
        }
    }
    
//用户注销音乐    
    function cancelMusic(string _binhash){
        uint8 num = 0;
        address owner = msg.sender;
        for(num = 0; num < musics.length; num++){
            if(musics[num].owner == owner && keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].isvalid == true){
                musics[num].isvalid = false;
                musics[num].beg_time = 0;
                musics[num].end_time = 0;
                musics[num].modified = now;
            }
        }
    }
    
//音乐版权方将音乐版权授予申请方    
    function authorizeMusic(address _to, string _binhash){
        address owner = msg.sender;
        uint8 num = 0;
        for(num = 0; num < musics.length; num++){
            if(keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].owner == msg.sender){
                Record newrecord;
                newrecord.author = msg.sender;
                newrecord.user = _to;
                newrecord.bin = _binhash;
                uint256 endtime = now + 316224000;
                records.push(Record(_to, msg.sender, _binhash, now, endtime, "", now));
            }
        }
    }
```

### 1.3 设计与后端进行数据交换的函数

```
    function getUserName()public view returns(string){      //get user's name
        return (account[msg.sender].name);
    }
    
    function getUserId()public view returns(string){       //get user's id
        return (account[msg.sender].id);
    }
    
    function getUserLocation()public view returns(string){    //get user's location
        return (account[msg.sender].location);
    }
    
    function getUserPhone()public view returns(string){     //get user's phone
        return (account[msg.sender].phone);
    }
    
    function getUserEmail()public view returns(string){    //get user's email
        return (account[msg.sender].email);
    }
    
    function getMusicOwnerBySearch(string _name, string _singer)public view returns(address){     //get music's owner
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].owner);
            }            
        }
    }
    
    function getMusicBinBySearch(string _name, string _singer)public view returns(string){        //get music's bin
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].bin);
            }            
        }
    }
    
    function getMusicMnameBySearch(string _name, string _singer)public view returns(string){        //get music's bin
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].mname);
            }            
        }
    }
    
    function getMusicSingerBySearch(string _name, string _singer)public view returns(string){        //get music's bin
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].singer);
            }            
        }
    }
    
    function getMusicBtimeBySearch(string _name, string _singer)public view returns(uint256){      //get musics's beg_time
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].beg_time);
            }            
        }
    }
    
    function getMusicEtimeBySearch(string _name, string _singer)public view returns(uint256){      //get music's end_time
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].end_time);
            }            
        }
    }
    
    function getMusicPlatormBySearch(string _name, string _singer)public view returns(string){     //get musics's platform
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].platform);
            }            
        }
    }
    
    function getMusicModifiedBySearch(string _name, string _singer)public view returns(uint256){      //get musics's modified
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].modified);
            }            
        }
    }
    
    function getMusicIsvalidBySearch(string _name, string _singer)public view returns(bool){     //get musics's platform
        for(uint8 count=0; count < musics.length; count++){
            if(keccak256(musics[count].mname) == keccak256(_name) && keccak256(musics[count].singer) == keccak256(_singer)){
                return (musics[count].isvalid);
            }            
        }
    }
    
    function getRecordNumber(address _address)public view returns(uint8[]){
        uint8 []num;
        uint8 count = 0;
        for(uint8 number = 0; number < records.length; number++){
            if(records[number].author == _address || records[number].user == _address){
                num[count] = number;
                count++;
            }
        }
        return num;
    }

    function getRecordUser(uint8 _num)public view returns(address){
        return (records[_num].user);
    }
    
    function getRecordAuthor(uint8 _num)public view returns(address){
        return (records[_num].author);
    }
    
    function getRecordBin(uint8 _num)public view returns(string){
        return (records[_num].bin);
    }
    
    function getRecordBTime(uint8 _num)public view returns(uint256){
        return (records[_num].beg_time);
    }
    
    function getRecordETime(uint8 _num)public view returns(uint256){
        return (records[_num].end_time);
    }
    
    function getRecordPlatform(uint8 _num)public view returns(string){
        return (records[_num].platform);
    }
    
    function getRecordModified(uint8 _num)public view returns(uint256){
        return (records[_num].modified);
    }
    
    function getNoticeNumber(address _address)public view returns(uint8[]){
        uint8 []num;
        uint8 count = 0;
        for(uint8 number = 0; number < records.length; number++){
            if(notices[number].to == _address){
                num[count] = number;
                count++;
            }
        }
        return num;
    }
    
    function getNoticeFrom(uint8 _num)public view returns(address){
        return (notices[_num].from);
    }
    
    function getNoticeTo(uint8 _num)public view returns(address){
        return (notices[_num].from);
    }
    
    function getNoticeTime(uint8 _num)public view returns(uint256){
        return (notices[_num].time);
    }
    
    function getNoticeText(uint8 _num)public view returns(string){
        return (notices[_num].text);
    }
    
    function getNoticeValid(uint8 _num)public view returns(bool){
        return (notices[_num].valid);
    }
    
    function getNoticePrice(uint8 _num)public view returns(string){
        return (notices[_num].price);
    }
    
    function getMusic(uint numb) public view returns(address,string,string,string, bool,uint256,uint256,string,uint){
        return (musics[numb].owner,musics[numb].bin, musics[numb].mname, musics[numb].singer, musics[numb].isvalid, musics[numb].beg_time, musics[numb].end_time, musics[numb].platform, musics[numb].modified);
    }
```

## 2 对构建的MusicChain合约进行功能测试

### 2.1 用户注册测试

分别注册两个普通用户

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/3.JPG)

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/2.JPG)

### 2.2 用户身份认证以及音乐上传、注册功能测试

对用户Travis Scott进行音乐人认证，并将注册其音乐作品

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/4.JPG)

查看刚刚注册的音乐作品

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/7.JPG)

### 2.3 通知生成以及查看功能测试

以刚刚注册的音乐作品作为通知主体向用户Drake发送通知并查看

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/5.JPG)

### 2.4 音乐授权以及查看功能测试

音乐版权所有者用户Travis Scott向用户Drake授予音乐作品版权

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/6.JPG)

### 2.5 音乐版权转让功能测试

用户Travis Scott将其音乐作品版权转让给用户Drake

[](https://github.com/fisco-bcos-group1/WeBank/blob/master/day4/JianhengLiang/assets/8.JPG)