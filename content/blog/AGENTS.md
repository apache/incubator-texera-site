# Authoring & styling Texera blog posts

This directory holds the site's blog posts. Each post is a folder with an
`index.md` (a [page bundle](https://gohugo.io/content-management/page-bundles/)),
rendered by `layouts/blog/single.html`, which wraps the content in
`<article class="blog-post">` inside the `.td-content` column.

**All blog-post styling lives in one shared stylesheet:
`assets/scss/_blog_post.scss`** (imported last in `assets/scss/main.scss`, scoped
to `.blog-post` so nothing else on the site is affected). Posts are written as
clean, semantic HTML that picks from the classes below. **Do not use inline
`style="..."` attributes in a post.** If you need a new visual treatment, add a
class to `_blog_post.scss` and use it, so every post shares one look and a change
made once applies everywhere.

The article measure, centering, image sizing, and typography are all handled by
the stylesheet. The article width is `$bp-measure` (currently `100%`, so a post
fills its container and the site's `.container` max-width, ~1140px on wide screens,
is the natural ceiling), and every image and video fills that column, so images can
no longer look oversized or misaligned with the text. You do not set widths by hand.
To change how wide posts run, edit `$bp-measure` in one place: a percentage tracks
the container responsively, or a fixed value like `820px` gives a tighter measure.

## Class reference

The template already provides `<article class="blog-post">` and the post
`<h1 class="post-title">`. A post's `index.md` body is just the flowing content
below the title. Copy the nearest existing post and adapt.

### Structure & text

| Class | Use |
|---|---|
| `<figure class="post-hero"><img ...></figure>` | Full-width hero image at the top. |
| `<figure class="post-hero post-hero--card">` | Hero variant for a small logo centered on a soft card. |
| `<p class="post-eyebrow">` | Uppercase orange kicker line (date/context). |
| `<p class="post-lead">` | Large serif intro paragraph(s). |
| `<p class="post-note">` | Small muted note on a cream chip. |
| `<p>` | Normal body paragraph (17px). |
| `<h2 data-num="01">Heading</h2>` | Numbered section heading. The orange pill and the short rule beneath are generated from `data-num`, so do not add a number `<span>` or a rule `<div>`. |
| `<h3>Sub-heading</h3>` | Sub-heading within a section. |
| `<a href="...">` | Links are styled automatically (orange). Keep `target`/`rel` where relevant. |
| `<p class="post-outro">` | Closing italic line, centered. |

### Boxes & callouts

| Class | Use |
|---|---|
| `<div class="post-callout">` | Green-accented callout for an aside. |
| `<div class="post-card">` | Cream card; may contain an `<h3>`, `<p>`, or `<ul>`. |
| `<div class="post-banner">` | Dark block for a mid-article divider or the closing CTA. Optional `<p class="post-banner__eyebrow">` kicker, an `<h2>`, a `<p>`, and an `<a class="post-btn">` button. |
| `<a class="post-btn" href="...">` | Pill call-to-action button (usually inside a banner). |

### Figures (image or video with a caption)

```html
<figure class="post-figure">
  <img src="/images/blog_hero/example.png" alt="Describe the image">
  <figcaption>Caption text.</figcaption>
</figure>

<figure class="post-figure">
  <video autoplay loop muted playsinline controls>
    <source src="/videos/example.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <figcaption>Caption text.</figcaption>
</figure>
```

Always write real `alt` text. It is the accessible description and feeds the blog
list page's search index.

### Tables, grids, and badges

```html
<!-- Three-up stat cells -->
<table class="post-stats" role="presentation"><tbody><tr>
  <td><div class="post-stat-num">23</div><div class="post-stat-label">participants</div></td>
  <td><div class="post-stat-num">46</div><div class="post-stat-label">hours</div></td>
  <td><div class="post-stat-num">35</div><div class="post-stat-label">submissions</div></td>
</tr></tbody></table>

<!-- Bordered step / summary rows -->
<table class="post-steps"><tbody>
  <tr><td><b>1. Step title.</b> Description. <a href="..."><span class="pr-badge">PR #7602</span></a></td></tr>
</tbody></table>

<!-- Award / label+entry rows -->
<table class="post-awards" role="presentation">
  <colgroup><col class="post-awards-label"><col></colgroup>
  <tbody>
    <tr>
      <td class="post-awards-tag"><span class="badge-pill badge--winner">Winner</span></td>
      <td>Entry text <a href="..."><span class="pr-badge">PR #5104</span></a></td>
    </tr>
  </tbody>
</table>

<!-- 2-column feature grid -->
<div class="post-grid">
  <div class="post-grid-cell"><h3>Isolation</h3><p>...</p></div>
  <div class="post-grid-cell"><h3>Flexibility</h3><p>...</p></div>
</div>
```

Badge colors: `badge--winner` (orange), `badge--runner` (green),
`badge--honorable` / `badge--special` (gold). `pr-badge` is the small inline PR
link chip.

## Front matter

```yaml
---
title: "Full title shown as the page <h1>"
linkTitle: "Short title for nav/cards"      # optional
slug: "url-slug"                             # optional; defaults from folder name
date: 2026-09-15                             # controls ordering (newest first)
author: Name(s)
description: "One-sentence summary; shown on the blog card and used for search."
images:
  - /images/blog_hero/your-hero.png          # card thumbnail on the blog list
tags: ["tag-one", "tag-two"]
---
```

The blog list card (`layouts/blog/list.html`) uses `images[0]`, `title`,
`description`, `author`, `date`, and `tags`, and its search matches
title/description/author/tags, so fill them in.

## Assets

- Images live in `static/images/blog_hero/`, referenced as `/images/blog_hero/<file>`.
- Videos live in `static/videos/`, referenced as `/videos/<file>`.

## Design tokens

The palette and fonts are defined once at the top of `_blog_post.scss`
(orange `#c8451f`, ink `#14110f`, cream `#fbf7ef`, green `#1f6b5c`, dark `#2a241d`;
Georgia for display/serif, Helvetica Neue for body). Reuse those variables rather
than hard-coding hex values when you extend the stylesheet.

## Before you finish

Build to confirm the SCSS compiles and the post renders:

```bash
hugo --quiet --gc            # or: hugo server -D   to preview at localhost:1313
```

`AGENTS.md` is kept out of the built site by `ignoreFiles` in `hugo.toml`.
