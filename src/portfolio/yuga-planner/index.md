---
title: "Yuga Planner"
date: 2025-06-27
draft: false
description: "Intelligent scheduling with LLM-powered task decomposition and constraint-based optimization"
tags: ["Python", "LLM", "Optimization", "Hackathon", "MCP", "HuggingFace"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
A neuro-symbolic prototype combining LLM-powered task decomposition with constraint-based optimization for intelligent scheduling.
Built for the [Hugging Face Agents MCP Hackathon](https://huggingface.co/spaces/huggingface/mcp-hackathon).
{{< /lead >}}

## What it does

Yuga Planner transforms project descriptions into optimized employee schedules:

{{< keywordList >}}
{{< keyword icon="wand-magic-sparkles" >}} LLM Task Decomposition {{< /keyword >}}
{{< keyword icon="scale-balanced" >}} Constraint Optimization {{< /keyword >}}
{{< keyword icon="code" >}} MCP Integration {{< /keyword >}}
{{< /keywordList >}}

---

## How it works

{{< timeline >}}

{{< timelineItem icon="pencil" header="Project Input" subheader="Markdown Parsing" >}}
Accepts project descriptions in markdown format with automatic task extraction.
{{< /timelineItem >}}

{{< timelineItem icon="wand-magic-sparkles" header="Task Decomposition" subheader="LlamaIndex + Nebius AI" >}}
Breaks down projects into actionable tasks, analyzing skill requirements and dependencies.
{{< /timelineItem >}}

{{< timelineItem icon="scale-balanced" header="Optimization" subheader="Timefold Solver" >}}
Generates optimal assignments respecting calendar constraints, business hours (9:00-18:00), and weekends.
{{< /timelineItem >}}

{{< /timeline >}}

---

## Architecture

{{< mermaid >}}
sequenceDiagram
    actor User
    participant LLM as LlamaIndex
    participant Solver as Timefold
    participant Cal as Calendar

    User->>LLM: Project description
    LLM->>LLM: Extract tasks
    LLM->>Solver: Task constraints
    Solver->>Cal: Check availability
    Cal-->>Solver: Free slots
    Solver-->>User: Optimized schedule
{{< /mermaid >}}

---

## Features

{{< alert icon="lightbulb" >}}
**Dual-mode operation**: Works as both a Gradio web interface and an MCP tool for integration with agent platforms like Claude Desktop.
{{< /alert >}}

- Calendar integration with `.ics` file support
- Real-time log streaming and progress indicators
- Streaming tool call processing with JSON repair
- Intelligent scheduling request detection

---

## Tech Stack

{{< keywordList >}}
{{< keyword icon="code" >}} Python 3.10+ {{< /keyword >}}
{{< keyword icon="code" >}} Java 17+ {{< /keyword >}}
{{< keyword icon="github" >}} LlamaIndex {{< /keyword >}}
{{< keyword icon="scale-balanced" >}} Timefold {{< /keyword >}}
{{< /keywordList >}}

---

## Links

{{< button href="https://huggingface.co/spaces/blackopsrepl/yuga-planner" target="_blank" >}}
{{< icon "wand-magic-sparkles" >}} Live Demo
{{< /button >}}

{{< button href="https://github.com/blackopsrepl/yuga-planner" target="_blank" >}}
{{< icon "github" >}} GitHub
{{< /button >}}
