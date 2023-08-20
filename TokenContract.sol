pragma solidity ^0.8.0;

import "./XTokContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenContract is Ownable {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed user, uint256 amount);
    event Mint(address indexed user, uint256 amount);

    XTokContract private xTokContract;

    constructor(address _xTokContractAddress) {
        name = "TokenName";
        symbol = "TOK";
        decimals = 18;
        totalSupply = 1000000 * (10**uint256(decimals)); // Total supply of tokens

        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the contract deployer

        xTokContract = XTokContract(_xTokContractAddress);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(value <= balanceOf[msg.sender], "Insufficient balance");
        require(to != address(0), "Invalid recipient address");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Insufficient allowance");
        require(to != address(0), "Invalid recipient address");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;
    }
}
