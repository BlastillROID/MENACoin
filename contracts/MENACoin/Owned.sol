pragma solidity ^0.4.21;
import './IOwned.sol';
contract Owned is IOwned {
  
  address public owner;
    address public newOwner;
    address public coinSeller;
    address public crowdSale;

    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);

    /**
        @dev constructor
    */
    function Owned() public {
        owner = msg.sender;
        
    }
    
    function SetCrowdSale(address Sale) public ownerOnly {
        crowdSale = Sale;
        
    }
    function SetCoinSeller(address seller) public ownerOnly{
        coinSeller = seller;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        assert((msg.sender == owner)|| (msg.sender == coinSeller) || (msg.sender == crowdSale));
        _;
    }
    
    /**
        @dev allows transferring the contract ownership
        the new owner still needs to accept the transfer
        can only be called by the contract owner

        @param _newOwner    new contract owner
    */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner);
        owner = _newOwner;
    }

    /**
        @dev used by a new owner to accept an ownership transfer
    */
  /*  function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }*/
}
