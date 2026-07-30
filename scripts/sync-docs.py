#!/usr/bin/env python3
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

# Mirror a texera docs/ tree into a Hugo content dir. Used at website build
# time to pull docs from apache/texera release branches, so nothing is
# committed to the site repo and it can never drift.
#
# Usage: sync-docs.py <source_docs> <target_dir> [--aliases]
#   --aliases  inject the pre-versioning "/docs/<page>/" alias into each page's
#              front matter. Pass this ONLY for the latest version (whose pages
#              own the canonical /docs/... URLs); archived versions live under
#              their own /docs/<ver>/... paths and get no aliases.

import pathlib
import shutil
import sys


def split_front_matter(text):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, text
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            return lines[1:i], "\n".join(lines[i + 1:])
    return None, text


def alias_for(rel):
    parts = list(rel.parts)
    if parts[-1] == "_index.md":
        parts = parts[:-1]
        if not parts:
            return None  # root _index keeps no alias (would collide with /docs/)
    else:
        parts[-1] = parts[-1][: -len(".md")]
    return "/docs/" + "/".join(parts) + "/"


def render_md(rel, text, inject_aliases):
    fm, body = split_front_matter(text)
    if fm is None:
        fm = []
    if inject_aliases:
        alias = alias_for(rel)
        if alias and not any(l.strip().startswith("aliases:") for l in fm):
            fm = fm + ["aliases:", f"  - {alias}", ""]
    body = body.lstrip("\n").rstrip()
    out = "---\n" + "\n".join(fm) + "\n---\n"
    if body:
        out += "\n" + body + "\n"
    return out


def main(argv):
    args = [a for a in argv if not a.startswith("--")]
    inject_aliases = "--aliases" in argv
    if len(args) != 2:
        print("usage: sync-docs.py <source_docs> <target_dir> [--aliases]", file=sys.stderr)
        return 2
    source, target = pathlib.Path(args[0]), pathlib.Path(args[1])
    if not source.is_dir():
        print(f"error: source dir not found: {source}", file=sys.stderr)
        return 2

    if target.exists():
        shutil.rmtree(target)
    target.mkdir(parents=True, exist_ok=True)

    count = 0
    for sfile in sorted(source.rglob("*")):
        if sfile.is_dir():
            continue
        rel = sfile.relative_to(source)
        tfile = target / rel
        tfile.parent.mkdir(parents=True, exist_ok=True)
        if sfile.suffix == ".md":
            tfile.write_text(render_md(rel, sfile.read_text(encoding="utf-8"), inject_aliases),
                             encoding="utf-8")
        else:
            tfile.write_bytes(sfile.read_bytes())
        count += 1
    print(f"  synced {count} files into {target} (aliases={'on' if inject_aliases else 'off'})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
