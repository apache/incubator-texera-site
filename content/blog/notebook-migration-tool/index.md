---
title: "Migrating Jupyter Notebooks into Texera Workflows"
linkTitle: "Notebook Migration Tool"
slug: "notebook-migration-tool"
date: 2026-09-15
author: Ryan Zhang and Meng Wang, advised by Chen Li
description: "A new tool converts a Jupyter notebook into a Texera workflow using a large language model, and keeps the notebook open beside the workflow so users can see which cell produced which operator."
images:
  - /images/blog_hero/notebook-migration.png
tags: ["notebook-migration", "jupyter", "llm", "python", "workflows"]
---

<figure class="post-hero">
  <img src="/images/blog_hero/notebook-migration.png" alt="A Texera workspace showing a generated workflow beside the notebook it was generated from">
</figure>

<p class="post-eyebrow">Feature Introduction &middot; Apache Texera</p>

<p class="post-lead">
Texera users build data pipelines by connecting operators on a canvas. Users who already have working code, most often a Jupyter notebook, have had one way in: read the notebook, decide where the pipeline boundaries fall, and rebuild it operator by operator. Texera now has a tool that does a first pass of that work. It sends a notebook to a large language model, builds a workflow from the response, and records which cell produced which operator.
</p>

<p class="post-lead">
A generated workflow is a draft. The tool is built around that assumption, so the notebook stays open beside the workflow while the user edits it and the original code is always one click away.
</p>

<p class="post-note">
This post has two halves. The first shows what the tool does, with no assumptions about Texera's internals. The second covers how it was built and what went wrong along the way, for readers who want that.
</p>

<h2 data-num="01">The Problem</h2>

<p>
A notebook and a Texera workflow describe the same computation in different shapes. A notebook is a linear sequence of cells that share one namespace. A workflow is a graph of operators that pass tables to each other. Getting from the first shape to the second means deciding where one stage ends and the next begins, which values cross those boundaries, and which cells are setup rather than computation.
</p>

<p>
None of those decisions are hard on their own. Together they scale with the size of the notebook, and all of them come before the user can run anything. For someone with a few hundred lines of analysis code, the cost of the first workflow is high enough to be the reason they never build it.
</p>

<div class="post-callout">
The user still has to judge whether the split is right. The tool changes what they spend that judgment on: reviewing a draft instead of producing one.
</div>

<h2 data-num="02">Converting a Notebook</h2>

<p>
The user uploads a notebook from a button in the workspace toolbar and picks a model from the ones the deployment exposes. There is no API key to paste. The request goes to Texera's own LiteLLM proxy, authenticated with the session the user already has, and the deployment holds the provider credentials. The deployment therefore decides which models are reachable. Conversion takes roughly one to five minutes, depending on the size of the notebook.
</p>

<figure class="post-figure">
  <img src="/images/blog_hero/notebook-migration-upload.png" alt="The notebook upload dialog, showing the selected notebook and the model selector">
  <figcaption>Selecting a notebook and a model before conversion.</figcaption>
</figure>

<p>
When the model responds, the workspace reloads with the generated workflow on the canvas and the notebook open in a panel beside it. Every generated operator is a Python UDF, so the result is an ordinary Texera workflow. It can be edited, run, versioned, and shared like any other, and nothing about it depends on the tool that produced it.
</p>

<figure class="post-figure">
  <video autoplay loop muted playsinline controls>
    <source src="/videos/notebook-migration-convert.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <figcaption>Uploading a notebook and waiting for the workspace to reload with the generated workflow.</figcaption>
</figure>

<h2 data-num="03">Reading the Result</h2>

<p>
Conversion produces two things: the workflow, and a mapping between notebook cells and the operators generated from them. The mapping is what makes the draft reviewable. Clicking an operator on the canvas highlights the cell it came from, and clicking a cell highlights the operators it produced. A user who wants to know why an operator contains the code it does can answer that by clicking on it.
</p>

<figure class="post-figure">
  <video autoplay loop muted playsinline controls>
    <source src="/videos/notebook-migration-mapping.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <figcaption>Selecting an operator highlights the cell it was generated from, and selecting a cell highlights its operators.</figcaption>
</figure>

<p>
The notebook is uploaded to a JupyterLab server, which the workspace embeds in a read-only iframe. Each workflow gets its own file, and the mapping is stored against the workflow's version, so it stays attached to the revision it actually describes.
</p>

<p>
Both the notebook and the mapping outlive the session. Reopening a workflow that came from a notebook reopens the notebook with it. The panel can be minimized while the user works on the canvas, and a user who is done with the notebook can delete it, which removes the stored mapping and the file on the Jupyter server together.
</p>

<figure class="post-figure">
  <video autoplay loop muted playsinline controls>
    <source src="/videos/notebook-migration-panel.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <figcaption>Minimizing and reopening the panel, closing and reopening the workflow, and deleting the notebook.</figcaption>
</figure>

<h2 data-num="04">What It Does Not Do</h2>

<p>
A generated workflow does not arrive with its data attached. The tool reads the notebook's code, not the files that code opened, so the user still has to upload the dataset and connect it before anything will run. Until then the workspace reports the workflow as invalid, which is expected rather than a sign that conversion failed.
</p>

<p>
Conversion quality depends on the model. There are no benchmarks and the project makes no accuracy claim. A generated workflow can be wrong in ways that range from an awkward split between two operators to code that does not run. Users should expect to read the output, and the cell mapping exists to make reading it practical.
</p>

<p>
The notebook panel is read-only. It shows the original code for reference and does not execute it, so it does not replace running a notebook. Editing happens on the workflow side.
</p>

<div class="post-banner">
  <p class="post-banner__eyebrow">Part Two</p>
  <h2>Under the Hood</h2>
  <p>Everything above is what the tool does and where it stops. What follows is how it is put together, and the problems that shaped it. Nothing below is needed in order to use the feature.</p>
</div>

<h2 data-num="05">The Path of a Conversion</h2>

<p>
A conversion touches four components spread across the gateway, the computation tier, and storage. The diagram traces a single one, from the upload through to the workspace reloading.
</p>

<figure class="post-figure">
  <img src="/images/blog_hero/notebook-migration-architecture-diagram.png" alt="An eight step flow: the user uploads a notebook through the gateway, which sends it to LiteLLM and a model provider, receives a workflow and mapping back, saves the workflow, passes the notebook and mapping to notebook-migration-service, which stores them in the Texera database and renders the notebook in JupyterLab">
  <figcaption>One conversion, from the upload to the reloaded workspace.</figcaption>
</figure>

<p>
The notebook goes up through the gateway, which forwards it to LiteLLM and on to whichever model provider the deployment has been configured with. The workflow and the cell mapping come back together in one response. The gateway saves the workflow the way it would save any other, then hands the notebook and the mapping to <code>notebook-migration-service</code>, which writes both to the Texera database and uploads the notebook to JupyterLab so the panel has something to render. The workspace reloads with the workflow on the canvas and the notebook beside it.
</p>

<h2 data-num="06">How It Is Built</h2>

<p>
The feature splits across a Dropwizard microservice, <code>notebook-migration-service</code>, which owns the notebook file, the cell mapping, and the JupyterLab server, and a pair of frontend services. <code>NotebookMigrationService</code> builds the prompt, calls the model, and turns the response into a workflow. <code>JupyterPanelService</code> owns the panel and decides which notebook file the current workflow is looking at.
</p>

<p>
The model call runs in the browser against Texera's own LiteLLM proxy at <code>/api/chat</code>. The browser authenticates with the Texera JWT it already holds, and the backend swaps in the LiteLLM master key before the request leaves the cluster. Conversion returns a workflow whose operators are all <code>PythonUDFV2</code>, plus a mapping from each cell to the operators derived from it. The mapping is keyed on the workflow id and the workflow's version, so editing a workflow does not leave a mapping pointing at operators that no longer exist.
</p>

<p>
The first version of the service ran one instance per user, in the same pod as that user's JupyterLab. The Jupyter address was then a constant inside the pod, and isolation was a property of the pod boundary. That was a reasonable simplification for a first version. It did not match how the rest of Texera is arranged. Texera's other services follow a consistent split: orchestrators are global, and stateful resources are per user. <code>computing-unit-managing-service</code> is the closest example, a single global service that resolves each user's compute pod by name.
</p>

<p>
Moving the notebook service into that pattern took four stages, each small enough to review on its own.
</p>

<table class="post-steps" role="presentation">
<tbody>
<tr><td><b>1. Stateless API.</b> A request carries the notebook it refers to, instead of the service remembering it. <a href="https://github.com/apache/texera/pull/7602" target="_blank" rel="noopener"><span class="pr-badge">PR #7602</span></a></td></tr>
<tr><td><b>2. Per-user Jupyter.</b> A registry table and derived tokens, so one global service can serve every user. <a href="https://github.com/apache/texera/pull/8032" target="_blank" rel="noopener"><span class="pr-badge">PR #8032</span></a></td></tr>
<tr><td><b>3. Deployment topology.</b> The service moves out of the user's pod and becomes a global Deployment. <a href="https://github.com/apache/texera/pull/8073" target="_blank" rel="noopener"><span class="pr-badge">PR #8073</span></a></td></tr>
<tr><td><b>4. Per-workflow files.</b> Every workflow gets its own notebook rather than sharing one. <a href="https://github.com/apache/texera/pull/7738" target="_blank" rel="noopener"><span class="pr-badge">PR #7738</span></a></td></tr>
</tbody>
</table>

<h2 data-num="07">Problems That Came Up</h2>

<h3>One notebook name for every workflow</h3>

<p>
The frontend uploaded every notebook to <code>work/notebook.ipynb</code>. Across users that was safe, because each user had their own pod. Across one user's workflows it was not. Opening a second converted workflow overwrote the first one's notebook, and two tabs on different workflows collided on the same file. The file is now <code>notebook_&lt;wid&gt;.ipynb</code>, derived in a single helper that both the upload and the iframe request call, so the file that gets written and the file the panel asks for cannot drift apart.
</p>

<h3>A service that remembered things</h3>

<p>
The service held the current Jupyter URL in a <code>@volatile</code> field. Uploading a notebook wrote it, and asking for the iframe URL read it back. One user with two tabs open could race that field and get the other tab's notebook. The URL is now built from the request, and the notebook name is validated against the same <code>.ipynb</code> pattern used on upload, which also closes the path traversal that a free-form name would otherwise open.
</p>

<h3>One Jupyter address for everyone</h3>

<p>
The Jupyter URL and token were read from configuration as process-wide values. That is only safe when each user runs their own copy of the service. A single global instance would have handed every user the same Jupyter and the same token. A registry table now holds one row per provisioned user, storing both the in-cluster and browser-reachable addresses, and each user's token is derived as <code>HMAC-SHA256(secret, uid)</code>. No credential is stored at rest, any replica derives the same value, and rotating the secret rotates every token. The service refuses to start if the feature is on and the secret is empty, because an empty key is publicly known and the tokens would only look distinct.
</p>

<h3>An iframe cannot carry a token</h3>

<p>
JupyterLab loads in an iframe and then issues its own requests for assets, directory contents, and kernel websockets. None of those can carry a Texera token, and Texera has no session cookie, so the caller cannot be authenticated per request. Each user's JupyterLab is therefore served under <code>/jupyter/&lt;uid&gt;/</code>, and the gateway resolves that uid to the recorded pod address.
</p>

<div class="post-callout">
That mechanism routes. It does not authorize. What keeps users apart is the per-user token, which is derived from a server-held secret and is unguessable. Anyone who can reach the gateway can route to any user's pod, and JupyterLab will answer with a 403 without that user's token. A NetworkPolicy closes the remaining case of a hostile neighboring pod.
</div>

<h3>Rebuilt pods and pooled connections</h3>

<p>
A Jupyter pod is named after its uid, so rebuilding one reuses the hostname with a new IP. The gateway kept pooled connections to the old address for its default idle hour, and a request handed one of those hung until the route timeout, because a departed pod IP is unrouted rather than refused. Retiring idle connections after 30 seconds took a rebuild from 14 failures in 40 requests, scattered over minutes, down to four, confined to the moment of the switch.
</p>

<h3>Default timeouts shorter than the work</h3>

<p>
The gateway's default request timeout is 15 seconds. An LLM completion routinely runs longer than that, so the upstream call succeeded and the response was discarded on the way back. Every conversion failed while still spending the API call. The route serving the model now allows 10 minutes, matching the conversion timeout, and the notebook-migration route allows three minutes, which covers provisioning a pod that has to terminate and come back before it answers.
</p>

<h2 data-num="08">Deploying It</h2>

<p>
The tool runs in all three of Texera's deployment modes. Single-node Docker Compose and the local development scripts each bring up one JupyterLab shared across users, which suits a deployment that already assumes one trusted environment. The Helm chart runs the service as a global Deployment with one JupyterLab pod per user behind a headless Service, a ResourceQuota bounding the pool, and the NetworkPolicy described above.
</p>

<p>
Per-user resolution is gated on its own flag rather than on whether a registry row exists. With the flag off, every user resolves to the one shared JupyterLab. With it on, a user with no row has nothing provisioned yet and is told so, because falling back to the shared server in that case would hand them another user's notebooks. The user id always comes from the authenticated session and never from a request body.
</p>

<p>
The whole feature is off by default, behind the <code>pythonNotebookMigrationEnabled</code> flag. An administrator who does not want users sending code to an external model can leave it disabled, and the toolbar button never appears. On Kubernetes, enabling it without supplying a token secret fails at install with a message naming the missing key, rather than coming up quietly insecure.
</p>

<p>
One known limitation is worth stating. JupyterLab pods have no persistent volume, so a restart empties the working directory, and a single-node container restart does the same. The notebooks themselves are not lost: each one is stored in the database and is uploaded again the next time its workflow is opened.
</p>

<div class="post-banner">
  <h2>Where This Goes Next</h2>
  <p>Notebooks are the first source format the tool understands. Support for plain Python files and for R is in progress, and the machinery that carries a mapping from source code back to generated operators stays the same in each case. Development is tracked on GitHub, and design discussion happens there and on <a href="https://lists.apache.org/list.html?dev@texera.apache.org">dev@texera.apache.org</a>.</p>
  <a class="post-btn" href="https://github.com/apache/texera/issues/4301" target="_blank" rel="noopener">Follow the work on issue #4301</a>
</div>

<p class="post-outro">
If you have a notebook and a Texera deployment, the project would like to hear how the conversion holds up on it.
</p>
