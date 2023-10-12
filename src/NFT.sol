// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, Ownable {
    constructor()
        ERC721("MyToken", "MTK")
        Ownable(msg.sender)
    {}

    function safeMint(uint256 tokenId) public onlyOwner {
        _safeMint(msg.sender, tokenId);
    }
}
