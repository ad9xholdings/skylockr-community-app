# SkyLockr DAO Quorum Governance Charter

**Institutional Constitution | Version 1.0**

**Effective Date:** Upon DAO Token Genesis  
**Jurisdiction:** Republic of the Marshall Islands  
**Legal Entity:** United Series of America Master DAO, LLC

---

## PREAMBLE

We, the token holders of the SkyLockr Decentralized Autonomous Organization, establish this Charter to secure the principles of decentralized governance, economic sovereignty, and protocol integrity. This document constitutes the supreme governance framework for the SkyLockr ecosystem, binding upon all participants, contributors, and integrated protocols.

**Core Principles:**
1. **Governance Sovereignty** — DAO token holders possess ultimate authority over protocol parameters
2. **Economic Separation** — Governance and economic value operate through distinct token mechanisms
3. **Transparency** — All governance actions occur on-chain and are publicly verifiable
4. **Progressive Decentralization** — Autonomy increases as the ecosystem matures
5. **Long-term Alignment** — Lockup mechanisms ensure stakeholder commitment

---

## ARTICLE I: DEFINITIONS

| Term | Definition |
|------|------------|
| **DAO Token** | The governance token conferring voting rights within the SkyLockr ecosystem |
| **SkyIvy Coin** | The economic token capturing value from ecosystem revenue |
| **SkyLockr Treasury** | The smart contract system executing DAO decisions and managing protocol reserves |
| **Quorum** | The minimum participation threshold required for valid governance decisions |
| **Proposal** | A formal request for governance action submitted to the DAO |
| **Lockout Period** | The 100-month duration during which DAO token sales are restricted |
| **SubDAO** | A subsidiary governance entity operating under Master DAO authority |
| **White-Label Partner** | An authorized entity deploying SkyLockr technology under separate branding |
| **Ad9x Holdings** | The operating company generating revenue subject to DAO governance |
| **ORME** | The core Offer-Request-Match-Execute protocol underlying all transactions |

---

## ARTICLE II: GOVERNANCE STRUCTURE

### Section 2.1: Governance Token

**DAO Token Attributes:**
- **Voting Power:** 1 DAO Token = 1 Vote
- **Transferability:** Restricted per Article IV
- **Economic Rights:** None (no dividend, yield, or revenue share)
- **Conversion Rights:** One-way conversion to SkyIvy per Article V

**Voting Mechanism:**
- Votes are recorded on-chain via the SkyLockr Treasury
- Vote delegation is permitted but non-transferable
- Voting power snapshots at proposal submission block

### Section 2.2: Governance Scope

**Exclusive DAO Authority:**
1. Treasury allocations and reserve management
2. Revenue routing percentages from Ad9x Holdings
3. SkyIvy reward distribution parameters
4. Protocol fee schedules and economic parameters
5. White-label partner authorization and terms
6. SubDAO formation and oversight
7. Smart contract upgrades and security modifications
8. Emergency protocol pauses and parameter adjustments

**Reserved Matters** (requiring supermajority per Article III):
1. Charter amendments
2. Tokenomics changes (supply, emission, conversion rates)
3. Treasury distribution beyond 24-month runway
4. Protocol architectural changes
5. Dispute resolution for governance attacks

### Section 2.3: Treasury Execution

**SkyLockr Treasury Powers:**
- Execute DAO-approved parameter changes
- Manage protocol reserves per DAO specifications
- Apply white-label configuration defaults
- Maintain governance state (fee parameters, revenue splits, thresholds)
- Log all decisions immutably on-chain

**Treasury Limitations:**
- Cannot act without DAO approval (except emergency pause)
- Cannot modify token supply or distribution without proposal
- Cannot override governance vote outcomes
- Must maintain 24-month minimum reserve per Article VI

---

## ARTICLE III: PROPOSAL PROCESS

### Section 3.1: Proposal Creation

**Eligibility:**
- Minimum holding: 13% of circulating DAO token supply
- Holding duration: Minimum 30 days prior to proposal submission
- No active proposals from same address within 14 days

**Proposal Requirements:**
- Clear title and description
- Specific actionable parameters
- Implementation timeline
- Risk assessment and mitigation plan
- Code audit (for technical proposals)

### Section 3.2: Voting Process

**Standard Proposals:**
| Parameter | Requirement |
|-----------|-------------|
| Voting Period | 7 full days |
| Voting Cutoff | Midnight UTC end of day 7 |
| Quorum | 20% of total voting power |
| Approval Threshold | >50% Yes votes |

**Reserved Matters (Supermajority):**
| Parameter | Requirement |
|-----------|-------------|
| Voting Period | 14 full days |
| Voting Cutoff | Midnight UTC end of day 14 |
| Quorum | 33% of total voting power |
| Approval Threshold | >67% Yes votes |

### Section 3.3: Proposal Execution

**Automatic Execution:**
- Passed proposals execute automatically via SkyLockr Treasury
- Execution delay: 48 hours (timelock for security)
- Emergency proposals may bypass timelock with 90% approval

**Failed Proposals:**
- May not be resubmitted for 30 days
- Modified proposals require new submission

---

## ARTICLE IV: TOKEN LOCKOUT MECHANISM

### Section 4.1: 100-Month Lockout

**Primary Constraint:**
All DAO tokens are subject to a 100-month (~8.3 year) lockout period from genesis.

**Liquidity Limits:**
- Maximum sale: 1% of held DAO tokens per 30-day rolling period
- Calculation: Based on current balance at time of exit request
- Tracking: Maintained by SkyLockr Treasury per-address ledger

**Enforcement:**
- Exit Gateway smart contract enforces limits
- Unauthorized transfers are non-recognized for governance
- Legal prohibition in DAO LLC operating agreement

### Section 4.2: Exit Gateway

**Authorized Exit Paths:**
1. Conversion to SkyIvy (one-way, irreversible)
2. DAO-approved strategic transfers (multi-sig override)
3. Treasury buybacks (if authorized by governance)

**Exit Gateway Process:**
```
Exit Request → Balance Check → 30-Day History Review → 
Limit Verification → Approval/Rejection → Execution
```

**Non-Compliance:**
DAO tokens transferred outside Exit Gateway:
- Lose all voting rights
- Are excluded from revenue distributions
- Forfeit conversion eligibility
- May be subject to exclusion from ecosystem benefits

---

## ARTICLE V: ECONOMIC TOKEN FRAMEWORK

### Section 5.1: SkyIvy Coin

**Purpose:** Pure economic value capture — no governance rights

**Value Sources:**
1. 2% of Ad9x Holdings creator gross revenue
2. DAO-approved treasury buybacks
3. Ecosystem incentive distributions
4. White-label partner fees

**Liquidity Rights:**
- Never locked
- 25% maximum liquidation per 6-month rolling period
- Full convertibility: SkyIvy → XRP → fiat

### Section 5.2: DAO to SkyIvy Conversion

**Conversion Rate Models** (DAO-selected at genesis):

**Option A — Fixed Treasury Rate:**
- Fixed ratio set by DAO (e.g., 1 DAO = 100 SkyIvy)
- Predictable, transparent
- Treasury assumes price risk

**Option B — Dynamic Market Rate:**
- Based on treasury reserves + circulating supply + market price
- Market-aligned
- Lower treasury risk

**Option C — Auction Exit:**
- Periodic auction pools
- Demand-based pricing
- Prevents sudden liquidity shocks

**Irreversibility:**
- All conversions are one-way and permanent
- DAO tokens burned upon conversion
- Voting power permanently extinguished

---

## ARTICLE VI: TREASURY SUSTAINABILITY

### Section 6.1: Reserve Requirements

**Minimum Reserve:**
SkyLockr Treasury must maintain reserves sufficient for:
- 24 months of projected SkyIvy distributions, OR
- 18 months of operating expenses (whichever is greater)

**Distribution Limitations:**
- DAO cannot approve distributions violating minimum reserve
- Treasury automatically blocks non-compliant proposals
- Reserve calculation updated monthly

### Section 6.2: Revenue Flow

**Ad9x Holdings Revenue:**
```
Ad9x Gross Revenue
        ↓
Operating Expenses
        ↓
Protocol Profit
        ↓
2% → SkyIvy Treasury
        ↓
DAO-Governed Distribution
```

**White-Label Revenue:**
- 20% protocol fee to Ad9x
- Subject to same 2% SkyIvy allocation
- Additional fees per white-label agreement

---

## ARTICLE VII: SUBDAO GOVERNANCE

### Section 7.1: SubDAO Formation

**Authorization:**
- Requires Master DAO proposal approval
- Must specify: purpose, governance structure, funding, revenue share

**SubDAO Requirements:**
1. RMI DAO LLC registration
2. Minimum 5% revenue share to Master DAO Treasury
3. Compliance with Master DAO protocol standards
4. Quarterly reporting to Master DAO

### Section 7.2: SubDAO Autonomy

**SubDAO Controls:**
- Internal governance parameters
- Community management
- Local feature development
- Sub-treasury allocations (within approved budget)

**Master DAO Reserved Controls:**
- Protocol architecture changes
- Economic parameters (fees, rewards)
- Token issuance authorization
- Dispute resolution

---

## ARTICLE VIII: WHITE-LABEL GOVERNANCE

### Section 8.1: White-Label Authorization

**Approval Process:**
- DAO proposal for each white-label partner
- Minimum requirements: legal entity, compliance framework, use case
- Revenue share agreement (minimum 20% to protocol)

### Section 8.2: White-Label Boundaries

**White-Label Partners MAY:**
- Deploy SkyLockr technology under separate branding
- Configure UI/UX per brand guidelines
- Manage community relationships
- Set local fee schedules (within DAO-approved ranges)

**White-Label Partners MAY NOT:**
- Modify core protocol logic
- Issue governance tokens without DAO approval
- Alter economic parameters (revenue shares, reward rates)
- Access Master DAO treasury

---

## ARTICLE IX: EMERGENCY PROTOCOLS

### Section 9.1: Emergency Pause

**Authority:**
- SkyLockr Treasury multi-sig may pause protocol in emergency
- Duration: Maximum 14 days without DAO approval
- Requires: 3-of-5 multi-sig consensus

**Emergency Conditions:**
1. Critical security vulnerability
2. Economic attack threatening treasury
3. Regulatory enforcement action
4. System failure preventing governance

### Section 9.2: Emergency Proposal Fast-Track

**Accelerated Process:**
- 24-hour voting period (vs. standard 7 days)
- 90% approval threshold (vs. standard 50%)
- Immediate execution upon passage
- Post-emergency review within 30 days

---

## ARTICLE X: CHARTER AMENDMENTS

### Section 10.1: Amendment Process

**Reserved Matter Status:**
Charter amendments require supermajority approval per Article III.

**Amendment Proposal Requirements:**
- 90-day notice period before vote
- Public comment period
- Legal review for compliance
- Impact assessment on existing stakeholders

### Section 10.2: Non-Delegable Provisions

**Permanent Provisions** (cannot be amended):
1. 100-month lockout mechanism
2. One-way DAO → SkyIvy conversion
3. 1 DAO = 1 Vote principle
4. 24-month minimum treasury reserve

---

## ARTICLE XI: DISPUTE RESOLUTION

### Section 11.1: On-Chain Disputes

**Governance Attacks:**
- Defined as: proposals violating Charter principles, flash loan voting, coordinated manipulation
- Resolution: Supermajority vote to nullify and penalize

**Technical Disputes:**
- Smart contract bugs: Emergency pause + technical review
- Oracle failures: Fallback to manual DAO vote

### Section 11.2: Off-Chain Disputes

**Jurisdiction:** Republic of the Marshall Islands
**Governing Law:** RMI DAO Act 2022, RMI Non-Profit Entities Act 2021
**Arbitration:** Binding arbitration in Majuro, Marshall Islands

---

## ARTICLE XII: TRANSITIONAL PROVISIONS

### Section 12.1: Genesis Phase (Months 0-24)

**Hybrid Treasury Model:**
- DAO votes require Quorum verification before execution
- Multi-sig oversight of treasury operations
- Monthly governance reports

### Section 12.2: Autonomous Phase (Months 24+)

**Full Decentralization:**
- Automatic execution of DAO votes
- Reduced multi-sig role (emergency only)
- Continuous on-chain monitoring

### Section 12.3: Lockout Lift (Month 100)

**Post-Lockout Governance:**
- DAO may propose new liquidity mechanisms
- 100-month lockout constraint expires
- Alternative constraints may be implemented via supermajority

---

## SCHEDULE A: GOVERNANCE PARAMETERS

| Parameter | Standard Proposal | Reserved Matter | Emergency |
|-----------|-------------------|-----------------|-----------|
| Proposal Threshold | 13% of circulating supply | 13% of circulating supply | 5% of circulating supply |
| Holding Duration | 30 days | 30 days | 7 days |
| Voting Period | 7 days | 14 days | 24 hours |
| Quorum | 20% | 33% | 20% |
| Approval Threshold | >50% | >67% | >90% |
| Execution Timelock | 48 hours | 48 hours | Immediate |

---

## SCHEDULE B: TOKEN PARAMETERS

| Parameter | DAO Token | SkyIvy Coin |
|-----------|-----------|-------------|
| Total Supply | 10,000,000 | 1,000,000,000 |
| Purpose | Governance | Economic |
| Voting Rights | Yes | No |
| Lockout | 100 months | None |
| Liquidity Limit | 1% per 30 days | 25% per 6 months |
| Conversion | → SkyIvy only | → XRP → fiat |
| Reversible | No | N/A |

---

## RATIFICATION

This Charter is ratified by the founding DAO token holders upon genesis block execution. All subsequent token holders, by acquiring DAO tokens, agree to be bound by the terms herein.

**Executed this ____ day of __________, 2026**

_________________________
Founding Signatory

_________________________
Founding Signatory

_________________________
Founding Signatory

---

**Document Control:**
- Version: 1.0
- Effective: Upon Genesis
- Amendment History: None
- Next Review: Month 24 (Autonomous Phase transition)

---

*"In code we trust, in governance we unite, in decentralization we persist."*

— SkyLockr DAO Genesis
