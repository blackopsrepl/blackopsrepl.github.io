---
title: "SolverForge"
date: 2025-12-07
draft: false
description: "A native Rust planning engine with first-class Rust and Python modeling surfaces"
tags: ["Python", "Rust", "Optimization", "Constraint Programming", "SolverForge"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
SolverForge is a native planning engine for decisions that couple people, vehicles, tasks, machines, capacity, time, and cost. Model the problem in Rust or pure Python; inspect the trade-offs instead of accepting an opaque recommendation.
{{< /lead >}}

## The decision behind the software

Many business decisions look simple until their dependencies meet. A maintenance planner may know which shutdown windows are least risky, but must still account for qualified technicians, spare-parts arrival, production commitments, safety rules, and overtime. A scheduler may know who is best suited to a shift, but must still satisfy coverage, contracts, rest, skills, and individual preferences.

SolverForge takes those facts, planning variables, hard rules, and competing preferences, then searches for a feasible high-scoring plan. It is built for the gap between **the option that looks best in isolation** and **the option an organization can actually execute**.

{{< keywordList >}}
{{< keyword icon="calendar" >}} Workforce and maintenance scheduling {{< /keyword >}}
{{< keyword icon="truck" >}} Routing and sequencing {{< /keyword >}}
{{< keyword icon="cube" >}} Capacity and resource allocation {{< /keyword >}}
{{< keyword icon="scale-balanced" >}} Explainable trade-offs {{< /keyword >}}
{{< /keywordList >}}

## Current product surface

SolverForge is not a Java or JPype wrapper. Its solver, scoring engine, move system, and retained solve lifecycle run natively in Rust. The public surface is deliberately split so that teams can start at the level that fits their work.

{{< timeline >}}

{{< timelineItem icon="code" header="Rust runtime" badge="Native core" subheader="Concrete planning and incremental scoring" >}}
The Rust framework provides declarative constraint streams, scalar and list planning variables, construction heuristics, local search, exact search for small finite spaces, and retained solve jobs with snapshots, telemetry, pause, resume, and cancellation.
{{< /timelineItem >}}

{{< timelineItem icon="code" header="SolverForge CLI" badge="Application path" subheader="Start a web, API, or command-line planning app" >}}
`solverforge new` creates a neutral application shell. Teams then add their own facts, entities, variables, constraints, and sample data as the domain becomes clear instead of beginning from a fixed vertical template.
{{< /timelineItem >}}

{{< timelineItem icon="code" header="SolverForge Python" badge="Pure Python models" subheader="Python classes, decorators, functions, and lambdas" >}}
Python users define planning models and constraint callbacks in Python. A native extension owns solution state in Rust for safe cloning, mutation, snapshots, and execution; users neither write Rust nor send JSON to a fixed remote solver.
{{< /timelineItem >}}

{{< /timeline >}}

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

{{< mermaid >}}
flowchart LR
    facts[Business facts and limits] --> model[Rust or Python model]
    model --> rules[Hard rules and soft preferences]
    rules --> solver[Native SolverForge runtime]
    solver --> plan[Feasible plan]
    plan --> explanation[Scores, telemetry, and trade-offs]
{{< /mermaid >}}

## Why native execution matters

SolverForge keeps its canonical solver and scoring pipeline concrete in Rust, with documented dynamic seams only where host-language and runtime integration require them. This avoids a second, divergent Python solver while preserving Python as a real authoring surface.

For planning teams, that means one decision engine can support fast native execution, a generated local application path, and a Python-first integration path without forcing the business model into a lowest-common-denominator JSON schema.

## Links

{{< button href="https://solverforge.org" target="_blank" >}}
{{< icon "globe" >}} SolverForge
{{< /button >}}

{{< button href="https://github.com/SolverForge/solverforge" target="_blank" >}}
{{< icon "github" >}} Rust runtime
{{< /button >}}

{{< button href="https://github.com/SolverForge/solverforge-py" target="_blank" >}}
{{< icon "github" >}} Python bindings
{{< /button >}}

{{< button href="https://github.com/SolverForge/solverforge-cli" target="_blank" >}}
{{< icon "code" >}} CLI
{{< /button >}}

{{< button href="https://pypi.org/project/solverforge/" target="_blank" >}}
{{< icon "code" >}} Python package
{{< /button >}}
