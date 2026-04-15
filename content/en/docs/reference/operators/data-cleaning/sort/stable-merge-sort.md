---
title: "Stable Merge Sort"
description: "Stable per-partition sort with multi-key ordering (incremental stack of sorted buckets)"
category: "Sort"
operator_type: "StableMergeSort"
tags: [data-cleaning, sort]
---

[Home](../../../) > [Data Cleaning](../../) > [Sort](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Sort Keys | ✓ | List<Sort Criteria Unit> | - | List of attributes to sort by with ordering<br>preferences |
| ↳ Sort Preference | ✓ | `ASC`, `DESC` | - | Sort preference (ASC or DESC) |
| ↳ Attribute | ✓ | Column | - | Attribute name to sort by |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../../output-modes/#set-snapshot) |
