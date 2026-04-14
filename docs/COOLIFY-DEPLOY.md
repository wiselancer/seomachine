# Deploying SEO Machine to Coolify

Short, opinionated deploy guide. Mirrors the existing `claude` app on the
same Coolify host (the one that runs the leadcognition_v2 dev container).

## What you're deploying

A long-running **dev container** — not a web service. It's a headless
Linux box with Python + Node + Claude Code CLI pre-installed. You SSH
into it (over Tailscale) and run Claude Code interactively from tmux.

See `docker/Dockerfile.dev` and `docker/coolify.yaml` for full config.

## Prerequisites

1. Coolify host with access to the `Dev` project/environment.
2. Tailscale tailnet + a reusable auth key (`tskey-auth-…`).
3. GitHub PAT (fine-grained) with:
   - `contents:read` on `wiselancer/leadcognition_v2`
   - `contents:read/write` on `wiselancer/seomachine`
4. Anthropic API key for Claude Code.

## Step-by-step

### 1. Create the app in Coolify

In the `Dev` project → `production` env:

- **Type**: Dockerfile
- **Git source**: `wiselancer/seomachine` (main branch)
- **Dockerfile path**: `docker/Dockerfile.dev`
- **Build context**: repo root (`.`)

### 2. Add runtime config

Under *Advanced → Docker Run Options*, add the same flags the existing
`claude` app uses:

```
--cap-add=NET_ADMIN
--device=/dev/net/tun
```

### 3. Volumes

Add two persistent volumes:

| Host path | Container path | Why |
|-----------|----------------|-----|
| `/data/seomachine-dev/tailscale` | `/var/lib/tailscale` | Keep Tailscale node identity across redeploys |
| `/data/seomachine-dev/workspace` | `/workspace` | Persist cloned repo + research output + logs |

### 4. Environment variables

Required:

| Key | Notes |
|-----|-------|
| `ANTHROPIC_API_KEY` | Claude Code auth |
| `GITHUB_TOKEN` | Drives repo clone + product-doc sync |

Recommended:

| Key | Notes |
|-----|-------|
| `TS_AUTHKEY` | Tailscale auth key (enables `ssh openclaw`) |
| `TS_HOSTNAME` | Defaults to `seomachine-dev`; set to whatever you want to SSH to |
| `GIT_USER_NAME` / `GIT_USER_EMAIL` | Git commit identity |
| `DOTFILES_REPO` | Optional — clones + runs `remote/setup.sh` on boot |

Optional (SEO Machine data sources — only set what you use):

- `DATAFORSEO_LOGIN`, `DATAFORSEO_PASSWORD`
- `GA4_PROPERTY_ID`
- `GSC_SITE_URL`
- `WORDPRESS_URL`, `WORDPRESS_USER`, `WORDPRESS_APP_PASSWORD`

### 5. GA4 credentials file (optional)

If you use the GA4 integration, mount the service-account JSON via Coolify's
*Storages → Files* feature at:

```
/workspace/seomachine/credentials/ga4-credentials.json
```

### 6. Deploy

Hit *Deploy*. First boot takes ~5-8 min (tmux compile, Python deps,
Playwright/Chromium is *not* included in this image to keep it lean —
add it back if a future command needs browser automation).

### 7. Connect

Once Tailscale is up:

```bash
ssh openclaw            # or whatever TS_HOSTNAME you chose
tmux attach -t dev      # pre-started session in /workspace/seomachine
claude                  # start Claude Code
```

## How this differs from local dev

- **Credentials live in env vars**, not `data_sources/config/.env`. The
  Python modules still read `.env` if present, so you can drop one onto
  the persistent `/workspace/seomachine/data_sources/config/.env` on the
  host once and forget it.
- **Product docs auto-sync** from `leadcognition_v2` into
  `projects/leadcognition/_synced/` on every container boot via
  `scripts/sync-product-docs.sh`. Locally you'd just browse the product
  repo directly.
- **No WordPress MU-plugin changes** happen from the container — those
  still deploy via the product repo's WP pipeline.
- **No Playwright/Chromium**. Add it back to `Dockerfile.dev` if a
  command starts needing browser automation.

## Updating the container

1. Push changes to `main` on `wiselancer/seomachine`.
2. In Coolify, hit *Redeploy* on the app.
3. The entrypoint re-runs `git pull` implicitly (the repo volume is
   persistent; the container image is rebuilt). If you change Python deps,
   the `pip install` layer will re-run as part of the rebuild.

## Debugging

```bash
# From the Coolify host, not Tailscale:
docker ps | grep seomachine
docker logs -f <container>
docker exec -it -u dev <container> tmux attach -t dev
```

If Tailscale doesn't come up: check `TS_AUTHKEY` validity and that the
`NET_ADMIN` cap + `/dev/net/tun` device are actually applied to the
container.
