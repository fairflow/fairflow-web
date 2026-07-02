# Deploy to Krystal

## Overview

The site syncs from your local DDEV environment to Krystal shared hosting via
rsync over SSH/SFTP (port 722). WordPress core is synced; the server-side
`wp-config.php` and `wp-content/uploads/` are intentionally left untouched.

---

## One-time setup

### 1. Enable SSH on Krystal

1. Log in to your Krystal client area
2. Go to **Services → [your hosting plan] → SSH Access**
3. Enable SSH and note your username, host, and port (default: 722)

### 2. Add SSH key to Krystal

```bash
# Generate a key if you don't have one
ssh-keygen -t ed25519 -C "fairflow-deploy"

# Copy public key to Krystal (via cPanel → SSH Key Manager, or manually)
cat ~/.ssh/id_ed25519.pub
# Paste into Krystal's cPanel → Security → SSH/Shell Access → Manage Keys
```

### 3. Add to ~/.ssh/config

```
Host krystal-fairflow
  HostName      YOUR_KRYSTAL_HOST    # e.g. srv1234.krystal.co.uk
  User          YOUR_CPANEL_USER
  Port          722
  IdentityFile  ~/.ssh/id_ed25519
```

### 4. Create .env.local (never committed)

```bash
cp deploy/.env.example .env.local
# Edit .env.local with your credentials
```

Contents of `.env.local`:
```bash
KRYSTAL_HOST=srv1234.krystal.co.uk
KRYSTAL_USER=your_cpanel_username
KRYSTAL_PORT=722
REMOTE_PATH=public_html/design
```

---

## Deploying

```bash
# Dry run first — shows what would change
./deploy/sync.sh

# Real deploy
./deploy/sync.sh --live
```

---

## WordPress config on the server

`wp-config.php` is **not synced** — it lives on the server only.

After the first deploy, create it on the server via cPanel File Manager, or:

```bash
ssh krystal-fairflow
cd public_html/design
wp config create \
  --dbname=YOUR_DB_NAME \
  --dbuser=YOUR_DB_USER \
  --dbpass='YOUR_DB_PASS' \
  --dbhost=localhost \
  --path=/home/YOUR_USER/public_html/design
```

(WP-CLI availability on Krystal shared hosting is not guaranteed — check via SSH first.)

---

## Uploading media (wp-content/uploads)

Use cPanel File Manager or:
```bash
rsync -avz --checksum -e "ssh -p 722" \
  wp-content/uploads/ \
  YOUR_USER@YOUR_HOST:public_html/design/wp-content/uploads/
```

---

## Krystal-specific notes

- SFTP port is **722** (not 22)
- PHP version is set per-account in cPanel → MultiPHP Manager
- Subdirectory WordPress installs need correct `siteurl` and `home` in wp_options
  — set these before first deploy: `ddev wp option update siteurl https://fairflow.co.uk/design`
