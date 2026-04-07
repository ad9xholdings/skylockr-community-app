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

**Document Status**: Finalized  
**Effective Date**: Upon DAO deployment  
**Legal Entity**: United Series of America Master DAO, LLC  
**Technical Implementation**: XRPL / Smart Contract
