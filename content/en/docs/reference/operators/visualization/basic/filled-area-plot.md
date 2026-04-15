---
title: "Filled Area Plot"
description: "Visualize data in filled area plot"
category: "Basic"
operator_type: "FilledAreaPlot"
tags: [visualization, basic]
---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| X-axis Attribute | ✓ | Column | - | The attribute for your x-axis |
| Y-axis Attribute | ✓ | Column | - | The attribute for your y-axis |
| Line Group |  | Column | - | The attribute for group of each line |
| Color |  | Column | - | Choose an attribute to color the plot |
| Split Plot by  Line Group | ✓ | Boolean | `false` | Do you want to split the graph |
| Pattern |  | Column | - | Add texture to the chart based on an attribute |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
