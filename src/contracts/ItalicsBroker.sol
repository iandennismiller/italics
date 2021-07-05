// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ItalicsToken.sol";

interface TokenInterface {
    function is_publisher(address _publisherAddress, uint256 _tokenId) external view returns (bool);
    function get_publisher(uint256 tokenId) external view returns(address);
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external;
}

contract ItalicsBroker is Ownable {
    
    event CreateType(address indexed operator, address indexed publisher, uint256 type_id, uint256 token_amount);

    // Mapping from item to price in wei
    mapping(uint256 => uint256) private _tokenPrice;

    constructor(address _italicsToken) {
        italicsToken = _italicsToken;
    }

    address public italicsToken;

    function list_asset(uint256 tokenId, uint256 amountWei) public {
        require(amountWei > 0, "Amount is not greater than 0 wei");

        // ensure msg.sender is publisher of this token
        require(TokenInterface(italicsToken).is_publisher(msg.sender, tokenId), "not publisher");

        _tokenPrice[tokenId] = amountWei;
    }

    function get_asset_price(uint256 tokenId) public view returns (uint256) {
        return _tokenPrice[tokenId];
    }

    function sell_asset_to(address toAddress, uint256 tokenId) public payable {
        address publisher = TokenInterface(italicsToken).get_publisher(tokenId);
        // require payment amount is above price
        require(msg.value == _tokenPrice[tokenId], "payment is insufficient");
        TokenInterface(italicsToken).safeTransferFrom(publisher, toAddress, tokenId, 1, "");
    }

}
