//
//Website Validation Smart Contract! Written by thedudelebowski for the Dero smart contract competition!
//Version 1.0 - Competition entry 
//Check out https://github.com/lebowski1234/dero-websitecheck for setup and usage instructions. 


// This function is used to initialize parameters during install time
Function Initialize() Uint64
10 userSetup(SIGNER())
20 websiteSetup()
30 contractIntro()
40 RETURN 0
End Function


//userSetup: the person deploying the contract (owner1 - master owner) can add additional owners who are authorized to update the URL and IP address information in future.
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


//contractIntro: Display greeting and useful information, github link etc. 
Function contractIntro() Uint64
10 PRINTF "Contract initialized!"
20 PRINTF "Website Validation Smart Contract written by thedudelebowski for the Dero smart contract competition!"
30 PRINTF "For usage instructions, refer to https://github.com/lebowski1234/dero-websitecheck "
40 PRINTF "Please note: this smart contract was written for the Stargate testnet. Use at your own risk!"
50 RETURN 0
End Function


//UpdateIP: call this function to change the IP address. 
Function UpdateIP(Data String) Uint64
10 DIM ownerNo as Uint64
20 LET ownerNo = verifySigner(SIGNER())
30 IF ownerNo != 0 THEN GOTO 50
35 PRINTF "Signer address not found in list of owners"
40 RETURN 0
50 STORE("websiteIP", Data)
55 PRINTF "Updated IP address = %s" Data
60 RETURN 0
End Function


//UpdateURL: call this function to change the website URL
Function UpdateURL(Data String) Uint64 
10 DIM ownerNo as Uint64
20 LET ownerNo = verifySigner(SIGNER())
30 IF ownerNo != 0 THEN GOTO 50
35 PRINTF "Signer address not found in list of owners"
40 RETURN 0
50 STORE("websiteURL", Data)
55 PRINTF "Updated URL: %s" Data
60 RETURN 0
End Function


//UpdateDescription: call this function to change the website description
Function UpdateDescription(Data String) Uint64 
10 DIM ownerNo as Uint64
20 LET ownerNo = verifySigner(SIGNER())
30 IF ownerNo != 0 THEN GOTO 50
35 PRINTF "Signer address not found in list of owners"
40 RETURN 0
50 STORE("websiteDescription", Data)
55 PRINTF "Updated website description: %s" Data
60 RETURN 0
End Function


//UpdateOwner: Owner 1 can call this function to update, add or remove owners. To remove an owner, owner address can be set to "null", allowing frontend UI code to use omitEmpty or similar in JSON structs.
Function UpdateOwner(ownerNo Uint64, newOwner String) Uint64
10 IF ADDRESS_RAW(SIGNER()) == ADDRESS_RAW(LOAD("owner1")) THEN GOTO 40
20 PRINTF "Signer is not owner 1 (contract master owner)"
30 RETURN 0
40 IF newOwner == "null" THEN GOTO 100  
45 IF IS_ADDRESS_VALID(newOwner) == 1 THEN GOTO 65
50 PRINTF "Recipient not a valid Dero address"
60 RETURN 0 
65 IF ownerNo <= 1 THEN GOTO 67 //Prevent Owner 1 ownership change with this function (prevents getting locked out if there's a mistake) and prevents Owner 0 being created. 
66 GOTO 70
67 PRINTF "Owner %d cannot be changed with UpdateOwner function" ownerNo  
68 RETURN 0
70 STORE("owner" + ownerNo, newOwner)
80 PRINTF "Updated owner %d to %s" ownerNo newOwner
90 RETURN 0
100 STORE("owner" + ownerNo, "")
110 PRINTF "Removed owner %d" ownerNo
120 RETURN 0
End Function


//UpdateNumberOfOwners: call this function if owners are added or removed. 
Function UpdateNumberOfOwners(number Uint64) Uint64
10 IF ADDRESS_RAW(SIGNER()) == ADDRESS_RAW(LOAD("owner1")) THEN GOTO 40
20 PRINTF "Signer is not owner 1 (contract master owner)"
30 RETURN 0
40 IF number >0 THEN GOTO 70 //Make sure we have at least 1 owner
50 PRINTF "Number of owners cannot be 0"
60 RETURN 0
70 STORE("numberOfOwners", number)
80 PRINTF "Updated number of owners to %d" number
90 RETURN 0
End Function


//Function verifySigner: Check that signer is an owner. 
Function verifySigner(s String) Uint64
10 DIM inc, numberOfOwners as Uint64
30 LET numberOfOwners = LOAD("numberOfOwners")
40 LET inc = 1
50 IF ADDRESS_RAW(s) == ADDRESS_RAW(LOAD("owner" + inc)) THEN GOTO 110
60 IF inc == numberOfOwners THEN GOTO 90 //we have reached numberOfOwners, and not matched the signer's address to an owner.
70 LET inc = inc + 1
80 GOTO 50
90 PRINTF "Signer address not found in list of owners"
100 RETURN 0 //Signer ownership check has failed, result is 0. Calling functon must exit on 0. 
110 RETURN inc //Signer is in list of owners, return owner index.
End Function


//TransferOwnership and ClaimOwnership were taken from https://git.dero.io/DeroProject/dvm_doc/src/master/lottery.bas
// Owner 1 can transfer ownership. 
Function TransferOwnership(newOwner String) Uint64 
10  IF ADDRESS_RAW(LOAD("owner1")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
20  RETURN 1
30  STORE("tmpowner",newOwner)
40  RETURN 0
End Function
	
// until the new owner claims ownership, existing owner remains owner
Function ClaimOwnership() Uint64 
10  IF ADDRESS_RAW(LOAD("tmpowner")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
20  RETURN 1
30  STORE("owner1",SIGNER()) // ownership claim successful
40  RETURN 0
End Function

