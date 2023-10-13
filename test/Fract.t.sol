// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FractionalNFTMarketplace} from "../src/NewFracts.sol";
import {ERC20Token} from "../src/NewFracts.sol";
import {MyToken} from "../src/NFT.sol";
import "./Helpers.sol";


contract FractionalNFTMarketplaceTest is Test {
    FractionalNFTMarketplace FractMarketplace;
    MyToken nft;
    ERC20Token FractsToken;


    function setUp() public {
        FractMarketplace = new FractionalNFTMarketplace();
        nft = new MyToken();
        FractsToken = new ERC20Token();
        
        // uint256 nftId = 1;
        // uint256 totalShares = 100;
        // address nftContractAddress = vm.addr(nft);
        // address tokenAddress = vm.addr(FractsToken);
        // uint256 percent = 50;

        address user1 = vm.addr(1);

        F = FractMarketplace.FractionalNFT({
            owner: address(0),
            nftId: 0,
            totalShares: 0,
            availableShares: 0,
            tokenAddress: address(0)
        });

        nft.safeMint(1);
    }

    function testAddFractionalNFT() public {
        uint256 nftId = 1;
        uint256 totalShares = 100;
        address nftContractAddress = vm.addr(nft);
        address tokenAddress = vm.addr(FractsToken);

        FractMarketplace.addFractionalNFT(nftId, totalShares, nftContractAddress, tokenAddress);
        FractionalNFTMarketplace.FractionalNFT memory fractionalNFT = FractMarketplace.fractions(1);

        assertEq(fractionalNFT.owner, address(this), "Owner should match");
        assertEq(fractionalNFT.nftId, nftId, "NFT ID should match");
        assertEq(fractionalNFT.totalShares, 100, "Total shares should be 100");
        assertEq(fractionalNFT.availableShares, 50, "Available shares should be 50");
    }

    // function testPurchaseShares() public payable {
    //     assertEq(FractMarketplace.availableShares(1), 100, "Available shares should be 100");

    //     // Purchase 50 shares
    //     FractMarketplace.purchaseShares{value: 1 ether}(1, 50);
    //     assertEq(FractMarketplace.availableShares(1), 50, "Available shares should be 50");

    //     // Check balances and shares for buyer and FractMarketplace
    //     assertEq(address(FractMarketplace).balance, 0.1 ether, "Marketplace balance should be 0.1 ether");
    //     assertEq(FractMarketplace.userShares(1, address(this)), 50, "Buyer should have 50 shares");

    //     // Try to purchase more shares than available
    //     bool success = FractMarketplace.purchaseShares{value: 1 ether}(1, 100);
    //     Assert.isFalse(success, "Should fail to purchase more shares than available");
    // }

    // function testWithdrawFunds() public {
    //     // Withdraw available funds
    //     FractMarketplace.withdrawFunds();

    //     // Check balances after withdrawal
    //     assertEq(address(FractMarketplace).balance, 0 ether, "Marketplace balance should be 0");
    //     assertEq(FractMarketplace.userShares(1, address(this)), 50, "Buyer shares should remain");

    //     // Try withdrawing from a different address
    //     (bool success, ) = address(FractMarketplace).call{value: 1 ether}(abi.encodeWithSignature("withdrawFunds()"));
    //     Assert.isFalse(success, "Should fail to withdraw funds from a different address");
    // }
}