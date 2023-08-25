// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TokenVault {
    address public owner;
    address[] public whitelistedAddresses;
    mapping(address => uint256) public lastWithdrawalTimestamp;
    mapping(address => bool) public slashedAddresses;
    mapping(address => uint256) public withdrawalLimit;
    mapping(address => uint256) public withdrawalCooldown;
    mapping(address => uint256) public slashType;

    IERC20 private token; // Define the ERC20 token contract

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = IERC20(_tokenAddress); // Initialize the ERC20 token contract
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender), "Address not whitelisted");
        _;
    }

    function isWhitelisted(address addr) public view returns (bool) {
        return slashedAddresses[addr] == false;
    }

    function addWhitelistedAddress(address addr) external onlyOwner {
        whitelistedAddresses.push(addr);
    }

    function removeWhitelistedAddress(address addr) external onlyOwner {
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == addr) {
                delete whitelistedAddresses[i];
                break;
            }
        }
    }

    function slashAddress(address addr, uint256 slashType_) external onlyOwner {
        slashedAddresses[addr] = true;
        slashType[addr] = slashType_;
    }

    function setWithdrawalLimit(address addr, uint256 limit, uint256 cooldown) external onlyOwner {
        withdrawalLimit[addr] = limit;
        withdrawalCooldown[addr] = cooldown;
    }

    function addSlashedAddress(address addr, uint256 slashType_) external onlyOwner {
        slashedAddresses[addr] = true;
        slashType[addr] = slashType_;
    }

    function transferTokens(address recipient, uint256 amount) external onlyWhitelisted {
        require(amount <= withdrawalLimit[msg.sender], "Transfer amount exceeds limit");
        require(block.timestamp >= lastWithdrawalTimestamp[msg.sender] + withdrawalCooldown[msg.sender], "Transfer cooldown not met");

        lastWithdrawalTimestamp[msg.sender] = block.timestamp;

        emit Transfer(msg.sender, recipient, amount);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
}
