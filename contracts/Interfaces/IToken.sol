pragma solidity ^0.4.8;

contract IToken {

  

    
    function transfer(address _to, uint256 _value) public returns(bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    }

    
   
    function approve(address _spender, uint256 _value) public
        returns (bool success) 
        {
          _spender; _value;
    }

   
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success)
        {
          _spender; _value; _extraData;
        }
    

 
}
