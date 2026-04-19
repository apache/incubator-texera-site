---
title: " File Scan"
description: "Scan data from a  file"
category: "Data Input"
operator_type: "FileScan"
tags: [data-input]
weight: 50
---

[Home](../../) > [Data Input](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| File | ✓ | String | - |  |
| Encoding | ✓ | `UTF_8`, `UTF_16`, `US_ASCII` | UTF_8 |  |
| Extract |  | Boolean | false |  |
| Include Filename |  | Boolean | false |  |
| Limit |  | Integer | - |  |
| Offset |  | Integer | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
