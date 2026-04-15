---
title: "Time Series Plot"
description: "Visualize trends and patterns over time."
category: "Basic"
operator_type: "TimeSeriesPlot"
version: "N/A"
tags: [visualization, basic]
---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Time Column | ✓ | Column | - | The column containing time/date values (e.g.,<br>Date, Timestamp) |
| Value Column | ✓ | Column | - | The numerical column to plot on the Y-axis (e.g.,<br>Sales, Temperature) |
| Facet Column |  | Column | No Selection | Optional - A column to create separate subplots |
| Category Column |  | Column | No Selection | Optional - A categorical column to create<br>separate lines |
| Plot Type | ✓ | String | line | Select the type of time series plot (line, area) |
| Show Range Slider |  | Boolean | false | Display a range slider at the bottom of the plot |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
