---
title: "Sort"
description: "Sort based on the columns and sorting methods"
category: "Sort"
operator_type: "Sort"
version: "N/A"
tags: [data-cleaning, sort]
---

[Home](../../../) > [Data Cleaning](../../) > [Sort](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Attributes | ✓ | List<Criteria Unit> | - | Column to perform sorting on |
| ↳ Sort Preference | ✓ | `ASC`, `DESC` | - | Sort preference (ASC or DESC) |
| ↳ Attribute | ✓ | Column | - | Attribute name to sort by |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../../output-modes/#set-snapshot) |
