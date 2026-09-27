---
title: "Automatic Cleanup for Idle Kubernetes Computing Units"
linkTitle: "Idle Kubernetes Computing Unit Cleanup"
slug: "idle-kubernetes-computing-units"
date: 2026-09-27
author: Yichen Ren
description: "Texera can now remove idle Kubernetes computing units automatically, freeing cluster resources while keeping running workflows safe."
images:
  - /images/blog_hero/idle-kubernetes-computing-units.svg
tags: ["kubernetes", "computing-units", "resource-management"]
---

<p style="text-align: center; font-size: 15px; color: #6a6257; margin: 0 0 22px;">
Reviewed by <a style="color: #c8451f; font-weight: 700; text-decoration: none;" href="https://github.com/kunwp1" target="_blank" rel="noopener">Kunwoo Park</a>, <a style="color: #c8451f; font-weight: 700; text-decoration: none;" href="https://github.com/aicam" target="_blank" rel="noopener">Ali Risheh</a>, and <a style="color: #c8451f; font-weight: 700; text-decoration: none;" href="https://github.com/Ma77Ball" target="_blank" rel="noopener">Matthew Ball</a>, and advised by <a style="color: #c8451f; font-weight: 700; text-decoration: none;" href="https://github.com/chenlica" target="_blank" rel="noopener">Chen Li</a>.
</p>

<div style="max-width: 860px; width: 100%; margin: 0 auto 32px;">
  <img src="/images/blog_hero/idle-kubernetes-computing-units.svg" alt="Texera removes a Kubernetes computing unit only when no workflow is running and the unit has been idle longer than the chosen time limit" style="width: 100%; height: auto; display: block; border-radius: 12px;">
</div>

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Texera uses computing units (CUs) to run workflows. On a Kubernetes deployment, each CU runs in its own pod. Keeping that pod ready makes the next workflow start faster, but it also means the pod keeps using cluster resources after the work is done.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Texera can now clean up CUs that have been unused for a long time. Once an administrator turns on this feature, Texera regularly checks for idle CUs and removes their pods. Running workflows are left alone, while unused CPU and memory become available to the rest of the cluster.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #5b5347; margin: 0 0 8px; padding: 14px 18px; background: #fbf7ef; border-radius: 10px;">
This post explains the feature from a user's point of view. Links to the design discussion and implementation are included at the end for readers who want the technical details.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
The Problem
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
A user may create a CU, run a workflow, and then leave Texera. The workflow has finished, but the Kubernetes pod can continue running until someone removes it by hand. On a shared cluster, many forgotten CUs can slowly take resources away from active users.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
Kubernetes cannot solve this problem by looking at CPU use alone. A workflow may still be running even when its CPU use is low. Texera has better information: it knows which workflows use each CU and when that CU was last active.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-size: 16px; border-radius: 0 8px 8px 0;">
The goal is simple: keep CUs available for active work and short breaks, but remove the ones that have truly been left behind.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
What Changes
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 18px; margin: 26px 0;">
  <div style="background: #fff3ef; border: 1.5px solid #e7b7a8; border-radius: 12px; padding: 24px 26px;">
    <div style="font-size: 13px; font-weight: 800; letter-spacing: .08em; color: #a92d18; margin-bottom: 8px;">BEFORE</div>
    <div style="font-family: Georgia,'Times New Roman',serif; font-size: 24px; font-weight: 900; margin-bottom: 10px;">Idle pods stayed alive</div>
    <div style="font-size: 16px; color: #5b5347;">A CU kept running until a user or administrator removed it.</div>
  </div>
  <div style="background: #edf9f2; border: 1.5px solid #9bcfae; border-radius: 12px; padding: 24px 26px;">
    <div style="font-size: 13px; font-weight: 800; letter-spacing: .08em; color: #146938; margin-bottom: 8px;">NOW</div>
    <div style="font-family: Georgia,'Times New Roman',serif; font-size: 24px; font-weight: 900; margin-bottom: 10px;">Old, unused pods can be removed</div>
    <div style="font-size: 16px; color: #416352;">Texera can find idle CUs and clean them up automatically.</div>
  </div>
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 25px; margin: 34px 0 14px; color: #14110f;">
How Texera Detects an Idle CU
</h3>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 28px; align-items: center; margin: 22px 0 28px;">
<div>
<p style="font-size: 17px; margin: 0 0 18px;">
During each cleanup check, Texera looks only at Kubernetes CUs that have not already been removed. It first checks the workflows connected to each CU. If any workflow is still active, Texera keeps the CU, even if it has been running for a long time.
</p>
<p style="font-size: 17px; margin: 0;">
When no workflow is active, Texera finds the CU's latest activity by comparing its creation time with the latest workflow start and update times. The CU is idle only when that activity is older than the limit chosen by the administrator. The database update that marks the CU as terminated repeats the workflow checks. If the CU became active during the scan, the update does nothing and Texera keeps the CU.
</p>
</div>

  <figure style="margin: 0;">
    <img src="/images/blog/idle-kubernetes-cu-detection.svg" alt="Flowchart showing how Texera checks whether a Kubernetes computing unit is idle before removing its pod" style="width: 100%; max-width: 590px; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
    <figcaption style="font-size: 14px; color: #666; margin-top: 8px; text-align: center;">
      A CU is removed only when it has no active workflow and its latest activity is older than the chosen limit.
    </figcaption>
  </figure>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
See It in Action
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<div style="display: flex; flex-wrap: wrap; gap: 28px; align-items: center; max-width: 1180px; margin: 26px auto 34px;">
  <figure style="flex: 1.7 1 560px; margin: 0; text-align: center;">
    <video controls playsinline preload="metadata" style="width: 100%; max-width: 780px; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
      <source src="/videos/texera-pr6046.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>
    <figcaption style="font-size: 14px; color: #666; margin-top: 8px;">
      Manual removal followed by automatic idle cleanup.
    </figcaption>
  </figure>

  <div style="flex: 1 1 300px; background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 23px; margin: 0 0 12px; color: #14110f;">What the demo shows</h3>
    <p style="font-size: 16px; margin: 0 0 12px; color: #5b5347;">
      The demo creates two CUs and shows how administrators can tell why each one was removed:
    </p>
    <ol style="font-size: 16px; margin: 0; padding-left: 22px;">
      <li style="margin-bottom: 8px;">A user removes the first CU manually.</li>
      <li style="margin-bottom: 8px;">The second CU is left unused until Texera removes it automatically.</li>
      <li>The service log records the CU and the reason in both cases.</li>
    </ol>
  </div>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
What Users Can Expect
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
Users do not need to start the cleanup or watch a timer. It runs in the background as part of Texera. A CU with a running workflow stays available. A CU that was used recently also stays available, so users can return after a short break without waiting for a new pod.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
After a CU has been idle past the chosen limit, Texera removes its Kubernetes pod. If the user needs more computing power later, they can create another CU in the usual way.
</p>

<div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px; margin: 22px 0;">
  <h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 0 0 14px;">The cleanup stays out of the way</h3>
  <ul style="margin: 0; padding-left: 22px; font-size: 16px;">
    <li style="margin-bottom: 8px;">Running workflows are not removed.</li>
    <li style="margin-bottom: 8px;">Recently used CUs stay warm for the next workflow.</li>
    <li style="margin-bottom: 8px;">Only Kubernetes CUs are included.</li>
    <li>Administrators can tell whether a CU was removed automatically or by a user.</li>
  </ul>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
Choices for Each Deployment
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
Different clusters have different needs. A classroom deployment may want CUs to remain available throughout a lab, while a busy shared cluster may want to free resources sooner. Texera therefore lets administrators choose how long a CU may sit idle and how often cleanup runs.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
The feature is off by default. When it is enabled, the default idle limit is 24 hours and Texera checks once per hour. Administrators can change both values to match their users and available cluster resources.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">06</span>
Looking Ahead
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-size: 17px; margin: 0 0 18px;">
The first version puts safety first. If Texera sees a workflow record that has not finished, it keeps the CU. In an unusual failure, an old workflow record may get stuck and keep an unused CU alive. That is safer than removing a CU that may still be doing work, but it also means some idle CUs may need more checks in the future.
</p>

<p style="font-size: 17px; margin: 0 0 18px;">
We are tracking that improvement in <a style="color: #c8451f; font-weight: bold; text-decoration: none;" href="https://github.com/apache/texera/issues/8618" target="_blank" rel="noopener">issue #8618</a>. Future work can compare old workflow records with the real pod status before deciding what to do.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 36px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Learn More
</h2>

<p style="font-size: 16px; color: #cbc1b1; margin: 0 auto 24px; max-width: 720px;">
This feature began with a community discussion about how Texera should identify and clean up idle computing units. The discussion and implementation are available on GitHub.
</p>

<div style="display: flex; flex-wrap: wrap; gap: 12px; justify-content: center;">
  <a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/discussions/6264" target="_blank" rel="noopener">Read the discussion</a>
  <a style="display: inline-block; background: #f4efe6; color: #2a241d; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/pull/6046" target="_blank" rel="noopener">View the implementation</a>
</div>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
Automatic cleanup helps Texera keep shared Kubernetes resources available for the users who need them.
</p>

</div>
