// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SubscriptionContract is Ownable {
    struct payments {
        uint256 paymentStartTime;
        uint256 paymentExpireTime;
    }

    mapping(address => payments) public usersPayment;

    uint256 public subscriptionPrice;

    constructor(uint256 _subscriptionPrice) {
        setSubscriptionPrice(_subscriptionPrice);
    }

    function subscribe(uint256 _subscriptionPeriod) public payable  {
        require( msg.value == _subscriptionPeriod * subscriptionPrice, "please send the exact subscription price amount");
        usersPayment[_msgSender()].paymentStartTime = block.timestamp;
        usersPayment[_msgSender()].paymentExpireTime = block.timestamp +_subscriptionPeriod * 30 days;
    }


    function paymentsInSmartContract() public view returns (uint256) {
        return address(this).balance;
    }

    //onwer functions
    function withdraw() public onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
    }

    function setSubscriptionPrice(uint256 _newPrice) public onlyOwner {
        subscriptionPrice = _newPrice;
    }

}
