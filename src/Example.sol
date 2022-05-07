// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.13;

import "./ERC721FTR.sol";

contract FuckTheRichExample is ERC721FTR {

    uint public totalSupply = 0;
    uint public constant MAX_SUPPLY = 10000;

    constructor() ERC721FTR(1 ether) ERC721("Fuck the Rich", "ERC721FTR") {}

    function mint(uint num) public {
        require(totalSupply + num <= MAX_SUPPLY, "ERR_NONE_LEFT");
        uint beforeSupply = totalSupply;
        totalSupply = totalSupply + num;
        for (uint i = 0; i < num; i++)
            ERC721._safeMint(msg.sender, beforeSupply+i);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(id < MAX_SUPPLY, "OUT_OF_BOUNDS");
        require(ownerOf(id) != address(0), "NO_EXIST");
        return "data:application/json;base64,eyJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIQnlaWE5sY25abFFYTndaV04wVW1GMGFXODlJbmhOYVc1WlRXbHVJRzFsWlhRaUlIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJajQ4YzNSNWJHVStkR1Y0ZEh0bWFXeHNPaUIzYUdsMFpUc2dkMmhwZEdVdGMzQmhZMlU2Y0hKbE95Qm1iMjUwTFdaaGJXbHNlVG9nUTI5MWNtbGxjaUJPWlhjN0lHWnZiblF0YzJsNlpUb2dNemh3ZUR0OVBDOXpkSGxzWlQ0OGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NDhkR1Y0ZENCNFBTSXhNeUlnZVQwaU1UWXdJajVHZFdOcklIUm9aU0J5YVdOb0xqd3ZkR1Y0ZEQ0OEwzTjJaejQ9IiwibmFtZSI6IkZ1Y2sgdGhlIFJpY2ggTkZUIn0K";
    }
}

