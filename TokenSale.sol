// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20TokenSale is Ownable, ERC20 {

    constructor(uint256 initialSupply) ERC20("TestToken", "TEST") {
        _mint(msg.sender, initialSupply);
    }

    function mintTokens() public payable returns (bool success) {
        require(msg.value == 1 ether, "Insuffienct funds to mint tokens. Cost is 1 ether.");
        require(totalSupply() < 1000000, "Token sale has reached one million tokens. Token sale is over.");
        _mint(msg.sender, 1000);
        return true;
    }

    function withdrawSaleFunds() external onlyOwner returns (bool) {
        address self = address(this);
        require(payable(self).balance > 0, "Balance is empty. Nothing to transfer.");
        payable(msg.sender).transfer(payable(self).balance);
        return true;
    }

}