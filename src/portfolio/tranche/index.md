---
title: "Tranche"
date: 2026-10-05
draft: false
description: "Input-bound, model-assisted PR discovery and review prioritization for public GitHub repositories"
tags: ["Rust", "GitHub", "Code Review", "MCP", "Developer Tools"]
---

<div class="lead"><p>A configurable PR triage tool for public GitHub repositories. It spots likely duplicates and gathers changes into reviewable batches. The model supplies the judgments; humans make the merge call.</p></div>

Tranche binds to one repository per deployment: a directory holding the deployment contract (`tranche.json`), the captured PR corpus, the stored judgments, and the published reports. The binary holds no state and no global configuration. The repository under review stays read-only input, reached only through GitHub's API — it stores nothing, hosts nothing, and needs no cooperation from its maintainers.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/search.svg" alt="" width="16" height="16">Duplicate discovery</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16">Review batches</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/shield.svg" alt="" width="16" height="16">Bound reports</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Offline pipeline</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16">Published workbench</span></div>

## The pipeline

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/download.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Fetch</h3><span class="timeline-badge">Capture</span><p class="timeline-subheader">Open-PR membership through gh, so the credential never touches a command line</p></header>
    <div class="timeline-item-body"><p>Incremental captures reuse stored work when the evidence and policy have not changed. A refresh with nothing new spends zero model calls.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Judge</h3><span class="timeline-badge">Model</span><p class="timeline-subheader">One batched Jev call per PR: area, risk, fix probability, finish, effort, security</p></header>
    <div class="timeline-item-body"><p>Question wording and the category taxonomy come from the deployment's contract, so each repository is reviewed against its own standards. A question the model answers unusably becomes <code>null</code> — never coerced to zero, because an unknown and a measured low are different facts.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Dupes</h3><span class="timeline-badge">Compare</span><p class="timeline-subheader">Candidate pairs by title and body similarity plus literal cross-references</p></header>
    <div class="timeline-item-body"><p>Candidate pairs and duplicate groups give reviewers a starting point for comparing competing implementations; similar wording alone never proves equivalence.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Cluster and batch</h3><span class="timeline-badge">Offline</span><p class="timeline-subheader">Pure functions of the stored corpus — no model, no network</p></header>
    <div class="timeline-item-body"><p>Groups become merge units of up to five PRs, security first, each carrying a ready-to-paste reviewer prompt. Every stage is safe to re-run.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Publish</h3><span class="timeline-badge">Workbench</span><p class="timeline-subheader">Machine-readable out/ for agents and a browsable HTML workbench for people</p></header>
    <div class="timeline-item-body"><p>The binary embeds the workbench template and browser assets, so rendering needs no source checkout. Offline CLI and MCP commands read the same bound reports.</p></div>
  </div>
</article></div>

## Bound evidence, inspectable limits

<aside class="alert"><p>Tranche judges descriptions and diff statistics, not patch correctness. Reviewers still need to read the diffs, check CI, and test the proposed result.</p></aside>

Each report records a digest of the inputs it was built from, and the gate refuses a report whose binding no longer matches. `tranche info` shows the counts and digests of the current report, so a reader always knows what observation they are looking at. Its "duplicates" are model suggestions, not verified facts — maintainers decide what happens to a PR, always.

## The Omarchy demo

Tranche grew out of the Omarchy PR backlog: a large backlog where contributors propose competing fixes across installation, desktop configuration, shell tools, applications, and hardware support. The published workbench exposes the review queues, and a committed slice of the captured corpus lets regression tests rebuild reports without a model pass.

<div class="gallery"><img src="tranche-workbench.png" loading="lazy" decoding="async" alt="The Tranche workbench: searchable PRs, review queues, and model risk hints" />
<img src="tranche-cli.png" loading="lazy" decoding="async" alt="The Tranche CLI: pipeline commands in a real terminal" /></div>

## Install

```bash
git clone https://github.com/blackopsrepl/Tranche && cd Tranche
cargo install --path crates/tranche-cli --locked
```

The binary is self-contained: no interpreter, no daemon, no database, no service. A new deployment for any public repository starts with `tranche init OWNER/REPO` — then rewrite the starter taxonomy for that repository before making model calls.

## Repository

<div class="github-card"><a href="https://github.com/blackopsrepl/Tranche">blackopsrepl/Tranche</a></div>

<a class="button" href="https://github.com/blackopsrepl/Tranche" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Source and setup</a>

<a class="button" href="https://vdistefano.studio/Tranche/" target="_blank"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16" /> Live Omarchy demo report</a>
