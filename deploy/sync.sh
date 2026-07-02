#!/usr/bin/env bash
# Deploy fairflow.co.uk/design to Krystal via rsync over SFTP/SSH
#
# Prerequisites:
#   1. Add your Krystal SSH credentials to ~/.ssh/config (see deploy/README.md)
#   2. Set KRYSTAL_HOST in your shell or .env.local (never commit this file)
#   3. Run: chmod +x deploy/sync.sh
#
# Usage:
#   ./deploy/sync.sh            # dry run (shows what would change)
#   ./deploy/sync.sh --live     # real deploy

set -euo pipefail

# ── Load local env (not committed) ───────────────────────────────────────────
ENV_LOCAL="$(dirname "$0")/../.env.local"
if [[ -f "$ENV_LOCAL" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_LOCAL"
fi

KRYSTAL_HOST="${KRYSTAL_HOST:-}"
KRYSTAL_USER="${KRYSTAL_USER:-}"
KRYSTAL_PORT="${KRYSTAL_PORT:-722}"
REMOTE_PATH="${REMOTE_PATH:-public_html/design}"

if [[ -z "$KRYSTAL_HOST" || -z "$KRYSTAL_USER" ]]; then
  echo "ERROR: Set KRYSTAL_HOST and KRYSTAL_USER in .env.local or environment."
  echo "  See deploy/README.md for instructions."
  exit 1
fi

RSYNC_DEST="${KRYSTAL_USER}@${KRYSTAL_HOST}:${REMOTE_PATH}/"

DRY_RUN="--dry-run"
if [[ "${1:-}" == "--live" ]]; then
  DRY_RUN=""
  echo "⚡ LIVE DEPLOY to ${RSYNC_DEST}"
else
  echo "🔍 DRY RUN (pass --live to deploy for real)"
  echo "   Target: ${RSYNC_DEST}"
fi

# ── What we sync ──────────────────────────────────────────────────────────────
# WordPress core files (wp-admin, wp-includes, wp-*.php) are synced from the
# local DDEV install. wp-config.php is excluded — it lives on the server only.
# Uploads are excluded — manage via cPanel File Manager or a separate media sync.

rsync -avz $DRY_RUN \
  --checksum \
  --delete \
  --exclude='.git/' \
  --exclude='.ddev/' \
  --exclude='deploy/' \
  --exclude='wolfram/' \
  --exclude='node_modules/' \
  --exclude='wp-config.php' \
  --exclude='wp-content/uploads/' \
  --exclude='wp-content/cache/' \
  --exclude='wp-content/upgrade/' \
  --exclude='.DS_Store' \
  --exclude='*.log' \
  -e "ssh -p ${KRYSTAL_PORT}" \
  ./ \
  "$RSYNC_DEST"

echo ""
if [[ -z "$DRY_RUN" ]]; then
  echo "✅ Deploy complete."
else
  echo "Dry run done. Run with --live to apply."
fi
