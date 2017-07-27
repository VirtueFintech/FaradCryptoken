module.exports = {
  networks: {
    ropsten: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    },
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    }
  },
  rpc: {
    host: "localhost",
    port: 8545
  },
  mocha: {
    useColors: true
  }
};
