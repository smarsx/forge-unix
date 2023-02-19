// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {Unix} from "../lib/unix/src/Unix.sol";
import {Command} from "../lib/unix/src/Command.sol";

contract UnixTest is Test {
    using Unix for *;

    function setUp() public {}

    function testRaw() public {
        (uint256 success, bytes memory data) = "echo Hello World".run();
        assertEq(success, 1);
        assertEq(string(data), "Hello World");
        console2.log(string.concat("\nEchoed: \"", string(data), "\""));
    }

    /*
    [FAIL. Reason: Failed to execute command: No such file or directory (os error 2)]
    */

    function testStrong() public {
        Command echo = Unix.echo().n().stdout("Hello World");
        (uint256 success, bytes memory data) = Unix.run(echo);
        assertEq(success, 1);
        assertEq(string(data), "Hello World");
        console2.log(string.concat("\nEchoed: \"", string(data), "\""));
    }

    /*
    error[9574]: TypeError: Type contract Echo is not implicitly convertible to expected type contract Command.
    --> test/unix.t.sol:22:9:
    |
    22 |         Command echo = Unix.echo().n().stdout("Hello World");

    error[9582]: TypeError: Member "run" not found or not visible after argument-dependent lookup in type(library Unix).
    --> test/unix.t.sol:23:48:
    |
    23 |         (uint256 success, bytes memory data) = Unix.run(echo);
    */

    function testTester() public {
        (uint256 success, bytes memory data) = Unix.run("hello world");
        assertEq(success, 1);
        console2.log(vm.toString(data));
    }

    /*
    Running 1 test for test/unix.t.sol:UnixTest
    [FAIL. Reason: Failed to execute command: No such file or directory (os error 2)] testTester() (gas: 1972828)
    Test result: FAILED. 0 passed; 1 failed; finished in 3.40ms
    */
}
