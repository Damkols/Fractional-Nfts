FractionalNFTMarketplace contract:

```solidity
struct FractionalNFT {
 address owner;
 uint256 nftId;
 uint256 totalShares;
 uint256 availableShares;
 address tokenAddress;
}
```

- `struct FractionalNFT { ... }`: Defines a struct `FractionalNFT` to represent the fractional ownership of an NFT. It contains the following fields:
  - `owner`: The address of the owner of the fractional NFT.
  - `nftId`: The ID of the original NFT being fractionally owned.
  - `totalShares`: The total number of shares that correspond to the NFT.
  - `availableShares`: The number of shares that are available for purchase.
  - `tokenAddress`: The address of the ERC20 token representing the shares.

```solidity
    mapping(uint256 => FractionalNFT) public fractions;
    mapping(uint256 => mapping(address => uint256)) public userShares;
```

- `mapping(uint256 => FractionalNFT) public fractions;`: Creates a mapping that associates a fractionalNFTCounter to a FractionalNFT struct. This allows for storage and retrieval of fractional NFTs.
- `mapping(uint256 => mapping(address => uint256)) public userShares;`: Creates a double mapping to keep track of the number of shares owned by each address for each fractional NFT.

```solidity
    event FractionalNFTAdded(uint256 indexed fractionalNftId, uint256 nftId, uint256 totalShares);
    event SharesPurchased(address indexed buyer, uint256 indexed fractionalNftId, uint256 sharesAmount);
    event SharesSold(address indexed seller, uint256 indexed fractionalNftId, uint256 sharesAmount);
    event NFTWithdrawn(address indexed owner, uint256 indexed fractionalNftId);
```

- `event FractionalNFTAdded(uint256 indexed fractionalNftId, uint256 nftId, uint256 totalShares);`: Event emitted when a new fractional NFT is added to the marketplace. It includes the fractionalNftId, the original nftId, and the total number of shares

Apologies for the interruption. Here's the continuation of the explanation of each line of the FractionalNFTMarketplace contract:

```solidity
    event FractionalNFTAdded(uint256 indexed fractionalNftId, uint256 nftId, uint256 totalShares);
    event SharesPurchased(address indexed buyer, uint256 indexed fractionalNftId, uint256 sharesCount);
    event SharesSold(address indexed seller, uint256 indexed fractionalNftId, uint256 sharesCount);
    event NFTClaimed(address indexed claimer, uint256 indexed fractionalNftId);
```

- `event FractionalNFTAdded(uint256 indexed fractionalNftId, uint256 nftId, uint256 totalShares);`: An event triggered when a new fractional NFT is added to the marketplace. It emits the `fractionalNftId`, `nftId`, and `totalShares` of the added fractional NFT.

- `event SharesPurchased(address indexed buyer, uint256 indexed fractionalNftId, uint256 sharesCount);`: An event triggered when shares of a fractional NFT are purchased. It emits the `buyer` address, `fractionalNftId` of the purchased shares, and the `sharesCount` representing the number of shares purchased.

- `event SharesSold(address indexed seller, uint256 indexed fractionalNftId, uint256 sharesCount);`: An event triggered when shares of a fractional NFT are sold. It emits the `seller` address, `fractionalNftId` of the sold shares, and the `sharesCount` representing the number of shares sold.

- `event NFTClaimed(address indexed claimer, uint256 indexed fractionalNftId);`: An event triggered when the ownership of an NFT is claimed. It emits the `claimer` address and the `fractionalNftId` of the NFT being claimed.

```solidity
    modifier onlyNFTOwner(uint256 nftId) {
        require(
            INFTContract(nftContractAddress).ownerOf(nftId) == msg.sender,
            "Only NFT owner can perform this action"
        );
        _;
    }
```

- `modifier onlyNFTOwner(uint256 nftId) { ... }`: A modifier that restricts certain functions to be called only by the owner of the NFT with the given `nftId`. It checks if the `msg.sender` (caller) is the owner of the NFT using the `ownerOf` function from the `INFTContract` interface. If the condition is satisfied, the modified function is executed; otherwise, an exception is thrown.

```solidity
constructor() {
 foundry = msg.sender;
 fractionalNFTCounter = 0;
}
```

- `constructor() { ... }`: The constructor function that is executed when the contract is deployed. It sets the `foundry` address to the deployer's address (`msg.sender`) and initializes the `fractionalNFTCounter` to 0.

```solidity
    function addFractionalNFT(
        uint256 nftId,
        uint2
```
