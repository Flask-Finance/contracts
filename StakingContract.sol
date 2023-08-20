import "./TokenContract.sol";
import "./XTokContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract is Ownable {
    using SafeMath for uint256;

    TokenContract private tokenContract;
    XTokContract private xTokContract;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public stakingRewards;
    mapping(address => uint256) public stakingTimestamps;
    uint256 public totalStaked;
    uint256 public constant lockUpPeriod = 0; // Placeholder lock-up period of 30 days

    uint256 private constant REWARD_RATE = 100; // Placeholder reward rate for demonstration purposes

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(address _tokenContractAddress, address _xTokContractAddress) {
        tokenContract = TokenContract(_tokenContractAddress);
        xTokContract = XTokContract(_xTokContractAddress);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer the tokens from the user to the contract
        require(tokenContract.transferFrom(msg.sender, address(this), amount), "TransferFrom failed");

        // Update the user's balance and the total staked amount
        balances[msg.sender] = balances[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);

        // Mint xTOK tokens to the user
        xTokContract.Mint(msg.sender, amount);

        // Record the staking timestamp
        stakingTimestamps[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        require(balances[msg.sender] > 0, "No tokens staked");
        require(isLockUpPeriodFinished(msg.sender), "Tokens are still locked up");

        uint256 amount = balances[msg.sender];

        // Burn xTOK tokens from the user
        xTokContract.Burn(msg.sender, amount);

        // Deduct the amount from the user's balance and the total staked amount
        balances[msg.sender] = 0;
        totalStaked = totalStaked.sub(amount);

        // Transfer the tokens back to the user
        require(tokenContract.transfer(msg.sender, amount), "Transfer failed");

        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external {
        require(balances[msg.sender] > 0, "No tokens staked");

        uint256 rewardAmount = calculateRewards(msg.sender);
        require(rewardAmount > 0, "No rewards to claim");

        // Transfer the rewards to the user
        require(tokenContract.transfer(msg.sender, rewardAmount), "Transfer failed");

        // Update the user's staking rewards
        stakingRewards[msg.sender] = stakingRewards[msg.sender].add(rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function calculateRewards(address user) private view returns (uint256) {
        uint256 stakedAmount = balances[user];
        uint256 stakingDuration = block.timestamp.sub(stakingTimestamps[user]);

        // Apply a time-based factor to the rewards based on the staking duration
        uint256 rewards = stakedAmount.mul(REWARD_RATE).mul(stakingDuration).div(lockUpPeriod).div(100);

        return rewards;
    }

    function isLockUpPeriodFinished(address user) private view returns (bool) {
        return block.timestamp.sub(stakingTimestamps[user]) >= lockUpPeriod;
    }

    // Additional functions for contract management

    function updateTokenContract(address _tokenContractAddress) external onlyOwner {
        require(_tokenContractAddress != address(0), "Invalid token contract address");

        tokenContract = TokenContract(_tokenContractAddress);
    }

    function updateXTokContract(address _xTokContractAddress) external onlyOwner {
        require(_xTokContractAddress != address(0), "Invalid xTOK contract address");

        xTokContract = XTokContract(_xTokContractAddress);
    }

    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= tokenContract.balanceOf(address(this)), "Insufficient contract balance");

        tokenContract.transfer(to, amount);
    }
}
