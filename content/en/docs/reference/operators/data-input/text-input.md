---
title: "Text Input"
description: "Source data from manually inputted text"
category: "Data Input"
operator_type: "TextInput"
version: "N/A"
tags: [data-input]
---

[Home](../../) > [Data Input](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Text | ✓ | String | - |  |
| Attribute Type | ✓ | `string`, `single string`, `integer`<br>`long`, `double`, `boolean`, `timestamp`<br>`binary`, `large binary` | string |  |
| Attribute Name | ✓ | String | line |  |
| Limit |  | Integer | - |  |
| Offset |  | Integer | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
