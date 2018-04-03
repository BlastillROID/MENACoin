
pragma solidity ^0.4.21;

contract Utils {
      function Utils() public 
     {
    }
  function safeAdd(uint a, uint b) internal pure returns (uint) {
  if (a + b < a) {
      revert(); 
      }
  return a + b;
}

function safeSub(uint a, uint b) internal pure returns (uint) {
  if (b > a) {revert();}
  return a - b;
}
 
    modifier greaterThanZero(uint256 _amount) {
        require(_amount > 0);
        _;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        require(_address != address(this));
        _;
    }
     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x * _y;
        assert(_x == 0 || z / _x == _y);
        return z;
    }

}
