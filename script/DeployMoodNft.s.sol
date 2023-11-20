// SPDX-Lincense-Identifier: MIT

pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract DeployMoodNft is Script {
   function run() external returns (MoodNft) {
      string memory splash = vm.readFile("./img/splash.svg");
      string memory splash2 = vm.readFile("./img/splash2.svg");
      console.log(splash);

      vm.startBroadcast();
      MoodNft moodNft = new MoodNft(
      svgToImageURI(splash),
      svgToImageURI(splash2));
      vm.stopBroadcast();

      return moodNft;

   }
    // The fucntion bellow will automatically convert svg image to base64 string
   function svgToImageURI(string memory svg) public pure returns (string memory) {
      string memory baseURL = "data:image/svg+xml;base64,";
      string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
      return string(abi.encodePacked(baseURL, svgBase64Encoded));
   }
}    