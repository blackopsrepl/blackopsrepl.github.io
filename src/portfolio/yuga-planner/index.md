---
title: "Yuga Planner"
date: 2025-06-27
draft: false
description: "Intelligent scheduling with LLM-powered task decomposition and constraint-based optimization"
tags: ["Python", "LLM", "Optimization", "Hackathon", "MCP", "HuggingFace"]
---

<div class="lead"><p>A neuro-symbolic prototype combining LLM-powered task decomposition with constraint-based optimization for intelligent scheduling.
Built for the <a href="https://huggingface.co/spaces/huggingface/mcp-hackathon">Hugging Face Agents MCP Hackathon</a>.</p></div>

## What it does

Yuga Planner transforms project descriptions into optimized employee schedules:

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16">LLM Task Decomposition</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/scale-balanced.svg" alt="" width="16" height="16">Constraint Optimization</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">MCP Integration</span></div>

---

## How it works

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/pencil.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Project Input</h3><p class="timeline-subheader">Markdown Parsing</p></header>
    <div class="timeline-item-body"><p>Accepts project descriptions in markdown format with automatic task extraction.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Task Decomposition</h3><p class="timeline-subheader">LlamaIndex + Nebius AI</p></header>
    <div class="timeline-item-body"><p>Breaks down projects into actionable tasks, analyzing skill requirements and dependencies.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/scale-balanced.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Optimization</h3><p class="timeline-subheader">Timefold Solver</p></header>
    <div class="timeline-item-body"><p>Generates optimal assignments respecting calendar constraints, business hours (9:00-18:00), and weekends.</p></div>
  </div>
</article></div>

---

## Architecture

<pre class="not-prose mermaid">sequenceDiagram
    actor User
    participant LLM as LlamaIndex
    participant Solver as Timefold
    participant Cal as Calendar

    User-&gt;&gt;LLM: Project description
    LLM-&gt;&gt;LLM: Extract tasks
    LLM-&gt;&gt;Solver: Task constraints
    Solver-&gt;&gt;Cal: Check availability
    Cal--&gt;&gt;Solver: Free slots
    Solver--&gt;&gt;User: Optimized schedule</pre>

---

## Features

<aside class="alert"><p><strong>Dual-mode operation</strong>: Works as both a Gradio web interface and an MCP tool for integration with agent platforms like Claude Desktop.</p></aside>

- Calendar integration with `.ics` file support
- Real-time log streaming and progress indicators
- Streaming tool call processing with JSON repair
- Intelligent scheduling request detection

---

## Tech Stack

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Python 3.10+</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Java 17+</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16">LlamaIndex</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/scale-balanced.svg" alt="" width="16" height="16">Timefold</span></div>

---

## Links

<a class="button" href="https://huggingface.co/spaces/blackopsrepl/yuga-planner" target="_blank"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16" /> Live Demo</a>

<a class="button" href="https://github.com/blackopsrepl/yuga-planner" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> GitHub</a>
