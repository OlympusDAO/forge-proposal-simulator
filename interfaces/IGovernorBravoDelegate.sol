// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.4;

/// @title  IGovernorBravoDelegate
/// @notice The external interface of the Olympus Governor Bravo delegate, as reached through the
///         GovernorBravoDelegator proxy.
/// @dev    This replaces the copy of the delegate implementation. A proposal talks to an already
///         deployed governor, so the implementation source was never needed here, and carrying it
///         made every consumer compile the contract whose ABI coder exhausts the EVM stack under
///         code generation without the optimizer.
///
///         The signatures mirror the implementation ABI exactly. Two spellings differ from the
///         implementation source and are ABI identical to it: a Keycode argument appears as its
///         underlying bytes5, and a getter returning a contract type appears as address.
///
///         This file documents the surface, not the semantics. For behaviour, revert conditions and
///         invariants, read the implementation it was generated from:
///         https://github.com/OlympusDAO/olympus-v3/blob/92bd5a9a055f0e36dacf7732e929e51185b8e684/src/external/governance/GovernorBravoDelegate.sol
interface IGovernorBravoDelegate {
    // --- DATA STRUCTURES ---------------------------------------------------------

    /// @notice Ballot receipt record for a voter
    struct Receipt {
        /// @notice Whether or not a vote has been cast
        bool hasVoted;
        /// @notice Whether or not the voter supports the proposal or abstains
        uint8 support;
        /// @notice The number of votes the voter had, which were cast
        uint256 votes;
    }

    /// @notice Possible states that a proposal may be in
    /// @dev    The order is part of the ABI. `state()` returns this as a uint8, so a value may only
    ///         ever be appended: reordering or inserting one silently changes the meaning of every
    ///         value returned to an existing consumer.
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed,
        Vetoed,
        Emergency
    }

    // --- ERRORS ------------------------------------------------------------------

    error GovernorBravo_AddressZero();
    error GovernorBravo_AlreadyInitialized();
    error GovernorBravo_Cancel_AboveThreshold();
    error GovernorBravo_Cancel_AlreadyExecuted();
    error GovernorBravo_Cancel_WhitelistedProposer();
    error GovernorBravo_Emergency_SupplyTooLow();
    error GovernorBravo_Execute_BelowThreshold();
    error GovernorBravo_Execute_NotQueued();
    error GovernorBravo_Execute_VetoedProposal();
    error GovernorBravo_InvalidCalldata();
    error GovernorBravo_InvalidDelay();
    error GovernorBravo_InvalidGracePeriod();
    error GovernorBravo_InvalidPeriod();
    error GovernorBravo_InvalidSignature();
    error GovernorBravo_InvalidThreshold();
    error GovernorBravo_NotActive();
    error GovernorBravo_NotEmergency();
    error GovernorBravo_OnlyAdmin();
    error GovernorBravo_OnlyPendingAdmin();
    error GovernorBravo_OnlyVetoGuardian();
    error GovernorBravo_Proposal_AlreadyActivated();
    error GovernorBravo_Proposal_AlreadyActive();
    error GovernorBravo_Proposal_AlreadyPending();
    error GovernorBravo_Proposal_IdCollision();
    error GovernorBravo_Proposal_IdInvalid();
    error GovernorBravo_Proposal_LengthMismatch();
    error GovernorBravo_Proposal_NoActions();
    error GovernorBravo_Proposal_ThresholdNotMet();
    error GovernorBravo_Proposal_TooEarly();
    error GovernorBravo_Proposal_TooManyActions();
    error GovernorBravo_Queue_AlreadyQueued();
    error GovernorBravo_Queue_BelowThreshold();
    error GovernorBravo_Queue_FailedProposal();
    error GovernorBravo_Queue_VetoedProposal();
    error GovernorBravo_Veto_AlreadyExecuted();
    error GovernorBravo_Vote_AlreadyCast();
    error GovernorBravo_Vote_Closed();
    error GovernorBravo_Vote_InvalidType();

    // --- EVENTS ------------------------------------------------------------------

    event NewAdmin(address oldAdmin, address newAdmin);
    event NewImplementation(address oldImplementation, address newImplementation);
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
    event ProposalCanceled(uint256 id);
    event ProposalCreated(
        uint256 id,
        address proposer,
        address[] targets,
        uint256[] values,
        string[] signatures,
        bytes[] calldatas,
        uint256 startBlock,
        string description
    );
    event ProposalExecuted(uint256 id);
    event ProposalQueued(uint256 id, uint256 eta);
    event ProposalThresholdSet(uint256 oldProposalThreshold, uint256 newProposalThreshold);
    event ProposalVetoed(uint256 id);
    event ProposalVotingStarted(uint256 id);
    event VetoGuardianSet(address oldGuardian, address newGuardian);
    event VoteCast(address indexed voter, uint256 proposalId, uint8 support, uint256 votes, string reason);
    event VotingDelaySet(uint256 oldVotingDelay, uint256 newVotingDelay);
    event VotingPeriodSet(uint256 oldVotingPeriod, uint256 newVotingPeriod);
    event WhitelistAccountExpirationSet(address account, uint256 expiration);
    event WhitelistGuardianSet(address oldGuardian, address newGuardian);

    // --- FUNCTIONS ---------------------------------------------------------------

    function BALLOT_TYPEHASH() external view returns (bytes32);
    function DOMAIN_TYPEHASH() external view returns (bytes32);
    function MAX_PROPOSAL_THRESHOLD_PCT() external view returns (uint256);
    function MAX_VOTING_DELAY() external view returns (uint256);
    function MAX_VOTING_PERIOD() external view returns (uint256);
    function MIN_GOHM_SUPPLY() external view returns (uint256);
    function MIN_PROPOSAL_THRESHOLD_PCT() external view returns (uint256);
    function MIN_VOTING_DELAY() external view returns (uint256);
    function MIN_VOTING_PERIOD() external view returns (uint256);
    function _acceptAdmin() external;
    function _setModuleRiskLevel(bytes5 module_, bool isHighRisk_) external;
    function _setPendingAdmin(address newPendingAdmin) external;
    function _setProposalThreshold(uint256 newProposalThreshold) external;
    function _setVetoGuardian(address account) external;
    function _setVotingDelay(uint256 newVotingDelay) external;
    function _setVotingPeriod(uint256 newVotingPeriod) external;
    function activate(uint256 proposalId) external;
    function activationGracePeriod() external view returns (uint256);
    function admin() external view returns (address);
    function approvalThresholdPct() external view returns (uint256);
    function cancel(uint256 proposalId) external;
    function castVote(uint256 proposalId, uint8 support) external;
    function castVoteBySig(uint256 proposalId, uint8 support, uint8 v, bytes32 r, bytes32 s) external;
    function castVoteWithReason(uint256 proposalId, uint8 support, string memory reason) external;
    function emergencyPropose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas
    ) external returns (uint256);
    function execute(uint256 proposalId) external payable;
    function getActions(uint256 proposalId)
        external
        view
        returns (
            address[] memory targets,
            uint256[] memory values,
            string[] memory signatures,
            bytes[] memory calldatas
        );
    function getHighRiskQuorumVotes() external view returns (uint256);
    function getProposalEta(uint256 proposalId) external view returns (uint256);
    function getProposalQuorum(uint256 proposalId) external view returns (uint256);
    function getProposalThreshold(uint256 proposalId) external view returns (uint256);
    function getProposalThresholdVotes() external view returns (uint256);
    function getProposalVotes(uint256 proposalId) external view returns (uint256, uint256, uint256);
    function getQuorumVotes() external view returns (uint256);
    function getReceipt(uint256 proposalId, address voter)
        external
        view
        returns (Receipt memory);
    function getVoteOutcome(uint256 proposalId) external view returns (bool);
    function gohm() external view returns (address);
    function highRiskQuorum() external view returns (uint256);
    function implementation() external view returns (address);
    function initialize(
        address timelock_,
        address gohm_,
        address kernel_,
        address vetoGuardian_,
        uint256 votingPeriod_,
        uint256 votingDelay_,
        uint256 activationGracePeriod_,
        uint256 proposalThreshold_
    ) external;
    function isKeycodeHighRisk(bytes5) external view returns (bool);
    function kernel() external view returns (address);
    function latestProposalIds(address) external view returns (uint256);
    function name() external view returns (string memory);
    function pendingAdmin() external view returns (address);
    function proposalCount() external view returns (uint256);
    function proposalMaxOperations() external view returns (uint256);
    function proposalThreshold() external view returns (uint256);
    /// @notice The automatic getter of the public `proposals` mapping of the implementation.
    /// @dev    A Solidity struct getter omits the array and mapping members, so the four action
    ///         arrays and the per voter receipts are absent from the tuple below. Read the actions
    ///         with `getActions()` and a voter receipt with `getReceipt()`.
    function proposals(uint256)
        external
        view
        returns (
            uint256 id,
            address proposer,
            uint256 proposalThreshold,
            uint256 quorumVotes,
            uint256 eta,
            uint256 startBlock,
            uint256 endBlock,
            uint256 forVotes,
            uint256 againstVotes,
            uint256 abstainVotes,
            bool votingStarted,
            bool vetoed,
            bool canceled,
            bool executed
        );
    function propose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) external returns (uint256);
    function queue(uint256 proposalId) external;
    function quorumPct() external view returns (uint256);
    /// @dev See the note on `ProposalState` before treating the returned uint8 as stable.
    function state(uint256 proposalId) external view returns (ProposalState);
    function timelock() external view returns (address);
    function veto(uint256 proposalId) external;
    function vetoGuardian() external view returns (address);
    function votingDelay() external view returns (uint256);
    function votingPeriod() external view returns (uint256);
}
