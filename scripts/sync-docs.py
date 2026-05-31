#!/usr/bin/env python3
"""Regenerate the Hugo docs section from the apache/texera ``docs/`` folder.

apache/texera is the single source of truth for documentation content
(see apache/texera#5001). The source ``docs/`` tree holds clean Markdown with
no website-specific front matter. This script copies that tree into
``content/docs/latest`` and layers back the Hugo artifacts the website needs:

* a per-page ``aliases`` entry so the un-versioned ``/docs/<path>/`` URLs (and
  the in-page ``/docs/...`` links authored in the source) keep resolving to the
  versioned ``/docs/latest/<path>/`` location, and
* ``linkTitle`` plus the main-menu entry on the section's root ``_index.md`` so
  "Docs" still appears in the site navigation.

The mapping is deterministic, so running this repeatedly is idempotent.

Usage:
    sync-docs.py <source-docs-dir> <dest-dir>
e.g. sync-docs.py texera-src/docs content/docs/latest
"""

import shutil
import sys
from pathlib import Path

# Injected verbatim into the section's root _index.md so "Docs" stays in the nav.
ROOT_INDEX_EXTRA = ["linkTitle: Docs", "menu: {main: {weight: 45}}"]


def alias_for(rel: Path) -> str | None:
    """Return the un-versioned /docs alias for a source-relative Markdown path.

    ``reference/_index.md``       -> ``/docs/reference/``
    ``reference/storage.md``      -> ``/docs/reference/storage/``
    ``_index.md`` (section root)  -> ``None`` (handled via menu/linkTitle)
    """
    if rel.name == "_index.md":
        parent = rel.parent.as_posix()
        if parent == ".":
            return None
        return f"/docs/{parent}/"
    stem = rel.with_suffix("").as_posix()
    return f"/docs/{stem}/"


def split_front_matter(text: str) -> tuple[list[str], str] | None:
    """Split ``text`` into (front-matter lines, remainder) or None if absent."""
    if not text.startswith("---\n"):
        return None
    lines = text.split("\n")
    for i in range(1, len(lines)):
        if lines[i] == "---":
            return lines[1:i], "\n".join(lines[i:])
    return None


def transform_markdown(text: str, rel: Path) -> str:
    parts = split_front_matter(text)
    is_root_index = rel.name == "_index.md" and rel.parent.as_posix() == "."
    alias = alias_for(rel)

    if parts is None:
        # No front matter in the source; synthesize a minimal block.
        fm: list[str] = []
        body = ""
    else:
        fm, rest = parts
        # ``rest`` still starts with the closing ``---``; drop it.
        body = rest[len("---"):]

    if is_root_index:
        # "Docs" must stay in the main nav: inject the nav keys right after the
        # title, and point the section links at the versioned /docs/latest tree.
        existing_keys = {ln.split(":", 1)[0].strip() for ln in fm if ":" in ln}
        nav = [e for e in ROOT_INDEX_EXTRA
               if e.split(":", 1)[0].strip() not in existing_keys]
        title_idx = next((i for i, ln in enumerate(fm)
                          if ln.startswith("title:")), len(fm) - 1)
        new_fm = fm[:title_idx + 1] + nav + fm[title_idx + 1:]
        body = body.replace("](/docs/", "](/docs/latest/")
    elif alias and not any(ln.strip() == "aliases:" for ln in fm):
        # Trailing "" reproduces the blank line the site keeps before ``---``.
        new_fm = fm + ["aliases:", f"  - {alias}", ""]
    else:
        new_fm = fm

    return "---\n" + "\n".join(new_fm) + "\n---" + body


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])
    if not src.is_dir():
        print(f"source docs dir not found: {src}", file=sys.stderr)
        return 1

    # Rebuild the destination from scratch so deletions in the source propagate.
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True)

    count = 0
    for path in sorted(src.rglob("*")):
        if path.is_dir():
            continue
        rel = path.relative_to(src)
        out = dst / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        if path.suffix == ".md":
            out.write_text(transform_markdown(path.read_text(encoding="utf-8"), rel),
                           encoding="utf-8")
        else:
            shutil.copy2(path, out)
        count += 1

    print(f"Synced {count} files into {dst}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
