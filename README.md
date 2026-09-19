# Procedural Narrative Generation Using Storylets and Event Memory

## Overview

This project investigates the use of **event memory** within a **storylet-based procedural narrative system**. The goal is to study whether remembering previously triggered events and player choices can reduce repetition while increasing narrative variability and coherence.

The project was developed as part of a Master's thesis in Engineering Informatics, with a focus on game development.

## Research Question

> **How does event memory influence variability, repetition, and narrative coherence in a storylet-based procedural narrative system?**

## Objectives

The project aims to:

- Implement a modular storylet-based procedural narrative system.
- Extend the system with an event memory mechanism.
- Compare a memory-aware system with a memoryless baseline.
- Measure differences in repetition, variability, and narrative continuity.
- Evaluate the systems through automated simulations.
- Explore player perceptions of memory, variety, and narrative coherence.

## Prototype

The prototype is a choice-driven card game set in a **space colony**.

Each card represents a narrative event and presents the player with two choices. Choices can modify the state of the colony and influence which events become available in the future.

The system uses a relatively small number of global variables to keep the narrative state manageable while allowing meaningful interactions between events.

### Storylets

Each card functions as a storylet containing:

- An identifier
- A name
- A description
- Left and right choices
- A rarity
- Effects associated with each choice
- Availability conditions
- Visibility conditions
- Optional narrative arc information

Storylets are selected dynamically based on the current game state and the selection system.

### Effects

Effects describe the consequences of player choices. They can modify:

- World-state variables
- Narrative flags
- Narrative arcs
- Cooldowns
- Other persistent state information

Example:

```gdscript
{
    "type": "stat",
    "target": "wealth",
    "value": -5
}
```

```gdscript
{
    "type": "flag",
    "target": "angered_church",
    "value": true
}
```

## System Architecture

The prototype separates static narrative content from dynamic game state.

### Main Components

- **Card Resources** — store authored storylet data.
- **Effect Resources** — describe the consequences of choices.
- **Card Database** — stores static card content.
- **Game State** — maintains the current state of a playthrough.
- **Card Selection System** — determines the next storylet.
- **Event Memory** — records relevant previous events and influences future selection.
- **Simulation System** — runs automated playthroughs for experimental evaluation.

### Game State

The dynamic state includes information such as:

```gdscript
var world_state: Dictionary = {}
var memory_flags: Dictionary = {}
var unlocked_arcs: Array = []
var card_cooldowns: Dictionary = {}
```

This allows the system to distinguish between the permanent authored content and the changing state of an individual playthrough.

## Event Memory

The memory system is designed to give the narrative system access to information about previously occurring events.

Rather than treating each storylet selection as an isolated decision, the system can use previous events and their consequences when determining which events should appear next.

Memory can be used to:

- Prevent immediate or short-term repetition.
- Encourage narrative callbacks.
- Support longer narrative arcs.
- Make previous choices relevant to future events.
- Increase perceived continuity between events.

The memory mechanism is intentionally relatively simple so that its effects can be evaluated against a comparable baseline.

## Experimental Conditions

Two versions of the system are evaluated.

### Baseline

The baseline system uses:

- Weighted random storylet selection.
- World-state conditions.
- Storylet availability.
- Cooldowns.
- Authored storylet content.

It does **not** use the event memory mechanism.

### Memory-Aware System

The memory-aware system uses the same underlying content and mechanics while additionally incorporating:

- Event memory.
- Persistent narrative information.
- Narrative arcs.
- Memory-based selection constraints.

Keeping the two systems as similar as possible allows the effect of event memory to be examined more directly.

## Automated Simulation

Automated simulations are used to evaluate system behaviour over many playthroughs.

The current experimental setup uses:

- **100 runs per condition**
- **100 turns per run**
- Random left/right decisions
- Identical authored content between conditions
- Recorded storylet sequences
- Recorded world-state information

The automated player makes random choices so that the comparison focuses primarily on the behaviour of the narrative generation system rather than on differences in human decision-making.

## Metrics

The experimental data can be used to examine several properties of the generated narratives.

### Storylet Diversity

Measures how many distinct storylets are encountered within a run or across multiple runs.

### Repetition

Measures how frequently the same storylets are repeated, particularly within short intervals.

### Sequence Variability

Measures how much generated storylet sequences differ between playthroughs.

### Narrative Arc Activation

Tracks how frequently authored narrative arcs are activated and progressed.

### World-State Evolution

Records changes to the main world-state variables throughout each simulation.

### Narrative Continuity

Examines whether events appear connected through previous events, choices, or persistent consequences.

## Player Evaluation

Automated simulations measure system behaviour, but they cannot fully capture whether players actually perceive the system as varied or coherent.

A player evaluation can therefore complement the simulation by measuring perceptions such as:

- Perceived variety
- Repetition
- Narrative continuity
- Perceived memory
- Meaningfulness of choices
- Lasting consequences
- Interest in replaying the game

A particularly relevant question is:

> **To what extent did the game appear to remember and react to your previous choices?**

The player evaluation is intended to remain short enough that participants do not need to complete extremely long playthroughs.

## Hypotheses

### Null Hypothesis

> **H0:** Event memory has no significant effect on variability, repetition, or narrative coherence in a storylet-based procedural narrative system.

### Alternative Hypothesis

> **H1:** Event memory significantly reduces repetition and improves variability and narrative coherence in a storylet-based procedural narrative system.

## Reproducibility

The project is structured so that the game, narrative data, simulations, and analysis can be maintained separately.

Suggested repository structure:

```text
/
├── Game/
│   ├── Assets/
│   ├── Scenes/
│   ├── Scripts/
│   └── project.godot
│
├── Data/
│   ├── Cards.csv
│   ├── Effects.csv
│   └── ...
│
├── Analysis/
│   ├── notebooks/ 
│
└── README.md
```

## Technology

- **Godot Engine**
- **GDScript**
- **Python**
- **Pandas**
- **scikit-learn**
- **Jupyter Notebook**
- CSV-based narrative data

## Research Contribution

The main contribution of this work is the design and implementation of a **modular, memory-aware storylet architecture**, together with an evaluation methodology for comparing procedural narrative systems with and without event memory.

The project aims to provide practical insight into whether a relatively simple memory mechanism can alter procedural narrative behaviour without requiring substantially more complex narrative authoring.

## Limitations

The current study has several limitations:

- The prototype contains a relatively small pool of authored storylets.
- The memory mechanism is intentionally simple.
- Automated simulations use random player decisions.
- Player evaluation is based on a limited sample.
- Narrative coherence is difficult to capture completely through purely quantitative metrics.
- Results from a single prototype may not generalise to all storylet-based narrative systems.

## Future Work

Potential extensions include:

- Expanding the storylet pool.
- Developing richer event-memory representations.
- Tracking longer-term consequences.
- Investigating different memory durations.
- Comparing alternative storylet-selection strategies.
- Improving automated narrative-coherence metrics.
- Conducting larger-scale player evaluations.
- Investigating AI-assisted storylet generation.
- Exploring AI-assisted visual asset generation.
- Studying how AI-generated content can be integrated while maintaining player acceptance and narrative quality.

## Thesis Context

This project forms the practical component of a Master's thesis investigating procedural plot and narrative generation in digital games.

The broader research explores how structured narrative techniques, particularly storylets, can be combined with memory mechanisms to produce procedural narratives that remain varied and coherent across repeated playthroughs.
