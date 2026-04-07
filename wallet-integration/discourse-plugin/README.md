# XRP Wallet Integration - Discourse Plugin

## Overview

This plugin provides XRP Ledger wallet integration for the SkyLockr Community platform, enabling users to connect their XUMM wallet and access membership tiers based on their XRP balance.

## Features

- XUMM wallet connection via QR code
- Automatic membership tier assignment based on XRP balance
- Real-time balance updates via WebSocket
- Wallet address verification
- JamZia SSO integration

## Membership Tiers

| Tier | Minimum XRP | Price | Features |
|------|-------------|-------|----------|
| Entry | 0 | Free | Basic community access |
| Pro | 100 | $19/mo | Republic tier access |
| Master | 500 | $49/mo | Metaverse access |
| Prime | 2000 | $99/mo | Full ecosystem |

## API Endpoints

### POST /xrp-wallet/connect
Initiates XUMM wallet connection.

Response:
```json
{
  "uuid": "...",
  "qr_url": "https://xumm.app/qr/...",
  "xumm_app_url": "https://xumm.app/sign/..."
}
```

### GET /xrp-wallet/verify/:uuid
Verifies XUMM payload completion.

Response:
```json
{
  "verified": true,
  "address": "r...",
  "balance": 1500.5,
  "network": "mainnet",
  "membership_tier": "master"
}
```

### POST /xrp-wallet/disconnect
Disconnects wallet from user account.

### POST /skylockr/verify-membership
Verifies and updates membership tier based on current balance.

## Configuration

Add to `discourse.conf`:

```
xumm_api_key = your_api_key
xumm_api_secret = your_api_secret
xrp_network = mainnet
```

Or set environment variables:

```bash
XUMM_API_KEY=your_key
XUMM_API_SECRET=your_secret
XRP_NETWORK=mainnet
```

## Development

1. Clone into Discourse plugins directory:
```bash
cd /var/www/discourse/plugins
git clone https://github.com/skylockr/xrp-wallet-plugin.git
```

2. Restart Discourse:
```bash
sv restart unicorn
```

3. Run tests:
```bash
bundle exec rake plugin:spec[xrp-wallet]
```
