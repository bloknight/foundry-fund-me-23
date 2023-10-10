// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Fund} from "../../script/Interactions.s.sol";
import {Withdraw} from "../../script/Interactions.s.sol";

contract FundMeIT is Test {

    FundMe fundMe;
    address user = makeAddr("user");
    uint256 constant STARTING_BALANCE = 1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, STARTING_BALANCE);
    }

    function testUserCanInteract() external {
        Fund fund = new Fund();
        fund.fund(address(fundMe));

        Withdraw withdraw = new Withdraw();
        withdraw.withdraw(address(fundMe));

        assert(address(fundMe).balance == 0);
    }

}
