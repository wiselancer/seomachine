# Use Project: $ARGUMENTS

Switch the active SEO Machine project to: **$ARGUMENTS**

## Your Task

1. Read ALL files from `projects/$ARGUMENTS/` using the Read tool
2. For each file, write it to `context/<filename>` using the Write tool (overwriting existing)
3. Also copy `projects/_shared/seo-guidelines.md` → `context/seo-guidelines.md` UNLESS `projects/$ARGUMENTS/seo-guidelines.md` exists (project-specific overrides shared)
4. **If `projects/$ARGUMENTS/_synced/` exists**, surface its contents in your report as "Synced from upstream product repo" — these are read-only authoritative docs (e.g., for `leadcognition`: refreshed strategy/brand/gtm pulled from `wiselancer/leadcognition_v2` by `scripts/sync-product-docs.sh`). Don't copy them into `context/` — point readers at the `_synced/` paths so they read the live versions. See `projects/$ARGUMENTS/SOURCES.md` for what's synced and where it comes from.
5. Report a summary: which project is now active, what context files were loaded, what synced docs are available (if any), and 2-3 sentence overview of the project based on its config.md

## Available Projects

| Slug | Domain | Type |
|------|--------|------|
| `leadcognition` | leadcognition.io | B2B SaaS — developer signal intelligence |
| `fruitfulcode` | fruitfulcode.com | Dev agency — custom web/mobile development |
| `stormlookup` | stormlookup.com | Property SaaS — storm damage assessment |
| `shewell-care` | shewell.care | Healthcare — women's health clinic (UK) |
| `olvia` | TBD | AI product — needs context filled in |
| `petrenko-cv` | petrenko.cv | Personal CV/portfolio — Semen Petrenko |
| `stackpass` | stackpass.app | SaaS product — needs context filled in |

## Notes

- After switching projects, all other commands (`/write`, `/research`, `/landing-write`, etc.) will use this project's context automatically
- Run `/use-project <name>` at the start of each session when switching projects
- The current project is indicated by what's in `context/config.md`
