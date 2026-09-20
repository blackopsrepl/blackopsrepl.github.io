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
{{< lead >}}
{{< typeit
  tag=h3
  speed=40
  breakLines=false
  loop=false
>}}
Point it at a PRD. Walk away. Come back to committed code.
{{< /typeit >}}
{{< /lead >}}

{{< keywordList >}}
{{< keyword icon="refresh" >}} Autonomous Loop {{< /keyword >}}
{{< keyword icon="document" >}} PRD-Driven {{< /keyword >}}
{{< keyword icon="chart" >}} Progress Tracking {{< /keyword >}}
{{< keyword icon="bolt" >}} Auto-Commit {{< /keyword >}}
{{< keyword icon="github" >}} Open Source {{< /keyword >}}
{{< /keywordList >}}

---

## Screenshots

{{< gallery >}}
  <img src="screenshot-tui.png" class="grid-w50 md:grid-w50" alt="Zoyd TUI with banner and task status" />
  <img src="screenshot-progress.png" class="grid-w50 md:grid-w50" alt="Zoyd task progress output" />
{{< /gallery >}}

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

{{< alert icon="lightbulb" cardColor="#1a1a2e" iconColor="#00ff00" textColor="#ffffff" >}}
**Minimal PRD** — Zoyd tracks markdown checkboxes. Write `- [ ] Do the thing` and it knows what to do.
{{< /alert >}}

---

## How It Works

{{< timeline >}}

{{< timelineItem icon="document" header="PRD Parsing" badge="Input" subheader="Markdown Checkboxes" >}}
Reads your PRD file and extracts `- [ ]` / `- [x]` tasks. Tracks completion status and line numbers for precise updates.
{{< /timelineItem >}}

{{< timelineItem icon="code" header="Claude Invocation" badge="Core" subheader="AI-Powered Execution" >}}
Builds a prompt with PRD content, progress history, and iteration context. Invokes Claude Code with full codebase access.
{{< /timelineItem >}}

{{< timelineItem icon="refresh" header="Loop & Commit" badge="Auto" subheader="Until Done" >}}
Appends output to the progress log, auto-commits completed tasks, and loops back. Stops when all checkboxes are checked or limits are hit.
{{< /timelineItem >}}

{{< timelineItem icon="chart" header="Rich TUI" badge="Live" subheader="Visual Feedback" >}}
Real-time progress tracking with spinners, task status, iteration count, and cost monitoring in a terminal dashboard.
{{< /timelineItem >}}

{{< /timeline >}}

---

## Architecture

{{< mermaid >}}
graph TD
    subgraph INPUT["Input"]
        A["PRD.md<br/>Task Checkboxes"]
    end

    subgraph CORE["Zoyd Loop"]
        B[Task Parser]
        C[Loop Runner]
        D[Progress Logger]
    end

    subgraph AI["AI Backend"]
        E["Claude Code<br/>--print --permission-mode acceptEdits"]
    end

    subgraph OUTPUT["Output"]
        F[Auto Commit]
        G[Git Repository]
        H[Rich TUI]
    end

    A --> B
    B --> C
    C --> E
    E --> D
    D --> B

    C --> F
    F --> G
    C --> H
{{< /mermaid >}}

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

{{< alert icon="circle-info" cardColor="#1a1a2e" iconColor="#00ffff" textColor="#ffffff" >}}
**Storage backends** — File-based logging by default, or Redis for persistent session state and vector semantic memory.
{{< /alert >}}

---

## Highlights

{{< alert icon="fire" cardColor="#1a1a2e" iconColor="#00ff00" textColor="#ffffff" >}}
**Fully autonomous** — Zoyd invokes Claude Code in a loop, tracking progress and committing changes until every task in your PRD is checked off.
{{< /alert >}}

{{< alert icon="bolt" cardColor="#1a1a2e" iconColor="#ffff00" textColor="#ffffff" >}}
**Cost-aware** — Set a dollar budget with `--max-cost`. Zoyd stops before you burn through tokens.
{{< /alert >}}

{{< alert icon="shield" cardColor="#1a1a2e" iconColor="#00ffff" textColor="#ffffff" >}}
**Sandboxed by default** — Runs Claude Code with `acceptEdits` permissions. Use `--rabid` to go unrestricted.
{{< /alert >}}

---

## Tech Stack

{{< keywordList >}}
{{< keyword icon="code" >}} Python {{< /keyword >}}
{{< keyword icon="code" >}} Claude Code {{< /keyword >}}
{{< keyword icon="code" >}} Rich {{< /keyword >}}
{{< keyword icon="code" >}} Textual {{< /keyword >}}
{{< keyword icon="code" >}} Redis {{< /keyword >}}
{{< keyword icon="code" >}} Click {{< /keyword >}}
{{< /keywordList >}}

---

## Links

{{< button href="https://github.com/blackopsrepl/zoyd" target="_blank" >}}
{{< icon "github" >}} View on GitHub
{{< /button >}}
