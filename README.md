# Fairflow Systems Design — website

**fairflow.co.uk/design** — the home of Fairflow Systems Design and Education.

## Local development

Requires: [DDEV](https://ddev.com), [wp-cli](https://wp-cli.org), Docker Desktop.

```bash
# First-time setup
ddev start
ddev wp core download
cp .env.example .env          # fill in credentials (never commit .env)
ddev wp config create --extra-php < .env-to-config.php
ddev wp core install \
  --url=https://fairflow-design.ddev.site \
  --title="Fairflow Systems Design" \
  --admin_user=matthew \
  --admin_email=matthew@fairflow.co.uk \
  --prompt=admin_password

# Import content from backup
ddev wp import fairflow-export.xml

# Daily use
ddev start     # start environment
ddev stop      # stop (keeps data)
ddev poweroff  # stop all DDEV projects
```

Visit: **https://fairflow-design.ddev.site**

## Wolfram content

See [wolfram/README.md](wolfram/README.md) for how to convert `.nb` / `.cdf` files
to web-embeddable formats (Wolfram Cloud iframes, MP4 exports, animated GIFs).

## Deploy to Krystal (fairflow.co.uk/design)

See [deploy/README.md](deploy/README.md) for full instructions.

Quick deploy (credentials in `~/.ssh/config`):

```bash
./deploy/sync.sh
```

## Repository structure

```
.ddev/            DDEV config (no secrets)
deploy/           Sync scripts and deploy docs
wolfram/
  downloads/      .nb/.cdf files offered as downloads (Git LFS)
  media/          Exported GIFs/MP4s (Git LFS)
wp-content/
  themes/
    fairflow/     Custom theme (committed)
  plugins/        Ignored — installed via wp-cli
```
