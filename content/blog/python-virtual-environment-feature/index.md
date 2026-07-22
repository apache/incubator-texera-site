---
title: "Introducing Python Virtual Environments in Texera"
linkTitle: "Introducing Python Virtual Environments in Texera"
date: 2026-06-03
author: Sarah Asad
description: "Enabling users to run workflows with custom Python dependencies while maintaining isolation and reproducibility."
images:
  - /images/blog_hero/pve-screenshot.png
tags: ["python", "virtual-environments", "dependency-management"]
---

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction · Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Python UDFs allow users to extend Texera workflows with custom code, but many workflows depend on packages that are not available in the default system environment. To address this challenge, Texera now supports Python Virtual Environments (PVEs), enabling users to install custom dependencies and execute workflows in isolated Python environments.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
By giving users control over their runtime dependencies, PVEs make it easier to develop, share, and reproduce Python-based workflows while reducing package conflicts across the platform.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
The Challenge
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Before PVEs, Python UDFs relied entirely on packages installed in the system environment. While this worked for simple workflows, it became increasingly difficult to support workflows that required specialized libraries or specific package versions.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Installing packages globally can introduce dependency conflicts and make workflow execution less reproducible. As Texera's Python ecosystem continued to grow, users needed a way to manage dependencies independently.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
A workflow requiring one version of a package should not prevent another workflow from using a different version of the same package.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
Introducing Python Virtual Environments
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Python Virtual Environments provide isolated Python installations that maintain their own package dependencies. Users can create environments, install packages, and manage dependencies without affecting other workflows or users.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video
    autoplay
    loop
    muted
    playsinline
    controls
    style="width: 100%; border-radius: 12px;">
    <source src="/videos/pve-demo.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Creating a virtual environment, installing dependencies, and using it in a Python UDF.
  </p>
</div>

<div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px; margin: 22px 0;">
<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; margin: 0 0 16px;">
Key Capabilities
</h3>

<ul style="margin: 0;">
<li>Create Python virtual environments directly within Texera</li>
<li>Install custom Python packages using pip</li>
<li>View and manage existing environments</li>
<li>Remove environments that are no longer needed</li>
<li>Reuse environments across multiple workflow executions</li>
</ul>
</div>


<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
Running Python UDFs with PVEs
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
When configuring a Python UDF, users can select a virtual environment to use during execution. Texera launches the Python worker using the interpreter from the selected environment, giving the UDF access to all installed packages.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
This allows workflows to use libraries such as pandas, numpy, scikit-learn, and many others without requiring those dependencies to be installed globally.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
Benefits
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<table style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0; width: 100%;">
<tbody>
<div style="display: grid; grid-template-columns: repeat(2, 1fr); border: 2px solid #14110f; margin: 6px 0;">
  <div style="padding: 24px 26px; background: #fbf7ef; border-right: 2px solid #14110f; border-bottom: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 28px; color: #c8451f; margin: 0 0 12px;">Isolation</h3>
    <p style="margin: 0;">Separate dependencies for different workflows.</p>
  </div>

  <div style="padding: 24px 26px; background: #fbf7ef; border-bottom: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 28px; color: #c8451f; margin: 0 0 12px;">Flexibility</h3>
    <p style="margin: 0;">Support custom Python packages and libraries.</p>
  </div>

  <div style="padding: 24px 26px; background: #fbf7ef; border-right: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 28px; color: #c8451f; margin: 0 0 12px;">Reproducibility</h3>
    <p style="margin: 0;">Ensure consistent workflow execution.</p>
  </div>

  <div style="padding: 24px 26px; background: #fbf7ef;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 28px; color: #c8451f; margin: 0 0 12px;">Extensibility</h3>
    <p style="margin: 0;">Support a broader range of data science and machine learning workflows.</p>
  </div>
</div>
</tbody>
</table>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
Impact on Texera
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 20px;">
The introduction of Python Virtual Environments represents an important step toward making Texera a more flexible platform for Python-based analytics and machine learning. By allowing users to manage their own dependencies, workflows become easier to share, reproduce, and extend.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 36px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Looking Ahead
</h2>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto; max-width: 680px;">
Python Virtual Environments provide the foundation for more advanced environment management capabilities in Texera while giving users greater control over how their workflows are executed today.
</p>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
Python Virtual Environments make custom dependency management a first-class experience in Texera.
</p>

</div>
