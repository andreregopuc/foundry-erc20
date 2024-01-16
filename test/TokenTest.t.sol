// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "../script/Deploy.s.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token public tkn;
    DeployToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployToken();
        tkn = deployer.run();

        vm.prank(msg.sender);
        tkn.transfer(bob, STARTING_BALANCE);
        
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, tkn.balanceOf(bob));
    }

    function testAllowance() public {
        uint256 initAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        tkn.approve(alice, initAllowance);

        vm.prank(alice);
        uint256 amount = 500;
        tkn.transferFrom(bob, alice, amount);

        assertEq(tkn.balanceOf(alice), amount);
        assertEq(tkn.balanceOf(bob), STARTING_BALANCE - amount);
    }

}