// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Mint_contract.sol";

contract TestContract is Test {
    Mint_contract m;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        m = new Mint_contract();
    }


    // Mint
    function testMint() public {
        m.mint(address(this), 100);
        assertEq(m.balanceOf(address(this)), 100, "OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7),0 , "OK");
    }

    // Transfer
    function testTransfer() public{
        m.mint(address(this), 100);
        m.transfer(0x7361360D60BE09274EccfebAb510753cA894a7d7, 50);

        assertEq(m.balanceOf(address(this)), 50, "OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7), 50, "OK");

        // Now we change the owner
        vm.prank(0x7361360D60BE09274EccfebAb510753cA894a7d7);
        // Now transfer from the new owner to the previous owner
        m.transfer(address(this), 50);

        assertEq(m.balanceOf(address(this)), 100, "OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7), 0, "OK");
    }

    // Approval
    function testApproval() public {
        m.mint(address(this), 100);

        // This new address has the permission to spend upto 10 tokens of the contract (address(this))
        m.approve(0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);

        // Allowance_     owner address, spender address
        assertEq(m.allowance(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7), 10);
        assertEq(m.allowance(0x7361360D60BE09274EccfebAb510753cA894a7d7, address(this)), 0);

        // Change the owner......0x7361360D60BE09274EccfebAb510753cA894a7d7 is the new owner 
        vm.prank(0x7361360D60BE09274EccfebAb510753cA894a7d7);

        // Now transfer from the new owner to the previous owner
        m.transferFrom(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7, 5);

        assertEq(m.balanceOf(address(this)), 95 ,"OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7), 5, "OK");
        assertEq(m.allowance(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7), 5);
    }


    // Testing Transfer event
    function testTransfer_event() public {
        m.mint(address(this), 100);

        // We are expecting the event
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);

        // We are actually calling the event
        m.transfer(0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);
    }

    // Testing Approval event
    function testApproval_event() public {
        m.mint(address(this), 100);

        // We are expecting the Approval event
        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);

        // We are actually calling the Approval event
        m.approve(0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);

        // Now change the owner of the contract
        vm.prank(0x7361360D60BE09274EccfebAb510753cA894a7d7);

        // Now do transferFrom
        m.transferFrom(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7, 10);
    }


    // VM Deal
    function test_DealExample() public {
        address token = 0x7361360D60BE09274EccfebAb510753cA894a7d7;
        uint256 amount = 10 ether;
        // Deal is used to =>    Set the balance of "account" to "10 ether"
        vm.deal(token, amount);

        // Assert that the balance is set correctly
        assertEq(address(token).balance, amount, "ok");
    }

    
}