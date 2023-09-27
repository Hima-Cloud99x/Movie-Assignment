const Web3 = require('web3');


if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    
    const providerUrl = 'http://localhost:8545'; //Not connected 
    web3 = new Web3(new Web3.providers.HttpProvider(providerUrl));
}
