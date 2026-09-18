# Procedural Narrative Generation Using Storylets and Event Memory

This repository contains the implementation, experimental data, and analysis developed as part of my Master's thesis on procedural narrative generation in digital games.

The project investigates the use of **storylets** as a modular approach to procedural narrative generation and explores whether introducing an **event memory mechanism** can influence narrative variability, repetition, and coherence.

The project consists of a playable Godot prototype, an automated simulation system, experimental datasets, and data analysis used to compare memory-aware and memoryless versions of the system.

---

## Research Question

> How does the introduction of event memory affect variability, repetition, and narrative coherence in a storylet-based procedural narrative system?

The research compares two configurations of the same narrative system:

- **Baseline:** storylets are selected without event memory.
- **Memory:** storylet selection incorporates information about previous events and player actions.

The purpose is not to determine whether one system is universally "better", but to measure how the introduction of memory changes system behaviour and player perception.

---

# Project Overview

The prototype is a narrative card game set in a space colony.

Each card represents a **storylet** containing:

- Narrative description
- Two player choices
- One or more effects
- Rarity
- Narrative arc information
- Availability conditions
- Cooldowns
- Other metadata used by the procedural selection system

Player choices modify the game state and can influence which storylets become available in the future.

The main systems are:

```text
                    ┌───────────────┐
                    │  Card Database │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │   GameState   │
                    └───────┬───────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        Card Selection   Effects       Memory
             │              │              │
             └──────────────┼──────────────┘
                            ▼
                       World State
                            │
                            ▼
                       Next Storylet
