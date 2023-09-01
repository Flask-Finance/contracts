// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary interfaces and libraries.
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Uniswap interface (simplified for demonstration).
interface IUniswapRouter {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

// Wormhole bridge interface (simplified for demonstration).
interface IWormholeBridge {
    function transferToEth(address receiver, uint256 amount) external;
}

contract CrossChainSwapContract is Ownable {
    address public uniswapRouter; // Address of the Uniswap router.
    address public wormholeBridge; // Address of the Wormhole bridge.

    constructor(address _uniswapRouter, address _wormholeBridge) {
        uniswapRouter = _uniswapRouter;
        wormholeBridge = _wormholeBridge;
    }

    // Swap USDT for wUSDT on Uniswap and send wUSDT to Wormhole bridge.
    function swapAndSendToWormhole(uint256 amountIn, uint256 amountOutMin, uint256 deadline) external onlyOwner {
        // Define the token addresses.
        address usdtAddress = 0xYourUSDTAddress; // Replace with the actual USDT token address.
        address wusdtAddress = 0xYourWUSDTAddress; // Replace with the actual wUSDT token address.

        // Approve Uniswap to spend USDT on your behalf.
        IERC20(usdtAddress).approve(uniswapRouter, amountIn);

        // Define the swap path.
        address[] memory path = new address[](2);
        path[0] = usdtAddress;
        path[1] = wusdtAddress;

        // Perform the swap on Uniswap.
        IUniswapRouter(uniswapRouter).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            deadline
        );

        // Send wUSDT to Wormhole bridge.
        uint256 wusdtBalance = IERC20(wusdtAddress).balanceOf(address(this));
        IWormholeBridge(wormholeBridge).transferToEth(msg.sender, wusdtBalance);
    }

    // Withdraw any ERC20 tokens sent to this contract (onlyOwner).
    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }
}
