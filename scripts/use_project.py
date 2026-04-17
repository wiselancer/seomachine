#!/usr/bin/env python3
"""Activate a project by copying its context files into ./context."""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
PROJECTS_DIR = REPO_ROOT / "projects"
CONTEXT_DIR = REPO_ROOT / "context"
SHARED_SEO_GUIDELINES = PROJECTS_DIR / "_shared" / "seo-guidelines.md"
PROJECT_DISPLAY_ORDER = [
    "leadcognition",
    "fruitfulcode",
    "stormlookup",
    "shewell-care",
    "petrenko-cv",
    "olvia",
    "stackpass",
]


def available_projects() -> list[str]:
    discovered = {
        path.name
        for path in PROJECTS_DIR.iterdir()
        if path.is_dir() and not path.name.startswith("_")
    }
    ordered = [slug for slug in PROJECT_DISPLAY_ORDER if slug in discovered]
    extras = sorted(discovered - set(PROJECT_DISPLAY_ORDER))
    return ordered + extras


def parse_config_summary(config_path: Path) -> list[str]:
    if not config_path.exists():
        return ["No config summary available."]

    values = extract_config_values(config_path.read_text(encoding="utf-8"))

    summary = []
    project = values.get("Project")
    domain = values.get("Domain")
    project_type = values.get("Type")
    audience = values.get("Primary")

    if project or domain or project_type:
        sentence = " ".join(
            part
            for part in [
                f"{project}" if project else "",
                f"({domain})" if domain else "",
                f"is a {project_type}." if project_type else "",
            ]
            if part
        )
        if sentence:
            summary.append(sentence)

    if audience:
        summary.append(f"Primary audience: {audience}.")

    cms = values.get("Blog CMS")
    publishing = values.get("WordPress endpoint")
    if cms or publishing:
        summary.append(
            "Publishing setup: "
            + ", ".join(
                part
                for part in [
                    f"blog CMS {cms}" if cms else "",
                    f"WordPress endpoint {publishing}" if publishing else "",
                ]
                if part
            )
            + "."
        )

    return summary or ["No config summary available."]


def synced_docs(project_dir: Path) -> list[Path]:
    synced_dir = project_dir / "_synced"
    if not synced_dir.exists():
        return []

    return sorted(path for path in synced_dir.rglob("*") if path.is_file())


def extract_config_values(project_config: str) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in project_config.splitlines():
        if not line.startswith("- **"):
            continue
        try:
            key, value = line[2:].split("**:", 1)
        except ValueError:
            continue
        values[key.strip("* ")] = value.strip()
    return values


def build_context_config(slug: str, project_config: str) -> str:
    values = extract_config_values(project_config)
    project_name = values.get("Project", slug)
    domain = values.get("Domain")
    configured_for = f"**{project_name}**"
    if domain:
        configured_for += f" ({domain})"
    available = ", ".join(available_projects())
    normalized_config = project_config.lstrip()
    if normalized_config.startswith("# "):
        normalized_config = "## " + normalized_config[2:]
    return (
        f"# Active Project: {project_name}\n\n"
        f"This context directory is currently configured for: {configured_for}\n\n"
        "Switch projects with: `/use-project <slug>`\n\n"
        f"Available: {available}\n\n"
        "---\n\n"
        f"{normalized_config}"
    )


def activate_project(slug: str) -> int:
    project_dir = PROJECTS_DIR / slug
    if not project_dir.exists() or not project_dir.is_dir():
        print(f"Unknown project: {slug}", file=sys.stderr)
        print("Available projects:", ", ".join(available_projects()), file=sys.stderr)
        return 1

    CONTEXT_DIR.mkdir(exist_ok=True)

    copied: list[str] = []
    for path in sorted(project_dir.iterdir()):
        if path.name in {"_synced", "SOURCES.md"} or path.is_dir():
            continue
        destination = CONTEXT_DIR / path.name
        if path.name == "config.md":
            project_config = path.read_text(encoding="utf-8")
            destination.write_text(build_context_config(slug, project_config), encoding="utf-8")
        else:
            shutil.copy2(path, destination)
        copied.append(path.name)

    if not (project_dir / "seo-guidelines.md").exists() and SHARED_SEO_GUIDELINES.exists():
        shutil.copy2(SHARED_SEO_GUIDELINES, CONTEXT_DIR / "seo-guidelines.md")
        if "seo-guidelines.md" not in copied:
            copied.append("seo-guidelines.md")

    config_path = project_dir / "config.md"
    summary = parse_config_summary(config_path)
    synced = synced_docs(project_dir)

    print(f"Active project: {slug}")
    print("")
    print("Loaded into context/:")
    for name in copied:
        print(f"- {name}")

    if synced:
        print("")
        print("Synced from upstream product repo:")
        for path in synced:
            print(f"- {path.relative_to(REPO_ROOT)}")

    print("")
    print("Project overview:")
    for sentence in summary[:3]:
        print(f"- {sentence}")

    return 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Activate a SEO Machine project for Codex by syncing it into ./context."
    )
    parser.add_argument("slug", nargs="?", help="Project slug to activate")
    parser.add_argument(
        "--list",
        action="store_true",
        help="List available projects and exit",
    )
    args = parser.parse_args()

    if args.list:
        for slug in available_projects():
            print(slug)
        return 0

    if not args.slug:
        parser.error("the following arguments are required: slug")

    return activate_project(args.slug)


if __name__ == "__main__":
    raise SystemExit(main())
