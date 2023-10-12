// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";


contract FractionalNFT is ERC20, Ownable, ERC721Holder{
    // state variables
    uint256 private __totalSupply;
    uint256 public curatorFee;

    struct saleItem{
        uint256 price;
        bool canReedeem;
        bool forSale;

    }
    constructor(
        uint256 _totalSupply,
        uint256 _curatorFee
    ) Ownable(msg.sender) ERC20("Fractional NFT","FNTS"){
        __totalSupply = _totalSupply * 10 ** 18;
        curatorFee = _curatorFee;
        _mint(msg.sender,1000000000 * 10 ** 18);
    }

    mapping(address => mapping(address => mapping(uint256 => uint256))) public FractionalNFTHoldings; // User address to tokenId to Fraction Holdings

    //mapping for Checking if the current Contract holds the nft or not
    mapping(address => mapping(uint256 => bool)) public tokenIdexists;
    mapping(address => mapping(uint256 => saleItem)) public itemForSale;

    function totalSupply () public view override returns(uint256){
        return __totalSupply;
    }

    function fractionalbalanceOf (
        address _user,
        address _nftContract,
        uint256 _tokenId
    ) public view returns(uint256){
        return FractionalNFTHoldings[_user][_nftContract][_tokenId];
    }

    function fractionalize(
        address _nftCollection,
        uint256 tokenId,
        uint256 fractionalNFTAmount
    ) external returns(bool){
        require(_nftCollection != address(0), "Address Should not be a Zero Address");
        require(IERC721(_nftCollection).ownerOf(tokenId) == msg.sender ,"Not Authorised");
        require(fractionalNFTAmount <= __totalSupply, "Not enough Supply of the tokens");

        fractionalNFTAmount = fractionalNFTAmount*(10 ** 18);
        IERC721(_nftCollection).safeTransferFrom(msg.sender, address(this), tokenId);
        _mint(msg.sender, fractionalNFTAmount); 

        FractionalNFTHoldings[msg.sender][_nftCollection][tokenId] = FractionalNFTHoldings[msg.sender][_nftCollection][tokenId]+(fractionalNFTAmount); // update the Holdings balance

        return true;
    }

    function putforSale (
        address _nftContract,
        uint256 _tokenId,
        uint256 _price
    ) external onlyOwner{
        require(_nftContract != address(0), "Address Should not be a Zero Address");
        require(tokenIdexists[_nftContract][_tokenId], "Contract does not have the ownership of the provided NFT");
        require(_price > 0, "Minimum amount put for Sale should be greater than zero");

        itemForSale[_nftContract][_tokenId].price = _price;
        itemForSale[_nftContract][_tokenId].forSale = true;
        itemForSale[_nftContract][_tokenId].canReedeem = false;

    }

    function purchase(
        address _nftContract,
        uint256 _tokenId
    ) external payable{
        require(itemForSale[_nftContract][_tokenId].forSale, "NFT not for Sale!!!!!");
        require(msg.value == itemForSale[_nftContract][_tokenId].price, "Value sent should be equal to the sale Price");

        itemForSale[_nftContract][_tokenId].forSale = false;
        itemForSale[_nftContract][_tokenId].canReedeem = true;

        IERC721(_nftContract).safeTransferFrom(address(this),msg.sender,_tokenId);

        uint256 _curatorFee = ((itemForSale[_nftContract][_tokenId].price)*(curatorFee))/(100);
        payable(owner()).transfer(_curatorFee);

        // emit the event
        emit PurchaseCreated(
            _nftContract,
            _tokenId,
            itemForSale[_nftContract][_tokenId].price,
            itemForSale[_nftContract][_tokenId].canReedeem
        );
        
    }  

    function redeem(
        address _nftContract,
        uint256 _tokenId, 
        uint256 _amount
    ) external {
        require(_nftContract != address(0), "Address Should not be a Zero Address");
        require(itemForSale[_nftContract][_tokenId].forSale , "Item Not purchased Yet!!!");
        require(itemForSale[_nftContract][_tokenId].canReedeem , "Redemption not available!!!");

        _amount = _amount *(10 ** 18);
        uint256 toReedeem = (itemForSale[_nftContract][_tokenId].price);
        uint256 _curatorFee = ((itemForSale[_nftContract][_tokenId].price)*(curatorFee))/(100);

        toReedeem = (toReedeem-(_curatorFee))/(_amount);
        __totalSupply = __totalSupply-(_amount);
        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(toReedeem);
        
    }
    
}
