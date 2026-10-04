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

<p class="post-eyebrow">Feature Introduction · Apache Texera</p>

<p class="post-lead">
Python UDFs allow users to extend Texera workflows with custom code, but many workflows depend on packages that are not available in the default system environment. To address this challenge, Texera now supports Python Virtual Environments (PVEs), enabling users to install custom dependencies and execute workflows in isolated Python environments.
</p>

<p class="post-lead">
By giving users control over their runtime dependencies, PVEs make it easier to develop, share, and reproduce Python-based workflows while reducing package conflicts across the platform.
</p>

<h2 data-num="01">The Challenge</h2>

<p>
Before PVEs, Python UDFs relied entirely on packages installed in the system environment. While this worked for simple workflows, it became increasingly difficult to support workflows that required specialized libraries or specific package versions.
</p>

<p>
Installing packages globally can introduce dependency conflicts and make workflow execution less reproducible. As Texera's Python ecosystem continued to grow, users needed a way to manage dependencies independently.
</p>

<div class="post-callout">
A workflow requiring one version of a package should not prevent another workflow from using a different version of the same package.
</div>

<h2 data-num="02">Introducing Python Virtual Environments</h2>

<p>
Python Virtual Environments provide isolated Python installations that maintain their own package dependencies. Users can create environments, install packages, and manage dependencies without affecting other workflows or users.
</p>

<figure class="post-figure">
  <video autoplay loop muted playsinline controls>
    <source src="/videos/pve-demo.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <figcaption>Creating a virtual environment, installing dependencies, and using it in a Python UDF.</figcaption>
</figure>

<div class="post-card">
<h3>Key Capabilities</h3>
<ul>
<li>Create Python virtual environments directly within Texera</li>
<li>Install custom Python packages using pip</li>
<li>View and manage existing environments</li>
<li>Remove environments that are no longer needed</li>
<li>Reuse environments across multiple workflow executions</li>
</ul>
</div>

<h2 data-num="03">Running Python UDFs with PVEs</h2>

<p>
When configuring a Python UDF, users can select a virtual environment to use during execution. Texera launches the Python worker using the interpreter from the selected environment, giving the UDF access to all installed packages.
</p>

<p>
This allows workflows to use libraries such as pandas, numpy, scikit-learn, and many others without requiring those dependencies to be installed globally.
</p>

<h2 data-num="04">Benefits</h2>

<div class="post-grid">
  <div class="post-grid-cell">
    <h3>Isolation</h3>
    <p>Separate dependencies for different workflows.</p>
  </div>
  <div class="post-grid-cell">
    <h3>Flexibility</h3>
    <p>Support custom Python packages and libraries.</p>
  </div>
  <div class="post-grid-cell">
    <h3>Reproducibility</h3>
    <p>Ensure consistent workflow execution.</p>
  </div>
  <div class="post-grid-cell">
    <h3>Extensibility</h3>
    <p>Support a broader range of data science and machine learning workflows.</p>
  </div>
</div>

<h2 data-num="05">Impact on Texera</h2>

<p>
The introduction of Python Virtual Environments represents an important step toward making Texera a more flexible platform for Python-based analytics and machine learning. By allowing users to manage their own dependencies, workflows become easier to share, reproduce, and extend.
</p>

<div class="post-banner">
<h2>Looking Ahead</h2>
<p>
Python Virtual Environments provide the foundation for more advanced environment management capabilities in Texera while giving users greater control over how their workflows are executed today.
</p>
</div>

<p class="post-outro">
Python Virtual Environments make custom dependency management a first-class experience in Texera.
</p>
