---
title: "Zoyd"
date: 2026-03-11
draft: false
description: "An autonomous PRD-driven development agent that loops Claude Code until every task is done."
tags: ["Python", "AI", "Automation", "Developer Tools", "Agentic Systems"]
showHero: false
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---
<div class="lead"><p><span class="typeit">Point it at a PRD. Walk away. Come back to committed code.</span></p></div>

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Autonomous Loop</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">PRD-Driven</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Progress Tracking</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Auto-Commit</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16">Open Source</span></div>

---

## Screenshots

<div class="gallery"><img src="screenshot-tui.png" class="grid-w50 md:grid-w50" alt="Zoyd TUI with banner and task status" />
  <img src="screenshot-progress.png" class="grid-w50 md:grid-w50" alt="Zoyd task progress output" /></div>

---

## Installation

```bash
git clone https://github.com/blackopsrepl/zoyd
cd zoyd
pip install -e .
```

---

## Quick Start

```bash
# Create a starter PRD
zoyd init "My Project"

# Edit PRD.md with your tasks, then run
zoyd run

# Check progress
zoyd status
```

<aside class="alert" style="background: #1a1a2e; color: #ffffff"><p><strong>Minimal PRD</strong> — Zoyd tracks markdown checkboxes. Write <code>- [ ] Do the thing</code> and it knows what to do.</p></aside>

---

## How It Works

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>PRD Parsing</h3><span class="timeline-badge">Input</span><p class="timeline-subheader">Markdown Checkboxes</p></header>
    <div class="timeline-item-body"><p>Reads your PRD file and extracts <code>- [ ]</code> / <code>- [x]</code> tasks. Tracks completion status and line numbers for precise updates.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Claude Invocation</h3><span class="timeline-badge">Core</span><p class="timeline-subheader">AI-Powered Execution</p></header>
    <div class="timeline-item-body"><p>Builds a prompt with PRD content, progress history, and iteration context. Invokes Claude Code with full codebase access.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Loop &amp; Commit</h3><span class="timeline-badge">Auto</span><p class="timeline-subheader">Until Done</p></header>
    <div class="timeline-item-body"><p>Appends output to the progress log, auto-commits completed tasks, and loops back. Stops when all checkboxes are checked or limits are hit.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Rich TUI</h3><span class="timeline-badge">Live</span><p class="timeline-subheader">Visual Feedback</p></header>
    <div class="timeline-item-body"><p>Real-time progress tracking with spinners, task status, iteration count, and cost monitoring in a terminal dashboard.</p></div>
  </div>
</article></div>

---

## Architecture

<pre class="not-prose mermaid">graph TD
    subgraph INPUT[&quot;Input&quot;]
        A[&quot;PRD.md&lt;br/&gt;Task Checkboxes&quot;]
    end

    subgraph CORE[&quot;Zoyd Loop&quot;]
        B[Task Parser]
        C[Loop Runner]
        D[Progress Logger]
    end

    subgraph AI[&quot;AI Backend&quot;]
        E[&quot;Claude Code&lt;br/&gt;--print --permission-mode acceptEdits&quot;]
    end

    subgraph OUTPUT[&quot;Output&quot;]
        F[Auto Commit]
        G[Git Repository]
        H[Rich TUI]
    end

    A --&gt; B
    B --&gt; C
    C --&gt; E
    E --&gt; D
    D --&gt; B

    C --&gt; F
    F --&gt; G
    C --&gt; H</pre>

---

## Configuration

Zoyd reads `zoyd.toml` from your project directory. CLI flags override config values.

```toml
prd = "PRD.md"
max_iterations = 10
model = "sonnet"
max_cost = 10.0
auto_commit = true
tui_enabled = true
storage_backend = "redis"
```

<aside class="alert" style="background: #1a1a2e; color: #ffffff"><p><strong>Storage backends</strong> — File-based logging by default, or Redis for persistent session state and vector semantic memory.</p></aside>

---

## Highlights

<aside class="alert" style="background: #1a1a2e; color: #ffffff"><p><strong>Fully autonomous</strong> — Zoyd invokes Claude Code in a loop, tracking progress and committing changes until every task in your PRD is checked off.</p></aside>

<aside class="alert" style="background: #1a1a2e; color: #ffffff"><p><strong>Cost-aware</strong> — Set a dollar budget with <code>--max-cost</code>. Zoyd stops before you burn through tokens.</p></aside>

<aside class="alert" style="background: #1a1a2e; color: #ffffff"><p><strong>Sandboxed by default</strong> — Runs Claude Code with <code>acceptEdits</code> permissions. Use <code>--rabid</code> to go unrestricted.</p></aside>

---

## Tech Stack

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Python</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Claude Code</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Rich</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Textual</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Redis</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Click</span></div>

---

## Links

<a class="button" href="https://github.com/blackopsrepl/zoyd" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> View on GitHub</a>
