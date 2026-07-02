#!/usr/bin/env bash
# First-time WordPress setup for fairflow-design.ddev.site
#
# Run from the project root AFTER ddev start:
#   ./bin/setup.sh
#
# What it does:
#   1. Downloads WordPress core
#   2. Creates wp-config.php with DDEV database credentials
#   3. Installs WordPress (prompts for admin password)
#   4. Activates the fairflow theme
#   5. Imports content from the WordPress XML backup
#   6. Sets site URLs, creates nav menu
#   7. Sets up pretty permalinks

set -euo pipefail

SITE_URL="https://fairflow-design.ddev.site"
SITE_TITLE="Fairflow Systems Design"
ADMIN_EMAIL="matthew@fairflow.co.uk"
ADMIN_USER="matthew"
THEME="fairflow"
IMPORT_FILE="$(dirname "$0")/../import/fairflowdesign.WordPress.2022-04-11.xml"

echo "=== Fairflow WordPress setup ==="
echo "Site: $SITE_URL"
echo ""

# ── 1. Download WordPress core ────────────────────────────────────────────────
if [ ! -f "wp-login.php" ]; then
  echo "→ Downloading WordPress core..."
  ddev wp core download --locale=en_GB
else
  echo "→ WordPress core already present"
fi

# ── 2. Create wp-config.php ───────────────────────────────────────────────────
if [ ! -f "wp-config.php" ]; then
  echo "→ Creating wp-config.php..."
  ddev wp config create \
    --dbname=db \
    --dbuser=db \
    --dbpass=db \
    --dbhost=db \
    --dbcharset=utf8mb4 \
    --extra-php << 'PHP'
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', false );
define( 'DISALLOW_FILE_EDIT', true );
PHP
else
  echo "→ wp-config.php already present"
fi

# ── 3. Install WordPress ──────────────────────────────────────────────────────
if ! ddev wp core is-installed 2>/dev/null; then
  echo "→ Installing WordPress..."
  echo "   You will be prompted for an admin password."
  read -rsp "   Admin password (min 12 chars): " ADMIN_PASS
  echo ""
  ddev wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --skip-email
else
  echo "→ WordPress already installed"
fi

# ── 4. Activate fairflow theme ────────────────────────────────────────────────
echo "→ Activating theme: $THEME"
ddev wp theme activate "$THEME"

# ── 5. Install useful plugins ─────────────────────────────────────────────────
echo "→ Installing plugins..."
ddev wp plugin install wordpress-importer --activate
# Remove unwanted defaults
ddev wp plugin deactivate akismet hello 2>/dev/null || true

# ── 6. Import content ─────────────────────────────────────────────────────────
if [ -f "$IMPORT_FILE" ]; then
  echo "→ Importing content from XML..."
  ddev wp import "$IMPORT_FILE" --authors=create
else
  echo "⚠  Import file not found at: $IMPORT_FILE"
  echo "   Copy fairflowdesign.WordPress.2022-04-11.xml to import/ and rerun."
fi

# ── 7. Set site URLs ──────────────────────────────────────────────────────────
echo "→ Setting site URL and home..."
ddev wp option update siteurl "$SITE_URL"
ddev wp option update home "$SITE_URL"

# ── 8. Permalinks ─────────────────────────────────────────────────────────────
echo "→ Setting permalink structure..."
ddev wp rewrite structure '/%postname%/' --hard
ddev wp rewrite flush

# ── 9. Create primary nav menu ────────────────────────────────────────────────
echo "→ Setting up navigation menu..."
MENU_EXISTS=$(ddev wp menu list --fields=name --format=csv 2>/dev/null | grep -c "^Primary" || true)
if [ "$MENU_EXISTS" -eq 0 ]; then
  ddev wp menu create "Primary"
  ddev wp menu item add-custom Primary "Home" "$SITE_URL"
  ABOUT_ID=$(ddev wp post list --post_type=page --name=about --field=ID 2>/dev/null | head -1)
  MATTHEW_ID=$(ddev wp post list --post_type=page --name=matthew --field=ID 2>/dev/null | head -1)
  GRAPH_ID=$(ddev wp post list --post_type=page --name=graph-theory-and-minimal-spanning-trees --field=ID 2>/dev/null | head -1)
  BLOG_ID=$(ddev wp option get page_for_posts 2>/dev/null || echo "")
  [ -n "$ABOUT_ID" ]  && ddev wp menu item add-post Primary "$ABOUT_ID"
  [ -n "$MATTHEW_ID" ] && ddev wp menu item add-post Primary "$MATTHEW_ID"
  [ -n "$GRAPH_ID" ]  && ddev wp menu item add-post Primary "$GRAPH_ID"
  ddev wp menu item add-custom Primary "Services" "$SITE_URL/services/"
  [ -n "$BLOG_ID" ] && ddev wp menu item add-post Primary "$BLOG_ID"
  ddev wp menu location assign Primary primary
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✅ Setup complete!"
echo ""
echo "   Admin:    $SITE_URL/wp-admin/"
echo "   Username: $ADMIN_USER"
echo ""
echo "Next steps:"
echo "  1. Visit the admin and review imported content"
echo "  2. Upload media files: wolfram/media/*.gif → wp-content/uploads/"
echo "  3. See wolfram/README.md to embed Wolfram Cloud notebooks"
echo "  4. Set up Krystal credentials in .env.local, then: ./deploy/sync.sh --live"
