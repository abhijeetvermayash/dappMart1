pragma solidity >=0.4.22 <0.9.0;

//we will have to specify abstract keyword here
abstract contract Logger {
    function logging() public pure virtual returns (bytes32);

    //since it is an abstract keyword we have to specify
    // virtual keyword
}
