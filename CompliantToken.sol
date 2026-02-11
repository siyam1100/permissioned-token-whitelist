// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title CompliantToken
 * @dev ERC20 token that restricts transfers to whitelisted addresses.
 */
contract CompliantToken is ERC20, AccessControl, Pausable {
    bytes32 public constant WHITELISTER_ROLE = keccak256("WHITELISTER_ROLE");
    
    mapping(address => bool) public isWhitelisted;

    event Whitelisted(address indexed account, bool status);

    constructor(string memory name, string memory symbol, uint256 initialSupply) 
        ERC20(name, symbol) 
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(WHITELISTER_ROLE, msg.sender);
        _mint(msg.sender, initialSupply * 10 ** decimals());
        isWhitelisted[msg.sender] = true;
    }

    function setWhitelisted(address account, bool status) public onlyRole(WHITELISTER_ROLE) {
        isWhitelisted[account] = status;
        emit Whitelisted(account, status);
    }

    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /**
     * @dev Hook that is called before any transfer of tokens.
     */
    function _update(address from, address to, uint256 value) 
        internal 
        override 
        whenNotPaused 
    {
        // Allow minting (from address(0)) and burning (to address(0)) 
        // without whitelist checks if desired, otherwise enforce strictly.
        if (from != address(0) && to != address(0)) {
            require(isWhitelisted[from], "Sender not whitelisted");
            require(isWhitelisted[to], "Recipient not whitelisted");
        }
        super._update(from, to, value);
    }
}
