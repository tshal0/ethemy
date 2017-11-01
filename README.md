# Ethemy

## Contract Requirements

### 1.	Contract
* Contract can add/remove user addresses
* Contract can add/remove/update sets of user addresses (workflows)
* Contract can create entities that require multiple signatures
* Contract can release funding or trigger some action once entity is “awarded”. 

### 2.	Users

* Users are represented by their addresses.
* Users can view all entities they have signatures on, or have the ability to sign. 
* Users can create entities. 
* Users can select other users (or sets of users) to participate in the signing process.

### 3.	Entities

* Entities will contain the ability to accept User Confirmations (signatures) or Revocations (signature withdrawals). 
* Entities will maintain state of confirmation based on how many and which Users have signed them. 
* Entities will execute a designated function once all signatures have been acquired. 
* Entities will be represented by addresses or some other form of identification.
