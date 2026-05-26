---
title: "Range Slider"
description: "Visualize data in a Range Slider"
category: "Basic"
operator_type: "RangeSlider"
tags: [visualization, basic]
aliases:
  - /docs/reference/operators/visualization/basic/range-slider/

---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Y-axis | ✓ | String | - | The name of the column to represent y-axis |
| X-axis | ✓ | String | - | The name of the column to represent the x-axis |
| Handle Duplicates |  | Nothing, Mean, Sum | NOTHING | How to handle duplicate values in y-axis |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
