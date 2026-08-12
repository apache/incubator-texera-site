#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with this
# work for additional information regarding copyright ownership.  The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.
#
# ---------------------------------------------------------------------------
# Sync versioned documentation from the apache/texera source repository.
#
# The website no longer stores documentation in-tree. Instead, each published
# version of the docs lives on a release branch of the texera code repo, under
# its `docs/` folder. This script pulls the `docs/` folder from each configured
# release branch into a matching version folder under `content/docs/` so that
# Hugo can build them.
#
# It is run by CI (see .github/workflows/publish-site.yml) before `hugo`, and
# can also be run locally to preview the docs (`bash scripts/sync-docs.sh`).
# ---------------------------------------------------------------------------

set -euo pipefail

# --- Configuration ---------------------------------------------------------

# Source repository that owns the documentation.
DOCS_REPO="${DOCS_REPO:-https://github.com/apache/texera.git}"

# Folder inside the source repo that holds the docs.
DOCS_SUBDIR="${DOCS_SUBDIR:-docs}"

# Where versioned docs are written in this repo.
DEST_ROOT="${DEST_ROOT:-content/docs}"

# Mapping of "<source-ref>:<version-folder>". The ref may be a branch (tracks
# its tip) or a tag (frozen snapshot); git clone --branch accepts both. To add
# a version, add an entry (and bump params.docs_version in hugo.toml).
VERSIONS=(
  "release/v1.1:v1.1.0"
  "release/v1.2:v1.2.0"
)

# --- Helpers ---------------------------------------------------------------

# Resolve to the repository root (parent of this script's scripts/ dir) so the
# script works regardless of the current working directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

log() { printf '\033[1;34m[sync-docs]\033[0m %s\n' "$*"; }

# Post-process a pulled version folder so Hugo can build it correctly:
#
#   1. Frontmatter fix: the source docs prepend the ASF license as an HTML
#      comment ABOVE the frontmatter. Hugo only recognizes frontmatter at the
#      very start of a file, so as-is every page loses its title/weight/etc
#      (which blanks out the sidebar). We move the frontmatter back above the
#      license comment.
#   2. Version label: the version's own _index.md is given a linkTitle of the
#      version plus "Docs" (e.g. "v1.2.0 Docs") so the top sidebar/section node
#      names both the release and that it is documentation.
#   3. Link relabel: root-relative site links such as `/docs/getting-started/`
#      are prefixed with the version (`/docs/v1.2.0/getting-started/`), and any
#      legacy `/docs/latest/` is normalized first. External URLs such as
#      `https://docs.aws.amazon.com/...` are left untouched.
process_docs() {
  local ver="$1" dir="$2"
  DOCS_VER="$ver" DOCS_DIR="$dir" python3 - <<'PY'
import os, re

ver = os.environ["DOCS_VER"]
root = os.path.normpath(os.environ["DOCS_DIR"])

# Leading HTML comment followed by a frontmatter block.
lead_comment = re.compile(r'^\ufeff?\s*(<!--.*?-->)\s*(---\r?\n.*?\r?\n---)(.*)$', re.S)

for dirpath, _dirs, files in os.walk(root):
    for name in files:
        if not name.endswith((".md", ".html")):
            continue
        path = os.path.join(dirpath, name)
        with open(path, encoding="utf-8") as fh:
            text = fh.read()
        original = text

        # 1) Move a leading license comment to below the frontmatter.
        m = lead_comment.match(text)
        if m:
            comment, front, body = m.group(1), m.group(2), m.group(3)
            text = front + "\n\n" + comment + body

        # 2) Label the version's own section index with the version string.
        is_version_index = (
            os.path.normpath(dirpath) == root and name == "_index.md"
        )
        if is_version_index and text.startswith("---\n"):
            head = text[: text.find("\n---", 4)]
            if "linktitle" not in head.lower():
                text = '---\nlinkTitle: "%s Docs"\n' % ver + text[len("---\n"):]

        # 3) Relabel root-relative /docs/ links to the versioned path.
        text = text.replace("/docs/latest/", "/docs/")
        text = text.replace("](/docs/", "](/docs/%s/" % ver)
        text = text.replace('href="/docs/', 'href="/docs/%s/' % ver)
        text = text.replace("href='/docs/", "href='/docs/%s/" % ver)

        if text != original:
            with open(path, "w", encoding="utf-8") as fh:
                fh.write(text)
PY
}

# --- Main ------------------------------------------------------------------

for entry in "${VERSIONS[@]}"; do
  ref="${entry%%:*}"
  version="${entry##*:}"

  dest="${DEST_ROOT}/${version}"
  log "Syncing ${DOCS_REPO} (${ref}:${DOCS_SUBDIR}) into ${dest}"

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  # Sparse, blobless, shallow clone of just the docs folder to keep the fetch
  # small. --branch accepts a branch or a tag.
  git clone --quiet --depth 1 --branch "$ref" \
    --filter=blob:none --sparse "$DOCS_REPO" "$tmpdir/repo"
  git -C "$tmpdir/repo" sparse-checkout set "$DOCS_SUBDIR" >/dev/null

  src="$tmpdir/repo/${DOCS_SUBDIR}"
  if [ ! -d "$src" ]; then
    log "WARNING: ${DOCS_SUBDIR}/ not found on ${ref}; writing empty version folder"
    rm -rf "$dest"
    mkdir -p "$dest"
  else
    rm -rf "$dest"
    mkdir -p "$dest"
    # Copy docs contents (excluding VCS metadata) into the version folder.
    cp -R "$src/." "$dest/"
  fi

  process_docs "$version" "$dest"
  log "Wrote $(find "$dest" -type f | wc -l | tr -d ' ') file(s) into ${dest}"

  rm -rf "$tmpdir"
  trap - EXIT
done

# Note: content/docs/_index.md is a tracked landing page (type: docs-home) that
# lists the version folders created above; it is intentionally NOT generated
# here.

log "Done."
