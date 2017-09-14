module.exports = {
  networks: {
    "live": {
      network_id: 1,
      host: "localhost",
      port: 8545
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
