---
title: "Introducing Python UDF UI Parameters in Texera"
linkTitle: "Python UDF UI Parameters"
slug: "python-udf-ui-parameters"
date: 2026-11-17
author: Carlos Ernesto Alvarez Berumen
description: "Expose tunable values in a Python UDF so collaborators can configure and rerun the workflow from the property panel."
images:
  - /images/blog_hero/python-udf-ui-parameters.png
tags: ["python", "udf", "ui-parameters", "workflows"]
---

<style>
.ui-parameter-feature{font-family:"Helvetica Neue",Arial,sans-serif;color:#14110f;background:#fff;line-height:1.65;padding:24px 44px 40px}
.ui-parameter-feature>.feature-kicker+p{font-family:Georgia,"Times New Roman",serif;font-size:21px;line-height:1.5}
.ui-parameter-feature p,.ui-parameter-feature li{font-size:17px;line-height:1.65}
.ui-parameter-feature h2{font-family:Georgia,"Times New Roman",serif;font-weight:900;font-size:32px;letter-spacing:-.01em;margin:48px 0 18px;line-height:1.2;color:#14110f}
.ui-parameter-feature .section-number{font-family:"Helvetica Neue",Arial,sans-serif;font-size:14px;font-weight:800;color:#c8451f;letter-spacing:.1em;border:2px solid #c8451f;border-radius:999px;padding:3px 11px;margin-right:10px;white-space:nowrap}
.ui-parameter-feature pre{background:#fbf7ef;border:2px solid #14110f;border-radius:10px;padding:16px 18px;margin:20px 0 24px;font-size:14.5px;white-space:pre-wrap;overflow-wrap:anywhere}
.ui-parameter-feature pre code{font-size:inherit;white-space:inherit}
.ui-parameter-feature img{max-width:100%;height:auto;display:block;margin:26px auto 8px;border:1px solid #ddd;border-radius:10px}
.ui-parameter-feature p:has(>em:only-child){font-size:14px;line-height:1.5;text-align:center;color:#5b5347;margin-bottom:30px}
.ui-parameter-feature table{width:100%;margin:24px 0;border-collapse:collapse}
.ui-parameter-feature th,.ui-parameter-feature td{padding:12px;border:1px solid #ddd}
.ui-parameter-feature th{background:#fbf7ef}
.ui-parameter-feature .feature-kicker{font-family:"Helvetica Neue",Arial,sans-serif;font-size:14px!important;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:#c8451f;margin:0 0 28px}
@media(max-width:600px){.ui-parameter-feature{padding:12px 4px 24px}.ui-parameter-feature h2{font-size:27px;line-height:1.35}.ui-parameter-feature pre{padding:12px;font-size:12px}.ui-parameter-feature p,.ui-parameter-feature li{font-size:16px}}
</style>

<div class="ui-parameter-feature">

<p><img alt="Python UDF code beside its threshold parameter" src="/images/blog_hero/python-udf-ui-parameters.png"/></p>

<p><em>The Python declaration creates the threshold row in the property panel. Its value is set to 0.5.</em></p>

<p class="feature-kicker"><strong>Feature Introduction · Apache Texera</strong></p>

<p>Python user-defined functions (UDFs) let workflow authors add custom logic to Texera. Many of those scripts also contain values that change between runs: a score threshold, a maximum number of results, or a switch for an optional step. Hardcoding each choice means opening the script whenever it changes.</p>

<p>Python UDF UI parameters in Texera 1.3 let workflow authors expose those choices in the operator’s <strong>Parameters</strong> panel. The author defines the custom logic and the parameter’s type; someone running the workflow can then enter a new value and rerun it without editing the Python script.</p>

<h2><span class="section-number">01</span> Expose a score threshold</h2>

<p>Suppose a workflow reads records with a numeric <code>score</code> column, applies custom Python logic, and displays the records that pass a threshold. A developer might begin with a constant such as <code>0.5</code> in the filtering code. Turning it into a UI parameter makes the threshold an explicit setting of the operator.</p>

<p>Here is a complete tuple-processing UDF for that example. It expects a non-null numeric <code>score</code> column and passes through the original records that meet the threshold.</p>

<pre><code class="language-python">from pytexera import *

class ProcessTupleOperator(UDFOperatorV2):
    @overrides
    def open(self) -> None:
        self.threshold = self.UiParameter(
            "threshold", AttributeType.DOUBLE
        ).value

    @overrides
    def process_tuple(
        self, tuple_: Tuple, port: int
    ) -> Iterator[Optional[TupleLike]]:
        if tuple_["score"] &gt;= self.threshold:
            yield tuple_
</code></pre>

<p>The declaration gives the parameter a name, <code>threshold</code>, and a type, <code>AttributeType.DOUBLE</code>. Texera detects the declaration in <code>open()</code> and shows a corresponding row in the property panel. The <code>.value</code> property supplies the converted number to the UDF when it opens. The tuple-processing method then uses that value for each record.</p>

<h2><span class="section-number">02</span> Change the value and rerun</h2>

<p>For a small input you can reproduce, save the following as a CSV file:</p>

<pre><code class="language-csv">score
0.42
0.76
0.91
</code></pre>

<p>Then configure the workflow:</p>

<ol>
<li>
<p>Import the CSV with a <strong>CSV File Scan</strong> operator and set the <code>score</code> column’s type to <strong>double</strong>. Connect its output to a <strong>Python UDF</strong>.</p>
</li>
<li>
<p>Paste the code above into the UDF’s code editor. Keep <strong>Retain input columns</strong> enabled; this example adds no output columns.</p>
</li>
<li>
<p>In the <strong>Parameters</strong> panel, enter <code>0.5</code> in the Value field for <code>threshold</code>.</p>
</li>
<li>
<p>Run the workflow and inspect the Python UDF’s output in the results panel.</p>
</li>
<li>
<p>Change the value to <code>0.8</code> and rerun the workflow.</p>
</li>
</ol>

<p><img alt="Changing the threshold value to 0.8" src="/images/blog_hero/python-udf-ui-parameters-value.png"/></p>

<p><em>Changing the threshold to 0.8 leaves the Python script unchanged.</em></p>

<p>For an illustrative input containing scores <code>0.42</code>, <code>0.76</code>, and <code>0.91</code>, the same script produces these results:</p>

<table>
<thead>
<tr>
<th>Threshold entered in the panel</th>
<th>Scores retained</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>0.5</code></td>
<td><code>0.76</code>, <code>0.91</code></td>
</tr>
<tr>
<td><code>0.8</code></td>
<td><code>0.91</code></td>
</tr>
</tbody>
</table>

<p>The filtering rule stays in Python. The choice of threshold is visible beside the operator’s other settings, making it easier for a collaborator to try a different cutoff without finding the right line in the script.</p>

<h2><span class="section-number">03</span> Add parameters from the panel</h2>

<p>You can also start in the UI. Choose <strong>Add parameter</strong>, enter a name, select a type, and confirm. Texera inserts a <code>self.UiParameter(...)</code> declaration into the UDF’s <code>open()</code> method, creating the method if needed. You then use the generated value in your processing code.</p>

<p><img alt="Adding an integer max_results parameter" src="/images/blog_hero/python-udf-ui-parameters-add.png"/></p>

<p><em>Choosing integer for a new max_results parameter. Confirming adds its declaration to the script.</em></p>

<p>The panel keeps the parameter’s <strong>Name</strong> and <strong>Type</strong> read-only because they come from the script; <strong>Value</strong> remains editable. Changing a declaration in the code updates the parameter rows. Existing values are preserved by parameter name, so renaming a parameter requires entering its value again. Commented-out declarations do not create parameter rows.</p>

<h2><span class="section-number">04</span> Choose a type that matches the setting</h2>

<p>Python UI parameters support strings, integers, long integers, doubles, booleans, and timestamps. A threshold can use <code>DOUBLE</code>, a maximum number of results can use <code>INT</code>, and an optional processing step can use <code>BOOL</code>.</p>

<p>Although values are entered as text in the panel, Texera converts them to the declared type for the Python UDF. Empty text is valid for a string parameter; other types require a non-empty value. A value that cannot be converted produces an error rather than silently becoming a different value. Application-specific rules still belong in the UDF: for example, whether a threshold must fall between zero and one.</p>

<h2><span class="section-number">05</span> Try it in an existing workflow</h2>

<p>Start with one value that you regularly change in a Python UDF. Declare it in <code>open()</code>, use its <code>.value</code> in your processing logic, and set its value in the Parameters panel. The feature supports the Python UDF, 2-in Python UDF, and 1-out Python UDF operators, with the supported tuple, batch, table, and source classes.</p>

<p>For the supported declarations and operator classes, see the <a href="https://github.com/apache/texera/blob/release/v1.3/docs/reference/operators/user-defined-functions/python/_index.md#ui-parameters">Python UI parameter reference</a>. For the UDF lifecycle and processing APIs, see the <a href="https://github.com/apache/texera/blob/release/v1.3/docs/tutorials/guide-to-use-python-udf.md">Python UDF tutorial</a>.</p>

</div>
