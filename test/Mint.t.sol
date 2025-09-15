// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Mint_contract.sol";

contract TestContract is Test {
    Mint_contract m;

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

        // Change the owner......0x7361360D60BE09274EccfebAb510753cA894a7d7 is the new owner 
        vm.prank(0x7361360D60BE09274EccfebAb510753cA894a7d7);

        // Now transfer from the new owner to the previous owner
        m.transferFrom(address(this), 0x7361360D60BE09274EccfebAb510753cA894a7d7, 5);

        assertEq(m.balanceOf(address(this)), 95 ,"OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7), 5, "OK");
    }
}