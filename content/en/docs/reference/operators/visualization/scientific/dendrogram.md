---
title: "Dendrogram"
description: "Visualize data in a Dendrogram"
category: "Scientific"
operator_type: "Dendrogram"
version: "N/A"
tags: [visualization, scientific]
---

[Home](../../../) > [Visualization](../../) > [Scientific](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Color Threshold |  | String | - | Value at which separation of clusters will be made |
| Value X Column | ✓ | Column | - | The x values of points in dendrogram |
| Value Y Column | ✓ | Column | - | The y value of points in dendrogram |
| Labels | ✓ | Column | - | The label of points in dendrogram |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
