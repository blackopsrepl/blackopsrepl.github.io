---
title: "SolverForge"
date: 2025-12-07
draft: false
description: "A native Rust planning engine with first-class Rust and Python modeling surfaces"
tags: ["Python", "Rust", "Optimization", "Constraint Programming", "SolverForge"]
showHero: false
showTableOfContents: true
---

<div class="lead"><p>SolverForge is a native planning engine for decisions that couple people, vehicles, tasks, machines, capacity, time, and cost. Model the problem in Rust or pure Python; inspect the trade-offs instead of accepting an opaque recommendation.</p></div>

## The decision behind the software

Many business decisions look simple until their dependencies meet. A maintenance planner may know which shutdown windows are least risky, but must still account for qualified technicians, spare-parts arrival, production commitments, safety rules, and overtime. A scheduler may know who is best suited to a shift, but must still satisfy coverage, contracts, rest, skills, and individual preferences.

SolverForge takes those facts, planning variables, hard rules, and competing preferences, then searches for a feasible high-scoring plan. It is built for the gap between **the option that looks best in isolation** and **the option an organization can actually execute**.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Workforce and maintenance scheduling</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Routing and sequencing</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Capacity and resource allocation</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/scale-balanced.svg" alt="" width="16" height="16">Explainable trade-offs</span></div>

## Current product surface

SolverForge is not a Java or JPype wrapper. Its solver, scoring engine, move system, and retained solve lifecycle run natively in Rust. The public surface is deliberately split so that teams can start at the level that fits their work.

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Rust runtime</h3><span class="timeline-badge">Native core</span><p class="timeline-subheader">Concrete planning and incremental scoring</p></header>
    <div class="timeline-item-body"><p>The Rust framework provides declarative constraint streams, scalar and list planning variables, construction heuristics, local search, exact search for small finite spaces, and retained solve jobs with snapshots, telemetry, pause, resume, and cancellation.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>SolverForge CLI</h3><span class="timeline-badge">Application path</span><p class="timeline-subheader">Start a web, API, or command-line planning app</p></header>
    <div class="timeline-item-body"><p><code>solverforge new</code> creates a neutral application shell. Teams then add their own facts, entities, variables, constraints, and sample data as the domain becomes clear instead of beginning from a fixed vertical template.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>SolverForge Python</h3><span class="timeline-badge">Pure Python models</span><p class="timeline-subheader">Python classes, decorators, functions, and lambdas</p></header>
    <div class="timeline-item-body"><p>Python users define planning models and constraint callbacks in Python. A native extension owns solution state in Rust for safe cloning, mutation, snapshots, and execution; users neither write Rust nor send JSON to a fixed remote solver.</p></div>
  </div>
</article></div>

## A business-sized example

Consider a factory scheduling preventative maintenance for several machines next week. A reliability model can rank each possible maintenance window by expected risk. That ranking alone cannot create a plan.

| Domain input | Planning consequence |
| --- | --- |
| Lowest-risk machine windows | Prefer them when possible |
| Qualified technician availability | Never schedule work without the necessary skills |
| Spare-parts delivery | Do not schedule before the parts arrive |
| Production commitments | Avoid or penalize lost output |
| Safety, rest, and overtime rules | Must be respected or explicitly costed |

SolverForge turns those requirements into a schedule: non-negotiable rules exclude impossible plans, while risk, lost output, overtime, and delay become visible trade-offs. The result can explain both *why the chosen slot works* and *why a lower-risk slot was rejected*.

The same structure applies to vehicle routing, staff rostering, job-shop sequencing, appointments, inventory allocation, and any workflow where one local recommendation changes the feasibility of another.

## Authoring a model

In Rust, models use concrete types, macros, and a fluent constraint API. In Python, the same planning idea is expressed with ordinary classes, decorators, functions, and lambdas:

```python
from solverforge import (
    ConstraintFactory,
    HardSoftScore,
    Solver,
    constraint_provider,
    planning_entity,
    planning_solution,
    planning_variable,
)

@planning_entity
class Shift:
    nurse = planning_variable(value_range_provider="nurses", allows_unassigned=True)

@constraint_provider
def constraints(factory: ConstraintFactory):
    return [
        factory.for_each(Shift)
        .filter(lambda shift: shift.nurse is None)
        .penalize(HardSoftScore.ONE_HARD)
        .named("required shift is unassigned")
    ]
```

The important boundary is ownership: Python owns the model vocabulary and constraint callbacks; the native runtime owns safe state transitions, scoring, search, and lifecycle management.

<pre class="not-prose mermaid">flowchart LR
    facts[Business facts and limits] --&gt; model[Rust or Python model]
    model --&gt; rules[Hard rules and soft preferences]
    rules --&gt; solver[Native SolverForge runtime]
    solver --&gt; plan[Feasible plan]
    plan --&gt; explanation[Scores, telemetry, and trade-offs]</pre>

## Why native execution matters

SolverForge keeps its canonical solver and scoring pipeline concrete in Rust, with documented dynamic seams only where host-language and runtime integration require them. This avoids a second, divergent Python solver while preserving Python as a real authoring surface.

For planning teams, that means one decision engine can support fast native execution, a generated local application path, and a Python-first integration path without forcing the business model into a lowest-common-denominator JSON schema.

## Links

<a class="button" href="https://solverforge.org" target="_blank"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16" /> SolverForge</a>

<a class="button" href="https://github.com/SolverForge/solverforge" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Rust runtime</a>

<a class="button" href="https://github.com/SolverForge/solverforge-py" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Python bindings</a>

<a class="button" href="https://github.com/SolverForge/solverforge-cli" target="_blank"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16" /> CLI</a>

<a class="button" href="https://pypi.org/project/solverforge/" target="_blank"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16" /> Python package</a>
