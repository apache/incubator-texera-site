---
title: "Automatically Removing Idle Kubernetes Computing Units"
linkTitle: "Idle Kubernetes Computing Unit Cleanup"
slug: "idle-kubernetes-computing-units"
date: 2026-09-27
author: Yichen Ren
description: "Texera can now remove idle Kubernetes computing units through an optional cleanup task that protects running workflows and frees cluster resources."
images:
  - /images/blog_hero/idle-kubernetes-computing-units.svg
tags: ["kubernetes", "computing-units", "resource-management", "backend"]
---

<div style="max-width: 100%; width: 100%; margin: 0 0 32px;">
  <img src="/images/blog_hero/idle-kubernetes-computing-units.svg" alt="Texera removes a Kubernetes computing unit only when no workflow is running and the unit has been idle longer than the configured limit" style="width: 100%; height: auto; display: block; border-radius: 12px;">
</div>

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
On Kubernetes, each Texera computing unit (CU) runs as a pod. Keeping a CU alive between workflow runs makes the next run start faster. However, a CU still uses CPU and memory after its owner stops using it. Until now, someone had to remove these pods by hand.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Texera administrators can now turn on automatic cleanup for idle CUs. A scheduled task finds Kubernetes CUs that have no running workflow and have not been used for a set amount of time. Texera then removes their pods and saves the reason in the database.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
Why Texera Does the Cleanup
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
A Texera CU is more than a Kubernetes pod. It has an owner, access rules, resource settings, an address, and a history of workflow runs. Kubernetes tools can check CPU and memory use, but they do not know whether a Texera workflow is still using the CU.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
For this reason, the cleanup runs in Texera's Computing Unit Managing Service. This service already manages CU records and Kubernetes pods. We do not need another service, and Texera can update the pod and database record together.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-size: 16px; border-radius: 0 8px 8px 0;">
<strong>Texera checks workflow status and activity time, not CPU or memory use.</strong> A CU may use very little CPU while a workflow is still running.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
When a CU Is Idle
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
Texera removes a CU only when all three conditions below are true:
</p>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 16px; margin: 24px 0;">
  <div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 22px 24px;">
    <div style="font-size: 13px; font-weight: 800; letter-spacing: .08em; color: #c8451f; margin-bottom: 8px;">SCOPE</div>
    <div style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; font-weight: 900; margin-bottom: 8px;">Kubernetes only</div>
    <div style="font-size: 15.5px; color: #5b5347;">The task skips local CUs and CUs that have already stopped.</div>
  </div>
  <div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 22px 24px;">
    <div style="font-size: 13px; font-weight: 800; letter-spacing: .08em; color: #c8451f; margin-bottom: 8px;">WORKFLOW STATE</div>
    <div style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; font-weight: 900; margin-bottom: 8px;">No workflow is running</div>
    <div style="font-size: 15.5px; color: #5b5347;">If any workflow run has not finished, Texera keeps the CU.</div>
  </div>
  <div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 22px 24px;">
    <div style="font-size: 13px; font-weight: 800; letter-spacing: .08em; color: #c8451f; margin-bottom: 8px;">ACTIVITY</div>
    <div style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; font-weight: 900; margin-bottom: 8px;">Idle long enough</div>
    <div style="font-size: 15.5px; color: #5b5347;">The CU's latest activity is older than the chosen time limit.</div>
  </div>
</div>

<p style="font-size: 17px; margin: 0 0 18px;">
Texera checks the latest workflow update time, workflow start time, and CU creation time. For a CU that has never run a workflow, the idle period starts when the CU is created. Using the newest of these times prevents Texera from removing a recently used CU.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
How One Cleanup Round Works
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<div style="margin: 26px 0;">
  <div style="display: grid; grid-template-columns: 58px 1fr; gap: 18px; align-items: start; margin-bottom: 22px;">
    <div style="width: 50px; height: 50px; border-radius: 50%; background: #2864dc; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 800;">1</div>
    <div><strong style="font-family: Georgia,'Times New Roman',serif; font-size: 22px;">Find idle CUs.</strong><div style="font-size: 16px; color: #5b5347; margin-top: 4px;">One database query checks all active Kubernetes CUs. Texera also adds an index on <code>workflow_executions.cuid</code> to make this lookup faster.</div></div>
  </div>
  <div style="display: grid; grid-template-columns: 58px 1fr; gap: 18px; align-items: start; margin-bottom: 22px;">
    <div style="width: 50px; height: 50px; border-radius: 50%; background: #2864dc; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 800;">2</div>
    <div><strong style="font-family: Georgia,'Times New Roman',serif; font-size: 22px;">Check again before removal.</strong><div style="font-size: 16px; color: #5b5347; margin-top: 4px;">Before removing a CU, Texera checks that no workflow started or reported new activity after the first query.</div></div>
  </div>
  <div style="display: grid; grid-template-columns: 58px 1fr; gap: 18px; align-items: start; margin-bottom: 22px;">
    <div style="width: 50px; height: 50px; border-radius: 50%; background: #1b9b52; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 800;">3</div>
    <div><strong style="font-family: Georgia,'Times New Roman',serif; font-size: 22px;">Remove the pod and save the reason.</strong><div style="font-size: 16px; color: #5b5347; margin-top: 4px;">Texera deletes the pod and records <code>GARBAGE_COLLECTED</code>. When a person removes a CU, Texera records <code>USER_REQUESTED</code> instead. This makes the two cases easy to tell apart.</div></div>
  </div>
</div>

<p style="font-size: 17px; margin: 0 0 18px;">
Texera handles each CU separately. If one pod cannot be deleted, Texera cancels that CU's database change and tries again in a later round. The other CUs are still checked. One failed round also does not stop later cleanup rounds.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
Settings
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
Cleanup is off by default. This gives each deployment time to choose settings that fit its users. Administrators control the feature with three environment variables:
</p>

<div style="overflow-x: auto; margin: 24px 0;">
<table style="border-collapse: collapse; width: 100%; min-width: 680px; font-size: 15px;">
  <thead>
    <tr style="background: #2a241d; color: #fff; text-align: left;">
      <th style="padding: 14px 16px;">Setting</th>
      <th style="padding: 14px 16px;">Purpose</th>
      <th style="padding: 14px 16px;">Default</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background: #fbf7ef; border-bottom: 1px solid #d8cfbf;">
      <td style="padding: 14px 16px;"><code>KUBERNETES_COMPUTING_UNIT_IDLE_CLEANUP_ENABLED</code></td>
      <td style="padding: 14px 16px;">Turns automatic cleanup on</td>
      <td style="padding: 14px 16px;"><code>false</code></td>
    </tr>
    <tr style="background: #fff; border-bottom: 1px solid #d8cfbf;">
      <td style="padding: 14px 16px;"><code>KUBERNETES_COMPUTING_UNIT_IDLE_TIMEOUT_MINUTES</code></td>
      <td style="padding: 14px 16px;">How long a CU may remain idle</td>
      <td style="padding: 14px 16px;">1,440 minutes (24 hours)</td>
    </tr>
    <tr style="background: #fbf7ef;">
      <td style="padding: 14px 16px;"><code>KUBERNETES_COMPUTING_UNIT_IDLE_CHECK_INTERVAL_MINUTES</code></td>
      <td style="padding: 14px 16px;">How often Texera checks for idle CUs</td>
      <td style="padding: 14px 16px;">60 minutes</td>
    </tr>
  </tbody>
</table>
</div>

<p style="font-size: 17px; margin: 0 0 18px;">
Both time values must be greater than zero. If either value is invalid, Texera writes a warning to the log and does not start the cleanup task. The rest of the Computing Unit Managing Service still starts normally.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
Known Limit
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
The first version is careful not to remove a CU that may still be in use. Any workflow record that has not finished keeps its CU alive, even if that record is old. Because of this, a record stuck in a state such as <code>RUNNING</code> or <code>UNKNOWN</code> can keep an idle CU alive forever.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
We are tracking this case in <a style="color: #c8451f; font-weight: bold; text-decoration: none;" href="https://github.com/apache/texera/issues/8618" target="_blank" rel="noopener">issue #8618</a>. A future update can ignore old, stuck workflow records after a safe amount of time and regularly compare workflow status with the real pod status.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 36px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
From Discussion to Feature
</h2>

<p style="font-size: 16px; color: #cbc1b1; margin: 0 auto 24px; max-width: 720px;">
This feature grew out of a community discussion about what “idle” means in Texera and why Kubernetes cannot decide it by itself. The final design gives administrators a simple way to free unused resources without stopping running workflows.
</p>

<div style="display: flex; flex-wrap: wrap; gap: 12px; justify-content: center;">
  <a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/pull/6046" target="_blank" rel="noopener">Read PR #6046</a>
  <a style="display: inline-block; background: #f4efe6; color: #2a241d; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/discussions/6264" target="_blank" rel="noopener">Read discussion #6264</a>
</div>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
Texera can now clean up unused computing units and return their resources to the cluster.
</p>

</div>
