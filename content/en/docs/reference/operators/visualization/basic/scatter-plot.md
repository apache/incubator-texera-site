---
title: "Scatter Plot"
description: "View the result in a scatterplot"
category: "Basic"
operator_type: "Scatterplot"
tags: [visualization, basic]
---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| X-Column | ✓ | Column (integer, double) | - | X Column |
| Y-Column | ✓ | Column (integer, double) | - | Y Column |
| Alpha Value |  | Double | 1.0 | Alpha (opacity) value from 0.0 (transparent) to<br>1.0 (opaque) |
| Color-Column |  | Column | - | Dots will be assigned different colors based on<br>their values of this column |
| log scale X |  | Boolean | false | Values in X-column is log-scaled |
| log scale Y |  | Boolean | false | Values in Y-column is log-scaled |
| Hover column |  | Column | - | Column value to display when a dot is hovered over |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
