# SkyLockr Theme Configuration Guide

## Color Variables

The theme uses CSS custom properties for consistent branding:

```scss
--skylockr-navy: #002145;          // Primary background
--skylockr-royal: #003594;         // Primary buttons
--skylockr-metallic: #869397;      // Borders
--skylockr-silver-green: #7F9695;  // Accents
```

## Components

### Header
- Gradient: `linear-gradient(90deg, #002145 0%, #002D62 100%)`
- Border: 2px solid `#869397`

### Buttons
- Primary: `#003594` background, rounded 25px
- Secondary: Transparent with border

### Cards
- Border radius: 20px
- Shadow: `0 20px 50px rgba(0, 33, 69, 0.15)`

### Typography
- Headings: 'Cinzel', serif
- Body: 'Inter', sans-serif

## Membership Badges

```html
<span class="membership-badge entry">🌱 Entry</span>
<span class="membership-badge pro">⚡ Pro</span>
<span class="membership-badge master">👑 Master</span>
<span class="membership-badge prime">💎 Prime</span>
```

## Custom Classes

- `.skylockr-hero` - Hero banner section
- `.membership-tiers` - Tier cards container
- `.xrp-wallet-widget` - Wallet connector widget
- `.custom-footer` - Footer section
