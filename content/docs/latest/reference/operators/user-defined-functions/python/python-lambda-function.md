---
title: "Python Lambda Function"
description: "Modify or add a new column with more ease"
category: "Python"
operator_type: "PythonLambdaFunction"
tags: [user-defined-functions, python]
aliases:
  - /docs/reference/operators/user-defined-functions/python/python-lambda-function/

---

[Home](../../../) > [User Defined Functions](../../) > [Python](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Add/Modify column(s) |  | List<Lambda Attribute Unit> | - |  |
| ↳ Attribute Name | ✓ | String | - |  |
| ↳ Expression | ✓ | String | - |  |
| ↳ Attribute Type | ✓ | string, integer, long, double, boolean,<br>timestamp, binary, large_binary | - |  |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../../output-modes/#set-snapshot) |
