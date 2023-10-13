// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol";

interface INFTContract {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}


contract FractionalNFTMarketplace {
    uint256 public constant COMMISSION_PERCENT = 100; // 0.1% commission

    address public marketPlaceDeployer;
    uint256 public fractionalNFTCounter;

    struct FractionalNFT {
        address owner;
        uint256 nftId;
        uint256 totalShares;
        uint256 availableShares;
        address tokenAddress;
    }

    mapping(uint256 => FractionalNFT) public fractions;
    mapping(uint256 => mapping(address => uint256)) public userShares;

    event FractionalNFTAdded(uint256 indexed fractionalNftId, uint256 nftId, uint256 totalShares);
    event SharesPurchased(address indexed buyer, uint256 indexed fractionalNftId, uint256 sharesAmount);
    event SharesSold(address indexed seller, uint256 indexed fractionalNftId, uint256 sharesAmount);
    event NFTTransferred(address indexed oldOwner, address indexed newOwner, uint256 fractionalNftId);
    event FractionalNFTListed(uint256 indexed fractionalNftId, uint256 sharesListed, uint256 pricePerShare);

    constructor() {
        marketPlaceDeployer = msg.sender;
        fractionalNFTCounter = 0;
    }

    function addFractionalNFT(
        uint256 nftId,
        uint256 totalShares,
        // string memory tokenName,
        // string memory tokenSymbol,
        address nftContractAddress,
        address tokenAddress
    ) external {
        require(nftId != 0, "NFT ID cannot be zero");
        require(totalShares > 0, "Total shares must be greater than zero");
        require(totalShares <= 1000, "Maximum 100 shares allowed");

        // Check if the NFT contract supports the ERC721 interface
        require(
            IERC721(nftContractAddress).ownerOf(nftId) == msg.sender,
            "Caller must be NFT owner"
        );

        fractionalNFTCounter++;

        // Transfer the NFT to this contract using the transferFrom function
        IERC721(nftContractAddress).transferFrom(msg.sender, address(this), nftId);

        // Create a new ERC20 token for the fractional NFT
        // address tokenAddress = address(new ERC20Token(tokenName, tokenSymbol));

        fractions[fractionalNFTCounter] = FractionalNFT(
            msg.sender,
            nftId,
            totalShares,
            totalShares,
            tokenAddress
        );
        // mapping(uint256 => mapping(address => uint256)) public userShares;
        userShares[fractionalNFTCounter][msg.sender] = totalShares;
        ERC20Token(tokenAddress).mint(msg.sender, totalShares);

        emit FractionalNFTAdded(fractionalNFTCounter, nftId, totalShares);
    }

    // Function to query the share balance for a specific address
    function getShareBalance(uint256 fractionalNftId, address account) external returns (uint256) {
        FractionalNFT storage fractionalNFT = fractions[fractionalNftId];
        require(fractionalNftId > 0 && fractionalNftId <= fractionalNFTCounter, "Invalid fractional NFT ID");
        return userShares[fractionalNftId][account] = fractionalNFT.availableShares;
    }

    function listFractionalNFTForSale(uint256 fractionalNftId, uint256 sharesListed, uint256 pricePerShare) external {
        FractionalNFT storage fractionalNFT = fractions[fractionalNftId];
        require(fractionalNFT.owner == msg.sender, "You are not the fractional NFT owner");
        require(sharesListed > 0 && sharesListed <= fractionalNFT.availableShares, "Invalid number of shares to be listed");

        ERC20 token = ERC20(fractionalNFT.tokenAddress);
        // token.approve(address(this), sharesListed);
        // token.allowance(msg.sender, address(this)) >= sharesListed;
        // token.transferFrom(msg.sender, address(this), sharesListed);
        require(token.approve(address(this), sharesListed), "Transfer of listed shares failed");

        uint remainderShares = fractionalNFT.availableShares -= sharesListed;
        fractionalNFT.availableShares = remainderShares;
        userShares[fractionalNFTCounter][msg.sender] = remainderShares;

        emit FractionalNFTListed(fractionalNftId, sharesListed, pricePerShare);
    } 
    
    function purchaseShares(uint256 fractionalNftId, uint256 sharesAmount) external payable {
        require(sharesAmount > 0, "Shares amount must be greater than zero");
        require(fractionalNFTCounter > 0 && fractionalNftId <= fractionalNFTCounter, "Invalid fractional NFT ID");
        
        FractionalNFT storage fractionalNft = fractions[fractionalNftId];
        require(fractionalNft.availableShares >= sharesAmount, "Insufficient available shares");
        
        uint256 sharePrice = msg.value / sharesAmount;
        uint256 totalCost = sharePrice * sharesAmount;
        require(msg.value >= totalCost, "Insufficient ETH provided");
        
        ERC20Token fractionalToken = ERC20Token(fractionalNft.tokenAddress);
        fractionalToken.transferFrom(fractionalNft.owner, msg.sender, sharesAmount);
        fractionalNft.availableShares -= sharesAmount;
        
        uint256 commissionAmount = totalCost * COMMISSION_PERCENT / 10000;
        payable(marketPlaceDeployer).transfer(commissionAmount);
        payable(fractionalNft.owner).transfer(totalCost - commissionAmount);
        
        emit SharesPurchased(msg.sender, fractionalNftId, sharesAmount);
    }
    
    function transferNFTOwnership(uint256 fractionalNftId, address newOwner) external {
        require(fractionalNFTCounter > 0 && fractionalNftId <= fractionalNFTCounter, "Invalid fractional NFT ID");
        require(fractions[fractionalNftId].owner == msg.sender, "Caller must be owner of the fractional NFT");
        
        fractions[fractionalNftId].owner = newOwner;
        emit NFTTransferred(msg.sender, newOwner, fractionalNftId);
    }
    
    
    function getFractionalNFTDetails(uint256 fractionalNftId) external view returns (
        address owner,
        uint256 nftId,
        uint256 totalShares,
        uint256 availableShares,
        address tokenAddress
    ) {
        require(fractionalNFTCounter > 0 && fractionalNftId <= fractionalNFTCounter, "Invalid fractional NFT ID");
        
        FractionalNFT storage fractionalNft = fractions[fractionalNftId];
        return (
            fractionalNft.owner,
            fractionalNft.nftId,
            fractionalNft.totalShares,
            fractionalNft.availableShares,
            fractionalNft.tokenAddress
        );
    }
    
}


contract ERC20Token is ERC20 {

    constructor() ERC20("Fractional NFTS", "FNFTS") {
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}


