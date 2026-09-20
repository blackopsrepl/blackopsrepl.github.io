---
title: "Implementing EASA Flight Time Limitations in Constraint-Based Crew Scheduling"
date: 2025-12-13
author: "Vittorio Distefano"
draft: false
description: "How I implemented aviation safety regulations as optimization constraints using Timefold"
tags: ["Java", "Optimization", "Timefold", "Constraint Programming"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
Translating European aviation safety regulations into constraint programming logic for automatic flight crew scheduling.
{{< /lead >}}

## The Challenge

Flight crew scheduling isn't just about filling slots—it's about ensuring pilots and cabin crew get adequate rest between duties. The European Union Aviation Safety Agency (EASA) mandates specific Flight Time Limitations (FTL) that protect crew members from fatigue-related incidents.

I recently extended a flight crew scheduling optimizer to enforce these regulations automatically. The solver assigns crew members to flights while respecting both operational requirements and safety constraints.

---

## What are EASA FTL Regulations?

EASA FTL rules define minimum rest periods based on several factors:

- **Location**: Rest requirements differ when crew is at their home base vs. away
- **Preceding duty duration**: Longer duties require longer subsequent rest
- **Flight type**: Long haul operations (10+ hours) require extended recovery
- **Cumulative fatigue**: Crew need periodic extended rest within any 7-day window

These rules exist because fatigue compounds. A pilot who flew 8 hours yesterday needs more rest than one who flew 4 hours.

---

## Implementation: The Constraints

### Minimum Rest at Home Base

When a crew member's next duty departs from their home airport, they need rest equal to the greater of:
- The duration of their preceding duty, OR
- 12 hours minimum

```java
public Constraint minimumRestAtHomeBase(ConstraintFactory constraintFactory) {
    return constraintFactory.forEach(FlightAssignment.class)
        .join(FlightAssignment.class,
            equal(FlightAssignment::getEmployee),
            lessThan(FlightAssignment::getDutyEndDateTime,
                     FlightAssignment::getDutyStartDateTime))
        // Ensure consecutive assignments
        .ifNotExists(FlightAssignment.class, /* ... */)
        // Apply only when departing from home base
        .filter((assignment1, assignment2) ->
            assignment2.isAtHomeBase(assignment2.getDepartureAirport()))
        // Calculate violation
        .penalizeLong(HardSoftLongScore.ofHard(100),
            (assignment1, assignment2) -> {
                double precedingDutyHours = assignment1.getFlight()
                    .getFlightDutyPeriodHours();
                double requiredRestHours = Math.max(precedingDutyHours, 12.0);
                // ... calculate violation in minutes
            })
        .asConstraint("Minimum rest at home base");
}
```

The constraint streams API lets me express this declaratively: find consecutive assignments for the same employee, check if it's a home base departure, then penalize any shortfall in rest.

### Minimum Rest Away from Home

Away from home base, the formula changes:
- Base requirement: `max(preceding_duty_hours, 10 hours)`
- Plus travel time adjustment when ground transfer exceeds 30 minutes

This accounts for the additional fatigue of commuting to/from accommodation at unfamiliar airports.

### Extended Recovery Rest Period (ERRP)

The most complex constraint. Within any rolling 168-hour (7-day) window, crew must have at least one 36-hour rest period.

```java
public Constraint extendedRecoveryRestPeriod(ConstraintFactory constraintFactory) {
    return constraintFactory.forEach(FlightAssignment.class)
        .groupBy(FlightAssignment::getEmployee, ConstraintCollectors.toList())
        .penalizeLong(HardSoftLongScore.ofHard(1000),
            (employee, assignments) -> {
                List<FlightAssignment> sorted = new ArrayList<>(assignments);
                sorted.sort(Comparator.comparing(
                    FlightAssignment::getDutyStartDateTime));
                return countErrrpViolations(sorted);
            })
        .asConstraint("Extended recovery rest period (ERRP)");
}
```

I group all assignments by employee, sort chronologically, then scan for 168-hour windows lacking a qualifying 36+ hour rest. Each violation gets a heavy penalty.

### Long Haul Rest Requirements

Long haul flights (10+ hours) require 48 hours of rest afterward. This applies to:
- Single flights over 10 hours
- Consecutive flights that together exceed 10 hours (e.g., two 6-hour legs with minimal layover)

The consecutive case required careful handling—I needed to join three assignments (A, B, C) and check if A+B form a long haul sequence, then enforce rest between B and C.

---

## Supporting Infrastructure

### Flight Duty Period Calculation

FDP isn't just flight time—it includes:
- 45 minutes reporting time before departure
- Actual flight duration
- 20 minutes post-flight duties

```java
public double getFlightDutyPeriodHours() {
    long flightMinutes = Duration.between(
        departureUTCDateTime,
        arrivalUTCDateTime
    ).toMinutes();
    long fdpMinutes = flightMinutes + 65; // 45 + 20
    return fdpMinutes / 60.0;
}
```

### Taxi Time via Haversine Formula

For travel time adjustments between airports (when crew transfers between terminals or nearby airports), I calculate great-circle distance:

```java
private double calculateHaversineDistance(
        double lat1, double lon1, double lat2, double lon2) {
    final double EARTH_RADIUS_KM = 6371.0;

    double lat1Rad = Math.toRadians(lat1);
    double lat2Rad = Math.toRadians(lat2);
    double dLat = lat2Rad - lat1Rad;
    double dLon = Math.toRadians(lon2) - Math.toRadians(lon1);

    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
        + Math.cos(lat1Rad) * Math.cos(lat2Rad)
        * Math.sin(dLon / 2) * Math.sin(dLon / 2);

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return EARTH_RADIUS_KM * c;
}
```

This distance converts to estimated ground travel time, which then affects rest requirements.

---

## Testing Strategy

Each constraint has dedicated unit tests using Timefold's `ConstraintVerifier`:

```java
@Test
void minimumRestAtHomeBase_sufficientRest_noPenalty() {
    // 8-hour flight, followed by 12 hours rest
    // Should pass: max(8, 12) = 12, and we have 12 hours
    constraintVerifier.verifyThat(
        FlightCrewSchedulingConstraintProvider::minimumRestAtHomeBase)
        .given(assignment1, assignment2)
        .penalizesBy(0);
}

@Test
void minimumRestAtHomeBase_insufficientRest_penalizes() {
    // 14-hour duty, followed by only 10 hours rest
    // Should fail: max(14, 12) = 14, but only 10 provided
    constraintVerifier.verifyThat(
        FlightCrewSchedulingConstraintProvider::minimumRestAtHomeBase)
        .given(assignment1, assignment2)
        .penalizesBy(240); // 4 hours * 60 minutes
}
```

I wrote over 800 lines of test code covering:
- Boundary conditions (exactly 12 hours, exactly 36 hours)
- Location variations (home vs. away)
- Long haul scenarios (standalone and consecutive)
- ERRP sliding window edge cases

---

## Results

The solver now produces schedules that are compliant by construction. Airlines can:

1. Define their crew roster and flight schedule
2. Let the optimizer assign crew to flights
3. Trust that every assignment respects EASA FTL regulations

Hard constraints ensure compliance is non-negotiable—the solver will never produce an illegal schedule. Soft constraints then optimize for preferences like minimizing deadhead flights or balancing workload.

---

## Tech Stack

{{< keywordList >}}
{{< keyword icon="code" >}} Java 21 {{< /keyword >}}
{{< keyword icon="code" >}} Timefold Solver {{< /keyword >}}
{{< keyword icon="server" >}} Quarkus {{< /keyword >}}
{{< keyword icon="check" >}} JUnit 5 {{< /keyword >}}
{{< /keywordList >}}

---

## Links

{{< button href="https://huggingface.co/spaces/blackopsrepl/flight-crew-scheduling-java" target="_blank" >}}
{{< icon "wand-magic-sparkles" >}} Live Demo
{{< /button >}}

{{< button href="https://github.com/SolverForge/solverforge-quickstarts/tree/stable/java/flight-crew-scheduling" target="_blank" >}}
{{< icon "github" >}} Source Code
{{< /button >}}

---

## Resources

- [EASA FTL Regulations](https://www.easa.europa.eu/en/domains/air-operations/air-ops-flight-time-limitations) — Official documentation
- [Source Code](https://github.com/SolverForge/solverforge-quickstarts/tree/stable/java/flight-crew-scheduling) — Java implementation
