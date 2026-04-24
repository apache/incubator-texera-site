---
title: "Continuous Error Bands"
description: "Visualize error or uncertainty along a continuous line"
category: "Statistical"
operator_type: "ContinuousErrorBands"
tags: [visualization, statistical]
---

[Home](../../../) > [Visualization](../../) > [Statistical](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| X Label |  | String | X Axis | Label used for x axis |
| Y Label |  | String | Y Axis | Label used for y axis |
| Bands | ✓ | List<Band> | - |  |
| ↳ Y-Axis Upper Bound | ✓ | Column | - | Represents upper bound error of y-values |
| ↳ Y-Axis Lower Bound | ✓ | Column | - | Represents lower bound error of y-values |
| ↳ Fill Color |  | String | - | Must be a valid CSS color or hex color string |
| ↳ Y Value | ✓ | Column | - | Value for y axis |
| ↳ X Value | ✓ | Column | - | Value for x axis |
| ↳ Line Mode | ✓ | line, dots, line with dots | line with dots |  |
| ↳ Line Name |  | String | - |  |
| ↳ Line Color |  | String | - | Must be a valid CSS color or hex color string |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
