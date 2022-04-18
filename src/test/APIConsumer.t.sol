// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../APIConsumer.sol";
import "./mocks/LinkToken.sol";
import "ds-test/test.sol";
import "./mocks/MockOracle.sol";

contract APIConsumerTest is DSTest {
    APIConsumer public apiConsumer;
    LinkToken public linkToken;
    MockOracle public mockOracle;

    bytes32 jobId;
    uint256 fee;
    bytes32 blank_bytes32;

    uint256 constant AMOUNT = 1 * 10**18;
    uint256 constant RESPONSE = 777;

    function setUp() public {
        linkToken = new LinkToken();
        mockOracle = new MockOracle(address(linkToken));
        apiConsumer = new APIConsumer(
            address(mockOracle),
            jobId,
            fee,
            address(linkToken)
        );
        linkToken.transfer(address(apiConsumer), AMOUNT);
    }

    function test_can_make_request() public {
        bytes32 requestId = apiConsumer.requestVolumeData();
        assertTrue(requestId != blank_bytes32);
    }

    function test_can_get_response() public {
        bytes32 requestId = apiConsumer.requestVolumeData();
        mockOracle.fulfillOracleRequest(requestId, bytes32(RESPONSE));
        assertTrue(apiConsumer.volume() == RESPONSE);
    }
}
