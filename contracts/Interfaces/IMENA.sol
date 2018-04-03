pragma solidity ^0.4.21;
import './IOwned.sol';
import './IToken.sol';

contract IMENA is IOwned, IToken {

    function increaseSupply(uint value, address to) public returns (bool success) {}

    function decreaseSupply(uint value, address from) public returns (bool success) {}

    function burn(uint256 _value) public returns (bool success) {_value;}

   
    function burnFrom(address _from, uint256 _value) public returns (bool success) {_from; _value;}

    function disableTransfers(bool _disable) public;
    
    function issue(address _to, uint256 _amount) public;
    
    function destroy(address _from, uint256 _amount) public;

      function issueBlockReward() public;

    
}
