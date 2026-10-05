---
title: "Introducing ML Model Support in Texera"
linkTitle: "ML Model Support"
slug: "ml-model-support"
date: 2026-10-04
author: Tanishq Gandhi and Ali Risheh, advised by Chen Li
description: "Three new features that let you bring a trained model to Texera: models as a first-class resource, mounting a model into your computing unit, and custom images for the environment it runs in."
images:
  - /images/blog_hero/ml-models.png
tags: ["ml-models", "computing-units", "storage", "versioning", "sharing"]
---

<div style="max-width: 100%; width: 100%; margin: 0 0 32px;">
  <img src="/images/blog_hero/ml-models.png" alt="The Models page in the Texera dashboard, showing model cards" style="width: 90%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
</div>

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Texera now supports machine-learning models. A model is a resource of its own, alongside workflows and datasets: it has an owner, a history of versions, a file tree, an access list, and a page other people can find.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Three features arrive together, because running a model takes all three: somewhere to keep it, a way for your code to reach it, and an environment able to load it.
</p>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(230px, 1fr)); border: 2px solid #14110f; margin: 32px 0 8px;">
  <div style="padding: 22px 24px; background: #fbf7ef; border-right: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">Models</h3>
    <p style="margin: 0; font-size: 15.5px;">Upload a model, keep versions of it, share it with collaborators and publish it to the Hub.</p>
  </div>
  <div style="padding: 22px 24px; background: #fbf7ef; border-right: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">Mounting</h3>
    <p style="margin: 0; font-size: 15.5px;">A Python UDF names a model version and reads it from a local folder. Files load lazily, so only the bytes your code reads are transferred.</p>
  </div>
  <div style="padding: 22px 24px; background: #fbf7ef;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">Custom Images</h3>
    <p style="margin: 0; font-size: 15.5px;">An administrator registers extra computing-unit environments for models with heavier requirements.</p>
  </div>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
Models in Texera
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Models live under <b>Your Work &rarr; Models</b>. You give a model a name and, if you like, record which framework trained it and how the weights are stored. Those are labels for people and for tools to read later.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A version can be a <b>single file or a whole folder</b>, since models arrive both ways &mdash; one checkpoint, or weights alongside a config file, a tokenizer and several shards. Upload files or folders, up to 2&nbsp;GB per file by default, and commit them together as one version.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay muted playsinline controls style="width: 90%; border-radius: 12px;">
    <source src="/videos/ml-models-upload.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Creating a model, uploading its files, and committing them as a version.
  </p>
</div>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/ml-models-detail.png" alt="A model's page showing its description, public and downloadable tags, version count and the path to its latest version file" style="width: 95%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">The model card: what the model is, and what a workflow needs in order to run it.</p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Once committed, a version never changes. That is what makes a workflow reproducible: it names a version, and that version means the same files a year later.
</p>

<div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px; margin: 22px 0;">
<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; margin: 0 0 16px;">
Key Capabilities
</h3>

<ul style="margin: 0;">
<li>Create a model and upload its files, singly or as a folder, from the browser</li>
<li>Commit a set of files as an immutable version, and keep a history of versions</li>
<li>Share a model with named collaborators, at read or write access</li>
<li>Publish a model to the Texera Hub, separately from whether it can be downloaded</li>
<li>Search and browse published models alongside workflows and datasets</li>
</ul>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 18px 0;">
Publishing and downloading are deliberately separate, so you can let people find and use a model without handing out the weights. Published models appear on the Hub and in search, and you can give one a cover image.
</p>


<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
Mounting a Model into Your Computing Unit
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
There is no "load model" step to configure. A Python UDF declares that one of its parameters names a model:
</p>

<pre style="background: #fbf7ef; border: 2px solid #14110f; border-radius: 10px; padding: 16px 18px; margin: 6px 0 24px; font-size: 14.5px; overflow-x: auto;"><code>class ProcessTableOperator(UDFTableOperator):

    @overrides
    def open(self):
        import joblib, os

        model_dir = self.UiParameter("MODEL", AttributeType.STRING,
                                     value=Resource.MODEL).value
        self.model = joblib.load(os.path.join(model_dir, "iris_rf.joblib"))</code></pre>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Texera reads that declaration and shows a model browser in the operator's property panel instead of a text box. You pick a model and a version there. When the workflow runs, the UDF receives a plain local folder path and reads files out of it like any other folder.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/ml-models-udf.png" alt="A Python UDF open in the editor, with the UiParameter line highlighted, beside the property panel showing a MODEL parameter whose value is the model version iris-species-rf v1" style="width: 100%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">The highlighted line in the script produces the <code>MODEL</code> parameter on the right, whose value is a model version rather than typed text.</p>
</div>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
<b>Nothing is downloaded.</b> The version is <i>mounted</i> into the machine running your code, and a file's contents only travel when your code actually reads them. Load one shard of a 40&nbsp;GB model and you transfer one shard.
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The design question underneath is who performs the mount. Mounting needs privileges, and the pod running a user's code should hold as few as possible. So a small separate program on each machine performs it and hands the finished read-only folder back, leaving that pod unprivileged. Before any of it happens, Texera confirms you may use that computing unit and may read that model, so a mount cannot reach something you could not already open.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/ml-models-mount.jpg" alt="Diagram: a workflow runs, the computing unit asks Access Control for a mount, the Texera Mounter runs GeeseFS against the file service, and the files appear in the pod" style="width: 100%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">The mount is performed outside the pod that runs your code, then handed in read-only.</p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The same mechanism carries datasets, since both are stored the same way &mdash; write <code>Resource.DATASET</code> instead.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
Custom Images for Computing Units
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Getting the weights to your code is half the job. The other half is code that can load them. The penguin model above needs xgboost, which the stock image does not carry; at the far end, something like AlphaFold 3 wants a particular Python version, tools that do not come from pip, and a compile step.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
An administrator can therefore register extra computing-unit environments. They paste a link to a published image, Texera checks it is a valid Texera computing-unit image and pins the exact version, and it appears as a dropdown when someone creates a computing unit. Pick one and your unit runs that environment; the choice applies to that unit alone and is fixed for its lifetime.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 90%; border-radius: 12px;">
    <source src="/videos/ml-models-curated-image.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Registering an image, and watching it validate before anyone can select it.
  </p>
</div>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/ml-models-image-picker.png" alt="The Create Computing Unit dialog with an Image dropdown listing Default and Python ML (xgboost)" style="width: 92%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">Choosing an environment when creating a computing unit.</p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Two details make this safe to leave switched on. The version is pinned when the image is registered, so its contents cannot be swapped out afterwards. And because these images come from outside the project, a unit started from one runs with reduced permissions. Registered images are also pulled onto each machine ahead of time, so starting a unit from one does not wait on a download.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
End to End
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px;"><b>1.</b> Create a model, upload its files, and commit them as a version.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px;"><b>2.</b> Create a computing unit, choosing an environment that can load it.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px;"><b>3.</b> In a Python UDF, declare a parameter with <code>value=Resource.MODEL</code> and pick your model and version in the property panel.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px;"><b>4.</b> Run the workflow. The version is mounted, and your UDF loads it from a local folder.</td>
</tr>
</tbody>
</table>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay muted playsinline controls style="width: 90%; border-radius: 12px;">
    <source src="/videos/ml-models-demo.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Creating a computing unit, naming a model version from a UDF, running the workflow, and reading the output.
  </p>
</div>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 56px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Where This Goes Next
</h2>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto 22px; max-width: 680px;">
Next is agreeing a standard layout for a model, so Texera can load one without being told how &mdash; and on top of that, an operator that runs a model over a table with no code at all. Development happens on GitHub, and design discussion there and on <a style="color: #f4efe6; font-weight: bold;" href="https://lists.apache.org/list.html?dev@texera.apache.org">dev@texera.apache.org</a>.
</p>

<a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; letter-spacing: .04em; text-decoration: none; padding: 14px 30px; border-radius: 999px; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15px;" href="https://github.com/apache/texera/issues/6494" target="_blank" rel="noopener">Read the design on issue #6494</a>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
If you have a model and a Texera deployment, turn it on and tell us where it falls short.
</p>

</div>
