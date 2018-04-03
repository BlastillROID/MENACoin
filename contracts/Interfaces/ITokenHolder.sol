pragma solidity ^0.4.21;
import './IOwned.sol';
import './IToken.sol';

contract ITokenHolder is IOwned {
    function withdrawTokens(IToken _token, address _to, uint256 _amount) public;
}