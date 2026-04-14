# Linear Marketing Workspace — Import Plan

This document defines the Linear setup for marketing/SEO work across all wiselancer projects (LeadCognition, FruitfulCode, StormLookup, ShewellCare, Olvia, PetrenkoCV, StackPass).

To apply: once Linear MCP tools are available in this Claude Code session (after `/restart`), run `/use-project` then ask Claude to "import the Linear marketing setup from MARKETING-LINEAR-IMPORT.md". Or apply manually via the Linear web UI using this as a checklist.

---

## Team

**Name**: Marketing
**Identifier**: `MKT`
**Description**: SEO, content, and growth work across all wiselancer projects.
**Icon**: chart-line (or pick anything)

### Workflow states (default Linear set is fine, with these tweaks)

| State | Type | Notes |
|-------|------|-------|
| Backlog | backlog | Idea/topic, not yet researched |
| Researched | unstarted | Brief written, ready to write |
| Writing | started | Draft in progress |
| Review | started | In review-required/, awaiting human edit |
| Optimizing | started | SEO/optimization passes running |
| Ready to Publish | started | Approved, queued for publish |
| Published | completed | Live |
| Cancelled | cancelled | Killed — explain why in comment |

### Labels

Create as team labels:

- `project/leadcognition`
- `project/fruitfulcode`
- `project/stormlookup`
- `project/shewellcare`
- `project/olvia`
- `project/petrenko-cv`
- `project/stackpass`
- `type/blog-post`
- `type/landing-page`
- `type/comparison`
- `type/alternative-page`
- `type/pillar`
- `type/repurpose`
- `funnel/tofu`
- `funnel/mofu`
- `funnel/bofu`
- `priority/p0` `priority/p1` `priority/p2`

---

## Projects

One Linear project per business. Use the URL/handle of the live property.

| Project Name | Slug | Lead | Status |
|--------------|------|------|--------|
| LeadCognition SEO | leadcognition-seo | wiselancer | In Progress |
| FruitfulCode SEO | fruitfulcode-seo | wiselancer | In Progress |
| StormLookup SEO | stormlookup-seo | wiselancer | Planned |
| Shewell Care SEO | shewell-care-seo | wiselancer | Planned |
| Olvia SEO | olvia-seo | wiselancer | Backlog (no context yet) |
| Petrenko.cv | petrenko-cv | wiselancer | In Progress |
| Stackpass SEO | stackpass-seo | wiselancer | Backlog (no context yet) |

Each project should have a description pointing to:
- The product repo (if applicable)
- The live domain
- The `projects/<slug>/` folder in this SEO repo

---

## Cycles

Two-week cycles. Each cycle picks 1–2 projects to focus on; rotate so no project goes >2 cycles unattended.

---

## Starter Issues (LeadCognition project)

These are seeded from the refreshed `docs/UNIFIED-SEO-STRATEGY.md` Phase 5–8 roadmap. Adjust as needed after the doc-refresh PR (#126) is merged.

### Phase 5 — Fill missing alternative pages (P1)

1. **MKT-1**: Write `/onfire-alternative` landing page
   - Labels: `project/leadcognition`, `type/alternative-page`, `funnel/bofu`, `priority/p1`
   - Description: Tier-1 gap from SEO audit. Use existing alternative pages as template.

2. **MKT-2**: Audit `/koala-alternative` visible-FAQ-HTML gap
   - Labels: `project/leadcognition`, `type/alternative-page`, `priority/p1`
   - Description: Confirm whether FAQ rendering issue still exists; fix if so.

### Phase 6 — Warmly template upgrade (P1)

3. **MKT-3**: Upgrade alternative-page template based on Warmly's high-converting layout
   - Labels: `project/leadcognition`, `type/landing-page`, `priority/p1`
   - Description: Apply learnings from competitor analysis to all 12 alternative pages.

### Phase 7 — Programmatic SEO (P2)

4. **MKT-4**: Spec programmatic SEO using `sample-developers` endpoint
   - Labels: `project/leadcognition`, `type/landing-page`, `priority/p2`
   - Description: One page per common GitHub category (e.g., "developers who starred Next.js"). Auto-generated from API.

5. **MKT-5**: Build first 10 programmatic SEO pages as proof-of-concept
   - Blocked by: MKT-4
   - Labels: `project/leadcognition`, `type/landing-page`, `priority/p2`

### Phase 8 — Public Discover preview URLs (P2)

6. **MKT-6**: Make Discover preview-scan results shareable via public URL
   - Labels: `project/leadcognition`, `type/landing-page`, `priority/p2`
   - Description: Link to product team — needs backend support. SEO benefit: indexable result pages.

### Always-on / cluster work

7. **MKT-7**: Pillar — "Developer Outreach Playbook"
   - Labels: `project/leadcognition`, `type/pillar`, `funnel/tofu`, `priority/p1`
   - Description: 3,000+ word pillar. Anchor for the developer-outreach cluster.

8. **MKT-8**: Pillar — "What is GitHub Signal Intelligence"
   - Labels: `project/leadcognition`, `type/pillar`, `funnel/tofu`, `priority/p1`
   - Description: Anchors AI-citation strategy (see `context/ai-citation-targets.md`).

9. **MKT-9**: Repurpose top-performing blog posts to Medium + Dev.to
   - Labels: `project/leadcognition`, `type/repurpose`, `priority/p2`
   - Description: Use `/repurpose` command. Target high AI-citation surfaces.

10. **MKT-10**: Monthly AI-citation audit via `/research-ai-citations`
    - Labels: `project/leadcognition`, `priority/p2`
    - Description: Recurring — first Monday of each month. Track which prompts cite us.

### Infra / workflow

11. **MKT-11**: Wire openclaw container with auto-sync of leadcognition_v2 docs
    - Labels: `priority/p0`
    - Description: Tracks the containerization PR (Agent 2 output) + Coolify deploy.

12. **MKT-12**: Set up GA4 + GSC integration in SEO repo's `.env`
    - Labels: `project/leadcognition`, `priority/p0`
    - Description: Required before `/research-performance` works. See `data_sources/config/.env.example`.

---

## Starter Issues (cross-project / repo-level)

Filed under a "Workspace" project or kept teamless:

- **MKT-13**: Kill `context/cro-best-practices.md` (stale from prior project) — add LeadCognition-specific replacement
- **MKT-14**: Add `projects/leadcognition/social-proof.md` — pull G2/HN/Reddit quotes
- **MKT-15**: Add `projects/leadcognition/target-repos.md` — top 20 GitHub repos to use as concrete examples in content

---

## Workflow conventions

- **Title format**: `[type] short imperative` — e.g., `[blog-post] Write GitHub stars buying intent`
- **Branch link**: When work moves to Writing, attach the seomachine repo branch via Linear's GitHub integration
- **Done = Published**: An issue is only Done when the URL is live, not when the draft is approved
- **Recurring issues**: Use Linear's recurring-issue feature for monthly audits

---

## Integrations to enable

1. **GitHub**: Link `wiselancer/seomachine` and `wiselancer/leadcognition_v2` to the team. Auto-link branches/PRs to issues.
2. **Slack** (if used): Notify on state changes
3. **Claude Code MCP**: Already installed (`https://mcp.linear.app/mcp`). Tools surface after `/restart`.

---

## Notes

- This file is a one-shot import plan. Once applied, treat Linear as source of truth — don't keep this in sync.
- After import, this file can be deleted or moved to `archive/`.
