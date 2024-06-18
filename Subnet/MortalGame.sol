// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./GameAssests.sol";

contract MortalGame{


    struct Player{
        address playerAddress;
        uint score;
    }

    address private immutable owner;


    GameAssests public asset1;

    mapping(uint => bool) private isAvailableAsset;
    Player[] public leaderBoard;

    mapping(address=> uint) private leaderBoardIndex;
    mapping(address => bool)private inLeaderBoard;
     address private lastHighestOwner;
    uint private lastHighest;

    uint[] public tokenIdNFTCollection;



    constructor() {
        asset1 = new GameAssests(msg.sender);
        owner = msg.sender;
    }


    function getGameAssets(uint _choice) external {
        asset1.gameAssetMint(msg.sender, _choice, msg.sender);
    }

    function rewardNFTs(address _receiver, uint _choice)external {
        asset1.gameAssetMint(_receiver, _choice, msg.sender);
    }


    function bidNFT(uint _tokenID) internal{
        asset1.transferAsset(msg.sender,address(this),_tokenID);
        isAvailableAsset[_tokenID] = true;
    }

    function getOwner() external view returns(address){
        return asset1.getOwner();
    }


    ///@notice : Auction for Buying the NFTs (incomplete)

      function auctionBuyNFT() public payable{
        if(msg.value > lastHighest){
            (bool callmsg, ) = payable(lastHighestOwner).call{value:lastHighest}("");
            require(callmsg,"Can't Transfered");
            lastHighest = msg.value;
        }
            lastHighestOwner = msg.sender;
      }


///@notice : To sell his/her nft to the owner for some amount of tokens. 
      function toSellNFT(uint _tokenID) external {

        
        asset1.transferAsset(msg.sender,owner,_tokenID);
      }

      function toTransferNFT(address _recepient, uint _tokenID) external{
        asset1.transferAsset(msg.sender, _recepient, _tokenID);
      }



    ///@notice Stone Paper Scissor Game.
    // 0 = Stone
    // 1 = Paper
    // 2 = Scissor
 
    function stonePaperScissor(uint _input) internal view returns(bool){
        require(_input < 3);
       uint machine =  machineRandomNumber()%3;
       if(_input == machine){
            return false;
       }else if (_input == 0 && machine == 1 || _input == 1 && machine == 2 || _input == 2 && machine == 0){
            return false;
       }else{
            return true;
       }

    }

    function playRockPaperScissor(uint _input)external returns(string memory) {

        bool res = playWithSystem(_input);
        if(res){
            return "You won";
        }
        return "You Lost";
    }

    function playWithSystem(uint _choice) internal returns(bool){
        bool res = stonePaperScissor(_choice);
        if(res == true && inLeaderBoard[msg.sender]!=false){
            // return leaderBoard[leaderBoardIndex[msg.sender]];
            leaderBoard[leaderBoardIndex[msg.sender]].score = leaderBoard[leaderBoardIndex[msg.sender]].score + 1;
           return true;
            
  
        }else{
            return false;
            
        }
      
        
    }

    function guessTheNumber(uint _inputNumber) internal returns(bool,uint){
        uint machine = machineRandomNumber()%5;

 
        if(_inputNumber == machine){
            leaderBoard[leaderBoardIndex[msg.sender]].score = leaderBoard[leaderBoardIndex[msg.sender]].score + 2;
            return (true,machine);
        }else{
            return (false,machine);
        }    
    }

    function guessTheNumberAgainstSystem(uint _inputNumber) external returns(string memory){

        (bool res, uint number ) = guessTheNumber(_inputNumber);
        string memory message;
       
        if(res){
             message = "You won the number was indeed ";
            return  string.concat(message, Strings.toString(number));
        }
         message = "You Lost the number was ";
        return  string.concat(message, Strings.toString(number));
    }



    function machineRandomNumber() internal view returns(uint){
      uint val =  uint256(keccak256(abi.encodePacked(block.timestamp,block.coinbase)));
    return val;
    }

    ///@notice Register the user in the leaderBoard.

    function registerPlayer()external {
        if(inLeaderBoard[msg.sender]==false){
            inLeaderBoard[msg.sender] = true;
            leaderBoardIndex[msg.sender] = leaderBoard.length;
            Player memory newPlayer = Player(msg.sender,0);
            leaderBoard.push(newPlayer);
        }
    }



    
}