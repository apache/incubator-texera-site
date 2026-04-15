---
title: "Gantt Chart"
description: "A Gantt chart is a type of bar chart that illustrates a project schedule. The chart lists the tasks to be performed on the vertical axis, and time intervals on the horizontal axis. The width of the horizontal bars in the graph shows the duration of each activity."
category: "Basic"
operator_type: "GanttChart"
version: "N/A"
tags: [visualization, basic]
---

[Home](../../../) > [Visualization](../../) > [Basic](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Pattern |  | Column | - | Add texture to the chart based on an attribute |
| Start Datetime Column | ✓ | Column (timestamp) | - | The start timestamp of the task |
| Finish Datetime Column | ✓ | Column (timestamp) | - | The end timestamp of the task |
| Task Column | ✓ | Column | - | The name of the task |
| Color Column |  | Column | - | Column to color tasks |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
