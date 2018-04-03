pragma solidity ^0.4.21;
contract IOwned {
  function IOwned() public {}
   function owner() public pure returns (address) {}
    function transferOwnership(address _newOwner) public;
  //  function acceptOwnership() public;
}
