---
title: "KNN Regressor"
description: "Sklearn KNN Regressor Operator"
category: "Advanced Sklearn"
operator_type: "KNNRegressorTrainer"
version: "N/A"
tags: [machine-learning, advanced-sklearn]
---

[Home](../../../) > [Machine Learning](../../) > [Advanced Sklearn](../)

### Input Properties

| Property | Requirement | Type | Default | Description |
|----------|-------------|------|---------|-------------|
| Parameter Setting | ✓ | [SklearnAdvancedKNNParameters](../../../parameters/sklearn-advanced-knn-parameters/) | - |  |
| Ground Truth Attribute Column | ✓ | Column | - | Ground truth attribute column |
| Selected Features | ✓ | List | - | Features used to train the model |

### Output Ports

| Port | Mode |
|------|------|
| 0 | [Set Snapshot](../../../output-modes/#set-snapshot) |
