// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
//import {MintBasicNft} from "../script/Interactions.s.sol";

contract DeployMoodNftTest is Test {
    //MoodNft moodNft;
    //string constant NFT_NAME = "GameMoodNft";
    //string constant NFT_SYMBOL = "JStick";
    //MoodNft public moodNft;
    DeployMoodNft public deployer;
    //address public deployerAddress;

    //string public constant  SPLASH_SVG_URI ="data:application/json;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDIwMDEwOTA0Ly9FTiIKICJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy1TVkctMjAwMTA5MDQvRFREL3N2ZzEwLmR0ZCI+CjxzdmcgdmVyc2lvbj0iMS4wIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiB3aWR0aD0iNTEyLjAwMDAwMHB0IiBoZWlnaHQ9IjUxMi4wMDAwMDBwdCIgdmlld0JveD0iMCAwIDUxMi4wMDAwMDAgNTEyLjAwMDAwMCIKIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaWRZTWlkIG1lZXQiPgoKPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMC4wMDAwMDAsNTEyLjAwMDAwMCkgc2NhbGUoMC4xMDAwMDAsLTAuMTAwMDAwKSIKZmlsbD0iIzAwMDAwMCIgc3Ryb2tlPSJub25lIj4KPHBhdGggZD0iTTEyODggNDExMCBjLTI2NyAtMzIgLTUwNyAtMTQ0IC02OTkgLTMyNyAtMjg4IC0yNzQgLTQyMiAtNjYwIC0zNjUKLTEwNTMgbDE3IC0xMTUgLTYwIC0zODAgYy02OCAtNDMxIC0xNDQgLTk2NCAtMTYxIC0xMTM0IC0yMyAtMjE5IDIwIC0zNTQgMTQ5Ci00NzQgODQgLTc3IDE0OCAtMTAxIDI3MSAtMTAyIDE2MiAwIDEwMiAtNDQgOTYwIDcxMCAxMyAxMiAyNSA3IDgzIC0zMCAzOAotMjQgMTA1IC01NiAxNTAgLTcyIDc1IC0yNiA5NCAtMjggMjI3IC0yOCAxMzMgMCAxNTIgMyAyMjUgMjggMjE2IDc2IDM4MiAyNDYKNDUxIDQ2MSAyMSA2OSAyMiA2OSAyOSAzNSAyNCAtMTExIDExMyAtMjU4IDIxMSAtMzQ4IDEyOSAtMTE4IDI5NiAtMTgxIDQ3OAotMTgxIDE1MyAwIDI4NCAzOSAzOTkgMTE5IGw0NSAzMCAzNTMgLTMxMSBjMTk1IC0xNzEgMzc0IC0zMjYgMzk5IC0zNDQgMTA5Ci04MiAyNzIgLTk1IDM5NyAtMzQgMTUwIDc0IDI1MyAyNDcgMjUzIDQyNSAwIDExNiAtNzEgNjM4IC0xODAgMTMzMCAtNDkgMzA4Ci00OSAzMTEgLTM1IDM5MCAzMCAxNjggMTQgNDA1IC0zOSA1NjYgLTEzOSA0MjYgLTQ2MiA3MTggLTkxMSA4MjIgLTg5IDIxCi0xMTAgMjEgLTEzMzUgMjMgLTY4NSAxIC0xMjc1IC0yIC0xMzEyIC02eiBtMjQ2MCAtMzY2IGMxNDUgLTYwIDE4NCAtMjY1IDcwCi0zNzEgLTM2IC0zNCAtMTA4IC02MyAtMTU4IC02MyAtNTAgMCAtMTIyIDI5IC0xNTggNjMgLTExMyAxMDUgLTc2IDMwOSA2OAozNzEgNDYgMjAgMTMxIDIwIDE3OCAweiBtLTIxOTQgLTQ1IGwyNiAtMjAgMCAtMTcyIDAgLTE3MiAtODggLTg4IC04NyAtODcKLTkzIDkzIC05MiA5MiAwIDE1MiBjMCAxNjMgNyAxOTggNDIgMjEzIDEzIDUgNzggOSAxNDQgOSAxMDggMSAxMjQgLTEgMTQ4Ci0yMHogbTE3MjAgLTQxMSBjNTEgLTE2IDExOSAtODIgMTM2IC0xMzIgMjAgLTYzIDkgLTE1NyAtMjUgLTIwNiAtMTI1IC0xODAKLTQwNiAtOTQgLTQwNiAxMjUgMCAxNTcgMTQxIDI1OSAyOTUgMjEzeiBtLTIwMzkgLTExOCBsOTAgLTkwIC05MCAtOTAgLTkwCi05MCAtMTYxIDAgYy0yMjIgMCAtMjE0IC02IC0yMTQgMTgxIDAgMTg5IC0xMSAxNzkgMjA4IDE3OSBsMTY3IDAgOTAgLTkwegptNzg0IDY0IGMxOSAtMjQgMjEgLTQwIDIxIC0xNTYgMCAtMTI0IC0xIC0xMzAgLTI1IC0xNTMgLTI0IC0yNSAtMjcgLTI1IC0xODcKLTI1IGwtMTYzIDAgLTkwIDkwIC05MCA5MCA5MCA5MCA5MCA5MCAxNjcgMCAxNjcgMCAyMCAtMjZ6IG0tNDM5IC01NzQgYzAKLTIyMyAxMSAtMjEwIC0xNzUgLTIxMCAtMTkxIDAgLTE4NSAtNyAtMTg1IDIwOSBsMCAxNTYgOTIgOTIgOTMgOTMgODcgLTg3IDg4Ci04OCAwIC0xNjV6IG0yMTUxIDE2OSBjMTcxIC01MiAyMDUgLTI5NSA1NiAtMzk2IC0xNTIgLTEwMiAtMzQ4IDAgLTM0OCAxODEgMAoxNTcgMTQwIDI2MCAyOTIgMjE1eiIvPgo8L2c+Cjwvc3ZnPg==";

    //string public constant SPLASH2_SVG_URI = "data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjAgIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIuMDAwMDAwMCBwdCIgaGVpZ2h0PSI1MTIuMDAwMDAwMCBwdCIgdmlld0JveD0iMCAwIDUxMi4wMDAwMDAgNTEyLjAwMDAwMCIKIHByZXNlcnZlQXNwZWN0UmF0aW89ImhNaWRZTWlkIG1lZXQiPgoKPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMC.wMDAwMDAsNTEyLjAwMDAwMCkgc2NhbGUoMC.xMDAwMDAsLTAuMTAwMDAwKSIKZmlsbD0iIzAwMDAwMCIgc3Ryb2tlPSJub25lIj4KPHBhdGggZD0iTTEyODggNDExMCBjLTI2NyAtMzIgLTUwNyAtMTQ0IC02OTkgLTMyNyAtMjg4IC0yNzQgLTQyMiAtNjYwIC0zNjUKLTEwNTMgbDE3IC0xMTUgLTYwIC0zODAgYy02OCAtNDMxIC0xNDQgLTk2NCAtMTYxIC0xMTM0IC0yMyAtMjE5IDIwIC0zNTQgMTQ5Ci00NzQgODQgLTc3IDE0OCAtMTAxIDI3MSAtMTAyIDE2MiAwIDEwMiAtNDQgOTYwIDcxMCAxMyAxMiAyNSA3IDgzIC0zMCAzOAotMjQgMTA1IC01NiAxNTAgLTcyIDc1IC0yNiA5NCAtMjggMjI3IC0yOCAxMzMgMCAxNTIgMyAyMjUgMjggMjE2IDc2IDM4MiAyNDYKNDUxIDQ2MSAyMSA2OSAyMiA2OSAyOSAzNSAyNCAtMTExIDExMyAtMjU4IDIxMSAtMzQ4IDEyOSAtMTE4IDI5NiAtMTgxIDQ3OAotMTgxIDE1MyAwIDI4NCAzOSAzOTkgMTE5IGw0NSAzMCAzNTMgLTMxMSBjMTk1IC0xNzEgMzc0IC0zMjYgMzk5IC0zNDQgMTA5Ci04MiAyNzIgLTk1IDM5NyAtMzQgMTUwIDc0IDI1MyAyNDcgMjUzIDQyNSAwIDExNiAtNzEgNjM4IC0xODAgMTMzMCAtNDkgMzA4Ci00OSAzMTEgLTM1IDM5MCAzMCAxNjggMTQgNDA1IC0zOSA1NjYgLTEzOSA0MjYgLTQ2MiA3MTggLTkxMSA4MjIgLTg5IDIxCi0xMTAgMjEgLTEzMzUgMjMgLTY4NSAxIC0xMjc1IC0yIC0xMzEyIC02eiBtMjQ2MCAtMzY2IGMxNDUgLTYwIDE4NCAtMjY1IDcwCi0zNzEgLTM2IC0zNCAtMTA4IC02MyAtMTU4IC02MyAtNTAgMCAtMTIyIDI5IC0xNTggNjMgLTExMyAxMDUgLTc2IDMwOSA2OAozNzEgNDYgMjAgMTMxIDIwIDE3OCAweiBtLTIxOTQgLTQ1IGwyNiAtMjAgMCAtMTcyIDAgLTE3MiAtODggLTg4IC04NyAtODcKLTkzIDkzIC05MiA5MiAwIDE1MiBjMCAxNjMgNyAxOTggNDIgMjEzIDEzIDUgNzggOSAxNDQgOSAxMDggMSAxMjQgLTEgMTQ4Ci0yMHogbTE3MjAgLTQxMSBjNTEgLTE";

    //vm.prank (USER) setup;
    //address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        
    }

    function testConvertSvgToUri() public view {
    // Define a simple SVG code with a single path element
    string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15" fill="black">Hi! Your browser decoded this</text></svg>';

    // Define the expected data URI for the provided SVG code
    string memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCI+Cjx0ZXh0IHg9IjAiIHk9IjE1IiBmaWxsPSJibGFjayI+SGkhIFlvdXIgYnJvd3NlciBkZWNvZGVkIHRoaXM8L3RleHQ+Cjwvc3ZnPg";

    // Convert the SVG code to data URI using the `svgToImageURI` function
    string memory actualUri = deployer.svgToImageURI(svg);

    // Remove whitespaces from both URIs for accurate comparison
    string memory removeWhitespaceexpectedUri = removeWhitespace(expectedUri);
    string memory actualUriWithoutWhitespace = removeWhitespace(actualUri);

    // Compare the actual and expected data URIs
    if (keccak256(abi.encodePacked(actualUriWithoutWhitespace)) != keccak256(abi.encodePacked(removeWhitespaceexpectedUri))) {
    revert("Generated data URI does not match expected data URI");
    }

    // Assert that the generated data URI matches the expected data URI
    assert(keccak256(abi.encodePacked(actualUri)) != keccak256(abi.encodePacked(expectedUri)));

    }
    function removeWhitespace(string memory str) private pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    uint256 strLength = strBytes.length;
   

     }

}    