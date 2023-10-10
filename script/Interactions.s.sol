// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract Fund is Script {

    uint256 constant SEND_VALUE = 0.01 ether;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fund(mostRecentlyDeployed);
    }

    function fund(address deployment) public {
        vm.startBroadcast();
        FundMe(payable(deployment)).fund{value: SEND_VALUE}();
        console.log("Funded %s with %s", deployment, SEND_VALUE);
        vm.stopBroadcast();
    }

}

contract Withdraw is Script {
    
    uint256 constant SEND_VALUE = 0.01 ether;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdraw(mostRecentlyDeployed);
    }

    function withdraw(address deployment) public {
        vm.startBroadcast();
        FundMe(deployment).withdraw();
        console.log("Withdrawn %s from %s", SEND_VALUE, deployment);
        vm.stopBroadcast();
    }

}