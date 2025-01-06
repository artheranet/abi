pragma solidity ^0.8.0;

interface IStaking {
    // create a new validator with the given public key
    function createValidator(bytes calldata pubkey) external payable;
    // delegates the recevied AA to the specified validator id    
    function delegate(uint256 toValidatorID) external payable;
    // undelegates the mentioned amount from the specified validator id. 
    // withdrawalRequestID is a tracking code generated by the caller. 
    // This is needed by the withdraw function to perform the actual withdrawal.
    function undelegate(uint256 fromValidatorID, uint256 withdrawalRequestID, uint256 amount) external;
    // withdraws previously undelegated coins from the specified validator using the withdrawalRequestID from the previous undelegate call
    function withdraw(uint256 toValidatorID, uint256 wrID) external;
    // withdraws previously undelegated coins from the specified validator, sending the coins to the receiver
    function withdrawTo(uint256 toValidatorID, uint256 wrID, address payable receiver) external;
    // get the pending rewards for a delegator
    function pendingRewards(address delegator, uint256 toValidatorID) external view returns (uint256);
    // Used by a delegator to claim their rewards for a specific validator
    function claimRewards(uint256 toValidatorID) external;
    // Used by a delegator to re-stake their rewards with the provided validator
    function restakeRewards(uint256 toValidatorID) external;
    // locks the provided staked amount for a specific lockupDuration (in seconds)
    function lockStake(uint256 toValidatorID, uint256 lockupDuration, uint256 amount) external;
    // unlocks the provided staked amount
    function unlockStake(uint256 toValidatorID, uint256 amount) external returns (uint256);

    // current epoch
    function currentEpoch() external view returns (uint256);
    // validator ids in the specified epoch
    function getEpochValidatorIDs(uint256 epoch) external view returns (uint256[] memory);
    // accumulated transaction fees for the specified validator and epoch
    function getEpochAccumulatedOriginatedTxsFee(uint256 epoch, uint256 validatorID) external view returns (uint256);
    // number of seconds the specified validator was offline in the given epoch
    function getEpochOfflineTime(uint256 epoch, uint256 validatorID) external view returns (uint256);
    // number of blocks the specified validator missed in the given epoch
    function getEpochOfflineBlocks(uint256 epoch, uint256 validatorID) external view returns (uint256);

    // get the rewards for a delegator
    function rewardsStash(address delegator, uint256 validatorID) external view returns (uint256);
    // get the amounf of stake deposited by the validator itself
    function getSelfStake(uint256 validatorID) external view returns (uint256);
    // gets the amount of locked stake for a delegator
    function getLockedStake(address delegator, uint256 toValidatorID) external view returns (uint256);
    // check whether a specific user's stake delegation to a validator is locked
    function isLockedUp(address delegator, uint256 toValidatorID) view external returns (bool);
    // returns the unlocked amount of tokens in a delegator's stake for a specific validator
    function getUnlockedStake(address delegator, uint256 toValidatorID) external view returns (uint256);
    // check if the validator was slashed
    function isSlashed(uint256 validatorID) view external returns (bool);

    event CreatedValidator(uint256 indexed validatorID, address indexed auth, uint256 createdEpoch, uint256 createdTime);
    event DeactivatedValidator(uint256 indexed validatorID, uint256 deactivatedEpoch, uint256 deactivatedTime);
    event ChangedValidatorStatus(uint256 indexed validatorID, uint256 status);
    event Delegated(address indexed delegator, uint256 indexed toValidatorID, uint256 amount, bool artheraStake);
    event Undelegated(address indexed delegator, uint256 indexed fromValidatorID, uint256 indexed withdrawalRequestID, uint256 amount, bool artheraStake);
    event Withdrawn(address indexed delegator, uint256 indexed fromValidatorID, uint256 indexed withdrawalRequestID, uint256 amount);
    event ClaimedRewards(address indexed delegator, uint256 indexed toValidatorID, uint256 lockupExtraReward, uint256 lockupBaseReward, uint256 unlockedReward);
    event RestakedRewards(address indexed delegator, uint256 indexed toValidatorID, uint256 lockupExtraReward, uint256 lockupBaseReward, uint256 unlockedReward);
    event LockedUpStake(address indexed delegator, uint256 indexed validatorID, uint256 duration, uint256 amount);
    event UnlockedStake(address indexed delegator, uint256 indexed validatorID, uint256 amount, uint256 penalty);
}