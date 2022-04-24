pragma solidity >=0.4.22 <0.9.0;

import "./Owner.sol";
import "./Logger.sol";
import "./IContract.sol";

contract MyContract is Owner, Logger, IContract {
    //address[] private funders;

    uint256 public numOFFunders;
    // address public owner;

    mapping(uint256 => address) private funders;
    mapping(address => bool) private addresses;

    // constructor() {
    //     //it is the first thing that is called
    //     owner = msg.sender;
    // }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "only owner can call this function");
    //     _;
    // }

    //we take the onlyOwner modifier in Owner.sol
    //we can inherit that from there now

    //rather than writing require statements again and again
    //we can use modifier
    modifier limitWithdraw(uint256 amount) {
        require(
            amount <= 100000000000000000,
            "Cannot withdraw more than 0.1 ETH"
        );
        _; //undescore semicolon here means the body of the func in which
        //the modifier is called
    }

    //we can restrict any function by using a modifier

    //for ex

    /*
    function test1() external {

        //some managing stuff that only admin should have access to
       


    }
     //so we create a modifier and use this function as

    function test1() external name_of_modifier(){

    }

    
     */

    function test1() external onlyOwner {
        //now if the msg sender address has the address of owner
        //then only they will be able to call this function
        //means only owner can call this function
    }

    function transferOwnerShip(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    receive() external payable {}

    // this function is a special function
    // it is called when you make a transaction that doesn't specify function
    // name to call

    //external function are part of the smart contract interface
    // which means they can be called via contract and other txs

    //payable-> when we make a txn we can specify value property
    // which can provide ether in  txn

    function logging() public pure override returns (bytes32) {
        return "Hello";
    }

    //abstract function from logger

    function addFunds() external payable override {
        if (!addresses[msg.sender]) {
            uint256 index = numOFFunders++;
            funders[index] = msg.sender;
            addresses[msg.sender] = true;
        }
    }

    function getOwner() external returns (address) {
        return owner;
    }

    function withDraw(uint256 amount)
        external
        override
        limitWithdraw(amount)
        onlyOwner
    {
        // require(
        //     amount <= 100000000000000000,
        //     "Cannot withdraw more than 0.1 ETH"
        // );

        //since we added our modifier in the function defination
        //it will take that condition from the modifier

        payable(msg.sender).transfer(amount);

        //if (amount < 1000000000000000000) payable(msg.sender).transfer(amount);
    }

    //withdraw will withdraw the money from smart contract
    //and give it to the user address specified
    // the address of the user that we mention in from during calling

    function getFunderbyindex(uint256 index) public view returns (address) {
        return funders[index];
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOFFunders);

        for (uint256 i = 0; i < numOFFunders; i++) {
            _funders[i] = funders[i];
        }
        return _funders;
    }
}

//to migrare again

//truffle migrare --reset

//truffle console

//const instance = await MyContract.deployed();

//instance.addFunds({from:accounts[0],value:"2000000000000000000"})

//instance.getAllFunders();

//instance.getFunderbyIndex(0);

//instance.withDraw("500000000000000000", {from:accounts[0]})
