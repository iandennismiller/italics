// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ItalicsToken is ERC1155 {
    
    event CreateType(address indexed operator, address indexed publisher, uint256 type_id, uint256 token_amount);

    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    // Mapping from token ID to publisher accounts
    mapping(uint256 => address) private _tokenPublishers;

    // Mapping from account to tokens published
    mapping(address => uint256[]) private _tokensPublished;

    // constructor() ERC1155("https://italics.w3n.org/api/item/{id}.json") {
    constructor() ERC1155("http://localhost:8081/api/item/{id}.json") {
        // the first asset is not owned by anybody
        add_asset(0x0000000000000000000000000000000000000001, 1, new bytes(0));
    }

    function add_asset(address _publisherAddress, uint256 _amount, bytes memory _data) public returns (uint256) {
        uint256 newItemId = _tokenId.current();

        // keep a record of who originally created the token
        _tokenPublishers[newItemId] = _publisherAddress;
        _tokensPublished[_publisherAddress].push(newItemId);

        // mint token and send to publisher
        _mint(_publisherAddress, newItemId, _amount, _data);

        // as the final step, increment token index
        _tokenId.increment();

        emit CreateType(msg.sender, _publisherAddress, newItemId, _amount);

        return newItemId;
    }

    function is_publisher(address _publisherAddress, uint256 tokenId) public view returns (bool) {
        return (_tokenPublishers[tokenId] == _publisherAddress);
    }

    function get_publisher(uint256 tokenId) public view returns(address) {
        return _tokenPublishers[tokenId];
    }

    function get_publisher_tokens(address _publisherAddress) public view returns (uint256[] memory) {
        return _tokensPublished[_publisherAddress];
    }

    function get_tokens_held_by(address _readerAddress) public view returns (uint256[] memory) {
        uint num_token_types = get_num_token_types();
        uint[] memory token_id_quantity = new uint[](num_token_types);

        for (uint256 token_id = 0; token_id < num_token_types; ++token_id) {
            token_id_quantity[token_id] = balanceOf(_readerAddress, token_id);
        }
        return token_id_quantity;
    }

    function get_num_token_types() public view returns (uint256) {
        uint256 maxItemId = _tokenId.current();
        return maxItemId;
    }

}
