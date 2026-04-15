---
title: "Candlestick Chart"
description: "Visualize data in a Candlestick Chart"
category: "Financial"
operator_type: "CandlestickChart"
version: "N/A"
tags: [visualization, financial]
---

[Home](../../../) > [Visualization](../../) > [Financial](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Date Column | ✓ | Column | - | The date of the candlestick |
| Opening Price Column | ✓ | Column | - | The opening price of the candlestick |
| Highest Price Column | ✓ | Column | - | The highest price of the candlestick |
| Lowest Price Column | ✓ | Column | - | The lowest price of the candlestick |
| Closing Price Column | ✓ | Column | - | The closing price of the candlestick |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Single Snapshot](../../../output-modes/#single-snapshot) |
