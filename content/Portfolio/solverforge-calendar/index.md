---
title: "SolverForge Calendar"
date: 2026-08-05
draft: false
description: "A local-first Ratatui calendar with Google sync, event dependencies, and an automation-first CLI"
tags: ["Rust", "TUI", "SQLite", "Calendar", "CLI"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
A fast terminal calendar that treats scheduling as an operable system: a human-facing TUI, an agent-facing JSON CLI, local persistence, and explicit event dependencies.
{{< /lead >}}

## More than dates on a grid

Month, week, day, and agenda views share a local SQLite model with recurring events, iCalendar import/export, desktop notifications, and incremental two-way Google Calendar sync. Events can form a directed acyclic graph, with cycle detection and topological ordering built into the model.

{{< keywordList >}}
{{< keyword icon="calendar" >}} Multiple calendar views {{< /keyword >}}
{{< keyword icon="share-nodes" >}} Dependency-aware events {{< /keyword >}}
{{< keyword icon="terminal" >}} JSON-first companion CLI {{< /keyword >}}
{{< keyword icon="rotate" >}} Incremental Google sync {{< /keyword >}}
{{< /keywordList >}}

## Designed for visible control

Background workers keep database and API operations off the interactive terminal loop. Destructive CLI operations require explicit flags, and OAuth tokens remain in the operating system keyring rather than the calendar database.

## Links

{{< button href="https://github.com/blackopsrepl/solverforge-calendar" target="_blank" >}}
{{< icon "github" >}} Source
{{< /button >}}
