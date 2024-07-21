// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {SaiToken} from "../src/SaiToken.sol";

contract DeploySaiToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (SaiToken) {
        vm.startBroadcast();
        SaiToken token = new SaiToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return token;
    }
}
