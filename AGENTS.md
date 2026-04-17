# AGENTS.md

This repository was originally structured for Claude Code, but Codex should treat it as a first-class workspace rather than a compatibility fallback.

## Core Operating Model

- The source of truth for project-specific context lives in `projects/<slug>/`.
- The active working context lives in `context/`.
- `context/` is generated runtime state. Permanent edits belong in `projects/<slug>/`.
- Before doing any content work for a specific brand, activate the project with:

```bash
python3 scripts/use_project.py <slug>
```

- If the user does not specify a project and the task depends on brand voice, product positioning, or internal links, check `context/config.md` and confirm which project is active before writing.

## How Codex Should Reuse Claude Assets

The `.claude/` directory is still highly useful. Treat it as a library of operating procedures:

- `.claude/commands/*.md` are workflow specs and output contracts.
- `.claude/agents/*.md` are specialist review checklists.
- `.claude/skills/*/SKILL.md` are domain playbooks that can inform SEO, CRO, and marketing work.

Codex does **not** execute Claude slash commands directly. Instead:

1. Map the user's request to the closest file in `.claude/commands/`.
2. Read that file before doing substantial work.
3. Use it as a checklist for process, deliverables, file naming, and quality bars.
4. When helpful, also read the relevant specialist files in `.claude/agents/` and apply their review criteria during drafting or QA.

Examples:

- "Switch to LeadCognition" -> `python3 scripts/use_project.py leadcognition`
- "Research topic X" -> `.claude/commands/research.md`
- "Write article about X" -> `.claude/commands/write.md`
- "Optimize this draft" -> `.claude/commands/optimize.md` plus `.claude/agents/seo-optimizer.md`
- "Analyze a landing page" -> `.claude/commands/landing-audit.md` plus `.claude/agents/landing-page-optimizer.md`

## Preferred Codex Workflow

1. Activate the right project with `scripts/use_project.py`.
2. Read `context/config.md` plus any context files relevant to the task.
3. Read the matching `.claude/commands/*.md` file.
4. Execute the work directly in the repo using normal Codex file edits and shell commands.
5. Save outputs to the same directories expected by the original workflow:
   - `research/`
   - `drafts/`
   - `rewrites/`
   - `published/`
6. If the task is a quality pass, also apply the matching `.claude/agents/*.md` checklist before finishing.

## Repo-Specific Guidance

- `scripts/use_project.py` is the Codex-native replacement for `/use-project`.
- `context/` is intentionally disposable and should not be treated as committed source-of-truth content.
- `scripts/sync-product-docs.sh` refreshes authoritative LeadCognition docs into `projects/leadcognition/_synced/`.
- Python research and SEO analysis entry points live at the repo root and in `data_sources/modules/`.
- Publishing assumptions come from the active `context/config.md`. Do not assume WordPress is available for every project.

## Quality Bar

Codex should aim to be at least as effective as the original Claude workflow by combining:

- the repo's existing command/agent playbooks,
- direct file/script execution,
- stronger repo-wide reasoning across multiple docs and scripts,
- explicit verification after edits.

When the Claude docs and the live repo disagree, prefer the live repo and note the mismatch.
