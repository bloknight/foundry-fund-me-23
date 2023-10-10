// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public config;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 200000000000;

    constructor() {
        if(block.chainid == 11155111) {
            config = getSepoliaEthConfig();
        } else if(block.chainid == 1) {
            config = getMainnetEthConfig();
        } else {
            config = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }   

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
    }  
        
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (config.priceFeed != address(0)) {
            return config;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        return NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
    } 

}