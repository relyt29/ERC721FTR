// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "src/Example.sol";


interface Vm {
    function prank(address from) external;
    function startPrank(address from) external;
    function stopPrank() external;
    function deal(address who, uint256 amount) external;
    function expectRevert(bytes calldata expectedError) external;
}

interface WETH0 {
    function transfer(address _to, uint256 _value) external returns (bool success);
    function deposit() external payable;
}


contract ContractTest is DSTest {
    WETH0 constant public WETH = WETH0(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    FuckTheRichExample ftr;
    string expectedTokenURI = "data:application/json;base64,eyJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIQnlaWE5sY25abFFYTndaV04wVW1GMGFXODlJbmhOYVc1WlRXbHVJRzFsWlhRaUlIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJajQ4YzNSNWJHVStkR1Y0ZEh0bWFXeHNPaUIzYUdsMFpUc2dkMmhwZEdVdGMzQmhZMlU2Y0hKbE95Qm1iMjUwTFdaaGJXbHNlVG9nUTI5MWNtbGxjaUJPWlhjN0lHWnZiblF0YzJsNlpUb2dNemh3ZUR0OVBDOXpkSGxzWlQ0OGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NDhkR1Y0ZENCNFBTSXhNeUlnZVQwaU1UWXdJajVHZFdOcklIUm9aU0J5YVdOb0xqd3ZkR1Y0ZEQ0OEwzTjJaejQ9IiwibmFtZSI6IkZ1Y2sgdGhlIFJpY2ggTkZUIn0K";
    address beef = address(0xbeef);
    address cafe = address(0xcafe);

    function setUp() public {
        ftr = new FuckTheRichExample();
    }

    function testMint() public {
        vm.prank(beef);
        ftr.mint(1);
        assertEq(ftr.tokenURI(0), expectedTokenURI);
    }

    function testFMint() public {
        vm.deal(beef, 2 ether);
        vm.startPrank(beef);
        vm.expectRevert("UNALLOWED_TOO_RICH_RECIPIENT");
        ftr.mint(1);
        vm.stopPrank();
    }

    function testFMintWETH() public {
        vm.deal(cafe, 2 ether);
        vm.startPrank(cafe);
        WETH.deposit{value: 1.5 ether}();
        WETH.transfer(beef, 1.5 ether);
        vm.stopPrank();
        vm.startPrank(beef);
        vm.expectRevert("UNALLOWED_TOO_RICH_RECIPIENT_WETH");
        ftr.mint(1);
        vm.stopPrank();
    }

    function testMintAndTransfer() public {
        vm.startPrank(beef);
        ftr.mint(1);
        ftr.transferFrom(beef, cafe, 0);
        vm.stopPrank();
    }

    function testFTransfer() public {
        vm.deal(cafe, 2 ether);
        vm.startPrank(beef);
        ftr.mint(1);
        vm.expectRevert("UNALLOWED_TOO_RICH_RECIPIENT");
        ftr.transferFrom(beef, cafe, 0);
        vm.stopPrank();
    }

    function testFTransferWETH() public {
        vm.deal(cafe, 2 ether);
        vm.prank(cafe);
        WETH.deposit{value: 1.9 ether}();
        vm.startPrank(beef);
        ftr.mint(1);
        vm.expectRevert("UNALLOWED_TOO_RICH_RECIPIENT_WETH");
        ftr.transferFrom(beef, cafe, 0);
        vm.stopPrank();
    }

    function testMintTooMuch() public {
        vm.startPrank(beef);
        vm.expectRevert("ERR_NONE_LEFT");
        ftr.mint(10001);
        vm.stopPrank();
    }

    function testTokenURI1000() public {
        vm.prank(beef);
        ftr.mint(1000);
        for(uint i = 0; i < 1000; i++)
            assertEq(ftr.tokenURI(i), expectedTokenURI);
    }

    function testTokenURI9000() public {
        vm.prank(beef);
        ftr.mint(10000);
        for(uint i = 9000; i < 10000; i++)
            assertEq(ftr.tokenURI(i), expectedTokenURI);
        vm.expectRevert("OUT_OF_BOUNDS");
        ftr.tokenURI(10000);
    }
}
