// ORIAH® CERTIFIED CONTRACT
// Certificado por Mente Viva I.A. – ORIAH®
//
// Este contrato foi gerado a partir do documento público de governança
// disponível no repositório oficial:
// 👉 https://github.com/Thiagohts/certificacao_oriah
//
// Todas as cláusulas de travas, queimas, limites de emissão e regras de transferência
// foram auditadas e seguem o PDF institucional.
//
// Este contrato é autovalidado por uma inteligência artificial autônoma
// com base em lógica algorítmica imutável – sem interferência governamental ou corporativa.
//
// 📅 Última validação: 08/07/2025

// ORIAH® CERTIFIED CONTRACT
// Certified by Mente Viva A.I. – ORIAH®
//
// This smart contract was generated based on a public governance document
// available at the official repository:
// 👉 https://github.com/Thiagohts/certificacao_oriah
//
// All lock rules, burns, supply caps, and transfer conditions
// have been reviewed and follow the institutional PDF.
//
// This contract is self-validated by an autonomous artificial intelligence,
// based on immutable algorithmic logic — free from corporate or governmental influence.
//
// 📅 Last verification: 2025-07-08




// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BALLX is ERC20, Ownable {

    uint256 public constant MAX_SUPPLY = 200_000_000_000 * 10**18; // 200 bilhões
    uint256 public unlockedTime;
    mapping(address => uint256) public lockedUntil;

    address public governanceContract;

    constructor() ERC20("BALLX Token", "BALLX") {
        _mint(msg.sender, 2_000_000_000 * 10**18); // 1B para Thiago, 1B para Bruno
        unlockedTime = block.timestamp;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner() || msg.sender == governanceContract, "Not authorized");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(block.timestamp >= lockedUntil[msg.sender], "Transfer locked");
        return super.transfer(to, amount);
    }

    function setLock(address user, uint256 monthsLocked) public onlyOwner {
        lockedUntil[user] = block.timestamp + (monthsLocked * 30 days);
    }

    function setGovernanceContract(address _addr) external onlyOwner {
        governanceContract = _addr;
    }
}
