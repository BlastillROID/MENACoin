pragma solidity ^0.4.21;
 

 
 // ----------------------------------------------------------------------------
 // Safe maths
 // ----------------------------------------------------------------------------
 library SafeMath {
     function add(uint a, uint b) internal pure returns (uint c) {
         c = a + b;
         require(c >= a);
     }
     function sub(uint a, uint b) internal pure returns (uint c) {
         require(b <= a);
         c = a - b;
     }
     function mul(uint a, uint b) internal pure returns (uint c) {
        if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
     }
     function div(uint a, uint b) internal pure returns (uint c) {
         require(b > 0);
         c = a / b;
     }
 }

 
 
 // ----------------------------------------------------------------------------
 // ERC Token Standard #20 Interface
 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
 // ----------------------------------------------------------------------------
 contract ERC20Interface {
     function totalSupply() public constant returns (uint);
     function balanceOf(address tokenOwner) public constant returns (uint balance);
     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
     function transfer(address to, uint tokens) public returns (bool success);
     function approve(address spender, uint tokens) public returns (bool success);
     function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
     event Transfer(address indexed from, address indexed to, uint tokens);
     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
 }
 
 
 // ----------------------------------------------------------------------------
 // Contract function to receive approval and execute function in one call
 //
 // Borrowed from MiniMeToken
 // ----------------------------------------------------------------------------
 contract ApproveAndCallFallBack {
     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
 }
 
 
 // ----------------------------------------------------------------------------
 // Owned contract
 // ----------------------------------------------------------------------------
 contract Owned {
     address public owner;
     address public newOwner;
     address public coinseller;
 
     event OwnershipTransferred(address indexed _from, address indexed _to);
 
     function Owned() public {
         owner = msg.sender;
     }
 
     modifier onlyOwner {
         require((msg.sender == owner) || (msg.sender == coinseller));
         _;
     }
     
     function SetCoinSeller(address seller) public onlyOwner{
        coinseller = seller;
    }
 
     function transferOwnership(address _newOwner) public onlyOwner {
         newOwner = _newOwner;
     }
     function acceptOwnership() public {
         require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
         owner = newOwner;
         newOwner = address(0);
     }
 }
 
 
 // ----------------------------------------------------------------------------
 // ERC20 Token, with the addition of symbol, name and decimals and an
 // initial fixed supply
 // ----------------------------------------------------------------------------
 contract PlayCoin is ERC20Interface, Owned {
     using SafeMath for uint;
 
     string public symbol;
     string public  name;
     uint8 public decimals;
     uint public _totalSupply;
   /*  struct Bet {
        address playerone; // first betting player
        address playertwo;  // second betting player
        address executedFrom ;// execution address 
        uint betvalue; // bet amount in playcoin
        bool finished; // bet finished and winner got transaction
        address swap1;
        address swap2;
    }
     mapping(address => Bet) bets; */
     mapping(address => mapping(address => uint)) gamesBalances;
     mapping(address => uint) gamesUnits;
     mapping(address => uint) balances;
     mapping(address => mapping(address => uint)) allowed;
 
 
     // ------------------------------------------------------------------------
     // Constructor
     // ------------------------------------------------------------------------
     function PlayCoin() public {
         symbol = "PLYC";
         name = "PlayCoin";
         decimals = 4;
         _totalSupply = 1000000 * 10**uint(decimals);
         balances[owner] = _totalSupply;
       emit  Transfer(address(0), owner, _totalSupply);
     }
    function topUp(address sender, address game,uint coins) public returns(bool success) {
      
        transfer(game,coins.mul(gamesUnits[game]));
        gamesBalances[game][sender] += coins;
     emit Transfer(sender,game,coins.mul(gamesUnits[game]));
        return true;
    }
    function cashOut(address sender,address player,uint gameCoins) public returns(bool success){
        if(gamesBalances[sender][player]>= gameCoins){
            transfer(player,gameCoins .mul(gamesUnits[sender]));
            gamesBalances[sender][player] -= gameCoins;
          emit  Transfer(sender,player,gameCoins.mul(gamesUnits[sender]));
            return true;
        }
    }
        function win(address sender,address player,uint gameCoins) public returns(bool success){
        if(balances[sender]>= gameCoins.mul(gamesUnits[sender])){
            gamesBalances[sender][player] += gameCoins;
            return true;
        }
        }
                function lose(address sender,address player,uint gameCoins) public returns(bool success){
        if(gamesBalances[sender][player]>= gameCoins){
            gamesBalances[sender][player] -= gameCoins;
            return true;
        }
        }
    function setGameUnitPrice(address game,uint unit) public returns(bool success){
        gamesUnits[game] = unit;
        return true;
    }
    function getGameUnitPrice(address game) public constant returns(uint gameUnit) {
        return gamesUnits[game];
    }
       function gameBalanceOf(address tokenOwner,address game) public constant returns (uint balance) {
         return gamesBalances[game][tokenOwner];
     }
 /*    function placeBet(address excutedFrom, address p1, address p2, uint betvalue,address swap1,address swap2) public returns(bool success) {
                var newBet = Bet(p1, p2,excutedFrom, betvalue,false,swap1,swap2);
               if (transferFrom(p1,swap1,betvalue)) {
               if (transferFrom(p2,swap2,betvalue)) {
                bets[swap1] = newBet;
                return true;
               } else {
                   return false;
               }
               }
    }
    function finishBet(address swap, uint winner) public returns(bool success) {
         address winnerAddress;
                if (winner==1) {
                     winnerAddress = bets[swap].playerone;
                }else {
                     winnerAddress = bets[swap].playertwo;
                }
               transferFrom(swap,winnerAddress,bets[swap].betvalue);
               transferFrom(bets[swap].swap2,winnerAddress,bets[swap].betvalue);
               return true; 
    }
    function cancelBet(address swap) public returns (bool success) {
         transferFrom(swap,bets[swap].playerone,bets[swap].betvalue);
               transferFrom(bets[swap].swap2,bets[swap].playertwo,bets[swap].betvalue);
               return true;
    } */
     
     // ------------------------------------------------------------------------
     // Total supply
     // ------------------------------------------------------------------------
     function totalSupply() public constant returns (uint) {
         return _totalSupply - balances[address(0)];
     }
 
 
     // ------------------------------------------------------------------------
     // Get the token balance for account `tokenOwner`
     // ------------------------------------------------------------------------
     function balanceOf(address tokenOwner) public constant returns (uint balance) {
         return balances[tokenOwner];
     }
 
 
     // ------------------------------------------------------------------------
     // Transfer the balance from token owner's account to `to` account
     // - Owner's account must have sufficient balance to transfer
     // - 0 value transfers are allowed
     // ------------------------------------------------------------------------
     function transfer(address to, uint tokens) public returns (bool success) {
         balances[msg.sender] = balances[msg.sender].sub(tokens);
         balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
         return true;
     }
 
 
     // ------------------------------------------------------------------------
     // Token owner can approve for `spender` to transferFrom(...) `tokens`
     // from the token owner's account
     //
     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
     // recommends that there are no checks for the approval double-spend attack
     // as this should be implemented in user interfaces 
     // ------------------------------------------------------------------------
     function approve(address spender, uint tokens) public returns (bool success) {
         allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
         return true;
     }
 
 
     // ------------------------------------------------------------------------
     // Transfer `tokens` from the `from` account to the `to` account
     // 
     // The calling account must already have sufficient tokens approve(...)-d
     // for spending from the `from` account and
     // - From account must have sufficient balance to transfer
     // - Spender must have sufficient allowance to transfer
     // - 0 value transfers are allowed
     // ------------------------------------------------------------------------
     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
         balances[from] = balances[from].sub(tokens);
         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
         balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
         return true;
     }
 
 
     // ------------------------------------------------------------------------
     // Returns the amount of tokens approved by the owner that can be
     // transferred to the spender's account
     // ------------------------------------------------------------------------
     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
         return allowed[tokenOwner][spender];
     }
 
 
     // ------------------------------------------------------------------------
     // Token owner can approve for `spender` to transferFrom(...) `tokens`
     // from the token owner's account. The `spender` contract function
     // `receiveApproval(...)` is then executed
     // ------------------------------------------------------------------------
     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
         allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
         return true;
     }
 
 
     // ------------------------------------------------------------------------
     // Don't accept ETH
     // ------------------------------------------------------------------------
     function () public payable {
         revert();
     }
 
 
     // ------------------------------------------------------------------------
     // Owner can transfer out any accidentally sent ERC20 tokens
     // ------------------------------------------------------------------------
     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
         return ERC20Interface(tokenAddress).transfer(owner, tokens);
     }
 }