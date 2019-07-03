pragma solidity ^0.4.25;

contract MusicChain{

    struct Music { // 音乐的版权信息
        address owner;   // 音乐版权所有者的地址
        string bin;      // 记录音乐二进制文件的hash
        string mname;    // 音乐名称
        string singer;   // 歌手
        bool isvalid;    // 标识该版权是否有效
        string alltime;  // 所有时间，beg_time # end_time # modified
    }

    struct Record {      // 一个授权记录
        address user;    // 被授权人地址
        address author;  // 授权人/版权拥有人地址
        string alltime;  // 所有时间，beg_time # end_time # modified
        string music;    // bin # mname # singer # owner
        string info;     // applicantName # phone # use # location # length # text # price
    }

    struct UserEntity { // 这里的用户实体可以是任何，包括节点，用户，企业
        string name;    // 用户实体的名称
        string kind;    // 用户类型 - user,company,musician,judge
        string id;      // 企业编号或身份证
        string location;
        string phone;
        string email;
    }

    struct Notice {     // 一个系统通知
        address start;  // 通知发起方
        address to;     // 接收方
        string music;   // mname # singer # recordTime # applyTime
        string info;    // applicantName # phone # use # location # length # text # price
        bool valid;     // 是否授权
    }

    mapping(address => UserEntity) account;  // 每个地址对应一个用户实体

    Music[] musics;     // 记录链上所有的音乐版权信息
    Record[] records;   // 记录链上所有的授权信息
    Notice[] notices;   // 记录所有通知消息

    //normal user registration
    function registerUser(string _name, string _phone) public {
        account[msg.sender].name = _name;
        account[msg.sender].phone = _phone;
        account[msg.sender].kind = "user";
    }

    //company registration
    function registerCompany(string _name, string _id, string _location, string _phone, string _email) public {
        account[msg.sender].name = _name;
        account[msg.sender].phone = _phone;
        account[msg.sender].kind = "company";
        account[msg.sender].id = _id;
        account[msg.sender].email = _email;
        account[msg.sender].location = _location;
    }

    //musician registration
    function registerMusician(string _name, string _id, string _location, string _phone, string _email) public {
        account[msg.sender].name = _name;
        account[msg.sender].phone = _phone;
        account[msg.sender].kind = "musician";
        account[msg.sender].id = _id;
        account[msg.sender].email = _email;
        account[msg.sender].location = _location;
    }

    //judge registration
    function registerJudge(string _name, string _id, string _location, string _phone, string _email) public {
        account[msg.sender].name = _name;
        account[msg.sender].phone = _phone;
        account[msg.sender].kind = "judge";
        account[msg.sender].id = _id;
        account[msg.sender].email = _email;
        account[msg.sender].location = _location;
    }

    //music registration
    function registerMusic(string _bin, string _mname, string _alltime) public {
        musics.push(Music(msg.sender, _bin, _mname, account[msg.sender].name, true, _alltime));
    }

    //notice registration
    function registerNotice(address _to, string _music, string _info) public {
        address _from = msg.sender;
        notices.push(Notice(_from, _to, _music, _info, false));
    }

    function transferMusic(address _to, string _binhash, string _alltime) public {
        address owner = msg.sender;
        uint8 num = 0;
        for (num = 0; num < musics.length; num++){
            if(owner == musics[num].owner && keccak256(musics[num].bin) == keccak256(_binhash)){   //modified
                musics[num].owner = _to;
                musics[num].alltime = _alltime;
            }
        }
    }

    function cancelMusic(string _binhash, string _alltime) public {
        uint8 num = 0;
        address owner = msg.sender;
        for(num = 0; num < musics.length; num++){
            if(musics[num].owner == owner && keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].isvalid == true){
                musics[num].isvalid = false;
                musics[num].alltime = _alltime;
            }
        }
    }

    function authorizeMusic(address _to, string _binhash, string _alltime, string _music, string _info) public {
        address owner = msg.sender;
        uint8 num = 0;
        for(num = 0; num < musics.length; num++){
            if(keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].owner == msg.sender){
                records.push(Record(_to, msg.sender, _alltime, _music, _info));
            }
        }
    }

    function getMusic(uint numb) public view returns(address,string,string,string, bool,string){
        return (musics[numb].owner, musics[numb].bin, musics[numb].mname, musics[numb].singer, musics[numb].isvalid, musics[numb].alltime);
    }

    function getMusicNumber(string _mname,string _singer) public view returns(uint8[]) {
        uint8 num1 = 0;
        uint8[] num2;
        uint8 count = 0;
        for(num1 = 0;num1 < musics.length; num1++){
            if((keccak256(musics[num1].mname) == keccak256(_mname)) && (keccak256(musics[num1].singer) == keccak256(_singer))){
                //return main info
                num2[count] = num1;
                count++;
            }
        }
        return num2;
    }

    // new - not be tested!!!
    function searchMusic(string _mname,string _singer) public view returns (address,string,string,string,string) {
        for (uint8 i = 0; i < musics.length; i++) {
            if (musics[i].isvalid && (keccak256(musics[i].mname) == keccak256(_mname)) && (keccak256(musics[i].singer) == keccak256(_singer))){
                return (musics[i].owner, musics[i].bin, musics[i].mname, musics[i].singer, musics[i].alltime);
            }
        }
    }

    function getRecord(uint numbe) public view returns(address,address,string,string,string){
        return (records[numbe].user,records[numbe].author,records[numbe].alltime,records[numbe].music,records[numbe].info);
    }

    function getRecordNumber (address _user,address _author) public view returns(uint8[]) {
        uint8 num1 = 0;
        uint8[] num3;
        uint8 count = 0;
        for(num1 = 0;num1 < records.length; num1++){
            if((keccak256(records[num1].user) == keccak256(_user)) && (keccak256(records[num1].author) == keccak256(_author))){
                //return main info
                num3[count] = num1;
                count++;
            }
        }
        return num3;
    }

    function getUser() public view returns (string,string,string,string,string,string) {
        UserEntity storage user = account[msg.sender];
        return (user.name, user.kind, user.id, user.location, user.phone, user.email);
    }

    // new
    function getUserByAddress(address _user) public view returns (string,string,string,string,string,string) {
        UserEntity storage user = account[_user];
        return (user.name, user.kind, user.id, user.location, user.phone, user.email);
    }

    // new - delete parameter
    function getNoticeNumberByStart() public view returns (uint8[]) {
        uint8[] storage idxs;
        for (uint8 i = 0; i < notices.length; i++){
            if (notices[i].start == msg.sender){
                idxs.push(i);
            }
        }
        return idxs;
    }

    // new - delete parameter
    function getNoticeNumberByTo() public view returns (uint8[]) {
        uint8[] storage idxs;
        for (uint8 i = 0; i < notices.length; i++){
            if (notices[i].to == msg.sender){
                idxs.push(i);
            }
        }
        return idxs;
    }

    function getNotice(uint8 _idx) public view returns (address, address, string, string, bool) {
        return (notices[_idx].start, notices[_idx].to, notices[_idx].music, notices[_idx].info, notices[_idx].valid);
    }

    // new - not be tested!!!
    function consumeNotice(uint8 _idx) public {
        notices[_idx].valid = true;
    }
}