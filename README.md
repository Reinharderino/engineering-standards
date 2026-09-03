# engineering-standards

One engineering baseline, two delivery formats, no plugin installs.

Built for environments where you cannot drop third-party Claude Code plugins into the machine:
the whole thing is plain Markdown in a repo, copied in by a script.

## What's inside

**`skills/engineering-standards/SKILL.md`** — the always-loaded baseline:

- **Three iron laws** — root cause before fix · failing test before code · fresh evidence before
  any completion claim.
- **Right-sizing gate** — Throwaway / Evolving / Core tiers decide how much structure is *correct*.
  The floor (validation, error handling, security, accessibility, clarity) is tier-independent.
- **The YAGNI ladder** — seven rungs, stop at the first that holds. No abstraction without a
  second caller.
- Clean code · SOLID · design-decision protocol · error handling · security baseline ·
  communication · git discipline · approval gates.

**`skills/engineering-standards/references/`** — loaded on demand, one per situation:

| File | Load when |
|---|---|
| `debugging.md` | Any bug or test failure, before proposing a fix. 4 phases + the 3-fix rule |
| `tdd.md` | Before writing implementation code. RED → GREEN → REFACTOR, verify each |
| `verification.md` | About to claim done/fixed/passing. The gate + claim→evidence table |
| `planning.md` | Spike / Bounded / Architectural paths, written plans, executing them |
| `code-review.md` | Requesting a review, and receiving one without performative agreement |
| `delegation.md` | Subagents, parallel dispatch, worktrees, verifying agent output |
| `architecture.md` | Core-tier design: layers, dependency rule, modular monolith |

## Install

```bash
./scripts/install.sh                 # user-wide Claude Code skill (~/.claude/skills)
./scripts/install.sh /path/to/repo   # into a project: .cursor/rules/ + .claude/skills/
```

## Cursor

Cursor has no on-demand file loading, so `scripts/build.sh` flattens the source into two rules:

- `.cursor/rules/engineering-standards.mdc` — `alwaysApply: true`, the baseline.
- `.cursor/rules/engineering-workflows.mdc` — `alwaysApply: false`, agent-requested, all references.

**Never edit the `.mdc` files.** They are generated. Edit `skills/engineering-standards/`, then:

```bash
./scripts/build.sh
```

`build.sh` fails if the iron laws or the reference bodies don't survive generation — that's the
test.

## Provenance

Distilled from three sources, all MIT:

- [superpowers](https://github.com/obra/superpowers) (Jesse Vincent) — the iron-law framing, TDD
  cycle, systematic debugging phases, verification gate, brainstorming paths, review reception.
- [ponytail](https://github.com/dietrichgebert/ponytail) (Dietrich Gebert) — the YAGNI ladder,
  "no abstraction without a second caller", marked deliberate shortcuts.
- The author's own `global-engineering-guidelines` — clean code, SOLID, clean architecture,
  right-sizing tiers, git discipline, approval gates.

The persona and tone layers of both plugins were deliberately left out. This is a standard, not
a character.
