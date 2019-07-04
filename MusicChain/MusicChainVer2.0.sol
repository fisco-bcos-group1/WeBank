pragma solidity ^0.4.25;

contract MusicChain{

    struct Music { // ���ֵİ�Ȩ��Ϣ
        address owner;   // ���ְ�Ȩ�����ߵĵ�ַ
        string bin;      // ��¼���ֶ������ļ���hash
        string mname;    // ��������
        string singer;   // ����
        bool isvalid;    // ��ʶ�ð�Ȩ�Ƿ���Ч
        string alltime;  // ����ʱ�䣬beg_time # end_time # modified
    }

    struct Record {      // һ����Ȩ��¼
        address user;    // ����Ȩ�˵�ַ
        address author;  // ��Ȩ��/��Ȩӵ���˵�ַ
        string alltime;  // ����ʱ�䣬beg_time # end_time # modified
        string music;    // bin # mname # singer 
        string info;     // applicantName # phone # use # location # length # text # price # owner
        string genre;    //����7-4 9:13 ��ʾ��Ȩ��¼���ͣ�transfer��authorize��cancel��
    }

    struct UserEntity { // ������û�ʵ��������κΣ������ڵ㣬�û�����ҵ
        string name;    // �û�ʵ�������
        string kind;    // �û����� - user,company,musician,judge
        string id;      // ��ҵ��Ż����֤
        string location;
        string phone;
        string email;
    }

    struct Notice {     // һ��ϵͳ֪ͨ
        address start;  // ֪ͨ����
        address to;     // ���շ�
        string music;   // mname # singer # recordTime # applyTime
        string info;    // applicantName # phone # use # location # length # text # price
        bool valid;     // �Ƿ���Ȩ
    }

    mapping(address => UserEntity) account;  // ÿ����ַ��Ӧһ���û�ʵ��

    Music[] musics;     // ��¼�������е����ְ�Ȩ��Ϣ
    Record[] records;   // ��¼�������е���Ȩ��Ϣ
    Notice[] notices;   // ��¼����֪ͨ��Ϣ

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

    function transferMusic(address _to, string _binhash, string _alltime,string m,string i) public {
        address owner = msg.sender;
        uint8 num = 0;
        //string gen = "transfer";
        //string m = getM(_to,msg.sender);
        //string i = getI(_to,msg.sender);
        for (num = 0; num < musics.length; num++){
            if(owner == musics[num].owner && keccak256(musics[num].bin) == keccak256(_binhash)){   //modified
                musics[num].owner = _to;
                musics[num].alltime = _alltime;
                records.push(Record(_to, msg.sender, _alltime,m, i,"transfer"));
            }
        }
    }


    function cancelMusic(string _binhash, string _alltime, string m, string i) public {
        uint8 num = 0;
        address owner = msg.sender;
        //string gen = "cancel";
        for(num = 0; num < musics.length; num++){
            if(musics[num].owner == owner && keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].isvalid == true){
                musics[num].isvalid = false;
                musics[num].alltime = _alltime;
                records.push(Record(msg.sender, msg.sender, _alltime, m, i,"cancel"));
            }
        }
    }

    function authorizeMusic(address _to, string _binhash, string _alltime, string _music, string _info) public {
        address owner = msg.sender;
        uint8 num = 0;
        //string gen = "authorize";
        for(num = 0; num < musics.length; num++){
            if(keccak256(musics[num].bin) == keccak256(_binhash) && musics[num].owner == msg.sender){
                records.push(Record(_to, msg.sender, _alltime, _music, _info,"authorize"));//9:20 �޸� ������ 
            }
        }
    }

    function getMusic(uint numb) public view returns(address,string,string,string, bool,string){
        return (musics[numb].owner, musics[numb].bin, musics[numb].mname, musics[numb].singer, musics[numb].isvalid, musics[numb].alltime);
    }
    
    // new - get all musics that belong to msg.sender
    function getMusicNumber() public view returns(uint8[]) {
        uint8[] num2;
        for(uint8 i = 0; i < musics.length; i++){
            if (musics[i].isvalid && musics[i].owner == msg.sender) {
                num2.push(i);
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

    function getRecord(uint numbe) public view returns(address,address,string,string,string,string){
        return (records[numbe].user,records[numbe].author,records[numbe].alltime,records[numbe].music,records[numbe].info,records[numbe].genre);
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

    function getHistory(string _music)public view returns (uint8[]){
        uint8 num1 = 0;
        uint8[] num3;
        uint8 count = 0;
        for(num1 = 0;num1 < records.length; num1++){
            if(keccak256(records[num1].music) == keccak256(_music)){
                //return main info
                num3[count] = num1;
                count++;
            }
        }
        return num3;
    }
}