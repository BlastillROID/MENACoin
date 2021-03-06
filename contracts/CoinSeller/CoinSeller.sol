pragma solidity ^0.4.21;
import "./Owned.sol";

contract token{
    function destroy(address _from,uint _amout) external;
    function transferFrom(address _from, address _to, uint256 _value) external;
    function transfer(address _to, uint _amout) external;
     mapping (address => uint256) public balanceOf;
}

contract CoinSeller is Owned {
    
    event Sold(address _to,uint amount);
    uint256 public priceOfHeadToken;
    address child;
    address self;
    token public HeadToken;
    token public Child;
    
    function CoinSeller( address headToken,uint256 PriceOfHeadToken )public {
        priceOfHeadToken = PriceOfHeadToken;
        HeadToken = token(headToken);
       
    }
    function setChildAddress(address CH) public {
        require(CH != 0x0);
        child = CH;
        
    }
    modifier ValidChild(){
        require(child != 0x0);
        _;
    }
    function setChild() public ValidChild() {
         Child = token(child);
    }
    modifier SufficientFunds(address _address,uint amount){
      require(HeadToken.balanceOf(_address)>amount*priceOfHeadToken)  ;
        _;
    }
    function BuyToken(uint amount)public SufficientFunds(msg.sender,amount){
        //Here is to be changed from desroy to normal transer ;
        
        HeadToken.transferFrom(msg.sender,this,priceOfHeadToken*amount);
        Child.transfer(msg.sender,amount);
       emit Sold(msg.sender,amount);
    }
  
    
    
}

