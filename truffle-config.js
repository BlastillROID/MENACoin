module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
     ropsten:  {
     network_id: 3,
     host: "localhost",
     port:  8545,
     gas:   2900000
}
  },
  
   rpc: {
 host: 'localhost',
 post:8080
   },

   live: {
    network_id: 1,
    host: "127.0.0.1",
    port: 8546   // Different than the default below
  }
};