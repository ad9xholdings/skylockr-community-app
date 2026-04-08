# DAO Proposal #001
## Protocol-Layer Enforcement of DAO Token Sale Limits

**Submitted:** April 8, 2026  
**Proposer:** [DAO Token Holder Address]  
**Voting Period:** 7 days (midnight cutoff)  
**Quorum Required:** [To be set by DAO parameters]

---

## Executive Summary

This proposal establishes the technical and legal framework to enforce the **1% DAO token sale limit per 30-day period** at the protocol layer, given that XRPL does not natively support time-based transfer restrictions.

---

## Problem Statement

The DAO governance specification (v1.0) establishes:
- **1% maximum sale** of held DAO tokens per 30-day rolling period
- **99% lock** for 100 months
- **One-way conversion** DAO → SkyIvy for liquidity

However, XRPL (XRP Ledger) does not natively enforce time-based sale limits or transfer restrictions on tokens. Without protocol-layer enforcement, these constraints rely entirely on voluntary compliance.

---

## Proposed Solution

Implement a **three-layer enforcement model** combining smart contract logic, controlled venues, and legal backstops.

### Layer 1: DAO Token as Gated Asset

**Status:** Non-freely transferable token

| Restriction | Implementation |
|-------------|----------------|
| **No Public DEX Listings** | DAO tokens will not be listed on XRPL DEX or external exchanges |
| **No Wallet-to-Wallet Transfers** | Generic transfers disabled or non-recognized |
| **Authorized Paths Only** | All valid transfers must pass through: (a) Governance/Treasury Contract, or (b) Whitelisted "DAO Exit Gateway" |

### Layer 2: Exit Gateway Smart Contract

**Function:** Controlled exit mechanism enforcing sale limits

```
Exit Request Flow:
├── Read holder's current DAO balance
├── Calculate max allowed: 0.01 × current balance (1%)
├── Check last 30 days exit history
├── Compare requested amount vs. remaining limit
├── IF within limit: Approve → Burn DAO → Release SkyIvy
└── IF exceeds limit: Reject transaction
```

**Gateway Capabilities:**
- Maintains per-address exit ledger (timestamp + amount)
- Permits transfers only to SkyIvy conversion contract
- DAO-approved multi-sig override for strategic transfers
- 30-day rolling window calculation

### Layer 3: One-Way Conversion Contract

**Function:** Irreversible DAO → SkyIvy conversion

| Step | Action |
|------|--------|
| 1 | Validate exit request through Exit Gateway |
| 2 | Verify 1%/30d limit not exceeded |
| 3 | Burn DAO tokens (permanent removal from supply) |
| 4 | Mint/Release equivalent SkyIvy to holder |
| 5 | Record voting power forfeiture |

### Layer 4: Legal & Governance Enforcement

**Marshall Islands DAO LLC Charter Amendment:**

> "Any DAO token transfer occurring outside the authorized Exit Gateway shall be deemed non-compliant. Such tokens shall:
> - Lose all governance recognition and voting rights
> - Be excluded from revenue distributions
> - Not be recognized for conversion to SkyIvy
> - Subject the holder to potential exclusion from ecosystem benefits"

**Exchange/Partner Agreements:**
- No listing or support for non-compliant DAO token transfers
- Cooperation with treasury on compliance monitoring

---

## Technical Implementation

### Smart Contract Architecture

| Contract | Purpose | Status |
|----------|---------|--------|
| `DAOToken.sol` | Gated token with restricted transfers | To be deployed |
| `ExitGateway.sol` | Sale limit enforcement logic | To be deployed |
| `ConversionBridge.sol` | DAO → SkyIvy one-way conversion | To be deployed |
| `TreasuryController.sol` | Governance state execution | To be deployed |

### XRPL Integration

Given XRPL's limited smart contract capabilities, implementation options:

| Option | Approach | Complexity |
|--------|----------|------------|
| **A** | Hooks (XRPL native smart contracts) | Medium |
| **B** | Sidechain with EVM compatibility | High |
| **C** | Federated consensus + off-chain validation | Medium |
| **D** | Legal-first with on-chain recognition | Lower |

**Recommended:** Option D (Legal-first) with Option A (Hooks) as future upgrade path.

### Off-Chain Components

| Component | Function |
|-----------|----------|
| Exit Gateway API | Web interface for conversion requests |
| Compliance Monitor | Tracks and audits exit patterns |
| Treasury Dashboard | Real-time governance state management |

---

## Voting Parameters

| Parameter | Value |
|-----------|-------|
| **Proposal Threshold** | 13% of circulating DAO supply (per governance spec) |
| **Voting Period** | 7 full days |
| **Cutoff** | Midnight end of day 7 |
| **Approval Threshold** | >50% Yes votes |
| **Quorum** | [DAO to set: recommend 20% minimum] |

---

## Expected Outcomes

### If Passed

1. **Technical Development Begins**
   - Smart contract development and audit
   - Exit Gateway API development
   - Legal documentation updates

2. **Timeline**
   - Development: 60-90 days
   - Audit: 30 days
   - Deployment: Q3 2026

3. **Post-Deployment**
   - All DAO token sales flow through Exit Gateway
   - 1%/30d limit automatically enforced
   - SkyIvy liquidity remains unrestricted (25%/6mo)

### If Rejected

- Governance constraints remain theoretical
- Reliance on social contract and voluntary compliance
- Increased risk of governance attacks via rapid accumulation/dumping

---

## Risk Analysis

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Smart contract bugs | Medium | High | Professional audit, bug bounty |
| XRPL limitations | High | Medium | Hybrid on-chain/off-chain approach |
| User confusion | Medium | Medium | Clear UI/UX, documentation |
| Centralization concerns | Low | Medium | Multi-sig treasury, DAO overrides |

---

## Resources Required

| Resource | Estimate |
|----------|----------|
| Smart Contract Development | $50,000 - $75,000 |
| Security Audit | $25,000 - $40,000 |
| Legal Documentation | $15,000 - $25,000 |
| Exit Gateway Infrastructure | $10,000/year hosting |
| **Total** | **~$100,000 - $150,000** |

---

## Call to Action

DAO token holders are asked to vote:

**YES** — Approve protocol-layer enforcement of 1% sale limits via Exit Gateway and Conversion Contract architecture.

**NO** — Reject this proposal and maintain status quo (social contract only).

---

## Appendix

### A. Governance Spec Reference
- Document: `SKYLOCKR_GOVERNANCE_SPEC.md`
- Section: Token Architecture / DAO Token Lock Structure

### B. Technical References
- XRPL Hooks Documentation: https://xrpl.org/hooks.html
- Marshall Islands DAO LLC Legal Framework

### C. Related Proposals
- None (this is the inaugural technical implementation proposal)

---

**Document Version:** 1.0  
**Last Updated:** April 8, 2026  
**Proposed Effective Date:** Upon passage + 90 days implementation
