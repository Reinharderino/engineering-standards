# Repository Context: ARCHITECTURE.md, MEMORY.md, and the Registry

Context that lives only in a chat session dies with it. These three files are how a repository
keeps what it learned, in a form the next person — or the next agent, in any IDE — can read.

## Entering a repository

```
1. Does docs/ARCHITECTURE.md exist?  → read it before reading code
2. Does docs/MEMORY.md exist?        → read it before proposing anything
3. Is this repo in the registry?     → if not, add the row (first session only)
4. Neither doc exists?               → offer to bootstrap. Do not create them silently
```

Do not bootstrap a throwaway-tier repo (§2). A one-week spike does not need an architecture
document; saying so is the right answer.

When a doc contradicts the code, **the code wins**. Say which line is wrong and propose the fix in
the same breath — a document nobody trusts is worse than no document, because it costs reading time
and returns misinformation.

## docs/ARCHITECTURE.md

The structure **as it is**, derived from the shipped code — not from the plan, not from intentions.
Written for someone competent who has never seen this repo.

```markdown
# Architecture

## Purpose
One paragraph: what this system does and for whom.

## Tier
Throwaway | Evolving | Core — and why. This sets how much structure is correct here.

## Map
| Module / directory | Responsibility | Depends on |
|---|---|---|

## Boundaries
Where the trust boundaries are (input validation happens here), where the layer boundaries are
(what may import what), what crosses them and in what shape (DTO, event, contract).

## Entry points
How execution starts: CLI commands, HTTP routes, jobs, consumers.

## External dependencies
Databases, queues, third-party APIs, and what breaks when each is unavailable.

## Running and testing
The exact commands. These are the commands used to verify claims (see verification.md).

## Known structural debt
Deliberate shortcuts with their marked ceiling and upgrade path (§2).
```

**Update rule:** a change that alters the structure updates this file **in the same diff** as the
code. Not in a follow-up commit, not in a cleanup ticket. A structural change whose architecture
doc update is deferred is an undocumented change.

## docs/MEMORY.md

Only what the code and the history **cannot** tell you.

```markdown
# Memory

<!-- Newest first. One fact per entry. If the code or git log already says it, it does not go here. -->

## 2026-09-03 — Retries capped at 3 on the payment gateway
The provider rate-limits at 5/min per merchant and returns 200 on a duplicate charge, so a
4th retry risks a double charge that their API will not report. Confirmed with their support,
ticket #4471.
**Applies to:** `payments/gateway.*`

## 2026-08-21 — Rejected: splitting billing into its own service
Tried it, reverted. The invoice and subscription aggregates share a transaction boundary; the
split forced a distributed transaction for the common path. Revisit only if billing needs to
scale independently.
```

**Goes in:** decisions and the *why* behind them · constraints imposed from outside (a vendor's
behavior, a regulation, a hardware limit, another team's timeline) · traps that cost someone hours
· dead ends already tried, with the reason they failed · measured numbers that shaped a decision.

**Never goes in:** what the code states · what `git log` records · what belongs in
ARCHITECTURE.md · session narration ("today we refactored the parser"). Derivable content is
duplication, and duplication goes stale and starts lying.

**Writing rule:** propose the entry, get approval, then write. An entry the user has not seen is an
assertion nobody checked. Delete entries that turn out to be wrong — a wrong memory is worse than
a missing one.

**Sizing rule:** if an entry is still true but no longer relevant to anything in the repo, it goes.
This file is read at the start of every session; every line in it costs attention forever.

## The registry

One row per repository worked on. Location: `$ES_REGISTRY`, default `~/.claude/REPOSITORIES.md` —
deliberately **outside** every repository, so project names and paths never leak into a corporate
repo or a public one.

```markdown
# Repositories

| Path | Purpose | Stack | Tier | Last |
|---|---|---|---|---|
| ~/Proyectos/engineering-standards | Agent engineering baseline, multi-IDE | Markdown, bash | Evolving | 2026-09-03 |
| ~/Proyectos/foo | Invoice reconciliation for the billing team | Python 3.12, Postgres | Core | 2026-08-30 |
```

- **First session in a repo that is not listed:** add the row. That is the whole maintenance burden.
- **Purpose** is one line, written for someone with zero context. "Backend" is not a purpose.
- **Last** is the date of the last session, updated in passing, not tracked religiously.
- The registry is an **index, not a journal.** It never grows a history column, a status column, or
  per-session notes. Those belong in the repository, in `MEMORY.md`.
- A path that no longer exists gets deleted from the registry, not marked dead.
