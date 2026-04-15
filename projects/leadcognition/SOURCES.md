# LeadCognition — Source of Truth Index

Where the *real* product information lives, and how to pull the latest
into this repo for SEO/content work.

## Product Repo

- **Local path**: `~/dev/martech/leadcognition` (monorepo)
- **GitHub**: <https://github.com/wiselancer/leadcognition_v2>
- **Primary branch**: `main`

## Canonical Docs (pulled via `scripts/sync-product-docs.sh`)

After sync, these live under `projects/leadcognition/_synced/` (gitignored).
Re-sync by running `./scripts/sync-product-docs.sh` from the repo root. The
container entrypoint runs it automatically on boot.

| File | Use it for |
|------|------------|
| `_synced/docs/BRAND.md` | Brand voice, tone, positioning — source of truth over `context/brand-voice.md` |
| `_synced/docs/UNIFIED-SEO-STRATEGY.md` | Top-level SEO plan, cluster priorities, keyword themes |
| `_synced/docs/gtm-strategy.md` | GTM posture, ICP, messaging pillars |
| `_synced/docs/gtm/free-tools-strategy-2026-04.md` | **THE programmatic SEO strategy** — 10 free-tool evaluations, top-3 picks, implementation sketches. Canonical reference. |
| `_synced/docs/gtm/*.md` | Other GTM-wide strategy docs (pricing, launches, etc.) |
| `_synced/docs/research/seo-technical-audit.md` | Current technical SEO findings & gaps |
| `_synced/docs/research/traffic-acquisition-plan.md` | Paid + organic acquisition playbook |
| `_synced/docs/research/geo-aeo-aio-optimization.md` | AI/generative-search optimization plan |
| `_synced/docs/research/icp-and-ux-research.md` | ICP research, UX findings, jobs-to-be-done |
| `_synced/docs/competitors/*.yaml` | Structured competitor dossiers (Apollo, Clay, Common Room, Koala, Pocus, RB2B, Scarf, etc.) |

## Canonical issues (check before filing new SEO work)

Programmatic SEO strategy is **not** fully captured in the SEO repo's Linear Marketing project — the main issue lives in the Discover Funnel project because it depends on product backend:

- **LC-55** (High, Discover Funnel project) — `/who-uses/:slug`, `/companies-using/:slug`, `/competitors/:slug`, `/devs-behind/:repo-slug` pages — THE canonical programmatic SEO issue
- **GH #129 / #130 / #131** — Three priority free tools (Repo Intent Score, Ecosystem Snapshot, Weekly Dev Trend Report) from the free-tools strategy doc
- **GH #85** — Discover Phase E (pre-compute 500 oceans) — enables public trending reports + reverse discovery
- **LC-65** (Medium, Marketing project) — Public share URLs for Discover preview results — subset of LC-55

**Before creating any new programmatic/SEO-page issue**, grep these and the free-tools-strategy doc to avoid duplicates.

## Live Landing-Page Inventory

The set of landing pages published at `leadcognition.io` is owned by
`apps/landing` and `apps/web-v2` in the product repo:

```bash
# From the product repo
find ~/dev/martech/leadcognition/apps/landing/src/routes -type f -name '*.tsx' -o -name '*.astro' \
  | sed "s|$HOME/dev/martech/leadcognition/||"

# Published sitemap (authoritative)
curl -s https://leadcognition.io/sitemap.xml | grep -oE '<loc>[^<]+</loc>'
```

## "What Shipped Recently"

```bash
git -C ~/dev/martech/leadcognition log --oneline -30
git -C ~/dev/martech/leadcognition log --since='4 weeks ago' --pretty='%h %ad %s' --date=short
```

Inside the dev container, substitute `/workspace/leadcognition_v2` (or whatever the
product repo is mounted as) for the local path.

## Linear Workspace

TODO: add Linear workspace URL + project board link once configured. Until
then, treat shipped PRs in `leadcognition_v2` as the source of truth for
"what's real" vs. "what's in progress."

## Support / Ops

- WordPress (blog) publishing endpoint: see `context/config.md` after `/use-project leadcognition`
- GA4 + GSC property IDs: `data_sources/config/.env` (not committed)
- MU-plugin that exposes Yoast fields: `wordpress/seo-machine-yoast-rest.php`
