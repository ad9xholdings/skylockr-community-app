# SkyLockr™ Community App

A complete community platform built on Discourse with XRP Ledger wallet integration, featuring SkyLockr branding and JamZia ecosystem SSO.

![SkyLockr Brand](https://img.shields.io/badge/Brand-SkyLockr-002145)
![XRP Ledger](https://img.shields.io/badge/XRP-Ledger-003594)
![Discourse](https://img.shields.io/badge/Discourse-3.2-7F9695)

## 🚀 Features

- **Discourse Forum**: Full-featured community discussion platform
- **XRP Wallet Integration**: Connect via XUMM wallet for authentication
- **Membership Tiers**: Entry, Pro, Master, Prime levels based on XRP balance
- **JamZia SSO**: Single sign-on with the JamZia ecosystem
- **Mobile Apps**: iOS and Android apps via Capacitor
- **Desktop Apps**: Windows, macOS, and Linux apps via Electron
- **Monitoring**: Prometheus + Grafana dashboards

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │   Web App    │  │  Mobile Apps │  │    Desktop Apps      │  │
│  │   (Ember)    │  │ (Capacitor)  │  │     (Electron)       │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                   APPLICATION LAYER                             │
│              Discourse (Ruby on Rails)                          │
│         ┌──────────────┐  ┌──────────────┐                     │
│         │   XRP Wallet │  │   JamZia SSO │                     │
│         │   Plugin     │  │   Plugin     │                     │
│         └──────────────┘  └──────────────┘                     │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                  DATA AVAILABILITY LAYER                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  PostgreSQL  │  │    Redis     │  │    S3 Storage        │  │
│  │   (Primary)  │  │   (Cache)    │  │   (Uploads)          │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 📦 Quick Start

### Prerequisites

- Docker & Docker Compose
- 4GB RAM minimum (8GB recommended)
- SSL certificates for production

### Installation

1. **Clone and configure:**
```bash
git clone https://github.com/skylockr/community-app.git
cd skylockr-community-app
cp .env.example .env
# Edit .env with your configuration
```

2. **Deploy:**
```bash
chmod +x deploy.sh
./deploy.sh production
```

3. **Access:**
- Web: `https://community.skylockr.com`
- Grafana: `http://localhost:3000`

## 🎨 Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Navy | `#002145` | Primary background |
| Royal | `#003594` | Buttons, accents |
| Silver | `#869397` | Borders, dividers |
| Silver-Green | `#7F9695` | Highlights, badges |

## 📱 Mobile Apps

### Build iOS App
```bash
cd mobile
npm install
npm run build
npm run open:ios
```

### Build Android App
```bash
cd mobile
npm install
npm run build
npm run open:android
```

## 💻 Desktop Apps

### Build All Platforms
```bash
cd desktop
npm install
npm run build
```

### Build Specific Platform
```bash
npm run build:mac    # macOS
npm run build:win    # Windows
npm run build:linux  # Linux
```

## 🔐 XRP Wallet Integration

### Setup XUMM

1. Create app at [apps.xumm.dev](https://apps.xumm.dev)
2. Add credentials to `.env`:
```env
XUMM_API_KEY=your_key
XUMM_API_SECRET=your_secret
```

### Membership Tiers

| Tier | XRP Balance | Price | Features |
|------|-------------|-------|----------|
| Entry | 0+ | Free | Basic access |
| Pro | 100+ | $19/mo | Republic tier |
| Master | 500+ | $49/mo | Metaverse access |
| Prime | 2000+ | $99/mo | Full ecosystem |

## 🔗 JamZia SSO

Configure JamZia authentication:

```env
JAMZIA_SSO=https://auth.jamzia.com
JAMZIA_API_KEY=your_key
JAMZIA_API_SECRET=your_secret
```

## 📊 Monitoring

Access monitoring dashboards:

- **Prometheus**: `http://localhost:9090`
- **Grafana**: `http://localhost:3000` (admin/admin)

## 🛠️ Development

### Local Development
```bash
./deploy.sh development
```

### View Logs
```bash
./deploy.sh logs
```

### Restart Services
```bash
./deploy.sh restart
```

## 📝 Environment Variables

See `.env.example` for all configuration options.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

## 📄 License

MIT License - see LICENSE file for details.

## 🔗 Links

- [SkyLockr Website](https://skylockr.com)
- [JamZia Networks](https://jamzia.com)
- [Discourse Docs](https://discourse.org)
- [XRP Ledger](https://xrpl.org)

---

Powered by [JamZia™ Networks](https://jamzia.com) | A Product of Ad9x Holdings, LLC
