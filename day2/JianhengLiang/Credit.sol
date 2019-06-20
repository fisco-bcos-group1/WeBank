pragma solidity ^0.4.25;
contract Credit{
    string name = "BookstoreCredit";
    string symbol = "BKC";
    uint totalSupply;
    
    mapping(address => uint) public balances;
    
    event transferEvent(address _from, address _to, uint value);
    
    constructor(string _name, string _symbol, uint _initSupply) public {
        name = _name;
        symbol = _symbol;
        totalSupply = _initSupply;
        balances[msg.sender] = totalSupply;
    }
    
    function getTotalSupply() public view returns (uint) {
        return totalSupply;
    }
    
    function _transfer(address _from, address _to, uint _value) internal{
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
        _transfer(msg.sender, _to, _value);
    }
    
    function balanceOf(address _owner) public view returns (uint){
        return balances[_owner];
    }
}