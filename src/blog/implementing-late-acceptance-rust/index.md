---
title: "Implementing Late Acceptance in Rust"
date: 2026-01-02
author: "Vittorio Distefano"
draft: false
description: "A practical guide to implementing the Late Acceptance Hill Climbing metaheuristic in Rust for optimization problems"
tags: ["Rust", "Optimization", "SolverForge"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
How to escape local optima without randomness: a deterministic alternative to Simulated Annealing.
{{< /lead >}}

## The Problem with Hill Climbing

Local search algorithms improve solutions iteratively by evaluating neighboring states and accepting improvements. Pure hill climbing is the simplest form: accept a move only if it makes the solution better.

```rust
fn is_accepted(current_score: i64, move_score: i64) -> bool {
    move_score > current_score  // Only accept improvements
}
```

This works until you hit a local optimum — a solution where all neighbors are worse, but globally better solutions exist elsewhere. Hill climbing gets stuck.

Classical solutions involve randomness:
- **Simulated Annealing**: Accept worse moves with decreasing probability
- **Genetic Algorithms**: Random crossover and mutation

But randomness complicates reproducibility and parameter tuning. What if we could escape local optima *deterministically*?

---

## Late Acceptance Hill Climbing

Late Acceptance, introduced by Edmund Burke and Yuri Bykov in 2008, offers an elegant alternative. Instead of comparing moves to the current score, we compare to the score from **L steps ago**.

The insight: if a move is better than where we were recently, it's probably worth taking—even if it's slightly worse than where we are now.

### The Algorithm

```
1. Initialize a circular buffer of size L with the initial score
2. For each step:
   a. Generate candidate moves
   b. Accept a move if: move_score >= score_history[current_index]
   c. Record the new score in score_history[current_index]
   d. Advance current_index (modulo L)
```

No random number generators. No temperature schedules to tune. Just one parameter: the history size L.

---

## Rust Implementation

Here's an example implementation using Rust's type system for safety:

### The Acceptor Trait

First, define a trait for move acceptance strategies:

```rust
use std::fmt::Debug;

pub trait Acceptor<Score>: Send + Debug {
    /// Returns true if a move resulting in `move_score` should be accepted.
    fn is_accepted(&self, last_step_score: &Score, move_score: &Score) -> bool;

    /// Called when optimization begins.
    fn phase_started(&mut self, initial_score: &Score);

    /// Called after each accepted move.
    fn step_ended(&mut self, step_score: &Score);
}
```

This trait abstraction lets us swap algorithms without changing the search loop. The `Send` bound ensures thread-safety for parallel implementations.

### Late Acceptance Acceptor

```rust
pub struct LateAcceptanceAcceptor<Score> {
    late_acceptance_size: usize,
    score_history: Vec<Option<Score>>,
    current_index: usize,
}

impl<Score> LateAcceptanceAcceptor<Score> {
    pub fn new(late_acceptance_size: usize) -> Self {
        Self {
            late_acceptance_size,
            score_history: (0..late_acceptance_size).map(|_| None).collect(),
            current_index: 0,
        }
    }
}
```

The buffer uses `Option<Score>` because it starts empty—`None` means no history at that position yet.

### Acceptance Logic

The key performance insight is in the API design: **references in the hot path**.

```rust
impl<Score: Clone + PartialOrd> Acceptor<Score> for LateAcceptanceAcceptor<Score> {
    // HOT PATH: called for every candidate move - takes references, no allocation
    fn is_accepted(&self, last_step_score: &Score, move_score: &Score) -> bool {
        // Always accept improving moves
        if move_score > last_step_score {
            return true;
        }

        // Accept if better than or equal to the late score
        if let Some(late_score) = &self.score_history[self.current_index] {
            move_score >= late_score
        } else {
            true  // No history yet
        }
    }

    // COLD PATH: called once when optimization starts
    fn phase_started(&mut self, initial_score: &Score) {
        for slot in &mut self.score_history {
            *slot = Some(initial_score.clone());
        }
        self.current_index = 0;
    }

    // COLD PATH: called once per step (after accepting a move)
    fn step_ended(&mut self, step_score: &Score) {
        self.score_history[self.current_index] = Some(step_score.clone());
        self.current_index = (self.current_index + 1) % self.late_acceptance_size;
    }
}
```

`is_accepted()` is called thousands of times per step—once for every candidate move. It only compares references. The `clone()` calls happen in `step_ended()`, which runs once per step after a move is accepted. This keeps the inner loop allocation-free.

---

## Why It Works

Consider a search trapped at a local optimum with score -100. Pure hill climbing stops. But with Late Acceptance (L=400):

1. **Steps 1-400**: We explore, maybe finding scores like -102, -98, -103...
2. **Step 401**: We compare to the score from step 1
3. If our current -98 is better than the -100 from step 1, we can accept moves that seemed "bad" at step 400

The algorithm naturally oscillates between intensification (when history scores are poor) and diversification (when history scores improve). No manual intervention needed.

### Choosing L

- **Smaller L (50-100)**: More aggressive exploration, faster escape from local optima
- **Larger L (400-1000)**: More conservative, better final solution quality
- **Rule of thumb**: Start with L=400 and adjust based on problem behavior

---

## Integration with a Search Loop

Here's how Late Acceptance integrates into a local search framework:

```rust
pub fn solve<S, M, A>(
    solution: &mut S,
    move_selector: &dyn MoveSelector<S, M>,
    acceptor: &mut A,
    step_limit: u64,
) where
    S: Solution,
    M: Move<S>,
    A: Acceptor<S::Score>,
{
    let mut current_score = solution.calculate_score();
    acceptor.phase_started(&current_score);

    for _ in 0..step_limit {
        let mut best_accepted: Option<(M, S::Score)> = None;

        for candidate_move in move_selector.generate_moves(solution) {
            // Apply move temporarily
            let undo = candidate_move.apply(solution);
            let move_score = solution.calculate_score();

            if acceptor.is_accepted(&current_score, &move_score) {
                // Track best accepted move this step
                if best_accepted.as_ref().map_or(true, |(_, s)| &move_score > s) {
                    best_accepted = Some((candidate_move.clone(), move_score.clone()));
                }
            }

            // Undo the move
            undo.revert(solution);
        }

        // Apply the best accepted move permanently
        if let Some((best_move, score)) = best_accepted {
            best_move.apply(solution);
            current_score = score.clone();
            acceptor.step_ended(&score);
        } else {
            break;  // No accepted moves—we're stuck
        }
    }
}
```

The acceptor is just a strategy plugged into the search. Swap in Simulated Annealing, Tabu Search, or any other acceptance criterion with identical integration.

---

## Comparison: Late Acceptance vs Simulated Annealing

| Aspect | Late Acceptance | Simulated Annealing |
|--------|-----------------|---------------------|
| Parameters | 1 (history size) | 2-3 (temperature, cooling rate, reheat) |
| Randomness | None | Required |
| Reproducibility | Deterministic | Varies across runs |
| Tuning difficulty | Low | Moderate to high |
| Escape power | Good | Excellent (with tuning) |

Late Acceptance shines when you need **reproducible results** or when you want a **simple baseline** before investing in parameter tuning.

---

## Testing

Unit tests to verify the acceptor's behavior at boundaries:

```rust
#[test]
fn test_accepts_improving() {
    let mut acceptor = LateAcceptanceAcceptor::<i64>::new(5);
    acceptor.phase_started(&-10);

    // Improving move: -10 -> -5
    assert!(acceptor.is_accepted(&-10, &-5));
}

#[test]
fn test_accepts_equal_to_late() {
    let mut acceptor = LateAcceptanceAcceptor::<i64>::new(5);
    acceptor.phase_started(&-10);

    // Equal to late score should be accepted
    assert!(acceptor.is_accepted(&-10, &-10));
}

#[test]
fn test_rejects_worse_than_late() {
    let mut acceptor = LateAcceptanceAcceptor::<i64>::new(5);
    acceptor.phase_started(&-10);

    // Worse than both current and late
    assert!(!acceptor.is_accepted(&-10, &-15));
}
```

---

## Conclusion

Late Acceptance Hill Climbing is an underappreciated metaheuristic. It's:
- Simple to implement
- Easy to tune
- Deterministic
- Effective on many problem types

The key to a fast implementation: references in the hot path, cloning *only when persisting to history*. This pattern keeps the inner move-evaluation loop allocation-free while maintaining a clean API.

Next time you reach for Simulated Annealing, consider Late Acceptance first. You might find that one parameter is all you need.

---

## References

{{< keywordList >}}
{{< keyword icon="code" >}} Rust {{< /keyword >}}
{{< keyword icon="star" >}} Metaheuristics {{< /keyword >}}
{{< keyword icon="bolt" >}} Local Search {{< /keyword >}}
{{< /keywordList >}}

---

## Resources

- [Original LAHC Paper (Burke & Bykov)](https://www.sciencedirect.com/science/article/pii/S0377221716305495) — The foundational research paper
