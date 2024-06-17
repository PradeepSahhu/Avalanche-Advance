// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Normal Assets
// 1. Fire Dragon : ipfs://QmQ6wwxiZdH1pnWXpTBzPYspaL2mD3EYFAuSvwTk6xWjL5
// 2. Army : ipfs://QmQ6wwxiZdH1pnWXpTBzPYspaL2mD3EYFAuSvwTk6xWjL5
// 3. Elf Warrior : ipfs://Qmac8hMkS4MyjT5bAfUGaCDfj11Gp8NWViG8GqbVcWJyn6
// 4. Sword Warrior : ipfs://QmTD6ti23L2fmdUivUAdoqGYWh6zgKMztFVbQNQHwktsPd
// 5. Knight Horse : ipfs://QmTcH7zedbjsCLjAXndRkgiamoK1CN9VdR4MAPuDqEmHae
// 6. army Of undead : ipfs://Qmctmn5LPcVWGxw68vJzF8dVvo4Q1Z7PvXZ7FEi4qLcDXF
// 7. elf Nature : ipfs://Qmac8hMkS4MyjT5bAfUGaCDfj11Gp8NWViG8GqbVcWJyn6
// 8. Dwarf : ipfs://QmfJe7fkEhM8pJ9nGZbGztc8u56QWXTjgT6s7hQ8smNpMV
// 9. Sword Warrior : ipfs://QmTD6ti23L2fmdUivUAdoqGYWh6zgKMztFVbQNQHwktsPd
// 10. Mermaid : ipfs://QmYMhsh5K3heLeMvX7cQGQAa87U1bL2VaeXpX8yqgRUdDJ


// Unique Assets
// 11. Queen Warrior : ipfs://QmW2E3FP7cvJxPy289qNria86gckjCB9ni26j33koi52Eu
// 12. Palace of Heaven : ipfs://QmSey5nTJGiBWfqc466FVvkGTTdNkEWQqBkrSsW7KjcVHs
// 13. Ice Queen : ipfs://QmP1a4A9SEPWNgjPoVEQQkEf8dqo5fewQwWjcKw1o5GSrR
// 14. batKnight : ipfs://QmPLeQTbbU7ogf6SEeyfNyxQKLaJZFDUNZrtfXNZWxVgts


// Special Assets
// 15. lightning Dragon : ipfs://QmXDi8PyweyKY5yCeQf3qr5bpKZz2juxYeubjt5CzmyHqX
// 16. Dark Dragon : ipfs://QmXNwk53nqQoXYGuHDiH73s5u6eaAnZE1v8AGdjrefqG9t
// 17. Space Dragon : ipfs://QmV2qGgB3wMauFCMzJqSf2oHC1AuHBbqDFJuQYDAm4Lhit

contract GameAssests is ERC721URIStorage{

    uint256 private CountToken;
    address private owner;
    uint[] private mintedTokenCount;


    string[] private assetURI = ['ipfs://QmQ6wwxiZdH1pnWXpTBzPYspaL2mD3EYFAuSvwTk6xWjL5','ipfs://QmQ6wwxiZdH1pnWXpTBzPYspaL2mD3EYFAuSvwTk6xWjL5','ipfs://Qmac8hMkS4MyjT5bAfUGaCDfj11Gp8NWViG8GqbVcWJyn6','ipfs://QmTD6ti23L2fmdUivUAdoqGYWh6zgKMztFVbQNQHwktsPd','ipfs://QmTcH7zedbjsCLjAXndRkgiamoK1CN9VdR4MAPuDqEmHae','ipfs://Qmctmn5LPcVWGxw68vJzF8dVvo4Q1Z7PvXZ7FEi4qLcDXF','ipfs://Qmac8hMkS4MyjT5bAfUGaCDfj11Gp8NWViG8GqbVcWJyn6','ipfs://QmfJe7fkEhM8pJ9nGZbGztc8u56QWXTjgT6s7hQ8smNpMV','ipfs://QmTD6ti23L2fmdUivUAdoqGYWh6zgKMztFVbQNQHwktsPd','ipfs://QmYMhsh5K3heLeMvX7cQGQAa87U1bL2VaeXpX8yqgRUdDJ'];
    string[] private uniqueAssetURI = ['ipfs://QmW2E3FP7cvJxPy289qNria86gckjCB9ni26j33koi52Eu','ipfs://QmSey5nTJGiBWfqc466FVvkGTTdNkEWQqBkrSsW7KjcVHs','ipfs://QmP1a4A9SEPWNgjPoVEQQkEf8dqo5fewQwWjcKw1o5GSrR','ipfs://QmPLeQTbbU7ogf6SEeyfNyxQKLaJZFDUNZrtfXNZWxVgts'];
    string[] private specialAssetURI = ['ipfs://QmXDi8PyweyKY5yCeQf3qr5bpKZz2juxYeubjt5CzmyHqX','ipfs://QmXNwk53nqQoXYGuHDiH73s5u6eaAnZE1v8AGdjrefqG9t','ipfs://QmV2qGgB3wMauFCMzJqSf2oHC1AuHBbqDFJuQYDAm4Lhit'];

    constructor(address _owner) ERC721("GAME ASSET","GAT"){ // Game Asset 
        owner = _owner;

    }

    modifier onlyOwner{
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view{
        require(owner == msg.sender);
    }

    function gameAssetMint(address _receiver, uint _choice) external onlyOwner{
        require(_choice < assetURI.length);
        _mint(_receiver, CountToken);
        _setTokenURI(CountToken,assetURI[_choice]);
        mintedTokenCount.push(CountToken);
        CountToken++;
    }

    function uniqueAssetMint(address _receiver, uint _choice) external onlyOwner{
        require(_choice <uniqueAssetURI.length);
        _mint(_receiver,CountToken);
        _setTokenURI(CountToken, uniqueAssetURI[_choice]);
         mintedTokenCount.push(CountToken);
        CountToken++;
    }

     function specialAssetMint(address _receiver, uint _choice) external onlyOwner{
        require(_choice <specialAssetURI.length);
        _mint(_receiver,CountToken);
        _setTokenURI(CountToken, specialAssetURI[_choice]);
         mintedTokenCount.push(CountToken);
        CountToken++;
    }

    function getLength() external view returns(uint){
        return assetURI.length;
    }


    function transferAsset(address _sender,address _recepient, uint _input) external {
        require(balanceOf(_sender)>0,"Don't have any NFT");
        require(ownerOf(_input) == _sender,"Not the owner of tokenId");
        safeTransferFrom(_sender, _recepient, _input);
    }

    function transferFromOwner(address _recepient, uint _input)external{
        if(_input >= CountToken || mintedTokenCount[_input]==0){
            revert("Input TokenId Doesn't exist");
        }
        safeTransferFrom(owner, _recepient, _input);
        delete mintedTokenCount[_input];
    }

    function totalAssetsMinted() external view returns(uint){
        return CountToken;
    }
  

}