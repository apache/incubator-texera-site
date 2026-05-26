---
title: "Polar Chart"
description: "Displays data points in a polar scatter plot"
category: "Scientific"
operator_type: "PolarChart"
tags: [visualization, scientific]
aliases:
  - /docs/reference/operators/visualization/scientific/polar-chart/

---

[Home](../../../) > [Visualization](../../) > [Scientific](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| r | ✓ | String | - | The column name for radial values (must be<br>numeric) |
| theta | ✓ | String | - | The column name for angular values (must be<br>numeric) |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
