# SkyLockr Community App - Complete Infrastructure

## 📁 Project Structure

```
skylockr-community-app/
├── docker-compose.yml              # Main Docker orchestration
├── deploy.sh                       # Deployment automation script
├── .env.example                    # Environment template
├── README.md                       # Main documentation
├── LICENSE                         # MIT License
│
├── discourse/                      # Discourse Application Layer
│   ├── Dockerfile                  # Custom Discourse build
│   └── entrypoint.sh               # Container initialization
│
├── theme/                          # SkyLockr Branding Theme
│   ├── about.yml                   # Plugin metadata
│   ├── theme.json                  # Theme configuration
│   ├── common/
│   │   └── common.scss             # Main styles (colors, typography)
│   ├── desktop/
│   │   └── desktop.scss            # Desktop-specific styles
│   ├── mobile/
│   │   └── mobile.scss             # Mobile-specific styles
│   ├── javascripts/
│   │   └── skylockr-wallet.js      # XRP wallet integration
│   ├── templates/
│   │   └── header.hbs              # Custom header templates
│   └── README.md                   # Theme documentation
│
├── wallet-integration/             # XRP Ledger Integration
│   ├── discourse-plugin/           # Discourse plugin
│   │   ├── plugin.rb               # Plugin entry point
│   │   ├── app/controllers/
│   │   │   └── wallet_controller.rb # Wallet API endpoints
│   │   ├── lib/
│   │   │   ├── xumm_client.rb      # XUMM API client
│   │   │   └── xrpl_client.rb      # XRP Ledger client
│   │   └── README.md               # Plugin documentation
│   └── websocket/                  # Real-time XRP service
│       ├── Dockerfile
│       ├── package.json
│       └── server.js               # WebSocket server
│
├── mobile/                         # Mobile Apps (Capacitor)
│   ├── capacitor.config.json       # Capacitor configuration
│   ├── package.json                # Dependencies
│   └── src/
│       └── main.js                 # Mobile bridge code
│
├── desktop/                        # Desktop Apps (Electron)
│   ├── package.json                # Electron configuration
│   └── src/
│       ├── main.js                 # Main process
│       └── preload.js              # Preload scripts
│
├── config/                         # Infrastructure Config
│   ├── nginx.conf                  # Reverse proxy config
│   ├── redis.conf                  # Redis cache config
│   └── prometheus.yml              # Monitoring config
│
├── scripts/                        # Utility Scripts
│   └── postgres-init/
│       └── 01-init.sh              # Database initialization
│
└── docs/                           # Documentation
    └── demo.html                   # Demo landing page
```

## 🚀 Quick Deployment

```bash
# 1. Clone and setup
cd /root/.openclaw/workspace/skylockr-community-app
cp .env.example .env
# Edit .env with your values

# 2. Deploy
chmod +x deploy.sh
./deploy.sh production

# 3. Access
# Web: http://localhost
# Grafana: http://localhost:3000
```

## 🎨 Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Navy | `#002145` | Primary background |
| Royal | `#003594` | Primary buttons |
| Silver | `#869397` | Borders, dividers |
| Silver-Green | `#7F9695` | Highlights, badges |

## 🔐 Environment Variables

Required:
- `DISCOURSE_HOSTNAME` - Your domain
- `DB_PASSWORD` - Database password
- `SECRET_KEY_BASE` - Rails secret

Optional:
- `XUMM_API_KEY` / `XUMM_API_SECRET` - XUMM wallet
- `S3_*` - S3 storage for uploads
- `SMTP_*` - Email configuration

## 📱 Building Apps

### Mobile
```bash
cd mobile
npm install
npm run build
npm run open:ios    # or open:android
```

### Desktop
```bash
cd desktop
npm install
npm run build
```

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │   Web App    │  │  Mobile Apps │  │    Desktop Apps      │  │
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
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 🔗 Integration Points

1. **XRP Ledger** - Wallet authentication via XUMM
2. **JamZia SSO** - Single sign-on with ecosystem
3. **Membership Tiers** - Balance-based access control

## 📦 Deliverables Summary

✅ Docker Compose stack (Discourse + PostgreSQL + Redis)
✅ SkyLockr theme with brand colors
✅ XRP Wallet plugin (XUMM integration)
✅ Mobile app configs (Capacitor)
✅ Desktop app configs (Electron)
✅ Nginx reverse proxy config
✅ Prometheus/Grafana monitoring
✅ Deployment scripts
✅ Documentation
