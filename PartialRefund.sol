// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PartialRefund is Ownable, ERC20 {

    constructor(uint256 initialSupply) ERC20("TestToken", "TEST") {
        _mint(msg.sender, initialSupply);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        if(to == address(this)){
            sellBack(amount);
        }
    }

    function sellBack(uint _amount) internal {
        require(balanceOf(msg.sender) >= _amount, "Insufficient token funds");
        uint ether_multiplier = _amount / 1000;
        uint ether_needed = 0.5 ether * ether_multiplier;
        address payable self = payable(address(this));
        require(self.balance >= ether_needed, "Not enough ETH in contract to complete transaction");
        payable(msg.sender).transfer(ether_needed);
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