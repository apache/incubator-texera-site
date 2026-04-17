---
title: "AsterixDB Source"
description: "Read data from a AsterixDB instance"
category: "Database Connector"
operator_type: "AsterixDBSource"
tags: [database-connector]
---

[Home](../../) > [Database Connector](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Host | ✓ | String | - |  |
| Port | ✓ | String | default | A port number or 'default' |
| Database | ✓ | String | - |  |
| Table Name | ✓ | String | - |  |
| Limit |  | Long | - | Max output count |
| Offset |  | Long | - | Starting point of output |
| Keyword Search? |  | Boolean | false |  |
| Keyword Search Column |  | Column | - |  |
| Keywords to Search |  | String | - |  |
| Progressive? |  | Boolean | false |  |
| Batch by Column |  | Column | - |  |
| Min |  | String | auto |  |
| Max |  | String | auto |  |
| Batch by Interval |  | Long | 1000000000 |  |
| Geo Search? |  | Boolean | false |  |
| Geo Search By Columns |  | List | - | Column(s) to check if any of them is in the<br>bounding box below |
| Geo Search Bounding Box |  | List | - | At least 2 entries should be provided to form a<br>bounding box. format of each entry: long, lat |
| Regex Search? |  | Boolean | false |  |
| Regex Search By Column |  | Column | - |  |
| Regex to Search |  | String | - |  |
| Filter Condition? |  | Boolean | false |  |
| Predicates |  | List<Filter Predicate> | - | Multiple predicates in OR |
| ↳ Attribute | ✓ | Column | - |  |
| ↳ Condition | ✓ | `=`, `>`, `>=`, `<`, `<=`, `!=`<br>`is null`, `is not null` | - |  |
| ↳ Value |  | String | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../output-modes/#set-snapshot) |
