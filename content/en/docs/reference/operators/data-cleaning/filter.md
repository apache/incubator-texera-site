---
title: "Filter"
description: "Performs a filter operation using OR between multiple predicates"
category: "Data Cleaning"
operator_type: "Filter"
version: "N/A"
tags: [data-cleaning]
---

[Home](../../) > [Data Cleaning](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Predicates | ✓ | List<Filter Predicate> | - | Multiple predicates in OR |
| ↳ Attribute | ✓ | Column | - |  |
| ↳ Condition | ✓ | `=`, `>`, `>=`, `<`, `<=`, `!=`<br>`is null`, `is not null` | - |  |
| ↳ Value |  | String | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
