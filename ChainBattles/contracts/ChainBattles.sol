// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 initialNumber = 1;

    mapping(uint256 => Warriors) public tokenIdToLevels;
    
    struct Warriors {
        uint256 levels;
        uint256 hp;
        uint256 strength;
        uint256 speed;
    }

    constructor() ERC721("Chain Battles", "CBLTS"){
        
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "HP: ",getHP(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

    function getLevels(uint256 tokenId) public view returns(string memory){
        Warriors storage warriors = tokenIdToLevels[tokenId];
        return warriors.levels.toString();
    }
    function getHP(uint256 tokenId) public view returns(string memory){
        Warriors storage warriors = tokenIdToLevels[tokenId];
        return warriors.hp.toString();
    }
    function getStrength(uint256 tokenId) public view returns(string memory){
        Warriors storage warriors = tokenIdToLevels[tokenId];
        return warriors.strength.toString();
    }
    function getSpeed(uint256 tokenId) public view returns(string memory){
        Warriors storage warriors = tokenIdToLevels[tokenId];
        return warriors.speed.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
    }

    function mint() public{
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = Warriors(0, random(10), random(10), random(10));
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

   function random(uint256 number) public returns(uint256){
        return uint(keccak256(abi.encodePacked(initialNumber++))) % number++;
    }

    function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
    Warriors storage warriors = tokenIdToLevels[tokenId];
    warriors.levels = warriors.levels +1;
    warriors.hp = warriors.hp +1;
    warriors.strength = warriors.strength +1;
    warriors.speed = warriors.speed +1;
    _setTokenURI(tokenId, getTokenURI(tokenId));
    }

} 

