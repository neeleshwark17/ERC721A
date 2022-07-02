// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "hardhat/console.sol";


error ApprovalCallerNotOwnerNorApproved();
error ApprovalQueryForNonexistentToken();
error ApprovalToCurrentOwner();
error ApproveToCaller();
error BalanceQueryForZeroAddress();
error MintToZeroAddress();
error MintZeroQuantity();
error OwnerQueryForNonexistentToken();
error TransferCallerNotOwnerNorApproved();
error TransferFromIncorrectOwner();
error TransferToNonERC721ReceiverImplementer();
error TransferToZeroAddress();
error URIQueryForNonexistentToken();



// error MintedQueryForZeroAddress();
// error OwnerIndexOutOfBounds();
// error TokenIndexOutOfBounds();
// error UnableDetermineTokenOwner();

contract MetaSimba is ERC721A, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address ContractOwner;

    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721A("Meta Simba Project", "Meta Simba") {
        ContractOwner = msg.sender;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    // function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory){
    //     console.log("HERE we will check it's ownership explicity");
    //     TokenOwnership[] memory tokensOwnwership = new TokenOwnership[](2);
    //     return tokensOwnwership;
    // }

    // function tokensOfOwner(address owner) external view returns (uint256[] memory){
    //     console.log("I will return owner all tokens");
    // }

    function createTokens(address contractAddress,string[] memory baseURIs) external payable onlyOwner
    {   

        uint256 quantity = baseURIs.length;
        if(quantity<0){
            revert MintZeroQuantity();
        }
        require(msg.sender != address(0),"admin address can not be zero");
        
        if(msg.sender == address(0)){
            revert MintToZeroAddress();
        }

        _safeMint(msg.sender, quantity);
        setApprovalForAll(contractAddress, true);
        uint256 tokenId = _tokenIds.current();
        console.log("my tokens building Ending with here",tokenId+quantity);

        for(uint256 i=0;i<quantity;i++) {
            tokenId = _tokenIds.current(); 
            require(_exists(tokenId), "token does not exist");
            _setTokenURI(tokenId , baseURIs[i]);
            safeTransferFrom( msg.sender,ContractOwner, tokenId);
            _tokenIds.increment();
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        // string memory base = _baseURI();
        
        // If there is no base URI, return the token URI.
        // if (bytes(base).length == 0) {
            return _tokenURI;
        // }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        // if (bytes(_tokenURI).length > 0) {
        //     return string(abi.encodePacked(base, _tokenURI));
        // }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        // return string(abi.encodePacked(base, tokenId.toString()));
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}