// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Imports 
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    // Storage Variables
    uint256 private s_tokenCounter;
    string private s_splashSVGImageUri ;
    string private s_splash2SVGImageUri;

    // On the constructor, we will pass the straight our two SVG files     
    constructor(string memory splashSVGImageUri, string memory splash2SVGImageUri ) ERC721("GameMoodNft", "JStick") {
        s_splashSVGImageUri = splashSVGImageUri; 
        s_splash2SVGImageUri = splash2SVGImageUri; 
        s_tokenCounter = 0;}

    // I order to flip the SVGs images , I need to create a Enum for that 
    enum SelectedImage { 
        splashSVGImageUri,
        splash2SVGImageUri
    }  

    // To be able to use the enum , I need to create a mapping function
    mapping(uint256 => SelectedImage) private s_selectedImage;
    

    // Now we will add a function to anybody to mint our NFTs  
    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_selectedImage [s_tokenCounter] = SelectedImage.splashSVGImageUri;
        // Here I'll need to explain it , our s_tokenCounter is set to 0 , everytime we mint a new NFT, we add 1 to it
        s_tokenCounter++;
    } 

    // We need to create a function to enpacket our SVG images into Base64
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_selectedImage[tokenId] == SelectedImage.splashSVGImageUri) {
            imageURI = s_splashSVGImageUri;
        } else if (s_selectedImage[tokenId] == SelectedImage.splash2SVGImageUri) {
            imageURI = s_splash2SVGImageUri;
        }
        // Down here we'll create a fanction that represents our SVG images
            return 
                string(
                        abi.encodePacked(
                            _baseURI(),
                            Base64.encode(
                                bytes(
                                abi.encodePacked('{"image": "', imageURI, '"}')  
                                )              
                            )
                        )
                ); 
    }
   
}    