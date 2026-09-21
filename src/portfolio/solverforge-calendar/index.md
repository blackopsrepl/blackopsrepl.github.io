---
title: "SolverForge Calendar"
date: 2026-08-05
draft: false
description: "A local-first Ratatui calendar with Google sync, event dependencies, and an automation-first CLI"
tags: ["Rust", "TUI", "SQLite", "Calendar", "CLI"]
---

<div class="lead"><p>A local-first calendar with two deliberate interfaces: a fast terminal UI for people and a strict JSON CLI for agents and automation.</p></div>

SolverForge Calendar treats time as structured, operable data. It combines month, week, day, and agenda views with recurring events, local persistence, Google Calendar synchronization, and dependency links between events.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Four calendar views</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Dependency-aware events</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">JSON companion CLI</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Incremental Google sync</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/bell.svg" alt="" width="16" height="16">Desktop reminders</span></div>

## The terminal calendar

The TUI keeps navigation, calendar visibility, event editing, quick-add, and synchronization available from the keyboard while background work stays out of the render loop.

<div class="gallery"><img src="calendar-tui.png" loading="lazy" decoding="async" alt="SolverForge Calendar month view in the Ratatui terminal interface" /></div>

## Human and automation surfaces

<aside class="alert"><p>The TUI and CLI are peers over the same model. Automation does not scrape the visual interface, and people do not have to operate a machine-oriented command protocol.</p></aside>

The companion CLI exposes calendars, projects, events, dependencies, and Google sync as JSON-first commands. Successful operations write JSON to standard output; failures write JSON to standard error. Destructive operations require explicit flags such as `--cascade-events` or `--detach-events` instead of hiding consequences behind a prompt.

```bash
solverforge-calendar-cli events create \
  --calendar-id <calendar-id> \
  --title "Planning session" \
  --start-at "2026-08-24 15:00:00" \
  --end-at "2026-08-24 16:00:00"
```

## Events can depend on one another

Dependencies form a directed acyclic graph. Cycle detection prevents an impossible chain from entering the model, while topological ordering makes the relationship usable by higher-level planning and automation.

<pre class="not-prose mermaid">flowchart LR
    tui[Ratatui TUI] --&gt; model[Calendar model]
    cli[JSON CLI] --&gt; model
    model --&gt; db[(Local SQLite)]
    model --&gt; dag[Event dependency DAG]
    model --&gt; workers[Background worker pool]
    workers --&gt; google[Google Calendar]
    workers --&gt; notify[Desktop notifications]</pre>

## Operational choices

- RFC 5545 recurrence and iCalendar import/export keep the data interoperable.
- Incremental sync uses Google sync tokens rather than repeatedly downloading an entire calendar.
- OAuth credentials live in the operating system keyring, not in the SQLite database.
- Channel-based workers isolate database and network latency from terminal input and rendering.
- The terminal palette can follow the surrounding SolverForge Linux environment.

## Repository

<div class="github-card"><a href="https://github.com/blackopsrepl/solverforge-calendar">blackopsrepl/solverforge-calendar</a></div>

<a class="button" href="https://github.com/blackopsrepl/solverforge-calendar" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Source and installation</a>
