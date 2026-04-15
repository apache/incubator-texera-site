---
title: "Quiver Plot"
description: "Visualize vector data in a Quiver Plot"
category: "Scientific"
operator_type: "QuiverPlot"
version: "N/A"
tags: [visualization, scientific]
---

[Home](../../../) > [Visualization](../../) > [Scientific](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| x | ✓ | Column | - | Column for the x-coordinate of the starting point |
| y | ✓ | Column | - | Column for the y-coordinate of the starting point |
| u | ✓ | Column | - | Column for the vector component in the x-direction |
| v | ✓ | Column | - | Column for the vector component in the y-direction |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
