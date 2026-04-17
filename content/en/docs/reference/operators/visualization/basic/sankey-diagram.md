---
title: "Sankey Diagram"
description: "Visualize data using a Sankey diagram"
category: "Basic"
operator_type: "SankeyDiagram"
tags: [visualization, basic]
---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Source Attribute | ✓ | Column | - | The source node of the Sankey diagram |
| Target Attribute | ✓ | Column | - | The target node of the Sankey diagram |
| Value Attribute | ✓ | Column | - | The value/volume of the flow between source and<br>target |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
