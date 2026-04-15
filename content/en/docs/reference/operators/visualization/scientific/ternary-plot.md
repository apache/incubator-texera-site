---
title: "Ternary Plot"
description: "Points are graphed on a Ternary Plot using 3 specified data fields"
category: "Scientific"
operator_type: "TernaryPlot"
version: "N/A"
tags: [visualization, scientific]
---

[Home](../../../) > [Visualization](../../) > [Scientific](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Variable 1 | ✓ | Column | - | First variable data field |
| Variable 2 | ✓ | Column | - | Second variable data field |
| Variable 3 | ✓ | Column | - | Third variable data field |
| Categorize by Color |  | Boolean | false | Optionally color points using a data field |
| Color Data Field |  | Column | - | Specify the data field to color |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
