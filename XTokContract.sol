pragma solidity ^0.8.0;

contract XTokContract {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        name = "xTokenName";
        symbol = "xTOK";
        decimals = 18;
        totalSupply = 0; // Initialize total supply to 0
    }

    function Mint(address to, uint256 value) external {
        totalSupply += value;
        balanceOf[to] += value;

        emit Transfer(address(0), to, value);
    }

    function Burn(address from, uint256 value) external {
        require(balanceOf[from] >= value, "Insufficient balance");

        totalSupply -= value;
        balanceOf[from] -= value;

        emit Transfer(from, address(0), value);
    }
}
