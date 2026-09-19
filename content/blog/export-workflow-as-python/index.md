---
title: "Taking a Workflow Out of Texera as a Python Script"
linkTitle: "Workflow to Python Script"
slug: "export-workflow-as-python"
date: 2026-09-18
author: Kary Zheng, advised by Professor Chen Li
description: "Texera can now hand a user the workflow they built as a single standalone Python file, and every operator that does so is checked by running it both ways and comparing the results."
images:
  - /images/blog_hero/workflow-to-python-export.jpg
tags: ["python", "export", "pandas", "verification", "workflows"]
---

<div style="max-width: 100%; width: 100%; margin: 0; font-family: 'Helvetica Neue',Arial,sans-serif; color: #14110f; background: #ffffff; line-height: 1.65;">

<div style="padding: 44px 44px 8px; background: #ffffff;">

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: #c8451f; margin: 0 0 28px;">
Feature Introduction &middot; Apache Texera
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
A workflow built on the Texera canvas can be run, shared and read, but only inside Texera. A user who wants to keep a pipeline after the fact, hand it to a colleague who does not run Texera, or step through it in a notebook has had nothing to take away. Texera is gaining an export that closes that gap: given a workflow, it produces a single Python file that reads the same sources, applies the same operators in the same order, and prints its results.
</p>

<p style="font-family: Georgia,'Times New Roman',serif; font-size: 21px; line-height: 1.5; margin: 0 0 20px;">
The harder half of the work is not the export. It is the question that follows it. A script that looks like the workflow is worth very little if it quietly computes something else, so every operator that knows how to export itself is run twice, once through the Texera engine and once as the generated Python, and the two answers are compared.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #5b5347; margin: 0 0 8px; padding: 14px 18px; background: #fbf7ef; border-radius: 10px;">
This post has two halves. The first shows what the export does, with no assumptions about Texera's internals. The second covers how it works and how it is kept honest, for readers who want that. The feature is rolling out one operator family at a time under <a style="color: #c8451f; font-weight: bold;" href="https://github.com/apache/texera/issues/8325">issue #8325</a>.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">01</span>
The Problem
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Texera operators already describe their work as Python. That is how the engine runs many of them: an operator hands the Python worker a block of code, and the worker executes it against the tuples it receives. The pieces of a script are therefore already in the system. What has been missing is a form of that description that stands on its own, without the runtime around it, and something to stitch the pieces into one file.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">Two descriptions of the same work</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The two forms are not the same code. The engine's version receives tuples and yields tuples, and it can rely on the worker for its inputs, its schema and its output ports. A standalone version gets none of that. It has to name its own inputs and outputs, read its own file, and produce a data frame that the next block can read. Most operators can express both, but only if each one is asked to write the second form deliberately rather than having it inferred from the first.
</p>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
An export that is almost right is worse than no export. The user cannot tell by reading it, and a script that runs to completion with the wrong numbers will be believed.
</div>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">02</span>
Exporting a Workflow
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
In the workspace toolbar there is a button marked with a code icon, titled <b>export as Python script</b>. It sends the workflow the user currently has open to the compiling service and shows the script that comes back, with a copy button beside it. Nothing about the workflow changes, and nothing has to be running first.
</p>

<div style="margin: 34px 0;">
  <img src="/images/blog_hero/workflow-to-python-toolbar.png" alt="The workflow toolbar, with the export control sixth from the left" style="width: 60%; height: auto; display: block; margin: 0 auto; border-radius: 6px;">
  <p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; color: #5b5347; margin: 12px 0 0; text-align: center;">
    The sixth control, between the download and the info buttons.
  </p>
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">What comes back</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
A small workflow makes the result concrete. Take a CSV file scan, a filter on one column, a sort on another, a limit, and a projection that renames a column. This is what the button hands back:
</p>

<div style="margin: 40px 0; text-align: center;">
  <img src="/images/blog_hero/workflow-to-python-export.jpg" alt="The Texera workspace with the export modal open, showing the Python script generated from a five-operator workflow" style="width: 100%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    The script the workflow on the canvas produced, ready to copy. Every line names the operator above it.
  </p>
</div>


<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
It is plain pandas. There is no Texera import, no runtime to install and no configuration file beside it. Each operator appears as a comment naming the operator that produced the line below it, which is what makes the script readable next to the canvas it came from. Only pandas is imported for every script; everything beyond it is asked of the operators actually in the plan, so a workflow that draws no chart never imports a plotting library. Two lines are there because the engine does the same thing: the filter guards against a null, which is how the engine's own filter answers a null field, and the scan renames its columns to the names the schema gave them, which is what every downstream operator was configured against.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">What the export guarantees</h3>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>One file, in run order.</b> The script reads top to bottom in the order the workflow executes, with a comment naming the operator behind every block.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>No dependency on Texera.</b> Plain pandas and Plotly, so the script runs wherever those are installed.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Every branch is printed.</b> Any output that no other operator consumes is printed at the end, labelled with the operator it came from.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>A gap is marked, not guessed.</b> An operator with no standalone form yet leaves a comment where its line would be, so the script stops at the gap instead of running on quietly.</td>
</tr>
</tbody>
</table>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">03</span>
How the Translation Works
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
An operator says how it reads outside the engine by implementing one trait, <code>StandaloneCodeGenerator</code>. Its central method returns a block of pandas, and beside it an operator can name the imports it needs, helper definitions to emit once for the whole script, and, for a source, the file it reads. The block does not know the names of any variables. It refers to its inputs and outputs by position, as <code>in1df</code> and <code>out1df</code>, and the translator substitutes real names later. Sort's whole implementation builds a column list and an ascending list and emits one <code>sort_values</code> call.
</p>

<div style="margin: 40px 0; text-align: center;">
  <img src="/images/blog_hero/workflow-to-python-translation.png" alt="The export path from the editor through the compiling service to a standalone script" style="width: 90%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    The editor posts the plan, the translator walks it and asks each operator for its block, and the script comes back to the UI.
  </p>
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">One variable per output port</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The translator walks the plan in topological order, gives every output port of every operator its own variable, and replaces each block's placeholders with the variables its upstream neighbours were given. Working at the level of ports rather than operators is what makes an operator with two outputs, such as Split, come out right: each of its ports carries a different data frame to a different consumer. Inputs are resolved in the consuming operator's port order rather than the order the links happen to appear in the plan, so the build side and the probe side of a join cannot be swapped by how the user drew the edges.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
At the end the translator finds every port that no link consumes and prints it. A workflow with one terminal operator prints once; a workflow that branches prints each branch, labelled with the operator it came from.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">An operator with no standalone form</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
This is the case worth being careful about. The translator writes a comment saying that the operator is not supported and names the variables that would have held its outputs. The script then fails where the gap is, loudly, instead of running to completion on a silently different pipeline. That is what makes the export useful before every operator implements the trait.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">04</span>
Checking That the Script Agrees
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Every operator that implements the trait now has two descriptions of its own behaviour, and nothing forces them to agree. Reviewing the two side by side does not scale, and it does not catch the cases that only appear on real data: how a null sorts, what an empty group produces, whether a column of integers survives a round trip with its type intact.
</p>

<div style="margin: 40px 0; text-align: center;">
  <img src="/images/blog_hero/workflow-to-python-verification.png" alt="The verification harness: one operator is run through the engine and as generated Python from the same input, and comparators check the two outputs port by port" style="width: 100%; height: auto; display: block; margin: 0 auto; border-radius: 12px;">
  <p style="font-size: 14px; color: #666; margin-top: 10px;">
    The same operator, the same input, two paths. The engine's answer is the reference the generated script is measured against.
  </p>
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">Run it two ways, compare the outputs</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
One path drives the operator through the engine's own execution, the way a running workflow would. The other takes the generated block, wraps it in a script, and runs it in a Python subprocess. The comparison is per output port and by kind of data: tables column by column with their types, models by the columns they carry, and a chart by the HTML the two paths drew. The suite reports one result per operator, named so that it says which operator it was and how its input was configured.
</p>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
On the most recent full run the suite covered <b>153 operators</b>, and <b>148 agreed on both paths</b>. The other five are withheld, and each states its reason in the report rather than being quietly absent.
</p>

<table class="td-initial" style="border: 2px solid #14110f; border-collapse: collapse; margin: 6px 0 26px; width: 100%;" role="presentation" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>Two score or predict from a fitted model</b> that arrives on an input port, and a fixture written from the JVM cannot carry a live model object.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>One reads file names that arrive at run time</b> on an input port, which this runner does not feed to a source.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; border-bottom: 1px solid #e3dccd; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>One fetches a live URL</b> over the network, so it has no fixed answer to compare against.</td>
</tr>
<tr>
<td style="padding: 16px 18px; background: #fbf7ef; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15.5px; vertical-align: top;"><b>One is a placeholder operator</b> with no physical execution at all.</td>
</tr>
</tbody>
</table>

<div style="background: #eef2f0; border-left: 4px solid #1f6b5c; padding: 18px 22px; margin: 24px 0; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; border-radius: 0 8px 8px 0;">
It is worth being precise about what this proves. The comparison shows that the two paths agree, not that the operator is correct. Correctness of the operator belongs in its own tests. What the harness rules out is the failure the export itself introduces, which is a script that departs from the workflow it was made from.
</div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">What it is for, day to day</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The harness has a second use, which turned out to matter more than the first. Adding an operator to it is the step that tells a contributor their standalone code is finished. A new operator arrives with its generated block and a fixture, the suite runs it both ways, and a disagreement becomes a failing test on the pull request rather than a bug a user finds in an exported script months later. Because these runs launch Python subprocesses, they live in their own continuous integration job instead of slowing down the ordinary unit tests.
</p>

<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 32px; letter-spacing: -.01em; margin: 48px 0 6px; line-height: 1.1; color: #14110f;">
<span style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 14px; font-weight: 800; color: #c8451f; letter-spacing: .1em; border: 2px solid #c8451f; border-radius: 999px; padding: 3px 11px; margin-right: 10px;">05</span>
What It Covers, and What It Does Not
</h2>

<div style="height: 3px; width: 60px; background: #14110f; margin: 0 0 22px;"></div>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">The families that export today</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
They are the ones a typical workflow is made of: the relational and text operators, sampling, the file and table sources, the visualizations, and the machine learning operators, including the scikit-learn families and the Hugging Face models. Ninety-nine operator classes write their own standalone code, and a further 56 scikit-learn descriptors inherit theirs from a shared base.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">The operators that leave a gap</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
Some operators are outside what a single file can reasonably do. A Java or R user defined function has no pandas form. The Twitter and Reddit sources need credentials and a live service. The database sources need a connection the script has no way to reproduce. The loop operators have no standalone form yet either. In each case a comment in the script says so at the point where the line would have been.
</p>

<h3 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 22px; margin: 30px 0 10px;">Two limits worth stating plainly</h3>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 17px; margin: 0 0 18px;">
The script is sequential. The engine's parallelism is a property of the runtime, not of the operators, so the script computes the same answer without the engine's distribution. And a file source is written as a plain file name, on the assumption that the file sits beside the script, because a Texera resource URI means nothing outside the system. Someone exporting a workflow that reads a dataset should expect to put the file next to the script, or to edit that one line.
</p>

<div style="background: #2a241d; color: #f4efe6; border-radius: 16px; padding: 38px 40px; margin: 36px 0 0; text-align: center;">
<h2 style="font-family: Georgia,'Times New Roman',serif; font-weight: 900; font-size: 28px; margin: 0 0 12px; color: #fbf7ef;">
Where This Goes Next
</h2>

<p style="font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 16px; color: #cbc1b1; margin: 0 auto 22px; max-width: 680px;">
The export is landing as a series of changes, one operator family at a time, each with its parity tests. A guide for contributors adding an operator to the export and to the harness lands with the last of them. Development is tracked on GitHub, and design discussion happens there and on <a style="color: #f4efe6; font-weight: bold;" href="https://lists.apache.org/list.html?dev@texera.apache.org">dev@texera.apache.org</a>.
</p>

<a style="display: inline-block; background: #c8451f; color: #fff; font-weight: 800; letter-spacing: .04em; text-decoration: none; padding: 14px 30px; border-radius: 999px; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 15px;" href="https://github.com/apache/texera/issues/8325" target="_blank" rel="noopener">Follow the work on issue #8325</a>
</div>

</div>

<p style="text-align: center; font-family: Georgia,'Times New Roman',serif; font-style: italic; font-size: 19px; padding: 40px 44px 52px; margin: 0; background: #ffffff; color: #5b5347;">
If you export a workflow and the script does not do what the canvas did, that is a bug worth reporting, and the harness is where its fix will be pinned.
</p>

</div>
