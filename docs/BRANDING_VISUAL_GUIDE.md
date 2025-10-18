# PrivaeChat Branding - Visual Implementation Guide

## 🎨 COMPLETE BRANDING SYSTEM OVERVIEW

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     PRIVAE CHAT BRANDING ECOSYSTEM                      │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   1. FAVICONS    │  │   2. MAIN LOGO   │  │   3. METADATA    │
│   (5 files)      │  │   (1 SVG file)   │  │   (HTML/YAML)    │
└──────────────────┘  └──────────────────┘  └──────────────────┘
        │                      │                      │
        └──────────────────────┼──────────────────────┘
                               │
                               ▼
                    ┌──────────────────┐
                    │   4. COLOR CSS   │
                    │   (style.css)    │
                    └──────────────────┘
```

---

## 📱 WHERE YOUR BRANDING APPEARS

### 1. BROWSER TAB (Desktop & Mobile)

```
┌────────────────────────────────────────────────────────┐
│  ┌──┐ PrivaeChat - New Chat                    - □ ×  │
│  └──┘                                                  │
│  ▲                                                     │
│  │                                                     │
│  └─ favicon-16x16.png or favicon-32x32.png            │
│     (automatically selected based on display density) │
└────────────────────────────────────────────────────────┘

Files involved:
• favicon-16x16.png   → Small displays, low DPI
• favicon-32x32.png   → Standard displays, high DPI
• index.html          → Title "PrivaeChat"
```

---

### 2. MOBILE HOME SCREEN

```
iOS DEVICE                          ANDROID DEVICE
──────────────────────────────────  ──────────────────────────────────

┌───────────────────────┐           ┌───────────────────────┐
│  9:41 AM         100% │           │  9:41        ●●●   ■  │
├───────────────────────┤           ├───────────────────────┤
│                       │           │                       │
│   ┌─────┐ ┌─────┐   │           │   ┌─────┐ ┌─────┐   │
│   │     │ │     │    │           │   │  •  │ │  •  │   │
│   │  📱 │ │  📧 │   │           │   │ YOUR│ │     │   │
│   │     │ │     │    │           │   │ LOGO│ │     │   │
│   └─────┘ └─────┘    │           │   └─────┘ └─────┘   │
│   Phone   Mail       │           │   Gmail   Maps      │
│                       │           │                       │
│   ┌─────┐ ┌─────┐   │           │   ┌─────┐ ┌─────┐   │
│   │YOUR │ │     │    │           │   │     │ │     │   │
│   │LOGO │ │  📷 │   │           │   │  🎵 │ │  📹 │   │
│   │HERE │ │     │    │           │   │     │ │     │   │
│   └─────┘ └─────┘    │           │   └─────┘ └─────┘   │
│   Privae  Camera     │           │   Music   YouTube   │
│                       │           │                       │
│   ┌─────┐ ┌─────┐   │           │                       │
│   │  📝 │ │  ⚙️ │   │           │   ┌───────────────┐   │
│   │     │ │     │    │           │   │   YOUR LOGO   │   │
│   └─────┘ └─────┘    │           │   │   (ADAPTIVE)  │   │
│   Notes   Settings   │           │   │               │   │
│                       │           │   └───────────────┘   │
│  ─────────────────    │           │   PrivaeChat          │
│                       │           │                       │
└───────────────────────┘           └───────────────────────┘

iOS uses:                           Android uses:
• apple-touch-icon-180x180.png     • icon-192x192.png
  → 180×180px, rounded corners      → 192×192px, various shapes
  → Auto-cropped to circle
  → Opaque or transparent          • maskable-icon.png (optional)
                                     → 512×512px adaptive icon
                                     → Can be cropped to any shape
                                     → Has "safe zone" requirement
```

**Maskable Icon Safe Zone:**
```
┌─────────────────────────────────────┐
│ ●                                 ● │  Outer 20% may be
│                                     │  cropped on some devices
│     ┌───────────────────────┐     │
│     │   SAFE ZONE (80%)     │     │  Your logo/icon must
│     │                       │     │  fit entirely in this
│     │     ┌─────────┐       │     │  center 80% area
│     │     │  LOGO   │       │     │
│     │     │  HERE   │       │     │
│     │     └─────────┘       │     │
│     │                       │     │
│     └───────────────────────┘     │
│                                     │
│ ●                                 ● │
└─────────────────────────────────────┘

Test at: https://maskable.app/editor
```

---

### 3. LOGIN PAGE (First Impression!)

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                         (Dark bg)                           │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │             ╔═══════════════════════╗              │   │
│  │             ║                       ║              │   │
│  │             ║    YOUR LOGO.SVG      ║  ← 40px h   │   │
│  │             ║   (Full width auto)   ║              │   │
│  │             ║                       ║              │   │
│  │             ╚═══════════════════════╝              │   │
│  │                                                     │   │
│  │                                                     │   │
│  │         Email or Username                          │   │
│  │         ┌─────────────────────────────────┐       │   │
│  │         │                                 │        │   │
│  │         └─────────────────────────────────┘       │   │
│  │                                                     │   │
│  │         Password                                   │   │
│  │         ┌─────────────────────────────────┐       │   │
│  │         │                                 │        │   │
│  │         └─────────────────────────────────┘       │   │
│  │                                                     │   │
│  │                                                     │   │
│  │         ┌─────────────────────────────────┐       │   │
│  │         │         Continue                │       │   │ ← Your brand
│  │         │    (Your Primary Color)         │       │   │   color button
│  │         └─────────────────────────────────┘       │   │
│  │                                                     │   │
│  │                                                     │   │
│  │      Privacy Policy   |   Terms of Service        │   │ ← Custom links
│  │         (Links in your accent color)              │   │   from YAML
│  │                                                     │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
│                        (Dark bg)                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Files involved:
• logo.svg                    → Main branding logo
• style.css                   → Button colors, link colors, backgrounds
• librechat.yaml (interface)  → Privacy/Terms URLs
• index.html                  → Theme color (status bar on mobile)
```

---

### 4. CHAT INTERFACE (Main Application)

```
┌──────────────────────────────────────────────────────────────────┐
│ ┌──┐ PrivaeChat                                    👤 User  ⚙️  │ ← Header
│ └──┘                                                             │   (Brand
│                                                                  │    color)
├──────────────────────────────────────────────────────────────────┤
│ ☰ Conversations          │                                      │
│                          │                                      │
│ 🔍 Search...             │    Welcome to PrivaeChat, Brandon!  │ ← Custom
│                          │                                      │   welcome
│ + New Chat               │    Your private AI assistant        │   from YAML
│                          │                                      │
│ Today                    │                                      │
│ • Chat 1                 │                                      │
│ • Chat 2                 │    ┌──────────────────────┐         │
│                          │    │  Ollama              │         │
│ Yesterday                │    │  deepseek-r1:32b     │         │
│ • Chat 3                 │    └──────────────────────┘         │
│                          │                                      │
│ This Week                │                                      │
│ • Chat 4                 │    What can I help you with?        │
│ • Chat 5                 │                                      │
│                          │                                      │
│                          │                                      │
│                          │                                      │
│                          │ ┌──────────────────────────────────┐│
│                          │ │ Type your message...             ││
│                          │ └──────────────────────────────────┘│
│                          │                               [Send]│ ← Brand
│                          │                                      │   color
└──────────┬───────────────┴──────────────────────────────────────┘
           │
           └─ Sidebar: --surface-primary-alt (gray-850 or custom)
              Header: Uses your theme colors
              Send button: --surface-submit (your brand color)
```

---

## 🎨 COLOR SYSTEM BREAKDOWN

### Current LibreChat Colors (Default)

```
┌─────────────────────────────────────────────────────────────┐
│                    LIGHT MODE                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Background:    #ffffff  ████████  White                   │
│  Text:          #1f2937  ████████  Dark Gray               │
│                                                             │
│  PRIMARY (Green):                                           │
│  --green-500    #10b981  ████████  Emerald (links)         │
│  --green-600    #059669  ████████  Darker (hover)          │
│  --green-700    #047857  ████████  Button fill             │
│  --green-800    #065f46  ████████  Button hover            │
│                                                             │
│  ACCENT (Purple):                                           │
│  --brand-purple #ab68ff  ████████  Purple                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    DARK MODE                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Background:    #0d0d0d  ████████  Near Black              │
│  Alt Bg:        #171717  ████████  Dark Gray               │
│  Text:          #f3f4f6  ████████  Light Gray              │
│                                                             │
│  PRIMARY (Green) - same as light mode                       │
│  ACCENT (Purple) - same as light mode                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Example: Blue Brand Color Scheme

```
┌─────────────────────────────────────────────────────────────┐
│              YOUR CUSTOM COLORS (Example)                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PRIMARY (Blue instead of Green):                           │
│  --green-500    #3b82f6  ████████  Blue (links)            │
│  --green-600    #2563eb  ████████  Darker Blue (hover)     │
│  --green-700    #1d4ed8  ████████  Button fill             │
│  --green-800    #1e40af  ████████  Button hover            │
│                                                             │
│  ACCENT (Purple or change to Orange):                       │
│  --brand-purple #f97316  ████████  Orange                  │
│                                                             │
│  THEME COLOR (Mobile status bar):                           │
│  theme-color    #1d4ed8  ████████  Matches button          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Example: Corporate Brand (Dark Blue + Gold)

```
┌─────────────────────────────────────────────────────────────┐
│         CORPORATE BRANDING (Dark Blue + Gold)               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PRIMARY (Navy Blue):                                       │
│  --green-500    #1e40af  ████████  Navy (links)            │
│  --green-600    #1e3a8a  ████████  Darker Navy (hover)     │
│  --green-700    #1e3a8a  ████████  Button fill             │
│  --green-800    #172554  ████████  Button hover            │
│                                                             │
│  ACCENT (Gold):                                             │
│  --brand-purple #f59e0b  ████████  Gold                    │
│                                                             │
│  BACKGROUNDS:                                               │
│  --gray-850     #0f172a  ████████  Slate Dark              │
│  --gray-900     #020617  ████████  Slate Darker            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📏 FILE SIZE SPECIFICATIONS

### Favicons & Icons

```
┌──────────────────────┬──────────┬─────────────┬────────────────┐
│ File                 │ Size     │ Format      │ Usage          │
├──────────────────────┼──────────┼─────────────┼────────────────┤
│ favicon-16x16.png    │ 16×16px  │ PNG (trans) │ Browser tab    │
│ favicon-32x32.png    │ 32×32px  │ PNG (trans) │ Browser tab HD │
│ apple-touch-icon-    │ 180×180  │ PNG         │ iOS home       │
│   180x180.png        │          │             │                │
│ icon-192x192.png     │ 192×192  │ PNG (trans) │ Android/PWA    │
│ maskable-icon.png    │ 512×512  │ PNG (trans) │ Android adapt  │
│ logo.svg             │ Scalable │ SVG         │ Login page     │
│                      │ (40px h) │             │                │
└──────────────────────┴──────────┴─────────────┴────────────────┘

Recommended file sizes:
• favicon-16x16.png:    < 1 KB  (simple icon)
• favicon-32x32.png:    < 2 KB  (simple icon)
• apple-touch-icon:     < 5 KB  (can be more detailed)
• icon-192x192.png:     < 6 KB
• maskable-icon.png:    < 15 KB (largest, most padding)
• logo.svg:             < 10 KB (optimize with SVGOMG)
```

---

## 🔧 CONFIGURATION FILE CHANGES

### 1. librechat.yaml (YAML Configuration)

```yaml
version: 1.3.0
cache: true

# ┌────────────────────────────────────────────────┐
# │ BRANDING: INTERFACE CUSTOMIZATION              │
# └────────────────────────────────────────────────┘
interface:
  # Custom welcome message (supports {{user.name}})
  customWelcome: 'Welcome to PrivaeChat, {{user.name}}! Your private AI assistant.'

  # Privacy policy link
  privacyPolicy:
    externalUrl: 'https://privae.umbrella7.com/privacy'
    openNewTab: true

  # Terms of service link
  termsOfService:
    externalUrl: 'https://privae.umbrella7.com/terms'
    openNewTab: true

# ... rest of your config (endpoints, fileConfig, etc.)
```

### 2. index.html (Metadata & Title)

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- ┌─────────────────────────────────────────┐ -->
    <!-- │ BRANDING: CHANGE THESE VALUES           │ -->
    <!-- └─────────────────────────────────────────┘ -->

    <!-- Browser tab title -->
    <title>PrivaeChat</title>

    <!-- Meta description for SEO -->
    <meta name="description"
          content="PrivaeChat - Your private AI assistant powered by Ollama" />

    <!-- Mobile browser theme color (top bar) -->
    <meta name="theme-color" content="#171717" />
    <!-- Change to your brand color ───────────▲ -->

    <!-- Mobile app settings -->
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style"
          content="black-translucent" />

    <!-- ┌─────────────────────────────────────────┐ -->
    <!-- │ BRANDING: ICON LINKS (Don't change)     │ -->
    <!-- └─────────────────────────────────────────┘ -->

    <!-- Favicons -->
    <link rel="icon" type="image/png" sizes="32x32"
          href="assets/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16"
          href="assets/favicon-16x16.png" />
    <link rel="apple-touch-icon"
          href="assets/apple-touch-icon-180x180.png" />

    <!-- ... rest of HTML ... -->
  </head>
  <!-- ... -->
</html>
```

### 3. style.css (Color Variables)

```css
/**
 * ┌────────────────────────────────────────────────┐
 * │ BRANDING: COLOR CUSTOMIZATION                  │
 * │ Change these variables to match your brand     │
 * └────────────────────────────────────────────────┘
 */

:root {
  /* ──────────────────────────────────────────────
   * PRIMARY BRAND COLOR (currently green)
   * Replace entire palette with your brand color
   * ────────────────────────────────────────────── */
  --green-50: #ecfdf5;
  --green-100: #d1fae5;
  --green-200: #a7f3d0;
  --green-300: #6ee7b7;
  --green-400: #34d399;
  --green-500: #10b981;  /* ← Main brand color (links) */
  --green-600: #059669;  /* ← Hover state */
  --green-700: #047857;  /* ← Button background */
  --green-800: #065f46;  /* ← Button hover */
  --green-900: #064e3b;

  /* ──────────────────────────────────────────────
   * ACCENT COLOR (currently purple)
   * ────────────────────────────────────────────── */
  --brand-purple: #ab68ff; /* ← Accent highlights */

  /* ──────────────────────────────────────────────
   * NEUTRAL COLORS
   * ────────────────────────────────────────────── */
  --gray-850: #171717;     /* ← Theme color */
  --gray-900: #0d0d0d;     /* ← Dark background */

  /* ──────────────────────────────────────────────
   * SURFACE COLORS (auto-inherit from above)
   * ────────────────────────────────────────────── */
  --surface-primary: #ffffff;
  --surface-submit: var(--green-700);
  --surface-submit-hover: var(--green-800);
}

.dark {
  /* Dark mode overrides */
  --surface-primary: var(--gray-900);
  --surface-primary-alt: var(--gray-850);
}
```

---

## 📋 IMPLEMENTATION CHECKLIST

### Phase 1: Design Assets
```
[ ] 1.1  Design main logo (SVG format)
[ ] 1.2  Create 16×16px favicon
[ ] 1.3  Create 32×32px favicon
[ ] 1.4  Create 180×180px iOS icon
[ ] 1.5  Create 192×192px Android icon
[ ] 1.6  Create 512×512px maskable icon (with safe zone)
[ ] 1.7  Choose primary brand color
[ ] 1.8  Choose accent color
[ ] 1.9  Generate full color palette (50-900 shades)
[ ] 1.10 Test color contrast (WCAG AA minimum)
```

### Phase 2: File Placement
```
[ ] 2.1  Copy logo.svg → /home/mbc/dev/LibreChat/client/public/assets/
[ ] 2.2  Copy favicon-16x16.png → .../public/assets/
[ ] 2.3  Copy favicon-32x32.png → .../public/assets/
[ ] 2.4  Copy apple-touch-icon-180x180.png → .../public/assets/
[ ] 2.5  Copy icon-192x192.png → .../public/assets/
[ ] 2.6  Copy maskable-icon.png → .../public/assets/
```

### Phase 3: Configuration
```
[ ] 3.1  Update librechat.yaml → interface.customWelcome
[ ] 3.2  Update librechat.yaml → interface.privacyPolicy
[ ] 3.3  Update librechat.yaml → interface.termsOfService
[ ] 3.4  Update index.html → <title> tag
[ ] 3.5  Update index.html → <meta name="description">
[ ] 3.6  Update index.html → <meta name="theme-color">
[ ] 3.7  Update style.css → --green-* color palette
[ ] 3.8  Update style.css → --brand-purple accent
[ ] 3.9  Update style.css → --gray-850 theme color
```

### Phase 4: Build & Deploy
```
[ ] 4.1  Rebuild frontend: npm run frontend:build
[ ] 4.2  Clear Redis cache: docker exec privae_redis redis-cli FLUSHDB
[ ] 4.3  Restart services: ./stop-services.sh && ./start-services.sh
[ ] 4.4  Test in Chrome/Chromium
[ ] 4.5  Test in Firefox
[ ] 4.6  Test in Safari
[ ] 4.7  Test on iOS device (add to home screen)
[ ] 4.8  Test on Android device (add to home screen)
[ ] 4.9  Verify custom welcome message
[ ] 4.10 Verify privacy/terms links work
```

### Phase 5: Version Control
```
[ ] 5.1  Stage changes: git add .
[ ] 5.2  Commit: git commit -m "Rebrand to PrivaeChat"
[ ] 5.3  Push: git push origin main
```

---

## 🎯 QUICK REFERENCE

### File Paths
```
Favicons:  /home/mbc/dev/LibreChat/client/public/assets/*.png
Logo:      /home/mbc/dev/LibreChat/client/public/assets/logo.svg
HTML:      /home/mbc/dev/LibreChat/client/index.html
CSS:       /home/mbc/dev/LibreChat/client/src/style.css
Config:    /home/mbc/dev/LibreChat/librechat.yaml
```

### Build Commands
```bash
# Rebuild frontend
cd /home/mbc/dev/LibreChat
npm run frontend:build

# Clear cache
docker exec privae_redis redis-cli FLUSHDB

# Restart
cd /home/mbc/dev/privae-chat
./stop-services.sh
./start-services.sh --tunnel
```

### Test URLs
```
Local:      http://localhost:3026
Public:     https://privae.umbrella7.com
API Config: http://localhost:3026/api/config
```

---

## 🌈 EXAMPLE BRAND PALETTES

### Option 1: Tech Blue
```
Primary:    #0284c7  ████████  Sky Blue
Hover:      #0369a1  ████████  Darker Sky
Button:     #075985  ████████  Deep Blue
Accent:     #f59e0b  ████████  Amber
```

### Option 2: Nature Green
```
Primary:    #059669  ████████  Emerald (current)
Hover:      #047857  ████████  Darker Emerald
Button:     #065f46  ████████  Deep Green
Accent:     #8b5cf6  ████████  Violet
```

### Option 3: Enterprise Purple
```
Primary:    #7c3aed  ████████  Purple
Hover:      #6d28d9  ████████  Darker Purple
Button:     #5b21b6  ████████  Deep Purple
Accent:     #f59e0b  ████████  Gold
```

### Option 4: Minimal Gray
```
Primary:    #4b5563  ████████  Gray
Hover:      #374151  ████████  Darker Gray
Button:     #1f2937  ████████  Dark Gray
Accent:     #06b6d4  ████████  Cyan
```

---

**Created:** 2025-10-18
**Project:** PrivaeChat Branding
**See also:** BRANDING_PLAN.md
