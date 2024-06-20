// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./GameAssests.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// Implemented ERC-721 as Game Assests like heroes, power, monsters, kingdom etc..
// Implemented ERC-20 as Game Currency like Money. will be used for buying game assests.
// This contract will act as a liquidity pool , where all the tokens, ethers(wei) and NFTs will be stored 
// for trade and exchange, auction.


// wei <---> Tokens
// Tokens -----> NFTs , NFTs can be auctioned for tokens

contract MortalGame is ERC20{


    event rpsGameResult(string indexed res);


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

    modifier onlyOwner{
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner,"You are not the owner");
    }


//(working)


    constructor() ERC20("MortalGame","MGT"){
        asset1 = new GameAssests(msg.sender);
        owner = msg.sender;
        _mint((address(this)),100000 * 10 ** 18);
    }

    // (working)

    function mintMoreGameCurrencty(uint _amount) external{
        _mint((address(this)), _amount * 10 **18);
    }


    function getGameAssets(uint _choice) external {
        asset1.gameAssetMint((address(this)), _choice, msg.sender);
    }

///@notice : To buy tokens from the game (exchange ethers for tokens) 1 token = 1000 wei (working)
    function BuyTokens(uint _tokenAmount) external payable {
        require(balanceOf((address(this))) >= _tokenAmount,"Transaction unsuccessuful");
        uint requiredWei = _tokenAmount * 1000;
        require(msg.value >= requiredWei,"Not enough wei paid");

        uint returnAmount = msg.value - requiredWei;
        (bool res,) = payable(msg.sender).call{value: returnAmount}("");
        require(res,"Can't return the money");
        _transfer((address(this)),msg.sender,_tokenAmount);
    }

///@notice : To exchange Token for some General NFTs( working)
function directBuyNFTs(uint _tokenAmount,uint _NFTID) external{
    require(balanceOf(msg.sender)>=_tokenAmount,"Not Enough tokens in the account");
   bool res =  transfer(address(this),_tokenAmount);
   require(res,"Not successful");
   if(asset1.balanceOf(address(this)) > 0){
        toTransferNFT(msg.sender,_NFTID);
   }else{
    rewardBasicNFTs(msg.sender,_NFTID);
   }
}

///@notice Rewarding NFTS
    function rewardBasicNFTs(address _receiver, uint _choice)internal {
        asset1.gameAssetMint(_receiver, _choice, msg.sender);
    }
    function rewardUniqueNFTs(address _receiver, uint _choice) internal{
        asset1.uniqueAssetMint(_receiver, _choice, msg.sender);
    }
    function rewardSpecialNFTs(address _receiver, uint _choice) internal{
        asset1.specialAssetMint(_receiver, _choice, msg.sender);
    }

///@notice Rewarding Tokens (working)

function rewardTokens(address _receiver, uint _amount) external{

    if(msg.sender == owner){
        require(balanceOf((address(this)))>= _amount,"Not enought Tokens in the liquidity pool");
       _transfer((address(this)), _receiver, _amount);
    }else{
         require(balanceOf(msg.sender) >=_amount);
         bool res = transfer( _receiver, _amount);
        require(res,"Tokens Transfer Unsuccessful");
    }
}

///@notice : For NFT Auction (see this later)

struct AuctionData{
    address _seller;
    uint _NFTID;
}
uint auctionCounter;

AuctionData[] public auction;
    function forAuctionNFT(uint _tokenID) external{
        asset1.transferAsset(msg.sender,address(this),_tokenID);
        auction.push(AuctionData(msg.sender,_tokenID));
        // isAvailableAsset[_tokenID] = true;
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

      function finishAuction() external onlyOwner{

      }


//

    function getOwner() external view returns(address){
        return asset1.getOwner();
    }




///@notice : To sell his/her nft to the liquidity Pool for some amount of tokens. 
      function toSellNFT(uint _tokenID) external {
        asset1.transferAsset(msg.sender,(address(this)),_tokenID);
      }

      function toTransferNFT(address _recepient, uint _tokenID) public{
        asset1.transferAsset((address(this)), _recepient, _tokenID);
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
            emit rpsGameResult("You won");
            return "You won";
        }else{
            emit rpsGameResult("you lost");
            return "You Lost";
        }
        
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


    ///@notice
    function withdrawTokens() external onlyOwner{

    }




///@notice to receive external ethers.
    receive() external payable { }



    
}