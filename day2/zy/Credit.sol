pragma solidity ^0.4.25;

contract Credit{
    string name = "zy_credit";
    string symbol = "zy";
    uint256 totalSupply;

    mapping(address => uint256) public balances;

    event transferEvent(address _from, address _to, uint value);

    constructor (string _creditName, string _creditSymbol, uint _initSupply) public {
        totalSupply = _initSupply;
        balances[msg.sender] = totalSupply;
        name = _creditName;
        symbol = _creditSymbol;
    }

    function getTotalSupply() public view returns (uint) {
        return totalSupply;
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        require(balances[_to] + _value > balances[_to]);

        uint preBalances = balances[_from] + balances[_to];

        balances[_from] -= _value;
        balances[_to] += _value;
        emit transferEvent(_from, _to, _value);
        assert(balances[_from] + balances[_to] == preBalances);
    }

    function transfer(address _to, uint _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}