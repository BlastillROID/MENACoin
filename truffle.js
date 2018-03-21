//var HDWalletProvider = require("truffle-hdwallet-provider");
//var mnemonic = "orange apple banana chocolate cake bread pie candy sugar caramel ganeshe icecream ";
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
   // ropsten: {
   //  provider: function () {
      //  return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/tDEqTVskM5EDSsOTGS6k ")
   //   },
    //  from: "0x0A44fB602b440E89BD44Bc586D04D594D4aE49cc",
    //  network_id: 3,
   //   gas:   2900000
   // }
  },

  rpc: {
    host: 'localhost',
    post: 8080
  },

  live: {
    network_id: 1,
    host: "127.0.0.1",
    port: 8546 // Different than the default below
  }
};