---
title: "Introducing the Hugging Face Operator in Texera"
linkTitle: "Hugging Face Operator"
slug: "hugging-face-operator"
date: 2026-11-24
author: Prateek Ganigi, Julie Cao, Anish Shivamurthy and Elliot Lin, mentored by Matthew Ball and Xuan Gu, advised by Chen Li
description: "A new operator runs pretrained models from the Hugging Face Hub as a workflow step: pick a task, pick a model, and get one result per row without writing code."
images:
  - /images/blog_hero/hugging-face-operator-hero.png
tags: ["hugging-face", "operators", "machine-learning", "inference"]
---

<div style="max-width: 100%; width: 100%; margin: 0 0 32px;">
  <img src="/images/blog_hero/hugging-face-operator-hero.png" alt="A Texera workflow with a Text Input operator feeding the Hugging Face operator, the operator's result table showing a prompt column and the new hf_response column, and its property panel open on the right" style="width: 90%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
</div>

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Texera has a new operator named Hugging Face. It runs a pretrained model from the Hugging Face Hub as a step in a workflow: a table goes in, the model is called once for each row, and the table comes out with one new column holding the results.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
Setting it up takes two choices, a task and then a model. The property panel shows only the settings that task needs, and the result column feeds the next operator like any other column. No code is involved.
</p>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(230px, 1fr)); border: 2px solid #14110f; margin: 32px 0 8px;">
  <div style="padding: 22px 24px; background: #fbf7ef; border-right: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">Pick a Task</h3>
    <p style="margin: 0; font-size: 15.5px;">Twenty tasks across text, images, audio, media generation and question answering. The panel shows only the fields the chosen task needs.</p>
  </div>
  <div style="padding: 22px 24px; background: #fbf7ef; border-right: 2px solid #14110f;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">Browse Models</h3>
    <p style="margin: 0; font-size: 15.5px;">Browse or search the Hub's models for that task from inside the editor, limited to models with hosted inference.</p>
  </div>
  <div style="padding: 22px 24px; background: #fbf7ef;">
    <h3 style="font-family: Georgia,'Times New Roman',serif; font-size: 22px; color: #c8451f; margin: 0 0 10px;">One Result per Row</h3>
    <p style="margin: 0; font-size: 15.5px;">Each input row becomes one request, and the answer lands in a new column for the next operator to use.</p>
  </div>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
The Problem
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The Hugging Face Hub hosts pretrained models for tasks ranging from text generation to speech recognition, and many of them can be called over the network without being downloaded. Until now, a Texera user had two ways to use one in a workflow.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The first was one of four operators added in 2024: Sentiment Analysis, Spam Detection, Text Summarization and Iris Logistic Regression. Each does one job with one fixed model. They cover those four jobs and offer nothing for any other task or any other model.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The second was a Python UDF that calls the model directly. That means handling the access token, building the request in the shape the task expects, encoding any image or audio, reading the answer out of the response, and deciding what happens when one row fails. The request and the response look different for each kind of task, so code written for a text model does not carry over to an image model.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
Choosing a model should be a setting on an operator, not a programming task.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
One Operator, Twenty Tasks
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The new operator is named <b>Hugging Face</b> and sits in the Hugging Face group of the operator menu, beside the four older ones. It is part of <a style="color: #c8451f; font-weight: bold; text-decoration: none;" href="/releases/1.3.0-incubating/">Apache Texera 1.3.0-incubating</a>. It takes one input table and produces one output table: the same rows, plus a result column named <code>hf_response</code> unless you choose another name.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
You pick a <b>task</b> first, then a <b>model</b> for that task. Everything else in the panel follows from the task, so a setting that does not apply is not shown. Text generation shows Prompt Column, System Prompt, Max New Tokens and Temperature. Automatic speech recognition shows Audio Upload and Input Audio Column, and no prompt. Question answering adds a Context Column, and zero-shot classification adds Candidate Labels.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/hugging-face-operator-fields.png" alt="The Hugging Face operator's property panel shown twice: with the Text Generation task it lists Prompt Column, System Prompt, Max New Tokens and Temperature, and with the Automatic Speech Recognition task it lists Audio Upload and Input Audio Column instead" style="width: 100%; max-width: 860px; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">The same operator with two different tasks selected. The fields change with the task.</p>
</div>

<div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px; margin: 22px 0;">
<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; margin: 0 0 16px;">
Key Capabilities
</h3>

<ul style="margin: 0;">
<li>Run a model from the Hugging Face Hub as a workflow step, with one result per input row</li>
<li>Choose from twenty tasks across text, image, audio, media generation, and question answering and ranking</li>
<li>Browse or search the models for a task without leaving the editor</li>
<li>Supply images and audio by uploading a file in the panel or by reading them from a column</li>
<li>Open a result row to view image, audio and video results as media</li>
</ul>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 18px 0;">
The twenty tasks fall into five families:
</p>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Text.</b> Text generation.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Image.</b> Image classification, zero-shot image classification, object detection, image segmentation, image-to-text, image-text-to-text, image-to-image, visual question answering, document question answering.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Audio.</b> Automatic speech recognition, audio classification, text-to-speech.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Media generation.</b> Text-to-image, text-to-video.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Question answering and ranking.</b> Question answering, table question answering, zero-shot classification, sentence similarity, text ranking.</td>
</tr>
</tbody>
</table>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
Choosing a Model
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The Task dropdown lists the tasks that currently have at least one model with hosted inference on the Hub, so it can show fewer than twenty. Below it, a model browser lists the models for the selected task, most downloaded first, with each model's download and like counts. Typing in the search box searches the Hub's models for that task, and clicking a model selects it.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/hugging-face-operator-model-browser.png" alt="The Hugging Face operator's property panel with the Task dropdown set to Text-to-Image, a search for FLUX.1-dev in the search box, and a paged list of matching models showing download and like counts, with one model selected" style="width: 100%; max-width: 380px; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">Picking a task, then a model for it, in the property panel.</p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The browser shows only models with live hosted inference, because those are the ones the operator can call. Both lists come from the Texera backend, which reads them from the Hub's public API, so your browser never calls Hugging Face directly.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Running a model needs a Hugging Face access token. It goes in the operator's HF API Token field, which is masked.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
See It in Action
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The example below generates an image from each prompt in a table. A column of prompts goes in with the Text-to-Image task, and each row comes back with a generated image in the result column. Open a row of the result table and the image itself is displayed. Audio and video results, from text-to-speech and text-to-video, are shown the same way with a player.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 90%; border-radius: 12px;">
    <source src="/videos/hugging-face-operator-text-to-image.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Running a Text-to-Image model over a column of prompts and opening a row to see the generated image.
  </p>
</div>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/hugging-face-operator-result-image.png" alt="The row details for one row of a text-to-image run, showing the prompt and the generated image displayed as a picture" style="width: 100%; max-width: 520px; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">A generated image shown in a result row's details.</p>
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">The same steps for other tasks</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Tasks that take media as input are set up the same way: a task, a model, then the input.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<b>Classifying a column of images.</b> The input table has one image per row, held in a column as a link or as encoded image data. Select the Image Classification task, pick a model, and set Input Image Column to that column. There is no prompt to write, so Prompt Column is not shown. Each row's image is sent to the model, and the result column holds the model's response for that image as JSON text, which a downstream operator can parse.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<b>Transcribing an uploaded recording.</b> Select Automatic Speech Recognition and the panel switches to audio inputs: Audio Upload and Input Audio Column. Upload a recording and the panel shows a player, so you can check it is the right file before running anything. Run the workflow and the transcript arrives as text in the result column.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
What to Expect
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The operator calls hosted inference. It does not download a model or run one on your computing unit: each row is a request sent over the network with your token, and the answer comes back in the response. The computing unit does not need the memory to hold the model. It does need to reach Hugging Face.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A model on the Hub can be served by more than one inference provider. Before sending anything, the operator asks the Hub which providers are live for the chosen model. It then tries them in a built-in cheapest-first order through Hugging Face's router, and moves to the next provider on errors such as a rate limit or an unavailable provider.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Rows are processed one at a time, so a run takes longer as the table grows. If one row's request fails, that row's result holds a short error message and the operator carries on with the remaining rows.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Images and audio can come from two places. A file uploaded in the panel is used for every row. A column gives each row its own file, and a cell can hold a data URL, an https link, or base64-encoded data. If both are set, the upload is used.
</p>

<div style="background: #fbf7ef; border: 1.5px solid #d8cfbf; border-radius: 12px; padding: 24px 26px; margin: 22px 0;">
  <h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 0 0 14px;">Good to know</h3>
  <ul style="margin: 0; padding-left: 22px; font-size: 16px;">
    <li style="margin-bottom: 8px;">A Hugging Face token is required to run the operator.</li>
    <li style="margin-bottom: 8px;">Models are called over the network. Nothing is downloaded to your computing unit or run on it.</li>
    <li style="margin-bottom: 8px;">The model browser lists only models with live hosted inference for the chosen task.</li>
    <li style="margin-bottom: 8px;">Results are written as text into one new column. Give it a name the input table does not already use.</li>
    <li style="margin-bottom: 8px;">System Prompt, Max New Tokens and Temperature apply to text generation only.</li>
    <li>The four operators from 2024 are still available.</li>
  </ul>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">06</span>
Under the Hood
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #5b5347; margin: 0 0 8px; padding: 14px 18px; background: #fbf7ef; border-radius: 10px;">
This section covers how the operator is put together. Nothing in it is needed in order to use the operator.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">Generated Python, one task family at a time</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The operator generates a Python table operator that runs in Texera's Python worker and processes the input table row by row. Each of the five task families supplies two pieces: how to build the request for its tasks, and how to read the response.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A shared template wraps those two pieces with the parts every task needs: resolving providers and falling back between them, reading media from an upload or a column, and writing the result column. Adding a task family means adding one small piece, without touching the others.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">A backend proxy for the editor</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A small REST resource in the Texera backend serves the property panel and the result view. It has three endpoints:
</p>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b><code>/tasks</code></b> returns the tasks that have hosted inference.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b><code>/models</code></b> returns the models for a task, browsed or searched, limited to ones with live inference.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b><code>/media-proxy</code></b> lets the result view display media results that are held at a remote address.</td>
</tr>
</tbody>
</table>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The task list and each task's browse list are cached for an hour, so opening the panel does not ask the Hub the same question again each time.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">The property panel</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
On the frontend, the operator adds a task selector and model browser, image and audio upload components, and the rules that show or hide each field for the selected task.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">The pull requests</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The core of the operator landed in these pull requests:
</p>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Backend proxy.</b> Model browsing and the media proxy.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5124" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5124</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Operator core.</b> Per-task code generation, with text generation as the first task.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5278" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5278</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Image tasks.</b> The image task family.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5320" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5320</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Audio and media generation.</b> The audio and media-generation task families.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5570" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5570</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Question answering and ranking.</b> The question-answering and ranking task family.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5574" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5574</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Task selector and model browser.</b> The component that picks a task and a model.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5566" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5566</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Audio upload.</b> The audio upload component.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5567" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5567</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Task-aware fields.</b> Showing and hiding fields in the property panel by task.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5568" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5568</span></a></td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Tests.</b> Unit tests for the operator's descriptors.
<a style="text-decoration: none;" href="https://github.com/apache/texera/pull/5898" target="_blank" rel="noopener"><span style="font-size: 12.5px; font-weight: bold; color: #c8451f; background: rgba(200,69,31,.10); padding: 1px 7px; border-radius: 5px; white-space: nowrap; margin-left: 6px;">PR #5898</span></a></td>
</tr>
</tbody>
</table>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 56px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Learn More
</h2>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto 24px; max-width: 720px;">
The operator was proposed and designed in one issue, which is still open and is the place to follow what comes next. Development happens on GitHub, and design discussion takes place there and on <a style="color: #f4efe6; font-weight: bold;" href="https://lists.apache.org/list.html?dev@texera.apache.org">dev@texera.apache.org</a>.
</p>

<div style="display: flex; flex-wrap: wrap; gap: 12px; justify-content: center;">
  <a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/issues/5041" target="_blank" rel="noopener">Read the design on issue #5041</a>
  <a style="display: inline-block; background: #f4efe6; color: #2a241d; font-weight: 800; text-decoration: none; padding: 12px 22px; border-radius: 999px; font-size: 14px;" href="https://github.com/apache/texera/tree/main/common/workflow-operator/src/main/scala/org/apache/texera/amber/operator/huggingFace" target="_blank" rel="noopener">Browse the operator source</a>
</div>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
If you have a Hugging Face token and a Texera deployment, try a model on your own data and tell us how it goes.
</p>

</div>
