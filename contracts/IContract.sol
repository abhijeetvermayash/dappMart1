pragma solidity >=0.4.22 <0.9.0;

// Interface cannot have constructor
//All declared function must be external
//Interface only has defination no body

interface IContract {
    function addFunds() external payable;

    function withDraw(uint256 amount) external;
}
