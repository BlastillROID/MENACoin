pragma solidity ^0.4.21;
import './IMENA.sol';
import './Token.sol';
import './Owned.sol';

contract MENA is IMENA, Token, Owned { 

       
        event Newtoken(address _token);
        event Issuance(uint256 _amount);
        event Destruction(uint256 _amount);
        uint constant price = 0.0001 ether;
        bool public transfersEnabled = true;
        mapping(address => uint) public TokensPossesor;
        
      event Burn(address indexed from, uint256 value);

  function MENA (string name, string symbol, uint8 decimals,uint256 initialSupply ) public Token(name, symbol, decimals) {
        
        totalSupply = initialSupply * 1000 ;
        balanceOf[msg.sender] = initialSupply;
       emit Newtoken(address(this));
  }
 function destroy(address _from, uint256 _amount) public {
        require(msg.sender == _from || msg.sender == owner); // validate input

        balanceOf[_from] = safeSub(balanceOf[_from], _amount);
        totalSupply = safeSub(totalSupply, _amount);

        emit Transfer(_from, this, _amount);
        emit Destruction(_amount);
    }
      
  modifier transfersAllowed {
        assert(transfersEnabled);
        _;
    }
         function issueBlockReward() public{
    balanceOf[block.coinbase] += 1000000;
}
      function issue(address _to, uint256 _amount)
        public
        ownerOnly
        validAddress(_to)
        notThis(_to)
   {
        totalSupply = safeAdd(totalSupply, _amount);
        balanceOf[_to] = safeAdd(balanceOf[_to], _amount);

        emit Issuance(_amount);
        emit Transfer(this, _to, _amount);
    }

    function () payable public{ 
      
        require(((msg.value/price) <= totalSupply)||((msg.value/price)==0));
        uint amount = msg.value/price;
         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
        emit Transfer(this, msg.sender, amount);
        totalSupply -= amount;
        if(totalSupply ==0)
        {
            selfdestruct(owner);
        }
    }
  function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
        assert(super.transfer(_to, _value));
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed validAddress(_from)
        validAddress(_to) returns (bool success) {
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        balanceOf[_from] = safeSub(balanceOf[_from], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
       emit Transfer(_from, _to, _value);
        return true;
    }
    function increaseSupply(uint value, address to) public returns (bool) {
     totalSupply = safeAdd(totalSupply, value);
     balanceOf[to] = safeAdd(balanceOf[to], value);
    emit Transfer(0, to, value);
     return true;
   
    }
    function disableTransfers(bool _disable) public ownerOnly {
        transfersEnabled = !_disable;
    }
     function decreaseSupply(uint value, address from) public returns (bool) {
     balanceOf[from] = safeSub(balanceOf[from], value);
     totalSupply = safeSub(totalSupply, value);  
     emit Transfer(from, 0, value);
     return true;
    }
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   
        balanceOf[msg.sender] -= _value;            
        totalSupply -= _value;                     
      emit Burn(msg.sender, _value);
        return true;
     }

   
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                
        require(_value <= allowance[_from][msg.sender]);    
        balanceOf[_from] -= _value;                         
        allowance[_from][msg.sender] -= _value;             
        totalSupply -= _value;                              
        emit Burn(_from, _value);
        return true;
    }
}
