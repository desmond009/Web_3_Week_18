// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Mint_contract.sol";

contract TestContract is Test {
    Mint_contract m;

    function setUp() public {
        m = new Mint_contract();
    }

    function testMint() public {
        m.mint(address(this), 100);
        assertEq(m.balanceOf(address(this)), 100, "OK");
        assertEq(m.balanceOf(0x7361360D60BE09274EccfebAb510753cA894a7d7),0 , "OK");
    }
}