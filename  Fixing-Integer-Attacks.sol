pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
contract BTC_Target{

    mapping(address => uint) balances;


  function batchTransfer(address[] memory _receivers, uint256 _value) public payable  returns (bool) {
    uint cnt = _receivers.length;
    uint256 amount = SafeMath.mul(uint256(cnt) ,_value);
    require(cnt > 0 && cnt <= 20);
    require(_value > 0 && balances[msg.sender] >= amount);

    balances[msg.sender] = SafeMath.sub(balances[msg.sender],amount) ;
    for (uint i = 0; i < cnt; i++) {
        balances[_receivers[i]] = SafeMath.add(balances[_receivers[i]],_value);
       // Transfer(msg.sender, _receivers[i], _value);
    }
    return true;
  }

  function deposit() public payable{
      balances[msg.sender] += msg.value;
  }

  function getBalance() public view returns(uint ){
      return balances[msg.sender];
  }

}