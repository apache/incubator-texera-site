#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pull docs from apache/texera's release/vX.Y branches and lay them out for
# Hugo. The highest release/vX.Y that actually carries docs becomes the
# "latest" (content/docs/latest, canonical /docs/... URLs, aliases injected);
# every older release with docs is archived under content/docs/v<maj>-<min>/.
# apache/texera is public, so no token is needed.

set -euo pipefail

REPO="${TEXERA_REPO:-https://github.com/apache/texera.git}"
CONTENT_DOCS="${CONTENT_DOCS:-content/docs}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# List release/vX.Y branches (two-component only; ignore release/v1.1.0-... etc.),
# sorted ascending by version. Last = highest = latest.
mapfile -t BRANCHES < <(
  git ls-remote --heads "$REPO" 'refs/heads/release/v*' \
    | sed -E 's#.*refs/heads/(release/v[0-9]+\.[0-9]+)$#\1#' \
    | grep -E '^release/v[0-9]+\.[0-9]+$' \
    | sort -t. -k1,1V
)

if [[ ${#BRANCHES[@]} -eq 0 ]]; then
  echo "error: no release/vX.Y branches found on $REPO" >&2
  exit 1
fi

latest_branch="${BRANCHES[-1]}"
echo "Release branches found: ${BRANCHES[*]}"
echo "Latest = ${latest_branch}"

pull_branch() {  # <branch> <target_dir> <alias_flag>
  local branch="$1" target="$2" alias_flag="$3"
  local dir="$WORK/${branch//\//_}"
  # Shallow, blobless, sparse checkout of just docs/.
  git clone --quiet --depth 1 --filter=blob:none --sparse --branch "$branch" "$REPO" "$dir"
  ( cd "$dir" && git sparse-checkout set docs >/dev/null 2>&1 )
  if [[ ! -d "$dir/docs" ]] || [[ -z "$(find "$dir/docs" -name '*.md' -print -quit)" ]]; then
    echo "  ${branch}: no docs/*.md - skipping"
    return 1
  fi
  python3 "$SCRIPT_DIR/sync-docs.py" "$dir/docs" "$target" $alias_flag
  return 0
}

published_latest=false
for branch in "${BRANCHES[@]}"; do
  if [[ "$branch" == "$latest_branch" ]]; then
    echo "==> ${branch} -> ${CONTENT_DOCS}/latest (latest)"
    if pull_branch "$branch" "${CONTENT_DOCS}/latest" "--aliases"; then
      published_latest=true
    fi
  else
    ver="${branch#release/v}"          # e.g. 1.1
    slug="v${ver//./-}"                # e.g. v1-1
    echo "==> ${branch} -> ${CONTENT_DOCS}/${slug} (archived)"
    pull_branch "$branch" "${CONTENT_DOCS}/${slug}" "" || true
  fi
done

if [[ "$published_latest" != true ]]; then
  echo "error: latest branch ${latest_branch} produced no docs" >&2
  exit 1
fi
echo "Done."
