// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;
    address public owner;

    //Duration of rewards to be paid out (in seconds)
    uint256 public duration;

    //Timestamp of when the rewards finish
    uint256 public finishAt;

    //Minimum of last updated time and reward finish time
    uint256 public updatedAt;

    //reward to be paid out be second
    uint256 public rewardRate;

    //the sum of (reward rate * duration * e18/total Supply
    uint256 public rewardPerTokenStored;

    //mappings

    //user address => rewardPerTokenStored
    mapping(address => uint256) public userRewardPerTokenPaid;

    //user address => rewards to be claimed
    mapping(address => uint256) public rewards;

    uint256 public totalSupply;

    //user address => stake amount
    mapping(address => uint256) public balanceOf;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return _min(finishAt, block.timestamp);
    }
}
