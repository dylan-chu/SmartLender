# SmartLender
SmartLender is a smart contract written for the Ethereum blockchain.  Its purpose is to facilitate offline loans using ethers as collateral.  
A group of 4 (Yogi Golle, Shubbankar Singh, Obim Okongwu and Dylan Chu) initially worked on this project.  

# Coding Language
The contract is written in [Solidity] (https://solidity.readthedocs.io/en/latest/index.html).

# How It Works
1. A borrower deploys the contract on the blockchain.
2. The borrower puts up collateral by sending ethers to the contract.  Other people may also contribute additional collateral by sending ethers to the contract.
3. When the borrower wants to request a loan from a specific lender, the borrower notifies the contract with the lenders' address.  The contract locks up all of the collateral.
4. If the lender approves the request, the lender notifies the contract with the amount and end date of the loan.  If the lender rejects the request, the borrower is free to request a loan from another lender.
5. When lender requests a payment from the borrower, the lender notifies the contract of the payment amount and gives it a hash.
6. When the borrower makes the payment in the real world, the lender gives the borrower the key to the hash.  
7. The borrower notifies the contract of the paid amount along with the provided key, the contract deducts the payment amount from the outstanding balance of the loan.
8. If the end date of the loan has passed and there is still an outstanding loan balance, the lender can ask the contract to seize the collateral.  The contract will send all collateralized ethers to the lender's address. 

# How to Deploy It to a Ethereum TestNet
To compile the contract to bytecode, paste the code into the browser at http://ethereum.github.io/browser-solidity/#version=soljson-latest.js

* Instructions for deploying to the [Morden TestNet] (https://github.com/ethereum/wiki/wiki/Morden) will be available in the future.

