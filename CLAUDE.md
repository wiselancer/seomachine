# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SEO Machine is an open-source Claude Code workspace for creating SEO-optimized blog content. It combines custom commands, specialized agents, and Python-based analytics to research, write, optimize, and publish articles for any business.

This instance is configured for **multiple projects** owned by Semen Petrenko (wiselancer). Before starting any content work, switch to the correct project with `/use-project <name>`.

## Projects

| Slug | Domain | Type |
|------|--------|------|
| `leadcognition` | leadcognition.io | B2B SaaS — developer signal intelligence |
| `fruitfulcode` | fruitfulcode.com | Dev agency — custom web/mobile development |
| `stormlookup` | stormlookup.com | Property SaaS — storm damage assessment |
| `shewell-care` | shewell.care | Women's health clinic (UK) |
| `olvia` | TBD | AI product — fill in projects/olvia/ first |
| `petrenko-cv` | petrenko.cv | Personal CV/portfolio — Semen Petrenko |
| `stackpass` | stackpass.app | SaaS product — fill in projects/stackpass/ first |

Each project's context lives in `projects/<slug>/`. The active project's context is always in `context/`. Switch with `/use-project <slug>`.

## Setup

```bash
pip install -r data_sources/requirements.txt
```

API credentials are configured in `data_sources/config/.env` (GA4, GSC, DataForSEO, WordPress). GA4 service account credentials go in `credentials/ga4-credentials.json`.

## Quick Start (New Session)

```
/use-project leadcognition   # or whichever project you're working on
/research github developer outreach
/write how to find developers who starred your competitor
```

## Commands

All commands are defined in `.claude/commands/` and invoked as slash commands:

### Project Management
- `/use-project [slug]` - Switch active project context (always run first)

### Research
- `/research [topic]` - Keyword/competitor research, generates brief in `research/`
- `/research-serp [topic]` - SERP analysis via DataForSEO
- `/research-gaps` - Competitor content gap analysis
- `/research-trending` - Trending topics in your niche
- `/research-performance` - Content performance from GA4 + GSC
- `/research-topics` - Topic cluster discovery
- `/research-ai-citations [topic]` - Audit which sources AI cites for your topics
- `/priorities` - Content prioritization matrix

### Content Creation
- `/write [topic]` - Create full article in `drafts/`, auto-triggers optimization agents
- `/article [topic]` - Simplified article creation
- `/rewrite [topic]` - Update existing content, saves to `rewrites/`
- `/optimize [file]` - Final SEO polish pass
- `/analyze-existing [URL or file]` - Content health audit
- `/cluster [topic]` - Build complete topic cluster strategy
- `/content-calendar` - Generate a content calendar

### Landing Pages
- `/landing-write [topic]` - Write conversion landing page
- `/landing-audit [URL]` - Audit existing landing page
- `/landing-research [topic]` - Research for landing pages
- `/landing-competitor [URL]` - Analyze competitor landing page
- `/landing-publish [file]` - Publish landing page to WordPress

### Publishing & Distribution
- `/publish-draft [file]` - Publish to WordPress via REST API
- `/repurpose [file]` - Adapt article for LinkedIn, Medium, Reddit, Quora
- `/scrub [file]` - Remove AI watermarks and telltale phrases
- `/performance-review` - Analytics-driven content priorities

## Architecture

### Command-Agent Model

**Commands** (`.claude/commands/`) orchestrate workflows. **Agents** (`.claude/agents/`) are specialized roles invoked by commands. After `/write`, these agents auto-run: SEO Optimizer, Meta Creator, Internal Linker, Keyword Mapper.

Key agents: `content-analyzer.md`, `seo-optimizer.md`, `meta-creator.md`, `internal-linker.md`, `keyword-mapper.md`, `editor.md`, `headline-generator.md`, `cro-analyst.md`, `performance.md`, `cluster-strategist.md`, `landing-page-optimizer.md`.

### Python Analysis Pipeline

Located in `data_sources/modules/`. The Content Analyzer chains:
1. `search_intent_analyzer.py` - Query intent classification
2. `keyword_analyzer.py` - Density, distribution, stuffing detection
3. `content_length_comparator.py` - Benchmarks against top 10 SERP results
4. `readability_scorer.py` - Flesch Reading Ease, grade level
5. `seo_quality_rater.py` - Comprehensive 0-100 SEO score

### Data Integrations

- `google_analytics.py` - GA4 traffic/engagement data
- `google_search_console.py` - Rankings and impressions
- `dataforseo.py` - SERP positions, keyword metrics
- `data_aggregator.py` - Combines all sources into unified analytics
- `wordpress_publisher.py` - Publishes to WordPress with Yoast SEO metadata

### Opportunity Scoring

`opportunity_scorer.py` uses 8 weighted factors: Volume (25%), Position (20%), Intent (20%), Competition (15%), Cluster (10%), CTR (5%), Freshness (5%), Trend (5%).

## Running Python Scripts

```bash
# Research & analysis scripts (run from repo root)
python3 research_quick_wins.py
python3 research_competitor_gaps.py
python3 research_performance_matrix.py
python3 research_priorities_comprehensive.py
python3 research_serp_analysis.py
python3 research_topic_clusters.py
python3 research_trending.py
python3 seo_baseline_analysis.py
python3 seo_bofu_rankings.py
python3 seo_competitor_analysis.py

# Test API connectivity
python3 test_dataforseo.py
```

## Content Pipeline

`topics/` (ideas) → `research/` (briefs) → `drafts/` (articles) → `review-required/` (pending review) → `published/` (final)

Rewrites go to `rewrites/`. Landing pages go to `landing-pages/`. Audits go to `audits/`. Repurposed content goes to `repurposed/`.

## Context Files (Active Project)

`context/` contains brand guidelines for the currently active project. Switch projects with `/use-project`.

- `config.md` - Project metadata (domain, CMS, analytics IDs, publishing endpoint)
- `brand-voice.md` - Tone, messaging pillars
- `style-guide.md` - Grammar, formatting standards
- `seo-guidelines.md` - Keyword and structure rules
- `internal-links-map.md` - Key pages for internal linking
- `features.md` - Product/service features & benefits
- `competitor-analysis.md` - Competitive intelligence
- `target-keywords.md` - Primary and secondary keyword targets
- `cro-best-practices.md` - Conversion optimization guidelines
- `ai-citation-targets.md` - Platforms where brand should be cited by AI
- `reddit-strategy.md` - Reddit engagement strategy
- `writing-examples.md` - Voice examples and style references

## Multi-Project File Structure

```
projects/
  _shared/          ← Universal SEO/style guidelines (used as fallback)
  leadcognition/    ← B2B SaaS: developer signal intelligence
  fruitfulcode/     ← Dev agency: custom web/mobile development
  stormlookup/      ← Property SaaS: storm damage assessment
  shewell-care/     ← Women's health clinic (UK)
  olvia/            ← AI product (context TODO)
  petrenko-cv/      ← Personal CV/portfolio
  stackpass/        ← SaaS product (context TODO)
context/            ← ACTIVE project (populated by /use-project)
```

## WordPress Integration

Publishing uses the WordPress REST API with a custom MU-plugin (`wordpress/seo-machine-yoast-rest.php`) that exposes Yoast SEO fields. Articles are published in WordPress block format (HTML comments in Markdown files).

## Syncing with Upstream

```bash
git fetch upstream
git merge upstream/main
```
