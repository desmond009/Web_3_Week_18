// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/Counter.sol";

contract TestContract is Test {
    Counter c;

    function setUp() public {
        // Basically the same as `Counter c = new Counter();`
        c = new Counter(3);
    }

    function testIncrement() public {
        c.increment();
        c.increment();
        assertEq(c.getNum(), 5, "OK");
    }

    function testDecrement() public {
        c.decrement();
        c.decrement();
        c.decrement();
    }
}
