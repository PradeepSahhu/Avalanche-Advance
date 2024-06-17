// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./GameAssests.sol";

contract MortalGame{


    struct Player{
        address playerAddress;
        uint score;
    }


    GameAssests asset1;

    mapping(uint => bool) private isAvailableAsset;
    Player[] public leaderBoard;

    mapping(address=> uint) private leaderBoardIndex;
    mapping(address => bool)private inLeaderBoard;

    // Game 1 - Stone Paper Scissor
    string[] options = ["Stone","Paper","Scissor"];



    constructor() {
        asset1 = new GameAssests(msg.sender);
    }


    function getGameAssets(uint _choice) external {
        asset1.gameAssetMint(msg.sender, _choice);
    }


    function bidNFT(uint _tokenID) internal{
        asset1.transferAsset(msg.sender,address(this),_tokenID);
        isAvailableAsset[_tokenID] = true;
    }


    ///@notice Stone Paper Scissor Game.
    // 0 = Stone
    // 1 = Paper
    // 2 = Scissor
 
    function stonePaperScissor(uint _input) internal view returns(bool){
        require(_input < 3);
       uint machine =  machineStonePaperScissor();

       if(_input == 0 && machine == 0 || _input == 1 && machine == 1 || _input == 2 && machine == 2){
            return false;
       }else if (_input == 0 && machine == 1 || _input == 1 && machine == 2 || _input == 2 && machine == 0){
            return false;
       }else{
            return true;
       }

    }

    function playWithSystem(uint _choice) external view returns(Player memory){
        bool res = stonePaperScissor(_choice);
        if(res == true && inLeaderBoard[msg.sender]){
            return leaderBoard[leaderBoardIndex[msg.sender]];
            // leaderBoard[leaderBoardIndex[msg.sender]].score+=0.2;
            
  
        }
        return Player(address(0),0);
    }

    function machineStonePaperScissor() internal view returns(uint){
      uint val =  uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender)));
        return val%3;
    }



    
}