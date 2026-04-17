# Multi-Project Context

This directory contains SEO Machine context for all projects owned by Semen Petrenko.

## How to Use

```
python3 scripts/use_project.py leadcognition   # Codex / shell workflow
/use-project leadcognition                     # Claude Code workflow
```

Available slugs:

```
python3 scripts/use_project.py --list
```

## Project Status

| Project | Domain | Context Ready | CMS Configured |
|---------|--------|---------------|----------------|
| leadcognition | leadcognition.io | ✅ Full | ❌ No blog yet |
| fruitfulcode | fruitfulcode.com | ✅ Full | ✅ Netlify site with live blog routes |
| stormlookup | stormlookup.com | ✅ Core | ❓ TBD |
| shewell-care | shewell.care | ✅ Core | ❓ TBD |
| petrenko-cv | petrenko.cv | ✅ Core | ❓ Static |
| olvia | olvia.group | ✅ Core | ❓ TBD (news section active) |
| stackpass | stackpass.app | ✅ Full | ❓ TBD |

## Context Files Per Project

Each project directory should contain:
- `config.md` — Domain, CMS endpoint, analytics IDs, pricing, key URLs
- `brand-voice.md` — Tone, messaging pillars, examples ✅/❌
- `features.md` — Product/service features and conversion angles
- `competitor-analysis.md` — Competitive landscape and content angles
- `internal-links-map.md` — Key pages to link to
- `target-keywords.md` — Primary, secondary, and long-tail keywords
- `ai-citation-targets.md` — Where to get cited by AI tools
- `reddit-strategy.md` — Subreddits and engagement approach
- `style-guide.md` — Grammar, formatting, terminology rules
- `writing-examples.md` — Voice examples (good and bad)

## _shared/

`_shared/seo-guidelines.md` contains universal SEO formatting rules (structure, meta elements, AI search optimization). The `/use-project` command copies this to `context/seo-guidelines.md` unless a project-specific override exists.

## context/

`context/` is generated active-project state. Edit `projects/<slug>/` first, then reload into `context/` with `/use-project <slug>` or `python3 scripts/use_project.py <slug>`.

## Updating a Project

1. Edit the relevant file in `projects/<slug>/`
2. Re-run `/use-project <slug>` or `python3 scripts/use_project.py <slug>` to reload into `context/`
3. All commands will pick up the changes automatically
