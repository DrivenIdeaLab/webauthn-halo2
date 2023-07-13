// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import "../src/core/EntryPoint.sol";
import "../src/P256Account.sol";
import "../src/P256AccountFactory.sol";

contract CounterTest is Test {
    Counter public counter;
    EntryPoint public entryPoint;
    P256AccountFactory public accountFactory;
    P256Account public account;

    // -------------------- 🧑‍🍼 Account Creation Constants 🧑‍🍼 --------------------
    bytes constant publicKey = "iliketturtles";
    bytes32 constant salt = keccak256("iwanttoberichardwhenigrowup");

    /**
     * Deploy the Entrypoint, AccountFactory, and a single account
     */
    function setUp() public {
        entryPoint = new EntryPoint();
        accountFactory = new P256AccountFactory();
        bytes memory constructorArgs = abi.encode(entryPoint, publicKey);
        bytes memory initializationCode = abi.encodePacked(
            type(P256Account).creationCode,
            constructorArgs
        );
        account = P256Account(payable(accountFactory.create(salt, initializationCode)));
    }

    /**
     * Test that the account was created correctly with the correct parameters
     */
    function testCreation() public {
        assertEq(account.nonce(), 0);
        assertEq(account.publicKey(), publicKey);
    }
}
