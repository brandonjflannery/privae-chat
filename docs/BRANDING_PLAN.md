# PrivaeChat Branding Customization Plan

## Overview
This document outlines all customizable branding elements in LibreChat and provides a step-by-step implementation plan for rebranding to PrivaeChat.

---

## 📋 BRANDING INVENTORY

### 1. FAVICON & APP ICONS
**Location:** `/home/mbc/dev/LibreChat/client/public/assets/`

| File | Size | Purpose | Current State |
|------|------|---------|---------------|
| `favicon-16x16.png` | 16×16px | Browser tab icon (small) | LibreChat green/purple gradient |
| `favicon-32x32.png` | 32×32px | Browser tab icon (standard) | LibreChat green/purple gradient |
| `apple-touch-icon-180x180.png` | 180×180px | iOS home screen icon | LibreChat green/purple gradient |
| `icon-192x192.png` | 192×192px | Android/PWA icon | LibreChat green/purple gradient |
| `maskable-icon.png` | 512×512px | Android adaptive icon | LibreChat logo (maskable format) |

**Visual Reference:**
```
┌─────────────────────────────────────────────────────────┐
│  Browser Tab                                            │
│  ┌──┐ LibreChat                                         │
│  └──┘ ← favicon-16x16.png or favicon-32x32.png         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  iOS Home Screen          Android Home Screen           │
│  ┌──────────┐            ┌──────────┐                  │
│  │          │            │          │                   │
│  │   ICON   │            │   ICON   │                   │
│  │          │            │          │                   │
│  └──────────┘            └──────────┘                   │
│   LibreChat              LibreChat                      │
│                                                          │
│  ← apple-touch-icon      ← icon-192x192.png            │
│    -180x180.png            or maskable-icon.png        │
└─────────────────────────────────────────────────────────┘
```

---

### 2. LOGO & MAIN BRANDING
**Location:** `/home/mbc/dev/LibreChat/client/public/assets/`

| File | Dimensions | Purpose | Current Colors |
|------|------------|---------|----------------|
| `logo.svg` | Scalable | Login page, Auth pages | Purple (#4f00da) to Cyan (#21facf) gradient |

**Where It Appears:**
- Login page header (40px height)
- Registration page header
- Password reset page
- All authentication flows

**Visual Layout:**
```
┌─────────────────────────────────────────────────────────┐
│                     LOGIN PAGE                          │
│                                                          │
│              ┌──────────────────────┐                   │
│              │   [LOGO.SVG HERE]    │  ← 40px height   │
│              │   (Full width auto)  │                   │
│              └──────────────────────┘                   │
│                                                          │
│              Email or Username                           │
│              ┌────────────────────┐                     │
│              │                    │                     │
│              └────────────────────┘                     │
│                                                          │
│              Password                                    │
│              ┌────────────────────┐                     │
│              │                    │                     │
│              └────────────────────┘                     │
│                                                          │
│                  [Continue]                              │
│                                                          │
│         Privacy Policy | Terms of Service               │
└─────────────────────────────────────────────────────────┘
```

**Current Gradient Colors in logo.svg:**
- `#21facf` (cyan)
- `#0970ef` (blue)
- `#72004e` (dark magenta)
- `#0015b1` (dark blue)
- `#4f00da` (purple)
- `#e5311b` (red)
- `#dc180d` to `#f96e20` to `#f4ce41` (warm gradient)

---

### 3. APP TITLE & METADATA
**Configuration:** `/home/mbc/dev/LibreChat/librechat.yaml`

| Setting | Current Value | Where It Appears |
|---------|---------------|------------------|
| `appTitle` | "LibreChat" | Browser tab title, logo alt text |
| `customWelcome` | (default) | Main chat landing page greeting |
| Meta description | LibreChat description | Search engine results, social shares |
| Theme color | `#171717` (dark gray) | Mobile browser chrome color |

**Configuration Example:**
```yaml
# In librechat.yaml
version: 1.3.0
cache: true

# Add this section:
interface:
  customWelcome: 'Welcome to PrivaeChat, {{user.name}}! Your private AI assistant.'
  privacyPolicy:
    externalUrl: 'https://privae.umbrella7.com/privacy'
    openNewTab: true
  termsOfService:
    externalUrl: 'https://privae.umbrella7.com/terms'
    openNewTab: true
```

**HTML Metadata Location:** `/home/mbc/dev/LibreChat/client/index.html`
```html
<!-- Lines to update -->
<title>LibreChat</title>  ← Change to "PrivaeChat"
<meta name="description" content="..." />  ← Change description
<meta name="theme-color" content="#171717" />  ← Change to brand color
```

---

### 4. COLOR SCHEME & THEMING
**Location:** `/home/mbc/dev/LibreChat/client/src/style.css`

**Current Brand Colors:**

**Primary (Green):**
```css
--green-50: #ecfdf5    /* Very light green background */
--green-100: #d1fae5   /* Light green background */
--green-500: #10b981   /* Primary green (links, accents) */
--green-600: #059669   /* Hover state */
--green-700: #047857   /* Submit button */
--green-800: #065f46   /* Submit button hover */
```

**Accent (Purple):**
```css
--brand-purple: #ab68ff  /* Accent purple */
```

**Neutrals (Gray):**
```css
--gray-850: #171717    /* Theme color, dark backgrounds */
--gray-900: #0d0d0d    /* Darkest background */
```

**Visual Color Map:**
```
LIGHT MODE                      DARK MODE
┌────────────────┐            ┌────────────────┐
│ #ffffff        │            │ #0d0d0d        │
│ Background     │            │ Background     │
│                │            │                │
│ ┌────────────┐ │            │ ┌────────────┐ │
│ │ #10b981    │ │            │ │ #10b981    │ │
│ │ (Green)    │ │            │ │ (Green)    │ │
│ │ [Button]   │ │            │ │ [Button]   │ │
│ └────────────┘ │            │ └────────────┘ │
│                │            │                │
│ #ab68ff        │            │ #ab68ff        │
│ (Purple accent)│            │ (Purple accent)│
└────────────────┘            └────────────────┘
```

**CSS Variables to Customize:**
```css
/* In :root selector (light mode) */
--green-500: #10b981;           ← Change to your primary brand color
--green-700: #047857;           ← Change to your button color
--brand-purple: #ab68ff;        ← Change to your accent color
--surface-submit: var(--green-700);  ← Inherits button color

/* In .dark selector (dark mode) */
--surface-primary: #0d0d0d;     ← Change dark background
--surface-primary-alt: #171717; ← Change dark alt background
```

---

### 5. WELCOME MESSAGE & LANDING PAGE
**Configuration:** `/home/mbc/dev/LibreChat/librechat.yaml`

**Current Behavior:**
- Time-based greetings (Good morning, Good afternoon, etc.)
- Generic welcome message

**Customizable Settings:**
```yaml
interface:
  customWelcome: 'Welcome to PrivaeChat, {{user.name}}!'
  # Template variables available:
  # {{user.name}} - User's display name
```

**Visual Layout:**
```
┌─────────────────────────────────────────────────────────┐
│                    CHAT LANDING PAGE                    │
│                                                          │
│                                                          │
│         Welcome to PrivaeChat, Brandon!                 │
│                                                          │
│         Your private AI assistant                       │
│                                                          │
│                                                          │
│              ┌────────────────────┐                     │
│              │  Start new chat    │                     │
│              └────────────────────┘                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

### 6. FOOTER & LEGAL LINKS
**Configuration:** `/home/mbc/dev/LibreChat/librechat.yaml`

**Current State:**
- Default privacy/terms links
- LibreChat branding in footer

**Customizable Settings:**
```yaml
interface:
  privacyPolicy:
    externalUrl: 'https://privae.umbrella7.com/privacy'
    openNewTab: true
  termsOfService:
    externalUrl: 'https://privae.umbrella7.com/terms'
    openNewTab: true
```

**Visual Layout:**
```
┌─────────────────────────────────────────────────────────┐
│                    AUTH PAGE FOOTER                     │
│                                                          │
│           Privacy Policy  |  Terms of Service           │
│                   (clickable links)                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 🎨 IMPLEMENTATION PLAN

### Phase 1: Prepare Brand Assets
**Time Estimate:** 2-4 hours (design work)

**Tasks:**
1. **Create PrivaeChat Logo**
   - [ ] Design SVG logo (scalable vector format)
   - [ ] Choose brand colors (primary, accent, neutral)
   - [ ] Export as `logo.svg`
   - [ ] Dimensions: Scalable (will be rendered at 40px height)

2. **Create Favicons**
   - [ ] Design 16×16px favicon (favicon-16x16.png)
   - [ ] Design 32×32px favicon (favicon-32x32.png)
   - [ ] Design 180×180px iOS icon (apple-touch-icon-180x180.png)
   - [ ] Design 192×192px Android icon (icon-192x192.png)
   - [ ] Design 512×512px maskable icon (maskable-icon.png)

   **Requirements:**
   - Consistent visual identity across all sizes
   - Maskable icon needs safe zone (see: https://maskable.app)
   - Use transparent backgrounds for PNG files
   - Consider visibility on both light and dark backgrounds

3. **Define Color Palette**
   - [ ] Choose primary brand color (replaces green #10b981)
   - [ ] Choose accent color (replaces purple #ab68ff)
   - [ ] Choose neutral colors (dark backgrounds, text)
   - [ ] Test color contrast for accessibility (WCAG AA minimum)
   - [ ] Document hex codes for implementation

---

### Phase 2: Update Configuration Files
**Time Estimate:** 30 minutes

**File: `/home/mbc/dev/LibreChat/librechat.yaml`**

```yaml
version: 1.3.0
cache: true

# File upload configuration
fileConfig:
  endpoints:
    ollama:
      fileLimit: 10
      fileSizeLimit: 50
      totalSizeLimit: 100
      supportedMimeTypes:
        - "image/jpeg"
        - "image/png"
        - "image/gif"
        - "image/webp"
        - "application/pdf"
  serverFileSizeLimit: 50
  avatarSizeLimit: 2

# BRANDING CONFIGURATION - UPDATE THESE
interface:
  customWelcome: 'Welcome to PrivaeChat, {{user.name}}! Your private AI assistant.'
  privacyPolicy:
    externalUrl: 'https://privae.umbrella7.com/privacy'
    openNewTab: true
  termsOfService:
    externalUrl: 'https://privae.umbrella7.com/terms'
    openNewTab: true

# Rate limits
rateLimits:
  fileUploads:
    ipMax: 100
    ipWindowInMinutes: 60
    userMax: 50
    userWindowInMinutes: 60
  conversationsImport:
    ipMax: 100
    ipWindowInMinutes: 60
    userMax: 50
    userWindowInMinutes: 60

registration:
  socialLogins: []
  allowedDomains: []

# Endpoint configuration
endpoints:
  custom:
    - name: "Ollama"
      apiKey: "ollama"
      baseURL: "http://localhost:11434/v1/"
      models:
        default:
          - "deepseek-r1:32b"
          - "deepseek-r1:7b"
          - "deepseek-r1:1.5b"
          - "gemma3:27b"
        fetch: true
      titleConvo: true
      titleModel: "current_model"
      summarize: false
      summaryModel: "current_model"
      forcePrompt: false
      modelDisplayLabel: "Ollama"
      addParams:
        max_tokens: 4096
      dropParams:
        - "user"
        - "frequency_penalty"
        - "presence_penalty"
        - "functions"
        - "function_call"
        - "tools"
        - "tool_choice"
      iconURL: "https://ollama.ai/public/ollama.png"
      modelSpecs:
        enforce: false
        prioritize: true
```

**Tasks:**
- [ ] Add `customWelcome` message
- [ ] Update `privacyPolicy.externalUrl`
- [ ] Update `termsOfService.externalUrl`
- [ ] Commit changes

---

### Phase 3: Replace Static Assets
**Time Estimate:** 15 minutes

**Location:** `/home/mbc/dev/LibreChat/client/public/assets/`

**Tasks:**
1. [ ] Backup original files (optional):
   ```bash
   cd /home/mbc/dev/LibreChat/client/public/assets
   mkdir -p ../../../librechat-original-branding
   cp *.png *.svg ../../../librechat-original-branding/
   ```

2. [ ] Replace favicon files:
   ```bash
   # Copy your custom favicons to:
   /home/mbc/dev/LibreChat/client/public/assets/favicon-16x16.png
   /home/mbc/dev/LibreChat/client/public/assets/favicon-32x32.png
   /home/mbc/dev/LibreChat/client/public/assets/apple-touch-icon-180x180.png
   /home/mbc/dev/LibreChat/client/public/assets/icon-192x192.png
   /home/mbc/dev/LibreChat/client/public/assets/maskable-icon.png
   ```

3. [ ] Replace logo:
   ```bash
   # Copy your custom logo to:
   /home/mbc/dev/LibreChat/client/public/assets/logo.svg
   ```

**File Specifications:**
- **favicon-16x16.png**: 16×16 pixels, PNG, transparent background
- **favicon-32x32.png**: 32×32 pixels, PNG, transparent background
- **apple-touch-icon-180x180.png**: 180×180 pixels, PNG, opaque or transparent
- **icon-192x192.png**: 192×192 pixels, PNG, transparent background
- **maskable-icon.png**: 512×512 pixels, PNG, transparent, with safe zone
- **logo.svg**: Scalable SVG, will be displayed at 40px height

---

### Phase 4: Update HTML Metadata
**Time Estimate:** 10 minutes

**File: `/home/mbc/dev/LibreChat/client/index.html`**

**Current Content:**
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#171717" />
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta name="description" content="LibreChat - An open source chat application..." />

    <title>LibreChat</title>

    <link rel="icon" type="image/png" sizes="32x32" href="assets/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="assets/favicon-16x16.png" />
    <link rel="apple-touch-icon" href="assets/apple-touch-icon-180x180.png" />
    <!-- ... -->
  </head>
  <!-- ... -->
</html>
```

**Changes to Make:**
```html
<!-- Line ~8: Update title -->
<title>PrivaeChat</title>

<!-- Line ~7: Update description -->
<meta name="description" content="PrivaeChat - Your private AI assistant powered by Ollama" />

<!-- Line ~3: Update theme color (optional - choose your brand color) -->
<meta name="theme-color" content="#171717" />  <!-- or your primary brand color -->
```

**Tasks:**
- [ ] Update `<title>` tag to "PrivaeChat"
- [ ] Update `<meta name="description">` to PrivaeChat description
- [ ] Update `<meta name="theme-color">` to brand color (optional)

---

### Phase 5: Customize CSS Colors
**Time Estimate:** 20 minutes

**File: `/home/mbc/dev/LibreChat/client/src/style.css`**

**Current Color Variables (starting around line 11):**
```css
:root {
  /* Green palette - PRIMARY BRAND COLOR */
  --green-50: #ecfdf5;
  --green-100: #d1fae5;
  --green-200: #a7f3d0;
  --green-300: #6ee7b7;
  --green-400: #34d399;
  --green-500: #10b981;   /* ← MAIN BRAND COLOR */
  --green-600: #059669;   /* ← HOVER STATE */
  --green-700: #047857;   /* ← BUTTON COLOR */
  --green-800: #065f46;   /* ← BUTTON HOVER */
  --green-900: #064e3b;

  /* Purple accent */
  --brand-purple: #ab68ff; /* ← ACCENT COLOR */

  /* Gray scale */
  --gray-850: #171717;     /* ← THEME COLOR */
  --gray-900: #0d0d0d;     /* ← DARK BACKGROUND */

  /* Surface colors (reference the above) */
  --surface-submit: var(--green-700);
  --surface-submit-hover: var(--green-800);
  /* ... more variables ... */
}
```

**Example: Blue Brand Color Scheme**
```css
:root {
  /* Blue palette - CUSTOM BRAND COLOR */
  --green-50: #eff6ff;
  --green-100: #dbeafe;
  --green-200: #bfdbfe;
  --green-300: #93c5fd;
  --green-400: #60a5fa;
  --green-500: #3b82f6;   /* ← MAIN BRAND COLOR (blue) */
  --green-600: #2563eb;   /* ← HOVER STATE */
  --green-700: #1d4ed8;   /* ← BUTTON COLOR */
  --green-800: #1e40af;   /* ← BUTTON HOVER */
  --green-900: #1e3a8a;

  /* Purple accent - or change to complementary color */
  --brand-purple: #8b5cf6; /* ← ACCENT COLOR (purple) */

  /* Gray scale - adjust if needed */
  --gray-850: #171717;     /* ← THEME COLOR */
  --gray-900: #0d0d0d;     /* ← DARK BACKGROUND */

  /* These will automatically inherit the new colors */
  --surface-submit: var(--green-700);
  --surface-submit-hover: var(--green-800);
}
```

**Tasks:**
- [ ] Decide on primary brand color
- [ ] Generate full color palette (50-900 shades)
- [ ] Update all `--green-*` variables
- [ ] Update `--brand-purple` accent color
- [ ] Update `--gray-850` theme color if desired
- [ ] Test in both light and dark modes

**Color Palette Generators:**
- https://uicolors.app/create
- https://tailwindcss.com/docs/customizing-colors
- https://coolors.co/

---

### Phase 6: Rebuild & Restart
**Time Estimate:** 5-10 minutes

**Tasks:**
1. [ ] Rebuild LibreChat frontend with new assets:
   ```bash
   cd /home/mbc/dev/LibreChat
   npm run frontend:build
   ```

2. [ ] Clear Redis cache (to reload configuration):
   ```bash
   docker exec privae_redis redis-cli FLUSHDB
   ```

3. [ ] Restart services:
   ```bash
   cd /home/mbc/dev/privae-chat
   ./stop-services.sh
   ./start-services.sh --tunnel
   ```

4. [ ] Verify changes:
   - [ ] Check browser tab shows new favicon and title
   - [ ] Check login page shows new logo
   - [ ] Check colors are applied correctly
   - [ ] Check custom welcome message appears
   - [ ] Test on mobile devices (iOS and Android)

---

### Phase 7: Commit & Deploy
**Time Estimate:** 5 minutes

**Tasks:**
1. [ ] Stage all branding changes:
   ```bash
   cd /home/mbc/dev/privae-chat
   git add .
   ```

2. [ ] Commit with descriptive message:
   ```bash
   git commit -m "Rebrand to PrivaeChat: Update logos, favicons, colors, and metadata

   - Replace all LibreChat logos with PrivaeChat branding
   - Update favicon set (16x16, 32x32, 180x180, 192x192, maskable)
   - Update app title and metadata in index.html
   - Customize color scheme (primary, accent, neutrals)
   - Add custom welcome message in librechat.yaml
   - Update privacy policy and terms of service links

   🎨 Full rebrand to PrivaeChat identity"
   ```

3. [ ] Push to GitHub:
   ```bash
   git push origin main
   ```

---

## 📊 VISUAL CHECKLIST

### Desktop Browser Experience
```
┌─────────────────────────────────────────────────────────┐
│ ┌──┐ PrivaeChat                                    × □ - │ ← Browser Tab
│ └──┘                                                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│              ┌──────────────────────┐                   │
│              │   [YOUR LOGO.SVG]    │                   │ ← Login Page Logo
│              └──────────────────────┘                   │
│                                                          │
│              Email or Username                           │
│              ┌────────────────────────────┐             │
│              │                            │             │
│              └────────────────────────────┘             │
│                                                          │
│              Password                                    │
│              ┌────────────────────────────┐             │
│              │                            │             │
│              └────────────────────────────┘             │
│                                                          │
│              ┌────────────────────────────┐             │
│              │        Continue            │             │ ← Brand Color Button
│              └────────────────────────────┘             │
│                                                          │
│         Privacy Policy  |  Terms of Service             │ ← Custom Links
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Mobile App Experience
```
iOS Home Screen              Android Home Screen
┌──────────────┐            ┌──────────────┐
│ ┌──────────┐ │            │ ┌──────────┐ │
│ │          │ │            │ │          │ │
│ │   YOUR   │ │            │ │   YOUR   │ │
│ │   ICON   │ │            │ │   ICON   │ │
│ │          │ │            │ │          │ │
│ └──────────┘ │            │ └──────────┘ │
│  PrivaeChat  │            │  PrivaeChat  │
└──────────────┘            └──────────────┘
```

### Chat Interface
```
┌─────────────────────────────────────────────────────────┐
│ [≡] PrivaeChat                           [User Menu]    │ ← Header (brand color)
├─────────────────────────────────────────────────────────┤
│                                                          │
│                                                          │
│         Welcome to PrivaeChat, Brandon!                 │ ← Custom Welcome
│                                                          │
│         Your private AI assistant                       │
│                                                          │
│                                                          │
│              Start a new conversation                   │
│                                                          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 TESTING CHECKLIST

After implementation, verify all branding elements:

### Browser Testing
- [ ] **Chrome/Chromium**
  - [ ] Favicon appears in tab
  - [ ] Title shows "PrivaeChat"
  - [ ] Logo displays on login page
  - [ ] Colors are correct
  - [ ] Custom welcome message appears

- [ ] **Firefox**
  - [ ] Favicon appears in tab
  - [ ] All branding elements visible

- [ ] **Safari**
  - [ ] Favicon appears in tab
  - [ ] All branding elements visible

### Mobile Testing
- [ ] **iOS (Safari)**
  - [ ] Add to Home Screen shows correct icon
  - [ ] App opens with correct branding
  - [ ] Status bar color matches theme

- [ ] **Android (Chrome)**
  - [ ] Add to Home Screen shows correct icon
  - [ ] Maskable icon adapts to device
  - [ ] App opens with correct branding

### Accessibility Testing
- [ ] Color contrast meets WCAG AA standards (4.5:1 for text)
- [ ] Logo alt text is descriptive
- [ ] Focus states are visible

### Configuration Testing
- [ ] Custom welcome message displays with user's name
- [ ] Privacy policy link works
- [ ] Terms of service link works
- [ ] Links open in new tab (if configured)

---

## 📁 FILE STRUCTURE SUMMARY

```
/home/mbc/dev/privae-chat/
├── BRANDING_PLAN.md                          ← This file
└── /home/mbc/dev/LibreChat/
    ├── librechat.yaml                        ← Update: interface settings
    └── client/
        ├── index.html                        ← Update: title, meta tags
        ├── src/
        │   └── style.css                     ← Update: color variables
        └── public/
            └── assets/
                ├── favicon-16x16.png         ← Replace
                ├── favicon-32x32.png         ← Replace
                ├── apple-touch-icon-180x180.png ← Replace
                ├── icon-192x192.png          ← Replace
                ├── maskable-icon.png         ← Replace
                └── logo.svg                  ← Replace
```

---

## 🚀 QUICK START COMMANDS

```bash
# 1. Navigate to LibreChat
cd /home/mbc/dev/LibreChat

# 2. Backup original branding (optional)
mkdir -p ../librechat-original-branding
cp client/public/assets/*.{png,svg} ../librechat-original-branding/

# 3. Copy your custom assets
# (Manually place your files in client/public/assets/)

# 4. Update configuration files
# (Edit librechat.yaml, index.html, style.css)

# 5. Rebuild frontend
npm run frontend:build

# 6. Clear Redis cache
docker exec privae_redis redis-cli FLUSHDB

# 7. Restart services
cd /home/mbc/dev/privae-chat
./stop-services.sh
./start-services.sh --tunnel

# 8. Verify in browser
# Visit: https://privae.umbrella7.com

# 9. Commit changes
git add .
git commit -m "Rebrand to PrivaeChat"
git push origin main
```

---

## 💡 DESIGN TIPS

### Logo Design
- Keep it simple and scalable
- Test at 16×16px to ensure legibility at small sizes
- Use SVG format for logo (scalable, sharp at any size)
- Consider dark/light mode visibility

### Color Selection
- Choose colors that work on both light and dark backgrounds
- Ensure sufficient contrast for accessibility
- Test with colorblind simulators
- Limit palette to 2-3 main colors

### Icon Design
- Maintain consistent visual style across all icon sizes
- Use safe zone for maskable icons (80% center area)
- Test on actual devices before finalizing
- Consider App Store/Play Store guidelines if publishing

### Typography
- LibreChat uses system fonts by default (good for performance)
- If adding custom fonts, update tailwind.config.cjs
- Keep font sizes consistent with existing UI

---

## 📚 ADDITIONAL RESOURCES

**LibreChat Documentation:**
- Configuration: https://www.librechat.ai/docs/configuration/librechat_yaml
- Branding: https://www.librechat.ai/docs/configuration/librechat_yaml/interface

**Design Tools:**
- Favicon Generator: https://realfavicongenerator.net/
- Maskable Icon Editor: https://maskable.app/editor
- Color Palette Generator: https://uicolors.app/create
- SVG Optimizer: https://jakearchibald.github.io/svgomg/

**Accessibility:**
- Color Contrast Checker: https://webaim.org/resources/contrastchecker/
- WCAG Guidelines: https://www.w3.org/WAI/WCAG21/quickref/

---

## 🔄 ROLLBACK PLAN

If you need to revert to original LibreChat branding:

```bash
# 1. Restore original assets (if backed up)
cd /home/mbc/dev/LibreChat
cp ../librechat-original-branding/*.{png,svg} client/public/assets/

# 2. Revert git changes
git checkout HEAD -- client/index.html client/src/style.css librechat.yaml

# 3. Rebuild
npm run frontend:build

# 4. Clear cache and restart
docker exec privae_redis redis-cli FLUSHDB
cd /home/mbc/dev/privae-chat
./stop-services.sh
./start-services.sh --tunnel
```

---

## ✅ COMPLETION CRITERIA

Your rebranding is complete when:
- [ ] All favicons display PrivaeChat branding
- [ ] Login page shows PrivaeChat logo
- [ ] Browser tab shows "PrivaeChat" title
- [ ] Custom welcome message appears
- [ ] Brand colors are applied throughout UI
- [ ] Mobile icons work on iOS and Android
- [ ] All links (privacy, terms) point to correct URLs
- [ ] Changes are committed to Git
- [ ] System works on https://privae.umbrella7.com

---

**Created:** 2025-10-18
**Project:** PrivaeChat (based on LibreChat v0.8.0)
**Author:** AI Assistant
