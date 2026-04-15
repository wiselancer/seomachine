#!/usr/bin/env bash
# Pull canonical product docs from wiselancer/leadcognition_v2 into
# projects/leadcognition/_synced/. Safe to re-run; overwrites files.
#
# Auth: prefers `gh auth` if logged in, otherwise falls back to the
# GITHUB_TOKEN env var. Exits 0 on any transient failure so the
# container entrypoint can keep going.
#
# Usage: ./scripts/sync-product-docs.sh

set -u
set -o pipefail

REPO="${SEO_MACHINE_PRODUCT_REPO:-wiselancer/leadcognition_v2}"
BRANCH="${SEO_MACHINE_PRODUCT_BRANCH:-main}"

# Always anchor at the repo root (works whether invoked from anywhere).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_DIR="$REPO_ROOT/projects/leadcognition/_synced"
mkdir -p "$DEST_DIR"

# Files (repo-relative) we want pulled verbatim.
FILES=(
  "docs/UNIFIED-SEO-STRATEGY.md"
  "docs/BRAND.md"
  "docs/gtm-strategy.md"
  "docs/gtm/free-tools-strategy-2026-04.md"
  "docs/research/seo-technical-audit.md"
  "docs/research/traffic-acquisition-plan.md"
  "docs/research/geo-aeo-aio-optimization.md"
  "docs/research/icp-and-ux-research.md"
)

# Directories (repo-relative) we want mirrored — just the listed globs.
# Pairs of "src_dir:glob".
DIR_GLOBS=(
  "docs/competitors:*.yaml"
  "docs/gtm:*.md"
)

ok=0
fail=0
failures=()

fetch_via_gh_api() {
  local path="$1"
  local out="$2"
  mkdir -p "$(dirname "$out")"
  if gh api "repos/$REPO/contents/$path?ref=$BRANCH" \
       --jq '.content' 2>/dev/null \
     | base64 -d > "$out" 2>/dev/null && [ -s "$out" ]; then
    return 0
  fi
  return 1
}

fetch_via_curl() {
  local path="$1"
  local out="$2"
  local url="https://raw.githubusercontent.com/$REPO/$BRANCH/$path"
  mkdir -p "$(dirname "$out")"
  local auth=()
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
  fi
  if curl -fsSL "${auth[@]}" "$url" -o "$out" 2>/dev/null && [ -s "$out" ]; then
    return 0
  fi
  return 1
}

fetch_file() {
  local path="$1"
  local out="$DEST_DIR/$path"

  # Try gh first (uses gh auth), then curl + optional token.
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if fetch_via_gh_api "$path" "$out"; then
      ok=$((ok + 1))
      echo "  sync: $path"
      return 0
    fi
  fi
  if fetch_via_curl "$path" "$out"; then
    ok=$((ok + 1))
    echo "  sync: $path"
    return 0
  fi
  fail=$((fail + 1))
  failures+=("$path")
  echo "  MISS: $path" >&2
  return 1
}

list_dir_via_gh() {
  local dir="$1"
  gh api "repos/$REPO/contents/$dir?ref=$BRANCH" \
    --jq '.[] | select(.type=="file") | .path' 2>/dev/null
}

echo "Syncing canonical product docs from $REPO@$BRANCH → $DEST_DIR"

# Plain file pulls
for f in "${FILES[@]}"; do
  fetch_file "$f" || true
done

# Directory globs — enumerate via gh api when possible, else skip quietly.
for pair in "${DIR_GLOBS[@]}"; do
  src_dir="${pair%%:*}"
  glob="${pair##*:}"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    while IFS= read -r p; do
      [ -z "$p" ] && continue
      case "$p" in
        $src_dir/$glob) fetch_file "$p" || true ;;
      esac
    done < <(list_dir_via_gh "$src_dir")
  else
    echo "  skip (no gh auth): $src_dir/$glob" >&2
  fi
done

# Stamp a manifest so it's obvious what was pulled and when.
{
  echo "# Synced from $REPO@$BRANCH"
  echo "# Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# OK=$ok  FAIL=$fail"
  if [ "$fail" -gt 0 ]; then
    echo "# Missing:"
    for m in "${failures[@]}"; do echo "#   - $m"; done
  fi
} > "$DEST_DIR/.sync-manifest"

echo "Done. synced=$ok failed=$fail (details → $DEST_DIR/.sync-manifest)"
exit 0
