pragma solidity ^0.4.15;

contract Victim {
  uint withdrawableBalance = 2 ether;
  uint a = 3 ether;
  function withdraw() {
    if (!msg.sender.call.value(a)()) {
      throw;
    }
		
    withdrawableBalance = withdrawableBalance - a;
  }

  function deposit() payable {
    withdrawableBalance = msg.value;
  }
}
