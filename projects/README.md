# Multi-Project Context

This directory contains SEO Machine context for all projects owned by Semen Petrenko.

## How to Use

```
/use-project leadcognition    # Switch to LeadCognition
/use-project fruitfulcode     # Switch to Fruitful Code  
/use-project stormlookup      # Switch to StormLookup
/use-project shewell-care     # Switch to Shewell.care
/use-project petrenko-cv      # Switch to personal CV/portfolio
/use-project olvia            # Switch to Olvia (fill in context first)
/use-project stackpass        # Switch to StackPass (fill in context first)
```

## Project Status

| Project | Domain | Context Ready | CMS Configured |
|---------|--------|---------------|----------------|
| leadcognition | leadcognition.io | ✅ Full | ❌ No blog yet |
| fruitfulcode | fruitfulcode.com | ✅ Core | ❓ Confirm WP |
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

## Updating a Project

1. Edit the relevant file in `projects/<slug>/`
2. Re-run `/use-project <slug>` to reload into `context/`
3. All commands will pick up the changes automatically
