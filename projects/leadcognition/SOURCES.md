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
| `_synced/docs/research/seo-technical-audit.md` | Current technical SEO findings & gaps |
| `_synced/docs/research/traffic-acquisition-plan.md` | Paid + organic acquisition playbook |
| `_synced/docs/research/geo-aeo-aio-optimization.md` | AI/generative-search optimization plan |
| `_synced/docs/research/icp-and-ux-research.md` | ICP research, UX findings, jobs-to-be-done |
| `_synced/docs/competitors/*.yaml` | Structured competitor dossiers (Apollo, Clay, Common Room, Koala, Pocus, RB2B, Scarf, etc.) |

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
