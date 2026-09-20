---
title: "SolverForge Calendar"
date: 2026-08-05
draft: false
description: "A local-first Ratatui calendar with Google sync, event dependencies, and an automation-first CLI"
tags: ["Rust", "TUI", "SQLite", "Calendar", "CLI"]
showHero: false
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---

{{< lead >}}
A local-first calendar with two deliberate interfaces: a fast terminal UI for people and a strict JSON CLI for agents and automation.
{{< /lead >}}

SolverForge Calendar treats time as structured, operable data. It combines month, week, day, and agenda views with recurring events, local persistence, Google Calendar synchronization, and dependency links between events.

{{< keywordList >}}
{{< keyword icon="calendar" >}} Four calendar views {{< /keyword >}}
{{< keyword icon="share-nodes" >}} Dependency-aware events {{< /keyword >}}
{{< keyword icon="terminal" >}} JSON companion CLI {{< /keyword >}}
{{< keyword icon="rotate" >}} Incremental Google sync {{< /keyword >}}
{{< keyword icon="bell" >}} Desktop reminders {{< /keyword >}}
{{< /keywordList >}}

## The terminal calendar

The TUI keeps navigation, calendar visibility, event editing, quick-add, and synchronization available from the keyboard while background work stays out of the render loop.

{{< gallery >}}
  <img src="calendar-tui.png" class="grid-w100 md:grid-w100" loading="lazy" decoding="async" alt="SolverForge Calendar month view in the Ratatui terminal interface" />
{{< /gallery >}}

## Human and automation surfaces

{{< alert icon="lightbulb" >}}
The TUI and CLI are peers over the same model. Automation does not scrape the visual interface, and people do not have to operate a machine-oriented command protocol.
{{< /alert >}}

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

{{< mermaid >}}
flowchart LR
    tui[Ratatui TUI] --> model[Calendar model]
    cli[JSON CLI] --> model
    model --> db[(Local SQLite)]
    model --> dag[Event dependency DAG]
    model --> workers[Background worker pool]
    workers --> google[Google Calendar]
    workers --> notify[Desktop notifications]
{{< /mermaid >}}

## Operational choices

- RFC 5545 recurrence and iCalendar import/export keep the data interoperable.
- Incremental sync uses Google sync tokens rather than repeatedly downloading an entire calendar.
- OAuth credentials live in the operating system keyring, not in the SQLite database.
- Channel-based workers isolate database and network latency from terminal input and rendering.
- The terminal palette can follow the surrounding SolverForge Linux environment.

## Repository

{{< github repo="blackopsrepl/solverforge-calendar" showThumbnail=false >}}

{{< button href="https://github.com/blackopsrepl/solverforge-calendar" target="_blank" >}}
{{< icon "github" >}} Source and installation
{{< /button >}}
