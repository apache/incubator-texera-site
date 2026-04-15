---
title: "SVM Regressor"
description: "Sklearn SVM Regressor Operator"
category: "Advanced Sklearn"
operator_type: "SVRTrainer"
version: "N/A"
tags: [machine-learning, advanced-sklearn]
---

[Home](../../../) > [Machine Learning](../../) > [Advanced Sklearn](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Parameter Setting | ✓ | [SklearnAdvancedSVRParameters](../../../parameters/sklearn-advanced-svr-parameters/) | - |  |
| Ground Truth Attribute Column | ✓ | Column | - | Ground truth attribute column |
| Selected Features | ✓ | List | - | Features used to train the model |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../../output-modes/#set-snapshot) |
