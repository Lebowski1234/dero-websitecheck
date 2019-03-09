# Website Validation Smart Contract

This smart contract was written for the Dero Stargate Smart Contract competition. This document contains a functional description and usage instructions.

This smart contract attempts to solve two problems for websites where security is a high priority:

1 - A website may fall victim to DNS highjacking, whereby the domain name is pointed to a malicious IP address. It may be possible for the user to detect the security breach by checking the SSL credentials (or lack thereof), however if the highjacker has created a self-signed SSL certificate, many users may not notice. 

2 - A website owner may wish to change the domain name. If the name change is unplanned (for example a torrent site has been closed down by the hosting service), how does the website owner communicate the new domain to the regular users of the website? How do the users know that a name change is legitimate, or whether the address of a phishing site is being circulated?

Some examples of where this smart contract may be particularly useful are:

* Cryptocurrency web wallets, which are prime targets for hackers as large sums of cryptocurrency are at stake. 
* Torrent sharing websites, which get taken offline regularly.
* Download sites for cryptocurrency node / wallet binaries, where there is an incentive for hackers to embed malicious code (e.g. key loggers. 


## Disclaimer

This contract was written for the Dero Stargate testnet. This smart contract may require modifications to function correctly on the main network. Use at your own risk. 

The example website in the smart contract is the Dero web wallet. Please note that the author of this smart contract does not own this website, and this smart contract should therefore not be used to verify the secuirty of the example website. 


## Functional Description

The website validation smart contract allows a website owner to store the website domain, IP address and description on the Dero blockchain. The smart contract address is then given out to the general public. Anybody can then retrieve this data from the smart contract, and compare the stored IP address with the actual IP address (this is best achieved with a user interface application which does the checking automatically). 

The website owner can update the domain, IP address and description at any time. The website owner may also delegate authority to other users (for example team members of an organisation or community), whose accounts are stored in the smart contract. The website owner may remove access by these other owners at any time. The domain, IP address and website description cannot be changed by anybody who is not in the list of owners.

The website owner can transfer ownership of the smart contract to a new owner (for example, if a website is sold). 


## Limitations

In the current form, the smart contract and associated user interface will only handle websites with a single IP address. High traffic websites (e.g. Google) sometimes use multiple servers with multiple IP addresses all tied to a single domain. The contract and user interface would need to be modified to handle this situation. If this is of interest to anyone, please submit an issue. 


## Interacting with the Smart Contract

### Users

The contract is intended to be accessed by website users on a regular basis, and a user interface is the easiest way to do this. A user interface has been written for this contract here: [https://github.com/lebowski1234/dero-websitecheck-ui](https://github.com/lebowski1234/dero-websitecheck-ui)

### Owners

Most websites will be updated infrequently. Therefore, a user interface for the update functions has not been written. If there is demand for this, please raise an issue. Full command line instructions are provided below for updating the data held within the contract by the owners. 
 

## Contract Setup 

Before deployment, the website parameters must be configured by the person deploying the contract. This person automatically becomes Owner 1.

All user defined parameters are grouped under the userSetup and websiteSetup function:

 
```
Function userSetup(signer String) Uint64
10 STORE("numberOfOwners", 2)
20 STORE("owner1", signer) 
//Add addresses of additional owners below.
30 STORE("owner2", "dEToiUSsRuXhpuchPysaTe739mXdWGpYvBNZZwqjJgBoaNKY3UoM2AcJ3zwfed8fEBAfTjX2P8iwxW2XP9kb8KaE1rZJzNLU2b")
40 STORE("owner3", "")
50 STORE("owner4", "")
60 STORE("owner5", "")
70 STORE("owner6", "")
//Add more owners below if more than 6 owners required. 
80 PRINTF "User setup complete!"
90 RETURN 0
End Function

//websiteSetup: the person deploying the contract can setup the website URL, IP address and description here.
Function websiteSetup() Uint64
10 STORE("websiteURL", "derowallet.io")
20 STORE("websiteIP", "46.166.148.8")
30 STORE("websiteDescription", "The Official Dero Web Wallet")
40 PRINTF "Website setup complete!"
50 RETURN 0
End Function
```

These variables must be changed to suit the requirements of the owners. There are no self-checking functions within the smart contract to verify that the data has been entered correctly. The instructions must be followed carefully, to avoid unintended consequences. 


### Number of Owners

The number of owners is declared in Line 10 of userSetup. This can be changed to any number above 1. In this example, there are 2 owners:


```
10 STORE("numberOfOwners", 2)
```


### Owner Addresses

The person deploying the contract automatically becomes owner 1. The addresses of all other owners must be declared prior to contract deployment. These are declared as text values from Line 30 onwards in userSetup. For example, for 2 owners:

```
30 STORE("owner2", "dEToiUSsRuXhpuchPysaTe739mXdWGpYvBNZZwqjJgBoaNKY3UoM2AcJ3zwfed8fEBAfTjX2P8iwxW2XP9kb8KaE1rZJzNLU2b")
40 STORE("owner3", "")
50 STORE("owner4", "")
60 STORE("owner5", "")
70 STORE("owner6", "")
```

If the required number of owners is less than 6, just leave unused owners blank. 

For more than 6 owners, just add new lines after 70. Remember to set the numberOfOwners variable to match! Owners must be declared in sequential order. No blank addresses are allowed between declared owners!


### Website Details

The website domain, IP address, and description are specified in the websiteSetup function:

```
//websiteSetup: the person deploying the contract can setup the website URL, IP address and description here.
Function websiteSetup() Uint64
10 STORE("websiteURL", "derowallet.io")
20 STORE("websiteIP", "46.166.148.8")
30 STORE("websiteDescription", "The Official Dero Web Wallet")
40 PRINTF "Website setup complete!"
50 RETURN 0
End Function
```

The domain name must be in the most simple form for use with the [user interface](https://github.com/lebowski1234/dero-websitecheck-ui), for example:

derowallet.io


The following are not acceptable:

* www.derowallet.io
* https://derowallet.io
* derowallet.io/index.html

The IP address must be entered exactly, with no preceding or trailing spaces.

The website description can be anything. It is for information only, and not used for verification. 


## Contract Deployment

Once setup has been complete, the contract is deployed:

```
curl --request POST --data-binary @websitecheck.bas http://127.0.0.1:30309/install_sc
```

The Dero Stargate daemon and wallet must both be running first. The wallet must be unlocked and have minimum 50 Dero unlocked balance available.

Get the Dero Stargate binaries here:

[https://git.dero.io/DeroProject/Dero_Stargate_testnet_binaries](https://git.dero.io/DeroProject/Dero_Stargate_testnet_binaries)


To run the daemon:

```
./derod-linux-amd64 --testnet
```

To run the wallet:

```
./dero-wallet-cli-linux-amd64 --rpc-server --wallet-file testnetwallet.db --testnet
```
 

## Command Line Usage

All owners listed in the smart contract can update the IP address, domain name, and description. All other functions can only be called by Owner 1. 


### Update IP Address

The following example updates the IP address to 123.4.5.6:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"UpdateIP","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "Data":"123.4.5.6" } } }}'
```

### Update Domain Name

The following example updates the domain name to google.com:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"UpdateURL","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "Data":"google.com" } } }}'
```

### Update Description

The following example updates the description to "Official Google Website":

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"UpdateDescription","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "Data":"Official Google Website" } } }}'
```

### Update Owner

This function is used to update an existing owner, or add an additional owner. Only owners 2 onwards can be updated using this function. Owner 0 does not exist and will be rejected. Owner 1 must be updated using the onwnership transfer functions (see below), to eliminate the risk of owner 1 accidentally transfering ownership to an unintended address. 

The following example updates owner 2 to dEToj2C887HTgd81eYCxtwhvZLnkMEuWUFfGcA5onfTGZEo83PH2pEz6R21k7YGdUvZJR33YsPMCSAEW1yFsQDhU2WohB7AjWA:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"UpdateOwner","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "ownerNo":"2","newOwner":"dEToj2C887HTgd81eYCxtwhvZLnkMEuWUFfGcA5onfTGZEo83PH2pEz6R21k7YGdUvZJR33YsPMCSAEW1yFsQDhU2WohB7AjWA" } } }}'
```

### Update Number Of Owners

The number of owners must be updated if additional owners are added. The following example updates the number of owners to 3:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"UpdateNumberOfOwners","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "number":"3" } } }}'
```

### Transfer Ownership

The following example transfers the ownership to dEToc2bFpqcfK6UPUJBwe7DPbhCZELzuaUGbBHjvrUCb5SPhfXM1FpvbV3oTEMYUbT3AgSicDoFdbCrJW3rKDGWz5x4SWyvV1Q:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"TransferOwnership","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f", "params":{ "newOwner":"dEToc2bFpqcfK6UPUJBwe7DPbhCZELzuaUGbBHjvrUCb5SPhfXM1FpvbV3oTEMYUbT3AgSicDoFdbCrJW3rKDGWz5x4SWyvV1Q" } } }}'
```

The new owner must then call the following function to claim onwership and complete the transfer:

```
curl -X POST http://127.0.0.1:30309/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"transfer_split","params":{"mixin":5,"get_tx_key": true , "sc_tx":{"entrypoint":"ClaimOwnership","scid":"9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f" } }}'
```

### Displaying Domain Name, IP Address, and Website Description

This is best done through the user interface, however can be done using the following curl command:

```
curl -X POST http://127.0.0.1:30306/gettransactions -H 'Content-Type: application/json' -d '{"txs_hashes":["9caa493a0167238cef5ec0394558a2bd9127c82f8bf0e90ea572aaf3703e819f"], "sc_keys": ["websiteURL", "websiteIP", "websiteDescription"]}'
```

Then search for the relevant fields in the JSON data displayed after the curl command. 


## Contact Details

I plan to update the smart contract and user interface for the Dero main network, when smart contracts become live. To report a bug, please open an issue in github. 

My contact details are: thedudelebowski1234@gmail.com

Finally, if you found this useful, any Dero donations are most welcome! dERoSME4c5GNUvPo27NsRFeJPR1FKiYt87g8Gknbm6JU9eL3xRPDs6JijHuVNxVzyFZXg1wxjbh52Hu9gUfWd3Lx5QRNTXvJWZ



