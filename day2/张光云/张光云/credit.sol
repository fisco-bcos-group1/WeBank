pragma solidity ^0.4.24;

contract credit {

    //总积分
    uint sumCredits;
    uint numberUser;
    address shoper;
    mapping(address => uint) userCredits;
    
    event transferEvent(address _from, address _to, uint256 value);
    
    //initialize
    constructor(uint _sumCredits) public{
        require(_sumCredits > 0);
        sumCredits = _sumCredits;
        userCredits[msg.sender] = _sumCredits;
        shoper = msg.sender;
        numberUser = 1;
    }
    
    //query the sum of credits
    function querySum() public view returns(uint){
        return sumCredits;
    }
    
   
    //account initialize
    function register(uint _consumeMoney) public {
        require(_consumeMoney > 0);
        numberUser++;
        userCredits[msg.sender] = 0;
        tran(shoper, msg.sender, _consumeMoney);
    }
    
    //transaction between two accounts
    function tran(address _from, address _to, uint _cre) internal {
        
        require(_to != 0x0);
        require(userCredits[_from] >= _cre);
        
        userCredits[_to] = userCredits[_to] + _cre;
        userCredits[_from] = userCredits[_from] - _cre;
        
        emit transferEvent(_from, _to, _cre);
    }
    
    //transfer to an account
    function transfer(address _to, uint _number) public {
        tran(msg.sender, _to, _number);
    }
    
    //query account's credits
    function query() public view returns(uint) {
        return userCredits[msg.sender];
    }
    
    //use money and get credits
    function consumeMoney(uint _money) public{
        tran(shoper, msg.sender, _money);
    }
    
    //use credits to 
    function consumeCredit(uint _number) public {
        tran(msg.sender, shoper, _number);
    }

}