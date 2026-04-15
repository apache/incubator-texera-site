---
title: "Dictionary matcher"
description: "Matches tuples if they appear in a given dictionary"
category: "Search"
operator_type: "DictionaryMatcher"
version: "N/A"
tags: [search]
---

[Home](../../) > [Search](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Dictionary | ✓ | String | - | Dictionary values separated by a comma |
| Attribute | ✓ | Column | - | Column name to match |
| Result Attribute | ✓ | String | matched | Column name of the matching result |
| Matching Type | ✓ | `Scan`, `Substring`, `Conjunction` | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
