pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract OpenWeatherConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    uint256 public result;

    constructor() public {
        setPublicChainlinkToken();
        oracle = 0xAA1DC356dc4B18f30C347798FD5379F3D77ABC5b;
        jobId = "235f8b1eeb364efc83c26d0bef2d0c01";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }
    
    /**
     * Initial request
     */
    function requestWeatherTemperature(string memory _city) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillWeatherTemperature.selector);
        req.add("city", _city);
        sendChainlinkRequestTo(oracle, req, fee);
    }
    
    /**
     * Callback function
     */
    function fulfillWeatherTemperature(bytes32 _requestId, uint256 _result) public recordChainlinkFulfillment(_requestId) {
        result = _result;
    }
}
