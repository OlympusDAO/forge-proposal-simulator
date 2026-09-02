// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

/// @notice Actions to trigger state changes in the kernel.
/// @dev    The order is part of the ABI. `executeAction` takes this as a uint8, so a value may
///         only ever be appended: reordering or inserting one silently changes which action
///         a caller triggers.
enum Actions {
    InstallModule,
    UpgradeModule,
    ActivatePolicy,
    DeactivatePolicy,
    ChangeExecutor,
    MigrateKernel
}

/// @title  IKernel
/// @notice The external interface of the Olympus kernel.
/// @dev    This replaces the copy of the kernel implementation. A proposal talks to an already
///         deployed kernel.
///
///         The signatures mirror the implementation ABI exactly. One spelling differs from the
///         implementation source and is ABI identical to it: a Keycode appears as its underlying
///         bytes5.
///
///         This file documents the surface, not the semantics. For behaviour, revert conditions
///         and invariants, read the implementation it was generated from:
///         https://github.com/OlympusDAO/olympus-v3/blob/464abc3fcc58d1fa3eb0326c423e177afb3989bb/src/Kernel.sol
interface IKernel {
    // --- ERRORS ------------------------------------------------------------------

    error InvalidKeycode(bytes5 keycode_);
    error Kernel_InvalidModuleUpgrade(bytes5 module_);
    error Kernel_ModuleAlreadyInstalled(bytes5 module_);
    error Kernel_OnlyExecutor(address caller_);
    error Kernel_PolicyAlreadyActivated(address policy_);
    error Kernel_PolicyNotActivated(address policy_);
    error TargetNotAContract(address target_);

    // --- EVENTS ------------------------------------------------------------------

    event ActionExecuted(Actions indexed action_, address indexed target_);
    event PermissionsUpdated(bytes5 indexed keycode_, address indexed policy_, bytes4 funcSelector_, bool granted_);

    // --- FUNCTIONS ---------------------------------------------------------------

    function activePolicies(uint256) external view returns (address);
    function allKeycodes(uint256) external view returns (bytes5);
    function executeAction(Actions action_, address target_) external;
    function executor() external view returns (address);
    function getDependentIndex(bytes5, address) external view returns (uint256);
    function getKeycodeForModule(address) external view returns (bytes5);
    function getModuleForKeycode(bytes5) external view returns (address);
    function getPolicyIndex(address) external view returns (uint256);
    function isPolicyActive(address policy_) external view returns (bool);
    function moduleDependents(bytes5, uint256) external view returns (address);
    function modulePermissions(bytes5, address, bytes4) external view returns (bool);
}
