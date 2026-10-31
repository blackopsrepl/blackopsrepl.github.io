---
title: "Planner123"
date: 2026-03-09
draft: false
description: "A keyboard-driven terminal calendar with a SolverForge planner that schedules your to-do list around your real week"
tags: ["Rust", "TUI", "Optimization", "SolverForge", "Developer Tools"]
---

<div class="lead"><p>A calendar that lives on your machine, runs in your terminal, and schedules your to-do list for you: around your meetings, inside your hours, before your deadlines. Nothing lands on the calendar until you approve it.</p></div>

Most calendars only remember what is already scheduled. Planner123 also holds the work that has no time yet. Give each task a duration, a priority, a cognitive load, and a deadline; press `o` and the SolverForge planner proposes a concrete slot for every task it can place; press `A` and only then do the tasks become events. Events live in a local SQLite file, with optional two-way Google Calendar sync and `.ics` import and export.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Ratatui TUI</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16">Local SQLite</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">SolverForge planner</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16">Google Calendar sync</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/lock.svg" alt="" width="16" height="16">Proposals change nothing</span></div>

## See it plan a week

<video controls preload="metadata" playsinline poster="poster.png" aria-label="Planner123 planning a week: the inbox fills, the planner proposes a slot for every task, and one key writes the plan into the calendar."><source src="planner123.mp4" type="video/mp4" /></video>

The week loads under copper bars, the month turns into a plasma, the Planner Inbox fills with five tasks, and each one flies to its slot on the downbeat before a single key writes the plan into the calendar.

## A calendar that plans

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Planner Inbox</h3><span class="timeline-badge">Tasks</span><p class="timeline-subheader">Work that exists but has no time yet</p></header>
    <div class="timeline-item-body"><p>Each task carries a duration, a priority, an optional cognitive load, an earliest start, and a hard or soft deadline. Settings declare your timezone, your weekly working hours, split shifts included, and the windows in which you do your best deep work.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>The planner</h3><span class="timeline-badge">SolverForge</span><p class="timeline-subheader">Fourteen constraints, one start slot per task</p></header>
    <div class="timeline-item-body"><p>Every task gets one planning variable, its start slot, and may stay unplaced when the week is full. Existing events are busy time, work lands only inside declared hours, hard deadlines and dependencies always hold, soft-deadline lateness outranks every deep-work preference, and high-load tasks are steered toward focus windows with recovery breaks between them.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/lock.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Review, then apply</h3><span class="timeline-badge">Control</span><p class="timeline-subheader">Dashed means proposed, not saved</p></header>
    <div class="timeline-item-body"><p>The proposal opens as a read-only preview on the time grid. Applying it is one transaction; a stale proposal is refused; <code>return-to-inbox</code> removes exactly one scheduled task's event and nothing else.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Agents and scripts</h3><span class="timeline-badge">JSON CLI</span><p class="timeline-subheader">Every feature without a keystroke</p></header>
    <div class="timeline-item-body"><p><code>planner123-cli</code> speaks JSON on stdout and stderr with no prompts, covering calendars, events, tasks, Google sync, conflicts, and the whole planner workflow. A portable agent skill teaches the contract to Codex, opencode, and other agents.</p></div>
  </div>
</article></div>

## Screenshots

<div class="gallery"><img src="month.png" loading="lazy" decoding="async" alt="Month view of October 2026 with event dots and the selected day's events" />
<img src="week.png" loading="lazy" decoding="async" alt="Week view with meetings on an hourly grid and a now line" />
<img src="planner-inbox.png" loading="lazy" decoding="async" alt="Planner Inbox listing tasks with duration, priority, and cognitive load" />
<img src="planner-proposal.png" loading="lazy" decoding="async" alt="Proposal preview with four of four tasks placed as dashed blocks on next week's grid" />
<img src="help.png" loading="lazy" decoding="async" alt="Keybinding help overlay listing the keys for the current view" /></div>

## Links

<div class="github-card"><a href="https://github.com/blackopsrepl/Planner123">blackopsrepl/Planner123</a></div>

<a class="button" href="https://github.com/blackopsrepl/Planner123" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Source and setup</a>
<a class="button" href="https://solverforge.org/use-cases/planner123/" target="_blank"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16" /> On solverforge.org</a>
