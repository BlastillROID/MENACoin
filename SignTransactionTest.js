const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const Tx = require('ethereumjs-tx');

var privateKey = new Buffer("4c33ee56f4b3475daf4668d7b898a61fc18dd3c9d6d4cd23cabca8a3ec531606","hex");
const web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/tDEqTVskM5EDSsOTGS6k"));

var input = 
{      
    'Utils.sol' : fs.readFileSync('./contracts/MENACoin/Utils.sol','utf8'),
     'TokeHolder.sol' : fs.readFileSync('./contracts/MENACoin/TokenHolder.sol','utf8'),
     'Owned.sol' : fs.readFileSync('./contracts/MENACoin/Owned.sol','utf8'),
     'Token.sol' : fs.readFileSync('./contracts/MENACoin/Token.sol','utf8'),
     'IMENA.sol' : fs.readFileSync('./contracts/Interfaces/IMENA.sol','utf8'),
     'IOwned.sol' : fs.readFileSync('./contracts/Interfaces/IOwned.sol','utf8'),
     'IToken.sol' : fs.readFileSync('./contracts/Interfaces/IToken.sol','utf8'),
     'ITokenHolder.sol' : fs.readFileSync('./contracts/Interfaces/ITokenHolder.sol','utf8'),
     'MENA.sol' : fs.readFileSync('./contracts/MENACoin/MENA.sol','utf8')

}
let output = solc.compile(input.toString(), 1);
console.log("test");
console.log(output['errors']);
const bytecode = output.contracts[':MENA'].bytecode;

const abi = JSON.parse(output.contracts[':MENA'].interface);

const contract = web3.eth.contract(abi);

const contractData = contract.new.getData({data: "0x" + bytecode});
const gasPrice = web3.eth.gasPrice;
const gasPriceHex = web3.toHex(gasPrice);
const gasLimitHex = web3.toHex(300000);

const nonce = web3.eth.getTransactionCount(web3.eth.coinbase);

const nonceHex = web3.toHex(nonce);

const rawTx = {

    nonce: nonceHex,
    gasPrice: gasPriceHex,
    gasLimit: gasLimitHex,
    data: contractData,
    from: web3.eth.coinbase

};

const tx = new tx(rawTx);
tx.sign(privateKey);

const serializedTx = tx.serialize();

web3.eth.sendRawTransaction(serializedTx.toString('hex'), (err, hash) => {
    if (err) { console.log(err); return; }

    // Log the tx, you can explore status manually with eth.getTransaction()
    console.log('contract creation tx: ' + hash);

    // Wait for the transaction to be mined
    waitForTransactionReceipt(hash);
});
