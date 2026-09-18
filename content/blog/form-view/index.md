---
title: "Form View: Running a Workflow Without the Canvas"
linkTitle: "Form View"
slug: "form-view"
date: 2026-09-17
author: Yang Zhang and Meng Wang, advised by Professor Chen Li
description: "A workflow can now be opened as a form. The author marks which operator properties a reader may change, and the reader fills them in, runs the workflow, and reads the results, without meeting the canvas."
images:
  - /images/blog_hero/form-view.png
tags: ["form-view", "workflows", "ui", "collaboration"]
---

<div style="max-width: 100%; width: 100%; margin: 0 0 32px;">
  <img src="/images/blog_hero/form-view.png" alt="A quality-control workflow open in the Form View: the author's instruction, one folder input, a Run button with a computing unit, and the collapsed workflow preview" style="width: 90%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
</div>

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
A Texera workflow has had one face: the operator canvas. That is the right tool for the person who built the pipeline. It is more than the next person needs, the one who wants to point the analysis at a different file, change a threshold, press Run, and read what comes out. Texera now gives a workflow a second view. The author marks which operator properties a reader may change, and those become a form.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
The form is a lens, not a copy. It edits the same workflow the canvas does, in the same co-editing session, so there is nothing to keep in sync and nothing to publish. A workflow can be opened either way, and either view can hand over to the other at any time.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #5b5347; margin: 0 0 8px; padding: 14px 18px; background: #fbf7ef; border-radius: 10px;">
This post has two halves. The first shows what the Form View does, with no assumptions about Texera's internals. The second covers how it is built and the problems that shaped it, for readers who want that.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
The Problem
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A finished workflow is usually run far more often than it is edited, and usually by someone other than its author. A biologist handed a quality-control pipeline does not need to see twenty operators wired together. They need to know which two boxes are theirs to fill in.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The canvas gives them everything instead. Every operator is open, every property of every operator is editable, and nothing on screen distinguishes the input file they are meant to change from the batch size they are not. The cost is not only confusion. A reader exploring the canvas can move an operator, edit a property that was tuned deliberately, or delete a link, and the workflow they were given is no longer the workflow that was tested.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
The author already knows which properties matter to a reader. The Form View is a place to write that knowledge down, so the reader does not have to reconstruct it.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
Choosing What the Form Shows
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Authoring happens in the property panel the author already uses. Opening an operator shows a tick box beside each property that can become a field. Ticking one exposes it: it appears in this workflow's form. Nothing else about the operator changes, and the property keeps working on the canvas exactly as before.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 70%; border-radius: 12px;">
    <source src="/videos/form-view-expose.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Ticking a property in the operator panel turns it into a field in the form.
  </p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A property name that reads well beside an operator often reads badly on its own, so the form has an edit mode of its own. In it the author renames a field, writes a line of help under it, reorders the fields by dragging, and takes a field back out. A nested or repeated input has its own sub-fields, and those can be renamed or hidden one at a time, so a reader is asked for the two parts of a setting that are theirs and not the four that are not. The author can also write an instruction in Markdown above the whole form, which is where the sentence explaining what the workflow is for belongs.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 70%; border-radius: 12px;">
    <source src="/videos/form-view-authoring.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Renaming a field, adding help text, reordering, and writing the instruction above the form.
  </p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Results are chosen the same way. By default the form shows the results of the workflow's terminal operators, which is what a reader almost always wants. An author who cares about an intermediate result can feature it as well, and the choice is stored with the workflow rather than being inferred each time.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
Using the Form
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A reader opening the workflow sees the instruction, the fields the author exposed, and a Run button. The fields are the operator panel's own controls, so a dataset input is still a dataset picker, an attribute selector still lists the upstream columns, and a nested or repeated input still expands the way it does on the canvas. Filling one in writes straight to the operator property behind it, so what runs is what the reader sees.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Running works the way it does on the canvas, because it is the same machinery: the same computing-unit selector, the same run and stop states, the same errors. The form remembers which computing unit the workflow last ran on, so a reader who only ever uses one does not have to choose it again. Results appear below the form as cards as they arrive.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 70%; border-radius: 12px;">
    <source src="/videos/form-view-run.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Filling in the exposed inputs, running on a computing unit, and reading the results.
  </p>
</div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The workflow itself is still there for a reader who wants to look. A collapsed strip opens a read-only picture of the graph, and clicking a step in it opens that step's settings, also read-only. The point is to let a reader answer "what does this actually do" without giving them a canvas they can rearrange.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/form-view-preview.png" alt="The form with its workflow preview expanded, showing the five steps the workflow runs" style="width: 90%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">The same form with the workflow preview expanded. The steps are visible and not editable.</p>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
Two Views of One Workflow
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Every workflow can be opened either way. Which one it opens in is a per-workflow preference the author sets, stored on the workflow itself, so the dashboard can send a card straight to the view its author intended. A workflow that is meant to be used opens as a form; a workflow that is still being built opens on the canvas.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The preference is a default, not a restriction. Both views carry a switch to the other, and neither is a copy of anything: the same workflow, the same co-editing session, the same saves. An author can expose a property on the canvas, switch to the form to see how it reads, rename it there, and switch back.
</p>

<div style="margin: 40px 0; text-align: center;">
  <video autoplay loop muted playsinline controls style="width: 70%; border-radius: 12px;">
    <source src="/videos/form-view-switch.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    Opening a workflow in its default view, and switching between the two.
  </p>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
What It Does Not Do
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The form is a lens over one workflow, not a per-reader sandbox. A value typed into it is written to the workflow, the way a value typed into the operator panel is. Two people filling in the same form are editing the same properties, and the second Run uses whatever the fields hold at that moment. For a workflow shared with a group who each want their own parameters, the answer today is a copy of the workflow per person, not one form serving all of them. Giving a reader a private set of values is the largest open question in the design.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
It is also not a permission boundary. Read-only is how the page behaves, not a rule the server enforces differently: a reader who could edit the workflow on the canvas can still do so by opening the canvas. The Form View narrows what is in front of someone; sharing settings decide what they are allowed to do.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Two property types are not fully at home in a form yet, and the shipped behaviour is a stated fallback rather than a surprise. A code property cannot be exposed at all: the code editor is not an inline control but a button that opens Monaco into a host the workspace owns, and the form has no such host, so the tick box is not offered for it. Projection's drag-to-reorder list is offered, but renders in the form as a plain repeated list, without the drag. Both are tracked in <a style="color:#c8451f;" href="https://github.com/apache/texera/issues/8439">issue #8439</a>, along with a fuller form mode for the HuggingFace model picker.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 34px 40px; margin: 56px 0 44px; text-align: center;">
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 13px; font-weight: 800; letter-spacing: .12em; text-transform: uppercase; color: #c9a227; margin: 0 0 10px;">
Part Two
</p>
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 30px; margin: 0 0 12px; color: #fbf7ef;">
Under the Hood
</h2>
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto; max-width: 680px;">
Everything above is what the Form View does and where it stops. What follows is how it is put together, and the problems that shaped it. Nothing below is needed in order to use the feature.
</p>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">06</span>
How It Is Built
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The Form View is one page, <code>WorkflowFormComponent</code>, on a route beside the canvas. It owns no model of its own. The graph, the run machinery, the result services and the property panel's field rules are the canvas's, and the page is a different arrangement of them. That is why a dataset picker in the form behaves like a dataset picker on the canvas: it is the same control, reached through the same operator schema and the same custom formly types, rather than a second rendering of the same JSON Schema that would drift from the first.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
What the form adds is a definition of itself, <code>formBinding</code>, stored in the workflow's content beside <code>settings</code>. It is a list of bindings, each naming an operator, the property key it writes to, a display name, optional help text, and per-sub-field overrides keyed by field path with array indices dropped, so one entry covers every row of a repeated input. Plus an optional Markdown instruction and <code>shownResultIds</code>. Keeping it in the content means it is exported, imported, versioned, cloned and shared with the workflow for free, with no second thing to keep in step.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Which view a workflow opens in is the deliberate exception. It is a <code>default_view</code> column, not a field inside the content, because the dashboard needs it for every workflow it lists. A column can be selected and ordered by; a field inside a JSON blob would have to be parsed for every row of every listing.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The feature shipped as a stack of seventeen pull requests under one issue, bottom-up, the last of which turned the flag on. Every one of them was mergeable on its own and none changed anything a user could see until that last one. The load-bearing pieces:
</p>

<div style="margin: 24px 0 30px; padding: 0 0 0 20px; border-left: 3px solid #e0d9cc;">
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; margin: 0 0 14px;">
<strong>1. The property panel decides what is exposable.</strong> The tick box and the exposability rules live with the operator schema, so the form never has its own opinion about which properties can become fields. <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8318">PR #8318</a>, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8436">#8436</a>
</p>
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; margin: 0 0 14px;">
<strong>2. Fields render and write back through formly.</strong> An exposed binding becomes a formly field; editing it writes to the operator property, including nested objects and repeated arrays. <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8437">PR #8437</a>, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8438">#8438</a>
</p>
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; margin: 0 0 14px;">
<strong>3. Running is the canvas's state machine.</strong> The run button, the computing-unit selector and the error reporting are the canvas's, not a copy, so a state the canvas can reach is a state the form can reach. <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8440">PR #8440</a>
</p>
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; margin: 0 0 14px;">
<strong>4. Edit mode authors the form in place.</strong> Rename, help text, reorder, remove, the Markdown instruction and the result choice, all written into <code>formBinding</code>. <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8516">PR #8516</a>, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8517">#8517</a>
</p>
<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; margin: 0;">
<strong>5. Entry points and the default view.</strong> The dashboard, the route and the switch in the canvas menu, plus remembering the computing unit a workflow last ran on. <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8456">PR #8456</a>
</p>
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">07</span>
Problems That Came Up
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>Read-only is not one door.</strong> The preview canvas is mounted with its structure locked, but the lock has to reach everywhere the canvas can be acted on, and it did not. A right-click on the preview still offered cut, paste and delete, because the context menu read the graph's modification flag rather than the preview's own lock. That flag is global and other code writes it: when a run reaches a terminal state the execute service re-enables modification unconditionally, looking only at whether the workflow is read-only, which handed a reader an editable graph the moment their run finished. The form now clamps it back on a microtask after any such unlock. And Angular's <code>form.disable()</code> does not reach a drag handle or an array's add and remove buttons, which are plain buttons outside the form, so the read-only form needed <code>inert</code> over the container plus a tabbable wrapper so a keyboard user can still scroll what they cannot edit.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>Two lists that disagree cannot both be right.</strong> Which results to show started as two lists, one of featured steps and one of hidden ones. Nothing keeps two such lists consistent: an author who features an intermediate step and then deletes everything downstream of it leaves a step that is both featured and now terminal, and a rule written over two lists has to guess. It is one list now, <code>shownResultIds</code>, and the shape carries the meaning: absent means the default, every terminal step, and present means exactly these, with the empty list meaning none. The cost is stated rather than hidden, namely that a step which becomes terminal after the author has chosen does not appear by itself.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>A workflow that never met the Form View must be written back unchanged.</strong> <code>formBinding</code> rides in the content, and the content is compared, cloned and exported. If opening any workflow added an empty <code>formBinding</code> key, every workflow in the system would come back subtly different from how it went in. The service remembers whether the content it loaded carried the key and re-emits it only when it did, or when an author has since put something in it. The same care applies to export: the downloaded file carries <code>defaultView</code> alongside the content, which meant one shared helper for the exported shape, because the dashboard's download and the canvas menu's own export are two producers of it and the second was missed the first time.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">08</span>
Still in Flight
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Three more came out of building the feature and are fixed in review rather than shipped. They are worth stating plainly, because each is a case where the Form View made an existing seam visible rather than introducing one.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>The form definition is private, so two editors can overwrite each other.</strong> Texera's graph is a shared Yjs document, but <code>formBinding</code> and <code>settings</code> sit outside it, as fields each browser holds privately. Autosave writes the whole content, so a co-editor whose private copy is stale puts it back on their next canvas edit, and one author's renames disappear with no conflict and no warning. Moving both into a shared map beside the graph fixes the lost update, and raises a second one: seeding the database's copy into a document that has not finished syncing with the room is a concurrent whole-value write, and Yjs settles those by client id rather than by recency, which is the same lost update wearing a different hat. The seed therefore waits for the room's first sync, writes only when the key is still absent, and never deletes a value that arrived from the room. The wait is bounded so an unreachable sync server still ends with the value in the document, and the database copy is read from while the seed waits, so the page is never blank and an autosave in that window does not save an empty one. <em>In review, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8351">PR #8351</a>.</em>
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>A save's answer can undo a rename.</strong> Every save's response is applied back as the workflow's metadata, and saves go out one at a time. Rename a workflow while an earlier save is in flight and that save's answer, carrying the name it was sent with, arrives last and wins. Rename during the view switch's save and the rename is lost outright, because the switch left as soon as its own save completed and the page load aborted the one queued behind it. The rule belongs in the one service every save passes through: each response is relayed with the page's current name and description in place of its own, and the switch waits for the whole save queue to drain rather than only for its own save. <em>In review, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8540">PR #8540</a>.</em>
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
<strong>Switching views is still a full page load.</strong> The switch reloads the browser, which throws away the shared document, the computing unit connection and the execution state, then rebuilds all of it on the other side, including an Angular bootstrap that blocks on the config endpoint and a re-fetch of operator metadata a root singleton already had. It was chosen because handing over in process left stale state attached, and the most interesting piece of that turned out to be a leak that predates the Form View: a JointJS paper binds to the root-provided graph and nothing ever disposes one, so every remount leaves another paper listening to that graph from a detached node, competing for the pointer events that decide whether an operator can be dragged. <em>In review, <a style="color:#c8451f;" href="https://github.com/apache/texera/pull/8581">PR #8581</a> and <a style="color:#c8451f;" href="https://github.com/apache/texera/issues/8582">issue #8582</a>.</em>
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">09</span>
Turning It On
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The Form View is on by default, behind the <code>form-view-enabled</code> configuration flag. With it off, every entrance closes together: the tick box in the property panel, the switch in the canvas menu, the dashboard's per-card control, and the route itself, which hands anyone who reaches it back to the canvas without loading anything. A workflow whose stored preference is the form opens on the canvas instead. A deployment that does not want a second view turns it off and sees nothing of it.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Nothing has to be migrated. A workflow with no form definition opens as a form with no fields, which is the correct answer for a workflow whose author has not chosen any, and its content is written back byte for byte as it was, so a workflow that never meets the Form View is not changed by its existence.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 36px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Where This Goes Next
</h2>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto 22px; max-width: 680px;">
Two lines of work are open. The first is the widgets: the more elaborate canvas controls should render in a form as well as they do beside an operator. The second is the harder one, a reader's own set of values, so that one shared workflow can serve several people at once without them overwriting each other. Development is tracked on GitHub, and design discussion happens there and on <a style="color: #f4efe6; font-weight: bold;" href="https://lists.apache.org/list.html?dev@texera.apache.org">dev@texera.apache.org</a>.
</p>

<a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; letter-spacing: .04em; text-decoration: none; padding: 14px 30px; border-radius: 999px; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15px;" href="https://github.com/apache/texera/issues/8011" target="_blank" rel="noopener">Follow the work on issue #8011</a>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
If you have a workflow that other people run, the project would like to know which of its properties you exposed, and which ones you wanted to and could not.
</p>

</div>
