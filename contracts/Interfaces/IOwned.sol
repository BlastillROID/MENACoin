pragma solidity ^0.4.8;
contract IOwned {
  function IOwned() {}
   function owner() public view returns (address) {}
    function transferOwnership(address _newOwner) public;
    function acceptOwnership() public;
}
