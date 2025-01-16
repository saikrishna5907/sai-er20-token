// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeploySaiToken} from "../../script/DeploySaiToken.s.sol";
import {SaiToken} from "../../src/SaiToken.sol";

contract SaiTokenTest is Test {
    SaiToken public saiToken;
    DeploySaiToken public saiTokenDeployer;

    address address1 = makeAddr("address1");
    address address2 = makeAddr("address2");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        saiTokenDeployer = new DeploySaiToken();
        saiToken = saiTokenDeployer.run();

        vm.prank(msg.sender);
        saiToken.transfer(address1, STARTING_BALANCE);
    }

    function testAddress1Balance() public view {
        assert(saiToken.balanceOf(address1) == STARTING_BALANCE);
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 100;
        //    address1 approves address2 to spend 1000 tokens
        vm.prank(address1);
        saiToken.approve(address2, initialAllowance);

        //    address2 spends 100 tokens
        vm.prank(address2);
        saiToken.transferFrom(address1, address2, transferAmount);

        //    address2 should have 100 tokens
        assert(saiToken.balanceOf(address2) == transferAmount);

        //    address1 should have 900 tokens
        assert(saiToken.balanceOf(address1) == STARTING_BALANCE - transferAmount);

        //    address2 should have 900 tokens left to spend
        assert(saiToken.allowance(address1, address2) == initialAllowance - transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 100;
        //    address1 transfers 100 tokens to address2
        vm.prank(address1);
        saiToken.transfer(address2, transferAmount);

        //    address2 should have 100 tokens
        assert(saiToken.balanceOf(address2) == transferAmount);

        //    address1 should have STARTING_BALANCE minus the transfered amount
        assert(saiToken.balanceOf(address1) == STARTING_BALANCE - transferAmount);
    }

    function testBalanceAfterTransfer() public {
        uint256 transferAmount = 100;
        //    address1 transfers 100 tokens to address2
        uint256 receiverInitialBalance = saiToken.balanceOf(address2);
        vm.prank(address1);
        saiToken.transfer(address2, transferAmount);

        //    address1 should have STARTING_BALANCE minus the transfered amount
        assert(saiToken.balanceOf(address1) == STARTING_BALANCE - transferAmount);
        assertEq(receiverInitialBalance + transferAmount, saiToken.balanceOf(address2));
    }

    function testAddressZeroError() public {
        //    address1 transfers 100 tokens to address(0)
        uint256 transferAmount = 100;
        vm.expectRevert();
        saiToken.transfer(address(0), transferAmount);
    }

    function testMintFunction() public {
        uint256 mintAmount = 100;
        //    address1 mints 100 tokens
    }
}
