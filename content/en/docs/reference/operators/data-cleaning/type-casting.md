---
title: "Type Casting"
description: "Cast between types"
category: "Data Cleaning"
operator_type: "TypeCasting"
version: "N/A"
tags: [data-cleaning]
---

[Home](../../) > [Data Cleaning](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| TypeCasting Units | ✓ | List<Unit> | - | Multiple type castings |
| ↳ Attribute | ✓ | Column | - | Attribute for type casting |
| ↳ Cast type | ✓ | `string`, `integer`, `long`, `double`<br>`boolean`, `timestamp`, `binary`<br>`large_binary` | - | Result type after type casting |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
