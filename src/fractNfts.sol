// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/interfaces/IERC721.sol";
// // lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol

// contract NFTFractionalizationPlatform is IERC20, ERC20 {

//     uint256 public platformFeePercentage; // Platform fee percentage (0.1% = 10 basis points).
//     address public feeCollector; // Address to collect platform fees.
//      IERC721 NFT;

//     // Mapping of NFT addresses and IDs to the corresponding ERC-20 tokens.
//     mapping(address => mapping(uint256 => address)) public nftToToken;

//     event NFTTokenized(address indexed nftAddress, uint256 indexed nftId, uint256 totalShares, string name);

//     constructor(
//         address _NFTs,
//         uint256 _platformFeePercentage,
//         address _feeCollector
//     ) ERC20("FNTS", "nTS") {
//         NFT = IERC721(_NFTs);
//         platformFeePercentage = _platformFeePercentage;
//         feeCollector = _feeCollector;
//     }

//     function setPlatformFeePercentage(uint256 _percentage) external {
//         platformFeePercentage = _percentage;
//     }

//     function setFeeCollector(address _collector) external {
//         feeCollector = _collector;
//     }

//     function tokenizeNFT(
//         address _nftAddress,
//         uint256 _nftId,
//         uint256 _totalShares,
//         string memory _name
//     ) external {
//         require(nftToToken[_nftAddress][_nftId] == address(0), "NFT address can not be address 0");

//         NFT.safeTransferFrom(msg.sender, address(this), tokenId);
//         // Mint the NFT shares to the caller.
//         _mint(msg.sender, _totalShares);
//         nftToToken[_nftAddress][_nftId] = address(this);

//         emit NFTTokenized(_nftAddress, _nftId, _totalShares, _name);
//     }

//     function listNFTShares(
//         address _nftAddress,
//         uint256 _nftId,
//         uint256 _totalShares,
//         uint256 _priceInWei
//     ) external {
//         require(nftToToken[_nftAddress][_nftId] == address(this), "NFT is not tokenized");
//         require(_totalShares > 0, "Total shares must be greater than 0");
//         require(_priceInWei > 0, "Price must be greater than 0");

//         // Approve the transfer of shares to this contract.
//         approve(address(this), _totalShares);

//         // Transfer NFT shares to this contract for listing.
//         transferFrom(msg.sender, address(this), _totalShares);

//         // Emit an event for the listing.
//         // emit ListingCreated(msg.sender, _nftAddress, _nftId, _totalShares, _priceInWei);
//     }

//     function purchaseNFTShares(
//         address _nftAddress,
//         uint256 _nftId,
//         uint256 _sharesToBuy
//     ) external {
//         require(nftToToken[_nftAddress][_nftId] == address(this), "NFT is not tokenized");
//         require(_sharesToBuy > 0, "Shares to buy must be greater than 0");

//         // Calculate the purchase amount, including platform fee.
//         uint256 purchaseAmount = calculatePurchaseAmount(_nftAddress, _nftId, _sharesToBuy);

//         // Transfer the purchase amount from the buyer to this contract.
//         transferToContract(purchaseAmount);

//         // Transfer NFT shares from the seller to the buyer.
//         transferShares(msg.sender, msg.sender, _nftAddress, _nftId, _sharesToBuy);

//         // Emit an event for the purchase.
//         // emit PurchaseMade(msg.sender, _nftAddress, _nftId, _sharesToBuy, purchaseAmount);
//     }

//     function calculatePurchaseAmount(address _nftAddress, uint256 _nftId, uint256 _sharesToBuy)
//         internal
//         view
//         returns (uint256)
//     {
//         uint256 priceInWei = getListingPrice(_nftAddress, _nftId);
//         uint256 totalShares = totalSupply();

//         // Calculate the purchase amount with platform fee.
//         uint256 purchaseAmount = (priceInWei * (_sharesToBuy)) /(totalShares);

//         uint256 platformFee = (purchaseAmount * (platformFeePercentage)) / (10000); // Convert basis points to percentage.
//         purchaseAmount = (purchaseAmount) - (platformFee);

//         return purchaseAmount;
//     }


//     function transferShares(
//         address _from,
//         address _to,
//         address _nftAddress,
//         uint256 _nftId,
//         uint256 _shares
//     ) internal {
//         require(nftToToken[_nftAddress][_nftId] == address(this), "NFT is not tokenized");
//         require(balanceOf(_from) >= _shares, "Insufficient shares to transfer");

//         transferFrom(_from, _to, _shares);
//     }

// }
