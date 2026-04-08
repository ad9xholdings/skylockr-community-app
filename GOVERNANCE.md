# SkyLockr / SkyIvy Governance Specification

## Version 1.0 | April 8, 2026

---

## Executive Summary

This document formalizes the governance architecture for the SkyLockr ecosystem, establishing clear separation between **governance** (DAO tokens) and **economics** (SkyIvy Coin), with the SkyLockr Treasury serving as the on-chain execution engine.

---

## 1. Token Architecture

### 1.1 DAO Token — Pure Governance

| Attribute | Specification |
|-----------|---------------|
| **Purpose** | Protocol governance and decision-making |
| **Voting Rights** | 1 DAO Token = 1 Vote |
| **Economic Rights** | None (no revenue share, no yield) |
| **Conversion** | One-way: DAO → SkyIvy only (irreversible) |

#### Lock Structure

| Parameter | Value |
|-----------|-------|
| **Sale Limit** | 1% of held DAO tokens per 30-day rolling period |
| **Lock Status** | All DAO tokens beyond the 1% liquid portion are **locked** |
| **Lock Duration** | 100 months (~8.3 years) |
| **Post-Lock** | Constraint lifts or renews per DAO proposal |

#### Conversion Mechanics

- DAO tokens may be converted to SkyIvy when holders seek liquidity
- Conversion is **one-way and irreversible**
- Upon conversion, DAO tokens are burned and voting power is permanently lost
- Conversion rate determined by DAO proposal (fixed, market, or treasury NAV)

### 1.2 SkyIvy Coin — Pure Economics

| Attribute | Specification |
|-----------|---------------|
| **Purpose** | Economic value accrual and liquidity |
| **Voting Rights** | None |
| **Economic Rights** | Receives 2% of creator gross revenue from Ad9x; additional buybacks/rewards per DAO decision |
| **Lock Status** | **Never locked** |

#### Liquidation Structure

| Parameter | Value |
|-----------|-------|
| **Liquidation Limit** | Max 25% of held SkyIvy per 6-month rolling period |
| **Lock Status** | None — SkyIvy is always liquid |
| **Conversion Path** | SkyIvy → XRP → Fiat |
| **Duration** | Permanent unless DAO modifies |

### 1.3 Token Relationship

```
┌─────────────────────────────────────────────────────────────────┐
│                      DAO TOKEN                                  │
│  • Pure governance (1 token = 1 vote)                          │
│  • 99% locked, 1% liquid per 30 days                           │
│  • One-way conversion to SkyIvy (irreversible)                 │
│  • 100-month lock period                                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓ (one-way conversion)
┌─────────────────────────────────────────────────────────────────┐
│                     SKYIVY COIN                                 │
│  • Pure economics (no voting rights)                           │
│  • Receives 2% of Ad9x gross revenue                           │
│  • Never locked                                                │
│  • 25% liquidation limit per 6 months                          │
│  • Fully convertible: SkyIvy → XRP → Fiat                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Governance Mechanics

### 2.1 Proposal Creation

| Requirement | Specification |
|-------------|---------------|
| **Threshold** | 13% of circulating DAO token supply |
| **Eligibility** | Addresses holding minimum DAO token stake |
| **Proposal Content** | Target (SkyIvy, SkyLockr, Ad9x, or Master DAO), action, effective scope, start date |

### 2.2 Voting Process

| Parameter | Specification |
|-----------|---------------|
| **Voting Period** | 7 full days |
| **Cutoff** | Midnight (end of day 7) |
| **Quorum** | Minimum % of total voting power must participate (set by DAO) |
| **Approval** | >50% "Yes" votes among participating votes |

### 2.3 Execution

Upon passage:
- Smart contract / XRPL-controlled logic automatically updates parameters
- SkyLockr Treasury applies approved changes
- No centralized intervention required

---

## 3. SkyLockr Treasury — Execution Engine

### 3.1 Role

The SkyLockr Treasury acts as the **on-chain/off-chain controller** that:
- Receives "decision messages" from DAO voting system
- Applies approved changes to protocol parameters
- Maintains governance state (fee parameters, revenue splits, token-gating thresholds, reward schedules)

### 3.2 Execution Scope

| Category | Actions |
|----------|---------|
| **SkyIvy Treasury** | Revenue routing, distribution cadence, reward parameters |
| **SkyLockr Platform** | Access rules, fee schedules, token-gating thresholds |
| **White-Label Forks** | Default parameters for downstream deployments |

---

## 4. Governance Scope

### 4.1 DAO Control Over SkyIvy Coin

- Treasury allocations (rewards, liquidity, grants, buybacks)
- Reward distribution parameters (2% of gross to holders, cadence, eligibility)
- Token policy (emission schedules, burns, use cases)
- Ad9x → SkyIvy revenue routing percentages

### 4.2 DAO Control Over SkyLockr Token

- Access rules and token-gating thresholds
- Governance process details (proposal thresholds, quorum %, voting windows)
- Platform fee schedules in non-ad categories
- Reserve allocations for ecosystem grants, dev funding, community programs

---

## 5. Practical Examples

### Example A: DAO Holder Seeking Liquidity

| Step | Action | Result |
|------|--------|--------|
| 1 | Holder has 10,000,000 DAO tokens | 100% locked except 1% monthly liquid |
| 2 | Sells 100,000 DAO (1% liquid portion) | 9,900,000 DAO remain locked |
| 3 | Converts 5,000,000 DAO → SkyIvy | 4,900,000 DAO left, 5M SkyIvy acquired, voting power reduced |
| 4 | 6 months later | Can liquidate 1,250,000 SkyIvy (25% of 5M) |
| 5 | Converts to XRP → Fiat | Exit complete |

### Example B: Governance Attack Prevention

| Scenario | Protection |
|----------|------------|
| Rapid accumulation attempt | 100-month lock prevents immediate voting power acquisition |
| Dump attack | 1% monthly sale limit prevents sudden supply flooding |
| Buyout via SkyIvy | SkyIvy has no voting rights — must acquire DAO tokens |

---

## 6. Legal Structure

### "The People of the JamZia Network (tm)"

Defined as:
- **Set of DAO token holders** acting through on-chain governance
- **Legal wrapper**: United Series of America Master DAO, LLC (Marshall Islands)
- **Binding mechanism**: Smart contract / XRPL logic enforces DAO decisions

---

## 7. Parameter Summary

| Parameter | Value |
|-----------|-------|
| **Proposal Threshold** | 13% of circulating DAO supply |
| **Voting Period** | 7 full days (midnight cutoff) |
| **DAO Token Lock** | 99% locked, 1% liquid per 30 days |
| **DAO Lock Duration** | 100 months |
| **DAO Conversion** | One-way only (DAO → SkyIvy) |
| **SkyIvy Lock** | Never locked |
| **SkyIvy Liquidation** | 25% max per 6-month rolling period |

---

## 8. Amendment Process

This specification may be amended through the governance process defined herein:
1. Proposal created (13% threshold)
2. 7-day voting period
3. Quorum reached and majority approval
4. Automatic implementation via SkyLockr Treasury

---

## 9. GOVERNANCE SAFEGUARDS

### 9.1 Voting Lockups

To prevent flash-loan governance attacks and ensure voter commitment:

| Parameter | Requirement |
|-----------|-------------|
| **Minimum Stake Duration** | 7 days before voting |
| **Recommended Stake Duration** | 30 days for full voting power |
| **Flash Loan Protection** | Votes invalid if tokens acquired within 7 days of proposal |
| **Delegation Lock** | Delegated tokens locked for duration of vote |

### 9.2 Proposal Thresholds

To prevent spam and ensure serious proposals:

| Proposal Type | Token Threshold | Holding Duration |
|---------------|-----------------|------------------|
| **Standard Proposal** | 13% of circulating supply | 30 days minimum |
| **Reserved Matter** | 13% of circulating supply | 60 days minimum |
| **Emergency Proposal** | 5% of circulating supply | 7 days minimum |

### 9.3 Supermajority Requirements

Certain critical changes require enhanced approval:

| Change Type | Approval Required | Quorum Required | Voting Period |
|-------------|-------------------|-----------------|---------------|
| **Standard Changes** | >50% Yes | 20% participation | 7 days |
| **Charter Amendments** | >67% Yes | 33% participation | 14 days |
| **Tokenomics Changes** | >67% Yes | 33% participation | 14 days |
| **Emergency Actions** | >90% Yes | 20% participation | 24 hours |

**Reserved Matters (Supermajority Required):**
- Charter amendments
- Token supply or emission changes
- Conversion rate modifications
- Treasury distribution beyond 24-month runway
- Protocol architectural changes
- Lockout period modifications

### 9.4 Treasury Sustainability Guardrails

Automatic protections to prevent treasury depletion:

| Safeguard | Rule | Enforcement |
|-----------|------|-------------|
| **Minimum Reserve** | 24 months of distribution runway | Treasury blocks distributions below threshold |
| **Maximum Distribution** | Cannot exceed 12 months of runway in single proposal | Proposal auto-fails if violation detected |
| **Monthly Recalculation** | Reserve requirement updated based on trailing 3-month average | Automatic on-chain calculation |
| **Emergency Freeze** | Treasury auto-pauses if reserve drops below 12 months | Multi-sig can override with 4-of-5 consensus |

### 9.5 Emergency Protocol Safeguards

**Emergency Pause Authority:**
- **Trigger:** Critical security vulnerability, economic attack, system failure
- **Authority:** 3-of-5 multi-sig can pause protocol
- **Duration:** Maximum 14 days without DAO approval
- **Restoration:** Requires DAO vote to resume normal operations

**Emergency Proposal Fast-Track:**
- 24-hour voting period
- 90% approval threshold
- Immediate execution upon passage
- Post-emergency review within 30 days

### 9.6 Delegation Safeguards

| Parameter | Rule |
|-----------|------|
| **Delegation Enabled** | Yes |
| **Transferable Delegation** | No (delegation is per-proposal) |
| **Self-Delegation Default** | Tokens self-delegated unless specified otherwise |
| **Delegation Lock** | Delegated tokens cannot be transferred during active vote |
| **Delegation Cap** | Single address cannot receive >10% of voting power via delegation |

---

## 10. TOKEN ALLOCATION MODEL

### 10.1 DAO Token Distribution

**Total Supply:** 10,000,000 DAO Tokens

| Allocation | Percentage | Amount | Purpose | Vesting |
|------------|------------|--------|---------|---------|
| **Founders/Team** | 20% | 2,000,000 | Long-term alignment | 48-month vesting, 12-month cliff |
| **Treasury Reserve** | 30% | 3,000,000 | Future grants, ecosystem | DAO-governed unlock |
| **Community Airdrop** | 25% | 2,500,000 | Decentralization | 25% at TGE, 75% over 12 months |
| **Strategic Partners** | 15% | 1,500,000 | Key integrations | 24-month vesting |
| **Early Contributors** | 10% | 1,000,000 | Development rewards | 50% at TGE, 50% over 12 months |

### 10.2 Vesting Schedules

**Founders/Team (48-month vesting, 12-month cliff):**
- Month 0-12: 0% (cliff)
- Month 12: 25% unlock
- Month 13-48: Remaining 75% linear monthly

**Strategic Partners (24-month vesting):**
- Month 0: 10% unlock
- Month 1-24: Remaining 90% linear monthly

**Early Contributors:**
- Month 0: 50% unlock
- Month 1-12: Remaining 50% linear monthly

**Community Airdrop:**
- Month 0: 25% unlock
- Month 1-12: Remaining 75% linear monthly

### 10.3 SkyIvy Coin Distribution

**Total Supply:** 1,000,000,000 SkyIvy

| Allocation | Percentage | Amount | Purpose | Emission |
|------------|------------|--------|---------|----------|
| **Circulating at TGE** | 50% | 500,000,000 | Initial liquidity | Immediate |
| **Creator Rewards** | 30% | 300,000,000 | 2% Ad9x revenue distribution | 10-year emission |
| **Treasury Reserve** | 15% | 150,000,000 | Buybacks, incentives | DAO-governed |
| **Ecosystem Grants** | 5% | 50,000,000 | Development, marketing | 5-year emission |

### 10.4 Emission Schedules

**Creator Rewards (300M over 10 years):**
- Year 1: 50M (16.7%)
- Year 2-5: 30M/year (10%)
- Year 6-10: 20M/year (6.7%)
- Emission reduces as ecosystem matures

**Ecosystem Grants (50M over 5 years):**
- Year 1: 15M (30%)
- Year 2: 12M (24%)
- Year 3: 10M (20%)
- Year 4: 8M (16%)
- Year 5: 5M (10%)

### 10.5 Deflationary Mechanisms

**Buyback and Burn:**
- DAO can approve treasury SkyIvy buybacks
- Burned tokens permanently removed from supply
- Quarterly burn reports

**Transaction Fees:**
- 0.5% fee on SkyIvy transfers (if implemented)
- Fee split: 50% to treasury, 50% burned

---

## Document Control

| Element | Value |
|---------|-------|
| **Version** | 1.1 |
| **Last Updated** | April 8, 2026 |
| **Effective Date** | Upon DAO Genesis |
| **Amendment History** | v1.0 (Initial), v1.1 (Added Safeguards & Allocation) |
| **Next Review** | Month 24 (Autonomous Phase transition) |

---

**Document Status**: Finalized  
**Effective Date**: Upon DAO deployment  
**Legal Entity**: United Series of America Master DAO, LLC  
**Technical Implementation**: XRPL / Smart Contract
