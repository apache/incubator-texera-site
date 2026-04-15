---
title: "Contour Plot"
description: "Displays terrain or gradient variations in a Contour Plot"
category: "Scientific"
operator_type: "ContourPlot"
version: "N/A"
tags: [visualization, scientific]
---

[Home](../../../) > [Visualization](../../) > [Scientific](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Grid Size |  | String | 10 | Grid resolution of the final image |
| Connect Gaps |  | Boolean | true | Automatically fill in the missing parts |
| x | ✓ | Column | - | The column name of X-axis |
| y | ✓ | Column | - | The column name of Y-axis |
| z | ✓ | Column | - | The column name of color bar |
| Coloring Method |  | `heatmap`, `lines`, `none` | heatmap |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
