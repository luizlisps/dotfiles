---
name: sync
description: Scout the current project and update its project-level guidance so it matches the real stack, commands, tests, and conventions. Adapted for Claude Code. Use when the user wants to sync, bootstrap, tune, initialize, or refresh project instructions.
---

# Sync

Scout the project and sync its project-level guidance with reality.

Use `CLAUDE.md` as the primary project instruction file. If the project also has `AGENTS.md` or other harness-specific docs, keep them in sync too.

## Usage

- `/sync` -> full sync
- `/sync claude` -> only update `CLAUDE.md`
- `/sync harness` -> only update existing harness-specific docs

## Phase 1: Scout

If useful, launch an Explore subagent. Otherwise scout inline.

Report:

- stack and versions
- test, lint, build, and format commands
- test structure
- naming and error-handling conventions
- existing docs such as `CLAUDE.md`, `README.md`, `CLAUDE.md`, `.claude/*`, and legacy files

## Phase 2: Diff

Compare the scout findings against:

- `CLAUDE.md`
- existing harness-specific docs
- other project docs that describe commands or conventions

Check:

- is `CLAUDE.md` missing or outdated
- do documented commands match reality
- do docs describe the current architecture and conventions

## Phase 3: Propose

Present a sync plan with:

- files to create
- files to update
- files that look stale but should not be auto-deleted

Wait for approval before applying.

## Phase 4: Apply

- show diffs before writing
- preserve custom sections
- never delete existing guidance automatically
- prefer updating shared guidance in `CLAUDE.md` over duplicating the same text in multiple harness folders

## Phase 5: Report

Summarize:

- created
- updated
- flagged for manual review
